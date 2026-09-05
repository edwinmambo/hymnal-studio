import 'sound_engine_base.dart';

SoundEngine createSoundEngine() => _StubSoundEngine();

class _StubSoundEngine implements SoundEngine {
  @override
  void resume() {}

  @override
  void playNote(int midiNote, {int transposeSemitones = 0, double durationSeconds = 0.5}) {}

  @override
  void playChord(List<int> midiNotes, {int transposeSemitones = 0, double durationSeconds = 0.5}) {}

  @override
  void stop() {}

  @override
  void dispose() {}
}
