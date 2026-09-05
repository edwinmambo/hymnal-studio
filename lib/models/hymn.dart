enum RightsType {
  publicDomain,
  licensed,
  userProvided,
}

class RightsRecord {
  final RightsType type;
  final String? rightsHolder;
  final String? licenseNotice;
  final String? verifiedAt;

  const RightsRecord({
    required this.type,
    this.rightsHolder,
    this.licenseNotice,
    this.verifiedAt,
  });

  factory RightsRecord.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String? ?? 'publicDomain';
    final type = RightsType.values.firstWhere(
      (e) => e.name == typeStr,
      orElse: () => RightsType.publicDomain,
    );
    return RightsRecord(
      type: type,
      rightsHolder: json['rightsHolder'] as String?,
      licenseNotice: json['licenseNotice'] as String?,
      verifiedAt: json['verifiedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.name,
        if (rightsHolder != null) 'rightsHolder': rightsHolder,
        if (licenseNotice != null) 'licenseNotice': licenseNotice,
        if (verifiedAt != null) 'verifiedAt': verifiedAt,
      };
}

class HymnSection {
  final String type; // 'verse', 'chorus', 'bridge', 'refrain'
  final int? number;
  final String label;
  final List<String> lines;
  final List<String>? chords;

  const HymnSection({
    required this.type,
    this.number,
    required this.label,
    required this.lines,
    this.chords,
  });

  bool get isChorus => type == 'chorus' || type == 'refrain';

  factory HymnSection.fromJson(Map<String, dynamic> json) {
    return HymnSection(
      type: json['type'] as String? ?? 'verse',
      number: json['number'] as int?,
      label: json['label'] as String? ?? (json['type'] == 'chorus' ? 'Chorus' : 'Verse'),
      lines: (json['lines'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      chords: (json['chords'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        if (number != null) 'number': number,
        'label': label,
        'lines': lines,
        if (chords != null) 'chords': chords,
      };
}

class MusicResource {
  final String? midiAsset;
  final String? scoreAsset;
  final String defaultKey;
  final String? tuneName;
  final String? meter;
  final int defaultBpm;
  final List<int>? melodyNotes; // MIDI note numbers for synthesized preview

  const MusicResource({
    this.midiAsset,
    this.scoreAsset,
    this.defaultKey = 'C',
    this.tuneName,
    this.meter,
    this.defaultBpm = 100,
    this.melodyNotes,
  });

  factory MusicResource.fromJson(Map<String, dynamic> json) {
    return MusicResource(
      midiAsset: json['midiAsset'] as String?,
      scoreAsset: json['scoreAsset'] as String?,
      defaultKey: json['defaultKey'] as String? ?? 'C',
      tuneName: json['tuneName'] as String?,
      meter: json['meter'] as String?,
      defaultBpm: json['defaultBpm'] as int? ?? 100,
      melodyNotes: (json['melodyNotes'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        if (midiAsset != null) 'midiAsset': midiAsset,
        if (scoreAsset != null) 'scoreAsset': scoreAsset,
        'defaultKey': defaultKey,
        if (tuneName != null) 'tuneName': tuneName,
        if (meter != null) 'meter': meter,
        'defaultBpm': defaultBpm,
        if (melodyNotes != null) 'melodyNotes': melodyNotes,
      };
}

class Hymn {
  final String id; // e.g. "sdah-100", "cis-433"
  final String hymnalCode; // "SDAH", "CIS", "EXT", "KM", "UE", "NZK"
  final String hymnalName;
  final int number;
  final String title;
  final String? originalTitle;
  final String? author;
  final String? composer;
  final String? scripture;
  final String? historyNote;
  final RightsRecord rights;
  final MusicResource music;
  final List<HymnSection> sections;

  const Hymn({
    required this.id,
    required this.hymnalCode,
    required this.hymnalName,
    required this.number,
    required this.title,
    this.originalTitle,
    this.author,
    this.composer,
    this.scripture,
    this.historyNote,
    required this.rights,
    required this.music,
    required this.sections,
  });

  String get searchIndex =>
      '$number ${hymnalCode.toLowerCase()}$number $title ${author ?? ''} ${composer ?? ''} ${scripture ?? ''} ${sections.map((s) => s.lines.join(' ')).join(' ')}'
          .toLowerCase();

  factory Hymn.fromJson(Map<String, dynamic> json) {
    return Hymn(
      id: json['id'] as String,
      hymnalCode: json['hymnalCode'] as String,
      hymnalName: json['hymnalName'] as String? ?? json['hymnalCode'] as String,
      number: json['number'] as int,
      title: json['title'] as String,
      originalTitle: json['originalTitle'] as String?,
      author: json['author'] as String?,
      composer: json['composer'] as String?,
      scripture: json['scripture'] as String?,
      historyNote: json['historyNote'] as String?,
      rights: RightsRecord.fromJson(json['rights'] as Map<String, dynamic>? ?? {}),
      music: MusicResource.fromJson(json['music'] as Map<String, dynamic>? ?? {}),
      sections: (json['sections'] as List<dynamic>?)
              ?.map((s) => HymnSection.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'hymnalCode': hymnalCode,
        'hymnalName': hymnalName,
        'number': number,
        'title': title,
        if (originalTitle != null) 'originalTitle': originalTitle,
        if (author != null) 'author': author,
        if (composer != null) 'composer': composer,
        if (scripture != null) 'scripture': scripture,
        if (historyNote != null) 'historyNote': historyNote,
        'rights': rights.toJson(),
        'music': music.toJson(),
        'sections': sections.map((s) => s.toJson()).toList(),
      };
}

class PresentationSlide {
  final String hymnId;
  final String hymnalCode;
  final int hymnNumber;
  final String title;
  final String sectionType;
  final String sectionLabel;
  final int slideIndex;
  final int totalSlides;
  final List<String> lines;
  final List<String>? chords;

  const PresentationSlide({
    required this.hymnId,
    required this.hymnalCode,
    required this.hymnNumber,
    required this.title,
    required this.sectionType,
    required this.sectionLabel,
    required this.slideIndex,
    required this.totalSlides,
    required this.lines,
    this.chords,
  });

  factory PresentationSlide.fromJson(Map<String, dynamic> json) {
    return PresentationSlide(
      hymnId: json['hymnId'] as String? ?? '',
      hymnalCode: json['hymnalCode'] as String? ?? '',
      hymnNumber: json['hymnNumber'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      sectionType: json['sectionType'] as String? ?? 'verse',
      sectionLabel: json['sectionLabel'] as String? ?? '',
      slideIndex: json['slideIndex'] as int? ?? 0,
      totalSlides: json['totalSlides'] as int? ?? 1,
      lines: (json['lines'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      chords: (json['chords'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'hymnId': hymnId,
        'hymnalCode': hymnalCode,
        'hymnNumber': hymnNumber,
        'title': title,
        'sectionType': sectionType,
        'sectionLabel': sectionLabel,
        'slideIndex': slideIndex,
        'totalSlides': totalSlides,
        'lines': lines,
        if (chords != null) 'chords': chords,
      };
}
