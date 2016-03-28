var lastMessage = "";

Elm.Native.WebSocket = {};
Elm.Native.WebSocket.make = function(localRuntime) {
  localRuntime.Native = localRuntime.Native || {};
  localRuntime.Native.WebSocket = localRuntime.Native.WebSocket || {};
  if (localRuntime.Native.WebSocket.values){
    return localRuntime.Native.WebSocket.values;
  }

  var Task = Elm.Native.Task.make (localRuntime);
  var Utils = Elm.Native.Utils.make (localRuntime);

  function ioWrapper(url, onmessage, onerror, onclose) {
    return Task.asyncFunction(function(callback) {
      var ws = new WebSocket(url);
      ws.onopen = function() {
        callback(Task.succeed(ws));
      };
      ws.onclose = function() {
        Task.perform(onclose._0(Utils.Tuple0));
      };
      ws.onerror = function(error) {
        Task.perform(onerror._0(Utils.Tuple0));
      };
      ws.onmessage = function(message) {
        lastMessage = message;
        Task.perform(onmessage._0(message.data));
      };
    });
  }

  function sendWrapper(ws, message) {
    return Task.asyncFunction(function(callback) {
      ws.send(message);
      callback(Task.succeed(Utils.Tuple0));
    });
  }

  localRuntime.Native.WebSocket.values = {
    io: F4(ioWrapper),
    send: F2(sendWrapper)
  };
  return localRuntime.Native.WebSocket.values;
};
