/*
 Node vs Zombies
 Copyright, 2011, Stepan Stolyarov
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
    this.keyState[e.keyCode] = true;
    console.log(e.keyCode);
  }

  KeyboardInput.prototype.onKeyUp = function(e) {
    this.keyState[e.keyCode] = false;
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


var Player = (function() {

  // Speed of turning in radians per millisecond
  var TURN_SPEED = Math.PI / 1000.0;

  var SPEED = 2.0 / 1000.0;

  function Player() {
    this.position = { x: 0.0, y: 0.0, z: 0.0 };
    this.heading = Math.PI / 2;
  }

  Player.prototype.turn = function(dt) {
    this.heading += TURN_SPEED * dt;
  }

  Player.prototype.walk = function(dt) {
    this.position.x += SPEED * Math.cos(this.heading) * dt;
    this.position.y += SPEED * Math.sin(this.heading) * dt;
  }

  Player.prototype.idle = function(dt) {
    // Do nothing.
  }

  return Player;

})();


var NodeVsZombies;
NodeVsZombies = (function() {

  var ASPECT, FAR, HEIGHT, NEAR, VIEW_ANGLE, WIDTH;
  WIDTH = 720;
  HEIGHT = 475;
  VIEW_ANGLE = 45;
  ASPECT = WIDTH / HEIGHT;
  NEAR = 0.1;
  FAR = 100;

  function NodeVsZombies(container) {
    this.t = Date.now();

    this.container = container;

    this.keyboard = new KeyboardInput();

    this.player = new Player();

    this.scene = new THREE.Scene();
    this.renderer = new THREE.WebGLRenderer();
    this.renderer.setSize(WIDTH, HEIGHT);
    this.container.append(this.renderer.domElement);
    this.camera = new THREE.Camera(VIEW_ANGLE, ASPECT, NEAR, FAR);

    this.camera.position = { x: 0.0, y: 5.0, z: 5.0 };
    this.camera.up = { x: 0.0, y: 0.0, z: 1.0 };

    var obj = new THREE.Mesh(
      new THREE.CubeGeometry(0.4, 0.8, 1.7, 1, 1, 1),
      new THREE.MeshLambertMaterial()
    );
    this.scene.addChild(obj);
    this.obj = obj;

    var ambient = new THREE.AmbientLight(0x333366);
    this.scene.addLight(ambient);

    var zlight = new THREE.PointLight(0xaaaaaa);
    zlight.position.z = 100.0;
    this.scene.addLight(zlight);
  }

  NodeVsZombies.prototype.animate = function() {
    requestAnimationFrame(this.animate.bind(this));
    this.simulate();
    this.renderer.clear();
    return this.renderer.render(this.scene, this.camera);
  };

  NodeVsZombies.prototype.simulate = function() {
    var dt = Math.min(Date.now() - this.t, 1000);
    var t = (this.t += dt);

    if (this.keyboard.left()) {
      this.player.turn(dt);
    }
    if (this.keyboard.right()) {
      this.player.turn(-dt);
    }
    if (this.keyboard.up()) {
      this.player.walk(dt);
    } else if (this.keyboard.down()) {
      this.player.walk(-dt / 2);
    } else {
      this.player.idle(dt);
    }

    this.obj.position.x = this.player.position.x;
    this.obj.position.y = this.player.position.y;

    this.obj.rotation.z = this.player.heading;
  };

  return NodeVsZombies;

})();
