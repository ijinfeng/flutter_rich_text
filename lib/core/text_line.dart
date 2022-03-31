import 'dart:ui' show Rect;

import 'package:rich_text/core/text_run.dart';

class RichTextLine {
  RichTextLine(this.runs, this.bounds)
      : minLineHeight = bounds.height,
        maxLineHeight = bounds.height;

  List<RichTextRun> runs;
  Rect bounds;
  double minLineHeight;
  double maxLineHeight;
}
