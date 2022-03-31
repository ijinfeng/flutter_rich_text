import 'dart:ui' show Paragraph, Size;

class RichTextRun {
  RichTextRun(this.text, this.position, this.paragraph)
      : _width = paragraph.maxIntrinsicWidth,
        _height = paragraph.height;

  String text;
  int position;
  Paragraph paragraph;

  final double _width;
  final double _height;

  Size get size => Size(_width, _height);

  /// 是否是换行符
  bool get isTurn => text == '\n';

  /// 是否是制表符
  bool get isTab => text == '\t';

  /// 是否是回车
  bool get isReturn => text == '\r';
}
