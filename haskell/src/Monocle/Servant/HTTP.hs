{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE NoImplicitPrelude #-}

-- Generated by monocle-codegen. DO NOT EDIT!

-- |
-- Copyright: (c) 2021 Monocle authors
-- SPDX-License-Identifier: AGPL-3.0-only
module Monocle.Servant.HTTP (MonocleAPI, server) where

import Data.Maybe (Maybe (Nothing))
import Monocle.Api.Server (searchFields, searchQuery, searchQueryAuth)
import Monocle.Search (FieldsRequest, FieldsResponse, QueryRequest, QueryResponse)
import Monocle.Servant.Env
import Monocle.Servant.PBJSON (PBJSON)
import Servant

type MonocleAPI =
  "search" :> "fields" :> ReqBody '[JSON] FieldsRequest :> Post '[PBJSON, JSON] FieldsResponse
    :<|> "search" :> "query" :> ReqBody '[JSON] QueryRequest :> Post '[PBJSON, JSON] QueryResponse
    :<|> "a" :> "search" :> "query" :> Vault :> ReqBody '[JSON] QueryRequest :> Post '[PBJSON, JSON] QueryResponse

server :: ServerT MonocleAPI AppM
server =
  searchFields Nothing
    :<|> searchQuery Nothing
    :<|> searchQueryAuth
