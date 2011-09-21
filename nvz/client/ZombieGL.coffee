
Zombie = require '../shared/Zombie'

module.exports = class ZombieGL extends Zombie

  GEOMETRY = new THREE.CubeGeometry(0.4, 0.8, 1.7 * 2, 1, 1, 1)
  MATERIAL = new THREE.MeshLambertMaterial

  constructor: (world) ->
    super world

    @scene = world.scene

    @object = new THREE.Mesh GEOMETRY, MATERIAL

    @object.position.z = 0

    @scene.addChild @object

  remove: ->
    @scene.removeChild @object

  update: (dt) ->
    super dt

    @object.position.x = @x
    @object.position.y = @y

    @object.rotation.z = @heading

    this

  loader = new THREE.JSONLoader false
  loader.load model: '/images/Dude.js', callback: (geometry) ->
    GEOMETRY = geometry
    MATERIAL = geometry.materials[0]
