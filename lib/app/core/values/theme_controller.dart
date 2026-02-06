import 'dart:math';

import 'package:cron/cron.dart';
import 'package:good_citizen/app/modules/home_module/controllers/home_controller.dart';
import 'package:good_citizen/app/modules/profile/models/address_data_model.dart';

import '../../export.dart';
import '../../modules/location_provider/current_location_provider.dart';

class ThemeController extends GetxController {
  RxnString mapStyle = RxnString();
  final cron = Cron();
  bool _isUpdating = false;

  @override
  void onInit() {
    systemThemeMode();
    getMapTheme();
    super.onInit();
  }

  Future<void> systemThemeMode() async {
    var themeMode = await Get.put(PreferenceManager()).getThemeModeData();
    debugPrint("isDarkModeTheme.value========1>${themeMode}");
    if (themeMode != typeDefualtSystemTheme) {
      if (themeMode == typeDarkTheme) {
        Get.changeThemeMode(ThemeMode.dark);
        Get.forceAppUpdate();
        isDarkMode.value = true;
      } else {
        isDarkMode.value = false;
        Get.changeThemeMode(ThemeMode.light);
        Get.forceAppUpdate();
      }
      return;
    }
    setupCronJobs();
  }

  void _setThemeBasedOnTime() {
    final currentTime = DateTime.now();
    final currentHour = currentTime.hour; // Get the current hour

    // You can define the evening as 6 PM (18:00) and night as midnight, etc.
    if (currentHour >= 18 || currentHour < 6) {
      // Evening or night (dark mode)
      isDarkMode.value = true;
      Get.changeThemeMode(ThemeMode.dark);
      Get.forceAppUpdate();
    } else {
      // Daytime (light mode)
      isDarkMode.value = false;
      Get.changeThemeMode(ThemeMode.light);
      Get.forceAppUpdate();
    }
  }

  Future<void> toggleTheme() async {
    debugPrint("showData${Get.isDarkMode}");
    if (Get.isDarkMode) {
      Get.changeThemeMode(ThemeMode.light);
      Get.forceAppUpdate();
      isDarkMode.value = false;
    } else {
      isDarkMode.value = true;

      Get.changeThemeMode(ThemeMode.dark);
      Get.forceAppUpdate();
    }
  }

  getMapTheme() {
    if (isDarkMode.value) {
      // Dark mode map style (you can replace with your custom style)
      return mapStyle.value = '''
            [
              {
                "elementType": "geometry",
                "stylers": [
                  {
                    "color": "#212B3D"
                  }
                ]
              },
              {
                "elementType": "labels.text.fill",
                "stylers": [
                  {
                    "color": "#666666"
                  }
                ]
              },
              {
                "elementType": "labels.text.stroke",
                "stylers": [
                  {
                    "color": "#212B3D"
                  }
                ]
              },
              {
                "featureType": "administrative",
                "elementType": "geometry",
                "stylers": [
                  {
                    "color": "#212B3D"
                  }
                ]
              },
              {
                "featureType": "landscape",
                "elementType": "geometry",
                "stylers": [
                  {
                    "color": "#212B3D"
                  }
                ]
              },
              {
                "featureType": "water",
                "elementType": "geometry.fill",
                "stylers": [
                  {
                    "color": "#171F2D"
                  }
                ]
              },
              {
                "featureType": "road",
                "elementType": "geometry",
                "stylers": [
                  {
                    "color": "#38414E"
                  }
                ]
              },
              {
                "featureType": "road",
                "elementType": "geometry.stroke",
                "stylers": [
                  {
                    "color": "#404A59"
                  }
                ]
              },
              {
                "featureType": "road.highway",
                "elementType": "geometry",
                "stylers": [
                  {
                    "color": "#282A33"
                  }
                ]
              },
              {
                "featureType": "road.highway",
                "elementType": "geometry.stroke",
                "stylers": [
                  {
                    "color": "#4A5460"
                  }
                ]
              },
              {
                "featureType": "road.arterial",
                "elementType": "geometry",
                "stylers": [
                  {
                    "color": "#373D47"
                  }
                ]
              },
              {
                "featureType": "poi",
                "elementType": "geometry",
                "stylers": [
                  {
                    "color": "#212B3D"
                  }
                ]
              },
              {
                "featureType": "poi.park",
                "elementType": "geometry",
                "stylers": [
                  {
                    "color": "#222E3F"
                  }
                ]
              },
              {
                "featureType": "poi.business",
                "elementType": "labels",
                "stylers": [
                  {
                    "visibility": "off"
                  }
                ]
              },
              {
                "featureType": "transit",
                "elementType": "geometry",
                "stylers": [
                  {
                    "color": "#2A3547"
                  }
                ]
              },
              {
                "featureType": "transit.station",
                "elementType": "labels.icon",
                "stylers": [
                  {
                    "visibility": "off"
                  }
                ]
              }
            ]
      ''';
    }else {
      // Light mode map style (Fixed greenish tint issue)
      mapStyle.value = '''
    [
      {
        "featureType": "all",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#f5f5f5"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "geometry.fill",
        "stylers": [
          {
            "color": "#b3d1ff"
          }
        ]
      },
      {
        "featureType": "landscape.natural",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#f0f0f0"  
          }
        ]
      },
      {
        "featureType": "landscape.natural.terrain",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#e0e0e0"  
          }
        ]
      },
      {
        "featureType": "park",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#d6e8d6"
          }
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#d6e8d6"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#ffffff"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "weight": 2
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "weight": 4
          }
        ]
      }
    ]
    ''';
    }

  }


