open Prelude
open WebApi

@module("../api.js") external serverUrl: string = "server"

module Query = {
  type t

  @module("./common.jsx")
  external mkQueryParams: (string, string, bool, bool, string, string, int, int) => t =
    "mkQueryParams"
}

module ChangesReviewStats = {
  type t
  @module("../api.js")
  external getChangesReviewStatsRaw: Query.t => axios<t> = "getQueryResults"

  // Binding for existing components
  module View = {
    @react.component @module("./changes_review.jsx")
    external make: (~data: t) => React.element = "CChangesReviewStats"
  }

  let get = (query: Query.t): axios<t> => getChangesReviewStatsRaw(query)
}
