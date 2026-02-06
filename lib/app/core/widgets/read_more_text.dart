import 'package:readmore/readmore.dart';

import '../../export.dart';

class ReadMoreTextWidget extends StatelessWidget {
  final String text;
  final int trimLines;
  final String? showMoreText;
  final String? showLessText;
  final TextStyle? textStyle;
  final TextAlign? textAlign;

  const ReadMoreTextWidget(
      {super.key,
      required this.text,
      this.trimLines = 3,
      this.textAlign,
      this.showMoreText,
      this.showLessText,
      this.textStyle});

  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      text,
      trimLines: trimLines,
      colorClickableText: AppColors.appColor,
      trimMode: TrimMode.Line,
      trimCollapsedText: ' ${showMoreText ?? keyShowMore.tr}',
      trimExpandedText: ' ${showLessText ?? keyShowLess.tr}',
      textAlign: textAlign,
      style: textStyle ?? textStyleBodySmall(),
      moreStyle: textStyleBodyLarge()
          !.copyWith(color: blackColor, fontWeight: FontWeight.w600),
      lessStyle: textStyleBodyLarge()
          !.copyWith(color: blackColor, fontWeight: FontWeight.w600),
    );
  }
}
