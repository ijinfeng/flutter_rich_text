import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:rich_text/core/rich_text_define.dart';

class RichTextOverflowSpan {
  RichTextOverflowSpan(RichTextOverflow overflow, TextSpan? overflowSpan,
      ui.ParagraphStyle paragraphStyle, TextStyle textStyle)
      : _overflow = overflow,
        _overflowSpan = overflowSpan,
        _paragraphStyle = paragraphStyle,
        _textStyle = textStyle,
        offset = Offset.zero, 
        drawed = false;

  final RichTextOverflow _overflow;
  RichTextOverflow get overflow => _overflow;

  final TextSpan? _overflowSpan;
  TextSpan? get overflowSpan => _overflowSpan;

  final ui.ParagraphStyle _paragraphStyle;
  ui.ParagraphStyle get paragraphStyle => _paragraphStyle;

  final TextStyle _textStyle;
  TextStyle get textStyle => _textStyle;

  bool get hasOverflowSpan => _overflow != RichTextOverflow.clip;

  ui.Paragraph? _paragraph;
  ui.Paragraph? get paragraph => _paragraph;

  void build({TextStyle? style}) {
    TextStyle _tstyle = style ?? _textStyle;

    String overflowText = '';
    switch (overflow) {
      case RichTextOverflow.clip:
        break;
      case RichTextOverflow.ellipsis:
        overflowText = '…';
        break;
      case RichTextOverflow.custom:
        if (overflowSpan == null) {
          overflowText = '…';
        } else {
          overflowText = overflowSpan!.text ?? '…';
          _tstyle = overflowSpan!.style ?? _textStyle;
        }
        break;
      default:
    }

    ui.TextStyle _ustyle = _tstyle.getTextStyle();
    final builder = ui.ParagraphBuilder(_paragraphStyle)
      ..pushStyle(_ustyle)
      ..addText(overflowText);
    final paragraph = builder.build();
    _paragraph = paragraph;
    paragraph.layout(const ui.ParagraphConstraints(width: double.infinity));

    _width = paragraph.maxIntrinsicWidth;
    _height = paragraph.height;
  }

  double _width = 0;
  double _height = 0;

  Size get size => Size(_width, _height);

  Offset offset;

  bool drawed;
}