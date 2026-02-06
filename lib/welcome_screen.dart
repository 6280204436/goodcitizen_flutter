import 'package:good_citizen/app/export.dart';
import 'package:good_citizen/app/modules/splash/widgets/onboarding_item.dart';

class OnBoardingView extends GetView<OnBoardingController> {
  const OnBoardingView({super.key});

  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: _body(),
    );
  }

  Widget _body() => Stack(
        children: [
          _pageView(),
          _bottomView(),
        ],
      );

  Widget _pageView() => GetBuilder<OnBoardingController>(
        builder: (controller) => PageView.builder(
          controller: controller.pageController.value,
          itemCount: controller.listItem.length,
          physics: const ClampingScrollPhysics(),
          onPageChanged: (value) {
            controller.selectedIndex.value = value;
            controller.update();
          },
          itemBuilder: (builder, index) {
            var item = controller.listItem[index];
            return _backGroundImage(item);
          },
        ),
      );

  Widget _backGroundImage(OnBoardingItem item) => Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter, // Start from top
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(200, 41, 39, 1),
            Color.fromRGBO(221, 78, 75, 1),
            Color.fromRGBO(251, 123, 118, 0.9)
          ],
        )),
      );

  Widget _bottomView() => SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GetBuilder<OnBoardingController>(
            builder: (controller) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // if (controller.selectedIndex.value != 2)
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     crossAxisAlignment: CrossAxisAlignment.end,
                //     children: [
                //       _topSkipButton(),
                //     ],
                //   ),
                const Spacer(),
                _content(),
                _indicators(),
                // _buttons(),
              ],
            ),
          ),
        ),
      );

  // Widget _topSkipButton() => GestureDetector(
  //   onTap: () {
  //     controller.moveToSignUpPage();
  //   },
  //   behavior: HitTestBehavior.translucent,
  //   child: Padding(
  //     padding: EdgeInsets.all(margin_16),
  //     child: Stack(
  //       children: [
  //         TextView(
  //           text: "Skip",
  //           textStyle: textStyleDisplayMedium()!.copyWith(
  //             color: AppColors.whiteAppColor,
  //             fontSize: font_14,
  //             fontWeight: FontWeight.w700,
  //           ),
  //         ),
  //         Positioned(
  //           bottom: 0,
  //           left: 0,
  //           right: 0,
  //           child: Container(
  //             color: AppColors.whiteAppColor,
  //             height: 1.5,
  //           ),
  //         ),
  //       ],
  //     ),
  //   ),
  // );

  Widget _content() => OnBoardingItem(
        heading: controller.listItem[controller.selectedIndex.value].heading,
        subheading:
            controller.listItem[controller.selectedIndex.value].subheading,
      ).paddingSymmetric(vertical: margin_10);

  Widget _indicators() => SizedBox(
        height: margin_5,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: controller.listItem.length,
          itemBuilder: (context, index) {
            return GetBuilder<OnBoardingController>(
              builder: (controller) => Container(
                height: margin_5,
                decoration: BoxDecoration(
                  color: controller.selectedIndex.value == index
                      ? AppColors.greyColor
                      : AppColors.whiteAppColor,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: controller.selectedIndex.value == index
                        ? AppColors.appDarkColor
                        : AppColors.whiteAppColor,
                    width: 5.0,
                  ),
                ),
              ).paddingOnly(right: 5.0),
            );
          },
        ),
      ).marginSymmetric(horizontal: margin_15);

  Widget _buttons() => Row(
        children: [
          if (controller.selectedIndex.value != 0)
            _prevButton().paddingOnly(right: margin_15),
          _nextButton(),
        ],
      )
          .paddingSymmetric(horizontal: margin_15, vertical: margin_15)
          .paddingOnly(bottom: margin_10);

  Widget _prevButton() => SizedBox(
        width: (Get.width - 3 * margin_15) / 2,
        child: CustomMaterialButton(
            isOutlined: true,
            borderColor: AppColors.appColor,
            borderWidth: margin_2,
            buttonText: "Previous",
            textColor: AppColors.appColor,
            onTap: () {
              controller.prevPageController();
              controller.update();
            }),
      );

  Widget _nextButton() => SizedBox(
        width: (controller.selectedIndex.value == 0)
            ? (Get.width - 2 * margin_15)
            : (Get.width - 3 * margin_15) / 2,
        child: CustomMaterialButton(
            buttonText: controller.selectedIndex.value == 2 ? "Signup" : "Next",
            textColor: Colors.white,
            onTap: () {
              controller.movePageController();
              controller.update();
            }),
      );
}
