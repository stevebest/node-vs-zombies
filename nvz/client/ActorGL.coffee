
module.exports = class ActorGL

  GEOMETRY = new THREE.CubeGeometry(0.4, 0.8, 1.7 * 2, 1, 1, 1)
  MATERIAL = new THREE.MeshLambertMaterial

  constructor: (@world, @actor) ->
    @scene = @world.scene

    @object = new THREE.Mesh GEOMETRY, MATERIAL
    @object.position.z = 0
    @scene.addChild @object

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

    this

  # Assets
  loader = new THREE.JSONLoader false
  loader.load model: '/images/Dude.js', callback: (geometry) ->
    GEOMETRY = geometry
    MATERIAL = geometry.materials[0]
