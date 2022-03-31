import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rich_text/core/rich_text_paragraph.dart';
import 'package:rich_text/core/rich_text_paragraph_builder.dart';

class RichTextPainter {
  RichTextPainter(List<TextSpan> textSpans, int maxLines) : _textSpans = textSpans, _maxLines = maxLines;

  RichTextParagraph? _paragraph;
  bool _needsLayout = true;

  final int _maxLines;

  List<TextSpan> _textSpans;
  List<TextSpan> get textSpans => _textSpans;

  set textSpans(List<TextSpan> value) {
    if (_textSpans == value) return;
    _textSpans = value;
    _paragraph = null;
    _needsLayout = true;
  }

  double _applyFloatingPointHack(double? layoutValue) {
    return layoutValue?.ceilToDouble() ?? 0;
  }

  double get minIntrinsicWidth {
    return _applyFloatingPointHack(_paragraph?.minIntrinsicWidth);
  }

  double get maxIntrinsicWidth {
    return _applyFloatingPointHack(_paragraph?.maxIntrinsicWidth);
  }

  double get width {
    return _applyFloatingPointHack(_paragraph?.width);
  }

  double get height {
    return _applyFloatingPointHack(_paragraph?.height);
  }

  Size get size {
    return Size(width, height);
  }

  double _lastMaxWidth = 0;
  double _lastMaxHeight = 0;

  void layout({double maxWidth = double.infinity, double maxHeight = double.infinity}) {
    if (!_needsLayout &&
        maxWidth == _lastMaxWidth &&
        maxHeight == _lastMaxHeight && kReleaseMode) return;
    _needsLayout = false;
    if (_paragraph == null) {
      final RichTextParagraphBuilder builder = RichTextParagraphBuilder();
      builder.maxLines = _maxLines;
      builder.textSpans = textSpans;
      _paragraph = builder.build();
    }
    _lastMaxWidth = maxWidth;
    _lastMaxHeight = maxHeight;
    _paragraph!.layout(maxWidth, maxHeight);
    final double newWidth = maxIntrinsicWidth.clamp(0, maxWidth);
    final double newHeight = height.clamp(0, maxHeight);
    if (newWidth != width || newHeight != height) {
      _paragraph!.layout(newWidth, newHeight);
    }
  }

  void paint(Canvas canvas, Offset offset) {
    _paragraph?.draw(canvas, offset);
  }
}
