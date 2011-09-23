
World = require './World'

module.exports = {

  randomAngle: -> (2 * Math.random() - 1) * Math.PI

  randomPosition: (x) -> (2 * Math.random() - 1) * x

  ###
   Bounds an angle to a [-π, π] range
  ###
  clampAngle: (angle) ->
    if angle >= 0
      ((angle + Math.PI) % (2 * Math.PI)) - Math.PI
    else
      ((angle - Math.PI) % (2 * Math.PI)) + Math.PI
  
}
