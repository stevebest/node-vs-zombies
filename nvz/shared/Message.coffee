# Messages

module.exports = class Message

  # Keyboard input events
  KEYDOWN: 'keydown'
  KEYUP:   'keyup'

  # List of players, list of zombies
  UPDATE:  'update'

  # A new player joins the game
  JOIN:    'nickname'

  # A player quits the game
  LEAVE:   'leave'
