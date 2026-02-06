import 'package:good_citizen/app/core/widgets/center_loader.dart';
import 'package:good_citizen/app/core/widgets/no_result_widget.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../export.dart';
import '../controllers/faq_controller.dart';

class FaqScreen extends GetView<FaqController> {
  const FaqScreen({super.key});

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
    return customAppBar(
      titleText: keyFaq.tr,
    );
  }

  Widget _bodyWidget() {
    return _faqList()
        .paddingSymmetric(horizontal: margin_15, vertical: margin_15);
  }

  Widget _faqList() {
    return controller.isLoading.value
        ? showCenterLoader()
        : controller.faqList.isEmpty
            ? noResultWidget()
            : ListView.builder(
                itemCount: controller.faqList.length,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemBuilder: (BuildContext ctx, index) {
                  return _singleItemWidget(index)
                      .paddingOnly(bottom: margin_15);
                });
  }

  Widget _singleItemWidget(int index) {
    return ExpansionTile(
      childrenPadding: EdgeInsets.symmetric(horizontal: margin_8),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      tilePadding: EdgeInsets.symmetric(horizontal: margin_15),
      title: TextView(
        text: controller.faqList[index].questions ?? '',
        textStyle: textStyleTitleSmall()!.copyWith(fontWeight: FontWeight.w500),
        textAlign: TextAlign.start,
        maxLines: 2,
      ),
      collapsedIconColor: isDarkMode.value ? Colors.white : blackColor,
      iconColor: isDarkMode.value ? Colors.white : blackColor,
      children: [
        Html(
          data: controller.faqList[index].answer,
          style: {
            "p": Style(
              color: isDarkMode.value
                  ? Colors.white
                  : AppColors.appColor, // Dynamic text color
            ),
            "span": Style(
              color: isDarkMode.value
                  ? Colors.white
                  : Colors.black, // Apply dark mode text color
            ),
            // You can customize other HTML tags here as needed
          },
        )
      ],
    ).paddingSymmetric(
      vertical: margin_6,
    );
  }
}
