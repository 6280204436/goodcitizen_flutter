import 'package:good_citizen/app/core/values/theme_controller.dart';
import 'package:good_citizen/app/export.dart';
import 'package:flutter/scheduler.dart';

/*class ThemeConfig {
  static ThemeData createTheme({
    required Brightness brightness,
    required Color background,
    required Color primaryText,
    Color? secondaryText,
    required Color accentColor,
    Color? divider,
    Color? buttonBackground,
    required Color buttonText,
    Color? cardBackground,
    Color? disabled,
    required Color error,
  }) {
    return ThemeData(
      brightness: brightness,
      canvasColor: background,
      primaryColorDark: Colors.white,
      primarySwatch: Colors.red,
      cardColor: background,
      dividerColor: divider,

      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      }),

      dividerTheme: DividerThemeData(
        color: divider,
        space: 1,
        thickness: 1,
      ),
      cardTheme: CardTheme(
        color: cardBackground,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
      ),

      primaryColor: accentColor,
      colorScheme: ColorScheme.fromSwatch(
        backgroundColor: background,
        errorColor: error,
        accentColor: accentColor,
        brightness: brightness,
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: accentColor,
        selectionHandleColor: accentColor,
        cursorColor: accentColor,
      ),
      appBarTheme: AppBarTheme(
        systemOverlayStyle:
        SystemUiOverlayStyle(statusBarBrightness: brightness,systemNavigationBarColor: Colors.black),
        color: Colors.black,
        toolbarTextStyle: TextStyle(
          color: secondaryText,
          fontSize: 18.0.sp,
        ),
        iconTheme: IconThemeData(color: Colors.black, size: height_25),
      ),
      iconTheme: IconThemeData(
        color: Colors.black,
        size: height_25,
      ),
      indicatorColor: AppColors.appColor,
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        colorScheme: ColorScheme(
          brightness: brightness,
          primary: Colors.purple,
          primaryContainer: accentColor,
          secondary: accentColor,
          secondaryContainer: accentColor,
          surface: background,
          background: background,
          error: error,
          onPrimary: buttonText,
          onSecondary: buttonText,
          onSurface: buttonText,
          onBackground: buttonText,
          onError: buttonText,
        ),
        padding: const EdgeInsets.all(16.0),
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: brightness,
        primaryColor: accentColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.5),
        ),
        focusedBorder:const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.5),
        ),
        errorStyle: TextStyle(color: error),
        labelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 16.0,
          color: primaryText.withOpacity(0.5),
          decorationColor: AppColors.textGreyColor

        ),
      ),
      datePickerTheme: DatePickerThemeData(headerHelpStyle: TextStyle(
        color: primaryText,
        fontSize: font_18,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,

      ) ),
      fontFamily: 'Poppins',
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: primaryText,
          fontSize: font_22,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w700,
            decorationColor: AppColors.textGreyColor
        ),

        displayMedium: TextStyle(
          color: primaryText,
          fontSize: font_20,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w700,
            decorationColor: AppColors.textGreyColor
        ),
        displaySmall: TextStyle(
          color: primaryText,
          fontSize: font_18,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w700,
            decorationColor: AppColors.textGreyColor
        ),
        headlineLarge: TextStyle(
          color: primaryText,
          fontSize: font_20,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w500,
            decorationColor: AppColors.textGreyColor
        ),
        headlineMedium: TextStyle(
          color: primaryText,
          fontSize: font_18,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w500,
            decorationColor: AppColors.textGreyColor
        ),
        headlineSmall: TextStyle(
          color: primaryText,
          fontSize: font_17,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w500,
            decorationColor: AppColors.textGreyColor
        ),
        labelLarge: TextStyle(
          color: primaryText,
          fontSize: font_15,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w600,
            decorationColor: AppColors.textGreyColor
        ),
        labelMedium: TextStyle(
          color: primaryText,
          fontSize: font_14,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w600,
            decorationColor: AppColors.textGreyColor
        ),
        labelSmall: TextStyle(
          color: primaryText,
          fontSize: font_13,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w600,
            decorationColor: AppColors.textGreyColor
        ),
        bodyLarge: TextStyle(
          color: primaryText,
          fontSize: font_13,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w400,
            decorationColor: AppColors.textGreyColor
        ),
        bodyMedium: TextStyle(
          color: primaryText,
          fontSize: font_12,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w400,
            decorationColor: AppColors.textGreyColor
        ),
        bodySmall: TextStyle(
          color: primaryText,
          fontSize: font_11,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w400,
            decorationColor: AppColors.textGreyColor
        ),
        titleLarge: TextStyle(
          color: primaryText,
          fontSize: font_16,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w500,
            decorationColor: AppColors.textGreyColor
        ),
        titleMedium: TextStyle(
          color: primaryText,
          fontSize: font_15,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w500,
            decorationColor: AppColors.textGreyColor
        ),
        titleSmall: TextStyle(
          color: primaryText,
          fontSize: font_14,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w400,
            decorationColor: AppColors.textGreyColor
        ),
      ).apply(
        bodyColor: primaryText,
        displayColor: primaryText,
        decorationColor:    AppColors.appColor
      ),
    );
  }

  static ThemeData get lightTheme => createTheme(
    brightness: Brightness.light,
    background: whiteAppColor,
    cardBackground: Colors.white,
    primaryText: Colors.black,
    secondaryText: Colors.white,
    accentColor: Colors.black,
    divider: Colors.black,
    buttonBackground: Colors.black38,
    buttonText: Colors.white,
    disabled: Colors.black,
    error: Colors.red,
  );

  static ThemeData get systemTheme {
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return createTheme(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      background: isDarkMode ? Colors.black : Colors.white,
      cardBackground: isDarkMode ? Colors.black : Colors.white,
      primaryText: isDarkMode ? Colors.white : Colors.black,
      secondaryText: isDarkMode ? Colors.white54 : Colors.black45,
      accentColor: isDarkMode ? Colors.white : Colors.black,
      divider: isDarkMode ? Colors.white : Colors.black,
      buttonBackground: isDarkMode ? Colors.white38 : Colors.black38,
      buttonText: isDarkMode ? Colors.black : Colors.white,
      disabled: isDarkMode ? Colors.white : Colors.black,
      error: Colors.red,

    );
  }

  static ThemeData get darkTheme => createTheme(
    brightness: Brightness.dark,
    background: whiteAppColor,
    cardBackground: Colors.black,
    primaryText: brownColor,
    secondaryText: Colors.black,
    accentColor: Colors.black,
    divider: Colors.black45,
    buttonBackground: Colors.white,
    buttonText: Colors.white,
    disabled: Colors.black,
    error: Colors.red,
  );
}*/



