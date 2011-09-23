G = require './Geometry'

module.exports = class Actor

  RADIUS: 0.5;

  MASS: 100000;

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
    { @x, @y, @heading, @health, @speed }

  setState: (state) ->
    { @x, @y, @heading, @health, @speed } = state
    this

  getLocation: ->
    { @x, @y }

  setLocation: (coordinates) ->
    { @x, @y } = coordinates
    this

  @updateCollisions: ->
    actors.forEach (actor) ->
      actor.collide() if !!actor

  collide: ->
    myself = this

    colliding = actors.filter (other) ->
      !!other and
        other != myself and
        myself.distanceTo(other) < 2 * Actor::RADIUS

    colliding.forEach (other) ->
      phi = myself.headingTo other
      rho = 1 - myself.distanceTo(other) / (2 * Actor::RADIUS)
      f = 10 - 10*rho

      dfx = f * Math.cos(phi)
      dfy = f * Math.sin(phi)

      myself.force.x -= dfx
      myself.force.y -= dfy
      other.force.x += dfx
      other.force.y += dfy

    this

  update: (dt) ->
    this

  walk: (dt) ->
    vx = Math.cos(@heading) * @speed +
        (@force.x / Actor::MASS) * dt
    vy = Math.sin(@heading) * @speed +
        (@force.y / Actor::MASS) * dt

    @x += vx * dt
    @y += vy * dt

    @force.x = 0
    @force.y = 0

    this

  ###
   Change heading for elapsed period of time
  ###
  turn: (dt) ->
    @heading = G.clampAngle(@heading + @turnSpeed * dt)
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
    Math.abs(G.clampAngle(@headingTo(point) - @heading)) < Math.PI / 2

  ###
   Turns in a direction optimal to reach the given point
  ###
  changeHeading: (point, dt) ->
    alpha = G.clampAngle(@headingTo(point) - @heading)

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
