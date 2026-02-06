import 'package:good_citizen/app/core/widgets/text_view_widget.dart';

import '../../export.dart';

// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String? titleText;
//   final Widget? actions;
//   final Widget? primaryWidget;
//   final Widget? titleWidget;
//   final Color? bgColor;
//   final Color? backIconColor;
//   final double? titleTextMarginRight;
//   final bool hideBackIcon;
//   final MainAxisAlignment? rowAlignment;
//
//   final VoidCallback? onTap;
//
//   const CustomAppBar({
//     Key? key,
//     this.titleText,
//     this.onTap,
//     this.actions,
//     this.titleTextMarginRight,
//     this.hideBackIcon = false,
//     this.primaryWidget,
//     this.titleWidget,
//     this.rowAlignment,
//     this.backIconColor,
//     this.bgColor,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return _customAppBar2();
//   }
//
//   _customAppBar() {
//     return Container(
//       alignment: Alignment.center,
//       constraints: BoxConstraints(maxHeight: height_125, minHeight: height_110),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             appColorLight,
//             appColor,
//           ],
//         ),
//       ),
//       child: SafeArea(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: rowAlignment ?? MainAxisAlignment.spaceBetween,
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             primaryWidget != null
//                 ? Expanded(flex: 3, child: primaryWidget!)
//                 : hideBackIcon
//                     ? const SizedBox()
//                     : InkWell(
//                         onTap: () {
//                           Get.back(result: true);
//                         },
//                         child: AssetImageWidget(
//                           iconsIcBackPng,
//                           imageHeight: height_25,
//                           imageWidth: height_25,
//                         ).paddingOnly(right: margin_5, bottom: margin_0)),
//             Expanded(
//                 child: titleWidget != null
//                     ? titleWidget!
//                     : (titleText != "" || titleText != null)
//                         ? Text(
//                             titleText ?? "",
//                             textAlign: TextAlign.center,
//                             style: textStyleHeadlineMedium()
//                                 .copyWith(fontWeight: FontWeight.w600),
//                           ).paddingOnly(
//                             bottom: margin_1,
//                             right: titleTextMarginRight ??
//                                 (hideBackIcon
//                                     ? margin_20
//                                     : actions != null
//                                         ? margin_20
//                                         : margin_45))
//                         : const SizedBox()),
//             actions ?? const SizedBox()
//           ],
//         ).paddingOnly(bottom: margin_6, top: margin_18, left: margin_20),
//       ),
//     );
//   }
//
//   _customAppBar2() {
//     return AppBar(
//       flexibleSpace: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             // begin: Alignment.topCenter,
//             // end: Alignment.bottomCenter,
//             colors: [
//               appColorLight,
//               appColor,
//             ],
//           ),
//         ),
//       ),
//       leading: primaryWidget != null
//           ? primaryWidget!
//           : hideBackIcon
//               ? const SizedBox()
//               : InkWell(
//                   onTap: () {
//                     Get.back(result: true);
//                   },
//                   child: AssetImageWidget(
//                     iconsIcBackPng,
//                     imageHeight: height_25,
//                     imageWidth: height_25,
//                   ).paddingOnly(right: margin_5, bottom: margin_0)),
//       title: titleWidget != null
//           ? titleWidget!
//           : (titleText != "" || titleText != null)
//               ? Text(
//                   titleText ?? "",
//                   textAlign: TextAlign.center,
//                   style: textStyleHeadlineMedium()
//                       .copyWith(fontWeight: FontWeight.w600),
//                 ).paddingOnly(
//                   bottom: margin_1,
//                   right: titleTextMarginRight ??
//                       (hideBackIcon
//                           ? margin_20
//                           : actions != null
//                               ? margin_20
//                               : margin_45))
//               : const SizedBox(),
//       actions: [actions ?? SizedBox()],
//     );
//   }
//
//   @override
//   Size get preferredSize => Size.fromHeight(height_85);
// }

AppBar customAppBar(
    {String? titleText,
    Widget? actions,
    Widget? primaryWidget,
    Widget? titleWidget,
    Widget? centerBottomWidget,
    Color? bgColor,
    Color?textColor,
    Color? backIconColor,
    double? titleTextMarginRight,
    double? appBarHeight,
    double? elevation,
    bool hideBackIcon = false,
    bool centerTitle = true,
    PreferredSizeWidget? tabBar,
    VoidCallback? onBackTap}) {
  return AppBar(surfaceTintColor: Colors.transparent,
    centerTitle: centerTitle,
    toolbarHeight: appBarHeight ?? (height_55),
    titleSpacing: 0,
    bottom: tabBar,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light ,
      statusBarBrightness: Brightness.dark,
    ),
    backgroundColor:bgColor??Colors.white,
    elevation: elevation??0,
    // flexibleSpace: Container(
    //   decoration: BoxDecoration(
    //     color: whiteAppColor,
    //     // gradient: LinearGradient(
    //     //   begin: Alignment.topLeft,
    //     //   end: Alignment.bottomRight,
    //     //   colors: [
    //     //     appColorLight,
    //     //     appColor,
    //     //   ],
    //     // ),
    //   ),
    // ),
    leadingWidth: hideBackIcon ? 0 : null,
    leading: (primaryWidget ??
        (hideBackIcon
            ? const SizedBox()
            : InkWell(
                onTap: onBackTap ??
                    () {
                      Get.back(result: true);
                    },
                child: Icon(Icons.arrow_back,color: Colors.white,)))),
    title: Column(
      children: [
        (titleWidget ??
            ((titleText != "" || titleText != null)
                ? TextView(
                    text:titleText?.tr ?? "",
                    textAlign: TextAlign.start,
                    textStyle: textStyleHeadlineMedium()
                        !.copyWith(fontWeight: FontWeight.w500,color:textColor??Colors.white),
                  )
                : const SizedBox())),
        centerBottomWidget ?? const SizedBox()
      ],
    ),
    actions: [(actions ?? const SizedBox()).paddingOnly(right: margin_14)],
  );
}
