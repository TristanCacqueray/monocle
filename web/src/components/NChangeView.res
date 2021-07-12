open Prelude

@react.component
let make = (~store: Store.t) => {
  let (state, _) = store
  let index = state.index
  let request = {
    SearchTypes.index: index,
    query: state.query,
    username: "",
    query_type: SearchTypes.Query_change,
  }

  <div>
    {switch useAutoGetOn(() => WebApi.Search.query(request), state.query) {
    | None => <Spinner />
    | Some(Error(title)) => <Alert variant=#Danger title />
    | Some(Ok(SearchTypes.Error(err))) =>
      <Alert
        title={err.message ++ " at " ++ string_of_int(Int32.to_int(err.position))} variant=#Danger
      />
    | Some(Ok(SearchTypes.Changes(items))) => {
        let changes = items.changes->Belt.List.toArray
        switch changes->Belt.Array.length {
        | 0 => <p> {"No changes matched"->str} </p>
        | _ =>
          <Patternfly.DataList isCompact={true}>
            {changes
            ->Belt.Array.map(change => <Change.DataItem index key={change.url} change={change} />)
            ->React.array}
          </Patternfly.DataList>
        }
      }
    }}
  </div>
}

let default = make