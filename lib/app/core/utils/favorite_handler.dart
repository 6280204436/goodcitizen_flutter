// import 'package:good_citizen/app/export.dart';
//
// void toggleFavoriteHandler(
//     {required RxList<dynamic> list,
//     required int index,
//     required String type,
//     List<RxList<RvDataModel>?>? extraLists}) {
//   // list[index].isLike = !(list[index].isLike ?? true);
//   // list.refresh();
//   //
//   // if (extraLists != null && extraLists.isNotEmpty) {
//   //   for (var iterList in extraLists) {
//   //     final i =
//   //         iterList?.indexWhere((element) => (element.sId == list[index].sId));
//   //     if (i != null && i != -1) {
//   //       iterList?[i].isLike = list[index].isLike;
//   //       iterList?.refresh();
//   //     }
//   //   }
//   // }
//
//   // debouncer.call(() {
//   //   _setFavUnFav(list[index].sId, type);
//   // });
//
//   list[index].isLike == true
//       ? _removeFromFav(index: index, type: type, list: list)
//       : _addToFav(index: index, type: type, list: list);
// }
//
// void _addToFav(
//     {required RxList<dynamic> list,
//     required int index,
//     required String type,
//     List<RxList<RvDataModel>?>? extraLists}) {
//   list[index].isLoadingLike = true;
//   list.refresh();
//   final paramData = RvRequestModels.toggleFavRequestData(
//       id:list[index].runtimeType==RvDataModel?list[index].sId: list[index].likeFor.sId  , type: type);
//   repository.addToFavorite(requestData: paramData).then((value) async {
//     if (value != null) {
//       list[index].isLoadingLike = false;
//       list[index].isLike = true;
//       list.refresh();
//     }
//   }).onError((error, stackTrace) {
//     list[index].isLoadingLike = false;
//     list.refresh();
//     // showSnackBar(message: error.toString());
//   });
// }
//
// void _removeFromFav(
//     {required RxList<dynamic> list,
//     required int index,
//     required String type,
//     List<RxList<RvDataModel>?>? extraLists}) {
//   list[index].isLoadingLike = true;
//   list.refresh();
//
//   repository
//       .removeFavorite(list[index].runtimeType==RvDataModel?list[index].sId: list[index].likeFor.sId)
//       .then((value) async {
//     if (value != null) {
//       list[index].isLoadingLike = false;
//       list[index].isLike = false;
//       if(list[index].runtimeType!=RvDataModel)
//         {
//           list.removeAt(index);
//         }
//       list.refresh();
//     }
//   }).onError((error, stackTrace) {
//     list[index].isLoadingLike = false;
//     list.refresh();
//     // showSnackBar(message: error.toString());
//   });
// }
//
// Widget showBgLoader({double? size, double? loaderSize,Color? bgColor,Color? loaderColor}) {
//   return Container(
//     height: size ?? height_28,
//     width: size ?? height_28,
//     decoration: BoxDecoration(color:bgColor?? whiteAppColor, shape: BoxShape.circle),
//     child: Platform.isIOS
//         ? CupertinoActivityIndicator(
//       color:loaderColor?? appColor,
//       radius: loaderSize ?? height_7,
//     )
//         : CircularProgressIndicator(
//       color:loaderColor?? appColor,
//       strokeWidth: margin_1point5,
//
//     ).paddingAll(margin_6+margin_0point4),
//   );
// }
