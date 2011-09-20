Hashtable = require './Hashtable'

clamp = (value, min, max) ->
  `value < min ? min : value > max ? max : value`

module.exports = class World

  SIZE: 64.0;

  constructor: ->
    @players = new Hashtable

  addPlayer: (name, player) ->
    @players.put name, player

  getPlayer: (name) ->
    @players.get name

  removePlayer: (name) ->
    @players.delete name

  simulate: ->
    t = Date.now()
    dt = Math.min t - @t, 1000
    @t = t

    @players.forEach (name, player) ->
      player.update dt
      player.position.x = clamp player.position.x, -World::SIZE, World::SIZE
      player.position.y = clamp player.position.y, -World::SIZE, World::SIZE
