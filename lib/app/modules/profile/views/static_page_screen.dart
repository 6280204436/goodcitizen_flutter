import 'package:good_citizen/app/core/widgets/center_loader.dart';
import 'package:good_citizen/app/core/widgets/custom_app_bar.dart';
import 'package:good_citizen/app/core/widgets/no_result_widget.dart';

import 'package:good_citizen/app/modules/profile/controllers/static_page_controller.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../export.dart';

class StaticPageScreen extends GetView<StaticPageController> {
  const StaticPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: false,
      extendBodyBehindAppBar: false,
      appBar: _appBarWidget(),
      body: Obx(() =>
          controller.notificationResponse.value?.data?.first.content != null
              ? _bodyWidget()
              : SizedBox()),
    );
  }

  AppBar _appBarWidget() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Obx(() => Text(
            (controller.notificationResponse.value?.data?.first.type == "YEARLY"
                        ? "EULA"
                        : controller
                                .notificationResponse.value?.data?.first.type ??
                            "")
                    ?.replaceAll("_", " ") ??
                "",
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 18, color: Colors.black),
          )),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget _bodyWidget() {
    return htmlView(controller.notificationResponse.value?.data?.first.content);
  }

  Widget htmlView(String? data) {
    return SingleChildScrollView(
      child: Html(
        style: {
          "body": Style(
            backgroundColor: Colors.white,
            color: Colors.black87,
            fontSize: FontSize.medium,
            padding: HtmlPaddings.symmetric(horizontal: 10, vertical: 10),
          ),
        },
        data: data,
      ).paddingSymmetric(horizontal: margin_10, vertical: margin_10),
    );
  }
}
