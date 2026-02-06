import 'package:good_citizen/app/common_data.dart';
import 'package:good_citizen/app/core/utils/localizations/localization_controller.dart';
import 'package:good_citizen/app/core/widgets/drop_down_text_widget.dart';
import 'package:good_citizen/app/currencies_json.dart';
import 'package:good_citizen/app/modules/profile/controllers/currency_language_controller.dart';
import '../../../export.dart';

class CurrencyLanguageScreen extends GetView<CurrencyLanguageController> {
  const CurrencyLanguageScreen({super.key});

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
    return customAppBar(titleText: keyCurrencyLanguage.tr);
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // _currencyDropDown().paddingOnly(bottom: margin_25),
                // _languageDropDown()
              ],
            ).paddingSymmetric(vertical: margin_7, horizontal: margin_15),
          ),
        ),
        _buttonsWidget()
      ],
    );
  }

  // Widget _currencyDropDown() {
  //   return DropdownFieldWidget(
  //     hintText: keyPrefCurrency.tr,
  //     labelText: keyPrefCurrency.tr,
  //     list: currenciesList,
  //     selected: controller.selectedCurrency.value,
  //     // showSearch: true,
  //     onChanged: (value) {
  //       controller.selectedCurrency.value = value;
  //       controller.isDataChanged.value = true;
  //     },
  //   );
  // }

  // Widget _languageDropDown() {
  //   return DropdownFieldWidget(
  //     hintText: keyPrefLanguage.tr,
  //     labelText: keyPrefLanguage.tr,
  //     list: languagesList,
  //     selected: controller.tempSelectedLanguage.value,
  //     onChanged: (value) {
  //       controller.tempSelectedLanguage.value = value;
  //       controller.isDataChanged.value = true;
  //     },
  //   );
  // }

  Widget _buttonsWidget() {
    return Visibility(
      visible: controller.isDataChanged.value,
      child: SafeArea(
        top: false,
        child: CustomMaterialButton(
          enabled: controller.isDataChanged.value,
          onTap:(){

          },
          isLoading: controller.isSavingChanges.value,
          buttonText: keySave.tr,
        )
            .paddingSymmetric(horizontal: margin_15, vertical: margin_0)
            .paddingOnly(bottom: margin_10, top: margin_10),
      ),
    );
  }
}
