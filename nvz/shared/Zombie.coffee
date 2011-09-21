Actor = require './Actor'

module.exports = class Zombie extends Actor

  constructor: (world, @id) ->
    super world

    @speed = 1.0 / 1000

    # MUST EAT HIM BRAAAINS!
    @player = null

  update: (dt) ->
    super dt

    @findPlayer  if @player == null
    @chasePlayer if @player != null

  attack: (player) ->
    # TODO
    this

  findPlayer: ->
    # TODO
    this

  chasePlayer: ->
    @walk dt
    @attack player if 0 # TODO very close to player

    @player = null if @player.isDead()
