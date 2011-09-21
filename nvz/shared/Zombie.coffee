Actor = require './Actor'

module.exports = class Zombie extends Actor

  constructor: (world, @id) ->
    super world

    @speed = 1.0 / 1000

  walk: (dt) ->
    if 0 # near player
      @attack player
