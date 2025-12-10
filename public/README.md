# Public Directory - Redirect Page Only

This directory contains **ONLY** the redirect/fallback page and `.well-known` files for deep linking.

## What's in here?

- `index.html` - Minimal redirect page (~5KB) that:
  - Tries to open the app via deep link
  - Redirects to App Store/Play Store if app not installed
  - Detects iOS/Android automatically

- `.well-known/` - Files required for Universal/App Links:
  - `apple-app-site-association` - For iOS Universal Links
  - `assetlinks.json` - For Android App Links

## What's NOT here?

- ❌ Full Flutter web app (that would be in `build/web/`)
- ❌ Flutter framework files
- ❌ Large JavaScript bundles

## Deployment

This directory is deployed directly to Firebase Hosting:

```bash
firebase deploy --only hosting
```

The deployment is fast (~5KB) and only includes the redirect page, not the entire Flutter web app.

## Updating Files

1. **Redirect page:** Edit `index.html` directly
2. **Universal Links:** Edit `.well-known/apple-app-site-association` with your Team ID and Bundle ID
3. **App Links:** Edit `.well-known/assetlinks.json` with your package name and SHA-256 fingerprint

Then deploy:
```bash
firebase deploy --only hosting
```

