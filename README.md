# FlowToken Flutter 🌊

Flutter port of [FlowToken](https://github.com/Ephibbs/flowtoken) — smooth animations for streaming LLM text and markdown.

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

`fadeIn`, `blurIn`, `dropIn`, `slideUp`, `slideInFromLeft`, `fadeAndScale`, `blurAndSharpen`

## License

MIT — see [FlowToken](https://github.com/Ephibbs/flowtoken) for the original concept.
