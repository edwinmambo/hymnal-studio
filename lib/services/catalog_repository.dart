import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hymnal_studio/models/hymn.dart';

class CatalogRepository {
  List<Hymn> _songs = [];
  List<Map<String, String>> _hymnals = [];
  bool _isLoaded = false;

  List<Hymn> get songs => List.unmodifiable(_songs);
  List<Map<String, String>> get hymnals => List.unmodifiable(_hymnals);
  bool get isLoaded => _isLoaded;

  Future<void> loadCatalog() async {
    if (_isLoaded) return;
    try {
      final jsonString = await rootBundle.loadString('assets/catalog/hymnals.json');
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      _hymnals = (data['hymnals'] as List<dynamic>?)
              ?.map((e) => {
                    'code': e['code'].toString(),
                    'name': e['name'].toString(),
                    'description': e['description']?.toString() ?? '',
                  })
              .toList() ??
          [];

      _songs = (data['songs'] as List<dynamic>?)
              ?.map((e) => Hymn.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

      _isLoaded = true;
    } catch (e) {
      // Fallback empty or rethrow
      _songs = [];
      _hymnals = [];
      _isLoaded = true;
    }
  }

  void loadFromData(List<Hymn> songs, List<Map<String, String>> hymnals) {
    _songs = List.from(songs);
    _hymnals = List.from(hymnals);
    _isLoaded = true;
  }

  List<Hymn> search({
    String query = '',
    String? hymnalFilter,
  }) {
    final cleanQuery = query.trim().toLowerCase();

    return _songs.where((hymn) {
      if (hymnalFilter != null &&
          hymnalFilter.isNotEmpty &&
          hymnalFilter != 'ALL' &&
          hymn.hymnalCode.toUpperCase() != hymnalFilter.toUpperCase()) {
        return false;
      }

      if (cleanQuery.isEmpty) return true;

      // Exact or prefix number match
      if (int.tryParse(cleanQuery) != null) {
        final queryNum = int.parse(cleanQuery);
        if (hymn.number == queryNum) return true;
        if (hymn.number.toString().startsWith(cleanQuery)) return true;
      }

      // Check hymnal code + number (e.g. "cis 433" or "cis433")
      final hymnalPrefixMatch = RegExp(r'^([a-zA-Z]+)\s*(\d+)$');
      final match = hymnalPrefixMatch.firstMatch(cleanQuery);
      if (match != null) {
        final code = match.group(1)!;
        final num = int.parse(match.group(2)!);
        if (hymn.hymnalCode.toLowerCase() == code && hymn.number == num) {
          return true;
        }
      }

      // Search in title, author, scripture, and lyrics
      return hymn.searchIndex.contains(cleanQuery);
    }).toList();
  }

  Hymn? findById(String id) {
    try {
      return _songs.firstWhere((h) => h.id == id);
    } catch (_) {
      return null;
    }
  }

  Hymn? findByNumber(String hymnalCode, int number) {
    try {
      return _songs.firstWhere(
        (h) => h.hymnalCode.toUpperCase() == hymnalCode.toUpperCase() && h.number == number,
      );
    } catch (_) {
      return null;
    }
  }
}
