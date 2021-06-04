open Store

module ChangesReviewStats = {
  let fetch = (q: LegacyWebApi.Query.t, (state: Store.t, dispatch)) => {
    Fetch.fetch(
      q,
      state.changesReviewStats,
      () => LegacyWebApi.ChangesReviewStats.get(q),
      res => Store.FetchChangesReviewStats(res),
      dispatch,
    )
  }
}
