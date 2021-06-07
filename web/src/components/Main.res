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

module PeopleView = {
  open LegacyApp
  @react.component
  let make = (~store: Store.t) => {
    let (state, _) = store
    switch (
      AuthorsHistoStats.fetch(store),
      MostActiveAuthorsStats.fetch(store),
      MostReviewedAuthorsStats.fetch(store),
      AuthorsPeersStats.fetch(store),
      NewContributorsStats.fetch(store),
    ) {
    | (Some(Ok(ah)), Some(Ok(maa)), Some(Ok(mra)), Some(Ok(aps)), Some(Ok(ncs))) =>
      <div className="container">
        <FiltersForm store showChangeParams={false} />
        <AuthorsHistoStats.View data={ah} />
        <MostActiveAuthorsStats.View data={maa} />
        <MostReviewedAuthorsStats.View data={mra} />
        <AuthorsPeersStats.View data={aps} />
        <NewContributorsStats.View data={ncs} />
      </div>
    | _ => <Spinner />
    }
  }
}

module ReposView = {
  open LegacyApp
  @react.component
  let make = (~store: Store.t) => {
    let (state, _) = store
    switch Repos.fetch(store) {
    | Some(Ok(data)) =>
      <div className="container">
        <FiltersForm store showChangeParams={false} /> <Repos.View index={state.index} data />
      </div>
    | _ => <Spinner />
    }
  }
}

module ChangesView = {
  open LegacyApp
  @react.component
  let make = (~store: Store.t) => {
    let (showPies, setShowPies) = React.useState(_ => false)
    let (state, _) = store
    let index = state.index
    switch Changes.fetch(store) {
    | Some(Ok(data)) =>
      <MStack>
        <MStackItem> <FiltersForm store showChangeParams={true} /> </MStackItem>
        <MStackItem> <ChangesStats.StatsToggle showPies setShowPies /> </MStackItem>
        {showPies ? <MStackItem> <ChangesStats.Pies store /> </MStackItem> : {React.null}}
        <MStackItem>
          <LegacyApp.Changes.View index data showComplexityGraph={showPies} />
        </MStackItem>
      </MStack>
    | _ => <Spinner />
    }
  }
}

module ChangeView = {
  open LegacyApp
  @react.component
  let make = (~change: string, ~store: Store.t) => {
    let (state, _) = store
    let index = state.index
    switch Change.fetch(change, store) {
    | Some(Ok(data)) => <div className="container"> <Change.View index data /> </div>
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
          | list{"login"} => <User.LoginView />
          | list{"user"} => <User.View store />
          | list{_index} => <RootView store />
          | list{_index, "board"} => <Board store />
          | list{_index, "people"} => <PeopleView store />
          | list{_index, "repos"} => <ReposView store />
          | list{_index, "changes"} => <ChangesView store />
          | list{_index, "change", change} => <ChangeView store change />
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
