// import 'package:flutter_localization/flutter_localization.dart';
import 'package:good_citizen/app/common_data.dart';
import 'package:good_citizen/app/routes/route_observer.dart';

import 'app/core/utils/localizations/translations.dart';
import 'app/export.dart';

NavigatorObserver navigatorObserver = NavigatorObserver();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final FlutterLocalization _localization = FlutterLocalization.instance;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: ScreenUtilInit(
        builder: (context, widget) => GetMaterialApp(
          theme: ThemeConfig().lightTheme,
          darkTheme: ThemeConfig().darkTheme,
          //color: whiteAppColor,
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
          locale: deviceLocale,
          fallbackLocale: const Locale('en', 'US'),
          supportedLocales: const [Locale('en', 'US'), Locale('hi', 'IN')],
          // localizationsDelegates: [..._localization.localizationsDelegates],
          initialBinding: InitialBinding(),
          localeResolutionCallback: (locale, supportedLocales) {
            return locale; // Return the provided locale without checking for support
          },

          translations: LanguageTranslations(),
          scaffoldMessengerKey: AppGlobals.scaffoldMessengerState,
          navigatorKey: AppGlobals.navState,
          debugShowCheckedModeBanner: false,
          enableLog: true,
          logWriterCallback: LoggerX.write,
          builder: EasyLoading.init(builder: (context, child) {
            final mediaQueryData = MediaQuery.of(context);
            final scale = mediaQueryData.textScaleFactor.clamp(1.0, 1.02);
            return MediaQuery(
              data: mediaQueryData.copyWith(textScaleFactor: scale),
              child: child ??
                  const SizedBox.shrink(), // Provide a fallback for `child`
            );
          }),
          defaultTransition: Transition.native,
          // routingCallback: (value) {
          //   appConfigProvider.loadConfiguration();
          //   // stopChatNotificationsIos(value?.current);
          //   onRouteChanged(value);
          // },
        ),
      ),
    );
  }
}
