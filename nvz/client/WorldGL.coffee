

World = require '../shared/World'

PlayerGL = require './PlayerGL'
KeyboardInput = require './KeyboardInput'
SocketInput = require './SocketInput'
Message = require '../shared/Message'
Hashtable = require '../shared/Hashtable'

ThirdPersonCamera = require './ThirdPersonCamera'

module.exports = class WorldGL extends World

  VIEW_ANGLE = 45
  NEAR = 0.1
  FAR = 100

  constructor: (container, socket, heroName) ->
    super()

    @t = Date.now()

    @scene = new THREE.Scene

    @renderer = new THREE.WebGLRenderer antialias: true
    @renderer.setSize container.width(), container.height()
    container.append @renderer.domElement

    @hero = new PlayerGL this
    @hero.setInput new KeyboardInput
    @addPlayer heroName, @hero

    groundMaterial = new THREE.MeshLambertMaterial color: 0x774422
    ground = new THREE.Mesh(
      new THREE.PlaneGeometry World::SIZE, World::SIZE, 100, 100
      groundMaterial
    )
    @scene.addChild ground

    ambient = new THREE.AmbientLight 0x222233
    @scene.addLight ambient

    # This meant to be player overhead light
    zlight = new THREE.PointLight 0xffffff, 0.5, 10.0
    zlight.position.z = 2.5
    @scene.addLight zlight

    # Set up camera
    @camera = new ThirdPersonCamera(
      fov:    VIEW_ANGLE
      aspect: container.width() / container.height()
      near:   NEAR
      far:    FAR
      target: @hero.object
    )
    # Z axis is up. Default Y up is STUPID!
    @camera.up = x: 0.0, y: 0.0, z: 1.0

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

  removePlayer: (name) ->
    player = super name
    player.remove()

  animate: ->
    requestAnimationFrame @animate.bind(this)
    @simulate()
    @renderer.render @scene, @camera
