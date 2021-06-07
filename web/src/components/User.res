open Prelude

module LoginView = {
  @react.component
  let make = () => {
    <a className="nav-link" href={WebApi.serverUrl ++ "/api/0/login"}>
      {"Sign in with GitHub"->str}
    </a>
  }
}

module View = {
  @react.component
  let make = (~store: Store.t) => {
    switch Store.Fetch.loggedUser(store) {
    | Some(Ok(user)) => ("Hello " ++ user)->str
    | Some(Error(title)) => <Alert title />
    | _ => <Spinner />
    }
  }
}
