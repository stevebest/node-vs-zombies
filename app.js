var express = require('express'),
    sio = require('socket.io');

var app = module.exports = express.createServer();

// Configuration

app.configure(function() {
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser());
  app.use(express.session({ secret: 'yo mama is fat' }));
  app.use(app.router);
  app.use(express.static(__dirname + '/public'));
});

app.configure('development', function() {
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true })); 
});

app.configure('production', function() {
  app.use(express.errorHandler());
});

// Routes

app.get('/', function (req, res) {
  res.render('index');
});

app.listen(3000);
console.log("Express server listening on port %d in %s mode",
            app.address().port, app.settings.env);

// Socket.IO server

var io = sio.listen(app), nicknames = {};

io.sockets.on('connection', function (socket) {

  socket.on('keydown', function (keyCode) {
    socket.broadcast.emit('keydown', socket.nickname, keyCode);
  });

  socket.on('keyup', function (keyCode) {
    socket.broadcast.emit('keyup', socket.nickname, keyCode);
  });

  socket.on('nickname', function (nick, fn) {
    if (nicknames[nick]) {
      fn(true);
    } else {
      fn(false);
      nicknames[nick] = socket.nickname = nick;
      io.sockets.emit('nicknames', nicknames);
    }
  });

  socket.on('disconnect', function () {
    if (!socket.nickname) return;

    delete nicknames[socket.nickname];
    socket.broadcast.emit('leave', socket.nickname);
    socket.broadcast.emit('nicknames', nicknames);
  });

});
