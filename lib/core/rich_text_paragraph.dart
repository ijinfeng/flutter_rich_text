import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:rich_text/core/rich_text_define.dart';
import 'package:rich_text/core/rich_text_overflow.dart';
import 'package:rich_text/core/text_line.dart';
import 'package:rich_text/core/text_run.dart';

class RichTextParagraph {
  RichTextParagraph({
    required ui.ParagraphStyle paragraphStyle,
    required TextStyle textStyle,
    required TextSpan text,
    int maxLines = 0,
    RichTextOverflow overflow = RichTextOverflow.clip,
    TextSpan? overflowSpan,
  })  : _paragraphStyle = paragraphStyle,
        _textStyle = textStyle,
        _text = text,
        _maxLines = maxLines,
        _overflowSpan = RichTextOverflowSpan(
            overflow, overflowSpan, paragraphStyle, textStyle)
          ..build();

  final ui.ParagraphStyle _paragraphStyle;
  final TextStyle _textStyle;
  final TextSpan _text;
  // 最大行数，0为不限制
  final int _maxLines;
  final RichTextOverflowSpan _overflowSpan;

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
    _setupOverflowSpan();
    _calculateRuns();
    _calculateLines(maxWidth, maxHeight);
    _calculateHeight();
    _calculateWidth();
    _calculateIntrinsicWidth();
  }

  void _setupOverflowSpan() {}

  final List<RichTextRun> _runs = [];
  // 收集每个文字
  void _calculateRuns() {
    if (_runs.isNotEmpty) return;

    void deepCollectTextSpan(TextSpan text) {
      if (text.text != null) {
        String simpleText = text.text!;
        for (int i = 0; i < simpleText.length; i++) {
          _addRun(i, text.style ?? _textStyle, text);
        }
      }
      if (text.children != null) {
          for (var child in text.children!) {
            assert(child is TextSpan, 'Only the TextSpan type is supported');
            if (child is TextSpan) {
              deepCollectTextSpan(child);
            }
          }
        }
    }
    deepCollectTextSpan(_text);
  }

  void _addRun(int position, TextStyle style, TextSpan below) {
    assert(below.text != null);
    String text = below.text!;
    String runText = text.substring(position, position + 1);
    ui.TextStyle _style = style.getTextStyle();
    final builder = ui.ParagraphBuilder(_paragraphStyle)
      ..pushStyle(_style)
      ..addText(runText);
    final paragraph = builder.build();
    paragraph.layout(const ui.ParagraphConstraints(width: double.infinity));
    final run = RichTextRun(runText, position, paragraph, below);
    _runs.add(run);

    // var line = run.paragraph.computeLineMetrics().first;
    // print('run=${run.text}, ${line}, ${run.paragraph.ideographicBaseline}, ${run.size.height}');
    // print('run=${run.text}, size=${run.size}, sh=${style.height},ss=${style.letterSpacing}');
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
    double maxLineAscent = 0, maxLineDecent = 0;
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
      maxLineAscent = math.max(maxLineAscent, run.ascent);
      maxLineDecent = math.max(maxLineDecent, run.descent);
      if (run.isTurn || lineWidth + runWidth > maxWidth) {
        // 换行
        _addLine(runs, maxWidth, lineWidth, lineHeight, minLineHeight, maxLineHeight, maxLineAscent, maxLineDecent);
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
    _addLine(runs, maxWidth, lineWidth, lineHeight, minLineHeight, maxLineHeight, maxLineAscent, maxLineDecent);
  }

  void _addLine(List<RichTextRun> runs, double maxWidth, double width, double height,
      double minHeight, double maxHeight, double maxLineAscent, maxLineDecent) {
    if (runs.isEmpty) return;
    double dy = 0;
    int numberOfLines = _lines.length;
    if (numberOfLines > 0) {
      Rect bounds = _lines[numberOfLines - 1].bounds;
      dy = bounds.height + bounds.top;
    }
    final bounds = Rect.fromLTWH(0, dy, width, height);
    final RichTextLine lineInfo = RichTextLine(runs, bounds, maxWidth);
    lineInfo.minLineHeight = minHeight;
    lineInfo.maxLineHeight = maxHeight;
    lineInfo.maxLineAscent = maxLineAscent;
    lineInfo.maxLineDecent = maxLineDecent;
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

  InlineSpan? getSpanForPosition(Offset position) {
    // print('======》当前点击位置：$position, size=${Size(_width, _height)}');
    for (int i = 0; i < _lines.length; i++) {
      var line = _lines[i];
      if (line.bounds.contains(position)) {
        // print('-----找到行$i');
        for (var run in line.runs) {
          Rect bounds = Rect.fromLTWH(run.offset.dx,
              run.offset.dy + line.bounds.top, run.size.width, run.size.height);
          if (run.drawed && bounds.contains(position)) {
            // print("已找到，字(${run.text})，所在的bounds=$bounds，返回:${run.textSpan.text}");
            return run.textSpan;
          }
        }
      }
    }

    if (_overflowSpan.hasOverflowSpan && _lines.isNotEmpty) {
      var line = _lines[_lines.length - 1];
      Rect bounds = Rect.fromLTWH(_overflowSpan.offset.dx,
              _overflowSpan.offset.dy + line.bounds.top, _overflowSpan.size.width, _overflowSpan.size.height);
      if (bounds.contains(position)) {
        return _overflowSpan.overflowSpan;
      }
    }
    return null;
  }

  void draw(Canvas canvas, Offset offset) {
    canvas.save();

    canvas.translate(offset.dx, offset.dy);

    for (int i = 0; i < _lines.length; i++) {
      var line = _lines[i];
      if (i == _lines.length - 1) {
        line.draw(canvas, overflow: _overflowSpan);
      } else {
        line.draw(canvas);
      }
      // double dx = 0;
      // double maxLineHeight = line.maxLineHeight;
      // // 记录除去截断符后，所能到达的最大行宽
      // double maxOverlowLineWidth = 0;
      // for (int j = 0; j < line.runs.length; j++) {
      //   final run = line.runs[j];
      //   // 最后一行，并且有截断符
      //   if (i == _lines.length - 1 && _overflowSpan.hasOverflowSpan) {
      //     if (run.size.width + maxOverlowLineWidth + _overflowSpan.size.width <
      //         _width) {
      //       maxOverlowLineWidth += run.size.width;
      //     } else {
      //       // 需要绘制截断符
      //       assert(_overflowSpan.paragraph != null);
      //       Offset offset =
      //           Offset(dx, maxLineHeight - _overflowSpan.ascent);
      //       _overflowSpan.draw(canvas, offset);
      //       break;
      //     }
      //   }

      //   Offset offset = Offset(dx, maxLineHeight - run.ascent);
      //   run.draw(canvas, offset);
      //   dx += run.size.width;
      // }
      canvas.translate(0, line.bounds.height);
    }

    canvas.restore();
  }
}
