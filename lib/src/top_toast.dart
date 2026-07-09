import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'top_toast_types.dart';

// ─── Internal data ────────────────────────────────────────────────────────────

class _ToastData {
  static int _counter = 0;

  final String id;
  final ToastType type;
  final String? title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Duration? duration;
  final bool persistent;
  final VoidCallback? onTap;
  final ToastPosition position;
  final IconData? customIcon;
  final Color? cardColor;
  final Color? borderColor;
  final Color? iconBgColor;
  final Color? iconColor;
  final Color? actionColor;
  final ToastAnimation? animation;
  final bool? showProgressBar;

  _ToastData({
    required this.type,
    required this.message,
    required this.position,
    this.title,
    this.actionLabel,
    this.onAction,
    this.duration,
    this.persistent = false,
    this.onTap,
    this.customIcon,
    this.cardColor,
    this.borderColor,
    this.iconBgColor,
    this.iconColor,
    this.actionColor,
    this.animation,
    this.showProgressBar,
  }) : id = (++_counter).toString();
}

// ─── Public API ───────────────────────────────────────────────────────────────

class TopToast {
  TopToast._();

  static GlobalKey<NavigatorState>? _navigatorKey;
  static final _overlayKey = GlobalKey<OverlayState>();
  static Brightness? _forcedBrightness;
  static TopToastConfig _config = const TopToastConfig();

  // Stack management via ValueNotifier — no GlobalKey needed on _ToastStack.
  static OverlayEntry? _stackEntry;
  static final _toastsNotifier = ValueNotifier<List<_ToastData>>([]);
  static final _queueNotifier = ValueNotifier<List<_ToastData>>([]);

  // ─── Setup ───────────────────────────────────────────────────────────────

  /// Initialise once before showing any toast (typically in `main()`).
  ///
  /// Supply a [TopToastConfig] to customise global behaviour.
  static void init({
    required GlobalKey<NavigatorState> navigatorKey,
    TopToastConfig config = const TopToastConfig(),
  }) {
    _navigatorKey = navigatorKey;
    _config = config;
  }

  /// Auto-detects light/dark from the system theme. Pass to
  /// `MaterialApp`/`MaterialApp.router`'s `builder` so toasts always render
  /// above dialogs and bottom sheets.
  static Widget builder(BuildContext context, Widget? child) =>
      _buildOverlay(context, child, null);

  /// Forces the **light** colour scheme regardless of device theme.
  static Widget lightBuilder(BuildContext context, Widget? child) =>
      _buildOverlay(context, child, Brightness.light);

  /// Forces the **dark** colour scheme regardless of device theme.
  static Widget darkBuilder(BuildContext context, Widget? child) =>
      _buildOverlay(context, child, Brightness.dark);

  static Widget _buildOverlay(BuildContext context, Widget? child, Brightness? b) {
    _forcedBrightness = b;
    return Overlay(
      key: _overlayKey,
      initialEntries: [
        OverlayEntry(builder: (_) => child ?? const SizedBox.shrink()),
      ],
    );
  }

  // ─── Toast methods ────────────────────────────────────────────────────────

  static void toast({
    required String msg,
    ToastPosition? position,
    Duration? duration,
    bool persistent = false,
    VoidCallback? onTap,
    IconData? icon,
    Color? cardColor,
    Color? borderColor,
    Color? iconBgColor,
    Color? iconColor,
    ToastAnimation? animation,
    bool? showProgressBar,
  }) =>
      _show(_ToastData(
        type: ToastType.neutral,
        message: msg,
        position: position ?? _config.position,
        duration: duration,
        persistent: persistent,
        onTap: onTap,
        customIcon: icon,
        cardColor: cardColor,
        borderColor: borderColor,
        iconBgColor: iconBgColor,
        iconColor: iconColor,
        animation: animation,
        showProgressBar: showProgressBar,
      ));

