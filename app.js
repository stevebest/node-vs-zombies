var express = require('express'),
    browserify = require('browserify'),
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
  app.use(browserify({
    require: __dirname + '/nvz/client',
    watch: true
  }));
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true })); 
});

app.configure('production', function() {
  app.use(browserify({
    require: __dirname + '/nvz/client',
    watch: false,
    // filter: require('uglify-js')
  }));
  app.use(express.errorHandler());
});


//
// Routes
//
app.get('/', function (req, res) {
  res.render('index');
});

app.listen(3000);
console.log("Express server listening on port %d in %s mode",
            app.address().port, app.settings.env);

//
// Socket.IO server
//
var io = sio.listen(app);

io.enable('browser client minification');    // send minified client
io.set('log level', 2);                      // reduce logging

io.configure('production', function() {
  io.enable('browser client minification');  // send minified client
  io.enable('browser client etag');          // apply etag caching logic based on version number
  io.set('log level', 1);                    // reduce logging
  io.set('transports', [                     // enable all transports (optional if you want flashsocket)
      'websocket'
    , 'flashsocket'
    , 'htmlfile'
    , 'xhr-polling'
    , 'jsonp-polling'
  ]);  
});

//
// World simulation
//
var nvz = require(__dirname + '/nvz/server');

var world = new nvz.WorldServer(io);

world.animate();
