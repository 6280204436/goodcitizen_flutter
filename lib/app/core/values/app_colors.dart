
import '../../export.dart';

Color getAppColor() {
  if (SchedulerBinding.instance.platformDispatcher.platformBrightness ==
      Brightness.dark) {
    return Color(0xFFF4D558);
  } else {
    return Color(0xFFFFFFFF);
  }
}

Color getYellowColor2() {
  if (SchedulerBinding.instance.platformDispatcher.platformBrightness ==
      Brightness.dark) {
    return Color(0xFFE6BF0A);
  } else {
    return Color(0xFFF2E9B1);
  }
}

Color getLineColor() {
  if (SchedulerBinding.instance.platformDispatcher.platformBrightness ==
      Brightness.dark) {
    return Color(0x33633C3C);
  } else {
    return Color(0xFFFFFFFF);
  }
}

Color getTextColor() {
  if (SchedulerBinding.instance.platformDispatcher.platformBrightness ==
      Brightness.dark) {
    return Color(0xFF48281B);
  } else {
    return Color(0xFF000000);
  }
}

Color getSecTextColor() {
  if (SchedulerBinding.instance.platformDispatcher.platformBrightness ==
      Brightness.dark) {
    return Color(0xFF674D42);
  } else {
    return Color(0xFF111111);
  }
}

Color getGreenColor() {
  if (SchedulerBinding.instance.platformDispatcher.platformBrightness ==
      Brightness.dark) {
    return Color(0xFF25772B);
  } else {
    return Color(0xFF25772B);
  }
}

Color darkAppColor = const Color(0xFFF4D558);

Color lightYellowAppColor = const Color(0xFFF4D558);
Color darkYellowColor = const Color(0xFFE6BF0A);
Color whiteAppColor = const Color(0xFFFFFFFF);
Color darkRedColor = const Color(0xFFA2353E);
Color darkGreyColor = const Color(0xFF666668);
Color imageGreyColor = const Color(0xFF828282);
Color greyColor = const Color(0xFFA7A7AB);
Color greyColorLight = const Color(0xFFE6E6E6);
Color greyColorExtraLight = const Color(0xFFFAFAFA);
Color navBarGreyColor = const Color(0xEEEEEEEE);
Color buttonGreyColor = const Color(0xEED8D8D8);
Color textDarkGreyColor = const Color(0xEE343A40);
Color transparentBgColor = const Color(0xCC000000);



Color yellowColor2 = const Color(0xFFF2E9B1);
Color blackColor = const Color(0xFF000000);
Color shadowColor = const Color(0x10000000);
Color whiteColor = const Color(0xFFFFFFFF);
Color brownColor = const Color(0xFF633C3C);
Color lightBrownColor = const Color(0xFF674C4C);
Color reddishColor = const Color(0xFF93402B);
Color textBlueColor = const Color(0xFF3BB5EA);
Color textMediumBlueColor = const Color(0xFF203A43);
Color textLightBlueColor = const Color(0xFF0F2027);
Color textRedColor = const Color(0xFFFF6066);
Color deleteRedColor = const Color(0xFFFF4C4C);
Color redColor = const Color(0xFFFF2020);
Color spinWheelOrangeColor = const Color(0xFFE1873E);
Color textRedLightColor = const Color(0xFFF04249);
Color darkBrownColor = const Color(0xFF48281B);
Color greenColor1 = const Color(0xFF25772B);
Color greenColor2 = const Color(0xFF27A163);
Color onlyWhiteColor = const Color(0xFFFFFFFF);
Color onlyBlackColor = const Color(0xFF000000);
Color textFieldHintColor = const Color(0xFFB4A7A2);
Color errorColor = const Color(0xFFFF3333);
Color liveScreenBlackColor = const Color(0xFF252525);
Color liveScreenRedColor = const Color(0xFFFF4C4C);
Color spinWheelBgColor = const Color(0xFFD9D9D9);


//booking states colors
Color textOrangeColor = const Color(0xFFFDA50F);
Color buttonRedColor = const Color(0xFFFF0000);
Color chatGreenColor = const Color(0xFF00D563);


//donate product



Color donateProductLightColor = const Color(0xFF91F3CD);
Color donateProductDarkColor = const Color(0xFF53E2AA);

//track order colors
Color colorSelfPickup = const Color(0xFF2979C2);
Color colorPicked = const Color(0xFFC03FD4);
Color colorDeliverd = const Color(0xFF5AC229);
Color colorDispatched = const Color(0xFF3FCCD4);
Color colorShipped = const Color(0xFFE4BE5A);

//claim prize
Color lightPinkColor = const Color(0xFFFD5C8E);
Color darkPinkColor = const Color(0xFFF7447C);
Color lightBlueColor = const Color(0xFF7575FF);
Color darkBlueColor = const Color(0xFF5858FE);

//games colors

Color playStoriesOrangeColor = const Color(0xFFFFAB6B);
Color playStoriesOrangeColorDark = const Color(0xFFF3954D);
Color playQuizPinkColor = const Color(0xFFF16578);
Color liveDebateDarkBlueColor = const Color(0xFF4D4DA3);
Color liveDebateLightBlueColor = const Color(0xFF6060B0);
Color spinWheelGreenColor = const Color(0xFF518F8D);
Color postVideoDarkYellowColor = const Color(0xFFF2C338);
Color postVideoLightYellowColor = const Color(0xFFFAD465);
Color voteGamePinkColor = const Color(0xFFE7A39E);
Color kindnessGameGreenColor = const Color(0xFF86B24F);
Color kindnessGameLightGreenColor = const Color(0xFF9FC570);
Color guessGameBlueColor = const Color(0xFF86CCF1);

