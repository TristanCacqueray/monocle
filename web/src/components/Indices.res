// Copyright (C) 2021 Monocle authors
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// Render indices
//
open Prelude // 'open' bring module values into scope

module Indice = {
  @react.component
  let make = (~name, ~onSelect) =>
    <MSimpleCard key={name}>
      <Tooltip position=#Bottom content={"Click to get the metric"}>
        <a onClick={_ => onSelect(name)}> {name->React.string} </a>
      </Tooltip>
    </MSimpleCard>
}

module Indices = {
  @react.component
  let make = (~onSelect) => {
    let indices = useAutoGet(getIndices)
    <>
      <h2> {"Available Indices"->React.string} </h2>
      <Layout.Stack>
        {switch indices {
        | None => <Spinner />
        | Some(Error(title)) => <Alert variant=#Danger title />
        | Some(Ok(indices)) if indices->Array.length > 0 =>
          indices->Belt.Array.map(name => <Indice key={name} name onSelect />)->React.array
        | _ => <Alert variant=#Warning title={"Please create an index."} />
        }}
      </Layout.Stack>
    </>
  }
}

let default = Indices.make
