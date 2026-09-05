// ignore_for_file: avoid_print
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;
import 'sound_engine_base.dart';

SoundEngine createSoundEngine() => _WebSoundEngine();

class _WebSoundEngine implements SoundEngine {
  web.AudioContext? _ctx;

  web.AudioContext _ensureContext() {
    if (_ctx == null) {
      _ctx = web.AudioContext();
      if (kDebugMode) {
        print('[SoundEngine] Created Web AudioContext (state: ${_ctx!.state})');
      }
    }
    if (_ctx!.state == 'suspended') {
      _ctx!.resume();
      if (kDebugMode) {
        print('[SoundEngine] Resumed AudioContext');
      }
    }
    return _ctx!;
  }

  @override
  void resume() {
    try {
      _ensureContext();
    } catch (e) {
      if (kDebugMode) {
        print('[SoundEngine] resume() error: $e');
      }
    }
  }

  @override
  void playNote(
    int midiNote, {
    int transposeSemitones = 0,
    double durationSeconds = 0.5,
  }) {
    playChord([midiNote], transposeSemitones: transposeSemitones, durationSeconds: durationSeconds);
  }

  @override
  void playChord(
    List<int> midiNotes, {
    int transposeSemitones = 0,
    double durationSeconds = 0.5,
  }) {
    try {
      final ctx = _ensureContext();
      final now = ctx.currentTime;
      final effectiveDuration = math.max(durationSeconds, 0.2);

      for (final rawNote in midiNotes) {
        final finalNote = rawNote + transposeSemitones;
        // Formula: frequency = 440 * 2^((N - 69) / 12)
        final frequency = 440.0 * math.pow(2.0, (finalNote - 69.0) / 12.0);

        // 1. Primary Pipe Organ / Acoustic Voice (Triangle wave)
        final osc1 = ctx.createOscillator();
        osc1.type = 'triangle';
        osc1.frequency.value = frequency;

        // 2. Harmonic Octave Overtone (Sine wave)
        final osc2 = ctx.createOscillator();
        osc2.type = 'sine';
        osc2.frequency.value = frequency * 2.0;

        // Gain node for ADSR shaping
        final gain = ctx.createGain();
        gain.gain.setValueAtTime(0.001, now);
        // Fast, smooth attack
        gain.gain.setTargetAtTime(0.22, now, 0.02);
        // Gentle acoustic release
        gain.gain.setTargetAtTime(0.0001, now + effectiveDuration * 0.7, 0.06);

        // Overtone gain (softer)
        final overtoneGain = ctx.createGain();
        overtoneGain.gain.value = 0.25;

        osc1.connect(gain);
        osc2.connect(overtoneGain);
        overtoneGain.connect(gain);
        gain.connect(ctx.destination);

        osc1.start(now);
        osc2.start(now);
        osc1.stop(now + effectiveDuration);
        osc2.stop(now + effectiveDuration);
      }
    } catch (e) {
      if (kDebugMode) {
        print('[SoundEngine] playChord error: $e');
      }
    }
  }

  @override
  void stop() {}

  @override
  void dispose() {
    try {
      _ctx?.close();
      _ctx = null;
    } catch (_) {}
  }
}
