import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:rich_text/core/rich_text_define.dart';
import 'package:rich_text/core/text_line.dart';
import 'package:rich_text/core/text_run.dart';

class RichTextParagraph {
  RichTextParagraph({
    required ui.ParagraphStyle paragraphStyle,
    required ui.TextStyle textStyle,
    required List<TextSpan> textSpans,
    int maxLines = 0,
    RichTextOverflow overflow = RichTextOverflow.clip,
    TextSpan? overflowSpan,
  })  : _paragraphStyle = paragraphStyle,
        _textStyle = textStyle,
        _textSpans = textSpans,
        _maxLines = maxLines,
        _overflow = overflow,
        _overflowSpan = overflowSpan;

  final ui.ParagraphStyle _paragraphStyle;
  final ui.TextStyle _textStyle;
  final List<TextSpan> _textSpans;
  // 最大行数，0为不限制
  final int _maxLines;
  final RichTextOverflow _overflow;
  final TextSpan? _overflowSpan;

  double _width = 0;
  double _height = 0;

  double _minIntrinsicWidth = 0;
  double _maxIntrinsicWidth = double.infinity;

  /// 段落占据的宽度
  double get width => _width;

  /// 段落占据的高度
  double get height => _height;

  double get minIntrinsicWidth => _minIntrinsicWidth;

  double get maxIntrinsicWidth => _maxIntrinsicWidth;

  void layout(double maxWidth, double maxHeight) =>
      _layout(maxWidth, maxHeight);

  void _layout(double maxWidth, double maxHeight) {
    if (maxWidth == _width && maxHeight == _height) return;
    _calculateRuns();
    _calculateLines(maxWidth, maxHeight);
    _calculateHeight();
    _calculateWidth();
    _calculateIntrinsicWidth();

    print("There are ${_runs.length} runs.");
    print("There are ${_lines.length} lines.");
    print("width=$width height=$height");
    print("min=$minIntrinsicWidth max=$maxIntrinsicWidth");
  }

  final List<RichTextRun> _runs = [];
  // 收集每个文字
  void _calculateRuns() {
    if (_runs.isNotEmpty) return;

    for (var textSpan in _textSpans) {
      if (textSpan.text != null) {
        String text = textSpan.text!;
        ui.TextStyle style = textSpan.style?.getTextStyle() ?? _textStyle;
        int positon = 0;
        for (int i = 0; i < text.length; i++) {
          _addRun(positon, text, style);
          positon += 1;
        }
      }
    }
  }

  void _addRun(int position, String text, ui.TextStyle style) {
    String runText = text.substring(position, position + 1);
    final builder = ui.ParagraphBuilder(_paragraphStyle)
      ..pushStyle(style)
      ..addText(runText);
    final paragraph = builder.build();
    paragraph.layout(const ui.ParagraphConstraints(width: double.infinity));
    final run = RichTextRun(runText, position, paragraph);
    _runs.add(run);
  }

  final List<RichTextLine> _lines = [];
  void _calculateLines(double maxWidth, double maxHeight) {
    if (_runs.isEmpty) return;
    if (_lines.isNotEmpty) _lines.clear();

    double lineWidth = 0;
    double lineHeight = 0;
    double minLineHeight = double.infinity;
    double maxLineHeight = 0;
    double totalLineHeight = 0;
    List<RichTextRun> runs = [];
    for (int i = 0; i < _runs.length; i++) {
      if (_maxLines > 0 && _lines.length >= _maxLines) {
        // 到达最大行数限制
        return;
      } else if (totalLineHeight > maxHeight) {
        // 到达最大高度限制
        return;
      }
      final run = _runs[i];
      final double runWidth = run.isTurn ? 0 : run.size.width;
      final double runHeight = run.isTurn ? 0 : run.size.height;
      minLineHeight = math.min(minLineHeight, runHeight);
      maxLineHeight = math.max(maxLineHeight, runHeight);
      if (run.isTurn || lineWidth + runWidth > maxWidth) {
        // 换行
        _addLine(runs, lineWidth, lineHeight, minLineHeight, maxLineHeight);
        totalLineHeight += lineHeight;
        lineWidth = runWidth;
        lineHeight = runHeight;
        minLineHeight = lineHeight;
        maxLineHeight = lineHeight;
        runs = [];
        runs.add(run);
      } else {
        lineWidth += runWidth;
        lineHeight = math.max(lineHeight, runHeight);
        runs.add(run);
      }
    }
    _addLine(runs, lineWidth, lineHeight, minLineHeight, maxLineHeight);
  }

  void _addLine(List<RichTextRun> runs, double width, double height,
      double minHeight, double maxHeight) {
    if (runs.isEmpty) return;
    final bounds = Rect.fromLTRB(0, 0, width, height);
    final RichTextLine lineInfo = RichTextLine(runs, bounds);
    lineInfo.minLineHeight = minHeight;
    lineInfo.maxLineHeight = maxHeight;
    _lines.add(lineInfo);
  }

  void _calculateHeight() {
    double sum = 0;
    for (var line in _lines) {
      sum += line.bounds.height;
    }
    _height = sum;
  }

  void _calculateWidth() {
    double maxWidth = 0;
    for (var line in _lines) {
      maxWidth = math.max(maxWidth, line.bounds.width);
    }
    _width = maxWidth;
  }

  void _calculateIntrinsicWidth() {
    double sum = 0;
    double maxRunWidth = 0;
    for (var run in _runs) {
      final width = run.size.width;
      maxRunWidth = math.max(width, maxRunWidth);
      sum += width;
    }
    _minIntrinsicWidth = maxRunWidth;
    _maxIntrinsicWidth = sum;
  }

  void draw(Canvas canvas, Offset offset) {
    canvas.save();

    canvas.translate(offset.dx, offset.dy);

    for (var line in _lines) {
      double dx = 0;
      double maxLineHeight = line.maxLineHeight;
      for (int i = 0; i < line.runs.length; i++) {
        final run = line.runs[i];
        canvas.drawParagraph(
            run.paragraph, Offset(dx, maxLineHeight - run.size.height));
        dx += run.size.width;
      }
      canvas.translate(0, line.bounds.height);
    }

    canvas.restore();
  }
}
