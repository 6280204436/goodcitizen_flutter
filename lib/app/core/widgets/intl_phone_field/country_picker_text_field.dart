import 'package:good_citizen/app/core/widgets/intl_phone_field/phone_number.dart';

import '../../../export.dart';
import '../text_view_widget.dart';
import 'intl_phone_field.dart';
import 'package:good_citizen/app/core/widgets/intl_phone_field/countries.dart';

class CountryPickerTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final GlobalKey<IntlPhoneFieldState>? pickerKey;
  final String? hintText;
  final String? labelText;
  final TextStyle? inputTextStyle;
  final TextInputType? inputType;
  final TextInputAction? textInputAction;
  final double? contentPadding;
  final double? borderRadius;
  final bool showShadow;
  final bool showCountryFlag;
  final bool readOnly;
  final Widget? suffix;
  final Rx<Country> selectedCountry;
  final ValueChanged<Country>? onCountryChanged;
  final Function(PhoneNumber value)? onChanged;
  final bool showBorder;

  final double? borderWidth;
  final Color? borderColor;

  const CountryPickerTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      this.pickerKey,
      this.labelText,
      this.inputTextStyle,
      this.contentPadding,
      this.onChanged,
      this.borderRadius,
      this.inputType = TextInputType.text,
      this.textInputAction = TextInputAction.next,
      this.showShadow = false,
      this.showCountryFlag = false,
      this.readOnly = false,
      this.suffix,
      this.focusNode,
      required this.selectedCountry,
      required this.onCountryChanged,
      this.borderColor,
      this.showBorder = true,
      this.borderWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: labelText != null,
          child: TextView(
                  text: labelText ?? "",
                  textStyle: textStyleTitleSmall()!.copyWith(
                      fontWeight: FontWeight.w400, color: Colors.black) )
              .paddingOnly(bottom: margin_8),
        ),
        Theme(
          data: Theme.of(context).copyWith(
              textSelectionTheme: TextSelectionThemeData(
                  selectionColor: AppColors.appColor.withOpacity(0.4))),
          child: AbsorbPointer(
            absorbing: readOnly,
            child: IntlPhoneField(

              controller: controller,
              focusNode: focusNode,
              key: pickerKey,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: textInputAction,
              invalidNumberMessage: keyInvalidNumber.tr,
              emptyFieldMessage: keyPlsEnterPhone.tr,
              decoration: _inputDecoration(),
              dropdownTextStyle: textStyleTitleSmall(),
              showCountryFlag:false,


              dropdownIcon: Icon(Icons.arrow_drop_down,color: Colors.grey,size: 20,),
              onChanged: onChanged,
              style: inputTextStyle ??
                  textStyleTitleSmall()!.copyWith(fontWeight: FontWeight.w400),
              initialSelectedCountry: selectedCountry,
              dropdownIconPosition: IconPosition.leading,
              onCountryChanged: onCountryChanged,
              autovalidateMode: AutovalidateMode.onUnfocus,

            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      fillColor: Colors.white.withOpacity(.15),
      filled: false,
      contentPadding: EdgeInsets.symmetric(
          vertical: margin_15, horizontal: contentPadding ?? margin_12),
      errorMaxLines: 3,
      counterText: '',
      border: !showBorder
          ? InputBorder.none
          : UnderlineInputBorder(
        borderSide: BorderSide(
            color:  Color.fromRGBO(204,204,204, 1),
            width: 1),
      ),
      focusedBorder: !showBorder
          ? InputBorder.none
          :  UnderlineInputBorder(
        borderSide: BorderSide(
            color:  Color.fromRGBO(204,204,204, 1),
            width: 1),
      ),
      disabledBorder: !showBorder
          ? InputBorder.none
          : UnderlineInputBorder(
        borderSide: BorderSide(
            color:  Color.fromRGBO(204,204,204, 1),
            width: 1),
      ),
      enabledBorder: !showBorder
          ? InputBorder.none
          :UnderlineInputBorder(
        borderSide: BorderSide(
            color:  Color.fromRGBO(204,204,204, 1),
            width: 1),
      ),
      focusedErrorBorder: !showBorder
          ? InputBorder.none
          : UnderlineInputBorder(
        borderSide: BorderSide(
            color:  Color.fromRGBO(204,204,204, 1),
            width: 1),
      ),
      errorBorder: !showBorder
          ? InputBorder.none
          :UnderlineInputBorder(
        borderSide: BorderSide(
            color:  Color.fromRGBO(204,204,204, 1),
            width: 1),
      ),
      hintText: hintText?.tr,
      hintStyle:
          textStyleTitleSmall()!.copyWith(color: AppColors.textGreyColor),
      suffixIcon: suffix,
    );
  }
}
