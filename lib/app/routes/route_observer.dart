import 'package:good_citizen/app/export.dart';

List<String> _routeHistoryList = [];

String? previousRoute;

void onRouteChanged(Routing? routing) {
  if (routing?.isBack ?? false) {
    final removed = previousRoute;
    final removeIndex =
        _routeHistoryList.indexWhere((element) => element == removed);
    if (removeIndex != -1) {
      _routeHistoryList.removeAt(removeIndex);
    }
  }

  final added = routing?.current;
  previousRoute = added;
  if (!_routeHistoryList.any((element) => element == added)) {
    _routeHistoryList.add(added ?? '');
  }
  final addIndex = _routeHistoryList.indexWhere((element) => element == added);
  if (addIndex == -1) {
    _routeHistoryList.add(added ?? '');
  }
  debugPrint('active routes>>> $_routeHistoryList');
}

clearRouteHistory() {
  _routeHistoryList.clear();
}

bool isRouteExist(String route) {
  final index = _routeHistoryList.indexWhere((element) => element == route);
  return index != -1;

  // if not -1 then exit
}
