-- |
module Macroscope.Main (runMacroscope, getStream, getCrawlers, Clients (..)) where

import Control.Exception.Safe (tryAny)
import qualified Data.Text as T
import Gerrit (GerritClient)
import Lentille
import Lentille.Bugzilla (BugzillaSession, MonadBZ, getApikey, getBZData, getBugzillaSession)
import Lentille.Gerrit (MonadGerrit (..))
import qualified Lentille.Gerrit as GerritCrawler (GerritEnv, getChangesStream, getGerritEnv, getProjectsStream)
import Lentille.GitHub.Issues (streamLinkedIssue)
import Lentille.GitLab.Group (streamGroupProjects)
import Lentille.GitLab.MergeRequests (streamMergeRequests)
import Lentille.GraphQL
import Macroscope.Worker (DocumentStream (..), runStream)
import qualified Monocle.Api.Config as Config
import Monocle.Client
import Monocle.Prelude

data CrawlerInfo = CrawlerInfo
  { cName :: Text,
    cKey :: Text,
    cCrawler :: Config.Crawler,
    cIdents :: [Config.Ident]
  }
  deriving (Eq, Show)

-- | Utility function to create a flat list of crawler from the whole configuration
getCrawlers :: [Config.Index] -> [CrawlerInfo]
getCrawlers xs = do
  Config.Index {..} <- xs
  cCrawler <- crawlers
  let cKey = fromMaybe (error "unknown crawler key") crawlers_api_key
      cIdents = fromMaybe [] idents
      cName = name
  pure $ CrawlerInfo {..}

crawlerName :: Config.Crawler -> Text
crawlerName Config.Crawler {..} = name

-- | 'run' is the entrypoint of the macroscope process
-- withClient "http://localhost:8080" Nothing $ \client -> runMacroscope True "/home/user/git/github.com/change-metrics/monocle/etc/config.yaml" 30 client
runMacroscope :: Bool -> FilePath -> Word32 -> MonocleClient -> IO ()
runMacroscope verbose confPath interval client = do
  res <- runLentilleM $ runMacroscope' verbose confPath interval client
  case res of
    Left e -> error $ "Macroscope failed: " <> show e
    Right x -> pure x

type MonadMacro m = (MonadCatch m, MonadGerrit m, MonadBZ m, LentilleMonad m, MonadError LentilleError m)

-- | 'Clients' is a store for all the remote clients, indexed using their url/token
data Clients = Clients
  { clientsGerrit :: Map (Text, Maybe (Text, Secret)) GerritClient,
    clientsBugzilla :: Map (Text, Secret) BugzillaSession,
    clientsGraph :: Map (Text, Secret) GraphClient
  }

instance From () Clients where
  from _ = Clients mempty mempty mempty

-- | Boilerplate function to retrieve a client from the store
getClientGerrit :: MonadGerrit m => Text -> Maybe (Text, Secret) -> StateT Clients m GerritClient
getClientGerrit url auth = do
  clients <- gets clientsGerrit
  (client, newClients) <- mapMutate clients (url, auth) $ lift $ getGerritClient url auth
  modify $ \s -> s {clientsGerrit = newClients}
  pure client

-- | Boilerplate function to retrieve a client from the store
getClientBZ :: MonadBZ m => Text -> Secret -> StateT Clients m BugzillaSession
getClientBZ url token = do
  clients <- gets clientsBugzilla
  (client, newClients) <- mapMutate clients (url, token) $ lift $ getBugzillaSession url $ Just $ getApikey (unSecret token)
  modify $ \s -> s {clientsBugzilla = newClients}
  pure client

-- | Boilerplate function to retrieve a client from the store
getClientGraphQL :: MonadGraphQL m => Text -> Secret -> StateT Clients m GraphClient
getClientGraphQL url token = do
  clients <- gets clientsGraph
  (client, newClients) <- mapMutate clients (url, token) $ lift $ newGraphClient url token
  modify $ \s -> s {clientsGraph = newClients}
  pure client