  void setupCronJobs({isFromTheme = false}) {
    _updateThemeBackground(isFromTheme: isFromTheme);
    debugPrint("isCron Method ca;;");
    // Check theme every 5 minutes
    cron.schedule(Schedule.parse('*/5 * * * *'), () {
      debugPrint("isCron Fire =====>");
      // cron.schedule(Schedule.parse('* * * * * *'), () {
      if (!_isUpdating) {
        unawaited(_updateThemeBackground(isFromTheme: isFromTheme));
      }
    });
  }

  Future<void> _updateThemeBackground({isFromTheme = false}) async {
    _isUpdating = true;
    try {
      // Run theme calculation in a compute isolate to avoid blocking
      final shouldBeDark =
          _calculateTheme(DateTime.now().millisecondsSinceEpoch);
      debugPrint(
          "isDark Mode should ${shouldBeDark}  ${shouldBeDark != isDarkMode.value}");
      // Only update if theme needs to change
      if (shouldBeDark != isDarkMode.value) {
        isDarkMode.value = shouldBeDark;
        Get.changeThemeMode(shouldBeDark ? ThemeMode.dark : ThemeMode.light);
        Get.forceAppUpdate();
        var token = preferenceManager.getAuthToken();
        if (token != null) {
          Get.offAllNamed(AppRoutes.splashRoute);
        }
        checkBooking();
        getMapTheme(); // Update map style when theme changes
      } else {
        debugPrint(
            "isFrom Page===> $isFromTheme");
        if (isFromTheme == true) {
          Get.offAllNamed(AppRoutes.splashRoute);
        }
        getMapTheme(); // Update map style when theme changes
        checkBooking();
      }
      // else {
      //   if (Get.currentRoute != AppRoutes.homeRoute) {
      //     Get.offAllNamed(AppRoutes.homeRoute);
      //   }
      //   getMapTheme(); // Update map style when theme changes
      //   checkBooking();
      // }
    } finally {
      _isUpdating = false;
    }
  }

  checkBooking() async {
    await profileDataProvider.reloadProfile(showLoader: false);
    await Future.delayed(const Duration(milliseconds: 700));
    // if (Get.isRegistered<HomeController>()) {
    //   Get.find<HomeController>().checkForCurrentBooking();
    // }
  }

  static bool _calculateTheme(int timestamp) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final int dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays + 1;

    // Calculate solar declination for natural day/night cycle
    double rad = pi / 180.0;
    final double decl = -23.45 * cos(360.0 / 365.0 * (dayOfYear + 10) * rad);

    // Calculate natural sunrise/sunset without location
    final double sunriseHour =
        12.0 - (12.0 / pi) * acos(-tan(23.5 * rad) * tan(decl * rad));
    final double sunsetHour =
        12.0 + (12.0 / pi) * acos(-tan(23.5 * rad) * tan(decl * rad));

    final double currentHour = date.hour + date.minute / 60.0;
    return currentHour <= sunriseHour || currentHour >= sunsetHour;
  }

  cancelCron() {
    cron.close();
  }

  @override
  void onClose() {
    cron.close();
    super.onClose();
  }
}