  static void success({
    String? title,
    required String msg,
    ToastPosition? position,
    Duration? duration,
    bool persistent = false,
    VoidCallback? onTap,
    IconData? icon,
    Color? cardColor,
    Color? borderColor,
    Color? iconBgColor,
    Color? iconColor,
    Color? actionColor,
    ToastAnimation? animation,
    bool? showProgressBar,
  }) =>
      _show(_ToastData(
        type: ToastType.success,
        title: title ?? 'Success',
        message: msg,
        position: position ?? _config.position,
        duration: duration,
        persistent: persistent,
        onTap: onTap,
        customIcon: icon,
        cardColor: cardColor,
        borderColor: borderColor,
        iconBgColor: iconBgColor,
        iconColor: iconColor,
        actionColor: actionColor,
        animation: animation,
        showProgressBar: showProgressBar,
      ));

  static void error({
    String? title,
    required String msg,
    ToastPosition? position,
    Duration? duration,
    bool persistent = false,
    VoidCallback? onTap,
    IconData? icon,
    Color? cardColor,
    Color? borderColor,
    Color? iconBgColor,
    Color? iconColor,
    Color? actionColor,
    ToastAnimation? animation,
    bool? showProgressBar,
  }) =>
      _show(_ToastData(
        type: ToastType.error,
        title: title ?? 'Error',
        message: msg,
        position: position ?? _config.position,
        duration: duration,
        persistent: persistent,
        onTap: onTap,
        customIcon: icon,
        cardColor: cardColor,
        borderColor: borderColor,
        iconBgColor: iconBgColor,
        iconColor: iconColor,
        actionColor: actionColor,
        animation: animation,
        showProgressBar: showProgressBar,
      ));

  static void warning({
    String? title,
    required String msg,
    ToastPosition? position,
    Duration? duration,
    bool persistent = false,
    VoidCallback? onTap,
    IconData? icon,
    Color? cardColor,
    Color? borderColor,
    Color? iconBgColor,
    Color? iconColor,
    Color? actionColor,
    ToastAnimation? animation,
    bool? showProgressBar,
  }) =>
      _show(_ToastData(
        type: ToastType.warning,
        title: title ?? 'Warning',
        message: msg,
        position: position ?? _config.position,
        duration: duration,
        persistent: persistent,
        onTap: onTap,
        customIcon: icon,
        cardColor: cardColor,
        borderColor: borderColor,
        iconBgColor: iconBgColor,
        iconColor: iconColor,
        actionColor: actionColor,
        animation: animation,
        showProgressBar: showProgressBar,
      ));

  static void info({
    String? title,
    required String msg,
    ToastPosition? position,
    Duration? duration,
    bool persistent = false,
    VoidCallback? onTap,
    IconData? icon,
    Color? cardColor,
    Color? borderColor,
    Color? iconBgColor,
    Color? iconColor,
    Color? actionColor,
    ToastAnimation? animation,
    bool? showProgressBar,
  }) =>
      _show(_ToastData(
        type: ToastType.info,
        title: title ?? 'Did you know?',
        message: msg,
        position: position ?? _config.position,
        duration: duration,
        persistent: persistent,
        onTap: onTap,
        customIcon: icon,
        cardColor: cardColor,
        borderColor: borderColor,
        iconBgColor: iconBgColor,
        iconColor: iconColor,
        actionColor: actionColor,
        animation: animation,
        showProgressBar: showProgressBar,
      ));

  static void toastWithAction({
    required String msg,
    required String label,
    required VoidCallback onPressed,
    ToastType type = ToastType.neutral,
    String? title,
    ToastPosition? position,
    Duration? duration,
    bool persistent = false,
    VoidCallback? onTap,
    IconData? icon,
    Color? cardColor,
    Color? borderColor,
    Color? iconBgColor,
    Color? iconColor,
    Color? actionColor,
    ToastAnimation? animation,
    bool? showProgressBar,
  }) =>
      _show(_ToastData(
        type: type,
        title: title,
        message: msg,
        actionLabel: label,
        onAction: onPressed,
        position: position ?? _config.position,
        duration: duration,
        persistent: persistent,
        onTap: onTap,
        customIcon: icon,
        cardColor: cardColor,
        borderColor: borderColor,
        iconBgColor: iconBgColor,
        iconColor: iconColor,
        actionColor: actionColor,
        animation: animation,
        showProgressBar: showProgressBar,
      ));

