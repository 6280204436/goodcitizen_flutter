import 'package:good_citizen/app/export.dart';

class RepositoryBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<APIRepository>(
          () => APIRepository(),
      fenix: true,
    );
  }
}
