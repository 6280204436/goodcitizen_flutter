import 'dart:developer' as dev;

import 'package:socket_io_client/socket_io_client.dart';

import '../../../remote_config.dart';
import '../../export.dart';

class SocketController extends GetxController {
  late Socket _socket;

  Map<String, Function(dynamic data)?> socketListeners = {};

  @override
  void onInit() {
    print("Socket Controller initiallize");
    _connectSocket();
    super.onInit();
  }

  void _connectSocket() {
    var token = preferenceManager.getAuthToken();
    if (token == null) {
      dev.log('Token is null, socket not connected');
      return;
    }

    _socket = io(
        baseUrl,
        OptionBuilder().setTransports(['websocket']).setExtraHeaders(
            {'token': '$token'}).setQuery({
          'type': 'flutter' // Added parameter
        }).build());
    dev.log('Socket Connection Established111');
    if (!_socket.connected) {
      _socket.connect();
      print("Socket Controller Connected");
      _addSocketConnectionEvents();

    }

    // _addSocketConnectionEvents();

  }

  void _addSocketConnectionEvents() {
    _socket.onConnect((_) {
      dev.log('Socket Connection Established');
       socketEmit(event: socketEventConnected);
    });
    _socket.onDisconnect((_) {
      dev.log('Socket Connection Disconnected');
       socketEmit(event: socketEventDisconnected);
    });
    _socket.onConnectError((err) {
      dev.log('Socket Connection Error >> $err');
      // if (!_socket.connected) {
      //   _socket.connect();
      // }
    });
    _socket.onError((err) => dev.log('Socket Error >> $err'));
  }

  void socketEmit({required String event, dynamic data}) {
    dev.log("Event Emitted >>> $event");
    if (data != null) {
      dev.log("Data Emitted >>> $data");
    }

    _socket.emit(event, data);
  }

  void addSocketEventListener(
      {required String event, Function(dynamic data)? onEvent}) {
    _socket.on(event, (data) {
      if (data != null) {
        dev.log("Data Received on $event >>> $data");
        onEvent?.call(data);
      }
    });


  }

  void _attachListeners() {
    socketListeners.forEach(
      (key, value) {
        _socket.on(key, (data) {
          if (data != null) {
            dev.log("Data Received on $key >>> $data");
            value?.call(data);
          }
        });
      },
    );
  }



  void disconnectSocket() {
    if (_socket.connected) {
      _socket.disconnect();
    }
  }

  Future reConnectSocket({bool showLoader = false}) async {
    if (showLoader) {
      customLoader.show(Get.context);
    }
    _socket.disconnect();
    await Future.delayed(
      const Duration(milliseconds: 300),
          () {
        _socket.connect();
      },
    );
    await Future.delayed(
      const Duration(milliseconds: 350),
          () {
        if (showLoader) {
          customLoader.hide();
        }
      },
    );
  }


  @override
  void onClose() {
    disconnectSocket();
    _socket.dispose();
    super.onClose();
  }
}
