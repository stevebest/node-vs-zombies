Input = require '../shared/Input'
Message = require '../shared/Message'

module.exports = class KeyboardInput extends Input

  constructor: ->
    @keyState = {}
    Input::ALL.forEach (i) =>
      @keyState[i] = false;
    document.addEventListener 'keydown', @onKeyDown.bind(this), false
    document.addEventListener 'keyup', @onKeyUp.bind(this), false

  onKeyDown: (e) ->
    if -1 != Input::ALL.indexOf e.keyCode
      socket.emit Message::KEYDOWN, e.keyCode unless @keyState[e.keyCode]
      @keyState[e.keyCode] = true
      

  onKeyUp: (e) ->
    if -1 != Input::ALL.indexOf e.keyCode
      socket.emit Message::KEYUP, e.keyCode if @keyState[e.keyCode]
      @keyState[e.keyCode] = false

  left:  -> @keyState[Input::LEFT]
  up:    -> @keyState[Input::UP]
  right: -> @keyState[Input::RIGHT]
  down:  -> @keyState[Input::DOWN]
