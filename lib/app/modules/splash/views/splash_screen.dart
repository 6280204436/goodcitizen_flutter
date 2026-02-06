/*
 * @copyright : Henceforth Pvt. Ltd. <info@henceforthsolutions.com>
 * @author     : Gaurav Negi
 * All Rights Reserved.
 * Proprietary and confidential :  All information contained herein is, and remains
 * the property of Henceforth Pvt. Ltd. and its partners.
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 *
 */

import '../../../export.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
        init: SplashController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SizedBox(width: Get.width,
              child: Stack(

                children: [
                  AssetImageWidget(
                    iconSplashBackground,
                    imageHeight: Get.height,
                    imageWidth: Get.width,
                    imageFitType: BoxFit.cover,

                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextView(
                          text: "Good citizen".toUpperCase(),
                          maxLines: 1,
                          textStyle: textStyleDisplayMedium()!.copyWith(color:AppColors.whiteAppColor,fontSize:40,fontWeight:FontWeight.w900 ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),


          );
        }
    );
  }
}
