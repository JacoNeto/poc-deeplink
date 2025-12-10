import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'router/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLinks _appLinks;
  Stream<Uri>? _linkStream;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  void _initDeepLinks() {
    _appLinks = AppLinks();

    // Handle initial link (if app was opened via deep link)
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    });

    // Listen to incoming links while app is running
    _linkStream = _appLinks.uriLinkStream;
    _linkStream?.listen(
      (uri) => _handleDeepLink(uri),
      onError: (err) {
        debugPrint('Deep link error: $err');
      },
    );
  }

  void _handleDeepLink(Uri uri) {
    debugPrint('Deep link received: $uri');
    
    // Extract path from the URI
    String path = uri.path;
    
    // Handle custom URL scheme (pocdeeplink://)
    if (uri.scheme == 'pocdeeplink') {
      // For custom schemes, the path might include the host
      // e.g., pocdeeplink://product/123 or pocdeeplink:///product/123
      path = uri.path.isEmpty ? '/' : uri.path;
      // Remove leading slashes if present
      if (path.startsWith('/')) {
        path = path.substring(1);
      }
      // Add leading slash for go_router
      if (!path.startsWith('/')) {
        path = '/$path';
      }
    }
    
    // Handle HTTPS links (https://poc-deeplink.example.com/...)
    if (uri.scheme == 'https' || uri.scheme == 'http') {
      path = uri.path.isEmpty ? '/' : uri.path;
    }
    
    // Ensure path starts with /
    if (!path.startsWith('/')) {
      path = '/$path';
    }
    
    // Handle query parameters if needed
    if (uri.queryParameters.isNotEmpty) {
      final queryString = uri.queryParameters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      path = '$path?$queryString';
    }
    
    // Navigate using go_router
    if (path.isNotEmpty) {
      AppRouter.router.go(path);
    } else {
      AppRouter.router.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Deep Link POC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
    );
  }

  @override
  void dispose() {
    _linkStream = null;
    super.dispose();
  }
}
