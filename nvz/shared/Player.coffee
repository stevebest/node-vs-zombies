Actor = require './Actor'

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
      @idle

    this

  shoot: ->
    this
