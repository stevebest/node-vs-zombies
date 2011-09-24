
ActorGL = require './ActorGL'
Zombie = require '../shared/Zombie'

module.exports = class ZombieGL extends ActorGL

  constructor: (world, @id) ->
    super world, new Zombie(world, id)

  getGeometry: -> ActorGL::GEOMETRY.zombie
