import 'package:good_citizen/app/export.dart';
import 'package:good_citizen/app/modules/authentication/models/auth_request_model.dart';
import 'package:good_citizen/app/modules/authentication/models/data_model/message_response_model.dart';
import 'package:good_citizen/app/modules/authentication/models/data_model/user_model.dart';

import '../../../core/utils/common_methods.dart';
import '../../../core/widgets/intl_phone_field/countries.dart';
import '../../../core/widgets/intl_phone_field/intl_phone_field.dart';

class ContactUsController extends GetxController {
  GlobalKey<FormState> key = GlobalKey();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController subjectController;
  late TextEditingController phoneController;
  late TextEditingController descriptionController;
  final GlobalKey<IntlPhoneFieldState> countryPickerKey =
      GlobalKey<IntlPhoneFieldState>();

  late FocusNode nameNode;
  late FocusNode emailNode;
  late FocusNode subjectNode;
  late FocusNode phoneNode;
  late FocusNode descriptionNode;

  late Rx<Country> selectedCountry;

  dynamic argData;

  @override
  void onInit() {
    _getArgs();
    _initControllers();
    _loadCountry();
    super.onInit();
  }

  void _getArgs() {
    if (Get.arguments != null) {
      argData = Get.arguments;
    }
  }

  void _loadCountry() {
    final country = getSelectedCountryCode();
    selectedCountry = country.obs;
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  RxBool isSaving = false.obs;

  @override
  void onReady() {
    updateData();
    super.onReady();
  }

  updateData() async {
    UserDataModel? loginData = await preferenceManager.getSavedLoginData();
    if (loginData != null) {
      nameController.text = loginData.name ?? '';
      emailController.text = loginData.email ?? '';
      final country = getSelectedCountryCode(code: loginData.countryCode);
      selectedCountry = country.obs;
      // countryPickerKey.currentState?.selectedCountry = selectedCountry.value;
      countryPickerKey.currentState?.setState(() {});
      phoneController.text = loginData.phone ?? '';
    } else {
      if (argData != null && argData is Map) {
        emailController.text = argData['email'] ?? '';
      }
    }
  }

  void contactUsApiCall() {
    if (key.currentState!.validate() == false) {
      return;
    }

    isSaving.value = true;
    final data = AuthRequestModel.contactUsRequestModel(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        country: '+${selectedCountry.value.dialCode}',
        phone: phoneController.text.trim(),
        subject: subjectController.text.trim(),
        description: descriptionController.text.trim());
    repository.contactUsApiCall(dataBody: data).then((value) {
      isSaving.value = false;
      if (value != null) {
        MessageResponseModel messageResponseModel = value;
        Get.back();
        showSnackBar(message: messageResponseModel.message ?? '');
      }
    }).onError((error, stackTrace) {
      isSaving.value = false;
      showSnackBar(message: error.toString());
    });
  }

  void _initControllers() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    subjectController = TextEditingController();
    descriptionController = TextEditingController();
    phoneController = TextEditingController();

    nameNode = FocusNode();
    emailNode = FocusNode();
    phoneNode = FocusNode();
    subjectNode = FocusNode();
    descriptionNode = FocusNode();
  }

  void _disposeControllers() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    subjectController.dispose();
    descriptionController.dispose();

    nameNode.dispose();
    emailNode.dispose();
    phoneNode.dispose();
    subjectNode.dispose();
    descriptionNode.dispose();
  }
}
