# ai-cpp

## Design notes

- `whisper-cpp` is internal only. `whisper-server` has no API key, so it is not published through Traefik. Clients POST audio to `http://whisper-cpp:8080/inference`.
- `whisper-cpp` has a static address (`172.20.0.9`). Bemol's GPU worker runs on another host, reaches homelab-network over wg0, cannot resolve Docker DNS, and pins that address with `extra_hosts`.
- The `whisper.cpp` image entrypoint is `bash -c`, so the whole server command is one string.
- `-l auto` is set because the server defaults to English. `--convert` is set because voice notes arrive as opus/ogg.
- Optional for `llama-cpp`: `SYCL_CACHE_PERSISTENT=1` keeps compiled GPU kernels between restarts. It is not enabled.
