import 'worship_cast_server_base.dart';
import 'worship_cast_server_native.dart'
    if (dart.library.js_interop) 'worship_cast_server_web.dart'
    as impl;

export 'worship_cast_server_base.dart';

WorshipCastServer createWorshipCastServer() => impl.createWorshipCastServer();
