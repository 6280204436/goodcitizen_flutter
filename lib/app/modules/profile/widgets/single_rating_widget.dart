import '../../../core/widgets/network_image_widget.dart';
import '../../../core/widgets/read_more_text.dart';
import '../../../export.dart';
// import '../../trips/widgets/rating_builder.dart';
import '../models/data_model/rating_model.dart';

class RatingReviewWidget extends StatelessWidget {
  final RatingModel ratingDataModel;

  const RatingReviewWidget({
    required this.ratingDataModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(color: isDarkMode.value?AppColors.whiteLight:AppColors.whiteAppColor,
          border: Border.all(color: isDarkMode.value?AppColors.whiteLight:AppColors.appGreyColorDark),
          borderRadius: BorderRadius.circular(radius_5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.appGreyColorDark),
                child: NetworkImageWidget(
                  imageUrl: ratingDataModel.customer?.image??'',
                  imageHeight: height_35,
                  imageWidth: height_35,
                  placeHolder: userPlaceholder,
                  radiusAll: radius_40,
                ).paddingAll(margin_2),
              ).marginOnly(right: margin_5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView(
                      text: ratingDataModel.customer?.name??'',
                      textAlign: TextAlign.start,
                      textStyle: textStyleTitleSmall()
                          !.copyWith(fontWeight: FontWeight.w500),
                      maxLines: 1,
                    ).paddingOnly(bottom: margin_3),
                    // _ratingWidget()
                  ],
                ).paddingSymmetric(horizontal: margin_4),
              ),
            ],
          ),
          Visibility(

              visible: (ratingDataModel.description??'').isNotEmpty,
              child: _commentTextWidget().paddingOnly(top: margin_7,left: margin_6)),
          TextView(
            text: rideDateTimeFormat(date: getDateFromMilliSec(ratingDataModel?.createdAt)),
            textAlign: TextAlign.end,
            textStyle: textStyleBodyMedium()!.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textGreyColorDark),
            maxLines: 1,
          ).paddingOnly(top: margin_7,left: margin_6)
        ],
      ).paddingSymmetric(horizontal: margin_10, vertical: margin_10),
    );
  }

  // Widget _ratingWidget() {
  //   return RatingWidget(
  //     itemSize: height_12,
  //     initialRating: double.parse((ratingDataModel.rate??0).toString()),
  //     readOnly: true,
  //     allowHalf: true,
  //     itemPadding: height_0,
  //   );
  // }

  Widget _commentTextWidget() {
    return ReadMoreTextWidget(
      text: ratingDataModel.description??'',
      trimLines: 8,
      textAlign: TextAlign.start,
      textStyle: textStyleTitleSmall()!.copyWith(
          fontWeight: FontWeight.w400,
          color: AppColors.textGreyColorDark.withOpacity(0.7)),
    );
  }
}