runMacroscope' :: MonadMacro m => Bool -> FilePath -> Word32 -> MonocleClient -> m ()
runMacroscope' verbose confPath interval client = do
  mLog $ Log Macroscope LogMacroStart
  config <- Config.mReloadConfig confPath
  loop config (from ())
  where
    loop config clients = do
      -- Reload config
      conf <- config

      -- Flatten each crawler from all workspaces
      let crawlerInfos = getCrawlers conf

      -- Create the streams and update the client store
      (streams, newClients) <- runStateT (traverse getStream crawlerInfos) clients

      -- Crawl each index
      traverse_ safeCrawl $ zip crawlerInfos streams

      -- Pause
      mLog $ Log Macroscope $ LogMacroPause interval_sec
      mThreadDelay interval_usec

      -- Loop again
      loop config newClients

    interval_usec = fromInteger . toInteger $ interval * 1_000_000
    interval_sec :: Float
    interval_sec = fromIntegral interval_usec / 1_000_000

    safeCrawl :: MonadMacro m => (CrawlerInfo, [DocumentStream m]) -> m ()
    safeCrawl crawler = do
      catched <- tryAny $ crawl crawler
      case catched of
        Right comp -> pure comp
        Left exc ->
          let (CrawlerInfo index _ Config.Crawler {..} _, _) = crawler
           in mLog $ Log Macroscope $ LogMacroSkipCrawler (LogCrawlerContext index name) (show exc)

    crawl :: MonadMacro m => (CrawlerInfo, [DocumentStream m]) -> m ()
    crawl (CrawlerInfo index key crawler _, docStreams) = do
      now <- toMonocleTime <$> mGetCurrentTime
      when verbose (mLog $ Log Macroscope $ LogMacroStartCrawler $ LogCrawlerContext index (crawlerName crawler))

      let runner = runStream client now (toLazy key) (toLazy index) (toLazy $ crawlerName crawler)

      -- TODO: handle exceptions
      traverse_ runner docStreams

-- 'getStream' converts the crawler configuration into a stream
getStream :: MonadMacro m => CrawlerInfo -> StateT Clients m [DocumentStream m]
getStream (CrawlerInfo _ _ crawler idents) = getStream'
  where
    getStream' =
      -- Create document streams
      case Config.provider crawler of
        Config.GitlabProvider Config.Gitlab {..} -> do
          token <- lift $ Config.mGetSecret "GITLAB_TOKEN" gitlab_token
          glClient <-
            getClientGraphQL
              (fromMaybe "https://gitlab.com/api/graphql" gitlab_url)
              token
          pure $
            [glOrgCrawler glClient | isNothing gitlab_repositories]
              -- Then we always index the projects
              <> [glMRCrawler glClient getIdentByAliasCB]
        Config.GerritProvider Config.Gerrit {..} -> do
          auth <- lift $ case gerrit_login of
            Just login -> do
              passwd <- Config.mGetSecret "GERRIT_PASSWORD" gerrit_password
              pure $ Just (login, passwd)
            Nothing -> pure Nothing
          gClient <- getClientGerrit gerrit_url auth
          let gerritEnv = GerritCrawler.getGerritEnv gClient gerrit_prefix $ Just getIdentByAliasCB
          pure $
            [gerritREProjectsCrawler gerritEnv | maybe False (not . null . gerritRegexProjects) gerrit_repositories]
              <> [gerritChangesCrawler gerritEnv | isJust gerrit_repositories]
        Config.BugzillaProvider Config.Bugzilla {..} -> do
          bzToken <- lift $ Config.mGetSecret "BUGZILLA_TOKEN" bugzilla_token
          bzClient <- getClientBZ bugzilla_url bzToken
          pure [bzCrawler bzClient]
        Config.GithubProvider ghCrawler -> do
          let Config.Github _ _ github_token github_url = ghCrawler
          ghToken <- lift $ Config.mGetSecret "GITHUB_TOKEN" github_token
          ghClient <- getClientGraphQL (fromMaybe "https://api.github.com/graphql" github_url) ghToken
          pure [ghIssuesCrawler ghClient]
        Config.GithubApplicationProvider _ -> error "Not (yet) implemented"
        Config.TaskDataProvider -> pure [] -- This is a generic crawler, not managed by the macroscope
    getIdentByAliasCB :: Text -> Maybe Text
    getIdentByAliasCB = flip Config.getIdentByAliasFromIdents idents

    glMRCrawler :: MonadGraphQLE m => GraphClient -> (Text -> Maybe Text) -> DocumentStream m
    glMRCrawler glClient cb = Changes $ streamMergeRequests glClient cb

    glOrgCrawler :: MonadGraphQLE m => GraphClient -> DocumentStream m
    glOrgCrawler glClient = Projects $ streamGroupProjects glClient

    bzCrawler :: MonadBZ m => BugzillaSession -> DocumentStream m
    bzCrawler bzSession = TaskDatas $ getBZData bzSession

    ghIssuesCrawler :: MonadGraphQLE m => GraphClient -> DocumentStream m
    ghIssuesCrawler ghClient = TaskDatas $ streamLinkedIssue ghClient

    gerritRegexProjects :: [Text] -> [Text]
    gerritRegexProjects projects = filter (T.isPrefixOf "^") projects

    gerritREProjectsCrawler :: MonadGerrit m => GerritCrawler.GerritEnv -> DocumentStream m
    gerritREProjectsCrawler gerritEnv = Projects $ GerritCrawler.getProjectsStream gerritEnv

    gerritChangesCrawler :: MonadGerrit m => GerritCrawler.GerritEnv -> DocumentStream m
    gerritChangesCrawler gerritEnv = Changes $ GerritCrawler.getChangesStream gerritEnv
