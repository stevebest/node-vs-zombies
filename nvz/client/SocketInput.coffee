
Hashtable = require '../shared/Hashtable'
Message = require '../shared/Message'

module.exports = class SocketInput extends Input

  keyState = new Hashtable

  socket.on Message::KEYDOWN, (player, keyCode) ->
    keyState.get(player).set(keyCode, true)

  socket.on Message::KEYUP, (player, keyCode) ->
    keyState.get(player).set(keyCode, false)

  socket.on Message::PLAYERS, (players) ->
    for player in players
      keyState.set player, new Hashtable

  socket.on Message::LEAVE, (player) ->
    keyState.delete player

  constructor: (@player) ->
    keyState.set player, new Hashtable
    Input::ALL.forEach (keyCode) ->
      keyState.get(player).set keyCode, false

  left:  -> keyState.get(player).get(Input::LEFT)
  up:    -> keyState.get(player).get(Input::UP)
  right: -> keyState.get(player).get(Input::RIGHT)
  down:  -> keyState.get(player).get(Input::DOWN)
