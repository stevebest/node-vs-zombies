
World = require '../shared/World'
Player = require '../shared/Player'

SocketInput = require './SocketInput'
Message = require '../shared/Message'

# The framerate at which the server updates the world
SERVER_FRAMERATE = 30

# The interval at which the server performs the full
# world synchronisation with the clients
SYNC_INTERVAL = 5000

# Just to be fancy, we'll call `setTimeout` the same as on the client
requestAnimationFrame = (callback) ->
  setTimeout callback, 1000 / SERVER_FRAMERATE


module.exports = class WorldServer extends World

  constructor: (@io) ->
    super()
    world = this

    @io.sockets.on 'connection', @acceptConnection.bind(this)
    
    setInterval @updateAllPlayers.bind(this), SYNC_INTERVAL

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
      @createPlayer nick, socket
      return false
  
  createPlayer: (nick, socket) ->
    player = new Player this
    player.setInput new SocketInput(socket)
    socket.nickname = nick
    @addPlayer nick, player
    @updateAllPlayers

  updateAllPlayers: ->
    @io.sockets.emit Message::PLAYERS, @players.invoke('getState')
