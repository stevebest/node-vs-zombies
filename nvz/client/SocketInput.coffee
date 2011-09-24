
Input = require '../shared/Input'
Hashtable = require '../shared/Hashtable'
Message = require '../shared/Message'

module.exports = class SocketInput extends Input

  keyState = new Hashtable

  @keyDown: (player, keyCode) ->
    return null if !keyState.get player
    keyState.get(player).put keyCode, true

  @keyUp: (player, keyCode) ->
    return null if !keyState.get player
    keyState.get(player).put keyCode, false

  constructor: (@player) ->
    keyState.put @player, new Hashtable
    Input::ALL.forEach (keyCode) =>
      keyState.get(@player).put keyCode, false

  remove: ->
    keyState.delete @player

  left:  -> keyState.get(@player).get Input::LEFT
  up:    -> keyState.get(@player).get Input::UP
  right: -> keyState.get(@player).get Input::RIGHT
  down:  -> keyState.get(@player).get Input::DOWN
  fire:  -> keyState.get(@player).get Input::FIRE
