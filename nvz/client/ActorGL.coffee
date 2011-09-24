
module.exports = class ActorGL

  MATERIAL = new THREE.MeshLambertMaterial

  GEOMETRY: {
    player: new THREE.CubeGeometry(1, 1, 1)
    zombie: new THREE.CubeGeometry(1, 1, 1)
  }

  # Animation duration
  duration = 1500
  keyframes = 7
  interpolation = duration / keyframes

  constructor: (@world, @actor) ->
    @scene = @world.scene

    material = new THREE.MeshLambertMaterial(
      color: 0xaaaaaa
      morphTargets: true
      map: MATERIAL.map
    )

    @object = new THREE.Mesh @getGeometry(), material
    @object.position.z = 0
    @scene.addChild @object

    @lastKeyframe = 0
    @currentKeyframe = 0

  getState: ->
    @actor.getState()

  setState: (state) ->
    @actor.setState state

  die: ->
    @actor.die()

  isDead: ->
    @actor.isDead()

  getPosition: ->
    @actor.getPosition

  setPosition: (position) ->
    @actor.setPosition position

  remove: ->
    @scene.removeChild @object

  update: (dt) ->
    @actor.update dt

    @x = @object.position.x = @actor.x
    @y = @object.position.y = @actor.y
    @heading = @actor.heading

    @object.rotation.z = @actor.heading + (Math.PI / 2)

    # Alternate morph targets to animate the dude
    { keyframe, tween } = @getKeyframe()

    if keyframe != @currentKeyframe
      @object.morphTargetInfluences[@lastKeyframe] = 0
      @object.morphTargetInfluences[@currentKeyframe] = 1
      @object.morphTargetInfluences[keyframe] = 0

      @lastKeyframe = @currentKeyframe
      @currentKeyframe = keyframe

    @object.morphTargetInfluences[keyframe]      = tween
    @object.morphTargetInfluences[@lastKeyframe] = 1 - tween

    this

  getKeyframe: ->
    time = Date.now() % duration
    return {
      keyframe: Math.floor(time / interpolation)
      tween: (time % interpolation) / interpolation
    }

  # Assets
  loader = new THREE.JSONLoader false

  loader.load model: '/images/Dude-with-gun.js', callback: (geometry) ->
    ActorGL::GEOMETRY.player = geometry
    MATERIAL = geometry.materials[0][0]

  loader.load model: '/images/Dude-walk.js', callback: (geometry) ->
    ActorGL::GEOMETRY.zombie = geometry
