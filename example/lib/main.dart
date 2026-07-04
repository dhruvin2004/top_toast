import 'package:flutter/material.dart';
import 'package:top_toast/top_toast.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  TopToast.init(navigatorKey: navigatorKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TopToast Demo',
      navigatorKey: navigatorKey,
      theme: ThemeData(colorSchemeSeed: Colors.deepOrange, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

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
