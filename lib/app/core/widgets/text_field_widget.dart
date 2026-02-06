import '../../export.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final TextStyle? labelTextStyle;
  final TextStyle? inputTextStyle;
  final String? labelText;
  final TextInputType? inputType;
  final TextInputAction? textInputAction;
  final double? contentPadding;
  final double? borderRadius;
  final double? borderWidth;
  final Color? borderColor;
  final Color? bgColor;
  final Color? cursorColor;
  final bool obscureText;
  final bool showShadow;
  final bool readOnly;
  final bool enabled;
  final bool showBorder;
  final bool allowMultiline;
  final bool showLimitDialog;
  final bool capitalizeHint;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefIxIcon;
  final Widget? suffixIcon;
  final Widget? prefIx;
  final Widget? suffix;
  final String? Function(String? value)? validator;
  int? maxLength;
  final int? minLines;
  final int? maxLines;
  final VoidCallback? onTap;
  final AutovalidateMode? autovalidateMode;
  final Function(String value)? onChanged;
  final dynamic prefixConstraints;
  final dynamic suffixConstraints;

  final String? prefixText;
  final String? suffixText;
  final TextStyle? prefixTextStyle;
  final TextStyle? suffixTextStyle;
  final TextAlign? textAlign;
  final TextCapitalization? textCapitalization;

  TextFieldWidget(
      {Key? key,
      required this.controller,
      required this.hintText,
      this.hintTextStyle,
      this.inputTextStyle,
      this.labelTextStyle,
      this.labelText,
      this.textAlign,
      this.onChanged,
      this.contentPadding,
      this.borderRadius,
      this.borderWidth,
      this.prefixConstraints,
      this.suffixConstraints,
      this.borderColor,
      this.cursorColor,
      this.maxLength,
      this.minLines,
      this.maxLines,
      this.prefixText,
      this.suffixText,
      this.prefixTextStyle,
      this.suffixTextStyle,
      this.bgColor,
      this.inputType = TextInputType.text,
      this.textInputAction = TextInputAction.next,
      this.showBorder = true,
      this.obscureText = false,
      this.showShadow = false,
      this.readOnly = false,
      this.allowMultiline = false,
      this.showLimitDialog = false,
      this.enabled = true,
      this.capitalizeHint = true,
      this.inputFormatters,
      this.prefIxIcon,
      this.suffixIcon,
      this.prefIx,
      this.textCapitalization,
      this.suffix,
      this.onTap,
      this.autovalidateMode,
      this.focusNode,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (maxLength == null) {
      if (inputType == TextInputType.multiline) {
        maxLength = 250;
      } else {
        maxLength = 60;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: labelText != null,
          child: TextView(
                  text: labelText ?? "",
                  textStyle: labelTextStyle ?? textStyleTitleLarge()!)
              .paddingOnly(bottom: margin_2),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
            radius_12,
          )),
          child: Theme(
            data: Theme.of(context).copyWith(
                textSelectionTheme: TextSelectionThemeData(
                    selectionColor: AppColors.appColor.withOpacity(0.3))),
            child: TextFormField(
              obscureText: obscureText,
              controller: controller,
              maxLength: maxLength,
              textCapitalization: textCapitalization ?? TextCapitalization.none,
              readOnly: readOnly,
              onTap: onTap,
              minLines: minLines,
              maxLines: maxLines ?? (allowMultiline ? null : 1),
              focusNode: focusNode,
              keyboardType: inputType,
              onChanged: (value) {
                // if ( showLimitDialog&&maxLength != null && value.length == maxLength) {
                //   showSnackBar(
                //       message: 'Maximum character limit exceeded.',
                //       isWarning: true);
                // }
                onChanged?.call(value);
              },
              textAlign: textAlign ?? TextAlign.start,
              autovalidateMode: autovalidateMode ?? AutovalidateMode.onUnfocus,
              textAlignVertical: TextAlignVertical.center,
              textInputAction: textInputAction,
              inputFormatters: inputFormatters,
              validator: enabled ? validator : null,
              enabled: enabled,
              cursorColor: Colors.grey,
              style: inputTextStyle ??
                  textStyleTitleSmall()!.copyWith(
                      fontWeight: FontWeight.w400, color: Colors.black),
              decoration: _inputDecoration(),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      fillColor: AppColors.whiteLight,
      filled: true,
      contentPadding: EdgeInsets.symmetric(
        vertical: contentPadding ?? margin_13,
        horizontal: contentPadding ?? margin_12,
      ),
      errorMaxLines: 3,
      counterText: '',
      border: !showBorder
          ? InputBorder.none
          : UnderlineInputBorder(
              borderSide: BorderSide(
                  color:  Color.fromRGBO(204,204,204, 1), width: 1), // Bottom border only
            ),
      focusedBorder: !showBorder
          ? InputBorder.none
          : UnderlineInputBorder(
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
          : UnderlineInputBorder(
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
          : UnderlineInputBorder(
              borderSide: BorderSide(
                  color:  Color.fromRGBO(204,204,204, 1),
                  width: 1),
            ),
      prefixIcon: prefIxIcon,
      suffixIcon: suffixIcon,
      suffix: suffix,
      prefix: prefIx,
      prefixText: prefixText,
      suffixText: suffixText,
      prefixStyle: prefixTextStyle,
      suffixStyle: suffixTextStyle,
      suffixIconColor: ((focusNode?.hasFocus) ?? false)
          ? AppColors.appColor
          : AppColors.greyColor,
      prefixIconConstraints: prefixConstraints,
      suffixIconConstraints: suffixConstraints,
      hintText: hintText?.tr,
      hintStyle:
          textStyleTitleSmall()!.copyWith(color: AppColors.textGreyColor),
    );
  }
}
