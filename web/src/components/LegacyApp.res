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

module AuthorsHistoStats = {
  module View = {
    @react.component @module("./authors_histo.jsx")
    external make: (~data: Legacy.AuthorsHistoStats.t) => React.element = "CAuthorsHistoStats"
  }

  let fetch = ((state: Store.t, dispatch)) => {
    let query = Legacy.Query.mkQueryParams(
      "authors_histo_stats",
      "authors_histo_stats",
      false,
      false,
      state.legacyQuery,
      state.index,
      0,
      10,
    )
    Fetch.fetch(
      query,
      state.authorsHistoStats,
      () => Legacy.AuthorsHistoStats.get(query),
      res => Store.FetchAuthorsHistoStats(res),
      dispatch,
    )
  }
}

module MostActiveAuthorsStats = {
  module View = {
    @react.component @module("./top.jsx")
    external make: (~data: Legacy.MostActiveAuthorsStats.t) => React.element =
      "CMostActiveAuthorsStats"
  }

  let fetch = ((state: Store.t, dispatch)) => {
    let query = Legacy.Query.mkQueryParams(
      "most_active_authors_stats",
      "most_active_authors_stats",
      false,
      false,
      state.legacyQuery,
      state.index,
      0,
      10,
    )
    Fetch.fetch(
      query,
      state.mostActiveAuthorsStats,
      () => Legacy.MostActiveAuthorsStats.get(query),
      res => Store.FetchMostActiveAuthorsStats(res),
      dispatch,
    )
  }
}

module MostReviewedAuthorsStats = {
  module View = {
    @react.component @module("./top.jsx")
    external make: (~data: Legacy.MostReviewedAuthorsStats.t) => React.element =
      "CMostReviewedAuthorsStats"
  }

  let fetch = ((state: Store.t, dispatch)) => {
    let query = Legacy.Query.mkQueryParams(
      "most_reviewed_authors_stats",
      "most_reviewed_authors_stats",
      false,
      false,
      state.legacyQuery,
      state.index,
      0,
      10,
    )
    Fetch.fetch(
      query,
      state.mostReviewedAuthorsStats,
      () => Legacy.MostReviewedAuthorsStats.get(query),
      res => Store.FetchMostReviewedAuthorsStats(res),
      dispatch,
    )
  }
}

module AuthorsPeersStats = {
  module View = {
    @react.component @module("./top.jsx")
    external make: (~data: Legacy.AuthorsPeersStats.t) => React.element = "CAuthorsPeersStats"
  }

  let fetch = ((state: Store.t, dispatch)) => {
    let query = Legacy.Query.mkQueryParams(
      "peers_exchange_strength",
      "authors_peers_stats",
      false,
      false,
      state.legacyQuery,
      state.index,
      0,
      10,
    )
    Fetch.fetch(
      query,
      state.authorsPeersStats,
      () => Legacy.AuthorsPeersStats.get(query),
      res => Store.FetchAuthorsPeersStats(res),
      dispatch,
    )
  }
}

module NewContributorsStats = {
  module View = {
    @react.component @module("./top.jsx")
    external make: (~data: Legacy.NewContributorsStats.t) => React.element = "CNewContributorsStats"
  }

  let fetch = ((state: Store.t, dispatch)) => {
    let query = Legacy.Query.mkQueryParams(
      "new_contributors",
      "new_contributors",
      false,
      false,
      state.legacyQuery,
      state.index,
      0,
      10,
    )
    Fetch.fetch(
      query,
      state.newContributorsStats,
      () => Legacy.NewContributorsStats.get(query),
      res => Store.FetchNewContributorsStats(res),
      dispatch,
    )
  }
}

module Repos = {
  module View = {
    @react.component @module("./repos_summary.jsx")
    external make: (~index: string, ~data: Legacy.Repos.t) => React.element = "CRepoChanges"
  }

  let fetch = ((state: Store.t, dispatch)) => {
    let query = Legacy.Query.mkQueryParams(
      "repos_summary",
      "repos_summary",
      false,
      false,
      state.legacyQuery,
      state.index,
      0,
      10,
    )
    Fetch.fetch(
      query,
      state.repos,
      () => Legacy.Repos.get(query),
      res => Store.FetchRepos(res),
      dispatch,
    )
  }
}

module Changes = {
  module View = {
    @react.component @module("./changes.jsx")
    external make: (
      ~index: string,
      ~showComplexityGraph: bool,
      ~data: Legacy.Changes.t,
    ) => React.element = "CLastChangesNG"
  }

  let fetch = ((state: Store.t, dispatch)) => {
    let query = Legacy.Query.mkQueryParams(
      "last_changes",
      "last_changes",
      false,
      false,
      state.legacyQuery,
      state.index,
      0,
      10,
    )
    Fetch.fetch(
      query,
      state.changes,
      () => Legacy.Changes.get(query),
      res => Store.FetchChanges(res),
      dispatch,
    )
  }
}

module ChangesAuthorsPie = {
  module View = {
    @react.component @module("./changes_authors_pie.jsx")
    external make: (~data: Legacy.ChangesAuthorsPie.t) => React.element = "default"
  }

  let fetch = ((state: Store.t, dispatch)) => {
    let query = Legacy.Query.mkQueryParams(
      "authors_top",
      "authors_top",
      false,
      false,
      state.legacyQuery,
      state.index,
      0,
      10,
    )
    Fetch.fetch(
      query,
      state.changesAuthorsPie,
      () => Legacy.ChangesAuthorsPie.get(query),
      res => Store.FetchChangesAuthorsPie(res),
      dispatch,
    )
  }
}

module ChangesReposPie = {
  module View = {
    @react.component @module("./repos_pie.jsx")
    external make: (~data: Legacy.ChangesReposPie.t) => React.element = "default"
  }

  let fetch = ((state: Store.t, dispatch)) => {
    let query = Legacy.Query.mkQueryParams(
      "repos_top",
      "repos_top",
      false,
      false,
      state.legacyQuery,
      state.index,
      0,
      10,
    )
    Fetch.fetch(
      query,
      state.changesReposPie,
      () => Legacy.ChangesReposPie.get(query),
      res => Store.FetchChangesReposPie(res),
      dispatch,
    )
  }
}

module ChangesApprovalsPie = {
  module View = {
    @react.component @module("./approvals.jsx")
    external make: (~data: Legacy.ChangesApprovalsPie.t) => React.element = "CApprovalsPie"
  }

  let fetch = ((state: Store.t, dispatch)) => {
    let query = Legacy.Query.mkQueryParams(
      "approvals_top",
      "approvals_top",
      false,
      false,
      state.legacyQuery,
      state.index,
      0,
      10,
    )
    Fetch.fetch(
      query,
      state.changesApprovalsPie,
      () => Legacy.ChangesApprovalsPie.get(query),
      res => Store.FetchChangesApprovalsPie(res),
      dispatch,
    )
  }
}
