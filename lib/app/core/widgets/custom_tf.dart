import 'package:good_citizen/app/export.dart';

class CustomTF extends StatefulWidget {

  final TextEditingController controller;
  final String? hintText;
  final String? imageLink;
  final TextInputType? inputType;
  final Padding? contentPadding;
  final bool isLastKeyboard;
  final bool isPassword;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;

  const CustomTF({
    Key? key,
    required this.controller,
    required this.hintText,
    this.imageLink,
    this.contentPadding,
    this.inputType = TextInputType.name,
    this.isLastKeyboard = true,
    this.isPassword = false,
    this.inputFormatters,
    this.prefix,
  }) : super(key: key);

  @override
  State<CustomTF> createState() => _CustomTFState();
}

class _CustomTFState extends State<CustomTF>{

  bool showText = true;

  @override
  void initState() {
    print("k1");
    if (widget.isPassword){
      print("k2");
      showText = false;
    }else{
      print("k3");
      showText = true;
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius_12,),
        image: DecorationImage(
          image: AssetImage(
            imagesIcInputFieldLarge,
          ),
          fit: BoxFit.fill,
        ),

      ),
      child: TextFormField(
        obscureText: !showText,
        controller: widget.controller,
        keyboardType: widget.inputType,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: widget.isLastKeyboard ? TextInputAction.done : TextInputAction.next,
        inputFormatters: widget.inputFormatters,
        decoration: InputDecoration(
          // fillColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(vertical: margin_16,horizontal: (widget.imageLink == null&&widget.isPassword==false)?margin_10:margin_0),
          isDense: true,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: font_14,
            fontWeight: FontWeight.w400,
            color: textFieldHintColor,
          ),
          prefixIcon: widget.imageLink == null
              ? widget.prefix
              : AssetSVGWidget(
            widget.imageLink ?? "",
            imageFitType: BoxFit.scaleDown,
          ).paddingSymmetric(vertical: margin_15),
          suffixIcon: widget.isPassword ? IconButton(
            icon: AssetSVGWidget(showText ? iconsIcEyeOn : iconsIcEyeOff,imageHeight: height_50,imageWidth: height_50,
              imageFitType: BoxFit.scaleDown,
            ).paddingSymmetric(vertical: margin_5),
            onPressed: () {
              setState(() {
                showText = !showText;
                },
              );
            },
          ) : null,
        ),
      ),
    );
  }
}

class CustomTF2 extends StatefulWidget {

  final TextEditingController controller;
  final FocusNode? focasNode;
  final dynamic onChanged;
  final dynamic onTap;

  const CustomTF2({
    Key? key,
    required this.controller,
    required this.focasNode,
    this.onChanged,
    this.onTap,
  }) : super(key: key);

  @override
  State<CustomTF2> createState() => _CustomTF2State();
}

class _CustomTF2State extends State<CustomTF2>{

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: height_52,
      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(radius_12,),
        image: DecorationImage(
          image: AssetImage(
            imagesIcInputFieldCode,

          ),
          fit: BoxFit.fill,
        ),
        boxShadow: [
          BoxShadow(
            color: onlyBlackColor.withOpacity(0.36,),
            offset: Offset(0,2),
            spreadRadius: 0,
            blurRadius: 4,
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focasNode,
        keyboardType: TextInputType.number,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
        ],
        onTap: widget.onTap,
        onChanged: widget.onChanged,
        style: TextStyle(
          fontSize: font_24,
          fontWeight: FontWeight.w500,
          color: getTextColor(),
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: margin_15),

          // fillColor: Colors.transparent,
          isDense: true,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          errorBorder: InputBorder.none,
        ),
      ),
    );
  }
}
