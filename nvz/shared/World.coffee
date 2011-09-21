Hashtable = require './Hashtable'

clamp = (value, min, max) ->
  `value < min ? min : value > max ? max : value`

module.exports = class World

  # The origin of the world
  ORIGIN: { x: 0, y: 0 }

  # World is square, spanning from -SIZE to SIZE on both axis
  SIZE: 64.0;

  constructor: ->
    @actors = []
    @players = new Hashtable
    @zombies = new Hashtable

  addPlayer: (name, player) ->
    @players.put name, player
    @actors.push player

  getPlayer: (name) ->
    @players.get name

  removePlayer: (name) ->
    player = @players.delete name
    delete @actors[@actors.indexOf player] if player
    player

  addZombie: (zombie) ->
    @zombies.put zombie.id, zombie

  getZombie: (id) ->
    @zombies.get id

  simulate: ->
    t = Date.now()
    dt = Math.min t - @t, 1000
    @t = t

    @players.forEach (name, player) ->
      player.update dt
      player.x = clamp player.x, -World::SIZE, World::SIZE
      player.y = clamp player.y, -World::SIZE, World::SIZE
