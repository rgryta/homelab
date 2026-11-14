# firefox

## Design notes

- The authentik forward-auth middleware is non-negotiable. A browser reachable without auth is an open proxy into homelab-network for anyone who finds the hostname, and it holds logged-in sessions for whatever has been signed into it.
- The image is `jlesage/firefox` (noVNC), not the linuxserver one. linuxserver's GUI images moved to selkies, which streams over WebRTC and hard-requires the WebCodecs API. That rules out release Firefox for Android, which is the browser this is actually used from. noVNC is a canvas over a websocket and works anywhere.
- `VNC_PASSWORD` is empty. authentik is the front door, and a second password on the noVNC canvas would only be another thing to lose. Access control lives in the Traefik middleware.
- `DISPLAY_WIDTH` and `DISPLAY_HEIGHT` are sized for a phone in landscape. The canvas scales, so they only set the backing resolution the pages are laid out at.
- `KEEP_APP_RUNNING=1` makes Firefox restart instead of taking the container down with it, so a crashed tab does not cost the session.
- The `firefox_config` volume holds the profile and has to outlive the container: cookies, logins and 2FA trust survive a restart, so signing in is a once-per-service job rather than a once-per-deploy one.
- `shm_size: 2gb`: Firefox allocates its renderer shared memory there. The 64M Docker default makes tabs crash on real pages without any error that names the cause.
- `seccomp:unconfined`: the browser's own sandbox uses syscalls that Docker's default seccomp profile blocks. Without it Firefox starts and then dies opening a content process.
