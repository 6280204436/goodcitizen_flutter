import '../../export.dart';
import '../../modules/authentication/models/data_model/message_response_model.dart';
import '../../modules/location_provider/current_location_provider.dart';
import '../../modules/socket_controller/socket_controller.dart';


class NetworkExceptions {
  static String messageData = "";

  static void _navigateToLogin() {
    if (Get.currentRoute != AppRoutes.splashRoute &&
        Get.currentRoute != AppRoutes.loginRoute &&
        Get.currentRoute != AppRoutes.welcomeRoute&&  Get.currentRoute != AppRoutes.otpVerifyRoute) {
      Get.offAllNamed(AppRoutes.loginRoute);
      preferenceManager.clearLoginData();
      // Get.delete<SocketController>();
      Get.delete<CurrentLocationProvider>();
    }

  }

  static getDioException(error, {bool returnMap = false}) {
    if (error is Exception) {
      try {
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              return messageData = keyRequestCancelled.tr;
            case DioExceptionType.connectionTimeout:
              return messageData = keyConnectionTimeOut.tr;
            case DioExceptionType.connectionError:
              if (error.error is SocketException) {
                final socketException = error.error as SocketException;
                if (socketException.osError?.errorCode == 61 ||
                    socketException.osError?.errorCode == 111) {
                  return messageData = keyUnableToConnect.tr;
                }
                return messageData = keyNoInternetConnection.tr;
              } else {
                return messageData = keyNoInternetConnection.tr;
              }

            case DioExceptionType.unknown:
              List<String> dateParts = error.message!.split(":");
              List<String> message = dateParts[2].split(",");
              if (message[0].trim() == keyConnectionRefused.tr) {
                return messageData = keyServerUnderMaintenance.tr;
              } else if (message[0].trim() == keyNetworkUnReachable.tr) {
                return messageData = keyNetworkUnReachable.tr;
              } else if (dateParts[1].trim() == keyFailedToHostLookup.tr) {
                return messageData = keyNoInternetConnection.tr;
              } else if (error.message == null) {
                return messageData = keyNoInternetConnection.tr;
              } else {
                return messageData = dateParts[1];
              }
            case DioExceptionType.receiveTimeout:
              return messageData = keyTimeOut.tr;
            case DioExceptionType.badResponse:
              switch (error.response!.statusCode) {
                case 400:
                  debugPrint('Error type of data: ${error.response?.data}');
                  Map<String, dynamic> data = error.response?.data;

                  if (data.containsKey('statusCode') &&
                      data.containsKey('message')) {
                    return messageData = data['message'];
                  } else if (data.isNotEmpty &&
                      data.values.elementAt(0).runtimeType == String) {
                    if (returnMap) {
                      return data;
                    }
                    return messageData = data.values.elementAt(0);
                  } else {
                    if (data.length > 1 && data.values.elementAt(1) == null) {
                      var dataValue =
                          MessageResponseModel.fromJson(error.response?.data)
                              .message;
                      return messageData =
                          dataValue ?? keyUnauthorizedRequest.tr;
                    } else if (data.length > 1) {
                      Map<String, dynamic> datas = data.values.elementAt(1);
                      if (returnMap) {
                        return datas;
                      }

                      return messageData = datas.values.first[0];
                    } else {
                      return messageData = keyUnauthorizedRequest
                          .tr; // Fallback in case of unexpected data structure
                    }
                  }
                case 401:
                  try {
                    _navigateToLogin();

                    debugPrint('errror type of data${error.response?.data}');
                    Map<String, dynamic> data = error.response?.data;

                    if (data.values.length == 2 &&
                        data.values.elementAt(1) == 'BLOCKED') {
                      return MessageResponseModel(
                          message: data.values.elementAt(0),
                          errorCode: data.values.elementAt(1));
                    }

                    if (data.values.elementAt(0).runtimeType == String) {
                      return messageData = data.values.elementAt(0);
                    } else {
                      Map<String, dynamic> datas = data.values.elementAt(1);
                      if (data.values.elementAt(1) == null) {
                        var dataValue =
                            MessageResponseModel.fromJson(error.response?.data)
                                .message;
                        return dataValue == null
                            ? messageData = keyUnauthorizedRequest.tr
                            : messageData = dataValue;
                      } else {
                        return messageData = datas.values.first[0];
                      }
                    }
                  } catch (err) {
                    return messageData = 'Unauthorised Exception';
                  }
                case 402:
                  debugPrint('Error type of data: ${error.response?.data}');
                  Map<String, dynamic> data = error.response?.data;

                  if (data.containsKey('statusCode') &&
                      data.containsKey('message')) {
                    return messageData = data['message'];
                  } else if (data.isNotEmpty &&
                      data.values.elementAt(0).runtimeType == String) {
                    return messageData = data.values.elementAt(0);
                  } else {
                    if (data.length > 1 && data.values.elementAt(1) == null) {
                      var dataValue =
                          MessageResponseModel.fromJson(error.response?.data)
                              .message;
                      return messageData =
                          dataValue ?? keyUnauthorizedRequest.tr;
                    } else if (data.length > 1) {
                      Map<String, dynamic> datas = data.values.elementAt(1);
                      return messageData = datas.values.first[0];
                    } else {
                      return messageData = keyUnauthorizedRequest
                          .tr; // Fallback in case of unexpected data structure
                    }
                  }
                case 403:
                  _navigateToLogin();
                  try {
                    return messageData = error.response?.data['message'] ??
                        'Unauthorised Exception';
                  } catch (err) {
                    return messageData = 'Unauthorised Exception';
                  }
                case 404:
                  return messageData = keyNotFound.tr;
                case 408:
                  return messageData = keyRequestTimeOut.tr;
                case 500:
                  return messageData = keyInternalServerError.tr;
                case 503:
                  return messageData = keyServiceUnavailable.tr;
                default:
                  return messageData = keySomethingWrong.tr;
              }
            case DioExceptionType.sendTimeout:
              return messageData = keyTimeOut.tr;
            case DioExceptionType.badCertificate:
            // TODO: Handle this case.
              break;
            case DioExceptionType.badResponse:
            // TODO: Handle this case.
              break;
            case DioExceptionType.connectionError:
              return messageData = keyNoInternetConnection.tr;
              break;
          }
        } else if (error is SocketException) {
          return messageData = keySocketExceptions.tr;
        } else {
          return messageData = keyUnExceptedException.tr;
        }
      } on FormatException catch (_) {
        return messageData = keyFormatException.tr;
      } catch (_) {
        return messageData = keyUnExceptedException.tr;
      }
    } else {
      return error.toString().contains("not a subtype")
          ? messageData = keyUnableToProcessData.tr
          : messageData = keyUnableToProcessData.tr;
    }
  }
}
