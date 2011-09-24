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
    key = @transformCode e.keyCode

    if -1 != Input::ALL.indexOf key
      socket.emit Message::KEYDOWN, key unless @keyState[key]
      @keyState[key] = true

  onKeyUp: (e) ->
    key = @transformCode e.keyCode

    if -1 != Input::ALL.indexOf key
      socket.emit Message::KEYUP, key if @keyState[key]
      @keyState[key] = false

  left:  -> @keyState[Input::LEFT]
  up:    -> @keyState[Input::UP]
  right: -> @keyState[Input::RIGHT]
  down:  -> @keyState[Input::DOWN]
  fire:  -> @keyState[Input::FIRE]

  transformCode: (code) ->
    return Input::LEFT  if code == 65 # a
    return Input::UP    if code == 87 # w
    return Input::DOWN  if code == 83 # s
    return Input::RIGHT if code == 68 # d
    return Input::FIRE  if (code == 17) or (code == 32) # control or space

    return code
