# Setup

Start up the filebrowser, login as admin with the random password.

Once logged in, stop the container and set up the configs from Dockge:

`docker run --rm -v /mnt/quick/apps/volumes/filebrowser/db:/database filebrowser/filebrowser -d /database/filebrowser.db config set --auth.header=X-Authentik-Username --auth.method=proxy`

Filebrowser requires just a normal Proxy Provider with Single app type. Once set up, everything works out of the box.