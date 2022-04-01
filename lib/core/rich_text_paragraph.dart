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

    if (_text.text != null) {
      String text = _text.text!;
      int positon = 0;
      for (int i = 0; i < text.length; i++) {
        _addRun(positon, text, _text.style ?? _textStyle);
        positon += 1;
      }
    }

    if (_text.children != null) {
      for (var textSpan in _text.children!) {
        if (textSpan is TextSpan && textSpan.text != null) {
          String text = textSpan.text!;
          int positon = 0;
          for (int i = 0; i < text.length; i++) {
            _addRun(positon, text, textSpan.style ?? _textStyle);
            positon += 1;
          }
        }
      }
    }
  }

  void _addRun(int position, String text, TextStyle style) {
    String runText = text.substring(position, position + 1);
    ui.TextStyle _style = style.getTextStyle();
    final builder = ui.ParagraphBuilder(_paragraphStyle)
      ..pushStyle(_style)
      ..addText(runText);
    final paragraph = builder.build();
    paragraph.layout(const ui.ParagraphConstraints(width: double.infinity));
    final run = RichTextRun(runText, position, paragraph);
    _runs.add(run);
    print(
        'run=${run.text}, size=${run.size}, sh=${style.height},ss=${style.letterSpacing}');
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

  ui.TextPosition getPositionForOffset(ui.Offset position) {
    return ui.TextPosition(offset: 0);
  }

  void draw(Canvas canvas, Offset offset) {
    canvas.save();

    canvas.translate(offset.dx, offset.dy);

    for (int i = 0; i < _lines.length; i++) {
      var line = _lines[i];
      double dx = 0;
      double maxLineHeight = line.maxLineHeight;
      // 记录除去截断符后，所能到达的最大行宽
      double maxOverlowLineWidth = 0;
      for (int j = 0; j < line.runs.length; j++) {
        final run = line.runs[j];
        // 最后一行，并且有截断符
        if (i == _lines.length - 1 && _overflowSpan.hasOverflowSpan) {
          if (run.size.width + maxOverlowLineWidth + _overflowSpan.size.width <
              _width) {
            maxOverlowLineWidth += run.size.width;
          } else {
            // 需要绘制截断符
            assert(_overflowSpan.paragraph != null);
            canvas.drawParagraph(_overflowSpan.paragraph!,
                Offset(dx, (maxLineHeight - _overflowSpan.size.height) / 2));
            break;
          }
        }

        canvas.drawParagraph(
            run.paragraph, Offset(dx, (maxLineHeight - run.size.height) / 2));
        dx += run.size.width;
      }
      canvas.translate(0, line.bounds.height);
    }

    canvas.restore();
  }
}
