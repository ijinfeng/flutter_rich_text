import 'package:flutter/material.dart';
import 'package:rich_text/core/render_rich_label.dart';

class RichLabel extends LeafRenderObjectWidget {
  final List<TextSpan> children;

  final TextSpan? overflowSpan;

  final TextOverflow overflow;

  final int maxLines;

  const RichLabel(
      {Key? key,
      required this.children,
      this.overflowSpan,
      this.maxLines = 0,
      this.overflow = TextOverflow.clip})
      : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderRichLabel(
        children: children, overflowSpan: overflowSpan, maxLines: maxLines);
  }

  @override
  void updateRenderObject(BuildContext context, RenderRichLabel renderObject) {
    renderObject.children = children;
  }
}
