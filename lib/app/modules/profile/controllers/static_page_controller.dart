import 'package:good_citizen/app/export.dart';
import 'package:good_citizen/app/modules/model/Static_model.dart';
import 'package:good_citizen/app/modules/profile/models/data_model/static_page_model.dart';
import 'package:good_citizen/app/modules/profile/models/response_models/static_page_response_model.dart';

class StaticPageController extends GetxController {
  String type = staticPageAboutUs;
  Rx<StaticModel?> notificationResponse = Rx<StaticModel?>(null);
  final String staticHtmlContent = """
<h2>Welcome to Good Citizen</h2>
<p>A mobile application developed to promote responsible civic behavior by notifying users when an ambulance is approaching, enabling them to make way and help save lives.</p>

<h3>1. Acceptance of Terms</h3>
<p>By downloading, installing, or using Good Citizen, you agree to comply with and be legally bound by these Terms. If you do not agree to these terms, please do not use the application.</p>

<h3>2. Service Description</h3>
<p>Good Citizen allows ambulance drivers to notify nearby app users about their presence and route so that users can take appropriate actions to clear the path for emergency vehicles.</p>

<h3>3. User Responsibilities</h3>
<ul>
  <li>Enable location services to receive real-time notifications.</li>
  <li>Use the app responsibly and not misuse the notification system.</li>
  <li>Do not attempt to interfere with the operation of the app.</li>
</ul>

<h3>4. Ambulance Driver Responsibilities</h3>
<ul>
  <li>Only verified ambulance drivers can trigger alert notifications.</li>
  <li>Drivers must use the feature only during genuine emergency transits.</li>
</ul>

<h3>5. Privacy</h3>
<p>We value your privacy. Good Citizen collects minimal location data solely to provide real-time alerts. Your location is not stored or shared beyond the purpose of alerting you when an ambulance is nearby. For more, refer to our <a href="#">Privacy Policy</a>.</p>

<h3>6. Limitations of Liability</h3>
<p>Good Citizen is a tool to assist public awareness and cannot guarantee all users will respond or act upon notifications. We are not liable for any incidents arising due to misuse or technical failures of the app.</p>

<h3>7. Modifications</h3>
<p>We reserve the right to modify these Terms at any time. Continued use of the app constitutes acceptance of the revised terms.</p>

<h3>8. Termination</h3>
<p>We may suspend or terminate access to the app for users or drivers who violate these Terms or misuse the system.</p>
""";

  final String ourMissionHtml = """
<h2>Our Mission</h2>
<p>
  At <strong>Good Citizen</strong>, we believe in the power of technology to make communities more compassionate and responsive. 
  Our mission is to assist emergency services by creating awareness and enabling faster, safer transit for ambulances through user notifications.
</p>

<h2>How It Works</h2>
<p>
  When a verified ambulance driver starts a journey, the Good Citizen app alerts nearby users along the route. 
  These alerts prompt users to clear the road ahead, ensuring that ambulances reach their destinations as quickly and safely as possible.
</p>

<h2>Why We Exist</h2>
<p>
  Time is critical in emergencies. Even a few seconds can save lives. 
  <strong>Good Citizen</strong> empowers every individual with a simple yet impactful way to contribute to emergency response—just by being aware and ready to act.
</p>

<h2>Join Us</h2>
<p>
  Whether you're a concerned citizen or an ambulance driver, Good Citizen invites you to be part of a movement that puts life first. 
  Because being a good citizen isn’t just about obeying rules—it’s about saving lives.
</p>
""";

  String get appBarTitle {
    switch (type) {
      case staticPageTC:
        return keyTermsConditions.tr;
      case staticPagePrivacy:
        return keyPrivacyPolicy;
      case staticPageLegal:
        return keyAccountLegal;
      default:
        return keyAboutUs.tr;
    }
  }

  @override
  void onInit() {
    _getArgs();
    super.onInit();
  }

  Future getContent({bool showLoader = true, required String? type}) async {
    debugPrint("Inside the notification history");
    try {
      if (showLoader) {
        customLoader.show(Get.context);
      }

      await repository.getContent(type: type).then((value) async {
        notificationResponse.value = value;
        print("value,>>>>>>>>>>>>>>$value");

        customLoader.hide();
      }).onError((error, stackTrace) {
        customLoader.hide();
      });
    } catch (e) {
      print(">>>>>>>>>>>>>$e");
    }
  }

  Rxn<StaticPageDataModel> staticPageModel = Rxn();
  RxBool isLoading = false.obs;

  void _getArgs() {
    if (Get.arguments != null) {
      type = Get.arguments["from"];
    }
  }

  @override
  void onReady() {
    getContent(
        type: type == "Terms"
            ? "TERMS_AND_CONDITIONS"
            : type == "Privacy"
                ? "PRIVACY_POLICY"
                : type == "EULA"
                    ? "YEARLY"
                    : "ABOUT_US");

    super.onReady();
  }

  // Future loadData({bool showLoader = true}) async {
  //   if (showLoader) {
  //     isLoading.value = true;
  //   }
  //   await repository.getStaticPageApiCall(type).then((value) async {
  //     isLoading.value = false;
  //     if (value != null) {
  //       StaticPageResponseModel staticPageResponseModel = value;
  //       staticPageModel.value = staticPageResponseModel.data;
  //     }
  //   }).onError((error, stackTrace) {
  //     isLoading.value = false;
  //   });
  // }
}
