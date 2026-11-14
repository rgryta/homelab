# jamroom

## Design notes

Compose file is not in this repository yet. These notes come from the comments in the deployed `jamroom` stack.

- `jamroom` runs as `3001:3000`. That user owns the library files. Group 950 owns the library's top-level folder and may write there (`group_add: 950`).
- The public `jamroom` service mounts the music library read-only. It reuses songs you already have and never writes to the library.
- `jamroom-soulseek` looks for a lossless Soulseek copy of every cached YouTube song and files it in the library. It is not on the public network and has no ports. It is the only container that writes the library or talks to slskd.
