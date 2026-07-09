import 'package:flutter/material.dart';
import 'package:top_toast/top_toast.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  TopToast.init(
    navigatorKey: navigatorKey,
    config: const TopToastConfig(
      position: ToastPosition.top,
      animation: ToastAnimation.slide,
      defaultDuration: Duration(seconds: 3),
      showProgressBar: false,
      hapticFeedback: true,
      queueMode: false,
      stackMode: false,
    ),
  );
  runApp(const MyApp());
}

// ─── App ──────────────────────────────────────────────────────────────────────

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() => setState(() {
        _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'top_toast Demo',
      navigatorKey: navigatorKey,
      builder: TopToast.builder,
      themeMode: _themeMode,
      theme: ThemeData(colorSchemeSeed: Colors.deepOrange, useMaterial3: true),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.deepOrange,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: HomePage(onToggleTheme: _toggleTheme, themeMode: _themeMode),
    );
  }
}

// ─── Shell with bottom nav ─────────────────────────────────────────────────────

class HomePage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;
  const HomePage({super.key, required this.onToggleTheme, required this.themeMode});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tab = 0;

  static const _titles = ['Toasts', 'Dialogs'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_tab]),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),
          if (_tab == 0)
            IconButton(
              icon: const Icon(Icons.clear_all),
              tooltip: 'Dismiss all',
              onPressed: TopToast.dismissAll,
            ),
        ],
      ),
      body: IndexedStack(
        index: _tab,
        children: const [
          ToastsPage(),
          DialogsPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.notifications_none_rounded),
            selectedIcon: Icon(Icons.notifications_rounded),
            label: 'Toasts',
          ),
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline_rounded),
            selectedIcon: Icon(Icons.check_circle_rounded),
            label: 'Dialogs',
          ),
        ],
      ),
    );
  }
}

// ─── Toasts page ──────────────────────────────────────────────────────────────

class ToastsPage extends StatefulWidget {
  const ToastsPage({super.key});
  @override
  State<ToastsPage> createState() => _ToastsPageState();
}

class _ToastsPageState extends State<ToastsPage> {
  ToastPosition _position = ToastPosition.top;
  ToastAnimation _animation = ToastAnimation.slide;
  bool _persistent = false;
  bool _progressBar = false;
  bool _queueMode = false;
  bool _stackMode = false;
  Duration _duration = const Duration(seconds: 3);

