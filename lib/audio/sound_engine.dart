import 'sound_engine_base.dart';
import 'sound_engine_stub.dart'
    if (dart.library.js_interop) 'sound_engine_web.dart'
    as impl;

export 'sound_engine_base.dart';

SoundEngine createSoundEngine() => impl.createSoundEngine();
