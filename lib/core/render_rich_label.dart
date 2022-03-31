import 'package:flutter/material.dart';
import 'package:rich_text/core/rich_text_painter.dart';

class RenderRichLabel extends RenderBox {
  final TextSpan? overflowSpan;
  final TextOverflow overflow;
  final int maxLines;

  RenderRichLabel(
      {required List<TextSpan> children,
      this.overflowSpan,
      this.maxLines = 0,
      this.overflow = TextOverflow.clip})
      : _textPainter = RichTextPainter(children, maxLines);

  final RichTextPainter _textPainter;

  set children(List<TextSpan> value) {
    if (value.length != _textPainter.textSpans.length) {
      _textPainter.textSpans = value;
      markNeedsLayout();
      markNeedsPaint();
      return;
    }
    List<TextSpan> _value = value;
    List<TextSpan> _textSpans = _textPainter.textSpans;
    for (int i = 0; i < _value.length; i++) {
      switch (_value[i].compareTo(_textSpans[i])) {
        case RenderComparison.identical:
        case RenderComparison.metadata:
          break;
        case RenderComparison.paint:
          _textPainter.textSpans = value;
          markNeedsPaint();
          break;
        case RenderComparison.layout:
          _textPainter.textSpans = value;
          markNeedsLayout();
          break;
      }
    }
  }

  void _layoutText({
    double maxWidth = double.infinity,
    double maxHeight = double.infinity,
  }) {
    _textPainter.layout(maxWidth: maxWidth, maxHeight: maxHeight);
  }

  void _layoutTextWithConstraints(BoxConstraints constraints) {
    _layoutText(
      maxWidth: constraints.maxWidth,
      maxHeight: constraints.maxHeight,
    );
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    _layoutText();
    return _textPainter.height;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    _layoutText();
    return _textPainter.height;
  }

  double _computeIntrinsicWidth(double height) {
    _layoutText(maxWidth: height, maxHeight: height);
    return _textPainter.width;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return _computeIntrinsicWidth(height);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _computeIntrinsicWidth(height);
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    assert(!debugNeedsLayout);
    assert(constraints.debugAssertIsValid());
    _layoutTextWithConstraints(constraints);
    return _textPainter.height;
  }

  @override
  void performLayout() {
    _layoutTextWithConstraints(constraints);
    final Size textSize = _textPainter.size;
    size = constraints.constrain(textSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _textPainter.paint(context.canvas, offset);
  }
}
