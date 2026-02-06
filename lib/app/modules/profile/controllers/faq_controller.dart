import 'package:good_citizen/app/export.dart';

import '../models/data_model/faq_model.dart';
import '../models/response_models/faq_response_model.dart';

class FaqController extends GetxController {
  RxList<FaqDataModel> faqList = <FaqDataModel>[].obs;

  RxBool isLoading = false.obs;

  @override
  void onReady() {
    loadFaq(showLoader: true);
    super.onReady();
  }

  Future loadFaq({bool showLoader = false}) async {
    if (showLoader) {
      isLoading.value = true;
    }
    await repository.getFaqApiCall().then((value) async {
      isLoading.value = false;
      if (value != null) {
        FaqListResponseModel faqListResponseModel = value;
        faqList.value = faqListResponseModel.data ?? [];
      }
    }).onError((error, stackTrace) {
      showSnackBar(message: error.toString());
      isLoading.value = false;
    });
  }
}
