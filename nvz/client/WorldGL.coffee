

World = require '../shared/World'

PlayerGL = require './PlayerGL'
KeyboardInput = require './KeyboardInput'
SocketInput = require './SocketInput'
Message = require '../shared/Message'
Hashtable = require '../shared/Hashtable'

module.exports = class WorldGL extends World

  WIDTH = 720
  HEIGHT = 475
  VIEW_ANGLE = 45
  ASPECT = WIDTH / HEIGHT
  NEAR = 0.1
  FAR = 100

  constructor: (container, socket, heroName) ->
    super()

    @t = Date.now()

    @scene = new THREE.Scene

    @renderer = new THREE.WebGLRenderer antialias: true
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

    socket.on Message::PLAYERS, (players) =>
      (new Hashtable players).forEach (name, state) =>
        player = @getPlayer name
        if undefined == player
          player = new PlayerGL this
          player.setInput new SocketInput name
          @addPlayer name, player
        player.setState state

      return null # do not collect the comprehension result

    socket.on Message::LEAVE, (name) =>
      console.log "Removing player #{name}"
      @removePlayer name

    # Update SocketInput, too
    socket.on Message::PLAYERS, SocketInput.update
    socket.on Message::KEYDOWN, SocketInput.keyDown
    socket.on Message::KEYUP, SocketInput.keyUp
    socket.on Message::LEAVE, SocketInput.leave

  removePlayer: (name) ->
    player = super(name)
    @scene.removeChild player.object if player

  animate: ->
    requestAnimationFrame @animate.bind(this)
    @simulate()
    @renderer.render @scene, @camera
