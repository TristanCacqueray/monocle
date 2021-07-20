// Copyright (C) 2021 Monocle authors
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// The user group view component
//

open Prelude

type t = Commit | Review

module HistoBox = {
  @react.component
  let make = (
    ~bucket: UserGroupTypes.review_histo,
    ~store: Store.t,
    ~author: string,
    ~field: t,
  ) => {
    let count = bucket.count->Int32.to_int->Belt.Int.toFloat
    let countStr = switch bucket.count->Int32.to_int {
    | 0 => ""
    | x => x->string_of_int
    }
    let alpha = Js.Math.unsafe_round(255.0 *. Js.Math.log10(1.0 +. count))
    let green = 100 + Js.Math.unsafe_round(155.0 *. Js.Math.log10(1.0 +. count))
    let style = ReactDOM.Style.make(
      ~width="20px",
      ~height="20px",
      ~display="inline-block",
      ~border="1px solid black",
      ~color="black",
      ~margin="2px",
      ~borderRadius="5px",
      ~overflow="hidden",
      ~textAlign="center",
      ~backgroundColor="rgba(0, " ++ string_of_int(green) ++ ", 0, " ++ string_of_int(alpha) ++ ")",
      (),
    )

    let date = bucket.date->Int64.to_float->Js.Date.fromFloat
    let dateStr = date->Js.Date.toDateString
    let fromDate = (date->Js.Date.toISOString |> Js.String.split("T"))->Js.Array.unsafe_get(0)
    let nextDate =
      ((bucket.date->Int64.to_float +. 86401000.0)->Js.Date.fromFloat->Js.Date.toISOString
        |> Js.String.split("T"))->Js.Array.unsafe_get(0)
    let box = <span style> {countStr->str} </span>

    let (state, dispatch) = store
    let filter =
      "author:\"" ++ author ++ "\" and updated_at>" ++ fromDate ++ " and updated_at<" ++ nextDate
    let onClick = _ => filter->Store.Store.SetFilter->dispatch

    <Tooltip content={dateStr->str}>
      {switch field {
      | Commit if bucket.count->Int32.to_int > 0 =>
        <Link onClick _to={"/" ++ state.index ++ "/changes?q=" ++ state.query ++ "&f=" ++ filter}>
          {box}
        </Link>
      | _ => box
      }}
    </Tooltip>
  }
}

module RowItem = {
  module Head = {
    @react.component
    let make = () =>
      <thead>
        <tr role="row">
          <th role="columnheader"> {"Member"->str} </th>
          <Tooltip content={"The ratio between change created and change reviewed"}>
            <th role="columnheader"> {"Commit / Review"->str} </th>
          </Tooltip>
          <th role="columnheader"> {"Daily review activity"->str} </th>
        </tr>
      </thead>
  }
  @react.component
  let make = (~user: UserGroupTypes.user_stat, ~store: Store.t) => {
    let stat = user.stat->Belt.Option.getExn
    <tr role="row">
      <td role="cell"> {user.name->str} </td>
      <td role="cell">
        <Canvas.Dom
          width=100
          height=20
          onDraw={Canvas.drawScale(stat.change_review_ratio->Js.Math.unsafe_round)}
        />
      </td>
      <td role="cell">
        <Layout.Grid>
          <Layout.GridItem md=Column._1> {"Commits: "->str} </Layout.GridItem>
          <Layout.GridItem md=Column._11>
            {stat.commit_histo
            ->Belt.List.mapWithIndex((index, bucket) =>
              <HistoBox bucket key={index->string_of_int} store author={user.name} field={Commit} />
            )
            ->Belt.List.toArray
            ->React.array}
          </Layout.GridItem>
          <Layout.GridItem md=Column._1> {"Review: "->str} </Layout.GridItem>
          <Layout.GridItem md=Column._11>
            {stat.review_histo
            ->Belt.List.mapWithIndex((index, bucket) =>
              <HistoBox bucket key={index->string_of_int} author={user.name} store field={Review} />
            )
            ->Belt.List.toArray
            ->React.array}
          </Layout.GridItem>
        </Layout.Grid>
      </td>
    </tr>
  }
}

module GroupTable = {
  @react.component
  let make = (~group: UserGroupTypes.get_response, ~store: Store.t) => {
    <table className="pf-c-table pf-m-compact pf-m-grid-md" role="grid">
      <RowItem.Head />
      <tbody role="rowgroup">
        {group.users
        ->Belt.List.mapWithIndex((idx, user) => <RowItem key={string_of_int(idx)} user store />)
        ->Belt.List.toArray
        ->React.array}
      </tbody>
    </table>
  }
}

@react.component
let make = (~group: string, ~store: Store.t) => {
  let (state, _) = store
  let request: UserGroupTypes.get_request = {index: state.index, name: group, query: state.query}
  <MStack>
    <MStackItem>
      <h3> {group->str} </h3>
      {switch useAutoGetOn(() => WebApi.UserGroup.get(request), state.query) {
      | None => <Spinner />
      | Some(Error(title)) => <Alert variant=#Danger title />
      | Some(Ok(group)) => <GroupTable group store />
      }}
    </MStackItem>
  </MStack>
}
let default = make
