import 'package:good_citizen/app/modules/authentication/models/response_models/forget_password_response_model.dart';
import 'package:good_citizen/app/modules/authentication/models/response_models/signup_datamodel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:good_citizen/app/push_notifications/fcm_notifications_controller.dart';

import '../../../common_data.dart';
import '../../../core/widgets/intl_phone_field/countries.dart';
import '../../../export.dart';
import '../models/auth_request_model.dart';
import '../models/data_model/message_response_model.dart';
import '../models/data_model/user_model.dart';
import '../models/response_models/ResendOtpResponse.dart';
import '../models/response_models/user_response_model.dart';

class OtpVerificationController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late OTPTextEditController otpController;
  late OTPInteractor _otpInteractor;

  late FocusNode pinFocusNode;
  UserResponseModel? userResponseModel;
  ResendOtpResponse?forgetPasswordResponseModel;
  SignupModel? signupModel;
  bool isEdit = false;
  bool isForEmail = false;

  RxBool forceErrorState = false.obs;

  String? phoneNumber;
  Country? selectedCountry;
  String? email;
  String? from;

  UserResponseModel?
      socialLoginResponse; // when we have to verify phone on case of social login

  late Timer _timer;
  RxInt leftDuration = 30.obs;
  RxBool isTimerStarted = true.obs;
  RxBool isLoading = false.obs;
  RxBool isResendingOtp = false.obs;

  @override
  void onInit() {
    _getArgs();
    _initOtpReader();
    _initControllers();
    super.onInit();
  }

  void _getArgs() {
    if (Get.arguments != null) {
      // isForEmail = Get.arguments[argBool] ?? false;
      // phoneNumber = Get.arguments[argData];
      // selectedCountry = Get.arguments[argData2];
      email = Get.arguments["email"];
      from = Get.arguments["from"];
      isEdit = Get.arguments[argFromProfile] ?? false;
    }
  }

  @override
  void onReady() {
    startTimer();
    super.onReady();
  }

  void _initOtpReader() async {
    _initInteractor();
    _initOtpController();
  }

  Future<void> _initInteractor() async {
    _otpInteractor = OTPInteractor();
    // final appSignature = await _otpInteractor.getAppSignature();
  }

  void _initOtpController() {
    otpController = OTPTextEditController(
      codeLength: 6,
      // onCodeReceive: (code) => _autoValidate(),
      autoStop: true,
      otpInteractor: _otpInteractor,
    );

    // ..startListenUserConsent(
    //   (code) {
    //     final exp = RegExp(r'(\d{4})');
    //     return exp.stringMatch(code ?? '') ?? '';
    //   },
    // );
  }

  void startTimer({bool reset = false}) {
    if (reset) {
      leftDuration.value = 30;
    }
    isTimerStarted.value = true;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (leftDuration.value == 0) {
          timer.cancel();
          isTimerStarted.value = false;
        } else {
          leftDuration.value--;
        }
      },
    );
  }




  void validate() {
    if (formKey.currentState!.validate()) {

      from!="other"?

       _verifyEmail():

        _forgetverifyEmail();




    }
  }


  void _forgetverifyEmail() async {
    customLoader.show(Get.context);

    final data = AuthRequestModel.forgetemailVerifyRequestModel(
        otp: otpController.text.trim(), email:email);
    repository.forgetverifyEmailApiCall(dataBody: data).then((value) {
      customLoader.hide();
      signupModel = value;

      // // _saveData(userResponseModel);
       preferenceManager.saveAuthToken(signupModel?.accessToken);
      Get.toNamed(AppRoutes.passwordChangeRoute);


    }).onError((error, stackTrace) {
      otpController.clear();
      customLoader.hide();
      showSnackBar(message: error.toString());
    });
  }



  void _verifyEmail() async {
    customLoader.show(Get.context);
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    String? token = await messaging.getToken();
    final data = AuthRequestModel.emailVerifyRequestModel(
        otp: otpController.text.trim(), fcmtoken:token);
    repository.verifyEmailApiCall(dataBody: data).then((value) {
      customLoader.hide();
      userResponseModel = value;

     print( userResponseModel?.data?.role?.toUpperCase());
      preferenceManager.saveAuthToken(userResponseModel?.data?.accessToken );
      if(userResponseModel?.data?.role?.toUpperCase()=="USER"){
        Get.toNamed(AppRoutes.homeRouteUser);
      }else{
        Get.toNamed(AppRoutes.myDocsRoute);
      }




    }).onError((error, stackTrace) {
      otpController.clear();
      customLoader.hide();
      showSnackBar(message: error.toString());
    });
  }


  void _saveData(UserResponseModel? userResponseModel) {

    // if (userResponseModel?.accesstoken != null) {
    //   preferenceManager.saveAuthToken(userResponseModel?.accesstoken );
    //   Get.toNamed(AppRoutes.homeRoute);
    // }
    //
    // profileDataProvider.updateData(userResponseModel?.data);
    // _handleNavigation(userResponseModel?.data);
  }

  // void _handleNavigation(UserDataModel? userModel) {
  //   profileDataProvider.updateData(userModel);
  //   Future.delayed(
  //     const Duration(milliseconds: 200),
  //     () {
  //       loadVehicleTypes();
  //     },
  //   );
  //   if (isEdit) {
  //     Get.back();
  //     Get.back();
  //     return;
  //   }
  //
  //   if (userModel?.isEmailVerify == true) {
  //     if (userModel?.setUpVehicle == true) {
  //       Get.offAllNamed(AppRoutes.homeRoute);
  //     } else {
  //       Get.offNamed(AppRoutes.addVehicleDetailsRoute);
  //     }
  //   } else {
  //     Get.offNamed(AppRoutes.addUserDetailsRoute);
  //   }
  // }

  void resendOtp() {
    otpController.clear();

    _resendForEmail();

  }



  void _resendForEmail() {
    Map<String, dynamic> requestModel =
        AuthRequestModel.forgePassRequestModel(
          email:email,
    );
    repository
        .resendOtpApiCall(dataBody: requestModel)
        .then((value) async {
          forgetPasswordResponseModel=value;
          print("Token:>>>>>>>>>>>${forgetPasswordResponseModel?.data?.accessToken}");
         preferenceManager.saveAuthToken(forgetPasswordResponseModel?.data?.accessToken );
      //
      startTimer(reset: true);
      if (value != null) {
        showSnackBar(message: keyOtpResent);
      }
    }).onError((error, stackTrace) {
      isResendingOtp.value = false;
      showSnackBar(message: error.toString());
    });
  }

  @override
  void onClose() {
    _timer.cancel();
    _disposeControllers();
    Get.delete<OtpVerificationController>();
    super.onClose();
  }

  void _initControllers() {
    // otpController = TextEditingController();
    pinFocusNode = FocusNode();
  }

  void _disposeControllers() {
    // otpController.dispose();
    pinFocusNode.dispose();
  }
}
