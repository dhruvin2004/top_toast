import 'package:flutter/material.dart';
import 'top_toast_types.dart';

// ─── Public API ───────────────────────────────────────────────────────────────

/// A top-sliding overlay toast.
///
/// **Setup** — call [init] once with your app's navigator key:
/// ```dart
/// final navigatorKey = GlobalKey<NavigatorState>();
///
/// void main() {
///   TopToast.init(navigatorKey: navigatorKey);
///   runApp(MyApp(navigatorKey: navigatorKey));
/// }
/// ```
///
/// **Usage:**
/// ```dart
/// TopToast.success(msg: 'Saved successfully');
/// TopToast.error(msg: 'Something went wrong');
/// TopToast.warning(title: 'Heads up', msg: 'Low disk space');
/// TopToast.info(msg: 'Tap to learn more');
/// TopToast.toast(msg: 'Copied to clipboard');
/// ```
class TopToast {
  TopToast._();

  static GlobalKey<NavigatorState>? _navigatorKey;
  static OverlayEntry? _current;
  static final _overlayKey = GlobalKey<OverlayState>();

  /// Initialise the package. Call once before any toast.
  static void init({required GlobalKey<NavigatorState> navigatorKey}) {
    _navigatorKey = navigatorKey;
  }

  /// Pass this to the `builder` parameter of [MaterialApp] or
  /// [MaterialApp.router] so toasts always render above dialogs and bottom
  /// sheets.
  ///
  /// ```dart
  /// MaterialApp(
  ///   navigatorKey: navigatorKey,
  ///   builder: TopToast.builder,   // ← add this
  ///   home: HomePage(),
  /// )
  /// ```
  static Widget builder(BuildContext context, Widget? child) {
    return Overlay(
      key: _overlayKey,
      initialEntries: [
        OverlayEntry(builder: (_) => child ?? const SizedBox.shrink()),
      ],
    );
  }

  static void toast({required String msg}) =>
      _show(type: ToastType.neutral, message: msg);

  static void success({String? title, required String msg}) =>
      _show(type: ToastType.success, title: title ?? 'Success', message: msg);

  static void error({String? title, required String msg}) =>
      _show(type: ToastType.error, title: title ?? 'Error', message: msg);

  static void warning({String? title, required String msg}) =>
      _show(type: ToastType.warning, title: title ?? 'Warning', message: msg);

  static void info({String? title, required String msg}) =>
      _show(type: ToastType.info, title: title ?? 'Did you know?', message: msg);

  static void toastWithAction({
    required String msg,
    required String label,
    required VoidCallback onPressed,
    ToastType type = ToastType.neutral,
    String? title,
  }) =>
      _show(
        type: type,
        title: title,
        message: msg,
        actionLabel: label,
        onAction: onPressed,
      );

  // ─── Internals ─────────────────────────────────────────────────────────────

  static void _show({
    required ToastType type,
    String? title,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = _overlayKey.currentState ?? _navigatorKey?.currentState?.overlay;
    if (overlay == null) return;

    _current?.remove();
    _current = null;

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _TopToastWidget(
        style: _styleFor(type),
        title: title,
        message: message,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: duration,
        onDismiss: () {
          entry.remove();
          if (_current == entry) _current = null;
        },
      ),
    );

    _current = entry;
    overlay.insert(entry);
  }

  static Color _tint(Color c, double opacity) =>
      Color.alphaBlend(c.withValues(alpha: opacity), Colors.white);

