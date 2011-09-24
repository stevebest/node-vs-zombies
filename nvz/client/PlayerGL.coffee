ActorGL = require './ActorGL'
Player = require '../shared/Player'


class PlayerGL extends ActorGL

  duration = 1000
  keyframes = 8
  interpolation = duration / keyframes

  constructor: (world) ->
    super world, new Player(world)

  getGeometry: -> ActorGL::GEOMETRY.player

  setInput: (input) ->
    @actor.setInput input

  getKeyframe: ->
    time = Date.now() % duration

    if @isRunning()
      keyframe = Math.floor(time / interpolation)
      tween = (time % interpolation) / interpolation
    else
      keyframe = 1
      tween = 0

    return { keyframe, tween }

  isRunning: -> @actor.input.up()

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
