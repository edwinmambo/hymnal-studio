abstract interface class SoundEngine {
  void resume();
  void playNote(int midiNote, {int transposeSemitones = 0, double durationSeconds = 0.5});
  void playChord(List<int> midiNotes, {int transposeSemitones = 0, double durationSeconds = 0.5});
  void stop();
  void dispose();
}
