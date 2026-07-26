# FlowToken Flutter 🌊

Flutter port of [FlowToken](https://github.com/Ephibbs/flowtoken) — smooth animations for streaming LLM text and markdown.

Try the interactive Flutter web demo at [flowtoken-flutter.undivisible.dev](https://flowtoken-flutter.undivisible.dev).

Inspired by the original React library; uses [`gpt_markdown`](https://pub.dev/packages/gpt_markdown) for static rendering.

## Install

```yaml
dependencies:
  flowtoken_flutter:
    git:
      url: https://github.com/undivisible/flowtoken_flutter
      ref: main
```

## Usage

```dart
import 'package:flowtoken_flutter/flowtoken_flutter.dart';

// Streaming assistant reply
AnimatedMarkdown(
  content: streamBuffer,
  separator: FlowTokenSeparator.diff,
  animation: FlowTokenAnimation.fadeIn,
)

// Completed message — no animation
AnimatedMarkdown(
  content: message,
  animation: null,
)
```

## Animations

`fadeIn`, `blurIn`, `typewriter`, `slideInFromLeft`, `fadeAndScale`, `rotateIn`, `bounceIn`, `elastic`, `colorTransition`, `highlight`, `blurAndSharpen`, `dropIn`, `slideUp`, `wave`

`duration`, `curve`, and `animationIterationCount` are available on `AnimatedText`, `AnimatedMarkdown`, and `AnimatedImage`. `AnimatedMarkdown` also preserves the upstream code-copy and image animation behavior.

## License

ISC — see [FlowToken](https://github.com/Ephibbs/flowtoken) for the original concept.
