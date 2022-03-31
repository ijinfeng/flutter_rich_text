import 'package:flutter/material.dart';
import 'package:rich_text/core/render_rich_label.dart';
import 'package:rich_text/core/rich_text_define.dart';

class RichLabel extends LeafRenderObjectWidget {
  final List<TextSpan> children;
  /// 当 overflow = custom时生效
  final TextSpan? overflowSpan;

  final RichTextOverflow overflow;

  final int maxLines;

  const RichLabel(
      {Key? key,
      required this.children,
      this.overflowSpan,
      this.maxLines = 0,
      this.overflow = RichTextOverflow.clip})
      : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderRichLabel(
        children: children, overflowSpan: overflowSpan, maxLines: maxLines);
  }

  @override
  void updateRenderObject(BuildContext context, RenderRichLabel renderObject) {
    renderObject.children = children;
    renderObject.maxLines = maxLines;
    renderObject.overflow = overflow;
    renderObject.overflowSpan = overflowSpan;
  }
}
