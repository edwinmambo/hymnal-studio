import 'package:flutter_test/flutter_test.dart';
import 'package:hymnal_studio/models/hymn.dart';
import 'package:hymnal_studio/services/catalog_repository.dart';

void main() {
  group('CatalogRepository Tests', () {
    late CatalogRepository repo;

    setUp(() {
      repo = CatalogRepository();
      repo.loadFromData(
        [
          const Hymn(
            id: 'cis-433',
            hymnalCode: 'CIS',
            hymnalName: 'Christ in Song',
            number: 433,
            title: 'Peace, Be Still!',
            author: 'Mary Ann Baker',
            rights: RightsRecord(type: RightsType.publicDomain),
            music: MusicResource(defaultKey: 'C'),
            sections: [
              HymnSection(
                type: 'verse',
                label: 'Verse 1',
                lines: ['Master, the tempest is raging!'],
              ),
            ],
          ),
          const Hymn(
            id: 'cis-511',
            hymnalCode: 'CIS',
            hymnalName: 'Christ in Song',
            number: 511,
            title: 'Dare to Be a Daniel',
            author: 'Philip P. Bliss',
            rights: RightsRecord(type: RightsType.publicDomain),
            music: MusicResource(defaultKey: 'Bb'),
            sections: [
              HymnSection(
                type: 'verse',
                label: 'Verse 1',
                lines: ['Standing by a purpose true'],
              ),
            ],
          ),
          const Hymn(
            id: 'ext-701',
            hymnalCode: 'EXT',
            hymnalName: 'SDAH Extended',
            number: 701,
            title: 'Till the Storm Passes By',
            author: 'Mosie Lister',
            rights: RightsRecord(type: RightsType.licensed),
            music: MusicResource(defaultKey: 'F'),
            sections: [
              HymnSection(
                type: 'verse',
                label: 'Verse 1',
                lines: ['In the dark of the midnight'],
              ),
            ],
          ),
        ],
        [
          {'code': 'CIS', 'name': 'Christ in Song'},
          {'code': 'EXT', 'name': 'SDAH Extended'},
        ],
      );
    });

    test('Searches by number jump', () {
      final results = repo.search(query: '433');
      expect(results.length, 1);
      expect(results.first.title, 'Peace, Be Still!');
    });

    test('Searches by hymnal code and number (cis 511)', () {
      final results = repo.search(query: 'cis 511');
      expect(results.length, 1);
      expect(results.first.title, 'Dare to Be a Daniel');
    });

    test('Fuzzy searches title and lyric contents', () {
      final stormResults = repo.search(query: 'storm');
      expect(stormResults.length, 1);
      expect(stormResults.first.id, 'ext-701');

      final tempestResults = repo.search(query: 'tempest');
      expect(tempestResults.length, 1);
      expect(tempestResults.first.id, 'cis-433');
    });

    test('Filters by hymnal code', () {
      final cisHymns = repo.search(hymnalFilter: 'CIS');
      expect(cisHymns.length, 2);

      final extHymns = repo.search(hymnalFilter: 'EXT');
      expect(extHymns.length, 1);
      expect(extHymns.first.number, 701);
    });
  });
}
