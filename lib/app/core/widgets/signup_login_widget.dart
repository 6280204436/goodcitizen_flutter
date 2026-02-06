import 'package:good_citizen/app/core/utils/localizations/localizations.dart';
import 'package:good_citizen/app/core/widgets/text_view_widget.dart';

import '../../export.dart';

Widget showSignupLoginWidget(
    {String? title,
    String? description,
    VoidCallback? onSignup,
    VoidCallback? onLogin}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextView(
        text: title ?? '',
        maxLines: 2,
        textStyle:
            textStyleHeadlineMedium()!.copyWith(fontWeight: FontWeight.bold),
        textAlign: TextAlign.start,
      ),
      TextView(
        text: description ?? '',
        maxLines: 3,
        textStyle: textStyleTitleSmall()!.copyWith(),
        textAlign: TextAlign.start,
      ).paddingOnly(top: margin_8, bottom: margin_15),
      CustomMaterialButton(
        onTap: () {
          preferenceManager.saveCurrentRoute(Get.currentRoute);
          onSignup?.call();
        },
        buttonText: keySignUp,
      ).paddingOnly(bottom: margin_12),
      CustomMaterialButton(
        onTap: () {
          preferenceManager.saveCurrentRoute(Get.currentRoute);
          onLogin?.call();
        },
        isOutlined: true,
        borderColor: AppColors.appColor,
        buttonText: keyLogIn,
      ),
    ],
  ).paddingOnly(bottom: margin_15);
}
