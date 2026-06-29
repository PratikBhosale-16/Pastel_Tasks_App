import 'package:flutter/material.dart';

/// A widget that displays text with matched substrings highlighted.
class HighlightText extends StatelessWidget {
  /// The full text to display.
  final String text;

  /// The substring to highlight.
  final String query;

  /// The default text style.
  final TextStyle? style;

  /// The style for the highlighted substring.
  final TextStyle? highlightStyle;
  
  /// The maximum number of lines for the text.
  final int? maxLines;
  
  /// How visual overflow should be handled.
  final TextOverflow? overflow;

  const HighlightText({
    super.key,
    required this.text,
    required this.query,
    this.style,
    this.highlightStyle,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    if (query.trim().isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    
    int startIndex = 0;
    List<TextSpan> spans = [];

    while (true) {
      final index = lowerText.indexOf(lowerQuery, startIndex);
      if (index == -1) {
        // Add the remaining text
        if (startIndex < text.length) {
          spans.add(TextSpan(text: text.substring(startIndex)));
        }
        break;
      }

      // Add unhighlighted text before the match
      if (index > startIndex) {
        spans.add(TextSpan(text: text.substring(startIndex, index)));
      }

      // Add highlighted match
      spans.add(
        TextSpan(
          text: text.substring(index, index + query.length),
          style: highlightStyle ??
              TextStyle(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
        ),
      );

      startIndex = index + query.length;
    }

    return RichText(
      text: TextSpan(
        style: style ?? DefaultTextStyle.of(context).style,
        children: spans,
      ),
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
    );
  }
}
