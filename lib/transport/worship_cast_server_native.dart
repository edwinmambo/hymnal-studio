import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'worship_cast_server_base.dart';

WorshipCastServer createWorshipCastServer() => _NativeWorshipCastServer();

class _NativeWorshipCastServer implements WorshipCastServer {
  HttpServer? _server;
  final Set<WebSocketChannel> _clients = {};
  final StreamController<Map<String, dynamic>> _localStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  int _port = 8080;
  String _hostIp = '127.0.0.1';
  bool _isRunning = false;
  Map<String, dynamic>? _lastState;

  @override
  bool get isRunning => _isRunning;

  @override
  int get port => _port;

  @override
  String get hostIp => _hostIp;

  @override
  int get clientCount => _clients.length;

  @override
  String get displayUrl => 'http://$_hostIp:$_port';

  @override
  Stream<Map<String, dynamic>> get localStream => _localStreamController.stream;

  @override
  Future<bool> start({int preferredPort = 8080}) async {
    if (_isRunning) return true;

    _port = preferredPort;
    await _detectLocalIp();

    final wsHandler = webSocketHandler((WebSocketChannel webSocket) {
      _clients.add(webSocket);

      // Send the latest state to newly connected client immediately
      if (_lastState != null) {
        webSocket.sink.add(jsonEncode(_lastState));
      }

      webSocket.stream.listen(
        (message) {},
        onDone: () => _clients.remove(webSocket),
        onError: (_) => _clients.remove(webSocket),
      );
    });

    final handler = const Pipeline()
        .addMiddleware(logRequests())
        .addHandler((Request request) {
      if (request.url.path == 'ws') {
        return wsHandler(request);
      }
      if (request.url.path == 'api/status') {
        return Response.ok(
          jsonEncode({'status': 'online', 'clients': _clients.length}),
          headers: {'content-type': 'application/json'},
        );
      }
      // Serve the standalone HTML5 display client for any browser / Smart TV
      return Response.ok(
        _renderDisplayHtml(),
        headers: {'content-type': 'text/html; charset=utf-8'},
      );
    });

    try {
      _server = await shelf_io.serve(handler, InternetAddress.anyIPv4, _port);
      _isRunning = true;
      return true;
    } catch (e) {
      try {
        _port = 8088;
        _server = await shelf_io.serve(handler, InternetAddress.anyIPv4, _port);
        _isRunning = true;
        return true;
      } catch (err) {
        _isRunning = false;
        return false;
      }
    }
  }

  @override
  Future<void> stop() async {
    for (final client in _clients) {
      client.sink.close();
    }
    _clients.clear();
    await _server?.close(force: true);
    _server = null;
    _isRunning = false;
  }

  @override
  void broadcast(Map<String, dynamic> message) {
    _lastState = message;
    _localStreamController.add(message);

    final payload = jsonEncode(message);
    final deadClients = <WebSocketChannel>[];

    for (final client in _clients) {
      try {
        client.sink.add(payload);
      } catch (_) {
        deadClients.add(client);
      }
    }
    _clients.removeAll(deadClients);
  }

  @override
  void openDisplayWindow() {}

