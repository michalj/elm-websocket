import StartApp exposing (start)
import Effects exposing (Never, Effects)
import Html exposing (div, text)
import Signal
import Task

import WebSocket exposing (Socket)

-- a mailbox through which the WebSocket can talk back to the application
events = Signal.mailbox WebSocket.OnClose

app =
    start
      { init = init
      , view = view
      , update = update
      , inputs = [ events.signal |> Signal.map toAction ]
      }

main =
    app.html

port tasks : Signal (Task.Task Never ())
port tasks =
    app.tasks

-- MODEL
type Event = Disconnected | Connecting | Connected | Message String
type alias Model = List Event

init = ([ Connecting ], websocket)

-- UPDATE
type Action = OnConnect Socket | OnClose | OnMessage String | Ignore

update action model =
  case action of
    OnConnect socket ->
      ( model ++ [ Connected ]
      , WebSocket.send socket "Hello world" |> Effects.map toAction
      )
    OnMessage message ->
      ( model ++ [ Message message ]
      , Effects.none
      )
    OnClose ->
      ( model ++ [ Disconnected ]
      , Effects.none
      )
    Ignore -> (model, Effects.none)

-- map WebSocket events to application events
toAction : WebSocket.Event -> Action
toAction event =
  case event of
    WebSocket.OnClose -> OnClose
    WebSocket.OnMessage message -> OnMessage message
    _ -> Ignore

-- create the actual websocket, mapping the effects to application terms
websocket : Effects Action
websocket =
  WebSocket.new "ws://localhost:1337" events.address
    |> Effects.map (\result ->
        case result of
          Ok socket -> OnConnect socket
          Err _ -> OnClose
        )

-- VIEW
view address model =
  let
    viewEntry entry =
      case entry of
        Disconnected -> div [] [text "Disconnected"]
        Connecting -> div [] [text "Connecting"]
        Connected -> div [] [text "Connected"]
        Message message ->
          div []
            [ text "Message: "
            , text message
            ]
  in
    div [] (List.map viewEntry model)
