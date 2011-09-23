Actor = require './Actor'

G = require './Geometry'

randomAngle = G.randomAngle

module.exports = class Zombie extends Actor

  AGGRO_DISTANCE: 5.0
  MAX_AGGRO_DISTANCE: 20.0

  constructor: (world, @id) ->
    super world

    @speed = (1.0 + Math.random())/ 1000

    # MUST EAT HIM BRAAAINS!
    @player = null

  getState: ->
    state = super()
    state.targetHeading = @targetHeading
    state

  setState: (state) ->
    super state
    @targetHeading = state.targetHeading
    this

  update: (dt) ->
    super dt

    @findPlayer()   if !@player

    if @player
      @chasePlayer dt
    else
      @changeHeading dt
      @walk dt / 2

  attack: (player) ->
    # TODO
    this

  findPlayer: ->
    @player = @world.players.find (player) =>
      @distanceTo(player) < Zombie::AGGRO_DISTANCE

  chasePlayer: (dt) ->
    @targetHeading = @headingTo @player
    @changeHeading dt

    @walk dt
    @attack @player if 0 # TODO very close to player

    @losePlayer() if @player.isDead() or
                     @distanceTo(@player) > Zombie::MAX_AGGRO_DISTANCE

    this

  losePlayer: ->
    @targetHeading = randomAngle()
    @player = null
