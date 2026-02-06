export 'dart:async';


/*=============================================== base exports =============================================*/
export 'package:good_citizen/app/core/values/app_global_values.dart';
export 'package:good_citizen/app/core/values/app_theme.dart';
export 'package:good_citizen/app/core/values/app_colors.dart';
export  'package:good_citizen/app/core/values/app_strings.dart';
export 'package:good_citizen/app/core/values/app_assets.dart';
export 'package:good_citizen/app/core/utils/validators.dart';


/* ================================================app constants ===========================================*/
export 'package:good_citizen/app/core/values/app_values.dart';
export 'package:good_citizen/app/core/values/text_styles.dart';
export 'package:good_citizen/app/core/values/app_constants.dart';


/*=================================================== widgets =============================================*/

export 'package:good_citizen/app/core/widgets/custom_loader.dart';
export 'package:good_citizen/app/core/widgets/text_view_widget.dart';

export 'package:good_citizen/app/core/widgets/asset_svg.dart';
export 'package:good_citizen/app/core/widgets/cupertino_time_picker.dart';
export 'package:good_citizen/app/core/utils/helper_widget.dart';
export 'package:good_citizen/app/core/widgets/toast_float.dart';
export 'package:good_citizen/app/core/widgets/asset_image.dart';
export 'package:good_citizen/app/core/widgets/custom_button.dart';
export 'package:pinput/pinput.dart';
export 'package:good_citizen/app/core/widgets/custom_tf.dart';
export 'package:good_citizen/app/modules/authentication/widgets/authentication_app_bar.dart';
export 'package:good_citizen/app/core/widgets/custom_Gradient_Text.dart';
export 'package:good_citizen/app/core/widgets/intl_phone_field/country_picker_text_field.dart';
export 'package:good_citizen/app/core/widgets/text_field_widget.dart';
export 'package:good_citizen/app/core/widgets/custom_app_bar.dart';


/*==================================================== local services =====================================*/
export 'package:good_citizen/app/data/local/preferences/preference.dart';
export 'package:good_citizen/app/core/utils/localizations/localizations.dart';




/*================================================== dio client ======================================*/
export 'package:good_citizen/app/data/repository/api_repository.dart';
export 'package:good_citizen/app/logger/log_interceptor.dart';
export 'package:logger/logger.dart';
export 'package:good_citizen/app/data/repository/dio_client.dart';
export 'package:good_citizen/app/data/repository/endpoint.dart';


/*============================================ third parties libraries ====================================*/
export 'package:flutter/material.dart';
export 'package:flutter_easyloading/flutter_easyloading.dart';
export 'package:flutter/cupertino.dart' hide RefreshCallback;
export 'package:flutter_svg/flutter_svg.dart' hide Svg;
export 'package:flutter_svg_provider/flutter_svg_provider.dart' show Svg;
export 'dart:io';
export 'package:device_info_plus/device_info_plus.dart';
export 'package:dio/dio.dart';
export 'package:package_info_plus/package_info_plus.dart';
export 'package:flutter/foundation.dart';
// export 'package:dio/io.dart';
// export 'dart:ui' hide Codec;
export 'package:flutter/rendering.dart';
export 'package:flutter/scheduler.dart' hide Flow;
export 'package:flutter/gestures.dart';
export 'package:image_picker/image_picker.dart';
export 'package:permission_handler/permission_handler.dart';



/* =============================================dart, flutter and getx =====================================*/
export 'package:flutter/services.dart';
export 'package:get_storage/get_storage.dart';
export 'package:flutter_screenutil/flutter_screenutil.dart';
export 'package:get/get.dart'
    hide Response, HeaderValue, MultipartFile, FormData;
export 'dart:convert';


/* ==================================================app routes ===========================================*/
export 'package:good_citizen/app/routes/app_pages.dart';
export 'package:good_citizen/app/routes/app_routes.dart';
export 'package:good_citizen/main.dart';



/*================================================== application binding =====================================*/
export 'package:good_citizen/app/bindings/initial_binding.dart';
export 'package:good_citizen/app/bindings/local_source_bindings.dart';
export 'package:good_citizen/app/bindings/repository_bindings.dart';
export 'package:good_citizen/app/modules/authentication/bindings/sign_in_bindings.dart';



/*============================================== application screens =====================================*/
export 'package:good_citizen/my_app.dart';
export 'package:good_citizen/app/modules/splash/views/splash_screen.dart';




/*============================================== application controllers =====================================*/
export 'package:good_citizen/app/modules/splash/controllers/splash_controller.dart';
export 'package:good_citizen/app/modules/splash/controllers/welcome_controller.dart';



/* =========================================== application widgets=====================================================*/


/* =========================================== request model=====================================================*/


/* =========================================== response model=====================================================*/



/* =========================================== data model=====================================================*/

