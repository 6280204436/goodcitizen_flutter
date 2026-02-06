import 'package:good_citizen/app/export.dart';
import 'package:good_citizen/super_controller.dart';

import '../core/utils/localizations/localization_controller.dart';
import '../core/values/theme_controller.dart';
import '../push_notifications/fcm_notifications_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(UserStatusController());
    RepositoryBindings().dependencies();
    LocalSourceBindings().dependencies();
    Get.put(FCMNotificationsController(), permanent: true);

  }
}
