ActorGL = require './ActorGL'
Player = require '../shared/Player'


class PlayerGL extends ActorGL

  constructor: (world) ->
    super world, new Player(world)

  setInput: (input) ->
    @actor.setInput input


class HeroPlayerGL extends PlayerGL

  constructor: (world) ->
    super world

    @zlight = new THREE.PointLight 0xffffff, 1.0, 15.0
    @zlight.position.z = 5.0
    @scene.addLight @zlight

  update: (dt) ->
    super dt

    @zlight.position.x = @actor.x
    @zlight.position.y = @actor.y


module.exports = { PlayerGL, HeroPlayerGL }
