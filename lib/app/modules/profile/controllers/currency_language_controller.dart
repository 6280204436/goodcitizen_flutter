import 'package:good_citizen/app/core/utils/localizations/localization_controller.dart';
import 'package:good_citizen/app/export.dart';

import '../../../common_data.dart';
import '../../../core/utils/common_item_model.dart';
import '../../../currencies_json.dart';
import '../../authentication/models/auth_request_model.dart';
import '../../authentication/models/data_model/user_model.dart';
import '../../model/media_file_model.dart';


class CurrencyLanguageController extends GetxController {
  Rx<UserDataModel> userDataModel = UserDataModel().obs;

  RxBool isUploadingImage = false.obs;
  Rx<MediaFile> imageFile = MediaFile().obs;

  Rxn<CommonItemModel> selectedCurrency = Rxn();
  Rxn<CommonItemModel> tempSelectedLanguage = Rxn();

  RxBool isDataChanged = false.obs;
  RxBool isSavingChanges = false.obs;

  @override
  void onInit() {
    _getArgs();
    super.onInit();
  }

  void _getArgs() {}

  @override
  void onReady() {
    _setData();
    super.onReady();
  }

  void _setData() {
    selectedCurrency.value = getSelectedCurrency(
        profileDataProvider.userDataModel.value?.prefCurrency);
    // tempSelectedLanguage.value = getSelectedLanguage();
  }


}
