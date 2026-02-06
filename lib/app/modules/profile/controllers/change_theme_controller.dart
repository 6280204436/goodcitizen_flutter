
import '../../../core/values/theme_controller.dart';
import '../../../export.dart';
import '../../home_module/controllers/home_controller.dart';


class ChangeThemeController extends GetxController {
  // ignore: always_specify_types
  final RxInt _themeMode = typeDefualtSystemTheme.obs;
  PreferenceManager localStorage = Get.find<PreferenceManager>();
  RxnString? mapStyle;
  int get themeMode => _themeMode.value;

  @override
  void onInit() {
    getDataFromLocalStorage();
    super.onInit();
  }

  Future<void> getDataFromLocalStorage() async {
    _themeMode.value = await localStorage.getThemeModeData();
    update();
  }

  void setThemeMode(int mode) {
    _themeMode.value = mode;
    update();
  }


  void changeTheme() {
    // ignore: inference_failure_on_function_invocation
    Get.back();
    debugPrint('theme Mode $themeMode');
    updateThemData();
  }

  void updateThemData() {
    localStorage.saveThemeModeData(themeMode);
    // ignore: unrelated_type_equality_checks
    debugPrint('theme mode form  $themeMode ${themeMode == ThemeMode.light}');
    if (themeMode == typeLightTheme) {
      Get.find<ThemeController>().cancelCron();
      themeModeValue = 1;
      Get.changeThemeMode(ThemeMode.light);
      isDarkMode.value = false;
      _changeStatusBar();
      Get.forceAppUpdate();
    } else if (themeMode == typeDarkTheme) {
      Get.find<ThemeController>().cancelCron();
      themeModeValue = 2;
      Get.changeThemeMode(ThemeMode.dark);
      isDarkMode.value = true;
      _changeStatusBar();
      Get.forceAppUpdate();
    } else {
      Get.find<ThemeController>().cancelCron();
      themeModeValue = 0; //system
      _setThemeBasedOnTime();
      Get.find<ThemeController>().setupCronJobs(isFromTheme: true);
    }

    Get.find<ThemeController>().getMapTheme();
    // deleteonGoingController();
    Get.offAllNamed(AppRoutes.splashRoute);
    checkBooking();
  }

  checkBooking() async {
    await profileDataProvider.reloadProfile(showLoader: false);
    await Future.delayed(const Duration(milliseconds: 700));
    // if (Get.isRegistered<HomeController>()) {
    //   Get.find<HomeController>().checkForCurrentBooking();
    // }
  }

  void _setThemeBasedOnTime() {
    final currentTime = DateTime.now();
    final currentHour = currentTime.hour; // Get the current hour

    // You can define the evening as 6 PM (18:00) and night as midnight, etc.
    if (currentHour >= 18 || currentHour < 6) {
      // Evening or night (dark mode)
      isDarkMode.value = true;
      Get.changeThemeMode(ThemeMode.dark);
      _changeStatusBar();
      Get.forceAppUpdate();
    } else {
      // Daytime (light mode)
      isDarkMode.value = false;
      Get.changeThemeMode(ThemeMode.light);
      _changeStatusBar();
      Get.forceAppUpdate();
    }
  }

  void _changeStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            isDarkMode.value ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness:
            isDarkMode.value ? Brightness.light : Brightness.dark,
        systemNavigationBarColor:
            isDarkMode.value ? Colors.black : Colors.white,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarContrastEnforced: true,
      ),
    );
  }
}
