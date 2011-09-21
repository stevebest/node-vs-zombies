Player = require '../shared/Player'

class PlayerGL extends Player

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
    @input.remove()

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


class HeroPlayerGL extends PlayerGL

  constructor: (world) ->
    super world

    @zlight = new THREE.PointLight 0xffffff, 1.0, 15.0
    @zlight.position.z = 5.0
    @scene.addLight @zlight

  update: (dt) ->
    super dt

    @zlight.position.x = @x
    @zlight.position.y = @y


module.exports = { PlayerGL, HeroPlayerGL }
