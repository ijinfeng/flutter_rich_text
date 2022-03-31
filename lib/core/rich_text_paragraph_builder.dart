import 'dart:ui' as ui;
import 'package:flutter/painting.dart';
import 'package:rich_text/core/rich_text_paragraph.dart';

class RichTextParagraphBuilder {
  RichTextParagraphBuilder({ui.ParagraphStyle? style})
      : _paragraphStyle = style,
        _textSpans = [],
        _maxLines = 0;
  // 默认样式
  ui.ParagraphStyle? _paragraphStyle;
  ui.TextStyle? _textStyle;

  List<TextSpan> _textSpans;
  set textSpans(List<TextSpan> value) => _textSpans = value;

  int _maxLines;
  set maxLines(int value) => _maxLines = value;

  static final _defaultParagraphStyle = ui.ParagraphStyle(
    textAlign: ui.TextAlign.left,
    textDirection: ui.TextDirection.ltr,
    fontSize: 16,
  );

  static final _defaultTextStyle = ui.TextStyle(
    color: const Color(0xFF000000),
    textBaseline: TextBaseline.alphabetic,
    fontSize: 16,
  );

  set textStyle(TextStyle style) {
    _textStyle = style.getTextStyle();
  }

  RichTextParagraph build() {
    _paragraphStyle ??= _defaultParagraphStyle;
    _textStyle ??= _defaultTextStyle;
    return RichTextParagraph(
        _paragraphStyle!, _textStyle!, _textSpans, _maxLines);
  }
}
