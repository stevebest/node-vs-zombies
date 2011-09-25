NODE vz ZOMBIES
===============

Realtime multiplayer online game with Node.JS and ZOMBIES!!1


What's this all about?
----------------------

When you write a modern game, it should be a browser game. It should be
a multiplayer game. It should be a realtime game. Most importantly, it should
be a fun game.

Node vz Zombies is an example of all that.


How it's done?
--------------

Node vz Zombies is written for Node.JS, as well as for the browser.
Most of the code is in fact shared between the two. This allows for
rapidly changing both server-side and client-side logic, and seeing changes
right away.

Both client and server sides employ the usual game cycle:

 - read input from players,
 - update internal view of the world according to player's and NPC's behavior,
 - draw fancy 3D graphics (optional, if you're on the server)
 - rinse, repeat.

When both sides are executing the same code, there's no need to synchronize
states of the world every frame - they may simply exchange whatever inputs
from players is and update according to that. (Well, they MAY sync time to
time, if numerical precision and/or timing errors are expected to be present
in simulation.)

Developing your game code in JavaScript or CoffeeScript allows it to be run
on both sides without additional effort. No deploying, no build scripts,
no hassle. You can concentrate on making your game great, instead of making it
work over the net.


What's inside?
--------------

`Player`s and `Zombies` are represented by corresponding classes in
`nvz/shared`. Their code shows how exactly they behave in the world
plagued by a zombie epidemy.

The bridge between client world and server world is built by two classes:
`nvz/client/WorldGL.coffee` and `nvz/server/WorldServer.coffee`. Both share
a good chunk of their functionality from `nvz/shared/World.coffee`. You should
probably look at the code starting from these guys.

Socket.IO is responsible for exchanging messages between client and server
over WebSockets. The types of messages that are understood by parties is
listed in `nvz/shared/Message.coffee`.

Browserify glues all the CoffeeScript code together before sending it to
a browser.

Finally, Express is responsible for bringing up the HTTP server and serving
all static assets.


System requirements
-------------------

To play Node vs Zombies, you'll need a modern browser with WebGL support,
some friends, and a couple of minutes to spare.

Now go play!

