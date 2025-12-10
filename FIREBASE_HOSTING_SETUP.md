# Firebase Hosting Setup for Deep Links

Your Firebase project is already configured! Your free domain is:
- **Primary:** `https://poc-deeplink-487ac.web.app`
- **Alternative:** `https://poc-deeplink-487ac.firebaseapp.com`

Both domains work for deep links and are already configured in your app.

## Quick Setup

### 1. Install Firebase CLI (if not already installed)

```bash
npm install -g firebase-tools
```

### 2. Login to Firebase

```bash
firebase login
```

### 3. Initialize Firebase Hosting (if not already done)

```bash
firebase init hosting
```

When prompted:
- **What do you want to use as your public directory?** → `public` (already configured!)
- **Configure as a single-page app?** → `Yes`
- **Set up automatic builds and deploys with GitHub?** → `No` (or Yes if you want)

**Note:** The `public` directory contains ONLY the redirect page and `.well-known` files - NOT the full Flutter web app. This keeps the deployment minimal and fast.

### 4. Deploy to Firebase Hosting

```bash
firebase deploy --only hosting
```

**No need to build Flutter web app!** The `public` directory is separate and contains only the redirect page.

Your app will be live at: `https://poc-deeplink-487ac.web.app`

## Setting Up Universal/App Links

### For iOS Universal Links

1. **Get your Team ID:**
   - Go to [Apple Developer Account](https://developer.apple.com/account)
   - Your Team ID is in the top right corner

2. **Get your Bundle ID:**
   - Check `ios/Runner.xcodeproj` or Xcode
   - Usually: `com.example.poc_deeplink`

3. **Update apple-app-site-association:**
   - Edit `.well-known/apple-app-site-association.example`
   - Replace `TEAM_ID` with your actual Team ID
   - Replace `com.example.poc_deeplink` with your Bundle ID
   - Copy to `build/web/.well-known/apple-app-site-association` before deploying

### For Android App Links

1. **Get your SHA-256 fingerprint:**

   For debug builds:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```

   For release builds:
   ```bash
   keytool -list -v -keystore /path/to/your/keystore.jks -alias your-key-alias
   ```

2. **Update assetlinks.json:**
   - Edit `.well-known/assetlinks.json.example`
   - Replace `com.example.poc_deeplink` with your package name
   - Replace `YOUR_SHA256_FINGERPRINT_HERE` with your actual SHA-256 fingerprint
   - Copy to `build/web/.well-known/assetlinks.json` before deploying

3. **Update the files in `public/.well-known/`:**
   - Edit `public/.well-known/apple-app-site-association` with your Team ID and Bundle ID
   - Edit `public/.well-known/assetlinks.json` with your package name and SHA-256 fingerprint
   
   Then deploy:
   ```bash
   firebase deploy --only hosting
   ```

## Testing Deep Links

### Test Universal/App Links

1. **iOS:** Open Safari and navigate to:
   ```
   https://poc-deeplink-487ac.web.app/product/123
   ```

2. **Android:** Use ADB:
   ```bash
   adb shell am start -a android.intent.action.VIEW -d "https://poc-deeplink-487ac.web.app/product/123" com.example.poc_deeplink
   ```

### Test Custom URL Scheme (works without domain setup)

```bash
# Android
adb shell am start -a android.intent.action.VIEW -d "pocdeeplink://product/123" com.example.poc_deeplink

# iOS - Open in Safari or Notes app
pocdeeplink://product/123
```

## Deployment Workflow

For future deployments (only needed if you update the redirect page or .well-known files):

```bash
# 1. Update files in public/ directory if needed
#    - public/index.html (redirect page)
#    - public/.well-known/apple-app-site-association
#    - public/.well-known/assetlinks.json

# 2. Deploy to Firebase
firebase deploy --only hosting
```

**Note:** You don't need to build the Flutter web app. The `public` directory is completely separate and contains only the minimal redirect page (~5KB) instead of the full Flutter web app (which would be several MB).

## Custom Domain (Optional)

If you want to use a custom domain later:

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project → Hosting → Add custom domain
3. Follow the DNS configuration steps
4. Update your app configuration files with the new domain

## Free Domain Alternatives

If you want a custom domain for free, consider:

1. **Freenom** (freenom.com) - Free .tk, .ml, .ga domains (limited)
2. **GitHub Pages** - Free subdomain: `yourusername.github.io`
3. **Netlify** - Free subdomain: `your-app.netlify.app`
4. **Vercel** - Free subdomain: `your-app.vercel.app`

However, **Firebase Hosting is the easiest** since you already have it set up and it's free!

## Troubleshooting

### Universal Links not working on iOS?

1. Make sure Associated Domains are configured in Xcode
2. Verify the apple-app-site-association file is accessible:
   ```bash
   curl https://poc-deeplink-487ac.web.app/.well-known/apple-app-site-association
   ```
3. Check that Content-Type is `application/json` (configured in firebase.json)

### App Links not working on Android?

1. Verify assetlinks.json is accessible:
   ```bash
   curl https://poc-deeplink-487ac.web.app/.well-known/assetlinks.json
   ```
2. Verify app links:
   ```bash
   adb shell pm verify-app-links --re-verify com.example.poc_deeplink
   ```
3. Check that SHA-256 fingerprint matches your signing key

