import 'package:good_citizen/app/export.dart';
import 'package:good_citizen/app/modules/authentication/bindings/forget_password_binding.dart';
import 'package:good_citizen/app/modules/authentication/bindings/password_change_binding.dart';
import 'package:good_citizen/app/modules/authentication/bindings/select_signup_binding.dart';
import 'package:good_citizen/app/modules/authentication/bindings/signup_binding.dart';
import 'package:good_citizen/app/modules/authentication/views/forget_password_screen.dart';
import 'package:good_citizen/app/modules/authentication/views/password_change_screen.dart';
import 'package:good_citizen/app/modules/authentication/views/select_signup_screen.dart';
import 'package:good_citizen/app/modules/authentication/views/signup_screen.dart';


import 'package:good_citizen/app/modules/home_module/bindings/home_bindings.dart';
import 'package:good_citizen/app/modules/home_module/bindings/home_user_binding.dart';
import 'package:good_citizen/app/modules/home_module/bindings/picup_binding.dart';
import 'package:good_citizen/app/modules/home_module/bindings/tracking_binding.dart';
import 'package:good_citizen/app/modules/home_module/views/home_screen.dart';
import 'package:good_citizen/app/modules/home_module/views/home_user_screen.dart';
import 'package:good_citizen/app/modules/home_module/views/picup_destination_screen.dart';
import 'package:good_citizen/app/modules/home_module/views/tracking_screen.dart';
import 'package:good_citizen/app/modules/profile/bindings/edit_profile_bindings.dart';
import 'package:good_citizen/app/modules/profile/bindings/update_document_binding.dart';
import 'package:good_citizen/app/modules/profile/views/edit_item_screen.dart';
import 'package:good_citizen/app/modules/profile/views/my_documents_view_page.dart';
import 'package:good_citizen/app/modules/profile/views/static_page_screen.dart';
import 'package:good_citizen/app/modules/profile/views/update_document_view.dart';

import '../modules/authentication/bindings/driver_document_binding.dart';
import '../modules/authentication/views/changePassword_view.dart';
import '../modules/authentication/views/driver_document_screen.dart';
import '../modules/authentication/views/log_in_screen.dart';
import '../modules/authentication/views/otp_verify_screen.dart';
import '../modules/profile/bindings/profile_bindings.dart';
import '../modules/profile/views/profile_screen.dart';
import '../modules/splash/bindings/welcomescreen_binding.dart';
import '../modules/splash/views/welcom_screen.dart';



class AppPages {
  static const initial = AppRoutes.splashRoute;

  static final routes = [
    GetPage(
      name: AppRoutes.splashRoute,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.welcomeRoute,
      page: () => const OnBoardingView(),
      bindings: [OnBordingBinding()]
    ),
    GetPage(
      name: AppRoutes.loginRoute,
      page: () => const LogInScreen(),
      bindings: [LoginBindings()],
    ),
    GetPage(
      name: AppRoutes.selectSignUpRoute,
      page: () => SelectSignupScreen(),
      bindings: [SelectSignupBinding()],
    ),
    GetPage(
      name: AppRoutes.forgetPassword,
      page: () => const ForgetPasswordScreen(),
      bindings: [ForgetPasswordBinding()],
    ),
    GetPage(
      name: AppRoutes.otpVerifyRoute,
      page: () =>  OtpVerificationScreen(),
      bindings: [LoginBindings()],
    ),
    GetPage(
      name: AppRoutes.passwordChangeRoute,
      page: () => const PasswordChangeScreen(),
      bindings: [ChangePasswordBinding()],
    ),
    GetPage(
      name: AppRoutes.signupRoutes,
      page: () =>  SignupScreen(),
      bindings: [SignupBinding()],
    ),
    GetPage(
      name: AppRoutes.picupLocationScreen,
      page: () => const PicupDestinationScreen(),
      bindings: [PicupBinding()],
    ),

    GetPage(
      name: AppRoutes.profileRoute,
      page: () => const ProfileScreen(),
      bindings: [ProfileBindings()],
    ),

    GetPage(
        name: AppRoutes.homeRoute,
        page: () => HomeScreen(),
        binding: HomeBindings()),

    GetPage(
        name: AppRoutes.homeRouteUser,
        page: () => HomeScreenUser(),
        binding: HomeUserBindings()),

    GetPage(
      name: AppRoutes.editItemRoute,
      page: () => const EditProfileScreen(),
      bindings: [ProfileBindings()],
    ),

    GetPage(
      name: AppRoutes.trackingRoute,
      page: () =>  TrackingScreen(),
      bindings: [TrackingBinding()],
    ),


    GetPage(
      name: AppRoutes.staticPageRoute,
      page: () =>  StaticPageScreen(),
      bindings: [ProfileBindings()],
    ),


    GetPage(
      name: AppRoutes.myDocumentView,
      page: () =>  MyDocumentsViewPage(),
      bindings: [ProfileBindings()],
    ),

    GetPage(
      name: AppRoutes.editProfileRoute,
      page: () =>  EditProfileScreen(),
      bindings: [EditProfileBindings()],
    ),
    GetPage(
      name: AppRoutes.myDocsRoute,
      page: () =>  DriverDocumentScreen(),
      bindings: [DriverDocumentBinding()],
    ),
    GetPage(
      name: AppRoutes.changePasswordRouteUser,
      page: () =>  ChangepasswordScreen(),
      bindings: [ChangePasswordBinding()],
    ),
    GetPage(
      name: AppRoutes.updateDocumentRoute,
      page: () =>  UpdateDocumentView(),
      bindings: [UpdateDocumentBinding()],
    ),
  ];
}