  /// Immediately removes all visible toasts and clears the queue.
  static void dismissAll() {
    _toastsNotifier.value = [];
    _queueNotifier.value = [];
    _stackEntry?.remove();
    _stackEntry = null;
  }

  // ─── Internal show / remove ───────────────────────────────────────────────

  static void _show(_ToastData data) {
    final overlay = _overlayKey.currentState ?? _navigatorKey?.currentState?.overlay;
    if (overlay == null) return;

    if (_config.hapticFeedback) HapticFeedback.lightImpact();

    if (_stackEntry == null) {
      _stackEntry = OverlayEntry(builder: (_) => const _ToastStack());
      overlay.insert(_stackEntry!);
    }

    final active = _toastsNotifier.value;

    if (_config.stackMode) {
      if (active.length >= _config.maxStack) {
        if (_config.queueMode) {
          _queueNotifier.value = [..._queueNotifier.value, data];
        } else {
          _toastsNotifier.value = [...active.skip(1), data];
        }
      } else {
        _toastsNotifier.value = [...active, data];
      }
    } else {
      if (_config.queueMode && active.isNotEmpty) {
        _queueNotifier.value = [..._queueNotifier.value, data];
      } else {
        _toastsNotifier.value = [data];
      }
    }
  }

  static void _removeToast(String id) {
    final active = _toastsNotifier.value.where((d) => d.id != id).toList();
    _toastsNotifier.value = active;

    final queue = List<_ToastData>.from(_queueNotifier.value);

    if (active.isEmpty && queue.isEmpty) {
      _stackEntry?.remove();
      _stackEntry = null;
      return;
    }

    if (queue.isNotEmpty &&
        (!_config.stackMode || active.length < _config.maxStack)) {
      final next = queue.removeAt(0);
      _queueNotifier.value = queue;
      _toastsNotifier.value = [...active, next];
    }
  }

  // ─── Style ───────────────────────────────────────────────────────────────

  static Color _tintLight(Color c, double opacity) =>
      Color.alphaBlend(c.withValues(alpha: opacity), Colors.white);

