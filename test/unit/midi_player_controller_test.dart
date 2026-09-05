import 'package:flutter_test/flutter_test.dart';
import 'package:hymnal_studio/audio/midi_player_controller.dart';
import 'package:hymnal_studio/models/hymn.dart';

void main() {
  group('MidiPlayerController Tests', () {
    late MidiPlayerController controller;
    const testHymn = Hymn(
      id: 'cis-433',
      hymnalCode: 'CIS',
      hymnalName: 'Christ in Song',
      number: 433,
      title: 'Peace, Be Still!',
      rights: RightsRecord(type: RightsType.publicDomain),
      music: MusicResource(
        defaultKey: 'C',
        defaultBpm: 84,
        melodyNotes: [60, 64, 67],
      ),
      sections: [],
    );

    setUp(() {
      controller = MidiPlayerController();
      controller.setHymn(testHymn);
    });

    tearDown(() {
      controller.dispose();
    });

    test('Initializes with hymn default key and bpm', () {
      expect(controller.currentHymn?.id, 'cis-433');
      expect(controller.transposedKey, 'C');
      expect(controller.bpm, 84);
      expect(controller.isPlaying, false);
      expect(controller.transposeSemitones, 0);
    });

    test('Transposition calculates shifted key correctly', () {
      controller.setTranspose(2); // C + 2 = D
      expect(controller.transposedKey, 'D');

      controller.setTranspose(4); // C + 4 = E
      expect(controller.transposedKey, 'E');

      controller.setTranspose(5); // C + 5 = F
      expect(controller.transposedKey, 'F');

      controller.setTranspose(-2); // C - 2 = Bb
      expect(controller.transposedKey, 'Bb');
    });

    test('Clamps transposition within reasonable semitone bounds (-6 to +6)', () {
      controller.setTranspose(12);
      expect(controller.transposeSemitones, 6);

      controller.setTranspose(-10);
      expect(controller.transposeSemitones, -6);
    });

    test('BPM updates and clamps within safe bounds', () {
      controller.setBpm(110);
      expect(controller.bpm, 110);

      controller.setBpm(200);
      expect(controller.bpm, 160);

      controller.setBpm(30);
      expect(controller.bpm, 50);
    });

    test('Play and Pause toggles state', () {
      expect(controller.isPlaying, false);
      controller.play();
      expect(controller.isPlaying, true);
      controller.pause();
      expect(controller.isPlaying, false);
      controller.stop();
      expect(controller.isPlaying, false);
      expect(controller.currentNoteIndex, 0);
    });
  });
}
