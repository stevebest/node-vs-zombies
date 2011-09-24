

World = require '../shared/World'

{ PlayerGL, HeroPlayerGL } = require './PlayerGL'
ZombieGL = require './ZombieGL'
KeyboardInput = require './KeyboardInput'
SocketInput = require './SocketInput'
Message = require '../shared/Message'
Hashtable = require '../shared/Hashtable'

ThirdPersonCamera = require './ThirdPersonCamera'

module.exports = class WorldGL extends World

  GEOMETRY = new THREE.PlaneGeometry World::SIZE, World::SIZE, 100, 100
  MATERIAL = new THREE.MeshLambertMaterial color: 0x774422

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

    @initPlayer heroName

    @initGround()

    # Set up camera
    @camera = new ThirdPersonCamera(
      fov:    VIEW_ANGLE
      aspect: container.width() / container.height()
      near:   NEAR
      far:    FAR
      target: @hero.object
      min:    7
      max:    10
      height: 5
    )
    # Z axis is up. Default Y up is STUPID!
    @camera.up = x: 0.0, y: 0.0, z: 1.0

    socket.on Message::UPDATE, (message) =>
      console.log "UPDATE", message
      { players, zombies } = message
      @updatePlayers players
      @updateZombies zombies

    socket.on Message::JOIN, (player) =>
      console.log "JOIN", player
      @updatePlayer player

    socket.on Message::LEAVE, (name) =>
      console.log "LEAVE", name
      @removePlayer name

    # Update SocketInput, too
    socket.on Message::KEYDOWN, SocketInput.keyDown
    socket.on Message::KEYUP, SocketInput.keyUp

  initPlayer: (name) ->
    @hero = new HeroPlayerGL this
    @hero.setInput new KeyboardInput
    @addPlayer name, @hero

  initGround: ->
    @ground = new THREE.Mesh GEOMETRY, MATERIAL
    @scene.addChild @ground

    ambient = new THREE.AmbientLight 0x222233
    @scene.addLight ambient

  removePlayer: (name) ->
    player = super name
    player.remove()

  animate: ->
    requestAnimationFrame @animate.bind(this)
    @simulate()

    @ground.position.x = Math.floor(@hero.x / 2) * 2
    @ground.position.y = Math.floor(@hero.y / 2) * 2

    @renderer.render @scene, @camera

  updatePlayers: (players) ->
    (new Hashtable players).forEach (name, state) =>
      player = @getPlayer name
      if !player
        player = new PlayerGL this
        player.setInput new SocketInput name
        @addPlayer name, player
      player.setState state
      player.update 0

  updatePlayer: (state) ->
    player = @getPlayer state.name
    if !player
      player = new PlayerGL this
      player.setInput new SocketInput name
      @addPlayer name, player
    player.setState state
    player.update 0

  updateZombies: (zombies) ->
    (new Hashtable zombies).forEach (id, state) =>
      zombie = @getZombie id
      if !zombie
        zombie = new ZombieGL this, id
        @addZombie zombie
      zombie.setState state
      zombie.update 0


  # Asset loading

  loader = new THREE.JSONLoader false
  loader.load model: '/images/Floor.js', callback: (geometry) ->
    GEOMETRY = geometry
    MATERIAL = geometry.materials[0]
