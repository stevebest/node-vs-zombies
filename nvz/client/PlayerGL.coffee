Player = require '../shared/Player'

module.exports = class PlayerGL extends Player

  PLAYER_GEOMETRY = new THREE.CubeGeometry(0.4, 0.8, 1.7, 1, 1, 1)

  constructor: (world) ->
    super world

    @scene = world.scene

    material = new THREE.MeshLambertMaterial
    @object = new THREE.Mesh PLAYER_GEOMETRY, material
    @scene.addChild @object

  remove: ->
    @scene.removeChild @object
    @input.remove()

  update: (dt) ->
    super dt

    @object.position.x = @position.x
    @object.position.y = @position.y

    @object.rotation.z = @heading

    this
