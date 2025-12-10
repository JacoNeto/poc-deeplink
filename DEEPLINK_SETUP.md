# Deep Link Setup Guide

This project implements deep linking without external paid services or deprecated Firebase Dynamic Links. It uses:
- **go_router** for modular routing
- **app_links** for handling deep links
- Custom URL schemes and Universal/App Links
- **Firebase Hosting** for free domain hosting (already configured!)

## ✅ Domain Already Configured!

Your project is already set up to use **Firebase Hosting** with the free domain:
- **Primary:** `https://poc-deeplink-487ac.web.app`
- **Alternative:** `https://poc-deeplink-487ac.firebaseapp.com`

The domain is already configured in:
- ✅ `android/app/src/main/AndroidManifest.xml`
- ✅ `ios/Runner/Info.plist`
- ✅ `web/index.html`

**See [FIREBASE_HOSTING_SETUP.md](./FIREBASE_HOSTING_SETUP.md) for deployment instructions!**

## Configuration

### 1. Domain Configuration (Already Done!)

The Firebase Hosting domain is already configured. If you want to use a custom domain later, replace the Firebase domain with your custom domain in:
- `android/app/src/main/AndroidManifest.xml`
- `ios/Runner/Info.plist`
- `web/index.html`

### 2. Update App Store URLs

Update the app store URLs in `web/index.html`:
- **iOS App Store URL** (line 32): Replace with your actual App Store URL
- **Android Play Store URL** (line 33): Replace with your actual Play Store URL

### 3. iOS Universal Links Setup

For iOS Universal Links to work, you need to:

1. **Configure Associated Domains in Xcode:**
   - Open `ios/Runner.xcworkspace` in Xcode
   - Select the Runner target
   - Go to "Signing & Capabilities"
   - Add "Associated Domains" capability
   - Add: `applinks:poc-deeplink.example.com` (replace with your domain)

2. **Host Apple App Site Association file:**
   Create a file at: `https://poc-deeplink.example.com/.well-known/apple-app-site-association`
   
   Example content (replace with your bundle ID):
   ```json
   {
     "applinks": {
       "apps": [],
       "details": [
         {
           "appID": "TEAM_ID.com.example.poc_deeplink",
           "paths": ["*"]
         }
       ]
     }
   }
   ```
   
   **Important:** The file must be:
   - Served over HTTPS
   - Content-Type: `application/json` (not `text/plain`)
   - No file extension
   - Accessible without authentication

### 4. Android App Links Setup

For Android App Links to work, you need to:

1. **Host Digital Asset Links file:**
   Create a file at: `https://poc-deeplink.example.com/.well-known/assetlinks.json`
   
   Example content (replace with your package name and SHA-256 fingerprint):
   ```json
   [{
     "relation": ["delegate_permission/common.handle_all_urls"],
     "target": {
       "namespace": "android_app",
       "package_name": "com.example.poc_deeplink",
       "sha256_cert_fingerprints": [
         "YOUR_SHA256_FINGERPRINT_HERE"
       ]
     }
   }]
   ```
   
   To get your SHA-256 fingerprint:
   ```bash
   # For debug keystore
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   
   # For release keystore
   keytool -list -v -keystore /path/to/your/keystore.jks -alias your-key-alias
   ```

2. **Verify App Links:**
   ```bash
   adb shell pm verify-app-links --re-verify com.example.poc_deeplink
   ```

## Testing Deep Links

### Custom URL Scheme (Works without domain setup)
```bash
# Android
adb shell am start -a android.intent.action.VIEW -d "pocdeeplink://product/123" com.example.poc_deeplink

# iOS (from Safari or Notes app)
pocdeeplink://product/123
```

### Universal/App Links (Requires domain setup)
```bash
# Android
adb shell am start -a android.intent.action.VIEW -d "https://poc-deeplink.example.com/product/123" com.example.poc_deeplink

# iOS (from Safari or Messages)
https://poc-deeplink.example.com/product/123
```

## Available Deep Link Routes

- `/` - Home page
- `/product/:id` - Product page (e.g., `/product/123`)
- `/profile` - Profile page
- `/settings` - Settings page

## Web Fallback

The `web/index.html` file includes a fallback mechanism that:
1. Tries to open the app using deep links
2. If the app doesn't open within 2.5 seconds, redirects to the appropriate app store
3. Detects iOS/Android and redirects accordingly

## Notes

- Custom URL schemes (`pocdeeplink://`) work immediately without domain configuration
- Universal Links (iOS) and App Links (Android) require proper domain setup and verification
- The web fallback page should be hosted on your domain for Universal/App Links to work
- For production, ensure your domain has proper SSL certificates

