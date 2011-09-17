
World = require '../shared/World'
Player = require '../shared/Player'
PlayerGL = require './PlayerGL'
KeyboardInput = require './KeyboardInput'

module.exports = class WorldGL extends World

  WIDTH = 720
  HEIGHT = 475
  VIEW_ANGLE = 45
  ASPECT = WIDTH / HEIGHT
  NEAR = 0.1
  FAR = 100

  constructor: (container, heroName) ->
    super()

    @t = Date.now()

    @scene = new THREE.Scene

    @renderer = new THREE.WebGLRenderer
    @renderer.setSize WIDTH, HEIGHT;
    container.append @renderer.domElement

    @camera = new THREE.Camera(VIEW_ANGLE, ASPECT, NEAR, FAR)
    @camera.position = { x: 0.0, y: -20.0, z: 10.0 }
    # Z axis is up. Default Y up is STUPID!
    @camera.up = { x: 0.0, y: 0.0, z: 1.0 }

    ambient = new THREE.AmbientLight(0x333355)
    @scene.addLight ambient

    zlight = new THREE.PointLight(0xcccccc)
    zlight.position.z = 100.0
    @scene.addLight zlight

    @hero = new PlayerGL this
    @hero.setInput new KeyboardInput
    @addPlayer heroName, @hero

    socket.on 'nicknames', (players) =>
      for name in players
        do (name) ->
          if undefined == @players.get name
            player = new Player this
            player.setInput new SocketInput name
            @addPlayer name, player

      return null # do not collect the comprehension result

    socket.on 'leave', (name) =>
      @removePlayer name
  
  animate: ->
    requestAnimationFrame @animate.bind(this)
    @simulate()
    @renderer.render @scene, @camera
