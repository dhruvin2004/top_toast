# top_toast

A beautiful top-sliding overlay toast notification for Flutter.

- Five built-in types: **success**, **error**, **warning**, **info**, **neutral**
- Smooth slide-in from top + fade animation
- Optional title, optional action button
- Tap or swipe-up to dismiss early
- Zero dependencies beyond Flutter itself

---

## Platform Support

| Android | iOS | Web | macOS |
|:-------:|:---:|:---:|:-----:|
| ✅ | ✅ | ✅ | ✅ |

---

## Preview

![TopToast all types preview](https://raw.githubusercontent.com/dhruvin2004/top_toast/main/screenshots/preview.png)

---

## Setup

### 1. Add to `pubspec.yaml`

```yaml
dependencies:
  top_toast: ^0.0.1
```

### 2. Create a navigator key and pass it to `TopToast.init`

```dart
final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  TopToast.init(navigatorKey: navigatorKey);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,   // ← same key
      home: HomePage(),
    );
  }
}
```

---

## Usage

```dart
// Simple types
TopToast.success(msg: 'Record saved successfully.');
TopToast.error(msg: 'Something went wrong.');
TopToast.warning(msg: 'Low storage space remaining.');
TopToast.info(msg: 'Pull down to refresh the list.');
TopToast.toast(msg: 'Copied to clipboard');

// With custom title
TopToast.success(title: 'Done!', msg: 'Your profile has been updated.');

// With action button
TopToast.toastWithAction(
  type: ToastType.error,
  title: 'Deleted',
  msg: 'Item has been removed.',
  label: 'Undo',
  onPressed: () => TopToast.success(msg: 'Restored!'),
);
```

---

## API

### `TopToast.init({required GlobalKey<NavigatorState> navigatorKey})`
Call once before showing any toast (typically in `main()`).

### `TopToast.success({String? title, required String msg})`
### `TopToast.error({String? title, required String msg})`
### `TopToast.warning({String? title, required String msg})`
### `TopToast.info({String? title, required String msg})`
### `TopToast.toast({required String msg})`

### `TopToast.toastWithAction({...})`
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `msg` | `String` | ✅ | Body message |
| `label` | `String` | ✅ | Action button label |
| `onPressed` | `VoidCallback` | ✅ | Action button callback |
| `type` | `ToastType` | — | Defaults to `neutral` |
| `title` | `String?` | — | Optional title |

---

## Behaviour

- Only one toast is shown at a time; a new toast dismisses the previous one instantly.
- Auto-dismisses after **3 seconds**.
- **Tap** anywhere on the toast or **swipe up** to dismiss early.

---

## License

MIT — see [LICENSE](LICENSE).
