
module.exports = class Input

  # values of e.keyCode
  LEFT:  37
  UP:    38
  RIGHT: 39
  DOWN:  40
  FIRE:  17

  ALL: [Input::LEFT, Input::UP, Input::RIGHT, Input::DOWN, Input::FIRE]

  left:  -> false
  right: -> false
  up:    -> false
  down:  -> false
  fire:  -> false
