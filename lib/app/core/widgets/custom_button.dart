import 'package:good_citizen/app/export.dart';
import 'boune_widget.dart';

class CustomMaterialButton extends StatefulWidget {
  final VoidCallback? onTap;
  final String? buttonText;
  final TextStyle? textStyle;
  final String? suffixIcon;
  final Widget? suffixWidget;
  final String? prefixIcon;
  final Widget? prefixWidget;
  final double? borderRadius;
  final double? buttonHeight;
  final double? buttonWidth;
  final double? borderWidth;
  final bool disableWidth;
  final Color? sufixIconColor;
  final bool isLoading;
  final bool isOutlined;
  final bool enabled;
  final bool expandText;
  final Color? bgColor;
  final Color? loaderColor;
  final Color? prefixColor;
  final Color? borderColor;
  final Color? textColor;
  final double? textPadding;

  const CustomMaterialButton({
    Key? key,
    required this.onTap,
    required this.buttonText,
    this.textStyle,
    this.loaderColor,
    this.suffixIcon,
    this.suffixWidget,
    this.prefixIcon,
    this.textPadding,
    this.prefixWidget,
    this.borderRadius,
    this.sufixIconColor,
    this.isLoading = false,
    this.isOutlined = false,
    this.enabled = true,
    this.disableWidth = false,
    this.expandText = false,
    this.buttonHeight,
    this.buttonWidth,
    this.borderWidth,
    this.prefixColor,
    this.textColor,
    this.bgColor,
    this.borderColor,
  }) : super(key: key);

  @override
  State<CustomMaterialButton> createState() => _CustomMaterialButtonState();
}

class _CustomMaterialButtonState extends State<CustomMaterialButton>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Bouncing(
      enabled: widget.enabled && !widget.isLoading && widget.onTap != null,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.isLoading ? null : widget.enabled ? widget.onTap : null,
        child: IntrinsicWidth(
          child: Container(
            height: widget.buttonHeight ?? height_42,
            width: widget.disableWidth ? null : widget.buttonWidth ?? Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? (radius_4 + margin_0point3)),
              border: widget.isOutlined
                  ? Border.all(
                width: widget.borderWidth ?? margin_2,
                color: widget.enabled
                    ? (widget.borderColor ?? AppColors.appColor)
                    : (widget.borderColor ?? Colors.black).withOpacity(0.6),
              )
                  : null,
              color: widget.bgColor ??
                  (widget.isOutlined ? Colors.white : AppColors.appColor),
            ),
            child: widget.isLoading
                ? Center(
              child: Platform.isIOS
                  ? CupertinoActivityIndicator(
                color: widget.loaderColor ??
                    (widget.isOutlined
                        ? widget.borderColor ?? AppColors.appColor
                        : Colors.white),
                radius: margin_9,
              )
                  : SizedBox(
                height: margin_16,
                width: margin_16,
                child: CircularProgressIndicator(
                  color: widget.loaderColor ??
                      (widget.isOutlined
                          ? widget.borderColor ?? AppColors.appColor
                          : Colors.white),
                  strokeWidth: margin_2,
                ),
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.prefixWidget ??
                    ((widget.prefixIcon != null &&
                        widget.prefixIcon != '')
                        ? AssetSVGWidget(
                      widget.prefixIcon ?? "",
                      imageHeight: height_16,
                      color: widget.prefixColor,
                      imageWidth: height_16,
                    ).paddingOnly(left: margin_7, right: margin_7)
                        : const SizedBox()),
                widget.expandText
                    ? Expanded(child: _buttonText())
                    : Flexible(child: _buttonText()),
                widget.suffixWidget ??
                    ((widget.suffixIcon != null &&
                        widget.suffixIcon != '')
                        ? AssetSVGWidget(
                      widget.suffixIcon ?? "",
                      imageFitType: BoxFit.scaleDown,
                      imageHeight: height_20,
                      color: widget.sufixIconColor,
                      imageWidth: height_20,
                    ).paddingOnly(left: margin_7)
                        : const SizedBox()),
              ],
            ).paddingSymmetric(horizontal: margin_7),
          ),
        ),
      ),
    );
  }

  FittedBox _buttonText() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: TextView(
        text: widget.buttonText ?? "",
        textStyle: widget.textStyle ??
            textStyleTitleMedium()!.copyWith(
              color: widget.isOutlined
                  ? (widget.textColor ?? widget.borderColor ?? AppColors.appColor)
                  : (widget.textColor ?? Colors.white),
              fontWeight: FontWeight.w600,
            ),
      )
          .paddingOnly(
        right: widget.prefixWidget != null ||
            (widget.prefixIcon != null && widget.prefixIcon != '')
            ? margin_20
            : 0,
      )
          .paddingSymmetric(horizontal: widget.textPadding ?? 0),
    );
  }
}