class ThemeConfig {
  ThemeController themeController = Get.put(ThemeController());
  PreferenceManager localStorageController = Get.put(PreferenceManager());

  ThemeData createTheme({
    required Brightness brightness,
    required Color background,
    required Color primaryText,
    Color? secondaryText,
    Color? textFormFieldOultineColor,
    required Color accentColor,
    Color? divider,
    required Color buttonBackground,
    required Color buttonText,
    Color? cardBackground,
    Color? disabled,
    required Color error,
  }) {
    return ThemeData(
        brightness: brightness,
        canvasColor: background,scaffoldBackgroundColor: isDarkMode.value==true?Colors.black:Colors.white,
        primaryColor: accentColor,
        primaryColorDark: buttonBackground,
        primarySwatch: Colors.red,
        // Adjust or remove if not needed
        cardColor: cardBackground ?? background,
        dividerColor: divider,
        disabledColor: disabled ?? buttonBackground,

        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          },
        ),
        dividerTheme: DividerThemeData(
          color: divider,
          space: 1,
          thickness: 1,
        ),
        cardTheme: CardTheme(
          color: cardBackground ?? background,
          surfaceTintColor: cardBackground ?? background,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(margin_8)), // Ensure rectangular corners
          ),
          // clipBehavior: Clip.antiAliasWithSaveLayer,
        ),
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: background,
          errorColor: error,
          accentColor: accentColor,
          brightness: brightness,
        ),
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: isDarkMode.value
              ? Colors.white.withOpacity(.15)
              : AppColors.appColorLight,
          selectionHandleColor:
          isDarkMode.value ? Colors.white : AppColors.appColor,
          cursorColor: isDarkMode.value ? Colors.white : AppColors.appColor,
        ),
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
            statusBarIconBrightness: brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
            statusBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.transparent,
            systemNavigationBarIconBrightness: brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
            systemNavigationBarColor: Colors.transparent,
          ),
          color: brightness == Brightness.dark ? Colors.black : Colors.white,
          toolbarTextStyle: TextStyle(
            color: primaryText,
            fontSize: 18.0, // Adjust font size as needed
          ),
          iconTheme: IconThemeData(
            color: primaryText,
            size: 24.0, // Adjust icon size as needed
          ),
        ),
        iconTheme: IconThemeData(
          color: primaryText,
          size: 24.0, // Adjust icon size as needed
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: buttonBackground,
          // textTheme: ButtonTextTheme.primary,
          colorScheme: ColorScheme(
            brightness: brightness,
            primary: buttonBackground,
            primaryContainer: accentColor,
            secondary: accentColor,
            secondaryContainer: accentColor,
            surface: buttonBackground,
            background: buttonBackground,
            error: error,
            onPrimary: buttonText,
            onSecondary: buttonText,
            onSurface: buttonText,
            onBackground: buttonText,
            onError: buttonText,
          ),
          padding: const EdgeInsets.all(16.0),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: cardBackground,
        ),
        cupertinoOverrideTheme: CupertinoThemeData(
          brightness: brightness,
          primaryColor: accentColor,
        ),
        expansionTileTheme: ExpansionTileThemeData(
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(margin_6)),
            side: BorderSide(
                width: 1,
                color: cardBackground == Colors.white
                    ? Colors.grey.shade200
                    : Colors.white.withOpacity(0)),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(margin_6)),
            side: BorderSide(
                width: 1,
                color: cardBackground == Colors.white
                    ? Colors.grey.shade200
                    : Colors.white.withOpacity(0)),
          ),
          backgroundColor: cardBackground,
          // Background color of the tile when expanded
          collapsedBackgroundColor: cardBackground,
          // Background color when collapsed
          textColor: Colors.black,
          // Text color of the title when expanded
          collapsedTextColor: Colors.grey.shade800,
          // Text color when collapsed
          iconColor: buttonBackground,
          // Icon color when expanded
          collapsedIconColor: buttonBackground,
          // Icon color when collapsed
          tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
          // Padding around the tile
          expandedAlignment:
          Alignment.centerLeft, // Alignment of the expanded content
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
            color: primaryText.withOpacity(.8),
            fontSize: font_14, // Adjust font size as needed
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
          fillColor: cardBackground,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius_6),
              borderSide: BorderSide(color: textFormFieldOultineColor!)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius_6),
              borderSide: BorderSide(
                  color: isDarkMode.value
                      ? AppColors.whiteAppColor
                      : AppColors.appColor)),
          // errorBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(radius_10),
          //     borderSide: BorderSide(color: isDarkMode.value?AppColors.whiteColor:AppColors.appColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius_6),
              borderSide: BorderSide(
                  color: isDarkMode.value
                      ? AppColors.whiteAppColor
                      : AppColors.appColor)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius_6),
              borderSide: BorderSide(color: textFormFieldOultineColor)),
        ),
        fontFamily: 'Poppins',
        textTheme: TextTheme(
          displayLarge: TextStyle(
              color: primaryText,
              fontSize: font_22,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
              decorationColor: AppColors.textGreyColor
          ),

          displayMedium: TextStyle(
              color: primaryText,
              fontSize: font_20,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
              decorationColor: AppColors.textGreyColor
          ),
          displaySmall: TextStyle(
              color: primaryText,
              fontSize: font_18,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
              decorationColor: AppColors.textGreyColor
          ),
          headlineLarge: TextStyle(
              color: primaryText,
              fontSize: font_20,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
              decorationColor: AppColors.textGreyColor
          ),
          headlineMedium: TextStyle(
              color: primaryText,
              fontSize: font_18,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
              decorationColor: AppColors.textGreyColor
          ),
          headlineSmall: TextStyle(
              color: primaryText,
              fontSize: font_17,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
              decorationColor: AppColors.textGreyColor
          ),
          labelLarge: TextStyle(
              color: primaryText,
              fontSize: font_15,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              decorationColor: AppColors.textGreyColor
          ),
          labelMedium: TextStyle(
              color: primaryText,
              fontSize: font_14,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              decorationColor: AppColors.textGreyColor
          ),
          labelSmall: TextStyle(
              color: primaryText,
              fontSize: font_13,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              decorationColor: AppColors.textGreyColor
          ),
          bodyLarge: TextStyle(
              color: primaryText,
              fontSize: font_13,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w400,
              decorationColor: AppColors.textGreyColor
          ),
          bodyMedium: TextStyle(
              color: primaryText,
              fontSize: font_12,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w400,
              decorationColor: AppColors.textGreyColor
          ),
          bodySmall: TextStyle(
              color: primaryText,
              fontSize: font_11,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w400,
              decorationColor: AppColors.textGreyColor
          ),
          titleLarge: TextStyle(
              color: primaryText,
              fontSize: font_16,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
              decorationColor: AppColors.textGreyColor
          ),
          titleMedium: TextStyle(
              color: primaryText,
              fontSize: font_15,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
              decorationColor: AppColors.textGreyColor
          ),
          titleSmall: TextStyle(
              color: primaryText,
              fontSize: font_14,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w400,
              decorationColor: AppColors.textGreyColor
          ),
        )
    );
  }

  ThemeData get lightTheme => isDarkMode.value == true
      ? createTheme(
    brightness: Brightness.dark,
    background: Colors.black,
    cardBackground: Colors.white.withOpacity(.15),
    textFormFieldOultineColor: Colors.white.withOpacity(.15),
    primaryText: Colors.white,
    secondaryText: Colors.white,
    accentColor: Colors.blue,
    // Use your app color here
    divider: Colors.white.withOpacity(.15),
    // Adjust divider color for dark theme
    buttonBackground: Colors.white,
    // Use your app color here
    buttonText: Colors.black,
    disabled: Colors.grey,
    error: Colors.red,
  )
      : createTheme(
    brightness: Brightness.light,
    background: Colors.white,
    cardBackground: Colors.white,
    primaryText: Colors.black,
    textFormFieldOultineColor: Colors.grey.shade300,
    secondaryText: Colors.black,
    accentColor: Colors.blue,
    // Use your app color here
    divider: Colors.grey,
    // Adjust divider color for light theme
    buttonBackground: const Color.fromRGBO(91, 82, 223, 1.0),
    // Use your app color here
    buttonText: Colors.white,
    disabled: Colors.grey,
    error: Colors.red,
  );

  ThemeData get darkTheme => isDarkMode.value == true
      ? createTheme(
    brightness: Brightness.dark,
    background: Colors.black,
    cardBackground: Colors.white.withOpacity(.15),
    textFormFieldOultineColor: Colors.white.withOpacity(.15),
    primaryText: Colors.white,
    secondaryText: Colors.white,
    accentColor: Colors.blue,
    // Use your app color here
    divider: Colors.white.withOpacity(.15),
    // Adjust divider color for dark theme
    buttonBackground: Colors.white,
    // Use your app color here
    buttonText: Colors.black,
    disabled: Colors.grey,
    error: Colors.red,
  )
      : createTheme(
    brightness: Brightness.light,
    background: Colors.white,
    cardBackground: Colors.white,
    primaryText: Colors.black,
    textFormFieldOultineColor: Colors.grey.shade300,
    secondaryText: Colors.black,
    accentColor: Colors.blue,
    // Use your app color here
    divider: Colors.grey,
    // Adjust divider color for light theme
    buttonBackground: const Color.fromRGBO(91, 82, 223, 1.0),
    // Use your app color here
    buttonText: Colors.white,
    disabled: Colors.grey,
    error: Colors.red,
  );
}