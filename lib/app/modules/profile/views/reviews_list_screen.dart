

import 'package:good_citizen/app/modules/profile/controllers/reviews_list_controller.dart';
// import 'package:good_citizen/app/modules/trips/widgets/rating_builder.dart';
import '../../../core/widgets/center_loader.dart';
import '../../../core/widgets/no_result_widget.dart';
import '../../../export.dart';
import '../widgets/single_rating_widget.dart';

class ReviewsListScreen extends GetView<ReviewsListController> {
  const ReviewsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      extendBodyBehindAppBar: false,
      appBar: _appBarWidget(),
      body: Obx(() => _bodyWidget()),
    );
  }

  AppBar _appBarWidget() {
    return customAppBar(titleText: keyYourReview.tr);
  }

  Widget _bodyWidget() {
    return controller.isLoading.value && controller.reviewsList.isEmpty
        ? showCenterLoader()
        : controller.reviewsList.isEmpty?noResultWidget(text: keyNoReviews):SingleChildScrollView(
      controller: controller.scrollController,
      child: Column(
        children: [
          _ratingWidget().paddingOnly(bottom: margin_20),
          _ratingsList()
        ],
      ).paddingSymmetric(horizontal: margin_15, vertical: margin_10),
    );
  }

  Widget _ratingWidget() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(color: isDarkMode.value?AppColors.whiteLight:AppColors.whiteAppColor,
          border: Border.all(color: isDarkMode.value?AppColors.whiteLight:AppColors.appGreyColorDark),
          borderRadius: BorderRadius.circular(radius_5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextView(
            text: keyOverRating,
            textAlign: TextAlign.center,
            textStyle:
            textStyleTitleLarge()!.copyWith(fontWeight: FontWeight.w400),
          ).paddingOnly(bottom: margin_3),
          TextView(
            text:
            controller.reviewsListResponseModel.value?.overallRating ?? '0',
            textAlign: TextAlign.center,
            textStyle: textStyleTitleLarge()
                !.copyWith(fontWeight: FontWeight.w600, fontSize: font_28),
          ).paddingOnly(bottom: margin_5),

          TextView(
            text:
            '${keyBasedOn.tr} ${controller.reviewsListResponseModel.value?.count ?? '0'} ${keyReviews.tr.toLowerCase()}',
            textAlign: TextAlign.center,
            textStyle:
            textStyleTitleLarge()!.copyWith(fontWeight: FontWeight.w400),
          ),
        ],
      ).paddingSymmetric(horizontal: margin_10, vertical: margin_15),
    );
  }

  Widget _ratingsList() {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: controller.reviewsList.length + 1,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (context, index) => SizedBox(height: height_13),
      itemBuilder: (BuildContext ctx, index) {
        if (index == controller.reviewsList.length) {
          return controller.isLoading.value
              ? showCenterLoaderSmall().paddingOnly(top: margin_10)
              : const SizedBox();
        }
        return RatingReviewWidget(
            ratingDataModel: controller.reviewsList[index]);
      },
    ).paddingSymmetric();
  }
}
