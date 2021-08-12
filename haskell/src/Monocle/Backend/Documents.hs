{-# LANGUAGE StrictData #-}
{-# LANGUAGE TemplateHaskell #-}

-- | Data types for ELK documents
module Monocle.Backend.Documents where

import Data.Aeson (FromJSON, ToJSON, Value (String), parseJSON, toJSON, withText)
import Data.Aeson.Casing (aesonPrefix, snakeCase)
import Data.Aeson.TH
import Data.Time.Clock (UTCTime)
import Relude

data Author = Author
  { authorMuid :: LText,
    authorUid :: LText
  }
  deriving (Show, Eq, Generic)

$(deriveJSON (aesonPrefix snakeCase) ''Author)

data File = File
  { fileAdditions :: Word32,
    fileDeletions :: Word32,
    filePath :: LText
  }
  deriving (Show, Eq, Generic)

$(deriveJSON (aesonPrefix snakeCase) ''File)

newtype SimpleFile = SimpleFile
  { simplefilePath :: LText
  }
  deriving (Show, Eq, Generic)

$(deriveJSON (aesonPrefix snakeCase) ''SimpleFile)

data Commit = Commit
  { elkcommitSha :: LText,
    elkcommitAuthor :: Author,
    elkcommitCommitter :: Author,
    elkcommitAuthoredAt :: UTCTime,
    elkcommitCommittedAt :: UTCTime,
    elkcommitAdditions :: Word32,
    elkcommitDeletions :: Word32,
    elkcommitTitle :: LText
  }
  deriving (Show, Eq, Generic)

$(deriveJSON (aesonPrefix snakeCase) ''Commit)

-- TODO: Replace by the existing Monocle.TaskData.NewTaskData
data TaskData = TaskData
  { tdTid :: Text,
    tdTtype :: [Text],
    -- TODO: Handle `2021-05-18T04:31:18` (without the trailing Z)
    -- tdUpdatedAt :: UTCTime,
    tdChangeUrl :: Text,
    tdSeverity :: Text,
    tdPriority :: Text,
    tdScore :: Int,
    tdUrl :: Text,
    tdTitle :: Text
  }
  deriving (Show, Eq, Generic)

$(deriveJSON (aesonPrefix snakeCase) ''TaskData)

data ELKChangeState
  = ElkChangeOpen
  | ElkChangeMerged
  | ElkChangeClosed
  deriving (Eq, Show)

changeStateToText :: ELKChangeState -> Text
changeStateToText = \case
  ElkChangeOpen -> "OPEN"
  ElkChangeMerged -> "MERGED"
  ElkChangeClosed -> "CLOSED"

instance ToJSON ELKChangeState where
  toJSON v = String $ toText $ changeStateToText v

instance FromJSON ELKChangeState where
  parseJSON =
    withText
      "ElkChangeState"
      ( \case
          "OPEN" -> pure ElkChangeOpen
          "MERGED" -> pure ElkChangeMerged
          "CLOSED" -> pure ElkChangeClosed
          _anyOtherValue -> fail "Unknown Monocle ELK change state"
      )

data ELKDocType
  = ElkChangeCreatedEvent
  | ElkChangeMergedEvent
  | ElkChangeReviewedEvent
  | ElkChangeCommentedEvent
  | ElkChangeAbandonedEvent
  | ElkChangeCommitForcePushedEvent
  | ElkChangeCommitPushedEvent
  | ElkChange
  deriving (Eq, Show, Enum, Bounded)

allEventTypes :: [ELKDocType]
allEventTypes = filter (/= ElkChange) [minBound .. maxBound]

docTypeToText :: ELKDocType -> LText
docTypeToText = \case
  ElkChangeCreatedEvent -> "ChangeCreatedEvent"
  ElkChangeMergedEvent -> "ChangeMergedEvent"
  ElkChangeReviewedEvent -> "ChangeReviewedEvent"
  ElkChangeCommentedEvent -> "ChangeCommentedEvent"
  ElkChangeAbandonedEvent -> "ChangeAbandonedEvent"
  ElkChangeCommitForcePushedEvent -> "ChangeCommitForcePushedEvent"
  ElkChangeCommitPushedEvent -> "ChangeCommitPushedEvent"
  ElkChange -> "Change"

instance ToJSON ELKDocType where
  toJSON v = String $ toText $ docTypeToText v

instance FromJSON ELKDocType where
  parseJSON =
    withText
      "ElkDocType"
      ( \case
          "ChangeCreatedEvent" -> pure ElkChangeCreatedEvent
          "ChangeMergedEvent" -> pure ElkChangeMergedEvent
          "ChangeReviewedEvent" -> pure ElkChangeReviewedEvent
          "ChangeCommentedEvent" -> pure ElkChangeCommentedEvent
          "ChangeAbandonedEvent" -> pure ElkChangeAbandonedEvent
          "ChangeCommitForcePushedEvent" -> pure ElkChangeCommitForcePushedEvent
          "ChangeCommitPushedEvent" -> pure ElkChangeCommitPushedEvent
          "Change" -> pure ElkChange
          anyOtherValue -> fail $ "Unknown Monocle ELK doc type: " <> toString anyOtherValue
      )

data ELKChange = ELKChange
  { elkchangeId :: LText,
    elkchangeNumber :: Int,
    elkchangeType :: ELKDocType,
    elkchangeChangeId :: LText,
    elkchangeTitle :: LText,
    elkchangeText :: LText,
    elkchangeUrl :: LText,
    elkchangeCommitCount :: Word32,
    elkchangeAdditions :: Word32,
    elkchangeDeletions :: Word32,
    elkchangeChangedFilesCount :: Word32,
    elkchangeChangedFiles :: [File],
    elkchangeCommits :: [Commit],
    elkchangeRepositoryPrefix :: LText,
    elkchangeRepositoryShortname :: LText,
    elkchangeRepositoryFullname :: LText,
    elkchangeAuthor :: Author,
    elkchangeMergedBy :: Maybe Author,
    elkchangeBranch :: LText,
    elkchangeTargetBranch :: LText,
    elkchangeCreatedAt :: UTCTime,
    elkchangeMergedAt :: Maybe UTCTime,
    elkchangeUpdatedAt :: UTCTime,
    elkchangeClosedAt :: Maybe UTCTime,
    elkchangeState :: ELKChangeState,
    elkchangeDuration :: Maybe Int,
    elkchangeMergeable :: LText,
    elkchangeLabels :: [LText],
    elkchangeAssignees :: [Author],
    elkchangeApproval :: Maybe [LText],
    elkchangeDraft :: Bool,
    elkchangeSelfMerged :: Maybe Bool,
    elkchangeTasksData :: Maybe [TaskData]
  }
  deriving (Show, Eq, Generic)

$(deriveJSON (aesonPrefix snakeCase) ''ELKChange)

data ELKChangeEvent = ELKChangeEvent
  { elkchangeeventId :: LText,
    elkchangeeventNumber :: Word32,
    elkchangeeventType :: ELKDocType,
    elkchangeeventChangeId :: LText,
    elkchangeeventUrl :: LText,
    elkchangeeventChangedFiles :: [SimpleFile],
    elkchangeeventRepositoryPrefix :: LText,
    elkchangeeventRepositoryShortname :: LText,
    elkchangeeventRepositoryFullname :: LText,
    elkchangeeventAuthor :: Author,
    elkchangeeventOnAuthor :: Author,
    elkchangeeventBranch :: LText,
    elkchangeeventOnCreatedAt :: UTCTime,
    elkchangeeventCreatedAt :: UTCTime,
    elkchangeeventApproval :: Maybe [LText]
  }
  deriving (Show, Eq, Generic)

$(deriveJSON (aesonPrefix snakeCase) ''ELKChangeEvent)

data ELKCrawlerMetadataObject = ELKCrawlerMetadataObject
  { elkcmCrawlerName :: LText,
    elkcmCrawlerType :: LText,
    elkcmCrawlerTypeValue :: LText,
    elkcmLastCommitAt :: UTCTime
  }
  deriving (Show, Eq, Generic)

$(deriveJSON (aesonPrefix snakeCase) ''ELKCrawlerMetadataObject)

newtype ELKCrawlerMetadata = ELKCrawlerMetadata
  { elkcmCrawlerMetadata :: ELKCrawlerMetadataObject
  }
  deriving (Show, Eq, Generic)

$(deriveJSON (aesonPrefix snakeCase) ''ELKCrawlerMetadata)
