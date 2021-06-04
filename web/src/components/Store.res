module RemoteData = {
  type t<'data> = option<result<'data, string>>

  let fmap = (m: t<'a>, f: 'a => 'b): t<'b> => {
    m->Belt.Option.flatMap(r => r->Belt.Result.flatMap(d => d->f->Ok)->Some)
  }
}

module UrlData = {
  let getQuery = () => {
    let params = Prelude.URLSearchParams.current()
    switch params->Prelude.URLSearchParams.get("q")->Js.Nullable.toOption {
    | Some(expr) => expr
    | None => "limit 5"
    }
  }
}

module Store = {
  type suggestionsR = RemoteData.t<SearchTypes.search_suggestions_response>
  type fieldsRespR = RemoteData.t<SearchTypes.fields_response>
  type changesReviewStatsR = RemoteData.t<LegacyWebApi.ChangesReviewStats.t>

  type t = {
    index: string,
    query: string,
    legacyQuery: string,
    suggestions: suggestionsR,
    fields: RemoteData.t<list<SearchTypes.field>>,
    changesReviewStats: changesReviewStatsR,
  }
  type action =
    | SetIndex(string)
    | SetQuery(string)
    | SetLegacyQuery(string)
    | FetchFields(fieldsRespR)
    | FetchSuggestions(suggestionsR)
    | FetchChangesReviewStats(changesReviewStatsR)
  type dispatch = action => unit

  let reducer = (state: t, action: action) =>
    switch action {
    | SetIndex(index) if index != state.index => {
        ...state,
        suggestions: None,
        index: index,
        changesReviewStats: None,
      }
    | SetQuery(query) => {
        Prelude.setLocationSearch("q", query)->ignore
        {...state, query: query}
      }
    | SetLegacyQuery(legacyQuery) => {...state, legacyQuery: legacyQuery, changesReviewStats: None}
    | FetchFields(res) => {...state, fields: res->RemoteData.fmap(resp => resp.fields)}
    | FetchSuggestions(res) => {...state, suggestions: res}
    | FetchChangesReviewStats(res) => {...state, changesReviewStats: res}
    }

  // TODO: replace static index with a SetIndex action, after the LegacyApp is removed
  let create = index => {
    index: index,
    query: UrlData.getQuery(),
    legacyQuery: "",
    suggestions: None,
    fields: None,
    changesReviewStats: None,
  }
}

module Fetch = {
  // Helper module to abstract the WebApi
  open WebApi
  let fetch = (
    query: 'q,
    value: RemoteData.t<'r>,
    get: unit => axios<'a>,
    mkAction: RemoteData.t<'a> => Store.action,
    dispatch: Store.dispatch,
  ) => {
    let set = v => v->Some->mkAction->dispatch->Js.Promise.resolve
    let handleErr = err => {
      Js.log(err)
      "Network error"->Error->set
    }
    let handleOk = resp => resp.data->Ok->set
    // Effect0 is performed when the component is monted
    React.useEffect1(() => {
      // We fetch the remote data only when needed
      switch value {
      | None => (get() |> Js.Promise.then_(handleOk) |> Js.Promise.catch(handleErr))->ignore
      | _ => ignore()
      }
      None
    }, [query])
    value
  }

  let suggestions = ((state: Store.t, dispatch)) =>
    fetch(
      state.index,
      state.suggestions,
      () => WebApi.Search.suggestions({SearchTypes.index: state.index}),
      res => Store.FetchSuggestions(res),
      dispatch,
    )

  let fields = ((state: Store.t, dispatch)) => {
    fetch(
      None,
      state.fields,
      () => WebApi.Search.fields({version: "1"}),
      res => Store.FetchFields(res),
      dispatch,
    )
  }
}

// Hook API
type t = (Store.t, Store.action => unit)

let use = (index): t => React.useReducer(Store.reducer, Store.create(index))
