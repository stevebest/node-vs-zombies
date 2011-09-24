Actor = require './Actor'
World = require '../shared/World'

clamp = (value, min, max) ->
  `value < min ? min : value > max ? max : value`

module.exports = class Player extends Actor

  COOLDOWN: 400

  SPEED = 3.0 / 1000
  TURN_SPEED = Math.PI / 1000

  constructor: (world) ->
    super world

    @health = 5
    @isFiring = false

  getState: ->
    state = super()
    state.name = @name
    state

  setInput: (@input) ->
    this
  
  update: (dt) ->
    @turn  dt if @input.left()
    @turn -dt if @input.right()

    @walk(if @input.up()   then  dt       else
          if @input.down() then -dt / 2.0 else 0)

    if @input.fire()
      @fire() if !@isFiring
    else
      @isFiring = (@fireTime + Player::COOLDOWN) > Date.now()

    @x = clamp @x, -World::SIZE, World::SIZE
    @y = clamp @y, -World::SIZE, World::SIZE

    this

  fire: ->
    console.log "PEW-PEW!"
    @fireTime = Date.now()
    @isFiring = true
    # TODO Actually shoot someone
    this
