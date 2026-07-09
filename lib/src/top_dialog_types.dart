/// Dialog variant — controls icon, accent colour, and default labels.
enum DialogType {
  /// Destructive action. Confirm button is red.
  delete,

  /// Cautionary action. Confirm button is amber.
  warning,

  /// Informational success state. No cancel by default.
  success,

  /// Informational failure state. No cancel by default.
  failed,

  /// Generic "are you sure?" prompt. Confirm button is blue.
  confirmation,

  /// Fully custom icon, colour, and labels.
  custom,
}

/// Global defaults for [TopDialog.show].
///
/// Any field set here applies to every dialog unless the individual call
/// overrides it.
class TopDialogConfig {
  /// `null` — use the type's smart default (false for success/failed, true otherwise).
  final bool? showCancel;

  /// Default confirm button label. Falls back to a type-specific label if null.
  final String? confirmLabel;

  /// Default cancel button label.
  final String cancelLabel;

  /// Max width of the dialog card. Default 360.
  final double maxWidth;

  /// Whether tapping the barrier closes the dialog.
  final bool barrierDismissible;

  const TopDialogConfig({
    this.showCancel,
    this.confirmLabel,
    this.cancelLabel = 'Cancel',
    this.maxWidth = 450,
    this.barrierDismissible = true,
  });
}
