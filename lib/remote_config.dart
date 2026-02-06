//aws
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/export.dart';



late String stripeSecretKey;
late String stripeAccessKey;
late String googleApiConst;
late String isWaterApiKey;

late String baseUrl;
late String sharedUrl;
late String mediaBaseUrl;



class RemoteConfig {
  bool isLiveMode = true;

  ///set to true before publishing app to stop fetching data from firebase
  late FirebaseRemoteConfig _remoteConfig;

  RemoteConfig() {
    _remoteConfig = FirebaseRemoteConfig.instance;
  }

  Future<void> loadRemoteKeys() async {
    if (isLiveMode) {
      _loadConstants();
      return;
    }

    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 5),
      ));
      await _remoteConfig.fetchAndActivate();
      _loadConstants();
    } catch (e) {
      debugPrint("Remote Config Error: $e");
      _loadConstants();
    }
  }

  void _loadConstants() {
    baseUrl = _getKeyValue('BASE_URL');
    sharedUrl = _getKeyValue('SHARED_URL');
    mediaBaseUrl = _getKeyValue('MEDIA_BASE_URL');
    googleApiConst = _getKeyValue('GOOGLE_API');
    isWaterApiKey = _getKeyValue('IS_WATER_API');
    stripeAccessKey = _getKeyValue('STRIPE_ACCESS');
    stripeSecretKey = _getKeyValue('STRIPE_SECRET');
  }

  String _getKeyValue(String key) {
    if (isLiveMode) {
      return dotenv.env[key] ?? '';
    }

    if (_remoteConfig.getString(key).isNotEmpty) {
      return _remoteConfig.getString(key);
    } else {
      return dotenv.env[key] ?? '';
    }
  }
}
