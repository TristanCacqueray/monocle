{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoImplicitPrelude #-}

-- |
module Monocle.Backend.Documents where

import Data.Aeson (FromJSON, ToJSON, genericParseJSON, genericToJSON, parseJSON, toJSON)
import Data.Aeson.Casing (aesonPrefix, snakeCase)
import Data.Time.Clock (UTCTime)
import Relude

data Author = Author
  {authorMuid :: LText}
  deriving (Show, Eq, Generic)

instance ToJSON Author where
  toJSON = genericToJSON $ aesonPrefix snakeCase

instance FromJSON Author where
  parseJSON = genericParseJSON $ aesonPrefix snakeCase

data File = File
  { fileAdditions :: Word32,
    fileDeletions :: Word32,
    filePath :: LText
  }
  deriving (Show, Eq, Generic)

instance ToJSON File where
  toJSON = genericToJSON $ aesonPrefix snakeCase

instance FromJSON File where
  parseJSON = genericParseJSON $ aesonPrefix snakeCase

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

instance ToJSON Commit where
  toJSON = genericToJSON $ aesonPrefix snakeCase

instance FromJSON Commit where
  parseJSON = genericParseJSON $ aesonPrefix snakeCase

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

instance ToJSON TaskData where
  toJSON = genericToJSON $ aesonPrefix snakeCase

instance FromJSON TaskData where
  parseJSON = genericParseJSON $ aesonPrefix snakeCase

data ELKChange = ELKChange
  { elkchangeId :: Text,
    elkchangeNumber :: Int,
    elkchangeChangeId :: Text,
    elkchangeTitle :: Text,
    elkchangeText :: Text,
    elkchangeUrl :: Text,
    elkchangeCommitCount :: Word32,
    elkchangeAdditions :: Word32,
    elkchangeDeletions :: Word32,
    elkchangeChangedFilesCount :: Word32,
    elkchangeChangedFiles :: [File],
    elkchangeCommits :: [Commit],
    elkchangeRepositoryPrefix :: Text,
    elkchangeRepositoryShortname :: Text,
    elkchangeRepositoryFullname :: Text,
    elkchangeAuthor :: Author,
    elkchangeCommitter :: Maybe Author,
    elkchangeMergedBy :: Maybe Author,
    elkchangeBranch :: Text,
    elkchangeTargetBranch :: Text,
    elkchangeCreatedAt :: UTCTime,
    elkchangeMergedAt :: Maybe UTCTime,
    elkchangeUpdatedAt :: UTCTime,
    elkchangeClosedAt :: Maybe UTCTime,
    elkchangeState :: Text,
    elkchangeDuration :: Maybe Int,
    elkchangeMergeable :: Text,
    elkchangeLabels :: [Text],
    elkchangeAssignees :: [Author],
    elkchangeApproval :: Maybe [Text],
    elkchangeDraft :: Bool,
    elkchangeSelfMerged :: Maybe Bool,
    elkchangeTasksData :: Maybe [TaskData]
  }
  deriving (Show, Eq, Generic)

instance ToJSON ELKChange where
  toJSON = genericToJSON $ aesonPrefix snakeCase

instance FromJSON ELKChange where
  parseJSON = genericParseJSON $ aesonPrefix snakeCase
