import 'dart:ui' show Rect, Canvas, Offset;

import 'package:rich_text/core/rich_text_overflow.dart';
import 'package:rich_text/core/text_run.dart';

class RichTextLine {
  RichTextLine(this.runs, this.bounds, this.maxWidth)
      : minLineHeight = bounds.height,
        maxLineHeight = bounds.height,
        minLineAscent = 0,
        maxLineAscent = 0,
        minLineDecent = 0,
        maxLineDecent = 0;

  final List<RichTextRun> runs;
  final Rect bounds;
  final double maxWidth;
  double minLineHeight;
  double maxLineHeight;
  double minLineAscent;
  double maxLineAscent;
  double minLineDecent;
  double maxLineDecent;

  double get dx => bounds.left;
  double get dy => bounds.top;

  void draw(Canvas canvas, {RichTextOverflowSpan? overflow}) {
    double dx = 0;
    // 记录除去截断符后，所能到达的最大行宽
    double maxOverlowLineWidth = 0;
    for (int j = 0; j < runs.length; j++) {
      final run = runs[j];
      if (overflow != null && overflow.hasOverflowSpan) {
        if (run.size.width + maxOverlowLineWidth + overflow.size.width <
            maxWidth) {
          maxOverlowLineWidth += run.size.width;
        } else {
          // 需要绘制截断符
          assert(overflow.paragraph != null);
          Offset offset =
              Offset(dx, maxLineHeight - overflow.ascent - maxLineDecent);
          overflow.draw(canvas, offset);
          break;
        }
      }

      Offset offset = Offset(dx, maxLineHeight - run.descent - maxLineDecent - maxLineAscent);
      run.draw(canvas, offset);
      dx += run.size.width;
    }
  }

  @override
  String toString() {
    String text = '';
    for (var run in runs) {
      text += run.text;
    }
    return '''
  $text,
  bounds=$bounds, 
  maxWidth=$maxWidth, 
  minLineHeight=$minLineHeight, 
  maxLineHeight=$maxLineHeight, 
  minLineAscent=$minLineAscent, 
  maxLineAscent=$maxLineAscent, 
  minLineDecent=$minLineDecent, 
  maxLineDecent=$maxLineDecent
''';
  }
}
