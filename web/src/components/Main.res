open Prelude

module RootView = {
  open LegacyApp
  @react.component
  let make = (~store: Store.t) => {
    let (state, _) = store
    switch (ChangesLifeCycleStats.fetch(store), ChangesReviewStats.fetch(store)) {
    | (Some(Ok(lf)), Some(Ok(rs))) =>
      <div className="container">
        <FiltersForm store showChangeParams={false} />
        <ChangesLifeCycleStats.View index={state.index} data={lf} />
        <ChangesReviewStats.View data={rs} />
      </div>
    | _ => <Spinner />
    }
  }
}

module Main = {
  @react.component
  let make = () => {
    let url = RescriptReactRouter.useUrl()

    let store = Store.use(url.path->Belt.List.head->Belt.Option.getWithDefault(""))
    let (state, dispatch) = store

    let topNav = switch state.index {
    | "" => React.null
    | index => {
        let current =
          "/" ++
          url.path
          ->Belt.List.tail
          ->Belt.Option.flatMap(Belt.List.head)
          ->Belt.Option.getWithDefault("")

        let nav = (name, dest) =>
          <NavItem
            key={name}
            onClick={_ => RescriptReactRouter.push("/" ++ index ++ dest)}
            isActive={current == dest}>
            {name->str}
          </NavItem>
        <Nav variant=#Horizontal>
          <NavList>
            {[
              nav("Main", "/"),
              nav("Board", "/board"),
              nav("Peoples", "/people"),
              nav("Repositories", "/repos"),
              nav("Changes", "/changes"),
            ]->React.array}
          </NavList>
        </Nav>
      }
    }
    let logo = <span onClick={_ => RescriptReactRouter.push("/")}> {"Monocle"->str} </span>

    let header = <PageHeader logo topNav />

    <Page header>
      <PageSection isFilled=true>
        {
          let reacturl = RescriptReactRouter.useUrl()
          switch reacturl.path {
          | list{} =>
            <Indices.Indices
              onSelect={indice => {
                RescriptReactRouter.push(indice)
                indice->Store.Store.SetIndex->dispatch
              }}
            />
          | list{_index} => <RootView store />
          | list{_index, "board"} => <Board store />
          | list{_index, _} => <p> {("index: " ++ state.index)->str} </p>
          | _ => <p> {"Not found"->str} </p>
          }
        }
      </PageSection>
      <PageSection variant=#Light sticky=#Bottom>
        <Nav variant=#Horizontal>
          <NavList>
            <a
              className="nav-link"
              href="https://github.com/change-metrics/monocle"
              target="_blank"
              rel="noopener noreferrer">
              {"Powered by Monocle"->str}
            </a>
          </NavList>
        </Nav>
      </PageSection>
    </Page>
  }
}

let default = Main.make
