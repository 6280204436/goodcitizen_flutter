import '../../../export.dart';


class OnBoardingItem extends StatelessWidget {
  final String? image;
  final String? heading;
  final String? subheading;

  const OnBoardingItem({super.key,
    this.image,
    required this.heading,
    required this.subheading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextView(
          text: heading ?? "",
          maxLines: 3,
          textStyle: textStyleDisplayMedium()!.copyWith(color: AppColors.whiteAppColor,fontSize: 40,fontWeight: FontWeight.w800),
        ).paddingOnly(bottom: margin_4),
        TextView(
          text: subheading ?? "",
          maxLines: 4,
          textStyle: textStyleDisplaySmall()!.copyWith(color:AppColors.whiteAppColor,fontSize: font_20,fontWeight: FontWeight.w500),
        ),
      ],
    ).paddingSymmetric(horizontal: margin_15);
  }
}
