# wud

## Design notes

- `service-worker.js` is a self-destructing service worker, mounted over the one in the image. The stock one caches the app shell, so an expired authentik session produces a white screen instead of a login redirect: the SPA's XHR gets a cross-origin 302, which XHR cannot follow.
- `complexio`, `jamroom`, `slack` and `waha` auto-deploy new releases. Their stack folders are mounted into wud at the same path, so wud can rewrite their compose files. Each stack opts in with its own `wud.trigger.include` label.
