

enum RichTextOverflow {
  /// Clip the overflowing text to fix its container.
  clip,

  /// Use an ellipsis to indicate that the text has overflowed.
  ellipsis,

  /// Render custom overflowing text
  custom,
}