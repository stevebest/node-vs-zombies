/*
 Node vs Zombies
 Copyright, 2011, Stepan Stolyarov
*/

var socket = io.connect();

// socket.io specific code
var socket = io.connect();

socket.on('connect', function () {
  $('#login').addClass('connected');
});

socket.on('reconnect', function () {
});

socket.on('reconnecting', function () {
//  message('System', 'Attempting to re-connect to the server');
});

socket.on('error', function (e) {
//  message('System', e ? e : 'A unknown error occurred');
});

// dom manipulation
$(function () {
  $('#set-nickname').submit(function (ev) {
    socket.emit('nickname', $('#nick').val(), function (taken) {
      if (taken) {
        $('#nickname-err').css('visibility', 'visible');
      } else {
        $('#login').addClass('nickname-set');
        var nvz = new NodeVsZombiesUI($('#container'));
        nvz.animate();
      }
    });
    return false;
  });
});


/**
 * Reacts to keyboard events, saves them, and sends them to server.
 */
var KeyboardInput = (function() {
  
  function KeyboardInput() {
    this.keyState = [];
    [37, 38, 39, 40].forEach(function(i) {
      this.keyState[i] = false;
    }.bind(this));

    document.addEventListener('keydown', this.onKeyDown.bind(this), false);
    document.addEventListener('keyup', this.onKeyUp.bind(this), false);
  }

  KeyboardInput.prototype.onKeyDown = function(e) {
    if (this.keyState[e.keyCode]) return;

    this.keyState[e.keyCode] = true;
    socket.emit('keydown', e.keyCode);
  }

  KeyboardInput.prototype.onKeyUp = function(e) {
    this.keyState[e.keyCode] = false;
    socket.emit('keyup', e.keyCode);
  }

  KeyboardInput.prototype.left = function() {
    return this.keyState[37];
  }
  KeyboardInput.prototype.up = function() {
    return this.keyState[38];
  }
  KeyboardInput.prototype.right = function() {
    return this.keyState[39];
  }
  KeyboardInput.prototype.down = function() {
    return this.keyState[40];
  }

  return KeyboardInput;

})();


/**
 * Keeps player's state.
 */
var Player = (function() {

  // Speed of turning in radians per millisecond
  var TURN_SPEED = Math.PI / 1000.0;

  var SPEED = 3.0 / 1000.0;

  function Player() {
    this.position = { x: 0.0, y: 0.0, z: 0.0 };
    this.heading = Math.PI / 2;
  }

  Player.prototype.setInput = function(input) {
    this.input = input;
  }

  Player.prototype.update = function(dt) {
    if (this.input.left()) {
      this.turn(dt);
    }
    if (this.input.right()) {
      this.turn(-dt);
    }
    if (this.input.up()) {
      this.walk(dt);
    } else if (this.input.down()) {
      this.walk(-dt / 2);
    } else {
      this.idle(dt);
    }
  }

  Player.prototype.turn = function(dt) {
    this.heading += TURN_SPEED * dt;
  }

  Player.prototype.walk = function(dt) {
    var x = this.position.x + SPEED * Math.cos(this.heading) * dt,
        y = this.position.y + SPEED * Math.sin(this.heading) * dt;

    this.position.x = Math.min(10, Math.max(-10, x));
    this.position.y = Math.min(10, Math.max(-10, y));
  }

  Player.prototype.idle = function(dt) {
    // Do nothing.
  }

  return Player;

})();


/**
 * Represents player on a 3D scene
 */
var PlayerObject = (function() {

  var PLAYER_GEOMETRY = new THREE.CubeGeometry(0.4, 0.8, 1.7, 1, 1, 1);

  function PlayerObject(scene, player) {
    this.scene = scene;
    this.player = player;

    this.obj = new THREE.Mesh(
      PLAYER_GEOMETRY,
      new THREE.MeshLambertMaterial()
    );
    this.scene.addChild(this.obj);
  }

  PlayerObject.prototype.update = function () {
    this.obj.position.x = this.player.position.x;
    this.obj.position.y = this.player.position.y;

    this.obj.rotation.z = this.player.heading;
  }

  PlayerObject.prototype.remove = function () {
    this.scene.removeChild(this.obj);
  }

  return PlayerObject;

})();


/**
 * Creates and animates the 3D scene.
 */
var NodeVsZombiesUI = (function() {

  var ASPECT, FAR, HEIGHT, NEAR, VIEW_ANGLE, WIDTH;
  WIDTH = 720;
  HEIGHT = 475;
  VIEW_ANGLE = 45;
  ASPECT = WIDTH / HEIGHT;
  NEAR = 0.1;
  FAR = 100;

  function NodeVsZombiesUI(container) {
    this.t = Date.now();

    this.scene = new THREE.Scene();
    this.renderer = new THREE.WebGLRenderer();
    this.renderer.setSize(WIDTH, HEIGHT);
    this.camera = new THREE.Camera(VIEW_ANGLE, ASPECT, NEAR, FAR);
    container.append(this.renderer.domElement);

    this.camera.position = { x: 0.0, y: -20.0, z: 10.0 };
    this.camera.up = { x: 0.0, y: 0.0, z: 1.0 };

    var ambient = new THREE.AmbientLight(0x333355);
    this.scene.addLight(ambient);

    var zlight = new THREE.PointLight(0xcccccc);
    zlight.position.z = 100.0;
    this.scene.addLight(zlight);

    this.players = {};

    this.hero = new Player();
    this.heroObject = new PlayerObject(this.scene, this.hero);

    this.hero.setInput(new KeyboardInput());
  }

  NodeVsZombiesUI.prototype.animate = function() {
    requestAnimationFrame(this.animate.bind(this));
    this.simulate();
    this.renderer.clear();
    return this.renderer.render(this.scene, this.camera);
  };

  NodeVsZombiesUI.prototype.simulate = function() {
    var dt = Math.min(Date.now() - this.t, 1000);
    var t = (this.t += dt);

    this.hero.update(dt);
    this.heroObject.update();
  };

  return NodeVsZombiesUI;

})();
