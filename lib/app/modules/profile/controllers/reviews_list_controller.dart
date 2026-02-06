import '../../../export.dart';
import '../../authentication/models/auth_request_model.dart';
import '../models/data_model/rating_model.dart';
import '../models/response_models/reviews_list_model.dart';

class ReviewsListController extends GetxController {
  int pageNumber = 1;
  ScrollController scrollController = ScrollController();

  Rxn<ReviewsListResponseModel> reviewsListResponseModel = Rxn();
  RxList<RatingModel> reviewsList = <RatingModel>[].obs;
  RxBool isLoading = true.obs;
  bool _isHittingApi = false;

  @override
  void onInit() {
    _pagination();
    super.onInit();
  }

  _pagination() {
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (isLoading.value == false) {
          if (reviewsList.length <
              ((reviewsListResponseModel.value?.count ?? 0).toInt())) {
            isLoading.value = true;
            await loadReviews(showLoader: false);
            pageNumber++;
          } else {
            isLoading.value = false;
          }
        }
      }
    });
  }

  @override
  void onReady() {
    loadReviews();
    super.onReady();
  }

  Future loadReviews({bool showLoader = true}) async {
    if (_isHittingApi) {
      return;
    }
    _isHittingApi = true;
    if (showLoader) {
      isLoading.value = true;
    }
    final data = AuthRequestModel.paginationRequest(page: pageNumber);
    await repository.reviewsListApiCall(data).then((value) async {
      _isHittingApi = false;
      isLoading.value = false;
      if (value != null) {
        reviewsListResponseModel.value = value;
        if (pageNumber == 1) {
          reviewsList.value = reviewsListResponseModel.value?.data ?? [];
          pageNumber = 2;
        } else {
          reviewsList.addAll(reviewsListResponseModel.value?.data ?? []);
        }
      }
    }).onError((error, stackTrace) {
      _isHittingApi = false;
      isLoading.value = false;
    });
  }
}
