import 'package:good_citizen/app/modules/profile/controllers/change_theme_controller.dart';

import '../../../export.dart';

class ChangeThemeView extends StatelessWidget {
  const ChangeThemeView({super.key});

  @override
  Widget build(BuildContext context) {
    return _bodyView();
  }

  Widget _bodyView() => Center(
        child: Container(
          width: Get.width,
          margin: EdgeInsets.symmetric(horizontal: margin_20),
          decoration: BoxDecoration(
              color: isDarkMode.value ? Colors.black : Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(margin_6))),
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: margin_15, vertical: margin_15),
            decoration: BoxDecoration(
                color: isDarkMode.value ? Colors.white.withOpacity(.15) : null,
                borderRadius: BorderRadius.all(Radius.circular(margin_15))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _changeThemeHeading(),
                _divider(),
                _systemThemeView(),
                _darkThemeView(),
                _lightThemeView(),
                _changeThemeButton(),
              ],
            ),
          ),
        ),
      );

  Widget _changeThemeHeading() => Row(
        children: <Widget>[
          Expanded(
            child: TextView(
              text: keyChangeTheme.tr,
              textStyle: textStyleHeadlineMedium()!.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: font_18,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              // ignore: inference_failure_on_function_invocation
              Get.back();
            },
            child: const Icon(Icons.cancel),
          )
        ],
      );

  Widget _divider() =>
      Divider(color: Colors.grey.shade300).marginOnly(top: margin_15);

  Widget _systemThemeView() => GetBuilder<ChangeThemeController>(
        init: ChangeThemeController(),
        builder: (ChangeThemeController controller) {
          return ListTile(
            onTap: () {
              controller.setThemeMode(typeDefualtSystemTheme);
            },
            title: Text(keyDayNight.tr, style: textStyleTitleSmall()),
            contentPadding: EdgeInsets.zero,
            leading: SizedBox(
              width: height_20,
              height: height_20,
              child: Radio<int>(
                activeColor: isDarkMode.value?Colors.white:AppColors.appColor,
                value: typeDefualtSystemTheme,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                groupValue: controller.themeMode,
                onChanged: (int? value) {
                  if (value != null) {
                    controller.setThemeMode(value);
                  }
                },
              ),
            ),
          );
        },
      );

  Widget _darkThemeView() => GetBuilder<ChangeThemeController>(
        init: ChangeThemeController(),
        builder: (ChangeThemeController controller) {
          return ListTile(
            onTap: () {
              controller.setThemeMode(typeDarkTheme);
            },
            title: Text(keyDarkTheme.tr, style: textStyleTitleSmall()),
            contentPadding: EdgeInsets.zero,
            leading: SizedBox(
              width: height_20,
              height: height_20,
              child: Radio<int>(
                activeColor: isDarkMode.value?Colors.white:AppColors.appColor,
                value: typeDarkTheme,
                groupValue: controller.themeMode,
                onChanged: (int? value) {
                  if (value != null) {
                    controller.setThemeMode(value);
                  }
                },
              ),
            ),
          );
        },
      );

  Widget _lightThemeView() => GetBuilder<ChangeThemeController>(
        init: ChangeThemeController(),
        builder: (ChangeThemeController controller) {
          return ListTile(
            onTap: () {
              controller.setThemeMode(typeLightTheme);
            },
            title: Text(keyLightTheme.tr, style: textStyleTitleSmall()),
            contentPadding: EdgeInsets.zero,
            leading: SizedBox(
              width: height_20,
              height: height_20,
              child: Radio<int>(
                activeColor: isDarkMode.value?Colors.white:AppColors.appColor,
                value: typeLightTheme,
                groupValue: controller.themeMode,
                onChanged: (int? value) {
                  if (value != null) {
                    controller.setThemeMode(value);
                  }
                },
              ),
            ),
          );
        },
      );

  Widget _changeThemeButton() => GetBuilder<ChangeThemeController>(
        init: ChangeThemeController(),
        builder: (ChangeThemeController controller) {
          return CustomMaterialButton(
            onTap: () {
              controller.changeTheme();
            },
            buttonText: keySave.tr,
            buttonHeight: height_40,
            // isOutlined: true,
            borderColor: AppColors.blackColor,
          ).marginOnly(top: margin_15);
        },
      );
}
