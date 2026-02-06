import 'package:eraser/eraser.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:good_citizen/super_controller.dart';
import '../export.dart';
import '../modules/home_module/controllers/home_controller.dart';
// import '../modules/messages/controller/chat_controller.dart';
// import '../modules/messages/controller/chat_manager.dart';
// import '../modules/trips/controllers/trips_controller.dart';

bool avoidBookingCheckOnProfileReload=false;
class FcmNavigator {
  static void clearOldNotifications() {
    Eraser.clearAllAppNotifications();
  }

  static void handleNotificationRedirection(RemoteMessage? message) async {
    if (await preferenceManager.getAuthToken() == null) {
      return;
    }
    debugPrint("openNotificationRedirection");
    debugPrint('Notification Data>>>${message?.data}');
    _navigationHandle(message);
  }

  static void _navigationHandle(RemoteMessage? message) {
    final type = message?.data['type'];
    disableBookingCheckInProfile();
    switch (type) {
      case notificationTypeChat:
      // _handleChatNotification(message);
      case notificationTypeBookingRequest:
        _onRideNotificationsTap(message);
      case notificationTypeDispatchRequest:
        _onRideNotificationsTap(message);
      case notificationTypeAssignBooking:
        _onAssignBooking();
    }
  }

  static void _onAssignBooking() async {
    // if (Get.currentRoute == AppRoutes.tripsRoute) {
    //   if (Get.isRegistered<TripsController>()) {
    //     Get.find<TripsController>().pageNumber = 1;
    //     Get.find<TripsController>().loadTrips();
    //   }
    // } else {
    //   // if (Get.isRegistered<TripsController>() && Get.currentRoute == AppRoutes.ongoingRideRoute) {
    //   //   Get.find<TripsController>().pageNumber = 1;
    //   //   Get.find<TripsController>().loadTrips();
    //   //   Get.until((route) => Get.currentRoute == AppRoutes.tripsRoute);
    //   // } else {
    //     Get.toNamed(AppRoutes.tripsRoute,preventDuplicates: false);
    //     Future.delayed(const Duration(milliseconds: 300),() {
    //       Get.find<TripsController>().pageNumber = 1;
    //       Get.find<TripsController>().loadTrips();
    //     },);
    //
    //   // }
    //
    // }
  }

  static void _onRideNotificationsTap(RemoteMessage? message) {
    if (message == null) {
      return;
    }
    if (Get.isRegistered<HomeController>()) {
      // Get.find<HomeController>()
      //     .onNewNotificationReceived(message, showNotAvailableDialog: true);
    }
  }

//   static void _handleChatNotification(RemoteMessage? message) {
//     final decodedData = jsonDecode(message?.data['booking']);
//     final bookingId = decodedData;
//     if (bookingId != null) {
//     //   if (Get.currentRoute == AppRoutes.chatRoute &&
//     //       (Get.find<ChatController>().connectionModel?.bookingId ==
//     //           bookingId)) {
//     //     return;
//     //   }
//     //   ChatConnector.createChatConnection(bookingId);
//     // }
//   // }
// }
}