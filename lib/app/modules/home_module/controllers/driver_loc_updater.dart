import '../../../../main.dart';
import '../../../data/repository/endpoint.dart';
import '../../authentication/models/auth_request_model.dart';

// void updateDriverLocation(double? lat, double? long,
//     {double? heading, bool isSocket = false}) async {
//   profileDataProvider.userDataModel.value?.latitude = lat;
//   profileDataProvider.userDataModel.value?.longitude = long;
//   profileDataProvider.updateData(profileDataProvider.userDataModel.value);
//   final data = AuthRequestModel.updateDriverLocation(
//       long: long, lat: lat, heading: heading,token: preferenceManager.getAuthToken());
//   // if (isSocket) {
//   //   socketController.socketEmit(event: socketEventUpdateLocation, data: data);
//   // } else {
//   //   repository
//   //       .updateDriverLocationApiCall(queryParams: data, showLoader: false)
//   //       .then((value) {})
//   //       .onError(
//   //         (error, stackTrace) {},
//   //       );
//   // }
// }
