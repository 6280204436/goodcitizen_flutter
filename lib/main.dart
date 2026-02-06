import 'dart:math';

import 'package:app_links/app_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:good_citizen/remote_config.dart';

import 'package:good_citizen/app/push_notifications/fcm_navigator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:good_citizen/firebase_options.dart';

import 'app/common_data.dart';
import 'app/core/utils/common_item_model.dart';
import 'app/core/utils/localizations/localization_controller.dart';
import 'app/core/values/theme_controller.dart';
import 'app/export.dart';

import 'app/modules/authentication/controllers/profile_provider.dart';
import 'app/modules/location_provider/current_location_provider.dart';
import 'app/modules/profile/models/address_data_model.dart';
import 'app/modules/socket_controller/socket_controller.dart';
import 'app/push_notifications/fcm_event_listener.dart';
import 'app/push_notifications/notification_controller.dart';
import 'app/push_notifications/local_notification_service.dart';
import 'app/services/native_ios_service.dart';

// Firebase background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message received: ${message.messageId}');

  // Initialize Firebase if needed
  // await Firebase.initializeApp();

  // Show local notification for background messages
  final localNotificationService = LocalNotificationService();
  await localNotificationService.initialize();

  await localNotificationService.showFirebaseNotification(
    message: message,
  );
}

CustomLoader customLoader = CustomLoader();
GetStorage localStorage = GetStorage();

PreferenceManager preferenceManager = PreferenceManager();
late APIRepository repository;
late Debouncer debouncer;
RxBool isDarkModeTheme = false.obs;
RxBool isDarkMode = false.obs;
final appLinks = AppLinks();
int themeModeValue = 0;
late ProfileDataProvider profileDataProvider;
late CurrentLocationProvider currentLocationProvider;
late SocketController socketController;
late FCMEventListenController fcmEventListenerController;
// late AppConfigProvider appConfigProvider;
// late StripeHandler stripeHandler;

Rx<CommonItemModel> selectedLanguage = languagesList.first.obs;
late Locale? deviceLocale;

// Global flag to track app initialization
bool _isAppInitialized = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // GoogleMapsFlutterPlatform.instance.init(
  //   iosApiKey: 'YOUR_API_KEY', // Same as in AppDelegate
  // );
  // final nativeIOSService = Get.put(NativeIOSService());

  // Fetch and set auth token with retry
  const maxRetries = 5;
  int retryCount = 0;
  String? token;

  while (retryCount < maxRetries) {
    try {
      print(
          '🔍 Attempting to fetch auth token (Attempt ${retryCount + 1}/$maxRetries)...');
      dynamic tokenData = await preferenceManager.getAuthToken();
      print(
          '🔍 Token from PreferenceManager: $tokenData (${tokenData.runtimeType})');

      if (tokenData is String && tokenData.isNotEmpty) {
        token = tokenData;
        // Delay to ensure method channel is ready
        // await Future.delayed(Duration(milliseconds: 500));
        // final success = await nativeIOSService.setAuthToken(token);
        // if (success) {
        //   print(
        //       '✅ Auth token initialized: ${token.substring(0, token.length > 10 ? 10 : token.length)}...');
        //   break;
        // } else {
        //   print('⚠️ Failed to set auth token, retrying...');
        // }
      } else {
        print('⚠️ Invalid or empty token from PreferenceManager: $tokenData');
      }
    } catch (e) {
      print('❌ Error fetching or setting auth token: $e');
    }
    retryCount++;
    if (retryCount < maxRetries) {
      await Future.delayed(Duration(seconds: 2));
    }
  }

  if (token == null || token.isEmpty) {
    print('⚠️ Failed to initialize auth token after $maxRetries attempts');
  } else {
    // Verify token status after setting
    // final tokenStatus = await nativeIOSService.getAuthTokenStatus();
    // print('🔍 Initial auth token status: $tokenStatus');
  }

  await init();
}

init() async {
  _systemThemeMode();

  // Initialize app links with proper error handling
  try {
    // Handle initial link if app was opened from a link
    final initialLink = await appLinks.getInitialLink();
    if (initialLink != null) {
      print("Initial deep link: $initialLink");
      // Store the initial link to handle after app initialization
      _handleDeepLink(initialLink);
    }

    // Listen for subsequent links
    appLinks.uriLinkStream.listen((uri) {
      print("Deep link received: $uri");
      _handleDeepLink(uri);
    }, onError: (error) {
      print("Deep link error: $error");
    });
  } catch (e) {
    print("Error setting up deep links: $e");
  }

  await _loadPreConfig();
  _initControllers();
  await _setLocale();
  initApp();
}

