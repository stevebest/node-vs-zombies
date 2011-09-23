
World = require './World'

randomAngle = -> (2 * Math.random() - 1) * Math.PI

randomPosition = (x) -> (2 * Math.random() - 1) * x

isEast = (heading) -> Math.abs(heading) < Math.PI / 2
isWest = (heading) -> Math.abs(heading) > Math.PI / 2

isNorth = (heading) -> heading > 0
isSouth = (heading) -> heading < 0

###
 Bounds an angle to a [-π, π] range
###
clampAngle = (angle) ->
  if angle >= 0
    ((angle + Math.PI) % (2 * Math.PI)) - Math.PI
  else
    ((angle - Math.PI) % (2 * Math.PI)) + Math.PI

module.exports = {
  randomAngle
  randomPosition
  isEast
  isWest
  isNorth
  isSouth
  clampAngle
}
