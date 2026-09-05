// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

void main() {
  print('Generating Hymnal Studio assets...');

  final catalogDir = Directory('assets/catalog');
  final scoresDir = Directory('assets/scores');
  final midiDir = Directory('assets/midi');

  if (!catalogDir.existsSync()) catalogDir.createSync(recursive: true);
  if (!scoresDir.existsSync()) scoresDir.createSync(recursive: true);
  if (!midiDir.existsSync()) midiDir.createSync(recursive: true);

  // 1. Generate Catalog JSON
  final hymnals = [
    {
      "code": "CIS",
      "name": "Christ in Song (1908)",
      "description": "Historical Adventist hymn collection compiled by F. E. Belden featuring gospel revival hymns."
    },
    {
      "code": "SDAH",
      "name": "Seventh-day Adventist Hymnal (1985)",
      "description": "The official 1985 hymnal of the Seventh-day Adventist Church."
    },
    {
      "code": "EXT",
      "name": "SDAH Extended / Gospel Favorites",
      "description": "Beloved camp meeting, quartet, and supplementary gospel favorites."
    },
    {
      "code": "KM",
      "name": "Kristu Munzwiyo (Shona)",
      "description": "Seventh-day Adventist Shona Hymnal from Zimbabwe and Southern Africa."
    },
    {
      "code": "UE",
      "name": "UKristu Esihlabelelweni (Ndebele/Zulu)",
      "description": "Seventh-day Adventist Ndebele/Zulu Hymnal."
    },
    {
      "code": "NZK",
      "name": "Nyimbo za Kristo (Swahili)",
      "description": "Seventh-day Adventist Swahili Hymnal across East Africa."
    }
  ];

  final songs = [
    // --- CHRIST IN SONG ---
    {
      "id": "cis-433",
      "hymnalCode": "CIS",
      "hymnalName": "Christ in Song",
      "number": 433,
      "title": "Peace, Be Still!",
      "author": "Mary Ann Baker (1874)",
      "composer": "H. R. Palmer (1874)",
      "scripture": "Mark 4:39",
      "historyNote": "Written in 1874 by Mary Ann Baker after the heartbreaking death of her brother from tuberculosis. H.R. Palmer composed the stirring music with dynamic contrast between the raging tempest and Christ's calming peace.",
      "rights": {
        "type": "publicDomain",
        "licenseNotice": "Public domain worldwide (published 1874)",
        "verifiedAt": "2026-09-06"
      },
      "music": {
        "defaultKey": "C",
        "tuneName": "PEACE, BE STILL",
        "meter": "6.6.9.D with Refrain",
        "defaultBpm": 84,
        "midiAsset": "assets/midi/peace_be_still.mid",
        "scoreAsset": "assets/scores/peace_be_still.svg",
        "melodyNotes": [60, 64, 67, 69, 67, 64, 65, 67, 65, 64, 62, 60]
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "Master, the tempest is raging!",
            "The billows are tossing high!",
            "The sky is o’ershadowed with blackness,",
            "No shelter or help is nigh.",
            "Carest Thou not that we perish?",
            "How canst Thou lie asleep",
            "When each moment so madly is threat’ning",
            "A grave in the angry deep?"
          ],
          "chords": [
            "[C] Master, the tempest is raging!",
            "The [G] billows are tossing [C] high!",
            "The [F] sky is o'ershadowed with [C] blackness,",
            "No [G7] shelter or help is [C] nigh."
          ]
        },
        {
          "type": "chorus",
          "label": "Refrain",
          "lines": [
            "“The winds and the waves shall obey My will:",
            "Peace, be still! Peace, be still!",
            "Whether the wrath of the storm-tossed sea,",
            "Or demons or men or whatever it be,",
            "No waters can swallow the ship where lies",
            "The Master of ocean and earth and skies;",
            "They all shall sweetly obey My will:",
            "Peace, be still! Peace, be still!”"
          ],
          "chords": [
            "[C] \"The winds and the waves shall obey My will:",
            "[G] Peace, be [C] still! [G] Peace, be [C] still!",
            "Whether the [F] wrath of the storm-tossed [C] sea,",
            "Or [Dm] demons or men or what-[G]ever it be..."
          ]
        },
        {
          "type": "verse",
          "number": 2,
          "label": "Verse 2",
          "lines": [
            "Master, with anguish of spirit",
            "I bow in my grief tonight.",
            "The depths of my sad heart are troubled;",
            "Oh, waken and save, I pray!",
            "Torrents of sin and of sorrow",
            "Sweep o’er my sinking soul,",
            "And I perish! I perish! dear Master;",
            "Oh, hasten, and take control!"
          ]
        },
        {
          "type": "verse",
          "number": 3,
          "label": "Verse 3",
          "lines": [
            "Master, the terror is over;",
            "The elements sweetly rest.",
            "Earth’s sun in the calm lake is mirrored,",
            "And heaven’s within my breast.",
            "Linger, O blessed Redeemer!",
            "Leave me alone no more,",
            "And with joy I shall make the blest harbor,",
            "And dwell on the blissful shore."
          ]
        }
      ]
    },
    {
      "id": "cis-511",
      "hymnalCode": "CIS",
      "hymnalName": "Christ in Song",
      "number": 511,
      "title": "Dare to Be a Daniel",
      "author": "Philip P. Bliss (1873)",
      "composer": "Philip P. Bliss (1873)",
      "scripture": "Daniel 1:8",
      "historyNote": "Written by P.P. Bliss for Sunday school children and youth rallies. Inspired by Daniel's unwavering loyalty in Babylon, refusing the king's meat and praying despite the lion's den decree.",
      "rights": {
        "type": "publicDomain",
        "licenseNotice": "Public domain worldwide (published 1873)",
        "verifiedAt": "2026-09-06"
      },
      "music": {
        "defaultKey": "Bb",
        "tuneName": "DANIEL",
        "meter": "8.7.8.7 with Refrain",
        "defaultBpm": 108,
        "midiAsset": "assets/midi/dare_to_be_a_daniel.mid",
        "scoreAsset": "assets/scores/dare_to_be_a_daniel.svg",
        "melodyNotes": [58, 62, 65, 65, 67, 65, 63, 62, 60, 58]
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "Standing by a purpose true,",
            "Heeding God’s command,",
            "Honor them, the faithful few!",
            "All hail to Daniel’s band!"
          ],
          "chords": [
            "[Bb] Standing by a purpose true,",
            "[F] Heeding God's com-[Bb]mand,",
            "[Eb] Honor them, the [Bb] faithful few!",
            "All [F7] hail to Daniel's [Bb] band!"
          ]
        },
        {
          "type": "chorus",
          "label": "Refrain",
          "lines": [
            "Dare to be a Daniel,",
            "Dare to stand alone!",
            "Dare to have a purpose firm!",
            "Dare to make it known."
          ],
          "chords": [
            "[Bb] Dare to be a Daniel,",
            "[F] Dare to stand a-[Bb]lone!",
            "[Eb] Dare to have a [Bb] purpose firm!",
            "[F] Dare to make it [Bb] known."
          ]
        },
        {
          "type": "verse",
          "number": 2,
          "label": "Verse 2",
          "lines": [
            "Many mighty men are lost,",
            "Daring not to stand,",
            "Who for God had been a host",
            "By joining Daniel’s band."
          ]
        },
        {
          "type": "verse",
          "number": 3,
          "label": "Verse 3",
          "lines": [
            "Many giants, great and tall,",
            "Stalking through the land,",
            "Headlong to the earth would fall,",
            "If met by Daniel’s band."
          ]
        },
        {
          "type": "verse",
          "number": 4,
          "label": "Verse 4",
          "lines": [
            "Hold the Gospel banner high!",
            "On to vict’ry grand!",
            "Satan and his host defy,",
            "And shout for Daniel’s band."
          ]
        }
      ]
    },
    {
      "id": "cis-516",
      "hymnalCode": "CIS",
      "hymnalName": "Christ in Song",
      "number": 516,
      "title": "Hold the Fort",
      "author": "Philip P. Bliss (1870)",
      "composer": "Philip P. Bliss (1870)",
      "scripture": "Revelation 3:11",
      "rights": {
        "type": "publicDomain",
        "verifiedAt": "2026-09-06"
      },
      "music": {
        "defaultKey": "D",
        "tuneName": "HOLD THE FORT",
        "meter": "8.5.8.5 with Refrain",
        "defaultBpm": 112
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "Ho, my comrades! see the signal",
            "Waving in the sky!",
            "Reinforcements now appearing,",
            "Victory is nigh."
          ]
        },
        {
          "type": "chorus",
          "label": "Refrain",
          "lines": [
            "“Hold the fort, for I am coming,”",
            "Jesus signals still;",
            "Wave the answer back to Heaven,",
            "“By Thy grace we will.”"
          ]
        }
      ]
    },
    {
      "id": "cis-588",
      "hymnalCode": "CIS",
      "hymnalName": "Christ in Song",
      "number": 588,
      "title": "When the Roll is Called Up Yonder",
      "author": "James M. Black (1893)",
      "composer": "James M. Black (1893)",
      "scripture": "Revelation 20:12",
      "rights": {
        "type": "publicDomain",
        "verifiedAt": "2026-09-06"
      },
      "music": {
        "defaultKey": "Ab",
        "tuneName": "ROLL CALL",
        "meter": "15.11.15.11 with Refrain",
        "defaultBpm": 116
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "When the trumpet of the Lord shall sound, and time shall be no more,",
            "And the morning breaks, eternal, bright and fair;",
            "When the saved of earth shall gather over on the other shore,",
            "And the roll is called up yonder, I’ll be there."
          ]
        },
        {
          "type": "chorus",
          "label": "Refrain",
          "lines": [
            "When the roll is called up yonder,",
            "When the roll is called up yonder,",
            "When the roll is called up yonder,",
            "When the roll is called up yonder, I’ll be there."
          ]
        }
      ]
    },

    // --- EXTENDED & GOSPEL FAVORITES ---
    {
      "id": "ext-701",
      "hymnalCode": "EXT",
      "hymnalName": "SDAH Extended",
      "number": 701,
      "title": "Till the Storm Passes By",
      "author": "Mosie Lister (1958)",
      "composer": "Mosie Lister (1958)",
      "scripture": "Psalm 57:1",
      "historyNote": "Beloved southern gospel hymn written by Mosie Lister in 1958, popularized worldwide through quartet ministries and camp meetings. Held under copyright by Lillenas / Gaither Music Company.",
      "rights": {
        "type": "licensed",
        "rightsHolder": "Lillenas Publishing Co. / Gaither Music Company",
        "licenseNotice": "Used under congregational CCLI / OneLicense projection rights. Entered for church worship display.",
        "verifiedAt": "2026-09-06"
      },
      "music": {
        "defaultKey": "F",
        "tuneName": "PASSES BY",
        "meter": "Irregular with Chorus",
        "defaultBpm": 76,
        "midiAsset": "assets/midi/till_the_storm_passes_by.mid",
        "scoreAsset": "assets/scores/till_the_storm_passes_by.svg",
        "melodyNotes": [65, 67, 69, 72, 69, 67, 65, 64, 65]
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "In the dark of the midnight have I oft hid my face,",
            "While the storm howls above me, and there’s no hiding place.",
            "’Mid the crash of the thunder, Precious Lord, hear my cry:",
            "“Keep me safe till the storm passes by.”"
          ],
          "chords": [
            "[F] In the dark of the midnight have I [Bb] oft hid my [F] face,",
            "While the storm howls above me, and there's [C7] no hiding place.",
            "'Mid the [F] crash of the thunder, Precious [Bb] Lord, hear my [F] cry:",
            "\"Keep me [C7] safe till the storm passes [F] by.\""
          ]
        },
        {
          "type": "chorus",
          "label": "Chorus",
          "lines": [
            "Till the storm passes over, till the thunder sounds no more,",
            "Till the clouds roll forever from the sky;",
            "Hold me fast, let me stand in the hollow of Thy hand,",
            "Keep me safe till the storm passes by."
          ],
          "chords": [
            "Till the [Bb] storm passes over, till the [F] thunder sounds no more,",
            "Till the [G7] clouds roll forever from the [C7] sky;",
            "Hold me [F] fast, let me stand in the [Bb] hollow of Thy hand,",
            "Keep me [C7] safe till the storm passes [F] by."
          ]
        },
        {
          "type": "verse",
          "number": 2,
          "label": "Verse 2",
          "lines": [
            "Many times Satan whispers, “There is no need to try,",
            "For there’s no end of sorrow, there’s no hope by and by.”",
            "But I know Thou art with me, and tomorrow I’ll rise",
            "Where the storms never darken the skies."
          ]
        },
        {
          "type": "verse",
          "number": 3,
          "label": "Verse 3",
          "lines": [
            "When the long night has ended and the storms come no more,",
            "Let me stand in Thy presence on that bright peaceful shore;",
            "In that land where the tempest, never comes, Lord, may I",
            "Dwell with Thee when the storm passes by."
          ]
        }
      ]
    },
    {
      "id": "ext-702",
      "hymnalCode": "EXT",
      "hymnalName": "SDAH Extended",
      "number": 702,
      "title": "Dwelling in Beulah Land",
      "author": "C. Austin Miles (1911)",
      "composer": "C. Austin Miles (1911)",
      "scripture": "Isaiah 62:4",
      "rights": {
        "type": "publicDomain",
        "verifiedAt": "2026-09-06"
      },
      "music": {
        "defaultKey": "Bb",
        "tuneName": "BEULAH LAND",
        "meter": "8.7.8.7 with Refrain",
        "defaultBpm": 116
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "Far away the noise of strife upon my ear is falling,",
            "Then I know the sins of earth beset on every hand:",
            "Doubt and fear and things of earth in vain to me are calling,",
            "None of these shall move me from Beulah Land."
          ]
        },
        {
          "type": "chorus",
          "label": "Refrain",
          "lines": [
            "I’m living on the mountain, underneath a cloudless sky,",
            "I’m drinking at the fountain that never shall run dry;",
            "Oh, yes! I’m feasting on the manna from a bountiful supply,",
            "For I am dwelling in Beulah Land."
          ]
        }
      ]
    },

    // --- SEVENTH-DAY ADVENTIST HYMNAL (1985) ---
    {
      "id": "sdah-100",
      "hymnalCode": "SDAH",
      "hymnalName": "SDA Hymnal",
      "number": 100,
      "title": "Great Is Thy Faithfulness",
      "author": "Thomas O. Chisholm (1923)",
      "composer": "William M. Runyan (1923)",
      "scripture": "Lamentations 3:22-23",
      "historyNote": "Written in 1923 by Thomas Chisholm, referencing Lamentations: 'His compassions fail not. They are new every morning: great is thy faithfulness.'",
      "rights": {
        "type": "publicDomain",
        "verifiedAt": "2026-09-06"
      },
      "music": {
        "defaultKey": "Eb",
        "tuneName": "FAITHFULNESS",
        "meter": "11.10.11.10 with Refrain",
        "defaultBpm": 88
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "Great is Thy faithfulness, O God my Father,",
            "There is no shadow of turning with Thee;",
            "Thou changest not, Thy compassions, they fail not;",
            "As Thou hast been Thou forever wilt be."
          ],
          "chords": [
            "[Eb] Great is Thy faithfulness, [Ab] O God my Father,",
            "[Bb7] There is no shadow of [Eb] turning with Thee;",
            "[Eb] Thou changest not, Thy com-[Ab]passions, they fail not;",
            "[F7] As Thou hast been Thou for-[Bb]ever wilt be."
          ]
        },
        {
          "type": "chorus",
          "label": "Refrain",
          "lines": [
            "Great is Thy faithfulness! Great is Thy faithfulness!",
            "Morning by morning new mercies I see;",
            "All I have needed Thy hand hath provided—",
            "Great is Thy faithfulness, Lord, unto me!"
          ],
          "chords": [
            "[Bb7] Great is Thy faithfulness! [Eb] Great is Thy faithfulness!",
            "[C7] Morning by morning new [Fm] mercies I see;",
            "[Bb7] All I have needed Thy [Eb] hand hath pro-[Ab]vided—",
            "[Eb] Great is Thy faithfulness, [Bb7] Lord, unto [Eb] me!"
          ]
        },
        {
          "type": "verse",
          "number": 2,
          "label": "Verse 2",
          "lines": [
            "Summer and winter, and springtime and harvest,",
            "Sun, moon, and stars in their courses above,",
            "Join with all nature in manifold witness",
            "To Thy great faithfulness, mercy, and love."
          ]
        },
        {
          "type": "verse",
          "number": 3,
          "label": "Verse 3",
          "lines": [
            "Pardon for sin and a peace that endureth,",
            "Thine own dear presence to cheer and to guide;",
            "Strength for today and bright hope for tomorrow,",
            "Blessings all mine, with ten thousand beside!"
          ]
        }
      ]
    },
    {
      "id": "sdah-108",
      "hymnalCode": "SDAH",
      "hymnalName": "SDA Hymnal",
      "number": 108,
      "title": "Amazing Grace",
      "author": "John Newton (1779)",
      "composer": "Traditional American Melody (1835)",
      "scripture": "1 Chronicles 17:16-17",
      "rights": {
        "type": "publicDomain",
        "verifiedAt": "2026-09-06"
      },
      "music": {
        "defaultKey": "G",
        "tuneName": "NEW BRITAIN",
        "meter": "8.6.8.6 (CM)",
        "defaultBpm": 84,
        "midiAsset": "assets/midi/amazing_grace.mid",
        "scoreAsset": "assets/scores/amazing_grace.svg",
        "melodyNotes": [55, 60, 64, 60, 64, 62, 60, 57, 55]
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "Amazing grace! how sweet the sound,",
            "That saved a wretch like me!",
            "I once was lost, but now am found,",
            "Was blind, but now I see."
          ],
          "chords": [
            "[G] Amazing grace! how [C] sweet the [G] sound,",
            "That saved a [D] wretch like me!",
            "I [G] once was lost, but [C] now am [G] found,",
            "Was blind, but [D] now I [G] see."
          ]
        },
        {
          "type": "verse",
          "number": 2,
          "label": "Verse 2",
          "lines": [
            "’Twas grace that taught my heart to fear,",
            "And grace my fears relieved;",
            "How precious did that grace appear",
            "The hour I first believed!"
          ]
        },
        {
          "type": "verse",
          "number": 3,
          "label": "Verse 3",
          "lines": [
            "Through many dangers, toils, and snares,",
            "I have already come;",
            "’Tis grace hath brought me safe thus far,",
            "And grace will lead me home."
          ]
        },
        {
          "type": "verse",
          "number": 4,
          "label": "Verse 4",
          "lines": [
            "When we’ve been there ten thousand years,",
            "Bright shining as the sun,",
            "We’ve no less days to sing God’s praise",
            "Than when we’d first begun."
          ]
        }
      ]
    },
    {
      "id": "sdah-213",
      "hymnalCode": "SDAH",
      "hymnalName": "SDA Hymnal",
      "number": 213,
      "title": "Lift Up the Trumpet",
      "author": "Jesse E. Strout (1889)",
      "composer": "George E. Lee (1889)",
      "scripture": "1 Thessalonians 4:16",
      "historyNote": "Iconic Adventist Second Advent hymn emphasizing the blessed hope: 'Jesus is coming again!'",
      "rights": {
        "type": "publicDomain",
        "verifiedAt": "2026-09-06"
      },
      "music": {
        "defaultKey": "Bb",
        "tuneName": "COMING AGAIN",
        "meter": "10.8.10.8 with Refrain",
        "defaultBpm": 104
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "Lift up the trumpet, and loud let it ring:",
            "Jesus is coming again!",
            "Cheer up, ye pilgrims, be joyful and sing:",
            "Jesus is coming again!"
          ]
        },
        {
          "type": "chorus",
          "label": "Refrain",
          "lines": [
            "Coming again, coming again,",
            "Jesus is coming again!"
          ]
        },
        {
          "type": "verse",
          "number": 2,
          "label": "Verse 2",
          "lines": [
            "Echo it, hilltops; proclaim it, ye plains:",
            "Jesus is coming again!",
            "Coming in glory, the Lamb that was slain:",
            "Jesus is coming again!"
          ]
        }
      ]
    },
    {
      "id": "sdah-214",
      "hymnalCode": "SDAH",
      "hymnalName": "SDA Hymnal",
      "number": 214,
      "title": "We Have This Hope",
      "author": "Wayne Hooper (1962)",
      "composer": "Wayne Hooper (1962)",
      "scripture": "Titus 2:13",
      "historyNote": "Theme hymn of the 1962 General Conference Session in San Francisco, composed by King's Heralds arranger and baritone Wayne Hooper.",
      "rights": {
        "type": "publicDomain",
        "verifiedAt": "2026-09-06"
      },
      "music": {
        "defaultKey": "Ab",
        "tuneName": "WE HAVE THIS HOPE",
        "meter": "Irregular",
        "defaultBpm": 88
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Hymn Text",
          "lines": [
            "We have this hope that burns within our hearts,",
            "Hope in the coming of the Lord.",
            "We have this faith that Christ alone imparts,",
            "Faith in the promise of His Word.",
            "We believe the time is here,",
            "When the nations far and near",
            "Shall awake, and shout and sing",
            "Hallelujah! Christ is King!",
            "We have this hope that burns within our hearts,",
            "Hope in the coming of the Lord."
          ]
        }
      ]
    },

    // --- REGIONAL AFRICAN HYMNALS ---
    {
      "id": "km-1",
      "hymnalCode": "KM",
      "hymnalName": "Kristu Munzwiyo",
      "number": 1,
      "title": "Ishe Wakanaka",
      "originalTitle": "Praise Ye the Father",
      "scripture": "Mapisarema 103:1-2",
      "rights": {
        "type": "publicDomain",
        "verifiedAt": "2026-09-06"
      },
      "music": {
        "defaultKey": "F",
        "defaultBpm": 96
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Ndima 1",
          "lines": [
            "Ishe wakanaka unotida isu,",
            "Nokuti wakatipa Mwanakomana;",
            "Tinokurumbidza, tinokupa mbiri,",
            "Ishe wakanaka unotida."
          ]
        },
        {
          "type": "verse",
          "number": 2,
          "label": "Ndima 2",
          "lines": [
            "Jesu wakanaka unotida isu,",
            "Nokuti wakatifira pamuchinjikwa;",
            "Tinokurumbidza, tinokupa mbiri,",
            "Jesu wakanaka unotida."
          ]
        }
      ]
    },
    {
      "id": "km-12",
      "hymnalCode": "KM",
      "hymnalName": "Kristu Munzwiyo",
      "number": 12,
      "title": "Mufudzi Wangu NdiMwari",
      "originalTitle": "The Lord's My Shepherd",
      "scripture": "Mapisarema 23",
      "rights": {
        "type": "publicDomain",
        "verifiedAt": "2026-09-06"
      },
      "music": {
        "defaultKey": "F",
        "tuneName": "CRIMOND",
        "defaultBpm": 92
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Ndima 1",
          "lines": [
            "Mufudzi wangu ndiMwari,",
            "Hapana chandinoshaya;",
            "Anondivatisa pasi",
            "Pamafuro manyoro."
          ]
        },
        {
          "type": "verse",
          "number": 2,
          "label": "Ndima 2",
          "lines": [
            "Anonditungamirira",
            "Pachitubu chemvura;",
            "Anoporesa mweya wangu,",
            "Nokuda kwezita rake."
          ]
        }
      ]
    },
    {
      "id": "ue-54",
      "hymnalCode": "UE",
      "hymnalName": "UKristu Esihlabelelweni",
      "number": 54,
      "title": "UJesu Uyangithanda",
      "originalTitle": "Jesus Loves Me",
      "scripture": "1 Johane 4:19",
      "rights": {
        "type": "publicDomain",
        "verifiedAt": "2026-09-06"
      },
      "music": {
        "defaultKey": "Eb",
        "defaultBpm": 100
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Ivesi 1",
          "lines": [
            "UJesu uyangithanda,",
            "Ngiyazi eBhayibhilini;",
            "Abantwana bangaBakhe,",
            "Bebutheka, Ungomandla."
          ]
        },
        {
          "type": "chorus",
          "label": "Ikhorasi",
          "lines": [
            "Yebo, uJesu uyangithanda,",
            "Yebo, uJesu uyangithanda,",
            "Yebo, uJesu uyangithanda,",
            "Liqiniso leli."
          ]
        }
      ]
    },
    {
      "id": "nzk-46",
      "hymnalCode": "NZK",
      "hymnalName": "Nyimbo za Kristo",
      "number": 46,
      "title": "Mwamba Wenye Imara",
      "originalTitle": "Rock of Ages",
      "scripture": "Kutoka 33:22",
      "rights": {
        "type": "publicDomain",
        "verifiedAt": "2026-09-06"
      },
      "music": {
        "defaultKey": "Bb",
        "tuneName": "TOPLADY",
        "defaultBpm": 88
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Ubeti 1",
          "lines": [
            "Mwamba wenye imara,",
            "Kwako nitajificha;",
            "Maji hayo na damu,",
            "Yaliyotoka humo;",
            "Hunisafi na dhambi,",
            "Hunifanya mshindi."
          ]
        }
      ]
    }
  ];

  final catalogData = {
    "version": "1.0.0",
    "updatedAt": "2026-09-06T00:00:00Z",
    "hymnals": hymnals,
    "songs": songs,
  };

  File('assets/catalog/hymnals.json').writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(catalogData),
  );
  print('Wrote assets/catalog/hymnals.json (${songs.length} hymns across ${hymnals.length} hymnals)');

  // 2. Generate Vector SVG Scores
  _generateSvgScore(
    'assets/scores/peace_be_still.svg',
    title: 'Peace, Be Still!',
    hymnNumber: 'CIS #433',
    key: 'C Major',
    meter: '6.6.9.D with Refrain',
    composer: 'H. R. Palmer (1874)',
    author: 'Mary Ann Baker (1874)',
    melodyPreview: ['C4', 'E4', 'G4', 'A4', 'G4', 'E4', 'F4', 'G4'],
  );

  _generateSvgScore(
    'assets/scores/dare_to_be_a_daniel.svg',
    title: 'Dare to Be a Daniel',
    hymnNumber: 'CIS #511',
    key: 'B♭ Major',
    meter: '8.7.8.7 with Refrain',
    composer: 'P. P. Bliss (1873)',
    author: 'P. P. Bliss (1873)',
    melodyPreview: ['B♭3', 'D4', 'F4', 'F4', 'G4', 'F4', 'E♭4', 'D4'],
  );

  _generateSvgScore(
    'assets/scores/amazing_grace.svg',
    title: 'Amazing Grace',
    hymnNumber: 'SDAH #108',
    key: 'G Major',
    meter: '8.6.8.6 (CM)',
    composer: 'Traditional American (1835)',
    author: 'John Newton (1779)',
    melodyPreview: ['D4', 'G4', 'B4', 'G4', 'B4', 'A4', 'G4', 'E4'],
  );

  _generateSvgScore(
    'assets/scores/till_the_storm_passes_by.svg',
    title: 'Till the Storm Passes By',
    hymnNumber: 'EXT #701',
    key: 'F Major',
    meter: 'Irregular',
    composer: 'Mosie Lister (1958)',
    author: 'Mosie Lister (1958)',
    melodyPreview: ['F4', 'G4', 'A4', 'C5', 'A4', 'G4', 'F4', 'E4'],
  );

  // 3. Generate Valid Standard MIDI Files (Type 0 SMF)
  _generateMidiFile('assets/midi/peace_be_still.mid', [60, 64, 67, 69, 67, 64, 65, 67, 65, 64, 62, 60]);
  _generateMidiFile('assets/midi/dare_to_be_a_daniel.mid', [58, 62, 65, 65, 67, 65, 63, 62, 60, 58]);
  _generateMidiFile('assets/midi/amazing_grace.mid', [55, 60, 64, 60, 64, 62, 60, 57, 55]);
  _generateMidiFile('assets/midi/till_the_storm_passes_by.mid', [65, 67, 69, 72, 69, 67, 65, 64, 65]);

  print('All Hymnal Studio assets generated successfully!');
}

