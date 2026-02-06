// /*
//  * @copyright : Henceforth Pvt. Ltd. <info@henceforthsolutions.com>
//  * @author     : Gaurav Negi
//  * All Rights Reserved.
//  * Proprietary and confidential :  All information contained herein is, and remains
//  * the property of Henceforth Pvt. Ltd. and its partners.
//  * Unauthorized copying of this file, via any medium is strictly prohibited.
//  *
//  */
//
// import 'package:abundish_user/app/modules/authentication/models/responseModel/save_data_update_model.dart';
//




import 'package:dropdown_button2/dropdown_button2.dart';

import '../../export.dart';


class DropDownTextWidget extends StatefulWidget {
  final String? hint;
  final bool? dropdownType;
  final dynamic selectedValue;
  final dynamic validate;
  final dynamic hintStyle;
  final dynamic focusNode;
  final dynamic labelTextStyle;
  final dynamic styleheading;
  final EdgeInsets? contentPadding;
  final Function(dynamic value)? onFieldSubmitted;
  final bool? isShadow;
  final List? items;
  final dynamic dropDownColor;
  final dynamic icon;
  final dynamic tvHeading;

  DropDownTextWidget({
    this.hint,
    this.selectedValue,
    this.hintStyle,
    this.focusNode,
    this.labelTextStyle,
    this.validate,
    this.onFieldSubmitted,
    this.items,
    this.contentPadding,
    this.tvHeading,
    this.dropDownColor = Colors.white,
    this.icon,
    this.isShadow = false,
    this.styleheading,
    this.dropdownType = false,
    Key? key,
  }) : super(key: key);

  @override
  State<DropDownTextWidget> createState() => _DropDownTextWidgetState();
}

class _DropDownTextWidgetState extends State<DropDownTextWidget> {
  final GlobalKey _buttonKey = GlobalKey();
  Offset dropdownOffset = const Offset(0, 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculateOffset());
  }

  void _calculateOffset() {
    final renderBox = _buttonKey.currentContext?.findRenderObject();
    if (renderBox is RenderBox) {
      final Offset offset = renderBox.localToGlobal(Offset.zero);
      final double spaceBelow = MediaQuery.of(context).size.height - offset.dy - renderBox.size.height;

      setState(() {
        dropdownOffset = spaceBelow < 250 ? const Offset(0, -250) : const Offset(0, 0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (widget.tvHeading != null)
        TextView(
          text: widget.tvHeading,
          textStyle: widget.labelTextStyle ??
              textStyleTitleSmall()!.copyWith(
                  fontWeight: FontWeight.w400, color: Colors.black),
        ).marginSymmetric(vertical: 10),

      DropdownButtonHideUnderline(
        child: DropdownButton2<dynamic>(
          key: _buttonKey,
          focusNode: widget.focusNode,
          items: widget.items
              ?.map((item) => DropdownMenuItem(
            value: item,
            child: TextView(
              text: item,
              textStyle: textStyleTitleMedium()!.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color.fromRGBO(130, 130, 130, 1),
                fontSize: font_12,
              ),
            ),
          ))
              .toList(),
          onChanged: widget.onFieldSubmitted,
          style: textStyleTitleMedium()!.copyWith(
            fontWeight: FontWeight.w400,
            color: Colors.grey,
            fontSize: font_13,
          ),
          value: widget.selectedValue != '' ? widget.selectedValue : null,
          isExpanded: true,
          isDense: false,
          hint: TextView(
            text: widget.hint ?? "",
            textStyle: textStyleBodySmall()!.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: font_14,
            ),
          ),
          iconStyleData: IconStyleData(
            icon: widget.icon ??
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: const Color.fromRGBO(130, 130, 130, 1),
                  size: height_20,
                ),
          ),
          buttonStyleData: ButtonStyleData(
            width: Get.width,
            height: 48,
            padding: const EdgeInsets.only(left: 14, right: 14),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color.fromRGBO(204, 204, 204, 1), width: 1),
              ),
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: Get.height * .4,
            offset: dropdownOffset,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(radius_20),
              border: Border.all(color: const Color.fromRGBO(230, 230, 230, 1), width: margin_1),
            ),
            elevation: elevation_2.toInt(),
          ),
        ),
      ),
    ]);
  }
}
