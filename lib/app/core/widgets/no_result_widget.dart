import 'package:good_citizen/app/core/widgets/text_view_widget.dart';
import 'package:good_citizen/app/export.dart';

Widget noResultWidget(
    {Widget? textWidget,
    bool isError = false,
    bool showImage = false,
    double? imageHeight,
    double? imageWidth,
    String? text,
    VoidCallback? onTryAgain,
    bool showRefresh = false,
    TextStyle? textStyle,
    Widget? extraWidget}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: showImage,
          child: AssetSVGWidget(noDataImage,
                  imageHeight: imageHeight ?? height_130,
                  imageWidth: imageWidth ?? height_130)
              .paddingOnly(bottom: margin_12),
        ),
        textWidget ??
            (isError
                ? GestureDetector(
                    onTap: onTryAgain,
                    child: TextView(
                        text: keyTryAgain.tr,
                        textStyle:
                            textStyleTitleSmall()!.copyWith(color: AppColors.appColor)))
                : Visibility(
                    visible: text != '',
                    child: TextView(
                        text: text ?? keyNoResultsFound.tr,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        textStyle: textStyle ?? textStyleTitleMedium()!),
                  )),
        Visibility(
          visible: showRefresh,
          child: GestureDetector(
            onTap: onTryAgain,
            child: TextView(
                    text: keyTryAgain,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    textStyle: textStyle ??
                        textStyleTitleSmall()
                            !.copyWith(color: AppColors.textGreyColorDark))
                .paddingOnly(top: margin_5),
          ),
        ),
        extraWidget?.paddingOnly(top: margin_14) ?? const SizedBox()
      ],
    ),
  ).paddingOnly(bottom: margin_25);
}
