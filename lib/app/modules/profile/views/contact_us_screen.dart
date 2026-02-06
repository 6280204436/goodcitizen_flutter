import 'package:good_citizen/app/core/widgets/custom_app_bar.dart';

import '../../../export.dart';
import '../controllers/contact_us_controller.dart';

class ContactUsScreen extends GetView<ContactUsController> {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      extendBodyBehindAppBar: false,
      appBar: _appBarWidget(),
      body: _bodyWidget(),
    );
  }

  AppBar _appBarWidget() {
    return customAppBar(
      titleText: keyContactUs.tr,
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Form(
              key: controller.key,
              child: Column(
                children: [
                  // _nameField().paddingOnly(bottom: margin_14),
                  // _emailField().paddingOnly(bottom: margin_14),
                  // _phoneField().paddingOnly(bottom: margin_14),
                  // _subjectField().paddingOnly(bottom: margin_14),
                  // _descriptionField().paddingOnly(bottom: margin_14),
                ],
              ).paddingSymmetric(vertical: margin_20, horizontal: margin_15),
            ),
          ),
        ),
        // _buttonsWidget(),
      ],
    );
  }

  // TextFieldWidget _nameField() {
  //   return TextFieldWidget(
  //     controller: controller.nameController,
  //     focusNode: controller.nameNode,
  //     hintText: strName,
  //     labelText: strName,
  //     maxLength: 80,
  //     inputType: TextInputType.text,
  //     validator: (value) =>
  //         FieldChecker.fieldChecker(value: value, title: strName),
  //   );
  // }

  // TextFieldWidget _emailField() {
  //   return TextFieldWidget(
  //     controller: controller.emailController,
  //     focusNode: controller.emailNode,
  //     hintText: strEmail,
  //     labelText: strEmail,
  //     maxLength: 80,
  //     inputType: TextInputType.emailAddress,
  //     validator: (value) =>
  //         EmailValidator.validateEmail(value: value, title: strEmail),
  //   );
  // }

  // TextFieldWidget _subjectField() {
  //   return TextFieldWidget(
  //     controller: controller.subjectController,
  //     focusNode: controller.subjectNode,
  //     hintText: strSubject,
  //     labelText: strSubject,
  //     maxLength: 100,
  //     inputType: TextInputType.text,
  //     validator: (value) =>
  //         FieldChecker.fieldChecker(value: value, title: strSubject),
  //   );
  // }

  // CountryPickerTextField _phoneField() {
  //   return CountryPickerTextField(
  //     controller: controller.phoneController,
  //     focusNode: controller.phoneNode,
  //     labelText: strPhoneNumberTitle,
  //     pickerKey: controller.countryPickerKey,
  //     hintText: strPhoneNumber,
  //     selectedCountry: controller.selectedCountry,
  //     onChanged: (value) {},
  //     onCountryChanged: (value) {
  //       controller.selectedCountry.value = value;
  //     },
  //   );
  // }
  //
  // TextFieldWidget _descriptionField() {
  //   return TextFieldWidget(
  //     controller: controller.descriptionController,
  //     focusNode: controller.descriptionNode,
  //     labelText:keyMessage1.tr,
  //     minLines: 5,
  //     maxLines: 5,
  //
  //     textInputAction: TextInputAction.newline,
  //
  //     hintText: keyWriteMessage.tr,
  //     validator: (value) =>
  //         FieldChecker.fieldChecker(value: value, title: strDescription),
  //     inputType: TextInputType.multiline,
  //   );
  // }

  // Widget _buttonsWidget() {
  //   return CustomMaterialButton(
  //     onTap: controller.contactUsApiCall,
  //     buttonText: strSubmit,
  //   )
  //       .paddingSymmetric(horizontal: margin_20, vertical: margin_15)
  //       .paddingOnly(bottom: margin_15);
  // }
}
