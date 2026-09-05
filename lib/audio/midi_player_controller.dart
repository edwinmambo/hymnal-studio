import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hymnal_studio/audio/sound_engine.dart';
import 'package:hymnal_studio/models/hymn.dart';
import 'package:hymnal_studio/presentation/slide_formatter.dart';

class MidiPlayerController extends ChangeNotifier {
  final SoundEngine _soundEngine = createSoundEngine();

  bool _isPlaying = false;
  int _currentNoteIndex = 0;
  int _transposeSemitones = 0;
  int _bpm = 100;
  Timer? _playbackTimer;
  Hymn? _currentHymn;

  bool get isPlaying => _isPlaying;
  int get currentNoteIndex => _currentNoteIndex;
  int get transposeSemitones => _transposeSemitones;
  int get bpm => _bpm;
  Hymn? get currentHymn => _currentHymn;

  String get transposedKey {
    if (_currentHymn == null) return 'C';
    final baseKey = _currentHymn!.music.defaultKey;
    if (_transposeSemitones == 0) return baseKey;
    return SlideFormatter.transposeRootNote(baseKey, _transposeSemitones);
  }

  void setHymn(Hymn hymn) {
    if (_currentHymn?.id == hymn.id) return;
    stop();
    _currentHymn = hymn;
    _bpm = hymn.music.defaultBpm;
    _transposeSemitones = 0;
    _currentNoteIndex = 0;
    notifyListeners();
  }

  void setTranspose(int semitones) {
    _transposeSemitones = semitones.clamp(-6, 6);
    notifyListeners();
  }

  void setBpm(int newBpm) {
    _bpm = newBpm.clamp(50, 160);
    if (_isPlaying) {
      _restartTimer();
    }
    notifyListeners();
  }

  void togglePlay() {
    if (_isPlaying) {
      pause();
    } else {
      play();
    }
  }

  void play() {
    if (_currentHymn == null) return;
    _soundEngine.resume();
    _isPlaying = true;
    _restartTimer();
    notifyListeners();
  }

  void pause() {
    _isPlaying = false;
    _playbackTimer?.cancel();
    _playbackTimer = null;
    notifyListeners();
  }

  void stop() {
    _isPlaying = false;
    _currentNoteIndex = 0;
    _playbackTimer?.cancel();
    _playbackTimer = null;
    _soundEngine.stop();
    notifyListeners();
  }

  void _restartTimer() {
    _playbackTimer?.cancel();
    // Milliseconds per beat = (60000 / BPM)
    final intervalMs = (60000 / _bpm).round();

    // Play immediate first note
    _playCurrentTick(intervalMs);

    _playbackTimer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
      _playCurrentTick(intervalMs);
    });
  }

  void _playCurrentTick(int intervalMs) {
    final notes = _currentHymn?.music.melodyNotes;
    int noteToPlay;

    if (notes == null || notes.isEmpty) {
      const defaultMelody = [60, 64, 67, 69, 67, 64, 65, 67, 65, 64, 62, 60];
      noteToPlay = defaultMelody[_currentNoteIndex % defaultMelody.length];
      _currentNoteIndex = (_currentNoteIndex + 1) % defaultMelody.length;
    } else {
      noteToPlay = notes[_currentNoteIndex % notes.length];
      _currentNoteIndex = (_currentNoteIndex + 1) % notes.length;
    }

    // Rich 3-part organ chord: Melody + Tenor/Alto harmonic support + Pedal Bass (-12 semitones)
    final chordNotes = <int>[
      noteToPlay,
      if (noteToPlay >= 60) noteToPlay - 12, // pedal octave bass
    ];

    _soundEngine.playChord(
      chordNotes,
      transposeSemitones: _transposeSemitones,
      durationSeconds: (intervalMs / 1000.0) * 0.90,
    );

    notifyListeners();
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    _soundEngine.dispose();
    super.dispose();
  }
}
