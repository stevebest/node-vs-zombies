Actor = require './Actor'

module.exports = class Zombie extends Actor

  AGGRO_DISTANCE: 10.0
  MAX_AGGRO_DISTANCE: 30.0

  constructor: (world, @id) ->
    super world

    @speed = 1.0 / 1000

    # MUST EAT HIM BRAAAINS!
    @player = null

  update: (dt) ->
    super dt

    @findPlayer()   if !@player
    @chasePlayer dt if  @player

  attack: (player) ->
    # TODO
    this

  findPlayer: ->
    @player = @world.players.find (player) =>
      @distanceTo(player) < Zombie::AGGRO_DISTANCE

  chasePlayer: (dt) ->
    @changeHeading @player, dt

    @walk dt
    @attack @player if 0 # TODO very close to player

    @player = null if @player.isDead() or @distanceTo(@player) > Zombie::MAX_AGGRO_DISTANCE
