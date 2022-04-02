import 'dart:ui' show Rect;

import 'package:rich_text/core/text_run.dart';

class RichTextLine {
  RichTextLine(this.runs, this.bounds)
      : minLineHeight = bounds.height,
        maxLineHeight = bounds.height,
        maxLineAscent = 0,
        maxLineDecent = 0;

  List<RichTextRun> runs;
  Rect bounds;
  double minLineHeight;
  double maxLineHeight;
  double maxLineAscent;
  double maxLineDecent;
}
