import 'package:good_citizen/app/export.dart';
import 'package:good_citizen/app/modules/authentication/models/data_model/media_upload_model.dart';
import 'package:good_citizen/app/modules/authentication/models/data_model/message_response_model.dart';
import 'package:good_citizen/app/modules/authentication/models/data_model/user_model.dart';
import 'package:good_citizen/app/modules/authentication/models/response_models/signup_datamodel.dart';
import 'package:good_citizen/app/modules/authentication/models/response_models/user_response_model.dart';
import 'package:good_citizen/app/modules/home_module/models/response_models/booking_response_model.dart';
import 'package:good_citizen/app/modules/home_module/models/response_models/start_ride_reponse_model.dart';
import 'package:path/path.dart' as path;
import 'package:good_citizen/app/modules/profile/models/data_model/static_page_model.dart';
import 'package:good_citizen/app/modules/profile/models/response_models/faq_response_model.dart';
import 'package:good_citizen/app/modules/profile/models/response_models/static_page_response_model.dart';

// import 'package:good_citizen/app/modules/wallet/models/response_models/earnings_list_response.dart';

import '../../../remote_config.dart';
import '../../core/utils/location_services/location_data_model.dart';

import '../../modules/authentication/models/response_models/ResendOtpResponse.dart';
import '../../modules/authentication/models/response_models/forget_password_response_model.dart';
import '../../modules/home_module/models/response_models/bookings_list_reponse.dart';
import '../../modules/model/Static_model.dart';
import '../../modules/model/lat_lng_model.dart';
import '../../modules/profile/models/response_models/notification_model.dart';
import '../../modules/profile/models/response_models/reviews_list_model.dart';
// import '../../modules/wallet/models/response_models/payment_method_response.dart';
// import '../../modules/wallet/models/response_models/stripe_payment_response.dart';
import 'network_exceptions.dart';
import 'package:http_parser/http_parser.dart';

class APIRepository {
  late DioClient? dioClient;
  var deviceName, deviceType, deviceID, deviceVersion;

  APIRepository() {
    var dio = Dio();
    dioClient = DioClient(baseUrl, dio);
    getDeviceData();
  }