  void _applyConfig() {
    TopToast.init(
      navigatorKey: navigatorKey,
      config: TopToastConfig(
        position: _position,
        animation: _animation,
        defaultDuration: _duration,
        showProgressBar: _progressBar,
        queueMode: _queueMode,
        stackMode: _stackMode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _section('Position'),
          Wrap(
            spacing: 8, runSpacing: 4,
            children: ToastPosition.values.map((p) => ChoiceChip(
              label: Text(_posLabel(p)),
              selected: _position == p,
              onSelected: (_) => setState(() { _position = p; _applyConfig(); }),
            )).toList(),
          ),
          const SizedBox(height: 12),

          _section('Animation'),
          Wrap(
            spacing: 8, runSpacing: 4,
            children: ToastAnimation.values.map((a) => ChoiceChip(
              label: Text(a.name),
              selected: _animation == a,
              onSelected: (_) => setState(() { _animation = a; _applyConfig(); }),
            )).toList(),
          ),
          const SizedBox(height: 12),

          _section('Duration  (${_duration.inSeconds}s)'),
          Slider(
            value: _duration.inSeconds.toDouble(),
            min: 1, max: 10, divisions: 9,
            label: '${_duration.inSeconds}s',
            onChanged: (v) => setState(() {
              _duration = Duration(seconds: v.round());
              _applyConfig();
            }),
          ),

          _section('Options'),
          Wrap(
            spacing: 8, runSpacing: 4,
            children: [
              FilterChip(
                label: const Text('Progress bar'),
                selected: _progressBar,
                onSelected: (v) => setState(() { _progressBar = v; _applyConfig(); }),
              ),
              FilterChip(
                label: const Text('Persistent'),
                selected: _persistent,
                onSelected: (v) => setState(() => _persistent = v),
              ),
              FilterChip(
                label: const Text('Queue mode'),
                selected: _queueMode,
                onSelected: (v) => setState(() { _queueMode = v; _applyConfig(); }),
              ),
              FilterChip(
                label: const Text('Stack mode'),
                selected: _stackMode,
                onSelected: (v) => setState(() { _stackMode = v; _applyConfig(); }),
              ),
            ],
          ),
          const SizedBox(height: 20),

          _section('Toast types'),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: [
              _btn('Success', Colors.green,
                  () => TopToast.success(msg: 'Record saved successfully.', persistent: _persistent)),
              _btn('Error', Colors.red,
                  () => TopToast.error(msg: 'Something went wrong.', persistent: _persistent)),
              _btn('Warning', Colors.orange,
                  () => TopToast.warning(msg: 'Low storage space remaining.', persistent: _persistent)),
              _btn('Info', Colors.blue,
                  () => TopToast.info(msg: 'Pull down to refresh.', persistent: _persistent)),
              _btn('Neutral', Colors.grey,
                  () => TopToast.toast(msg: 'Copied to clipboard', persistent: _persistent)),
            ],
          ),
          const SizedBox(height: 8),

          _section('With action button'),
          ElevatedButton(
            onPressed: () => TopToast.toastWithAction(
              type: ToastType.error,
              title: 'Deleted',
              msg: 'Item has been removed.',
              label: 'Undo',
              persistent: _persistent,
              onPressed: () => TopToast.success(msg: 'Restored!'),
            ),
            child: const Text('Toast with action'),
          ),
          const SizedBox(height: 8),

          _section('Custom icon & colours'),
          ElevatedButton(
            onPressed: () => TopToast.toast(
              msg: 'Syncing in the background…',
              icon: Icons.sync_rounded,
              cardColor: const Color(0xFF1E1B4B),
              borderColor: const Color(0xFF3730A3),
              iconBgColor: const Color(0xFF4F46E5),
              iconColor: Colors.white,
            ),
            child: const Text('Custom icon & colour'),
          ),
          const SizedBox(height: 8),

          _section('Per-toast animation override'),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () => TopToast.success(msg: 'Scale!', animation: ToastAnimation.scale),
                child: const Text('Scale'),
              ),
              ElevatedButton(
                onPressed: () => TopToast.info(msg: 'Fade!', animation: ToastAnimation.fade),
                child: const Text('Fade'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _section(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(label,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
      );

  Widget _btn(String label, Color color, VoidCallback onTap) => ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
        child: Text(label),
      );

  String _posLabel(ToastPosition p) => switch (p) {
        ToastPosition.top => 'Top',
        ToastPosition.bottom => 'Bottom',
        ToastPosition.topLeft => 'Top Left',
        ToastPosition.topRight => 'Top Right',
        ToastPosition.bottomLeft => 'Bottom Left',
        ToastPosition.bottomRight => 'Bottom Right',
      };
}

// ─── Dialogs page ─────────────────────────────────────────────────────────────

class DialogsPage extends StatelessWidget {
  const DialogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _section(context, 'Built-in types'),
          _DialogTile(
            label: 'Delete',
            accent: const Color(0xFFDC2626),
            icon: Icons.delete_outline_rounded,
            subtitle: 'Destructive action — red accent, cancel shown',
            onTap: () => TopDialog.show(
              context,
              type: DialogType.delete,
              message: 'This item will be permanently removed and cannot be recovered.',
              onConfirm: () => TopToast.success(msg: 'Item deleted.'),
            ),
          ),
          _DialogTile(
            label: 'Warning',
            accent: const Color(0xFFF59E0B),
            icon: Icons.warning_amber_rounded,
            subtitle: 'Cautionary — amber accent, cancel shown',
            onTap: () => TopDialog.show(
              context,
              type: DialogType.warning,
              message: 'All unsaved changes will be lost.',
              onConfirm: () => TopToast.warning(msg: 'Changes discarded.'),
            ),
          ),
          _DialogTile(
            label: 'Success',
            accent: const Color(0xFF15803D),
            icon: Icons.check_circle_outline_rounded,
            subtitle: 'Informational — green accent, no cancel',
            onTap: () => TopDialog.show(
              context,
              type: DialogType.success,
              message: 'Your profile has been updated successfully.',
              onConfirm: () {},
            ),
          ),
          _DialogTile(
            label: 'Failed',
            accent: const Color(0xFFDC2626),
            icon: Icons.cancel_outlined,
            subtitle: 'Informational error — red accent, no cancel',
            onTap: () => TopDialog.show(
              context,
              type: DialogType.failed,
              message: 'Could not connect to the server. Please try again.',
              onConfirm: () => TopToast.error(msg: 'Retrying…'),
            ),
          ),
          _DialogTile(
            label: 'Confirmation',
            accent: const Color(0xFF2563EB),
            icon: Icons.help_outline_rounded,
            subtitle: 'Generic prompt — blue accent, cancel shown',
            onTap: () => TopDialog.show(
              context,
              type: DialogType.confirmation,
              message: 'Submitting this report will notify your manager.',
              onConfirm: () => TopToast.info(msg: 'Report submitted.'),
            ),
          ),
          const SizedBox(height: 20),

          _section(context, 'Async confirm (with spinner)'),
          _DialogTile(
            label: 'Async confirm',
            accent: const Color(0xFF2563EB),
            icon: Icons.cloud_upload_outlined,
            subtitle: 'Button shows spinner until the future resolves',
            onTap: () => TopDialog.show(
              context,
              type: DialogType.confirmation,
              title: 'Upload file?',
              message: 'This may take a few seconds.',
              confirmLabel: 'Upload',
              onAsyncConfirm: () async {
                await Future.delayed(const Duration(seconds: 2));
                TopToast.success(msg: 'File uploaded!');
              },
            ),
          ),
          const SizedBox(height: 20),

          _section(context, 'Custom type'),
          _DialogTile(
            label: 'Custom',
            accent: const Color(0xFF7C3AED),
            icon: Icons.palette_outlined,
            subtitle: 'Your own accent colour and icon widget',
            onTap: () => TopDialog.show(
              context,
              type: DialogType.custom,
              title: 'Update avatar?',
              message: 'Your profile photo will be changed immediately.',
              confirmLabel: 'Update',
              accentColor: const Color(0xFF7C3AED),
              customIcon: const Icon(Icons.person_rounded, color: Colors.white, size: 22),
              onConfirm: () => TopToast.success(msg: 'Avatar updated!'),
            ),
          ),
          const SizedBox(height: 20),

          _section(context, 'Config overrides'),
          _DialogTile(
            label: 'Custom labels',
            accent: const Color(0xFFDC2626),
            icon: Icons.label_outline_rounded,
            subtitle: 'TopDialogConfig: custom cancel/confirm labels',
            onTap: () => TopDialog.show(
              context,
              type: DialogType.delete,
              message: 'You are about to wipe all data.',
              config: const TopDialogConfig(
                cancelLabel: 'Keep data',
                confirmLabel: 'Wipe everything',
                barrierDismissible: false,
              ),
              onConfirm: () => TopToast.error(msg: 'All data wiped.'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, String label) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(label,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
      );
}

// ─── Dialog tile ──────────────────────────────────────────────────────────────

class _DialogTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final Color accent;
  final IconData icon;
  final VoidCallback onTap;

  const _DialogTile({
    required this.label,
    required this.subtitle,
    required this.accent,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: accent.withValues(alpha: .12),
          child: Icon(icon, color: accent, size: 22),
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
