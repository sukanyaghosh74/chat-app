import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';

Widget messageBubble(String message) {
  bool isCode = message.contains("```");
  return isCode
      ? HighlightView(
          code: message.replaceAll("```", ""),
          language: 'dart',
          theme: githubTheme,
        )
      : Text(message);
}
