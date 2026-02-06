import 'package:good_citizen/app/export.dart';

class AssetSVGWidget extends StatelessWidget {
  final String imageUrl;
  final String? placeHolder;
  final double? radiusAll;
  final double radiusTopRight;
  final double radiusTopLeft;
  final double radiusBottomRight;
  final double radiusBottomLeft;
  final double? imageHeight;
  final double? imageWidth;
  final BoxFit imageFitType;
  final Color? color;

  const AssetSVGWidget(this.imageUrl,
      {Key? key,
      this.radiusAll,
      this.placeHolder,
      this.radiusTopLeft = 0.0,
      this.radiusBottomRight = 0.0,
      this.radiusBottomLeft = 0.0,
      this.radiusTopRight = 0.0,
      this.imageHeight,
      this.imageWidth,
      this.color,
      this.imageFitType = BoxFit.contain})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorFilter? colorFilter;

    if (color != null) {
      colorFilter = ColorFilter.mode(color!, BlendMode.srcIn);
    }

    return ClipRRect(
      borderRadius: radiusAll == null
          ? BorderRadius.only(
              topRight: Radius.circular(radiusTopRight),
              topLeft: Radius.circular(radiusTopLeft),
              bottomLeft: Radius.circular(radiusBottomLeft),
              bottomRight: Radius.circular(radiusBottomRight))
          : BorderRadius.circular(radiusAll!),
      child: SvgPicture.asset(
        imageUrl,
        colorFilter: colorFilter,
        height: imageHeight,
        width: imageWidth,
        fit: imageFitType,
        placeholderBuilder: (context) {
          return SvgPicture.asset(
            placeHolder??samplePlaceholder,
            colorFilter: colorFilter,
            height: imageHeight,
            width: imageWidth,
            fit: imageFitType,
          );
        },
      ),
    );
  }
}