  static _ToastStyle styleFor(ToastType type, Brightness brightness) {
    final dark = brightness == Brightness.dark;
    switch (type) {
      case ToastType.success:
        return dark
            ? const _ToastStyle(
                cardColor: Color(0xFF052E16),
                borderColor: Color(0xFF166534),
                iconBgColor: Color(0xFF16A34A),
                iconColor: Colors.white,
                titleColor: Color(0xFFF9FAFB),
                messageColor: Color(0xFF9CA3AF),
                closeColor: Color(0xFF6B7280),
                actionColor: Color(0xFF4ADE80),
                icon: Icons.check_rounded,
              )
            : _ToastStyle(
                cardColor: _tintLight(const Color(0xFF15803D), .10),
                borderColor: _tintLight(const Color(0xFF15803D), .28),
                iconBgColor: const Color(0xFF15803D),
                iconColor: Colors.white,
                titleColor: const Color(0xFF111111),
                messageColor: const Color(0xFF666666),
                closeColor: const Color(0xFF9CA3AF),
                actionColor: const Color(0xFF15803D),
                icon: Icons.check_rounded,
              );

      case ToastType.error:
        return dark
            ? const _ToastStyle(
                cardColor: Color(0xFF450A0A),
                borderColor: Color(0xFF991B1B),
                iconBgColor: Color(0xFFDC2626),
                iconColor: Colors.white,
                titleColor: Color(0xFFF9FAFB),
                messageColor: Color(0xFF9CA3AF),
                closeColor: Color(0xFF6B7280),
                actionColor: Color(0xFFF87171),
                icon: Icons.close_rounded,
              )
            : _ToastStyle(
                cardColor: _tintLight(const Color(0xFFDC2626), .10),
                borderColor: _tintLight(const Color(0xFFDC2626), .28),
                iconBgColor: const Color(0xFFDC2626),
                iconColor: Colors.white,
                titleColor: const Color(0xFF111111),
                messageColor: const Color(0xFF666666),
                closeColor: const Color(0xFF9CA3AF),
                actionColor: const Color(0xFFDC2626),
                icon: Icons.close_rounded,
              );

      case ToastType.warning:
        return dark
            ? const _ToastStyle(
                cardColor: Color(0xFF1C0A00),
                borderColor: Color(0xFF92400E),
                iconBgColor: Color(0xFFD97706),
                iconColor: Colors.white,
                titleColor: Color(0xFFF9FAFB),
                messageColor: Color(0xFF9CA3AF),
                closeColor: Color(0xFF6B7280),
                actionColor: Color(0xFFFBBF24),
                icon: Icons.priority_high_rounded,
              )
            : _ToastStyle(
                cardColor: _tintLight(const Color(0xFFF59E0B), .12),
                borderColor: _tintLight(const Color(0xFFF59E0B), .32),
                iconBgColor: const Color(0xFFF59E0B),
                iconColor: Colors.white,
                titleColor: const Color(0xFF111111),
                messageColor: const Color(0xFF666666),
                closeColor: const Color(0xFF9CA3AF),
                actionColor: const Color(0xFFB45309),
                icon: Icons.priority_high_rounded,
              );

      case ToastType.info:
        return dark
            ? const _ToastStyle(
                cardColor: Color(0xFF0C1A45),
                borderColor: Color(0xFF1E3A8A),
                iconBgColor: Color(0xFF2563EB),
                iconColor: Colors.white,
                titleColor: Color(0xFFF9FAFB),
                messageColor: Color(0xFF9CA3AF),
                closeColor: Color(0xFF6B7280),
                actionColor: Color(0xFF93C5FD),
                icon: Icons.lightbulb_rounded,
              )
            : _ToastStyle(
                cardColor: _tintLight(const Color(0xFF2563EB), .10),
                borderColor: _tintLight(const Color(0xFF2563EB), .28),
                iconBgColor: const Color(0xFF2563EB),
                iconColor: Colors.white,
                titleColor: const Color(0xFF111111),
                messageColor: const Color(0xFF666666),
                closeColor: const Color(0xFF9CA3AF),
                actionColor: const Color(0xFF2563EB),
                icon: Icons.lightbulb_rounded,
              );

      case ToastType.neutral:
        return dark
            ? const _ToastStyle(
                cardColor: Color(0xFF111827),
                borderColor: Color(0xFF374151),
                iconBgColor: Color(0xFF4B5563),
                iconColor: Colors.white,
                titleColor: Color(0xFFF9FAFB),
                messageColor: Color(0xFF9CA3AF),
                closeColor: Color(0xFF6B7280),
                actionColor: Color(0xFF9CA3AF),
                icon: Icons.info_outline_rounded,
              )
            : _ToastStyle(
                cardColor: _tintLight(const Color(0xFF666666), .10),
                borderColor: _tintLight(const Color(0xFF666666), .28),
                iconBgColor: const Color(0xFF666666),
                iconColor: Colors.white,
                titleColor: const Color(0xFF111111),
                messageColor: const Color(0xFF666666),
                closeColor: const Color(0xFF9CA3AF),
                actionColor: const Color(0xFF666666),
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

// ─── Toast stack (single overlay entry managing all visible toasts) ───────────

class _ToastStack extends StatelessWidget {
  const _ToastStack();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<_ToastData>>(
      valueListenable: TopToast._toastsNotifier,
      builder: (_, toasts, __) {
        if (toasts.isEmpty) return const SizedBox.shrink();
        return Stack(
          fit: StackFit.expand,
          children: [
            for (int i = 0; i < toasts.length; i++)
              _TopToastWidget(
                key: ValueKey(toasts[i].id),
                data: toasts[i],
                stackIndex: i,
                onDismiss: () => TopToast._removeToast(toasts[i].id),
              ),
          ],
        );
      },
    );
  }
}

// ─── Single toast widget ──────────────────────────────────────────────────────

class _TopToastWidget extends StatefulWidget {
  final _ToastData data;
  final int stackIndex;
  final VoidCallback onDismiss;

  const _TopToastWidget({
    super.key,
    required this.data,
    required this.stackIndex,
    required this.onDismiss,
  });

  @override
  State<_TopToastWidget> createState() => _TopToastWidgetState();
}

class _TopToastWidgetState extends State<_TopToastWidget>
    with TickerProviderStateMixin {
  // Entry/exit animation
  late final AnimationController _ctrl;
  late final Animation<Offset> _slide;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  // Auto-dismiss timer (drives progress bar + pause-on-hover)
  AnimationController? _timerCtrl;

  bool get _isBottom =>
      widget.data.position == ToastPosition.bottom ||
      widget.data.position == ToastPosition.bottomLeft ||
      widget.data.position == ToastPosition.bottomRight;

  bool get _isCorner =>
      widget.data.position == ToastPosition.topLeft ||
      widget.data.position == ToastPosition.topRight ||
      widget.data.position == ToastPosition.bottomLeft ||
      widget.data.position == ToastPosition.bottomRight;

  Alignment get _scaleAlignment {
    switch (widget.data.position) {
      case ToastPosition.top:        return Alignment.topCenter;
      case ToastPosition.bottom:     return Alignment.bottomCenter;
      case ToastPosition.topLeft:    return Alignment.topLeft;
      case ToastPosition.topRight:   return Alignment.topRight;
      case ToastPosition.bottomLeft: return Alignment.bottomLeft;
      case ToastPosition.bottomRight:return Alignment.bottomRight;
    }
  }

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
    );

    final slideBegin = _isBottom ? const Offset(0, 1) : const Offset(0, -1);
    _slide = Tween<Offset>(begin: slideBegin, end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _scale = Tween<double>(begin: 0.85, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

    _ctrl.forward();

    // Auto-dismiss timer
    if (!widget.data.persistent) {
      final dur = widget.data.duration ?? TopToast._config.defaultDuration;
      _timerCtrl = AnimationController(vsync: this, duration: dur)
        ..addStatusListener((s) {
          if (s == AnimationStatus.completed) _dismiss();
        })
        ..forward();
    }
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    _timerCtrl?.stop();
    await _ctrl.reverse();
    if (mounted) widget.onDismiss();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _timerCtrl?.dispose();
    super.dispose();
  }

  Widget _wrapAnimation(Widget child) {
    final anim = widget.data.animation ?? TopToast._config.animation;
    switch (anim) {
      case ToastAnimation.slide:
        return SlideTransition(
          position: _slide,
          child: FadeTransition(opacity: _fade, child: child),
        );
      case ToastAnimation.scale:
        return ScaleTransition(
          scale: _scale,
          alignment: _scaleAlignment,
          child: FadeTransition(opacity: _fade, child: child),
        );
      case ToastAnimation.fade:
        return FadeTransition(opacity: _fade, child: child);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final padding = mq.padding;
    final brightness = TopToast._forcedBrightness ?? mq.platformBrightness;

    // Build the base style then apply any per-toast overrides
    final baseStyle = TopToast.styleFor(widget.data.type, brightness);
    final style = _ToastStyle(
      cardColor:    widget.data.cardColor    ?? baseStyle.cardColor,
      borderColor:  widget.data.borderColor  ?? baseStyle.borderColor,
      iconBgColor:  widget.data.iconBgColor  ?? baseStyle.iconBgColor,
      iconColor:    widget.data.iconColor    ?? baseStyle.iconColor,
      titleColor:   baseStyle.titleColor,
      messageColor: baseStyle.messageColor,
      closeColor:   baseStyle.closeColor,
      actionColor:  widget.data.actionColor  ?? baseStyle.actionColor,
      icon:         widget.data.customIcon   ?? baseStyle.icon,
    );

    final bool anchorRight = widget.data.position == ToastPosition.topRight ||
        widget.data.position == ToastPosition.bottomRight;
    final bool anchorLeft = widget.data.position == ToastPosition.topLeft ||
        widget.data.position == ToastPosition.bottomLeft;

    final double cornerWidth =
        (mq.size.width - 24).clamp(0.0, TopToast._config.cornerWidth);
    final double stackOffset =
        widget.stackIndex * TopToast._config.stackSpacing;

    final bool showProgress =
        widget.data.showProgressBar ?? TopToast._config.showProgressBar;

    Widget card = _ToastCard(
      style: style,
      title: widget.data.title,
      message: widget.data.message,
      actionLabel: widget.data.actionLabel,
      onAction: widget.data.onAction,
      onClose: _dismiss,
      isCorner: _isCorner,
      timerAnimation: showProgress ? _timerCtrl : null,
    );

    // Hover pause — web/desktop only
    card = MouseRegion(
      onEnter: (_) => _timerCtrl?.stop(),
      onExit: (_) {
        if (_timerCtrl != null && !_timerCtrl!.isCompleted) {
          _timerCtrl!.forward();
        }
      },
      child: card,
    );

    return Positioned(
      top:    _isBottom ? null : padding.top + 12 + stackOffset,
      bottom: _isBottom ? padding.bottom + 12 + stackOffset : null,
      left:   anchorRight ? null : 12,
      right:  anchorLeft  ? null : 12,
      width:  _isCorner   ? cornerWidth : null,
      child: _wrapAnimation(
        GestureDetector(
          onTap: () {
            _dismiss();
            widget.data.onTap?.call();
          },
          onVerticalDragEnd: (d) {
            final v = d.primaryVelocity ?? 0;
            if (_isBottom ? v > 0 : v < 0) _dismiss();
          },
          onHorizontalDragEnd: _isCorner
              ? (d) {
                  final v = d.primaryVelocity ?? 0;
                  final isRight = widget.data.position == ToastPosition.topRight ||
                      widget.data.position == ToastPosition.bottomRight;
                  if (isRight ? v > 200 : v < -200) _dismiss();
                }
              : null,
          child: Material(color: Colors.transparent, child: card),
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
  final bool isCorner;
  final AnimationController? timerAnimation;

  const _ToastCard({
    required this.style,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    required this.onClose,
    required this.isCorner,
    required this.timerAnimation,
  });

  bool get _hasTitle => title?.trim().isNotEmpty ?? false;
  bool get _hasAction => actionLabel != null && onAction != null;

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isCorner ? double.infinity : TopToast._config.maxWidth,
        ),
        child: Container(
          width: isCorner ? double.infinity : null,
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
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  crossAxisAlignment: _hasTitle
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
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
                          padding:
                              const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
                        child: Icon(Icons.close_rounded,
                            size: 18, color: style.closeColor),
                      ),
                    ),
                  ],
                ),
              ),

              // Progress bar
              if (timerAnimation != null)
                AnimatedBuilder(
                  animation: timerAnimation!,
                  builder: (_, __) => SizedBox(
                    height: 3,
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: FractionallySizedBox(
                        widthFactor: 1.0 - timerAnimation!.value,
                        child: Container(
                          color: style.iconBgColor.withValues(alpha: .65),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    return content;
  }
}
