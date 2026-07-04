import 'package:flutter/material.dart';
import 'package:top_toast/top_toast.dart';

// ─── Navigator key ────────────────────────────────────────────────────────────
//
// Pass this key to TopToast.init AND to your router.
//
// MaterialApp        → MaterialApp(navigatorKey: navigatorKey, ...)
// MaterialApp.router → GoRouter(navigatorKey: navigatorKey, ...)
//
final navigatorKey = GlobalKey<NavigatorState>();

// ─── GoRouter variant (uncomment if you use go_router) ───────────────────────
//
// import 'package:go_router/go_router.dart';
//
// final router = GoRouter(
//   navigatorKey: navigatorKey,
//   routes: [
//     GoRoute(path: '/', builder: (context, state) => const HomePage()),
//   ],
// );

void main() {
  TopToast.init(navigatorKey: navigatorKey);
  runApp(const MyApp());
}

// ─── MaterialApp variant ──────────────────────────────────────────────────────

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TopToast Demo',
      navigatorKey: navigatorKey,
      builder: TopToast.builder,   // renders toast above dialogs & bottom sheets
      theme: ThemeData(colorSchemeSeed: Colors.deepOrange, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

// ─── MaterialApp.router variant (uncomment + swap MyApp above) ────────────────
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       title: 'TopToast Demo',
//       routerConfig: router,          // navigatorKey lives inside GoRouter
//       builder: TopToast.builder,     // renders toast above dialogs & sheets
//       theme: ThemeData(colorSchemeSeed: Colors.deepOrange, useMaterial3: true),
//     );
//   }
// }

// ─── Home screen ──────────────────────────────────────────────────────────────

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TopToast Demo')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _btn('Success', () => TopToast.success(msg: 'Record saved successfully.')),
            _btn('Error', () => TopToast.error(msg: 'Something went wrong. Please try again.')),
            _btn('Warning', () => TopToast.warning(msg: 'Low storage space remaining.')),
            _btn('Info', () => TopToast.info(msg: 'Pull down to refresh the list.')),
            _btn('Neutral', () => TopToast.toast(msg: 'Copied to clipboard')),
            _btn('With Action', () {
              TopToast.toastWithAction(
                type: ToastType.error,
                title: 'Deleted',
                msg: 'Item has been removed.',
                label: 'Undo',
                onPressed: () => TopToast.success(msg: 'Restored!'),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _btn(String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ElevatedButton(onPressed: onTap, child: Text(label)),
    );
  }
}