Future<void> _loadPreConfig() async {
  await _setOrientation();
  await GetStorage.init();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await RemoteConfig().loadRemoteKeys();

  // Register Firebase background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

void _initControllers() {
  // preferenceManager = Get.put(PreferenceManager());
  Get.lazyPut<ThemeController>(
    () => ThemeController(),
    fenix: true,
  );
  repository = Get.put(APIRepository());
  profileDataProvider = Get.put(ProfileDataProvider());
  // appConfigProvider = Get.put(AppConfigProvider());
  // stripeHandler = Get.put(StripeHandler());
  debouncer = Get.put(Debouncer(delay: const Duration(milliseconds: 700)));

  // Initialize notification controller
  Get.put(NotificationController());
}

initApp() async {
  FcmNavigator.clearOldNotifications();
  runApp(const MyApp());

  // Mark app as initialized after a longer delay to ensure everything is ready
  Future.delayed(const Duration(milliseconds: 2000), () {
    _isAppInitialized = true;
    print("App initialization completed");
  });
}

Future _setLocale() async {
  final String? savedLocale = await preferenceManager.getLanguage();
  if (savedLocale != null) {
    final list = savedLocale.split('_');
    final tempLocale = Locale(list[0], list[1]);
    await Get.updateLocale(tempLocale);
  }
  deviceLocale = Get.locale ?? Get.deviceLocale;
  // selectedLanguage = getSelectedLanguage().obs;
}

Future _setOrientation() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark,
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black,
      statusBarIconBrightness: Brightness.dark));

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

Future<void> _systemThemeMode() async {
  //await Future.delayed(Duration(milliseconds: 700));

  final int themeMode = localStorage.read(PreferenceManager.themeModeKey) ?? 0;
  debugPrint('main dart check theme value >${themeMode}');
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
  _updateTheme();
}

Future<void> _updateTheme() async {
  try {
    // Run theme calculation in a compute isolate to avoid blocking
    final shouldBeDark =
        _calculateThemeInIsolate(DateTime.now().millisecondsSinceEpoch);
    // Only update if theme needs to change
    if (shouldBeDark != isDarkMode.value) {
      isDarkMode.value = shouldBeDark;
      Get.changeThemeMode(shouldBeDark ? ThemeMode.dark : ThemeMode.light);

      Get.forceAppUpdate();

      Get.find<ThemeController>()
          .getMapTheme(); // Update map style when theme changes
    }
  } catch (e) {
    debugPrint("exception $e");
  }
}

bool _calculateThemeInIsolate(int timestamp) {
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

// Handle deep links safely
void _handleDeepLink(Uri uri) {
  print("Processing deep link: $uri");

  // Wait for the app to be ready before navigating
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _processDeepLinkWithRetry(uri);
  });
}

// Process deep link with retry mechanism
void _processDeepLinkWithRetry(Uri uri, {int retryCount = 0}) {
  try {
    if (_isAppInitialized && Get.context != null) {
      print("App ready, processing deep link");
      _navigateBasedOnDeepLink(uri);
    } else {
      print("App not ready yet, retry count: $retryCount");
      if (retryCount < 5) {
        // Retry after a delay
        Future.delayed(const Duration(milliseconds: 500), () {
          _processDeepLinkWithRetry(uri, retryCount: retryCount + 1);
        });
      } else {
        print("Max retries reached, using emergency fallback");
        _emergencyNavigation();
      }
    }
  } catch (e) {
    print("Error in deep link processing: $e");
    _emergencyNavigation();
  }
}

// Emergency navigation fallback
void _emergencyNavigation() {
  try {
    final authToken = preferenceManager.getAuthToken();
    if (authToken != null) {
      Get.offAllNamed(AppRoutes.homeRoute);
    } else {
      Get.offAllNamed(AppRoutes.signupRoutes);
    }
  } catch (e) {
    print("Emergency navigation failed: $e");
  }
}

