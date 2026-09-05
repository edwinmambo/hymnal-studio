abstract interface class WorshipCastServer {
  bool get isRunning;
  int get port;
  String get hostIp;
  int get clientCount;
  String get displayUrl;
  Stream<Map<String, dynamic>> get localStream;

  Future<bool> start({int preferredPort = 8080});
  Future<void> stop();
  void broadcast(Map<String, dynamic> message);
  void openDisplayWindow();
}
