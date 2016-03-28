"use strict";

process.title = 'time-on-server';

var webSocketsServerPort = 1337;

var webSocketServer = require('websocket').server;
var http = require('http');

var server = http.createServer(function(request, response) {
});

function timeOnServer(connection) {
  connection.sendUTF("time on server " + new Date());
  setTimeout(function() {
    timeOnServer(connection);
  }, 3000);
}

server.listen(webSocketsServerPort, function() {
    console.log("Listening on port " + webSocketsServerPort);
});

var wsServer = new webSocketServer({
    httpServer: server
});

wsServer.on('request', function(request) {
    var connection = request.accept(null, request.origin);
    console.log(connection.remoteAddress + " connected");
    timeOnServer(connection);
    connection.on('message', function(message) {
      console.log('got message: ' + message.utf8Data);
    });
    connection.on('close', function(connection) {
      console.log(connection.remoteAddress + " disconnected");
    });
});