// Navigate based on deep link content
void _navigateBasedOnDeepLink(Uri uri) {
  try {
    // Check if user is authenticated
    final authToken = preferenceManager.getAuthToken();

    // Parse the URI to determine navigation
    final path = uri.path;
    final queryParams = uri.queryParameters;
    final host = uri.host;
    final scheme = uri.scheme;

    print(
        "Deep link - Scheme: '$scheme', Host: '$host', Path: '$path', Params: $queryParams");

    // Handle different URL formats
    if (host.contains('agoodcitizen.in') ||
        host.contains('agoodcitizen.com') ||
        scheme == 'goodcitizen') {
      // Handle URLs with no path (just domain)
      if (path.isEmpty || path == '/') {
        print("Domain-only URL detected, using default navigation");
        if (authToken != null) {
          safeNavigate(AppRoutes.homeRoute);
        } else {
          safeNavigate(AppRoutes.signupRoutes);
        }
        return;
      }

      // Handle specific paths
      if (authToken != null) {
        // User is logged in
        switch (path.toLowerCase()) {
          case '/home':
          case '/home/':
            safeNavigate(AppRoutes.homeRoute);
            break;
          case '/profile':
          case '/profile/':
            safeNavigate(AppRoutes.profileRoute);
            break;
          case '/tracking':
          case '/tracking/':
            safeNavigate(AppRoutes.trackingRoute);
            break;
          case '/signup':
          case '/signup/':
            safeNavigate(AppRoutes.signupRoutes);
            break;
          case '/login':
          case '/login/':
            safeNavigate(AppRoutes.loginRoute);
            break;
          default:
            // Check if path contains any of our keywords
            if (path.toLowerCase().contains('signup')) {
              safeNavigate(AppRoutes.signupRoutes);
            } else if (path.toLowerCase().contains('login')) {
              safeNavigate(AppRoutes.loginRoute);
            } else if (path.toLowerCase().contains('home')) {
              safeNavigate(AppRoutes.homeRoute);
            } else if (path.toLowerCase().contains('profile')) {
              safeNavigate(AppRoutes.profileRoute);
            } else if (path.toLowerCase().contains('tracking')) {
              safeNavigate(AppRoutes.trackingRoute);
            } else {
              // Default to home for authenticated users
              safeNavigate(AppRoutes.homeRoute);
            }
        }
      } else {
        // User is not logged in
        switch (path.toLowerCase()) {
          case '/signup':
          case '/signup/':
            safeNavigate(AppRoutes.signupRoutes);
            break;
          case '/login':
          case '/login/':
            safeNavigate(AppRoutes.loginRoute);
            break;
          case '/home':
          case '/home/':
            safeNavigate(
                AppRoutes.loginRoute); // Redirect to login if not authenticated
            break;
          case '/profile':
          case '/profile/':
            safeNavigate(
                AppRoutes.loginRoute); // Redirect to login if not authenticated
            break;
          case '/tracking':
          case '/tracking/':
            safeNavigate(
                AppRoutes.loginRoute); // Redirect to login if not authenticated
            break;
          default:
            // Check if path contains any of our keywords
            if (path.toLowerCase().contains('signup')) {
              safeNavigate(AppRoutes.signupRoutes);
            } else if (path.toLowerCase().contains('login')) {
              safeNavigate(AppRoutes.loginRoute);
            } else {
              // Default to signup for unauthenticated users
              safeNavigate(AppRoutes.signupRoutes);
            }
        }
      }
    } else {
      // Unknown domain, use default behavior
      print("Unknown domain, using default navigation");
      if (authToken != null) {
        safeNavigate(AppRoutes.homeRoute);
      } else {
        safeNavigate(AppRoutes.signupRoutes);
      }
    }
  } catch (e) {
    print("Error in deep link navigation: $e");
    // Fallback navigation
    final authToken = preferenceManager.getAuthToken();
    if (authToken != null) {
      safeNavigate(AppRoutes.homeRoute);
    } else {
      safeNavigate(AppRoutes.signupRoutes);
    }
  }
}

// Safe navigation method
void safeNavigate(String routeName) {
  try {
    if (_isAppInitialized) {
      print("Attempting to navigate to: $routeName");

      // Check if GetX is ready
      if (Get.isRegistered<NavigatorState>() || Get.context != null) {
        try {
          Get.offAllNamed(routeName);
          print("Successfully navigated to: $routeName");
        } catch (e) {
          print("Get.offAllNamed failed: $e");
          // Fallback to regular navigation
          try {
            Get.toNamed(routeName);
            print("Fallback navigation successful to: $routeName");
          } catch (e2) {
            print("Fallback navigation also failed: $e2");
            // Last resort - try to navigate after a delay
            Future.delayed(const Duration(milliseconds: 500), () {
              try {
                Get.offAllNamed(routeName);
              } catch (e3) {
                print("Final navigation attempt failed: $e3");
              }
            });
          }
        }
      } else {
        print("GetX not ready, queuing navigation to: $routeName");
        // If navigator is not ready, try again after a short delay
        Future.delayed(const Duration(milliseconds: 1000), () {
          safeNavigate(routeName);
        });
      }
    } else {
      print("App not initialized, queuing navigation to: $routeName");
      // If app is not ready, queue the navigation
      Future.delayed(const Duration(milliseconds: 1000), () {
        safeNavigate(routeName);
      });
    }
  } catch (e) {
    print("Error in safeNavigate: $e");
    // Emergency fallback
    try {
      Get.offAllNamed(AppRoutes.splashRoute);
    } catch (e2) {
      print("Emergency fallback also failed: $e2");
    }
  }
}

// Test function to verify deep link paths (for debugging)
void testDeepLinks() {
  print("=== Testing Deep Link Paths ===");

  // Test different URL formats
  final testUrls = [
    'https://agoodcitizen.in',
    'https://agoodcitizen.in/signup',
    'https://agoodcitizen.in/login',
    'https://agoodcitizen.in/home',
    'https://agoodcitizen.in/profile',
    'https://agoodcitizen.in/tracking',
    'goodcitizen://signup',
    'goodcitizen://login',
    'goodcitizen://home',
  ];

  for (final url in testUrls) {
    final uri = Uri.parse(url);
    print("Testing URL: $url");
    print("  - Scheme: ${uri.scheme}");
    print("  - Host: ${uri.host}");
    print("  - Path: '${uri.path}'");
    print("  - Query: ${uri.queryParameters}");
    print("---");
  }
}

// Add this to your init() function for testing
// testDeepLinks();
