
World = require '../shared/World'
Player = require '../shared/Player'

SocketInput = require './SocketInput'
Message = require '../shared/Message'

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
    
    setInterval @updateAllPlayers.bind(this), SYNC_INTERVAL

    # let's have some fun
    @spawnZombies WorldServer::ZOMBIES_AT_START

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

    socket.on 'disconnect', =>
      @removePlayer socket.nickname
      socket.broadcast.emit Message::LEAVE, socket.nickname

  # Tries to create a new player with a given name
  # @return true, if the name is already taken
  joinPlayer: (nick, socket) ->
    console.log "Player #{nick} tries to join the party"
    if @getPlayer nick
      return true
    else
      # let's have some fun
      # @spawnZombies WorldServer::ZOMBIES_PER_NEW_PLAYER, World::ORIGIN, World::SIZE, World::SIZE

      player = @createPlayer nick, socket
      @placePlayer player
      @addPlayer nick, player

      @updatePlayer player
      @updateAllPlayers()
      return false

  createPlayer: (nick, socket) ->
    player = new Player this
    player.setInput new SocketInput(socket)
    socket.nickname = nick
    socket.player = player
    player.socket = socket

  # Picks a relatively safe, but crowded place for the player
  placePlayer: (player) ->
    coordinates = x: 0.0, y: 0.0
    player.setLocation coordinates

  # Update client with the recent state of the world around
  updatePlayer: (player) ->
    # TODO Only send nearby fellow players and zombies to a player
    players = @players.invoke 'getState'
    zombies = @zombies.invoke 'getState'
    player.socket.emit Message::UPDATE, players, zombies

  updateAllPlayers: ->
    @io.sockets.emit Message::PLAYERS, @players.invoke('getState')

  # Spawns {n} zombies near {location},
  # no closer than {min} meters,
  # and no farther than {max} meters away.
  spawnZombies: (n, location, min, max) ->
    zombies = spawnZombie location for i in [1..n]

  # Spawns a zombie near a given {location},
  # no closer than {min} meters,
  # and no farther than {max} meters away.
  spawnZombie: (location, min, max) ->
    zombie = new Zombie this
    phi = 2 * Math.PI * Math.random()
    rho = Math.random() * (max - min) + min
    zombie.x = location.x + rho * Math.sin(phi)
    zombie.y = location.y + rho * Math.sin(phi)
    @addZombie zombie
