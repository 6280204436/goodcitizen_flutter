import 'package:cached_network_image/cached_network_image.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../remote_config.dart';
import '../../export.dart';

enum FileSizeEnum { small, medium, original }

class NetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? radiusAll;
  final FileSizeEnum fileSizeEnum;
  final double radiusTopRight;
  final double radiusTopLeft;
  final double radiusBottomRight;
  final double radiusBottomLeft;
  final double? imageHeight;
  final double? imageWidth;
  final BoxFit imageFitType;
  final bool includeBaseUrl;
  final bool isLoading;
  final color;
  final placeHolder;

  const NetworkImageWidget(
      {Key? key,
        required this.imageUrl,
        this.radiusAll,
        this.radiusTopLeft = 0.0,
        this.radiusBottomRight = 0.0,
        this.radiusBottomLeft = 0.0,
        this.radiusTopRight = 0.0,
        this.fileSizeEnum = FileSizeEnum.original,
        this.imageHeight,
        this.imageWidth,
        this.color,
        this.placeHolder,
        this.includeBaseUrl = true,
        this.isLoading = false,
        this.imageFitType = BoxFit.cover})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radiusAll == null
          ? BorderRadius.only(
          topRight: Radius.circular(radiusTopRight),
          topLeft: Radius.circular(radiusTopLeft),
          bottomLeft: Radius.circular(radiusBottomLeft),
          bottomRight: Radius.circular(radiusBottomRight))
          : BorderRadius.circular(radiusAll!),
      child: isLoading
          ? Bone.text(
        fontSize: imageHeight,
        width: imageWidth,
        borderRadius: radiusAll == null
            ? BorderRadius.only(
            topRight: Radius.circular(radiusTopRight),
            topLeft: Radius.circular(radiusTopLeft),
            bottomLeft: Radius.circular(radiusBottomLeft),
            bottomRight: Radius.circular(radiusBottomRight))
            : BorderRadius.circular(radiusAll!),
      )
          : CachedNetworkImage(
        height: imageHeight,
        width: imageWidth,
        imageUrl: _includeBase
            ? '$mediaBaseUrl$imageUrl'
            : imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: imageFitType,
              // colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)
            ),
          ),
        ),
        placeholder: (context, url) => AssetSVGWidget(
          placeHolder ?? samplePlaceholder,
          radiusAll: radiusAll,
          imageHeight: imageHeight,
          imageWidth: imageWidth,
          imageFitType: BoxFit.fill,
        ),
        errorWidget: (context, url, error) => AssetSVGWidget(
          placeHolder ?? samplePlaceholder,
          radiusAll: radiusAll,
          imageHeight: imageHeight,
          imageWidth: imageWidth,
          imageFitType: BoxFit.fill,
        ),
      ),
    );
  }


  bool get _includeBase{
    return !(imageUrl.contains('googleusercontent.com'));
  }
}


