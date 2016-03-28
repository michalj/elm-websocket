Example use of elm-websocket
----------------------------

A simple example of how to use elm-websocket. This example sends a single
message to the server-side and displays all messages received from the
server. Server-side is written in node and sends a string containing current
time every few seconds.

Install node packages:

    npm install

Start the server-side:

    node server.js

Start elm reactor:

    elm reactor

Navigate to:

    http://localhost:8000/TimeOnServer.elm
