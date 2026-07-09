import 'package:flutter/material.dart';
import 'top_dialog_types.dart';

// ─── Public API ───────────────────────────────────────────────────────────────

class TopDialog {
  TopDialog._();

  /// Show a confirmation dialog.
  ///
  /// Supply either [onConfirm] (sync) or [onAsyncConfirm] (async).
  /// When [onAsyncConfirm] is provided the confirm button shows a spinner
  /// while the future runs, then closes automatically on completion.
  static Future<void> show(
    BuildContext context, {
    required DialogType type,
    String? title,
    String? message,
    String? confirmLabel,
    String? cancelLabel,
    bool? showCancel,
    bool? barrierDismissible,
    VoidCallback? onConfirm,
    Future<void> Function()? onAsyncConfirm,
    VoidCallback? onCancel,
    // Custom type only
    Widget? customIcon,
    Color? accentColor,
    TopDialogConfig config = const TopDialogConfig(),
  }) {
    assert(
      onConfirm != null || onAsyncConfirm != null,
      'Provide at least onConfirm or onAsyncConfirm.',
    );

    return showGeneralDialog(
      context: context,
      barrierDismissible: barrierDismissible ?? config.barrierDismissible,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, __, ___) => _TopDialogWidget(
        type: type,
        title: title ?? _defaultTitle(type),
        message: message,
        confirmLabel: confirmLabel ?? config.confirmLabel ?? _defaultConfirmLabel(type),
        cancelLabel: cancelLabel ?? config.cancelLabel,
        showCancel: showCancel ?? config.showCancel ?? _defaultShowCancel(type),
        onConfirm: onConfirm,
        onAsyncConfirm: onAsyncConfirm,
        onCancel: onCancel,
        customIcon: customIcon,
        accentColor: accentColor,
        config: config,
      ),
      transitionBuilder: (_, anim, __, child) => ScaleTransition(
        scale: Tween<double>(begin: 0.88, end: 1.0).animate(
          CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
        ),
        child: FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  static String _defaultTitle(DialogType t) => switch (t) {
        DialogType.delete       => 'Delete?',
        DialogType.warning      => 'Warning',
        DialogType.success      => 'Success!',
        DialogType.failed       => 'Failed',
        DialogType.confirmation => 'Are you sure?',
        DialogType.custom       => '',
      };

  static String _defaultConfirmLabel(DialogType t) => switch (t) {
        DialogType.delete       => 'Delete',
        DialogType.warning      => 'Continue',
        DialogType.success      => 'Got it',
        DialogType.failed       => 'Try again',
        DialogType.confirmation => 'Confirm',
        DialogType.custom       => 'Confirm',
      };

  static bool _defaultShowCancel(DialogType t) => switch (t) {
        DialogType.success => false,
        DialogType.failed  => false,
        _                  => true,
      };
}

// ─── Dialog widget ────────────────────────────────────────────────────────────

class _TopDialogWidget extends StatefulWidget {
  final DialogType type;
  final String title;
  final String? message;
  final String confirmLabel;
  final String cancelLabel;
  final bool showCancel;
  final VoidCallback? onConfirm;
  final Future<void> Function()? onAsyncConfirm;
  final VoidCallback? onCancel;
  final Widget? customIcon;
  final Color? accentColor;
  final TopDialogConfig config;

  const _TopDialogWidget({
    required this.type,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.showCancel,
    required this.onConfirm,
    required this.onAsyncConfirm,
    required this.onCancel,
    required this.customIcon,
    required this.accentColor,
    required this.config,
  });

  @override
  State<_TopDialogWidget> createState() => _TopDialogWidgetState();
}

class _TopDialogWidgetState extends State<_TopDialogWidget> {
  bool _isLoading = false;

  Color get _accent =>
      widget.accentColor ?? _accentForType(widget.type);

  Color _accentForType(DialogType t) => switch (t) {
        DialogType.delete       => const Color(0xFFDC2626),
        DialogType.warning      => const Color(0xFFF59E0B),
        DialogType.success      => const Color(0xFF15803D),
        DialogType.failed       => const Color(0xFFDC2626),
        DialogType.confirmation => const Color(0xFF2563EB),
        DialogType.custom       => const Color(0xFF2563EB),
      };

  Future<void> _handleConfirm() async {
    if (widget.onAsyncConfirm != null) {
      setState(() => _isLoading = true);
      try {
        await widget.onAsyncConfirm!();
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
          Navigator.of(context).pop();
        }
      }
    } else {
      widget.onConfirm?.call();
      if (mounted) Navigator.of(context).pop();
    }
  }

  void _handleCancel() {
    if (_isLoading) return;
    widget.onCancel?.call();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final titleColor = isDark ? const Color(0xFFF9FAFB) : const Color(0xFF111111);
    final msgColor   = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF666666);
    final cancelBorderColor = isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB);
    final cancelTextColor   = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF666666);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: widget.config.maxWidth),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? .45 : .14),
                  blurRadius: 40,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  _buildIconArea(),
                  const SizedBox(height: 18),

                  // Title
                  if (widget.title.isNotEmpty)
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),

                  // Message
                  if (widget.message != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      widget.message!,
                      style: TextStyle(
                        fontSize: 14,
                        color: msgColor,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      if (widget.showCancel) ...[
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isLoading ? null : _handleCancel,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: cancelBorderColor),
                            ),
                            child: Text(
                              widget.cancelLabel,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: cancelTextColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleConfirm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _accent,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: _accent.withValues(alpha: .75),
                            disabledForegroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  widget.confirmLabel,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconArea() {
    final isCustomWithWidget =
        widget.type == DialogType.custom && widget.customIcon != null;

    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: _accent.withValues(alpha: .14),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: _accent,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: isCustomWithWidget
            ? widget.customIcon!
            : CustomPaint(
                size: const Size(28, 28),
                painter: _painterFor(widget.type),
              ),
      ),
    );
  }

  CustomPainter _painterFor(DialogType t) => switch (t) {
        DialogType.delete       => const _DeletePainter(),
        DialogType.warning      => const _WarningPainter(),
        DialogType.success      => const _SuccessPainter(),
        DialogType.failed       => const _FailedPainter(),
        DialogType.confirmation => const _QuestionPainter(),
        DialogType.custom       => const _QuestionPainter(),
      };
}

