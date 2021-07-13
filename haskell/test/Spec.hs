module Main (main) where

import qualified Data.Aeson.Encode.Pretty as Aeson
import Google.Protobuf.Timestamp
import Monocle.Api.Client
import qualified Monocle.Api.Config as Config
import Monocle.Mock
import Monocle.Prelude
import qualified Monocle.Search.Lexer as L
import qualified Monocle.Search.Parser as P
import qualified Monocle.Search.Query as Q
import qualified Monocle.Search.Syntax as S
import Monocle.TaskData
import Test.Tasty
import Test.Tasty.HUnit

main :: IO ()
main = defaultMain (testGroup "Tests" [monocleSearchLanguage, monocleWebApiTests, monocleConfig])

monocleSearchLanguage :: TestTree
monocleSearchLanguage =
  testGroup
    "Monocle.Search"
    [ testCase
        "Lexer basic"
        ( lexMatch "state:open" [L.Literal "state", L.Equal, L.Literal "open"]
        ),
      testCase
        "Parser basic"
        (parseMatch "state:open" (S.EqExpr "state" "open")),
      testCase
        "Lexer paren"
        ( lexMatch
            "(a>42 or a = 0) and b: d"
            [ L.OpenParenthesis,
              L.Literal "a",
              L.Greater,
              L.Literal "42",
              L.Or,
              L.Literal "a",
              L.Equal,
              L.Literal "0",
              L.CloseParenthesis,
              L.And,
              L.Literal "b",
              L.Equal,
              L.Literal "d"
            ]
        ),
      testCase
        "Lexer quoted"
        (lexMatch "field:\"A value\"" [L.Literal "field", L.Equal, L.Literal "A value"]),
      testCase
        "Lexer unicode"
        (lexMatch "!field:λr🌈bow" [L.Not, L.Literal "field", L.Equal, L.Literal "λr🌈bow"]),
      testCase
        "Lexer quoted unicode"
        (lexMatch "\"Zuul ▲ user\"" [L.Literal "Zuul ▲ user"]),
      testCase
        "Lexer does not escape"
        (lexMatch "\"test\\\"" [L.Literal "test\\"]),
      testCase
        "Parser paren"
        ( parseMatch
            "(a>42 or a:0) and b:d"
            ( (S.AndExpr (S.OrExpr (S.GtExpr "a" "42") (S.EqExpr "a" "0")) (S.EqExpr "b" "d"))
            )
        ),
      testCase
        "Parser aliases"
        ( parseMatch'
            [("sprint42", S.GtExpr "date" "2021-07-01")]
            "status:open sprint42"
            ( (S.AndExpr (S.EqExpr "status" "open")) (S.GtExpr "date" "2021-07-01")
            )
        ),
      testCase
        "Parser implicit and"
        ( parseMatch
            "state:open author:foo"
            ( (S.AndExpr (S.EqExpr "state" "open") (S.EqExpr "author" "foo"))
            )
        ),
      testCase
        "Query date"
        ( queryMatch
            "updated_at>2021-05-27"
            "{\"range\":{\"updated_at\":{\"boost\":1,\"gt\":\"2021-05-27T00:00:00Z\"}}}"
        ),
      testCase
        "Query number"
        ( queryMatch
            "score>200"
            "{\"range\":{\"tasks_data.score\":{\"boost\":1,\"gt\":200}}}"
        ),
      testCase
        "Query boolean"
        ( queryMatch
            "not state:self_merged"
            "{\"bool\":{\"must_not\":[{\"term\":{\"self_merged\":{\"value\":\"true\"}}}]}}"
        ),
      testCase
        "Query regex"
        ( queryMatch
            "repo_regex:openstack/.*nova.*"
            "{\"regexp\":{\"repository_fullname\":{\"flags\":\"ALL\",\"value\":\"openstack/.*nova.*\"}}}"
        ),
      testCase
        "Query state"
        ( queryMatch
            "state: abandoned"
            "{\"term\":{\"state\":{\"value\":\"CLOSED\"}}}"
        ),
      testCase
        "Query date"
        ( queryMatch
            "updated_at > 2021 and updated_at < 2021-05"
            "{\"bool\":{\"must\":[{\"range\":{\"updated_at\":{\"boost\":1,\"gt\":\"2021-01-01T00:00:00Z\"}}},{\"range\":{\"updated_at\":{\"boost\":1,\"lt\":\"2021-05-01T00:00:00Z\"}}}]}}"
        ),
      testCase
        "Query relative date"
        ( queryMatch
            "updated_at > now-3weeks"
            "{\"range\":{\"updated_at\":{\"boost\":1,\"gt\":\"2021-05-10T00:00:00Z\"}}}"
        ),
      testCase
        "Query from field"
        ( queryMatch
            "from:now-3weeks"
            "{\"range\":{\"created_at\":{\"boost\":1,\"gt\":\"2021-05-10T00:00:00Z\"}}}"
        ),
      testCase
        "Query from to field"
        ( queryMatch
            "from:now-3weeks to:now"
            "{\"bool\":{\"must\":[{\"range\":{\"created_at\":{\"boost\":1,\"gt\":\"2021-05-10T00:00:00Z\"}}},{\"range\":{\"created_at\":{\"boost\":1,\"lt\":\"2021-05-31T00:00:00Z\"}}}]}}"
        ),
      testCase
        "Query project"
        ( queryMatch
            "project:zuul"
            "{\"bool\":{\"must\":[{\"regexp\":{\"repository_fullname\":{\"flags\":\"ALL\",\"value\":\"zuul/.*\"}}},{\"regexp\":{\"target_branch\":{\"flags\":\"ALL\",\"value\":\"master\"}}}]}}"
        ),
      testCase
        "Query default bound"
        (queryMatchBound "state:open" (threeWeek, now)),
      testCase
        "Query lower bound"
        (queryMatchBound "updated_at>2021-01-01" (d "2021-01-01", now)),
      testCase
        "Query max bound"
        (queryMatchBound "updated_at<2021-01-01" (d "2020-12-11", d "2021-01-01")),
      testCase
        "Query both bounds"
        (queryMatchBound "created_at<2020-08-01 and updated_at>2020-06-01" (d "2020-06-01", d "2020-08-01")),
      testCase
        "Query silly bounds"
        (queryMatchBound "created_at<2020-01-01 and updated_at>2021-01-01" (d "2021-01-01", d "2020-01-01")),
      testCase
        "Query multi bounds"
        ( queryMatchBound
            "created_at>2000 and created_at>2001 and created_at<2010 and created_at<2011"
            (d "2001-01-01", d "2010-01-01")
        )
    ]
  where
    d :: String -> UTCTime
    d date = fromMaybe (error "nop") (readMaybe $ date <> " 00:00:00 Z")
    threeWeek = fromMaybe (error "nop") (readMaybe "2021-05-10 00:00:00 Z")
    now = fromMaybe (error "nop") (readMaybe "2021-05-31 00:00:00 Z")
    lexMatch code tokens = assertEqual "match" (Right tokens) (fmap L.token <$> L.lex code)
    parseMatch = parseMatch' []
    parseMatch' aliases code expr =
      assertEqual "match" (Right (Just expr)) (P.parse aliases code)
    queryDoMatch = queryDoMatch' []
    queryDoMatch' aliases field code query =
      assertEqual
        "match"
        (Right query)
        (P.parse aliases code >>= Q.queryWithMods now mempty (Just testTenant) >>= pure . field)
    encodePretty =
      Aeson.encodePretty'
        ( Aeson.defConfig {Aeson.confIndent = Aeson.Spaces 0, Aeson.confCompare = compare @Text}
        )
    queryMatch = queryDoMatch' [] (encodePretty . Q.queryBH)
    queryMatchBound = queryDoMatch Q.queryBounds
    testTenant =
      Config.Index
        { Config.index = "test",
          Config.projects = (Just [testProjects]),
          Config.search_aliases =
            ( Just
                [ let name = "sprint42"
                      alias = "from:2021-01-01 to:2021-01-21"
                   in Config.SearchAlias {..}
                ]
            ),
          Config.crawlers = [],
          Config.crawlers_api_key = "",
          Config.idents = Nothing
        }
    testProjects =
      let br = Just "master"
          fr = Just "tests/.*"
          rr = Just "zuul/.*"
       in Config.Project br fr "zuul" rr

