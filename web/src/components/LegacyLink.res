@react.component
let make = (~_to: string, ~children: 'children) =>
  <a style={ReactDOM.Style.make(~color="blue", ())} onClick={_ => RescriptReactRouter.push(_to)}>
    {children}
  </a>

let default = make
