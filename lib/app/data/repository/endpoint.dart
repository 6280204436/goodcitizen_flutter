

//auth endpoints
const String signUpEndPoint = "v1/app/signup";
const String startRideEndPoint = "v1/driver/start-ride";
const String rideDetailsEndPoint = "v1/driver/ride-detail";
const String endRideEndPoint = "v1/driver/end-ride";
const String logInEndPoint = "v1/app/login";
const String forgetEndPoint = "v1/app/forgot-password";
const String emailVerifyEndPoint = "v1/app/verify/forgot-password/otp";
const String resendOtpEndPoint = "v1/app/resend-otp";
const String setPasswordEndPoint = "v1/app/reset/forgot-password";
const String verificationEndPoint = "v1/app/verify/otp";
const String editProfileEndPoint = "v1/app/update-profile";
const String DocumentEndPoint = "v1/driver/upload/verification";
const String socialLoginEndPoint = "auth/social-login";
const String phoneVerifyEndPoint = "auth/verify-phone";
const String editPhoneVerifyEndPoint = "auth/verify-edit-phone";

const String updateProfileDataEndPoint = "auth/edit-profile"; //patch
// const String updateFCMTokenEndPoint = "auth/update/fcm/token";

const String getProfileEndPoint = "v1/app/profile";
const String fileUploadEndPoint = "v1/s3-manager/upload";
const String logoutEndPoint = "v1/app/logout";
const String deleteAccEndPoint = "auth/delete/account";

//configuration
const String configurationEndPoint = "v1/user/profile";
const String getNotificationEndPoint = "v1/user/notification";
const String getContentEndPoint = "v1/app/content";
const String DeleteAccountEndPoint = "v1/app/delete-account";
//vehicle types
const String vehicleTypesEndPoint = "vehicle/types";

//driver apis
const String addVehicleEndPoint = "driver/set-vehicle-detail";
const String editVehicleEndPoint = "driver/edit-vehicle-detail";
const String getVehicleEndPoint = "driver/get-all-vehicle";
const String getVehicleDetailEndPoint = "driver/get-vehicle-detail";
const String updateLicDataEndPoint = "driver/edit-licence"; //patch
const String driverStateEndPoint = "driver/go-online/offline";
const String driverUpdateLocationEndPoint = "driver/update/location";

const String signInEndPoint = "signin";
const String deActivateAccEndPoint = "user/deactivate";
const String otherProfileEndPoint = "user";

const String resendPhoneOtpEndPoint = "resend-phone-otp";
const String forgotPassEndPoint = "forget-password";
const String forgotPassVerifyOtpEndPoint = "verify-otp";
const String resetPassEndPoint = "reset-password";
const String changePassEndPoint = "change-password";
const String deleteAccountEndPoint = "/user/delete-account";
const String addRatingEndPoint = "/feedback";
const String reviewsListEndPoint = "/feedback/feedback_for";
const String contactUsEndPoint = "/contactus";
const String reportEndPoint = "/report";
const String faqEndPoint = "/faq/for/apps";
const String analysisEndPoint = "/history-analysis";
const String storeDetailEndPoint = "/store";

const String staticPagesEndPoint = "/content-page/{type}/{slug}";

//activate vehicle
const String activateVehicleEndPoint = "/driver/make/vehicle/active";

//bank
const String bankEndPoint = "/bank";

//document
const String uploadDocumentEndPoint = "/document";
const String getDocumentEndPoint = "/document/user";

//booking
const String bookingEndPoint = "/booking";
const String acceptBookingEndPoint = "/booking/accept-booking";
const String declineBookingEndPoint = "/booking/decline-booking";
const String changeRideStatusEndPoint = "/booking/ride/status";
const String completeRideEndPoint = "/booking/ride-completed";
const String markPaymentEndPoint = "/booking/recived/payment";

//review
const String earningsEndPoint = "/earning";
const String earningPaymentEndPoint = "/earning/make/payment";

//review
const String reviewEndPoint = "/review";

//chat
const String chatEndPoint = "/chat";

//comments
const String commentsEndPoint = "/product/comment";

//stripe

const String stripeCreateCustomerEndPoint = "/stripe/create-customer";
const String addCardEndPoint = "/stripe/add-card";
const String cardsListEndPoint = "/stripe/card";

//Log exceptions and crashes
const logCrashesExceptionsEndPoint = "logger/log/exception";

//notifications
const String notificationEndPoint = "/notification";
const String markReadEndPoint = "/notification";
const String notificationDeleteEndPoint = "/notification";

//static pages url
const String staticPageTCUrl = "https://dreamsgrant.com/terms-conditions/";
const String staticPageAboutUrl = "https://dreamsgrant.com/about-us/";
const String staticPagePrivacyUrl = "https://dreamsgrant.com/privacy-policy/";
const String staticPageReturnUrl = "https://dreamsgrant.com/return-policy/";
const String staticPageDeliveryUrl = "https://dreamsgrant.com/delivery-policy/";

///socket events
const String socketEventConnected = "connected";
const String socketEventDisconnected = "disconnected";
const String socketEventNewRideRequest = "current_ride_request";
const String socketEventBookingRequested = "socket_booking_accepted";
const String socketEventFindDriver = "find-driver";
const String socketEventUpdateLocation = "update_location";
const String socketEventBookingUpdate = "booking_detail";
const String socketEventCreateConnection = "create-connection";
const String socketEventCloseConnection = "leave-connection";
const String socketEventGetAllMessages = "getAllMessages";
const String socketEventSendMessage = "send-message";
const String socketEventGetMessage = "get_message";
const String socketEventGetUnreadMessageCount = "UnreadMessage";
const String socketEventMarkAsRead = "ReadMessages";
const String socketEventUpdateCharges = "waiting_charge_noti";
