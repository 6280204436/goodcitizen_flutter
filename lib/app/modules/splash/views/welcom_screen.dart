import 'package:good_citizen/app/export.dart';
import 'package:good_citizen/app/modules/splash/widgets/onboarding_item.dart';

class OnBoardingView extends GetView<OnBoardingController> {
  const OnBoardingView({super.key});

  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return SingleChildScrollView(
      child: SizedBox(
        width: Get.width,
        height: Get.height,
        child: _body(context, isLandscape),
      ),
    );
  }

  Widget _body(BuildContext context, bool isLandscape) => Stack(
        children: [
          _pageView(),
          _bottomView(context, isLandscape),
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
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(200, 41, 39, 1),
            Color.fromRGBO(221, 78, 75, 1),
            Color.fromRGBO(251, 123, 118, 0.9)
          ],
        )),
      );

  Widget _bottomView(BuildContext context, bool isLandscape) => Align(
        alignment: Alignment.bottomCenter,
        child: GetBuilder<OnBoardingController>(
          builder: (controller) => isLandscape
              ? _landscapeLayout(context, controller)
              : _portraitLayout(context, controller),
        ),
      );

  Widget _portraitLayout(
          BuildContext context, OnBoardingController controller) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AssetImageWidget(
            controller.selectedIndex.value == 0
                ? iconOne
                : controller.selectedIndex.value == 1
                    ? iconTwo
                    : iconThree,
            imageHeight: height_350,
            imageWidth: width_300,
            imageFitType: BoxFit.contain,
          ).marginOnly(top: margin_80),
          _content(controller),
          const Spacer(),
          _bottomBar(controller),
        ],
      );

  Widget _landscapeLayout(
          BuildContext context, OnBoardingController controller) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: AssetImageWidget(
              controller.selectedIndex.value == 0
                  ? iconOne
                  : controller.selectedIndex.value == 1
                      ? iconTwo
                      : iconThree,
              imageHeight: Get.height * 0.5,
              imageWidth: Get.width * 0.4,
              imageFitType: BoxFit.contain,
            ).marginOnly(top: margin_20, left: margin_20),
          ),
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _content(controller).marginOnly(top: margin_20),
                const Spacer(),
                _bottomBar(controller),
              ],
            ).marginOnly(right: margin_20),
          ),
        ],
      );

  Widget _content(OnBoardingController controller) => OnBoardingItem(
        heading: controller.listItem[controller.selectedIndex.value].heading,
        subheading:
            controller.listItem[controller.selectedIndex.value].subheading,
      ).paddingSymmetric(vertical: margin_10);

  Widget _bottomBar(OnBoardingController controller) => Container(
        height: height_70,
        decoration: BoxDecoration(
            color: Color.fromRGBO(200, 41, 39, 1),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _indicators(),
            GestureDetector(
                onTap: () {
                  controller.movePageController();
                  controller.update();
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.red,
                    ).paddingAll(margin_5))),
          ],
        ).paddingSymmetric(horizontal: margin_15),
      );

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
                      ? AppColors.whiteAppColor
                      : AppColors.whiteAppColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: controller.selectedIndex.value == index
                        ? AppColors.whiteAppColor
                        : AppColors.whiteAppColor.withOpacity(0.1),
                    width: 5.0,
                  ),
                ),
              ).paddingOnly(right: 5.0),
            );
          },
        ),
      ).marginSymmetric(horizontal: margin_15);
}
