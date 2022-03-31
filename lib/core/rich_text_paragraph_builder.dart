import 'dart:ui' as ui;
import 'package:flutter/painting.dart';
import 'package:rich_text/core/rich_text_define.dart';
import 'package:rich_text/core/rich_text_paragraph.dart';

class RichTextParagraphBuilder {
  RichTextParagraphBuilder({ui.ParagraphStyle? style})
      : _paragraphStyle = style;
  // 默认样式
  ui.ParagraphStyle? _paragraphStyle;
  ui.TextStyle? _textStyle;

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

  RichTextParagraph build(
      {required List<TextSpan> textSpans,
      int maxLines = 0,
      RichTextOverflow overflow = RichTextOverflow.clip,
      TextSpan? overflowSpan}) {
    _paragraphStyle ??= _defaultParagraphStyle;
    _textStyle ??= _defaultTextStyle;
    return RichTextParagraph(
        paragraphStyle: _paragraphStyle!,
        textStyle: _textStyle!,
        textSpans: textSpans,
        maxLines: maxLines,
        overflow: overflow,
        overflowSpan: overflowSpan);
  }
}
