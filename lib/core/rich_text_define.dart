

enum RichTextOverflow {
  /// 超出的文本将被截断
  clip,

  /// 一个现实为`…`的截断符
  ellipsis,

  /// 自定义的截断符
  custom,

  /// 当`overflow`为`custom`时，`…`会随着自定义的截断符一起出现
  both,
}