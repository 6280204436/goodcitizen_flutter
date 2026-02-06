import '../remote_config.dart';
import 'core/external_packages/google_places/google_places_flutter.dart';
import 'core/external_packages/google_places/model/prediction.dart';
import 'export.dart';

class GoogleLocationPickerTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final double? contentPadding;
  final double? borderRadius;
  final bool showBorder;
  final dynamic prefixConstraints;
  final dynamic suffixConstraints;
  final String? prefixText;
  final String? suffixText;
  final Widget? prefIxIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final Function(Prediction prediction) onPlaceTap;
  final String? Function(String? value)? validator;

  const GoogleLocationPickerTextField({
    super.key,
    required this.focusNode,
    this.validator,
    this.contentPadding,
    this.showBorder = true,
    this.borderRadius,
    this.suffixConstraints,
    this.prefixConstraints,
    this.prefixText,
    this.suffixText,
    this.suffixIcon,
    this.prefIxIcon,
    this.hintText,
    required this.controller,
    required this.onPlaceTap,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(Get.context!).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.greyColor,
          selectionColor: AppColors.appColor.withOpacity(0.3),
        ),
      ),
      child: GooglePlaceAutoCompleteTextField(
        countries: ["in"],
        textEditingController: controller,
        focusNode: focusNode,
        boxDecoration: const BoxDecoration(
          color: Colors.white, // Background for the input container
          borderRadius: BorderRadius.all(Radius.circular(8.0)), // Optional: rounded corners
        ),
        containerVerticalPadding: 0,
        googleAPIKey: googleApiConst,
        inputDecoration: _inputDecoration(),
        itemClick: onPlaceTap,
        debounceTime: 400,
        showError: false,
        isLatLngRequired: false,
        textStyle: textStyleTitleSmall()!.copyWith(fontWeight: FontWeight.w400),
        containerHorizontalPadding: margin_0,
        getPlaceDetailWithLatLng: (postalCodeResponse) {},
        seperatedBuilder: _dividerWidget(),
        itemBuilder: (context, index, Prediction prediction) {
          return Container(
            color: Colors.white, // Set dropdown item background to white
            child: _singleLocationWidget(prediction)
                .paddingOnly(top: index == 0 ? margin_8 : 0),
          );
        },
        isCrossBtnShown: false,
      ),
    );
  }

  Widget _dividerWidget() {
    return Divider(
      height: margin_0point8,
      color: greyColor.withOpacity(0.5),
    );
  }

  Widget _singleLocationWidget(Prediction prediction) {
    return Row(
      children: [
        AssetSVGWidget(
          icLocationWhite,
          imageHeight: height_15,
          color: Colors.white,
          imageWidth: height_15,
        ).paddingOnly(right: margin_8),
        SizedBox(
          width: Get.width*0.6,
          child: TextView(
            text: prediction.description ?? '',
            textAlign: TextAlign.start,
            textStyle: textStyleBodyMedium()!.copyWith(
              fontWeight: FontWeight.w400,
              color: Colors.black, // Changed to black for better contrast on white background
            ),
            maxLines: 3,
          ),
        ).paddingSymmetric(vertical: 10),
      ],
    ).paddingSymmetric(horizontal: margin_6);
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
      border: showBorder
          ? UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromRGBO(204, 204, 204, 1),
          width: 1,
        ),
      )
          : InputBorder.none,
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromRGBO(204, 204, 204, 1),
          width: 1,
        ),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromRGBO(204, 204, 204, 1),
          width: 1,
        ),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromRGBO(204, 204, 204, 1),
          width: 1,
        ),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 1,
        ),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 1,
        ),
      ),
      hintText: hintText?.tr,
      hintStyle: textStyleTitleSmall()?.copyWith(color: AppColors.textGreyColor),
      suffixIcon: suffixIcon,
      suffixIconConstraints: suffixConstraints,
      prefixIcon: prefIxIcon,
    );
  }
}