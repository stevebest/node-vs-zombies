Actor = require './Actor'

G = require './Geometry'

randomAngle = G.randomAngle
clampAngle = G.clampAngle
isEast = G.isEast
isWest = G.isWest
isNorth = G.isNorth
isSouth = G.isSouth

module.exports = class Zombie extends Actor

  AGGRO_DISTANCE: 5.0
  MAX_AGGRO_DISTANCE: 20.0

  constructor: (world, @id) ->
    super world

    @speed = (1.0 + 0.4 * Math.random()) / 1000

    # MUST EAT HIM BRAAAINS!
    @player = null

  getState: ->
    state = super()
    state.targetHeading = @targetHeading
    state.targetName = @player.name if @player
    state

  setState: (state) ->
    super state
    @targetHeading = state.targetHeading

    player = @world.getPlayer state.targetName
    @player = player if !!player

    this

  update: (dt) ->
    super dt

    @findPlayer()   if !@player

    if @player
      @chasePlayer dt
    else
      @changeHeading dt
      @walk dt / 2

    # World boundary check
    worldSize = @world.getSize()
    if (@x < -worldSize) and isWest(@heading)
      @targetHeading = clampAngle(Math.PI - @heading) if isWest(@targetHeading)
    if (@x > worldSize) and isEast(@heading)
      @targetHeading = clampAngle(Math.PI - @heading) if isEast(@targetHeading)

    if (@y < -worldSize) and isSouth(@heading)
      @targetHeading = clampAngle(-@heading) if isSouth(@targetHeading)
    if (@y > worldSize) and isNorth(@heading)
      @targetHeading = clampAngle(-@heading) if isNorth(@targetHeading)

    this

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
