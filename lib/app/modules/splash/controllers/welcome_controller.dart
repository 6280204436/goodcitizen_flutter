import 'package:good_citizen/app/export.dart';
import 'package:good_citizen/app/modules/splash/widgets/onboarding_item.dart';
import 'package:geolocator/geolocator.dart';

class OnBoardingController extends GetxController {
  RxList<OnBoardingItem> listItem = RxList.empty();
  RxInt selectedIndex = 0.obs;
  Rx<PageController> pageController = PageController(initialPage: 0).obs;

  @override
  void onInit() {
    _addData();
    toLocation();
    super.onInit();
  }

  _addData() {
    listItem.clear();
    listItem.add(OnBoardingItem(
        image: iconSplashBackground,
        heading: "Express Your Creativity",
        subheading: "Express Your Creativity With Our App and Using Our Premium Services Loerm"));
    listItem.add(OnBoardingItem(
        image: iconSplashBackground,
        heading: "Express Your Creativity",
        subheading: "Express Your Creativity With Our App and Using Our Premium Services Loerm"));
    listItem.add(OnBoardingItem(
        image: iconSplashBackground,
        heading: "Express Your Creativity",
        subheading: "Express Your Creativity With Our App and Using Our Premium Services Loerm"));
  }

  void movePageController() {
    if (selectedIndex.value <= 1) {
      selectedIndex.value++;
      pageController.value.animateToPage(
          selectedIndex.value,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut);
      pageController.refresh();
    } else {
      moveToSignUpPage();
    }
  }

  void prevPageController() {
    if (selectedIndex.value != 0) {
      selectedIndex.value--;
      pageController.value.animateToPage(
          selectedIndex.value,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut);
      pageController.refresh();
    }
  }

  void moveToSignUpPage() {
    Get.offAllNamed(AppRoutes.selectSignUpRoute);
  }

  void skipPage() {}

  Future<void> toLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("Location Services Disabled", "Please enable location services to use this feature.");
      return;
    }

    // Check for permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Permission Denied", "Location access is required for the app to function properly.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Permission Denied Forever", "Please enable location permissions from settings.");
      return;
    }

    // Get current location
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      // Get.snackbar("Location Access Granted", "Your location: ${position.latitude}, ${position.longitude}");
    } catch (e) {
      Get.snackbar("Error", "Failed to get location: $e");
    }
  }

}
