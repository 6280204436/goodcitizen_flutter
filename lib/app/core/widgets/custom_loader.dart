import 'package:good_citizen/app/export.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class CustomLoader {
  static CustomLoader? _loader;

  CustomLoader._createObject();

  factory CustomLoader() {
    if (_loader != null) {
      return _loader!;
    } else {
      _loader = CustomLoader._createObject();
      return _loader!;
    }
  }

  OverlayState? _overlayState;
  OverlayEntry? _overlayEntry;

  _buildLoader() {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              child: buildLoader(),
              color: Colors.black.withOpacity(.4),
            )
          ],
        );
      },
    );
  }

  show(context) {
    hide();
    _overlayState = Overlay.of(context);
    _buildLoader();
    _overlayState!.insert(_overlayEntry!);
  }

  hide() {
    try {
      if (_overlayEntry != null) {
        _overlayEntry!.remove();
        _overlayEntry = null;
      }
    } catch (_) {}
  }

  buildLoader({isTransparent = false}) {
    return WillPopScope(
      onWillPop: () {
        customLoader.hide();
        return Future.value(true);
      },
      child: Center(
        child: Container(
          color: isTransparent ? Colors.transparent : Colors.transparent,
          child: Center(
              child:SpinKitPulsingGrid(color: whiteAppColor)?? CircularProgressIndicator(
                color: AppColors.appColor,
                backgroundColor: Colors.white,
              )), //CircularProgressIndicator(),
        ),
      ),
    );
  }
}
