import '../../../remote_config.dart';
import '../../export.dart';
import '../socket_controller/socket_controller.dart';

class NativeLocationServices {
  static const _platform =
      MethodChannel( "com.android.goodcitizen/foreground_service");

  static Future<void> startForegroundService() async {
    try {
      _platform.invokeMethod('startForegroundService', {
        'token': preferenceManager.getAuthToken(),
        // 'serverUrl': baseUrl,
        // 'messageHeading': _androidNotificationContent
        //         .containsKey(selectedLanguage.value.secondValue)
        //     ? (_androidNotificationContent[selectedLanguage.value.secondValue]
        //             ?[0]) ??
        //         keyAndroidLocNotificationTitle.tr
        //     : keyAndroidLocNotificationTitle.tr,
        // 'messageDescription': _androidNotificationContent
        //         .containsKey(selectedLanguage.value.secondValue)
        //     ? (_androidNotificationContent[selectedLanguage.value.secondValue]
        //             ?[1]) ??
        //         keyAndroidLocNotificationDes.tr
        //     : keyAndroidLocNotificationDes.tr
        // these messages are used in android only to display notification
      });
      // reConnectFlutterSocket();
    } on PlatformException catch (e) {
      // reConnectFlutterSocket();
      debugPrint("Failed to start foreground service: '${e.message}'.");
    }
  }

  static void reConnectFlutterSocket() async {
    await Future.delayed(const Duration(seconds: 1));
    // if (Get.isRegistered<SocketController>()) {
    //   socketController.reConnectSocket();
    // }
  }


  static Future<void> stopForegroundService() async {
    try {
     await _platform.invokeMethod('stopForegroundService');
     reConnectFlutterSocket();
    } on PlatformException catch (e) {
      reConnectFlutterSocket();
      debugPrint("Failed to stop foreground service: '${e.message}'.");
    }
  }
}

Map<String, List<String>> _androidNotificationContent = {
  'english': [
    "You're Online!",
    "You're online and ready to receive ride requests."
  ],
  'hindi': [
    "आप ऑनलाइन हैं!",
    "आप ऑनलाइन हैं और राइड रिक्वेस्ट प्राप्त करने के लिए तैयार हैं।"
  ],
};
