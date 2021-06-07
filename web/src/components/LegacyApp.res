open Store

module ChangesReviewStats = {
  module View = {
    @react.component @module("./changes_review.jsx")
    external make: (~data: Legacy.ChangesReviewStats.t) => React.element = "CChangesReviewStats"
  }

  let fetch = ((state: Store.t, dispatch)) => {
    let query = Legacy.Query.mkQueryParams(
      "changes_review_stats",
      "changes_review_stats",
      false,
      false,
      state.legacyQuery,
      state.index,
      0,
      10,
    )
    Fetch.fetch(
      query,
      state.changesReviewStats,
      () => Legacy.ChangesReviewStats.get(query),
      res => Store.FetchChangesReviewStats(res),
      dispatch,
    )
  }
}

module ChangesLifeCycleStats = {
  // Binding for existing components
  module View = {
    @react.component @module("./changes_lifecycle.jsx")
    external make: (~index: string, ~data: Legacy.ChangesLifeCycleStats.t) => React.element =
      "CChangesLifeCycleStats"
  }

  let fetch = ((state: Store.t, dispatch)) => {
    let query = Legacy.Query.mkQueryParams(
      "changes_lifecycle_stats",
      "changes_lifecycle_stats",
      false,
      false,
      state.legacyQuery,
      state.index,
      0,
      10,
    )
    Fetch.fetch(
      query,
      state.changesLifeCycleStats,
      () => Legacy.ChangesLifeCycleStats.get(query),
      res => Store.FetchChangesLifeCycleStats(res),
      dispatch,
    )
  }
}