  Future<void> _detectLocalIp() async {
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLoopback: false,
      );
      for (final iface in interfaces) {
        for (final addr in iface.addresses) {
          if (!addr.isLoopback && addr.address.startsWith('192.') ||
              addr.address.startsWith('10.') ||
              addr.address.startsWith('172.')) {
            _hostIp = addr.address;
            return;
          }
        }
      }
    } catch (_) {
      _hostIp = '127.0.0.1';
    }
  }

  String _renderDisplayHtml() {
    return '''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Hymnal Studio • Audience Display</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      background: #0f172a;
      color: #ffffff;
      font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, Roboto, sans-serif;
      overflow: hidden;
      width: 100vw;
      height: 100vh;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      user-select: none;
      transition: background 0.5s ease;
    }

    body.theme-midnight { background: radial-gradient(circle at center, #1e293b 0%, #090d16 100%); }
    body.theme-warmGold { background: radial-gradient(circle at center, #292524 0%, #0c0a09 100%); color: #fef08a; }
    body.theme-sapphire { background: radial-gradient(circle at center, #1e3a8a 0%, #030712 100%); }
    body.theme-pureBlack { background: #000000; color: #ffffff; }

    #container {
      width: 90vw;
      max-width: 1400px;
      text-align: center;
      transition: opacity 0.3s ease, transform 0.3s ease;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
    }

    #badge {
      font-size: 1.5rem;
      font-weight: 700;
      letter-spacing: 0.1em;
      text-transform: uppercase;
      color: #38bdf8;
      margin-bottom: 2rem;
      opacity: 0.9;
    }

    #lyrics {
      font-size: clamp(2.4rem, 5.5vw, 4.8rem);
      font-weight: 600;
      line-height: 1.35;
      text-shadow: 0 4px 16px rgba(0, 0, 0, 0.7);
      word-break: break-word;
    }

    .lyric-line {
      margin-bottom: 0.4em;
    }

    #footer {
      position: absolute;
      bottom: 24px;
      font-size: 1.2rem;
      color: rgba(255, 255, 255, 0.4);
      letter-spacing: 0.05em;
    }

    .blackout { background: #000000 !important; }
    .blackout #container, .blackout #footer { opacity: 0 !important; }
    .cleared #lyrics, .cleared #badge { opacity: 0 !important; }

    #status-pill {
      position: absolute;
      top: 16px;
      right: 16px;
      background: rgba(16, 185, 129, 0.2);
      border: 1px solid rgba(16, 185, 129, 0.5);
      color: #34d399;
      font-size: 12px;
      padding: 4px 10px;
      border-radius: 9999px;
      display: flex;
      align-items: center;
      gap: 6px;
      opacity: 0.4;
      transition: opacity 0.2s ease;
    }
    #status-pill:hover { opacity: 1; }
    .dot { width: 8px; height: 8px; border-radius: 50%; background: #34d399; }
  </style>
</head>
<body class="theme-midnight">
  <div id="status-pill"><div class="dot"></div>Connected</div>
  <div id="container">
    <div id="badge">Hymnal Studio</div>
    <div id="lyrics">Ready for Presentation</div>
  </div>
  <div id="footer"></div>

  <script>
    const container = document.getElementById('container');
    const badge = document.getElementById('badge');
    const lyrics = document.getElementById('lyrics');
    const footer = document.getElementById('footer');
    const statusPill = document.getElementById('status-pill');

    function connect() {
      const loc = window.location;
      const wsUrl = (loc.protocol === 'https:' ? 'wss://' : 'ws://') + loc.host + '/ws';
      const ws = new WebSocket(wsUrl);

      ws.onopen = () => {
        statusPill.style.display = 'flex';
      };

      ws.onmessage = (event) => {
        try {
          const data = JSON.parse(event.data);
          handleEvent(data);
        } catch (e) {
          console.error(e);
        }
      };

      ws.onclose = () => {
        statusPill.style.display = 'none';
        setTimeout(connect, 2000);
      };
    }

    function handleEvent(data) {
      if (data.type === 'SLIDE') {
        document.body.classList.remove('cleared');
        document.body.classList.remove('blackout');

        badge.innerText = data.hymnalCode + ' #' + data.hymnNumber + ' • ' + data.sectionLabel;
        
        lyrics.innerHTML = data.lines
          .map(line => '<div class="lyric-line">' + escapeHtml(line) + '</div>')
          .join('');

        footer.innerText = data.title + ' (' + (data.slideIndex + 1) + '/' + data.totalSlides + ')';
      } else if (data.type === 'BLACKOUT') {
        if (data.value) {
          document.body.classList.add('blackout');
        } else {
          document.body.classList.remove('blackout');
        }
      } else if (data.type === 'CLEAR') {
        if (data.value) {
          document.body.classList.add('cleared');
        } else {
          document.body.classList.remove('cleared');
        }
      } else if (data.type === 'THEME') {
        document.body.className = 'theme-' + data.theme;
      }
    }

    function escapeHtml(str) {
      return str.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
    }

    document.addEventListener('dblclick', () => {
      if (!document.fullscreenElement) {
        document.documentElement.requestFullscreen().catch(() => {});
      } else {
        document.exitFullscreen().catch(() => {});
      }
    });

    connect();
  </script>
</body>
</html>''';
  }
}