  getDeviceData() async {
    DeviceInfoPlugin info = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await info.androidInfo;
      deviceName = androidDeviceInfo.model;
      deviceID = androidDeviceInfo.id;
      deviceVersion = androidDeviceInfo.version.release;
      deviceType = "1";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await info.iosInfo;
      deviceName = iosDeviceInfo.model;
      deviceID = iosDeviceInfo.identifierForVendor;
      deviceVersion = iosDeviceInfo.systemVersion;
      deviceType = "2";
    }
  }


  Future signupApiCall(
      {required Map<String, dynamic>? dataBody, bool showLoader = true}) async {
    try {
      final response = await dioClient!.post(signUpEndPoint,
          data: jsonEncode(dataBody), isLoading: showLoader);
      return SignupModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }



  Future DriverDocumentCall(
      {required Map<String, dynamic>? dataBody, bool showLoader = true}) async {
    try {
      final response = await dioClient!.post(DocumentEndPoint,
          data: jsonEncode(dataBody), isLoading: showLoader);
      return ForgetPasswordResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }



  Future editProfile(
      {required Map<String, dynamic>? dataBody, bool showLoader = true}) async {
    try {
      final response = await dioClient!.patch(editProfileEndPoint,
          data: jsonEncode(dataBody), isLoading: showLoader);
      return UserResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future startRideApiCall(
      {required Map<String, dynamic>? dataBody, bool showLoader = true}) async {
    try {
      final response = await dioClient!.post(startRideEndPoint,
          data: jsonEncode(dataBody), isLoading: showLoader);
      return StartRideResponse.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future registerApiCall(
      {required Map<String, dynamic>? dataBody, bool showLoader = true}) async {
    try {
      final response = await dioClient!.post(logInEndPoint,
          data: jsonEncode(dataBody));
      return UserResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future endRideApiCall(
      {required String? id }) async {
    try {
      final response = await dioClient!.patch("${endRideEndPoint}/$id");
      return ForgetPasswordResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }


  Future forgetPasswordApiCall(
      {required Map<String, dynamic>? dataBody, bool showLoader = true}) async {
    try {
      final response = await dioClient!.patch(forgetEndPoint,
          data: jsonEncode(dataBody), isLoading: showLoader);
      return ForgetPasswordResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future setPasswordApicall(
      {required Map<String, dynamic>? dataBody, bool showLoader = true}) async {
    try {
      final response = await dioClient!.patch(setPasswordEndPoint,
          data: jsonEncode(dataBody), isLoading: showLoader,skipAuth: false);
      return ForgetPasswordResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future socialLoginApiCall({required Map<String, dynamic>? dataBody}) async {
    try {
      final response = await dioClient!
          .post(socialLoginEndPoint, data: jsonEncode(dataBody!));
      return UserResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  // Future updateFCMTokenApiCall({required Map<String, dynamic>? query}) async {
  //   try {
  //     final response = await dioClient!.put(updateFCMTokenEndPoint,
  //         queryParameters: query, isLoading: false);
  //     return MessageResponseModel.fromJson(response);
  //   } catch (e) {
  //     return Future.error(NetworkExceptions.getDioException(e));
  //   }
  // }

  Future verifyPhoneApiCall(
      {required Map<String, dynamic>? dataBody, bool isEdit = false}) async {
    try {
      final response = await dioClient!.post(
          isEdit ? editPhoneVerifyEndPoint : phoneVerifyEndPoint,
          data: jsonEncode(dataBody),
          isLoading: false,
          skipAuth: false);
      return UserResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future editVerifyPhoneApiCall(
      {required Map<String, dynamic>? dataBody}) async {
    try {
      final response = await dioClient!.put(editPhoneVerifyEndPoint,
          data: jsonEncode(dataBody), skipAuth: false, isLoading: false);
      return UserResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future forgetverifyEmailApiCall({required Map<String, dynamic>? dataBody}) async {
    try {
      final response = await dioClient!.patch(emailVerifyEndPoint,
          data: jsonEncode(dataBody), isLoading: false);
      return SignupModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future verifyEmailApiCall({required Map<String, dynamic>? dataBody}) async {
    try {
      final response = await dioClient!.patch(verificationEndPoint,
          data: jsonEncode(dataBody), isLoading: false,skipAuth:false);
      return UserResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future resendOtpApiCall({Map<String, dynamic>? dataBody}) async {
    try {
      final response = await dioClient!.patch(resendOtpEndPoint,
          skipAuth: true,
          data: dataBody != null ? jsonEncode(dataBody) : null);
      return ResendOtpResponse.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future resendPhoneOtpApiCall() async {
    try {
      final response =
          await dioClient!.put(resendPhoneOtpEndPoint, skipAuth: false);
      return MessageResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future updateProfileApiCall(
      {required Map<String, dynamic>? dataBody, showLoader = true}) async {
    try {
      final response = await dioClient!.put(updateProfileDataEndPoint,
          data: jsonEncode(dataBody), skipAuth: false, isLoading: showLoader);
      return MessageResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future updateLicApiCall(
      {required Map<String, dynamic>? dataBody, showLoader = true}) async {
    try {
      final response = await dioClient!.put(updateLicDataEndPoint,
          data: jsonEncode(dataBody), skipAuth: false, isLoading: showLoader);
      return MessageResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future logoutApiCall() async {
    try {
      final response = await dioClient!.delete(logoutEndPoint, skipAuth: false);
      return MessageResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future deleteAccountApiCall() async {
    try {
      final response = await dioClient!.put(DeleteAccountEndPoint, skipAuth: false);
      return MessageResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future loadProfile() async {
    try {
      final response =
          await dioClient!.get(configurationEndPoint, skipAuth: false);
      return UserResponseModel.fromJson(response);
    } catch (e) {
      debugPrint('Error $e');
    }
  }



  Future getNotifications( Map<String, dynamic>? queryParams,) async {
    try {
      final response =
      await dioClient!.get(getNotificationEndPoint, skipAuth: false,queryParameters: queryParams);
      return NotificationResponse.fromJson(response);
    } catch (e) {
      debugPrint('Error $e');
    }
  }

  Future getContent({required String? type}) async {
    try {
      final response =
      await dioClient!.get("${getContentEndPoint}?type=$type", skipAuth: false);
      return StaticModel.fromJson(response);
    } catch (e) {
      debugPrint('Error $e');
    }
  }

  Future DeleteAccount() async {
    try {
      final response =
      await dioClient!.delete("${DeleteAccountEndPoint}", skipAuth: false);
      return ForgetPasswordResponseModel.fromJson(response);
    } catch (e) {
      debugPrint('Error $e');
    }
  }


  Future getProfileApiCall() async {
    try {
      final response =
          await dioClient!.get(getProfileEndPoint, skipAuth: false);
      return UserResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }


  Future getRideDetailsApiCall(String? id) async {
    try {
      final response =
      await dioClient!.get("${rideDetailsEndPoint}/$id", skipAuth: false);
      return StartRideResponse.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }


  Future addVehicleApiCall(
      {required Map<String, dynamic>? dataBody, showLoader = true}) async {
    try {
      final response = await dioClient!.post(addVehicleEndPoint,
          data: jsonEncode(dataBody), skipAuth: false, isLoading: showLoader);
      return MessageResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future editVehicleApiCall(
      {required Map<String, dynamic>? dataBody, showLoader = true}) async {
    try {
      final response = await dioClient!.put(editVehicleEndPoint,
          data: jsonEncode(dataBody), skipAuth: false, isLoading: showLoader);
      return MessageResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }




  Future updateDriverStateApiCall(
      {required Map<String, dynamic>? dataBody, showLoader = false}) async {
    try {
      final response = await dioClient!.put(driverStateEndPoint,
          data: jsonEncode(dataBody), skipAuth: false, isLoading: showLoader);
      return MessageResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future activateVehicleAPiCall(var id) async {
    try {
      final response = await dioClient!.put('$activateVehicleEndPoint/$id',
          skipAuth: false, isLoading: true);
      return MessageResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future updateDriverLocationApiCall(
      {required Map<String, dynamic>? queryParams, showLoader = false}) async {
    try {
      final response = await dioClient!.put(driverUpdateLocationEndPoint,
          queryParameters: queryParams, skipAuth: false, isLoading: showLoader);
      return MessageResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future addBankApiCall(
      {required Map<String, dynamic>? dataBody, bool showLoader = true}) async {
    try {
      final response = await dioClient!.post(bankEndPoint,
          data: json.encode(dataBody), skipAuth: false, isLoading: showLoader);
      return MessageResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future updateBankApiCall(
      {required Map<String, dynamic>? dataBody, bool showLoader = true}) async {
    try {
      final response = await dioClient!.put(bankEndPoint,
          data: json.encode(dataBody), skipAuth: false, isLoading: showLoader);
      return MessageResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }



  Future getBookingDetailApiCall(var id) async {
    try {
      final response =
          await dioClient!.get('$bookingEndPoint/$id', skipAuth: false);
      return BookingResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future bookingListApiCall(var query) async {
    try {
      final response = await dioClient!.get('$bookingEndPoint/listing/status',
          skipAuth: false, queryParameters: query);
      return BookingsListResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future acceptBookingApiCall({var id, showLoader = true}) async {
    try {
      final response = await dioClient!.put('$acceptBookingEndPoint/$id',
          skipAuth: false, isLoading: showLoader);
      return MessageResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future declineBookingApiCall({var id, showLoader = true}) async {
    try {
      final response = await dioClient!.put('$declineBookingEndPoint/$id',
          skipAuth: false, isLoading: showLoader);
      return MessageResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future changeRideStatusApiCall(Map<String, dynamic> query) async {
    try {
      final response = await dioClient!.put(changeRideStatusEndPoint,
          skipAuth: false, isLoading: false, queryParameters: query);
      return MessageResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future completeRideApiCall(var id, Map<String, dynamic> query) async {
    try {
      final response = await dioClient!.put('$completeRideEndPoint/$id',
          skipAuth: false, isLoading: true, queryParameters: query);
      return MessageResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future markPaymentReceived(var id) async {
    try {
      final response = await dioClient!
          .put('$markPaymentEndPoint/$id', skipAuth: false, isLoading: true);
      return MessageResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future cancelRideApiCall(var id,
      {bool showLoader = true, Map<String, dynamic>? dataBody}) async {
    try {
      final response = await dioClient!.put('$bookingEndPoint/cancelled/$id',
          isLoading: showLoader,
          data: dataBody != null ? json.encode(dataBody) : null);
      return MessageResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  // Future earningsApiCall(var query) async {
  //   try {
  //     final response = await dioClient!
  //         .get(earningsEndPoint, skipAuth: false, queryParameters: query);
  //     return EarningsListResponse.fromJson(response);
  //   } catch (e) {
  //     return Future.error(NetworkExceptions.getDioException(e));
  //   }
  // }

  // Future makeEarningPaymentApiCall(
  //     {required Map<String, dynamic>? query, bool showLoader = true}) async {
  //   try {
  //     final response = await dioClient!.put(earningPaymentEndPoint,
  //         queryParameters: query, skipAuth: false, isLoading: showLoader);
  //     return StripPaymentResponseModel.fromJson(response);
  //   } catch (e) {
  //     return Future.error(NetworkExceptions.getDioException(e));
  //   }
  // }

  /*===================================================================== Register API Call  ==========================================================*/

  Future otherUserProfileApiCall(var id) async {
    try {
      final response = await dioClient!
          .get('$otherProfileEndPoint/$id/detail', skipAuth: false);
      return UserDataModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future forgetPassApiCall({required Map<String, dynamic>? dataBody}) async {
    try {
      final response = await dioClient!
          .post(forgotPassEndPoint, data: jsonEncode(dataBody), skipAuth: true);
      return MessageResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future resetPassApiCall({required Map<String, dynamic>? dataBody}) async {
    try {
      final response = await dioClient!
          .put(resetPassEndPoint, data: jsonEncode(dataBody), skipAuth: true);
      return MessageResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future changePassApiCall({required Map<String, dynamic>? dataBody}) async {
    try {
      final response = await dioClient!
          .put(changePassEndPoint, data: jsonEncode(dataBody), skipAuth: false);
      return MessageResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future markNotificationAsReadApiCall(var id) async {
    try {
      final response = await dioClient!
          .patch('$markReadEndPoint/$id', skipAuth: false, isLoading: false);
      return response;
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future markAllReadApiCall() async {
    try {
      final response =
          await dioClient!.patch(notificationEndPoint, skipAuth: false);
      return MessageResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future deleteNotificationApiCall(var id) async {
    try {
      final response = await dioClient!.delete(
          '$notificationDeleteEndPoint/$id',
          skipAuth: false,
          isLoading: false);
      return MessageResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future contactUsApiCall({required Map<String, dynamic>? dataBody}) async {
    try {
      final response = await dioClient!
          .post(contactUsEndPoint, data: jsonEncode(dataBody), skipAuth: true);
      return MessageResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future reportApiCall({required Map<String, dynamic>? dataBody}) async {
    try {
      final response = await dioClient!
          .post(reportEndPoint, data: jsonEncode(dataBody), skipAuth: false);
      return MessageResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future getFaqApiCall() async {
    try {
      final response = await dioClient!.get(faqEndPoint, skipAuth: false,queryParameters: {"status":userTypeDriver});
      return FaqListResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future addRatingApiCall({Map<String, dynamic>? dataBody}) async {
    try {
      final response = await dioClient!.post(
        reviewEndPoint,
        skipAuth: false,
        data: json.encode(dataBody),
      );
      return MessageResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

  Future reviewsListApiCall(var query) async {
    try {
      final response = await dioClient!
          .get(reviewEndPoint, skipAuth: false, queryParameters: query);
      return ReviewsListResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }



  Future messagesListApiCall({var chatId}) async {
    try {
      final response =
          await dioClient!.get('$chatEndPoint/$chatId/msg', skipAuth: false);
      return response;
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }





  Future getStaticPageApiCall(var type) async {
    try {
      final response = await dioClient!.get(staticPagesEndPoint,
          skipAuth: false,
          queryParameters: {'name': type, 'type':type==staticPageAboutUs?userTypeCustomer: userTypeDriver});
      return StaticPageResponseModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }
//

  Future<MediaUploadResponseModel?> mediaUploadApiCall(File file, {bool showLoader = true}) async {
    try {
      // Determine file type
      final type = getFileType(file.path);
      String mimeType;
      String subtype;

      switch (type) {
        case FileTypeEnum.image:
          mimeType = 'image';
          subtype = path.extension(file.path).toLowerCase().replaceFirst('.', '');
          break;
        case FileTypeEnum.pdf:
          mimeType = 'application';
          subtype = 'pdf';
          break;
        case FileTypeEnum.unknown:
        default:
          throw Exception('Unsupported file type');
      }

      // Create multipart file
      final multipart = await MultipartFile.fromFile(
        file.path,
        filename: path.basename(file.path),
        contentType: MediaType(mimeType, subtype),
      );

      // Create form data
      FormData formData = FormData.fromMap({"file": multipart});

      // Make API call
      var response = await dioClient!.post(
        fileUploadEndPoint,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
        isLoading: showLoader,
      );

      // Parse and return response
      return MediaUploadResponseModel.fromJson(response);
    } catch (e) {
      // Handle errors
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }
// //media upload api
//   Future mediaUploadApiCall(File file, {bool showLoader = true}) async {
//     try {
//       final type = getFileType(file.path);
//       final multipart = await MultipartFile.fromFile(file.path,
//           filename: file.path.split('/').last,
//           contentType:
//               MediaType(type.name, file.path.toLowerCase().split('.').last));
//
//       FormData formData = FormData.fromMap({"file": multipart});
//       var response = await dioClient!
//           .post(fileUploadEndPoint, data: formData, isLoading: showLoader);
//       return MediaUploadResponseModel.fromJson(response);
//     } catch (e) {
//       return Future.error(NetworkExceptions.getDioException(e));
//     }
//   }


  Future getLocationDetailApiCall(
      {LatLongModel? latLongModel, var placeId}) async {
    String host = 'https://maps.google.com/maps/api/geocode/json';
    String url;

    if (placeId != null) {
      url = '$host?key=$googleApiConst&language=en&place_id=$placeId';
    } else {
      url =
          '$host?key=$googleApiConst&language=en&latlng=${latLongModel?.lat},${latLongModel?.long}';
    }
    try {
      final response = await dioClient!.get(url, skipAuth: false);
      return LocationDetailDataModel.fromJson(response);
    } catch (e) {
      return Future.error(NetworkExceptions.getDioException(e));
    }
  }

//   Future generatePaymentMethodCall(
//       {required Map<String, dynamic> queryBody}) async {
//     try {
//       String? formBody = queryBody.keys
//           .map((key) =>
//               '${Uri.encodeComponent(key)}=${Uri.encodeComponent(queryBody[key]!)}')
//           .join('&');
//
//       final response = await dioClient!.post(
//         "https://api.stripe.com/v1/payment_methods",
//         data: formBody,
//         skipAuth: true,
//         isLoading: false,
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $stripeAccessKey',
//             'Content-Type': 'application/x-www-form-urlencoded',
//           },
//         ),
//       );
//       return PaymentMethodResponseModel.fromJson(response);
//     } catch (e, stackTrace) {
//       debugPrint(stackTrace.toString());
//       return Future.error(NetworkExceptions.getDioException(e));
//     }
//   }
}

enum FileTypeEnum { image, pdf, unknown }

FileTypeEnum getFileType(String filePath) {
  final extension = path.extension(filePath).toLowerCase();
  switch (extension) {
    case '.jpg':
    case '.jpeg':
    case '.png':
    case '.gif':
      return FileTypeEnum.image;
    case '.pdf':
      return FileTypeEnum.pdf;
    default:
      return FileTypeEnum.unknown;
  }
}

