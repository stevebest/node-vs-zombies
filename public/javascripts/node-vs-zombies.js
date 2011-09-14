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

    this.scene = new THREE.Scene();
    this.renderer = new THREE.WebGLRenderer();
    this.renderer.setSize(WIDTH, HEIGHT);
    this.container.append(this.renderer.domElement);
    this.camera = new THREE.Camera(VIEW_ANGLE, ASPECT, NEAR, FAR);

    this.camera.position = { x: 5.0, y: 5.0, z: 5.0 };
    this.camera.up = { x: 0.0, y: 0.0, z: 1.0 };

    var obj = new THREE.Mesh(
      new THREE.SphereGeometry(1.0, 8, 8),
      new THREE.MeshPhongMaterial()
    );
    this.scene.addChild(obj);
    this.obj = obj;

    var xlight = new THREE.PointLight(0xff0000);
    xlight.position.x = 10.0;
    this.scene.addLight(xlight);

    var ylight = new THREE.PointLight(0x00ff00);
    ylight.position.y = 10.0;
    this.scene.addLight(ylight);

    var zlight = new THREE.PointLight(0x0000ff);
    zlight.position.z = 10.0;
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

    if (this.keyboard.left()) this.obj.position.x += 0.001 * dt;
    if (this.keyboard.right()) this.obj.position.x -= 0.001 * dt;
    if (this.keyboard.up()) this.obj.position.y += 0.001 * dt;
    if (this.keyboard.down()) this.obj.position.y -= 0.001 * dt;
  };

  return NodeVsZombies;

})();
