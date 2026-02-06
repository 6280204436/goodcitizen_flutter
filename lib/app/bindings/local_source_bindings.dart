import 'package:good_citizen/app/export.dart';

class LocalSourceBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreferenceManager>(
          () => PreferenceManager(),
      fenix: true,
    );
  }
}
