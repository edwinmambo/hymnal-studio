import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hymnal_studio/models/hymn.dart';
import 'package:hymnal_studio/presentation/slide_formatter.dart';

class MidiPlayerController extends ChangeNotifier {
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
    notifyListeners();
  }

  void _restartTimer() {
    _playbackTimer?.cancel();
    // Milliseconds per beat = (60000 / BPM)
    final intervalMs = (60000 / _bpm).round();
    _playbackTimer = Timer.periodic(Duration(milliseconds: intervalMs), (
      timer,
    ) {
      final notes = _currentHymn?.music.melodyNotes;
      if (notes == null || notes.isEmpty) {
        _currentNoteIndex = (_currentNoteIndex + 1) % 12;
      } else {
        _currentNoteIndex = (_currentNoteIndex + 1) % notes.length;
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    super.dispose();
  }
}