// ─── SVG-style icon painters ─────────────────────────────────────────────────
//
// All painters use white strokes on a transparent background.
// Coordinates are normalized to the canvas Size so they scale perfectly.

Paint _iconPaint(double strokeWidth) => Paint()
  ..color = Colors.white
  ..strokeWidth = strokeWidth
  ..style = PaintingStyle.stroke
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round;

Paint _iconFill() => Paint()
  ..color = Colors.white
  ..style = PaintingStyle.fill;

// Trash / delete
class _DeletePainter extends CustomPainter {
  const _DeletePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final p = _iconPaint(w * .10);
    final cx = w / 2;

    // Lid (horizontal bar)
    canvas.drawLine(Offset(w * .10, h * .29), Offset(w * .90, h * .29), p);

    // Handle above lid
    canvas.drawPath(
      Path()
        ..moveTo(cx - w * .14, h * .29)
        ..lineTo(cx - w * .14, h * .16)
        ..lineTo(cx + w * .14, h * .16)
        ..lineTo(cx + w * .14, h * .29),
      p,
    );

    // Body trapezoid
    canvas.drawPath(
      Path()
        ..moveTo(w * .18, h * .29)
        ..lineTo(w * .24, h * .86)
        ..lineTo(w * .76, h * .86)
        ..lineTo(w * .82, h * .29),
      p,
    );

    // Inner vertical lines
    canvas.drawLine(Offset(cx - w * .13, h * .44), Offset(cx - w * .13, h * .73), p);
    canvas.drawLine(Offset(cx + w * .13, h * .44), Offset(cx + w * .13, h * .73), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// Warning triangle with exclamation
class _WarningPainter extends CustomPainter {
  const _WarningPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final p = _iconPaint(w * .10);
    final cx = w / 2;

    // Triangle
    canvas.drawPath(
      Path()
        ..moveTo(cx, h * .10)
        ..lineTo(w * .90, h * .85)
        ..lineTo(w * .10, h * .85)
        ..close(),
      p,
    );

    // Exclamation line
    canvas.drawLine(Offset(cx, h * .35), Offset(cx, h * .60), p);
    // Exclamation dot
    canvas.drawCircle(Offset(cx, h * .73), w * .045, _iconFill());
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// Checkmark (success)
class _SuccessPainter extends CustomPainter {
  const _SuccessPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final p = _iconPaint(w * .11);
    final cx = w / 2;
    final cy = h / 2;

    canvas.drawPath(
      Path()
        ..moveTo(cx - w * .28, cy + h * .02)
        ..lineTo(cx - w * .06, cy + h * .24)
        ..lineTo(cx + w * .30, cy - h * .22),
      p,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// X mark (failed)
class _FailedPainter extends CustomPainter {
  const _FailedPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final p = _iconPaint(w * .11);
    final cx = w / 2;
    final cy = h / 2;
    const r = 0.26;

    canvas.drawLine(Offset(cx - w * r, cy - h * r), Offset(cx + w * r, cy + h * r), p);
    canvas.drawLine(Offset(cx + w * r, cy - h * r), Offset(cx - w * r, cy + h * r), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// Question mark (confirmation / custom fallback)
class _QuestionPainter extends CustomPainter {
  const _QuestionPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final p = _iconPaint(w * .10);
    final cx = w / 2;

    // ? arc
    final path = Path()
      ..moveTo(cx - w * .18, h * .28)
      ..cubicTo(cx - w * .18, h * .12, cx + w * .22, h * .12, cx + w * .22, h * .34)
      ..cubicTo(cx + w * .22, h * .48, cx, h * .46, cx, h * .58);
    canvas.drawPath(path, p);

    // dot
    canvas.drawCircle(Offset(cx, h * .76), w * .052, _iconFill());
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}
