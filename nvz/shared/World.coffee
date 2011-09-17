Hashtable = require './Hashtable'

module.exports = class World
  constructor: ->
    @players = new Hashtable

  addPlayer: (name, player) ->
    @players.put name, player

  removePlayer: (name) ->
    @players.delete name

  simulate: ->
    t = Date.now()
    dt = Math.min t - @t, 1000
    @t = t

    @players.forEach (name, player) ->
      player.update dt
