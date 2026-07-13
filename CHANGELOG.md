## 1.0.0

* **Stable release** — API is considered stable going forward.
* Fixed a staleness bug in `TopToast.builder` / `lightBuilder` / `darkBuilder`: the internal `Overlay` only applied `initialEntries` on its very first build, so the wrapped app content could get silently pinned to an old widget instance across later rebuilds (route changes, theme/orientation changes, etc.). The app content is now kept live via a `ValueListenableBuilder` on every rebuild.
* Added pub.dev `topics` for discoverability (`toast`, `snackbar`, `notifications`, `dialog`, `overlay`).

## 0.0.9

* Bug fixes and stability improvements.

## 0.0.8

* **Confirmation dialogs** — `TopDialog.show()` with six built-in types: `delete`, `warning`, `success`, `failed`, `confirmation`, `custom`.
* **Custom-painted icons** — trash, triangle+!, checkmark, ✕, ?, drawn with `CustomPainter` (no extra dependencies).
* **Async confirm** — `onAsyncConfirm` shows a spinner inside the confirm button until the future resolves, then closes automatically.
* **`TopDialogConfig`** — app-wide defaults: `cancelLabel`, `confirmLabel`, `showCancel`, `maxWidth`, `barrierDismissible`.
* Scale + fade entry animation via `showGeneralDialog` + `transitionBuilder`.
* Dark mode support for dialog card.

## 0.0.7

* **Toast queue** — `TopToastConfig(queueMode: true)` shows toasts one at a time in order.
* **Stack mode** — `TopToastConfig(stackMode: true, maxStack: 3)` shows up to N toasts simultaneously.
* **Progress bar** — optional countdown bar at the bottom of each card (`showProgressBar`).
* **`persistent`** — toasts that do not auto-dismiss.
* **`onTap` callback** — fired when the user taps the toast body.
* **`duration`** — per-toast auto-dismiss duration override.
* **Custom icon & colours** — `icon`, `cardColor`, `borderColor`, `iconBgColor`, `iconColor`, `actionColor` per toast.
* **Animation styles** — `slide` (default), `scale`, `fade`; set globally via `TopToastConfig` or per toast.
* **Hover-pause** — auto-dismiss timer pauses when the mouse hovers the toast (web/desktop).
* **Horizontal swipe** — corner toasts dismiss on swipe toward the nearest edge.
* **Haptic feedback** — light impact on show; toggle via `TopToastConfig(hapticFeedback: false)`.
* **`TopToast.dismissAll()`** — clears all visible toasts and the queue instantly.
* **`maxWidth` / `cornerWidth`** — configurable via `TopToastConfig`.
* Replaced `navigatorKey`-based overlay with a `ValueNotifier`-driven stack for clean multi-toast management.
* `TopToast.init` now accepts a `TopToastConfig` object instead of individual parameters.

## 0.0.6

* Added 6 toast positions: `top`, `bottom`, `topLeft`, `topRight`, `bottomLeft`, `bottomRight`.
* Set a global default in `TopToast.init(position: ...)` or override per-toast with the `position` argument.
* Corner positions (`topLeft` / `topRight` / `bottomLeft` / `bottomRight`) render as a fixed-width popup — ideal for web and desktop.
* Slide animation now enters from the nearest edge (top positions slide from top, bottom positions slide from bottom).
* Added light and dark mode support — toast colours auto-adapt to `MediaQuery.platformBrightness`.
* Added `TopToast.lightBuilder` and `TopToast.darkBuilder` to force a specific theme.
* Updated README and example with `MaterialApp.router` (GoRouter) navigation key setup.

## 0.0.5

* Added `TopToast.builder` — a `TransitionBuilder` for `MaterialApp`/`MaterialApp.router`'s `builder` parameter. Toasts now render above dialogs and bottom sheets.
* Updated README with `MaterialApp.router` (GoRouter) setup instructions.

## 0.0.4

* Fixed README image — use relative path so pub.dev serves it directly.

## 0.0.3

* Fixed GitHub image URL and repository links.

## 0.0.2

* Added preview screenshots to README.
* Added platform support table (Android, iOS, Web, macOS).

## 0.0.1

* Initial release.
* Overlay-based top-sliding toast with slide + fade animation.
* Five types: success, error, warning, info, neutral.
* Optional title, action button, swipe-up / tap-to-dismiss.
