

module.exports = class ThirdPersonCamera extends THREE.Camera

  constructor: (parameters) ->
    THREE.Camera.call this, parameters.fov, parameters.aspect,
      parameters.near, parameters.far, parameters.target

    parameters.height ||= 4.5
    parameters.min ||= 4.0
    parameters.max ||= 7.0
    parameters.damping ||= 0.3
    { @height, @min, @max, @damping } = parameters

  update: (parentMatrixWorld, forceUpdate, camera) ->
    @position.x = @target.position.x
    @position.y = @target.position.y - (@min + @max) / 2
    @position.z = @height
    super parentMatrixWorld, forceUpdate, camera
