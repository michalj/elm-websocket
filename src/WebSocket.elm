module WebSocket (Socket, io) where

import Task exposing (Task)
import Signal exposing (Address)

import Native.WebSocket

type Socket = Socket

io : String -> Address () -> Address String -> Address () -> Task x Socket
io = Native.WebSocket.io

send : Socket -> String -> Task x ()
send = Native.WebSocket.send
