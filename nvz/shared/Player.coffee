Actor = require './Actor'
World = require '../shared/World'

clamp = (value, min, max) ->
  `value < min ? min : value > max ? max : value`

module.exports = class Player extends Actor

  SPEED = 3.0 / 1000
  TURN_SPEED = Math.PI / 1000

  constructor: (world) ->
    super world

    @health = 5

  setInput: (@input) ->
    this
  
  update: (dt) ->
    @turn  dt if @input.left()
    @turn -dt if @input.right()

    if @input.up()
      @walk dt
    else if @input.down()
      @walk -dt / 2.0
    else
      @idle()

    @x = clamp @x, -World::SIZE, World::SIZE
    @y = clamp @y, -World::SIZE, World::SIZE

    this

  shoot: ->
    this
