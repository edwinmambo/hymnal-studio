import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'package:web/web.dart' as web;
import 'worship_cast_server_base.dart';

WorshipCastServer createWorshipCastServer() => _WebWorshipCastServer();

class _WebWorshipCastServer implements WorshipCastServer {
  final StreamController<Map<String, dynamic>> _localStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
  web.BroadcastChannel? _webChannel;
  bool _isRunning = false;

  @override
  bool get isRunning => _isRunning;

  @override
  int get port => 8080;

  @override
  String get hostIp => 'localhost';

  @override
  int get clientCount => 1;

  @override
  String get displayUrl =>
      Uri.base.replace(queryParameters: {'display': '1'}).toString();

  @override
  Stream<Map<String, dynamic>> get localStream => _localStreamController.stream;

  @override
  Future<bool> start({int preferredPort = 8080}) async {
    _webChannel = web.BroadcastChannel('hymnal_studio_cast');
    _isRunning = true;
    return true;
  }

  @override
  Future<void> stop() async {
    _webChannel?.close();
    _webChannel = null;
    _isRunning = false;
  }

  @override
  void broadcast(Map<String, dynamic> message) {
    _localStreamController.add(message);
    if (_webChannel != null) {
      final payload = jsonEncode(message);
      _webChannel!.postMessage(payload.toJS);
    }
  }

  @override
  void openDisplayWindow() {
    web.window.open(
      displayUrl,
      'hymnal_studio_display',
      'popup=yes,width=1280,height=720',
    );
  }
}
