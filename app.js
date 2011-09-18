var express = require('express'),
    browserify = require('browserify');

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

// Routes

app.get('/', function (req, res) {
  res.render('index');
});

app.listen(3000);
console.log("Express server listening on port %d in %s mode",
            app.address().port, app.settings.env);

// World simulation

var nvz = require(__dirname + '/nvz/server'),
    sio = require('socket.io');

var world = new nvz.WorldServer(sio.listen(app));

world.animate();
