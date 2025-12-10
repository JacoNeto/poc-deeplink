# Configuration Guide

## ⚠️ IMPORTANT: App Store URLs Required

The redirect page needs your actual App Store and Play Store URLs to work properly.

### Where to Configure

Edit `public/index.html` and update these lines (around lines 95-96):

```javascript
const iOSAppStoreUrl = 'https://apps.apple.com/app/your-app-id'; // TODO: Replace
const androidPlayStoreUrl = 'https://play.google.com/store/apps/details?id=com.example.poc_deeplink'; // TODO: Replace
```

### How to Get Your URLs

**iOS App Store:**
1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Find your app
3. The URL format is: `https://apps.apple.com/app/id[APP_ID]`
   - Or: `https://apps.apple.com/app/[APP_NAME]/id[APP_ID]`

**Android Play Store:**
1. Go to [Google Play Console](https://play.google.com/console)
2. Find your app
3. The URL format is: `https://play.google.com/store/apps/details?id=[PACKAGE_NAME]`
   - Your package name is: `com.example.poc_deeplink` (check `android/app/build.gradle.kts`)

### Example URLs

```javascript
// iOS - Replace YOUR_APP_ID with actual ID
const iOSAppStoreUrl = 'https://apps.apple.com/app/id1234567890';

// Android - Replace with your actual package name
const androidPlayStoreUrl = 'https://play.google.com/store/apps/details?id=com.example.poc_deeplink';
```

### After Updating

1. Save `public/index.html`
2. Deploy to Firebase:
   ```bash
   firebase deploy --only hosting
   ```

## How It Works

1. User clicks deep link: `https://poc-deeplink-487ac.web.app/product/123`
2. Page loads and tries to open app: `pocdeeplink://product/123`
3. If app is installed → App opens
4. If app is NOT installed → After 1.5 seconds, redirects to App Store/Play Store

## Testing

**Without app installed:**
- Should redirect to store after ~1.5 seconds
- If it gets stuck, check that app store URLs are configured correctly

**With app installed:**
- Should open app immediately
- Page should disappear (app takes focus)

