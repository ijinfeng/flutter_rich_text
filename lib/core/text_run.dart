import 'dart:ui' show Paragraph, Size, LineMetrics;

import 'package:flutter/material.dart';

class RichTextRun {
  RichTextRun(this.text, this.position, this.paragraph, this.textSpan)
      : _width = paragraph.maxIntrinsicWidth,
        _height = paragraph.height,
        _line = paragraph.computeLineMetrics().first,
        offset = Offset.zero,
        drawed = false;

  final String text;
  final int position;
  final Paragraph paragraph;

  final LineMetrics _line;

  double get ascent => _line.ascent;
  double get descent => _line.descent;
  double get baseline => _line.baseline;

  final double _width;
  final double _height;

  Size get size => Size(_width, _height);

  /// 是否是换行符
  bool get isTurn => text == '\n';

  /// 是否是制表符
  bool get isTab => text == '\t';

  /// 是否是回车
  bool get isReturn => text == '\r';

  /// 归属于哪个TextSpan
  final TextSpan textSpan;

  Offset offset;

  /// 是否被绘制
  bool drawed;
}
