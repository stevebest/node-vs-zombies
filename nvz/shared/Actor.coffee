
###
 Bounds an angle to a [-π, π] range
###
clampAngle = (angle) ->
  ((angle + Math.PI) % (2 * Math.PI)) - Math.PI

module.exports = class Actor

  constructor: (@world) ->
    @x = 0.0
    @y = 0.0
    # @z = 0.0
    @heading = 0.0

    @speed = 3.0 / 1000;
    @turnSpeed = Math.PI / 1000;

    @health = 1

  getState: ->
    { @x, @y, @heading, @health }

  setState: (state) ->
    { @x, @y, @heading, @health } = state
    @update 0

  getLocation: ->
    { @x, @y }

  setLocation: (coordinates) ->
    { @x, @y } = coordinates
    this

  update: (dt) ->
    this

  walk: (dt) ->
    @x += Math.cos(@heading) * @speed * dt
    @y += Math.sin(@heading) * @speed * dt
    this

  ###
   Change heading for elapsed period of time
  ###
  turn: (dt) ->
    @heading = clampAngle(@heading + @turnSpeed * dt)
    this

  idle: ->
    # do nothing
    this

  hit: ->
    @die() if (@health -= 1) <= 0
    this

  die: ->
    this

  isDead: ->
    @health <= 0

  ###
   Returns a heading to take to reach a given point from current position
  ###
  headingTo: (point) ->
    Math.atan2(point.y - @y, point.x - @x)

  ###
   Turns in a direction optimal to reach the given point
  ###
  changeHeading: (point, dt) ->
    alpha = clampAngle(@headingTo(point) - @heading)

    return if Math.abs(alpha) < 0.01

    t = Math.min(dt, Math.abs(alpha) / @turnSpeed)
    @turn if alpha > 0 then t else -t

  ###
   Returns an Euclidean distance to a given point
  ###
  distanceTo: (point) ->
    dx = point.x - @x
    dy = point.y - @y
    Math.sqrt dx*dx + dy*dy
