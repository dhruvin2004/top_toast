/// Toast variant — controls icon, accent colour, and card tint.
enum ToastType { success, error, warning, info, neutral }

/// Where the toast appears on screen.
///
/// - **Mobile** — use [top] or [bottom].
/// - **Web / desktop** — use any corner variant for a notification-style popup.
enum ToastPosition {
  /// Full-width banner at the top of the screen. *(default)*
  top,

  /// Full-width banner at the bottom of the screen.
  bottom,

  /// Corner popup anchored to the top-left.
  topLeft,

  /// Corner popup anchored to the top-right.
  topRight,

  /// Corner popup anchored to the bottom-left.
  bottomLeft,

  /// Corner popup anchored to the bottom-right.
  bottomRight,
}

/// Entry / exit animation style.
enum ToastAnimation {
  /// Slides in from the nearest screen edge. *(default)*
  slide,

  /// Scales up from the anchor point with a fade.
  scale,

  /// Fades in / out only — no movement.
  fade,
}

/// Global configuration passed to [TopToast.init].
///
/// Every field has a sensible default; only override what you need.
class TopToastConfig {
  /// Default position for all toasts. Individual calls can override this.
  final ToastPosition position;

  /// Entry / exit animation style.
  final ToastAnimation animation;

  /// Queue new toasts instead of replacing the current one.
  final bool queueMode;

  /// Allow multiple toasts to appear simultaneously (up to [maxStack]).
  final bool stackMode;

  /// Maximum number of toasts visible at once in [stackMode].
  final int maxStack;

  /// Vertical space (px) reserved per stacked toast slot.
  final double stackSpacing;

  /// Trigger a light haptic pulse whenever a toast appears.
  final bool hapticFeedback;

  /// Maximum width for full-width toasts (`top` / `bottom`). Default 480.
  final double maxWidth;

  /// Width for corner toasts. Default 340.
  final double cornerWidth;

  /// Show a countdown progress bar at the bottom of every toast.
  final bool showProgressBar;

  /// How long a toast stays visible before auto-dismissing.
  final Duration defaultDuration;

  const TopToastConfig({
    this.position = ToastPosition.top,
    this.animation = ToastAnimation.slide,
    this.queueMode = false,
    this.stackMode = false,
    this.maxStack = 3,
    this.stackSpacing = 80,
    this.hapticFeedback = true,
    this.maxWidth = 480,
    this.cornerWidth = 340,
    this.showProgressBar = false,
    this.defaultDuration = const Duration(seconds: 3),
  });
}
