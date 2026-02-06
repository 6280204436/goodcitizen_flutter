import '../../export.dart';

class TextView extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final int? maxLines;
  final TextAlign? textAlign;

  const TextView({
    required this.text,
    required this.textStyle,
    this.maxLines,
    this.textAlign,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text.tr,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      style: textStyle,
    );
  }
}


/// this fun returns the number of lines occupied by a text widget after rendering
int getTextLinesOccupiedByWidget(String text, TextStyle style, double maxWidth) {
  final textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: null, // Allows the text to wrap to multiple lines
    textAlign: TextAlign.left,
    textDirection: TextDirection.ltr,
  );

  textPainter.layout(maxWidth: maxWidth); // Layout the text with a maximum width

  // Number of lines
  return textPainter.computeLineMetrics().length;
}
