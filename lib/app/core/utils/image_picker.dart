import 'package:good_citizen/app/core/widgets/show_dialog.dart';
import 'package:good_citizen/app/export.dart';
// import 'package:image_cropper/image_cropper.dart';

class MediaUtils {
  static Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.request();
    return status == PermissionStatus.granted;
  }

  static Future<void> _showPermissionDeniedDialog() async {
    showAlertDialogNew(
      title: keyPermDenied.tr,
      subtitle: keyPermDeniedDes.tr,
      buttonText: keyGoToSettings,
      onTap: () {
        Get.back();
        openAppSettings();
      },
    );
  }

  static Future<bool> _checkAndRequestPermissions(
      {ImageSource source = ImageSource.gallery}) async {
    if (Platform.isAndroid) {
      return true;
    }

    if (source == ImageSource.camera) {
      final cameraStatus = await Permission.camera.status;
      if (cameraStatus.isPermanentlyDenied) {
        await _showPermissionDeniedDialog();
        return false;
      }

      final cameraPermission =
          cameraStatus.isGranted || await _requestPermission(Permission.camera);
      return cameraPermission;
    }

    if (source == ImageSource.gallery) {
      final storageStatus = await Permission.storage.status;
      if (storageStatus.isPermanentlyDenied ) {
        await _showPermissionDeniedDialog();
        return false;
      }
      final storagePermission = storageStatus.isGranted ||
          await _requestPermission(Permission.storage);
      return storagePermission;
    }
    return false;
  }

  static Future<File?> pickImage(
      {ImageSource source = ImageSource.gallery,
        bool crop = true}) async {
    if (!await _checkAndRequestPermissions(source: source)) {
      return null;
    }
    try {
      dynamic file;
      if (crop) {
      //   file = await _cropImage(await ImagePicker().pickImage(source: source));
      // } else {
        file = await ImagePicker().pickImage(source: source);
      }
      if (file != null) {
        return File(file.path);
      }
      return null;
    } on PlatformException {
      await _showPermissionDeniedDialog();
    } catch (e) {
      debugPrint('error $e');
    }
  }

  static Future<List<XFile?>?> pickMultiImages(
      {bool crop = true, int limit = 12}) async {
    if (!await _checkAndRequestPermissions(source: ImageSource.gallery)) {
      return null;
    }

    customLoader.show(Get.context);
    final list = await ImagePicker().pickMultiImage(imageQuality: 50);

    customLoader.hide();
    return list;
  }

  static Future<File?> pickVideo(
      {ImageSource source = ImageSource.camera}) async {
    if (!await _checkAndRequestPermissions(source: source)) {
      return null;
    }

    final file = await ImagePicker()
        .pickVideo(source: source, maxDuration: const Duration(seconds: 16));
    if (file != null) {
      if (source == ImageSource.gallery) {
        String videoFilePath = file.path;
        return File(file.path);
      }
    } else {
      return File(file?.path ?? '');
    }
    return null;
  }

  // static Future<CroppedFile?> _cropImage(XFile? file) async {
  //   if (file == null) {
  //     return null;
  //   }
  //
  //   return await ImageCropper().cropImage(
  //     sourcePath: file.path,
  //     aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
  //     uiSettings: [
  //       AndroidUiSettings(
  //         toolbarTitle: strAppName,
  //         toolbarColor: AppColors.appColor,
  //         showCropGrid: false,
  //         toolbarWidgetColor: Colors.white,
  //         lockAspectRatio: true,
  //       ),
  //       IOSUiSettings(
  //         title: strAppName,
  //         aspectRatioLockEnabled: true,
  //       ),
  //       WebUiSettings(
  //         context: Get.context!,
  //       ),
  //     ],
  //   );
  // }
}
