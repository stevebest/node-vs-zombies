
module.exports = class ActorGL

  GEOMETRY = new THREE.CubeGeometry(0.4, 0.8, 1.7 * 2, 1, 1, 1)
  MATERIAL = new THREE.MeshLambertMaterial

  # Animation duration
  duration = 1500
  keyframes = 6
  interpolation = duration / keyframes

  constructor: (@world, @actor) ->
    @scene = @world.scene

    material = new THREE.MeshLambertMaterial({color: 0x606060, morphTargets: true})

    @object = new THREE.Mesh GEOMETRY, material
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
  loader.load model: '/images/Dude-walk.js', callback: (geometry) ->
    GEOMETRY = geometry
    MATERIAL = new THREE.MeshLambertMaterial({color: 0x606060, morphTargets: true})
    #geometry.materials[0][0].morphTargets = true
    #MATERIAL = geometry.materials[0][0]
