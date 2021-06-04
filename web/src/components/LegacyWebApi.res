open Prelude
open WebApi

@module("../api.js") external serverUrl: string = "server"

module ChangesReviewStats = {
  type t
  @module("axios")
  external getChangesReviewStatsRaw: string => axios<t> = "get"

  // Binding for existing components
  module View = {
    @react.component @module("./changes_review.jsx")
    external make: (~data: t) => React.element = "CChangesReviewStats"
  }

  let get = (index): axios<t> => {
    getChangesReviewStatsRaw(
      serverUrl ++
      "/api/0/query/changes_review_stats?index=" ++
      index ++ "&repository=.*&gte=2021-03-04&from=0&size=10&ec_same_date=true",
    )
  }
}
