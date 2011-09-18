
module.exports = class Input

  # values of e.keyCode
  LEFT:  37
  UP:    38
  RIGHT: 39
  DOWN:  40

  ALL: [Input::LEFT, Input::UP, Input::RIGHT, Input::DOWN]

  left:  -> false
  right: -> false
  up:    -> false
  down:  -> false

  fire:  -> false
