import WebSocket exposing (io, Socket)

import Graphics.Element exposing (show)
import Time exposing (Time, second)
import Signal
import Task exposing (Task)

type Status = Connected | Disconnected

messages = Signal.mailbox ""
status = Signal.mailbox Disconnected

port connect : Task x Socket
port connect = io "ws://echo.websocket.org"
  (Signal.forwardTo status.address (\_ -> Connected))
  messages.address (Signal.forwardTo status.address
  (\_ -> Disconnected))

main = status.signal |> Signal.map show
