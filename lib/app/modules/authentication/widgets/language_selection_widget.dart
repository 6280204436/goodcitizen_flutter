import '../../../common_data.dart';
import '../../../core/utils/localizations/localization_controller.dart';
import '../../../export.dart';
import '../controllers/login_controller.dart';

class LanguageSelectionWidget extends StatelessWidget {
  final LoginController loginController;

  const LanguageSelectionWidget({super.key, required this.loginController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Expanded(child: _languageList()), _languageButtons()],
    );
  }

  Widget _languageList() {
    return Column(
      children: [
        TextView(
            text: keyChooseLang,
            textStyle:
            textStyleTitleLarge()!.copyWith(fontWeight: FontWeight.w600))
            .paddingOnly(bottom: margin_10),
        Expanded(
          child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: languagesList.length,
              // physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (context, index) =>
                  _dividerWidget().paddingSymmetric(vertical: margin_12),
              itemBuilder: (context, index) => _singleLanguageWidget(index)),
        ),
      ],
    );
  }

  Widget _dividerWidget() {
    return Divider(color: greyColor.withOpacity(0.5));
  }

  Widget _singleLanguageWidget(int index) {
    return Obx(() =>
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            loginController.tempSelectedLanguage.value=languagesList[index];
            loginController.tempSelectedLanguage.refresh();
          },
          child: Row(
            children: [
              Expanded(
                  child: TextView(
                      text: languagesList[index].title ?? '',
                      textStyle: textStyleTitleLarge()
                          !.copyWith(fontWeight: FontWeight.w400))),

            ],
          ),
        ));
  }

  Widget _languageButtons() {
    return Row(children: [
      Expanded(
        child: CustomMaterialButton(
          onTap: () {
            Get.back();
          },
          buttonText: keyCancel.tr,
          //textColor: AppColors.blackColor,
          isOutlined: true,
        ),
      ),
      SizedBox(width: height_15),
      Expanded(
        child: CustomMaterialButton(
          onTap: () {
            loginController.changeLanguage();
          },
          buttonText: keyDone.tr,
        ),
      ),
    ]);
  }
}
