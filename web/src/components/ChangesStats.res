// Copyright (C) 2021 Monocle authors
// SPDX-License-Identifier: AGPL-3.0-or-later
//
// The changes view
//
open Prelude

// The ChangesView components
module StatsToggle = {
  let boxStyle = ReactDOM.Style.make(
    ~backgroundColor="#dbecff6b",
    ~textAlign="center",
    ~cursor="pointer",
    (),
  )
  let pStyle = ReactDOM.Style.make(~marginTop="0rem", ~marginBottom="0rem", ~fontWeight="bold", ())

  @react.component
  let make = (~showPies: bool, ~setShowPies) => {
    let statMessage = showPies ? "Collapse stats" : "Display stats"
    <MSimpleCard style=boxStyle onClick={_ => setShowPies(x => !x)}>
      <p style=pStyle> {statMessage->React.string} </p>
    </MSimpleCard>
  }
}

module Pies = {
  open LegacyApp
  @react.component
  let make = (~store) =>
    switch (
      ChangesAuthorsPie.fetch(store),
      ChangesReposPie.fetch(store),
      ChangesApprovalsPie.fetch(store),
    ) {
    | (Some(Ok(cap)), Some(Ok(rp)), Some(Ok(ap))) =>
      <MGrid>
        <MGridItem> <ChangesAuthorsPie.View data={cap} /> </MGridItem>
        <MGridItem> <ChangesReposPie.View data={rp} /> </MGridItem>
        <MGridItem> <ChangesApprovalsPie.View data={ap} /> </MGridItem>
      </MGrid>
    | _ => <Spinner />
    }
}
