
Input = require '../shared/Input'
Hashtable = require '../shared/Hashtable'
Message = require '../shared/Message'

module.exports = class SocketInput extends Input

  keyState = new Hashtable

  window.socket.on Message::KEYDOWN, (player, keyCode) ->
    keyState.get(player).put keyCode, true

  window.socket.on Message::KEYUP, (player, keyCode) ->
    keyState.get(player).put keyCode, false

  window.socket.on Message::PLAYERS, (players) ->
    (new Hashtable players).forEach (player, state) ->
      if !keyState.get player
        keyState.put player, new Hashtable

  window.socket.on Message::LEAVE, (player) ->
    keyState.delete player

  constructor: (@player) ->
    keyState.put @player, new Hashtable
    Input::ALL.forEach (keyCode) =>
      keyState.get(@player).put keyCode, false

  left:  -> keyState.get(@player).get Input::LEFT
  up:    -> keyState.get(@player).get Input::UP
  right: -> keyState.get(@player).get Input::RIGHT
  down:  -> keyState.get(@player).get Input::DOWN