monocleWebApiTests :: TestTree
monocleWebApiTests =
  testGroup
    "Monocle.WebApi"
    [ _taskDataGetLastUpdated
    ]
  where
    _taskDataGetLastUpdated =
      testCase
        "taskDataGetLastUpdated"
        ( test
            taskDataGetLastUpdated
            taskDataGetLastUpdatedInput
            taskDataGetLastUpdatedOutput
        )
    taskDataGetLastUpdatedInput = TaskDataGetLastUpdatedRequest "test" "test"
    taskDataGetLastUpdatedOutput =
      TaskDataGetLastUpdatedResponse
        { taskDataGetLastUpdatedResponseResult =
            Just
              ( TaskDataGetLastUpdatedResponseResultTimestamp
                  (Timestamp {timestampSeconds = 1609459200, timestampNanos = 0})
              )
        }

    test api input output = withMockClient withClient $ \client -> do
      resp <- api client input
      assertEqual "Response differ: " output resp

monocleConfig :: TestTree
monocleConfig =
  testGroup
    "Monocle.Api.Config"
    [testConfigLoad]
  where
    testConfigLoad = testCase "Decode config" $ do
      conf <- getExn <$> Config.loadConfig "./test/data/config.yaml"
      assertEqual "config is loaded" 1 (length conf)