  static _ToastStyle _styleFor(ToastType type) {
    switch (type) {
      case ToastType.success:
        const accent = Color(0xFF15803D);
        return _ToastStyle(
          cardColor: _tint(accent, .10),
          borderColor: _tint(accent, .28),
          iconBgColor: accent,
          iconColor: Colors.white,
          titleColor: const Color(0xFF111111),
          messageColor: const Color(0xFF666666),
          closeColor: const Color(0xFF9CA3AF),
          actionColor: accent,
          icon: Icons.check_rounded,
        );
      case ToastType.error:
        const accent = Color(0xFFDC2626);
        return _ToastStyle(
          cardColor: _tint(accent, .10),
          borderColor: _tint(accent, .28),
          iconBgColor: accent,
          iconColor: Colors.white,
          titleColor: const Color(0xFF111111),
          messageColor: const Color(0xFF666666),
          closeColor: const Color(0xFF9CA3AF),
          actionColor: accent,
          icon: Icons.close_rounded,
        );
      case ToastType.warning:
        const accent = Color(0xFFF59E0B);
        return _ToastStyle(
          cardColor: _tint(accent, .12),
          borderColor: _tint(accent, .32),
          iconBgColor: accent,
          iconColor: Colors.white,
          titleColor: const Color(0xFF111111),
          messageColor: const Color(0xFF666666),
          closeColor: const Color(0xFF9CA3AF),
          actionColor: const Color(0xFFB45309),
          icon: Icons.priority_high_rounded,
        );
      case ToastType.info:
        const accent = Color(0xFF2563EB);
        return _ToastStyle(
          cardColor: _tint(accent, .10),
          borderColor: _tint(accent, .28),
          iconBgColor: accent,
          iconColor: Colors.white,
          titleColor: const Color(0xFF111111),
          messageColor: const Color(0xFF666666),
          closeColor: const Color(0xFF9CA3AF),
          actionColor: accent,
          icon: Icons.lightbulb_rounded,
        );
      case ToastType.neutral:
        const accent = Color(0xFF666666);
        return _ToastStyle(
          cardColor: _tint(accent, .10),
          borderColor: _tint(accent, .28),
          iconBgColor: accent,
          iconColor: Colors.white,
          titleColor: const Color(0xFF111111),
          messageColor: const Color(0xFF666666),
          closeColor: const Color(0xFF9CA3AF),
          actionColor: accent,
          icon: Icons.info_outline_rounded,
        );
    }
  }
}

// ─── Style ────────────────────────────────────────────────────────────────────

class _ToastStyle {
  final Color cardColor, borderColor, iconBgColor, iconColor;
  final Color titleColor, messageColor, closeColor, actionColor;
  final IconData icon;

  const _ToastStyle({
    required this.cardColor,
    required this.borderColor,
    required this.iconBgColor,
    required this.iconColor,
    required this.titleColor,
    required this.messageColor,
    required this.closeColor,
    required this.actionColor,
    required this.icon,
  });
}

// ─── Overlay widget ───────────────────────────────────────────────────────────

class _TopToastWidget extends StatefulWidget {
  final _ToastStyle style;
  final String? title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Duration duration;
  final VoidCallback onDismiss;

  const _TopToastWidget({
    required this.style,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_TopToastWidget> createState() => _TopToastWidgetState();
}

class _TopToastWidgetState extends State<_TopToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
    );
    _slide = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

    _ctrl.forward();
    Future.delayed(widget.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    await _ctrl.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top + 12;
    return Positioned(
      top: top,
      left: 12,
      right: 12,
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: GestureDetector(
            onTap: _dismiss,
            onVerticalDragEnd: (details) {
              if ((details.primaryVelocity ?? 0) < 0) _dismiss();
            },
            child: Material(
              color: Colors.transparent,
              child: _ToastCard(
                style: widget.style,
                title: widget.title,
                message: widget.message,
                actionLabel: widget.actionLabel,
                onAction: widget.onAction,
                onClose: _dismiss,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Card ─────────────────────────────────────────────────────────────────────

class _ToastCard extends StatelessWidget {
  final _ToastStyle style;
  final String? title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback onClose;

  const _ToastCard({
    required this.style,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    required this.onClose,
  });

  bool get _hasTitle => title?.trim().isNotEmpty ?? false;
  bool get _hasAction => actionLabel != null && onAction != null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: style.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: style.borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment:
                _hasTitle ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: style.iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(style.icon, color: style.iconColor, size: 19),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_hasTitle)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          title!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: style.titleColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: _hasTitle ? 12 : 14,
                        fontWeight: FontWeight.w400,
                        color: style.messageColor,
                        height: 1.35,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (_hasAction) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    onClose();
                    onAction!();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      actionLabel!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: style.actionColor,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 4),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onClose,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Icon(Icons.close_rounded, size: 18, color: style.closeColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
