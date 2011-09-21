
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
    @x += Math.sin(@heading) * @speed * dt
    @y -= Math.cos(@heading) * @speed * dt
    this

  turn: (dt) ->
    @heading += @turnSpeed * dt
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
