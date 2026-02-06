import '../../../export.dart';

class AuthenticationAppBar extends StatelessWidget {
  final dynamic onTap;
  final String? iconPath;

  const AuthenticationAppBar({
    Key? key,
    this.onTap,
    this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: onTap ??
              () {
                Get.back(result: true);
              },
          child:  AssetSVGWidget(
           iconPath?? icCross,
            imageHeight: height_22,
            imageWidth: height_22,
          ).paddingSymmetric(vertical: margin_10),
        ));
  }
}
