
module.exports = class Actor

  constructor: (@world) ->
    @position = x: 0.0, y: 0.0, z: 0.0
    @heading = 0.0

    @speed = 3.0 / 1000;
    @turnSpeed = Math.PI / 1000;

    @health = 1

  getState: ->
    { @position, @heading, @health }

  walk: (dt) ->
    @position.x += Math.cos(@heading) * @speed * dt
    @position.y += Math.sin(@heading) * @speed * dt
    this

  turn: (dt) ->
    @heading += @turnSpeed * dt
    this

  idle: ->
    # do nothing
    this

  hit: ->
    @die() if (@health -= 1) == 0
    this

  die: ->
    this

  remove: ->
    @world.remove this
    this
