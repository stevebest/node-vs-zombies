Actor = require './Actor'
Hashtable = require './Hashtable'

module.exports = class World

  # The origin of the world
  ORIGIN: { x: 0, y: 0 }

  # World is square, spanning from -SIZE to SIZE on both axis
  SIZE: 32.0;

  constructor: ->
    @players = new Hashtable
    @zombies = new Hashtable
    @t = Date.now()

  getSize: -> World::SIZE

  addPlayer: (name, player) ->
    @players.put name, player

  getPlayer: (name) ->
    @players.get name

  removePlayer: (name) ->
    player = @players.delete name
    player.die() if player
    player

  addZombie: (zombie) ->
    @zombies.put zombie.id, zombie

  getZombie: (id) ->
    @zombies.get id

  simulate: ->
    t = Date.now()
    dt = Math.min t - @t, 1000
    @t = t

    Actor.updateCollisions()

    @players.forEach (name, player) ->
      player.update dt

    @zombies.forEach (id, zombie) ->
      zombie.update dt