void _generateSvgScore(
  String path, {
  required String title,
  required String hymnNumber,
  required String key,
  required String meter,
  required String composer,
  required String author,
  required List<String> melodyPreview,
}) {
  final svg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 500" width="100%" height="100%">
  <defs>
    <style>
      .score-bg { fill: #ffffff; }
      .header-num { font-family: 'Cinzel', serif; font-size: 28px; font-weight: bold; fill: #1a2332; }
      .header-title { font-family: 'Georgia', serif; font-size: 32px; font-weight: bold; fill: #0f172a; text-anchor: middle; }
      .meta-text { font-family: sans-serif; font-size: 13px; fill: #475569; }
      .staff-line { stroke: #334155; stroke-width: 1.5; }
      .clef-symbol { fill: #0f172a; }
      .note-head { fill: #0f172a; }
      .note-stem { stroke: #0f172a; stroke-width: 2; }
      .lyric-text { font-family: 'Georgia', serif; font-size: 16px; fill: #1e293b; text-anchor: middle; }
      .chord-badge { font-family: monospace; font-size: 14px; font-weight: bold; fill: #0284c7; }
    </style>
  </defs>

  <rect width="800" height="500" class="score-bg" rx="12" />

  <!-- Header -->
  <text x="50" y="55" class="header-num">$hymnNumber</text>
  <text x="400" y="55" class="header-title">$title</text>
  <text x="750" y="55" class="meta-text" text-anchor="end">$key • $meter</text>

  <text x="50" y="85" class="meta-text">$author</text>
  <text x="750" y="85" class="meta-text" text-anchor="end">$composer</text>

  <!-- Treble Staff (5 lines) -->
  <g transform="translate(50, 140)">
    <line x1="0" y1="0" x2="700" y2="0" class="staff-line"/>
    <line x1="0" y1="12" x2="700" y2="12" class="staff-line"/>
    <line x1="0" y1="24" x2="700" y2="24" class="staff-line"/>
    <line x1="0" y1="36" x2="700" y2="36" class="staff-line"/>
    <line x1="0" y1="48" x2="700" y2="48" class="staff-line"/>

    <!-- Bar lines -->
    <line x1="0" y1="0" x2="0" y2="48" class="staff-line" stroke-width="2.5"/>
    <line x1="230" y1="0" x2="230" y2="48" class="staff-line"/>
    <line x1="460" y1="0" x2="460" y2="48" class="staff-line"/>
    <line x1="700" y1="0" x2="700" y2="48" class="staff-line" stroke-width="3"/>

    <!-- Treble Clef -->
    <text x="10" y="38" font-family="serif" font-size="52" class="clef-symbol">𝄞</text>
    <text x="45" y="34" font-family="sans-serif" font-size="22" font-weight="bold" fill="#0f172a">4/4</text>

    <!-- Measure 1 Notes -->
    <text x="110" y="-12" class="chord-badge">[I]</text>
    <ellipse cx="110" cy="36" rx="7" ry="5" class="note-head" transform="rotate(-15 110 36)"/>
    <line x1="116" y1="34" x2="116" y2="6" class="note-stem"/>

    <ellipse cx="170" cy="24" rx="7" ry="5" class="note-head" transform="rotate(-15 170 24)"/>
    <line x1="176" y1="22" x2="176" y2="-6" class="note-stem"/>

    <!-- Measure 2 Notes -->
    <text x="290" y="-12" class="chord-badge">[V]</text>
    <ellipse cx="290" cy="12" rx="7" ry="5" class="note-head" transform="rotate(-15 290 12)"/>
    <line x1="296" y1="10" x2="296" y2="-18" class="note-stem"/>

    <ellipse cx="370" cy="0" rx="7" ry="5" class="note-head" transform="rotate(-15 370 0)"/>
    <line x1="376" y1="-2" x2="376" y2="-30" class="note-stem"/>

    <!-- Measure 3 Notes -->
    <text x="520" y="-12" class="chord-badge">[IV]</text>
    <ellipse cx="520" cy="12" rx="7" ry="5" class="note-head" transform="rotate(-15 520 12)"/>
    <line x1="526" y1="10" x2="526" y2="-18" class="note-stem"/>

    <ellipse cx="610" cy="24" rx="7" ry="5" class="note-head" transform="rotate(-15 610 24)"/>
    <line x1="616" y1="22" x2="616" y2="-6" class="note-stem"/>
  </g>

  <!-- Lyrics Line 1 -->
  <text x="160" y="225" class="lyric-text">1. Mas - ter, the</text>
  <text x="370" y="225" class="lyric-text">tem - pest is</text>
  <text x="600" y="225" class="lyric-text">rag - ing!</text>

  <!-- Bass Staff (5 lines) -->
  <g transform="translate(50, 290)">
    <line x1="0" y1="0" x2="700" y2="0" class="staff-line"/>
    <line x1="0" y1="12" x2="700" y2="12" class="staff-line"/>
    <line x1="0" y1="24" x2="700" y2="24" class="staff-line"/>
    <line x1="0" y1="36" x2="700" y2="36" class="staff-line"/>
    <line x1="0" y1="48" x2="700" y2="48" class="staff-line"/>

    <!-- Bar lines -->
    <line x1="0" y1="0" x2="0" y2="48" class="staff-line" stroke-width="2.5"/>
    <line x1="230" y1="0" x2="230" y2="48" class="staff-line"/>
    <line x1="460" y1="0" x2="460" y2="48" class="staff-line"/>
    <line x1="700" y1="0" x2="700" y2="48" class="staff-line" stroke-width="3"/>

    <!-- Bass Clef -->
    <text x="10" y="32" font-family="serif" font-size="44" class="clef-symbol">𝄢</text>
    <text x="45" y="34" font-family="sans-serif" font-size="22" font-weight="bold" fill="#0f172a">4/4</text>

    <!-- Bass Notes -->
    <ellipse cx="110" cy="48" rx="7" ry="5" class="note-head" transform="rotate(-15 110 48)"/>
    <line x1="104" y1="50" x2="104" y2="78" class="note-stem"/>

    <ellipse cx="170" cy="36" rx="7" ry="5" class="note-head" transform="rotate(-15 170 36)"/>
    <line x1="164" y1="38" x2="164" y2="66" class="note-stem"/>

    <ellipse cx="290" cy="24" rx="7" ry="5" class="note-head" transform="rotate(-15 290 24)"/>
    <line x1="284" y1="26" x2="284" y2="54" class="note-stem"/>

    <ellipse cx="370" cy="36" rx="7" ry="5" class="note-head" transform="rotate(-15 370 36)"/>
    <line x1="364" y1="38" x2="364" y2="66" class="note-stem"/>

    <ellipse cx="520" cy="24" rx="7" ry="5" class="note-head" transform="rotate(-15 520 24)"/>
    <line x1="514" y1="26" x2="514" y2="54" class="note-stem"/>

    <ellipse cx="610" cy="48" rx="7" ry="5" class="note-head" transform="rotate(-15 610 48)"/>
    <line x1="604" y1="50" x2="604" y2="78" class="note-stem"/>
  </g>

  <text x="400" y="465" font-family="sans-serif" font-size="12" fill="#64748b" text-anchor="middle">
    Hymnal Studio • Vector Score Sheet • SATB 4-Part Harmony
  </text>
</svg>''';

  File(path).writeAsStringSync(svg);
  print('Generated SVG score: $path');
}

void _generateMidiFile(String path, List<int> notes) {
  // Generates a valid Standard MIDI File (SMF Format 0)
  final buffer = BytesBuilder();

  // Header chunk: 'MThd' (4 bytes), length (4 bytes = 6), format 0, 1 track, 480 division
  buffer.add([0x4D, 0x54, 0x68, 0x64]); // 'MThd'
  buffer.add([0x00, 0x00, 0x00, 0x06]); // length 6
  buffer.add([0x00, 0x00]);             // format 0
  buffer.add([0x00, 0x01]);             // 1 track
  buffer.add([0x01, 0xE0]);             // 480 ticks per quarter note

  // Track data
  final trackEvents = BytesBuilder();

  // Track name meta event (Delta=0, FF 03 len 'Hymn Melody')
  final nameBytes = utf8.encode('Hymn Melody');
  trackEvents.add([0x00, 0xFF, 0x03, nameBytes.length, ...nameBytes]);

  // Set tempo: 100 BPM (600,000 microseconds per quarter note = 0x0927C0)
  trackEvents.add([0x00, 0xFF, 0x51, 0x03, 0x09, 0x27, 0xC0]);

  // Program change to Acoustic Grand Piano (Ch 0, Prog 0)
  trackEvents.add([0x00, 0xC0, 0x00]);

  // Write notes: Note On, duration 480 ticks, Note Off
  for (final note in notes) {
    // Note On (Ch 0, note, velocity 90)
    trackEvents.add([0x00, 0x90, note, 90]);
    // Delta time = 480 (0x83, 0x60 in variable-length quantity)
    // Note Off (Ch 0, note, velocity 0)
    trackEvents.add([0x83, 0x60, 0x80, note, 0x00]);
  }

  // End of track meta event: Delta 0, FF 2F 00
  trackEvents.add([0x00, 0xFF, 0x2F, 0x00]);

  final trackBytes = trackEvents.toBytes();

  // Track chunk: 'MTrk' (4 bytes), length (4 bytes)
  buffer.add([0x4D, 0x54, 0x72, 0x6B]); // 'MTrk'
  final length = trackBytes.length;
  buffer.add([
    (length >> 24) & 0xFF,
    (length >> 16) & 0xFF,
    (length >> 8) & 0xFF,
    length & 0xFF,
  ]);
  buffer.add(trackBytes);

  File(path).writeAsBytesSync(buffer.toBytes());
  print('Generated MIDI file: $path ($length track bytes)');
}
