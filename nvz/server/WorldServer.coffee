
World = require '../shared/World'
Player = require '../shared/Player'
Zombie = require '../shared/Zombie'

SocketInput = require './SocketInput'
Message = require '../shared/Message'

Hashtable = require '../shared/Hashtable'
G = require '../shared/Geometry'

# The framerate at which the server updates the world
SERVER_FRAMERATE = 60

# The interval at which the server performs the full
# world synchronisation with the clients
SYNC_INTERVAL = 5000

# Just to be fancy, we'll call `setTimeout` the same as on the client
requestAnimationFrame = (callback) ->
  setTimeout callback, 1000 / SERVER_FRAMERATE


module.exports = class WorldServer extends World

  # Number of zombies permanently present in the world
  ZOMBIES_AT_START: 100

  # Additional number of zombies arrearing when new player joins the game
  ZOMBIES_PER_NEW_PLAYER: 10

  constructor: (@io) ->
    super()
    world = this

    @io.sockets.on 'connection', @acceptConnection.bind(this)

#    setInterval @updateAllPlayers.bind(this), SYNC_INTERVAL

    @addInitialZombies()

  animate: ->
    requestAnimationFrame @animate.bind(this)
    @simulate()

  acceptConnection: (socket) ->
    # Broadcast a keyup to everyone
    socket.on Message::KEYDOWN, (keyCode) =>
      socket.broadcast.emit Message::KEYDOWN, socket.nickname, keyCode

    # Broadcast a keyup to everyone
    socket.on Message::KEYUP, (keyCode) =>
      socket.broadcast.emit Message::KEYUP, socket.nickname, keyCode

    socket.on Message::JOIN, (nick, callback) =>
      callback @joinPlayer(nick, socket)

    socket.on Message::UPDATE, =>
      @updatePlayer socket.player

    socket.on 'disconnect', =>
      @removePlayer socket.nickname
      socket.broadcast.emit Message::LEAVE, socket.nickname

    this

  ###
   Tries to create a new player with a given name
   @return true, if the name is already taken
  ###
  joinPlayer: (nick, socket) ->
    console.log "Player #{nick} tries to join the party"
    if @getPlayer nick
      return true
    else
      player = @createPlayer nick, socket
      @placePlayer player
      @addPlayer nick, player

      process.nextTick =>
        @updatePlayer player
        @broadcastJoin player

      return false

  createPlayer: (nick, socket) ->
    player = new Player this
    player.setInput new SocketInput(socket)
    socket.nickname = nick
    player.name = nick
    socket.player = player
    player.socket = socket
    return player

  ###
   Picks a relatively safe, but crowded place for the player
  ###
  placePlayer: (player) ->
    coordinates = x: 0.0, y: 0.0
    player.setLocation coordinates
    return coordinates

  ###
   Update client with the recent state of the world around
  ###
  updatePlayer: (player) ->
    # TODO Only send nearby fellow players and zombies to a player
    players = @players.invoke 'getState'
    zombies = @zombies.invoke 'getState'
    player.socket.emit Message::UPDATE, { players, zombies }

  broadcastJoin: (player) ->
    @io.sockets.emit Message::JOIN, player.getState()

  removePlayer: (name) ->
    super name
    if @players.isEmpty()
      @addInitialZombies()

  addInitialZombies: ->
    @zombies = new Hashtable
    @spawnZombies WorldServer::ZOMBIES_AT_START

  spawnZombies: (n) ->
    zombies = (@spawnZombie() for i in [1..n])

  spawnZombie: ->
    zombie = new Zombie this, Math.floor(Math.random() * 0x7fffffff)

    zombie.x = G.randomPosition @getSize()
    zombie.y = G.randomPosition @getSize()
    zombie.heading = G.randomAngle()
    zombie.targetHeading = zombie.heading

    @addZombie zombie