Color onrideBookingColor = const Color(0xFF00B9FF);
Color completedGameBlueColor = const Color(0xFF3FCCD4);
Color deliveredGameColor = const Color(0xFFE4BE5A);
Color acceptedGameColor = const Color(0xFF5A71E4);



abstract class AppColors {
  static const Color appColor = const  Color.fromRGBO(221, 78, 75, 1);
  static const Color appSecondaryColor = const Color(0xFFFFFFFF);

  static const Color appDarkColor = Color.fromRGBO(56, 138, 61, 1.0);
  static const Color appColorDark = const Color(0xFF08B24F);
  static const Color appColorDark2 = const Color(0xFFFDCE15);
  static const Color appColorLight = const Color(0xFF2F5C09);
  static const Color greyColorExtraLight = const Color(0xFFE5E5E5);
  static const Color appGreyColor = const Color(0xFFF6F6F6);
  static const Color appGreyColorDark = const Color(0xFFE6E6E6);
  static const Color appBlackColor = const Color(0xFF100A0A);
  static const Color textLightGreyColor = const Color(0xFF999999);
  static const Color darkGreyColor = const Color(0xFF999999);
  static const Color chatBlueColor = const Color(0xFFF1FDFF);
  static const Color whiteLight = Color.fromRGBO(255, 255, 255, .15);



  static const Color onlyWhiteColor = const Color(0xFFFFFFFF);
  static const Color blackColor = const Color(0xFF000000);
  static const Color whiteAppColor = const Color(0xFFFFFFFF);
  static const Color brownColor = const Color(0xFF633C3C);
  static const Color textGreyColor = const Color(0xFF999999);
  static const Color textGreyColorDark = const Color(0xFF5B5B5B);
  static const Color ratingGlowColor = const Color(0xFFF7AE34);
  static const Color hintTextGreyColor = const Color(0xFF8F8F8F);
  static const Color transparentBgColor = const Color(0xCC000000);
  static const Color appRedColor = const Color(0xFFEF4444);

  static const Color appLightDarkColor = Color.fromRGBO(18, 18, 18, 1);
  static const Color appBorderDarkColor = Color.fromRGBO(58, 58, 58, 1);
  static const Color appBlueColor = Color.fromRGBO(26, 167, 222, 1);
  static const Color appGreenColor = const Color(0xFF22C55E);
  static const Color appYellowColor = Color.fromRGBO(236, 194, 99, 0.3);
  static const Color toastColor = Color.fromRGBO(236, 244, 239, 1.0);

  // static const Color darkGreyColor = Color.fromRGBO(70, 70, 70, 1.0);
  static const Color screenHeadingColor = Color.fromRGBO(61, 61, 61, 1.0);
  static const Color greyColor = Color.fromRGBO(96, 91, 91, 1.0);
  static const Color redColor = const Color(0xFFFF2020);
  static const Color redColorLight = Color(0xFFFF2020);
  static const Color grayColor = Color.fromRGBO(225, 225, 225, 1);
  static const Color grayTextColor = Color.fromRGBO(124, 124, 124, 1);
  static const Color appbarTitleTextColor = Color.fromRGBO(255, 255, 255, 1);
  static const Color availabilityContainerColor =
  Color.fromRGBO(230, 247, 237, 1);
  static const Color availabilityNotContainerColor =
  Color.fromRGBO(252, 230, 229, 1);
  static const Color lightRedColor = Color.fromRGBO(244, 67, 54, 1);
  static const Color availabilityTextColor = Color.fromRGBO(8, 178, 79, 1);
  static const Color textColorBlack = Color.fromRGBO(18, 18, 18, 1);
  static const Color textColorGrey = Color.fromRGBO(18, 18, 18, 1);
  static const Color listBorderColor = Color.fromRGBO(229, 229, 229, 1);
  static const Color subTextColor = Color.fromRGBO(143, 143, 143, 1);
  static const Color dividerColor = Color.fromRGBO(234, 234, 234, 1);
  static const Color pickDropContainerColor = Color.fromRGBO(250, 250, 250, 1);
  static const Color paymentListContainerColor = Color.fromRGBO(51, 51, 51, 1);
  static const Color hintTextColor = Color.fromRGBO(124, 124, 124, 1);
  static const Color cancelContainerBorderColor =
  Color.fromRGBO(225, 225, 225, 1);
  static const Color balanceTransactionHistoryColor =
  Color.fromRGBO(250, 250, 250, 1);
  static const Color tebBarTextColor = Color.fromRGBO(130, 130, 130, 1);
  static const Color greyColorLight = const Color(0xFFE6E6E6);
  static Color greyColor2 = const Color(0xFFA7A7AB);

  static List<Color> appGreenGradientColor = [
    Color(0xff08B24F),
    Color(0xFF2F5C09),
  ];
}




List<Color> redGradient = [
  const Color(0xFFE82D00),
  const Color(0xFFB52B02),
];

List<Color> darkRedGradient = [
  const Color(0xFFA2353E),
  const Color(0xFF74282C),
];

List<Color> greyGradient = [
  const Color(0xFF666668),
  const Color(0xFF3E3E40),
];

List<Color> blueGradient = [
  const Color(0xFF3AA1DB),
  const Color(0xFF1374B9),
];
