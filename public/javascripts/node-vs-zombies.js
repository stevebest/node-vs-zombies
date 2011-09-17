/*
 Node vs Zombies
 Copyright, 2011, Stepan Stolyarov
*/

var nvz = require('/client');

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
        var world = new nvz.WorldGL($('#container'), $('#nick').val());
        world.animate();
      }
    });
    return false;
  });
});
