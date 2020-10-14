import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  IO.Socket _socket;
  ServerStatus _serverStatus = ServerStatus.Connecting;

  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;
  ServerStatus get serverStatus => this._serverStatus;

  SocketService() {
    this._initConfig();
  }

  void _initConfig() {
    // Dart client
    // IO.Socket socket = IO.io('http://localhost:3000/', <String, dynamic>{
    this._socket = IO.io('http://192.168.0.102:3000/', <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': {'foo': 'bar'},
      'autoConnect': true
    });
    this._socket.on('connect', (_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    this._socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }
}
