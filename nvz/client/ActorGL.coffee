
module.exports = class ActorGL

  MATERIAL = new THREE.MeshLambertMaterial

  GEOMETRY: {
    player: new THREE.CubeGeometry(1, 1, 1)
    zombie: new THREE.CubeGeometry(1, 1, 1)
  }

  # Animation duration
  duration = 1000
  keyframes = 8
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
    time = Date.now() % duration

    keyframe = Math.floor(time / interpolation)

    if keyframe != @currentKeyframe
      @object.morphTargetInfluences[@lastKeyframe] = 0
      @object.morphTargetInfluences[@currentKeyframe] = 1
      @object.morphTargetInfluences[keyframe] = 0

      @lastKeyframe = @currentKeyframe
      @currentKeyframe = keyframe

    @object.morphTargetInfluences[keyframe] = (time % interpolation) / interpolation
    @object.morphTargetInfluences[@lastKeyframe] = 1 - @object.morphTargetInfluences[keyframe]

    this

  # Assets
  loader = new THREE.JSONLoader false

  loader.load model: '/images/Dude-with-gun.js', callback: (geometry) ->
    ActorGL::GEOMETRY.player = geometry
    MATERIAL = geometry.materials[0][0]

  loader.load model: '/images/Dude-walk.js', callback: (geometry) ->
    ActorGL::GEOMETRY.zombie = geometry
