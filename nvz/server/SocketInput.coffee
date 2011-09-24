
Input = require '../shared/Input'

Hashtable = require '../shared/Hashtable'
Message = require '../shared/Message'

module.exports = class SocketInput extends Input

  constructor: (socket) ->
    @keyState = new Hashtable

    # clean up key states
    Input::ALL.forEach (keyCode) =>
      @keyState.put keyCode, false

    socket.on Message::KEYDOWN, (keyCode) =>
      @keyState.put keyCode, true

    socket.on Message::KEYUP, (keyCode) =>
      @keyState.put keyCode, false

  left:  -> @keyState.get(Input::LEFT)
  up:    -> @keyState.get(Input::UP)
  right: -> @keyState.get(Input::RIGHT)
  down:  -> @keyState.get(Input::DOWN)
  fire:  -> @keyState.get(Input::FIRE)
