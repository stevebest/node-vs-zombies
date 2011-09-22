
###
 Bounds an angle to a [-π, π] range
###
clampAngle = (angle) ->
  if angle >= 0
    ((angle + Math.PI) % (2 * Math.PI)) - Math.PI
  else
    ((angle - Math.PI) % (2 * Math.PI)) + Math.PI

module.exports = class Actor

  RADIUS: 0.5;

  actors = [];

  constructor: (@world) ->
    @x = 0.0
    @y = 0.0

    @force = x: 0.0, y: 0.0

    # @z = 0.0
    @heading = 0.0

    @speed = 3.0 / 1000;
    @turnSpeed = Math.PI / 1000;

    @health = 1

    actors.push this

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
    myself = this
    @x += Math.cos(@heading) * @speed * dt
    @y += Math.sin(@heading) * @speed * dt

    @x += @force.x / 1000 * dt
    @y += @force.y / 1000 * dt

    @force = x: 0, y: 0

    colliding = actors.filter (other) ->
      !!other and
        other != myself and
        myself.isHeadingTo(other) and
        myself.distanceTo(other) < 2 * Actor::RADIUS

    colliding.forEach (other) ->
      dfx = 1 / (other.x - myself.x)
      dfy = 1 / (other.y - myself.y)
      other.force.x += dfx
      other.force.y += dfy
      myself.force.x += -dfx
      myself.force.y += -dfy

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
    @health = -100
    delete actors[actors.indexOf this]
    this

  isDead: ->
    @health <= 0

  ###
   Returns a heading to take to reach a given point from current position
  ###
  headingTo: (point) ->
    Math.atan2(point.y - @y, point.x - @x)

  ###
   Returns true if the point is in the front half-plane relative to us
  ###
  isHeadingTo: (point) ->
    Math.abs(clampAngle(@headingTo(point) - @heading)) < Math.PI / 2

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
