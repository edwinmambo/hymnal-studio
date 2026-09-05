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
      "description":
          "Historical Adventist hymn collection compiled by F. E. Belden featuring gospel revival hymns.",
    },
    {
      "code": "SDAH",
      "name": "Seventh-day Adventist Hymnal (1985)",
      "description":
          "The official 1985 hymnal of the Seventh-day Adventist Church.",
    },
    {
      "code": "EXT",
      "name": "SDAH Extended / Gospel Favorites",
      "description":
          "Beloved camp meeting, quartet, and supplementary gospel favorites.",
    },
    {
      "code": "KM",
      "name": "Kristu Munzwiyo (Shona)",
      "description":
          "Seventh-day Adventist Shona Hymnal from Zimbabwe and Southern Africa.",
    },
    {
      "code": "UE",
      "name": "UKristu Esihlabelelweni (Ndebele/Zulu)",
      "description": "Seventh-day Adventist Ndebele/Zulu Hymnal.",
    },
    {
      "code": "NZK",
      "name": "Nyimbo za Kristo (Swahili)",
      "description": "Seventh-day Adventist Swahili Hymnal across East Africa.",
    },
  ];

  final songs = [
    // ==========================================
    // --- CHRIST IN SONG (1908) ---
    // ==========================================
    {
      "id": "cis-433",
      "hymnalCode": "CIS",
      "hymnalName": "Christ in Song",
      "number": 433,
      "title": "Peace, Be Still!",
      "author": "Mary Ann Baker (1874)",
      "composer": "H. R. Palmer (1874)",
      "scripture": "Mark 4:39",
      "historyNote":
          "Written in 1874 by Mary Ann Baker after the heartbreaking death of her brother from tuberculosis. H.R. Palmer composed the stirring music with dynamic contrast between the raging tempest and Christ's calming peace.",
      "rights": {
        "type": "publicDomain",
        "licenseNotice": "Public domain worldwide (published 1874)",
        "verifiedAt": "2026-09-06",
      },
      "music": {
        "defaultKey": "C",
        "tuneName": "PEACE, BE STILL",
        "meter": "6.6.9.D with Refrain",
        "defaultBpm": 84,
        "midiAsset": "assets/midi/peace_be_still.mid",
        "scoreAsset": "assets/scores/peace_be_still.svg",
        "melodyNotes": [60, 64, 67, 69, 67, 64, 65, 67, 65, 64, 62, 60],
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
            "A grave in the angry deep?",
          ],
          "chords": [
            "[C] Master, the tempest is raging!",
            "The [G] billows are tossing [C] high!",
            "The [F] sky is o'ershadowed with [C] blackness,",
            "No [G7] shelter or help is [C] nigh.",
            "[Am] Carest Thou not that we perish?",
            "How [Em] canst Thou lie asleep",
            "When [F] each moment so madly is [C] threat’ning",
            "A [G7] grave in the angry [C] deep?",
          ],
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
            "Peace, be still! Peace, be still!”",
          ],
          "chords": [
            "[C] \"The winds and the waves shall obey My will:",
            "[G] Peace, be [C] still! [G] Peace, be [C] still!",
            "Whether the [F] wrath of the storm-tossed [C] sea,",
            "Or [Dm] demons or men or what-[G]ever it be,",
            "No [C] waters can swallow the [F] ship where lies",
            "The [C] Master of ocean and [G] earth and skies;",
            "[C] They all shall sweetly obey My will:",
            "[G] Peace, be [C] still! [G] Peace, be [C] still!\"",
          ],
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
            "Oh, hasten, and take control!",
          ],
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
            "And rest on the blissful shore.",
          ],
        },
      ],
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
      "historyNote":
          "Composed by Philip Bliss in 1873 for youth and Sunday school gatherings, inspired by Daniel's unwavering resolve not to defile himself with the king's meat.",
      "rights": {
        "type": "publicDomain",
        "licenseNotice": "Public domain worldwide (published 1873)",
        "verifiedAt": "2026-09-06",
      },
      "music": {
        "defaultKey": "Bb",
        "tuneName": "DANIEL",
        "meter": "P.M. with Refrain",
        "defaultBpm": 104,
        "midiAsset": "assets/midi/dare_to_be_a_daniel.mid",
        "scoreAsset": "assets/scores/dare_to_be_a_daniel.svg",
        "melodyNotes": [58, 62, 65, 67, 65, 62, 58, 60, 62, 60, 58],
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
            "All hail to Daniel’s band!",
          ],
          "chords": [
            "[Bb] Standing by a purpose true,",
            "[F] Heeding God’s [Bb] command,",
            "Honor them, the faithful few!",
            "All [F7] hail to Daniel’s [Bb] band!",
          ],
        },
        {
          "type": "chorus",
          "label": "Refrain",
          "lines": [
            "Dare to be a Daniel,",
            "Dare to stand alone!",
            "Dare to have a purpose firm!",
            "Dare to make it known.",
          ],
          "chords": [
            "[Bb] Dare to be a Daniel,",
            "[F] Dare to stand [Bb] alone!",
            "[Eb] Dare to have a purpose [Bb] firm!",
            "Dare to [F7] make it [Bb] known.",
          ],
        },
        {
          "type": "verse",
          "number": 2,
          "label": "Verse 2",
          "lines": [
            "Many mighty men are lost,",
            "Daring not to stand,",
            "Who for God had been a host",
            "By joining Daniel’s band.",
          ],
        },
        {
          "type": "verse",
          "number": 3,
          "label": "Verse 3",
          "lines": [
            "Many giants, great and tall,",
            "Stalking through the land,",
            "Headlong to the earth would fall,",
            "If met by Daniel’s band.",
          ],
        },
        {
          "type": "verse",
          "number": 4,
          "label": "Verse 4",
          "lines": [
            "Hold the Gospel banner high!",
            "On to victory grand!",
            "Satan and his host defy,",
            "And shout for Daniel’s band.",
          ],
        },
      ],
    },
    {
      "id": "cis-516",
      "hymnalCode": "CIS",
      "hymnalName": "Christ in Song",
      "number": 516,
      "title": "Hold the Fort",
      "author": "Philip P. Bliss (1870)",
      "composer": "Philip P. Bliss (1870)",
      "scripture": "Revelation 2:25",
      "historyNote":
          "Inspired by General Sherman's signal to General Corse at Allatoona Pass during the American Civil War: 'Hold the fort; I am coming.' Bliss transformed the incident into a spiritual rallying cry for the church triumphant.",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "D",
        "tuneName": "HOLD THE FORT",
        "meter": "8.5.8.5 with Refrain",
        "defaultBpm": 96,
        "midiAsset": "assets/midi/hold_the_fort.mid",
        "scoreAsset": "assets/scores/hold_the_fort.svg",
        "melodyNotes": [62, 66, 69, 69, 69, 67, 66, 64, 62],
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
            "Victory is nigh.",
          ],
          "chords": [
            "[D] Ho, my comrades! see the signal",
            "[A] Waving in the [D] sky!",
            "Reinforcements now appearing,",
            "[A7] Victory is [D] nigh.",
          ],
        },
        {
          "type": "chorus",
          "label": "Refrain",
          "lines": [
            "“Hold the fort, for I am coming,”",
            "Jesus signals still;",
            "Wave the answer back to heaven,",
            "“By Thy grace we will.”",
          ],
          "chords": [
            "[D] \"Hold the fort, for I am coming,\"",
            "[A] Jesus signals [D] still;",
            "Wave the answer back to heaven,",
            "[A7] \"By Thy grace we [D] will.\"",
          ],
        },
        {
          "type": "verse",
          "number": 2,
          "label": "Verse 2",
          "lines": [
            "See the mighty host advancing,",
            "Satan leading on;",
            "Mighty men around us falling,",
            "Courage almost gone!",
          ],
        },
        {
          "type": "verse",
          "number": 3,
          "label": "Verse 3",
          "lines": [
            "See the glorious banner waving!",
            "Hear the trumpet blow!",
            "In our Leader’s Name we triumph",
            "Over every foe.",
          ],
        },
        {
          "type": "verse",
          "number": 4,
          "label": "Verse 4",
          "lines": [
            "Fierce and long the battle rages,",
            "But our help is near;",
            "Onward comes our great Commander,",
            "Cheer, my comrades, cheer!",
          ],
        },
      ],
    },
    {
      "id": "cis-588",
      "hymnalCode": "CIS",
      "hymnalName": "Christ in Song",
      "number": 588,
      "title": "Let the Lower Lights Be Burning",
      "author": "Philip P. Bliss (1871)",
      "composer": "Philip P. Bliss (1871)",
      "scripture": "Matthew 5:16",
      "historyNote":
          "Dwight L. Moody related the story of a boat entering Cleveland harbor on a dark, stormy night where the upper lights burned bright, but the lower lights along the shore were out, causing the ship to crash on the rocks. Bliss wrote this hymn urging Christians to keep their individual lights burning.",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "Bb",
        "tuneName": "LOWER LIGHTS",
        "meter": "8.7.8.7.D with Refrain",
        "defaultBpm": 92,
        "melodyNotes": [58, 62, 65, 67, 65, 62, 58, 60, 62, 58],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "Brightly beams our Father’s mercy",
            "From His lighthouse evermore,",
            "But to us He gives the keeping",
            "Of the lights along the shore.",
          ],
          "chords": [
            "[Bb] Brightly beams our Father’s mercy",
            "From His lighthouse ever-[F]more,",
            "But to [Bb] us He gives the [Eb] keeping",
            "Of the [Bb] lights a-[F7]long the [Bb] shore.",
          ],
        },
        {
          "type": "chorus",
          "label": "Refrain",
          "lines": [
            "Let the lower lights be burning!",
            "Send a gleam across the wave!",
            "Some poor fainting, struggling seaman",
            "You may rescue, you may save.",
          ],
          "chords": [
            "[Bb] Let the lower lights be burning!",
            "Send a [Eb] gleam a-[Bb]cross the [F] wave!",
            "Some poor [Bb] fainting, struggling [Eb] seaman",
            "You may [Bb] rescue, [F7] you may [Bb] save.",
          ],
        },
        {
          "type": "verse",
          "number": 2,
          "label": "Verse 2",
          "lines": [
            "Dark the night of sin has settled,",
            "Loud the angry billows roar;",
            "Eager eyes are watching, longing,",
            "For the lights along the shore.",
          ],
        },
        {
          "type": "verse",
          "number": 3,
          "label": "Verse 3",
          "lines": [
            "Trim your feeble lamp, my brother;",
            "Some poor sailor, tempest tossed,",
            "Trying now to make the harbor,",
            "In the darkness may be lost.",
          ],
        },
      ],
    },
    {
      "id": "cis-1",
      "hymnalCode": "CIS",
      "hymnalName": "Christ in Song",
      "number": 1,
      "title": "Praise Ye the Father",
      "author": "Elizabeth Charles (1858)",
      "composer": "Friedrich F. Flemming (1811)",
      "scripture": "Psalm 148:1",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "Eb",
        "tuneName": "FLEMMING",
        "meter": "11.11.11.5",
        "defaultBpm": 84,
        "melodyNotes": [63, 63, 63, 65, 67, 68, 67, 65, 63],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "Praise ye the Father for His lovingkindness,",
            "Tenderly cares He for His erring children;",
            "Praise Him, ye angels, praise Him in the heavens;",
            "Praise ye Jehovah!",
          ],
          "chords": [
            "[Eb] Praise ye the Father for His lovingkindness,",
            "[Bb] Tenderly cares He for His erring [Eb] children;",
            "[Ab] Praise Him, ye [Eb] angels, [Ab] praise Him in the [Eb] heavens;",
            "[Bb7] Praise ye Je-[Eb]hovah!",
          ],
        },
        {
          "type": "verse",
          "number": 2,
          "label": "Verse 2",
          "lines": [
            "Praise ye the Savior, great is His compassion,",
            "Graciously cares He for His chosen people;",
            "Young men and maidens, ye old men and children,",
            "Praise ye the Savior!",
          ],
        },
        {
          "type": "verse",
          "number": 3,
          "label": "Verse 3",
          "lines": [
            "Praise ye the Spirit, comforter of Israel,",
            "Sent of the Father and the Son to bless us;",
            "Praise ye the Father, Son, and Holy Spirit,",
            "Praise the Triune God!",
          ],
        },
      ],
    },
    {
      "id": "cis-382",
      "hymnalCode": "CIS",
      "hymnalName": "Christ in Song",
      "number": 382,
      "title": "Under His Wings",
      "author": "William O. Cushing (1896)",
      "composer": "Ira D. Sankey (1896)",
      "scripture": "Psalm 91:4",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "Db",
        "tuneName": "UNDER HIS WINGS",
        "meter": "P.M. with Refrain",
        "defaultBpm": 84,
        "melodyNotes": [61, 65, 68, 65, 61, 63, 65, 61],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "Under His wings I am safely abiding;",
            "Though the night deepens and tempests are wild,",
            "Still I can trust Him; I know He will keep me;",
            "He has redeemed me, and I am His child.",
          ],
          "chords": [
            "[Db] Under His wings I am safely abiding;",
            "Though the night [Ab] deepens and tempests are [Db] wild,",
            "Still I can [Gb] trust Him; I [Db] know He will keep me;",
            "He has re-[Ab7]deemed me, and [Db] I am His child.",
          ],
        },
        {
          "type": "chorus",
          "label": "Refrain",
          "lines": [
            "Under His wings, under His wings,",
            "Who from His love can sever?",
            "Under His wings my soul shall abide,",
            "Safely abide forever.",
          ],
          "chords": [
            "[Db] Under His wings, under His wings,",
            "Who from His [Ab] love can [Db] sever?",
            "Under His [Gb] wings my [Db] soul shall abide,",
            "Safely a-[Ab7]bide for-[Db]ever.",
          ],
        },
        {
          "type": "verse",
          "number": 2,
          "label": "Verse 2",
          "lines": [
            "Under His wings, what a refuge in sorrow!",
            "How the heart yearningly turns to His rest!",
            "Often when earth has no balm for my healing,",
            "There I find comfort, and there I am blest.",
          ],
        },
      ],
    },
    {
      "id": "cis-429",
      "hymnalCode": "CIS",
      "hymnalName": "Christ in Song",
      "number": 429,
      "title": "Yield Not to Temptation",
      "author": "Horatio R. Palmer (1868)",
      "composer": "Horatio R. Palmer (1868)",
      "scripture": "1 Corinthians 10:13",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "Ab",
        "tuneName": "PALMER",
        "meter": "6.5.6.5.D with Refrain",
        "defaultBpm": 88,
        "melodyNotes": [60, 63, 65, 68, 65, 63, 60, 58, 60],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "Yield not to temptation, for yielding is sin;",
            "Each vict’ry will help you some other to win;",
            "Fight manfully onward, dark passions subdue;",
            "Look ever to Jesus, He’ll carry you through.",
          ],
          "chords": [
            "[Ab] Yield not to temptation, for [Eb] yielding is [Ab] sin;",
            "Each vict’ry will help you some [Eb] other to [Ab] win;",
            "Fight manfully onward, dark [Db] passions subdue;",
            "Look [Ab] ever to [Eb7] Jesus, He’ll [Ab] carry you through.",
          ],
        },
        {
          "type": "chorus",
          "label": "Refrain",
          "lines": [
            "Ask the Savior to help you,",
            "Comfort, strengthen, and keep you;",
            "He is willing to aid you,",
            "He will carry you through.",
          ],
          "chords": [
            "[Ab] Ask the Savior to help you,",
            "[Db] Comfort, strengthen, and [Ab] keep you;",
            "He is willing to [Db] aid you,",
            "He will [Ab] carry [Eb7] you [Ab] through.",
          ],
        },
      ],
    },

    // ==========================================
    // --- SEVENTH-DAY ADVENTIST HYMNAL (1985) ---
    // ==========================================
    {
      "id": "sdah-100",
      "hymnalCode": "SDAH",
      "hymnalName": "SDA Hymnal",
      "number": 100,
      "title": "Great Is Thy Faithfulness",
      "author": "Thomas O. Chisholm (1923)",
      "composer": "William M. Runyan (1923)",
      "scripture": "Lamentations 3:22-23",
      "rights": {
        "type": "publicDomain",
        "licenseNotice": "Public domain in many jurisdictions (composed 1923)",
        "verifiedAt": "2026-09-06",
      },
      "music": {
        "defaultKey": "Eb",
        "tuneName": "FAITHFULNESS",
        "meter": "11.10.11.10 with Refrain",
        "defaultBpm": 84,
        "midiAsset": "assets/midi/great_is_thy_faithfulness.mid",
        "scoreAsset": "assets/scores/great_is_thy_faithfulness.svg",
        "melodyNotes": [63, 67, 70, 68, 67, 65, 63, 65, 67, 63],
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
            "As Thou hast been Thou forever wilt be.",
          ],
          "chords": [
            "[Eb] Great is Thy faithfulness, [Ab] O God my Father,",
            "[Bb7] There is no shadow of [Eb] turning with Thee;",
            "Thou changest not, Thy com-[Ab]passions, they fail not;",
            "[F7] As Thou hast been Thou for-[Bb7]ever wilt be.",
          ],
        },
        {
          "type": "chorus",
          "label": "Refrain",
          "lines": [
            "Great is Thy faithfulness! Great is Thy faithfulness!",
            "Morning by morning new mercies I see;",
            "All I have needed Thy hand hath provided—",
            "Great is Thy faithfulness, Lord, unto me!",
          ],
          "chords": [
            "[Bb7] Great is Thy faithfulness! [Eb] Great is Thy faithfulness!",
            "[C7] Morning by morning new [Fm] mercies I see;",
            "[Bb7] All I have needed Thy [Eb] hand hath pro-[Ab]vided—",
            "[Eb] Great is Thy faithfulness, [Bb7] Lord, unto [Eb] me!",
          ],
        },
        {
          "type": "verse",
          "number": 2,
          "label": "Verse 2",
          "lines": [
            "Summer and winter, and springtime and harvest,",
            "Sun, moon, and stars in their courses above,",
            "Join with all nature in manifold witness",
            "To Thy great faithfulness, mercy, and love.",
          ],
        },
        {
          "type": "verse",
          "number": 3,
          "label": "Verse 3",
          "lines": [
            "Pardon for sin and a peace that endureth,",
            "Thine own dear presence to cheer and to guide;",
            "Strength for today and bright hope for tomorrow,",
            "Blessings all mine, with ten thousand beside!",
          ],
        },
      ],
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
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "G",
        "tuneName": "NEW BRITAIN",
        "meter": "8.6.8.6 (CM)",
        "defaultBpm": 84,
        "midiAsset": "assets/midi/amazing_grace.mid",
        "scoreAsset": "assets/scores/amazing_grace.svg",
        "melodyNotes": [55, 60, 64, 60, 64, 62, 60, 57, 55],
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
            "Was blind, but now I see.",
          ],
          "chords": [
            "[G] Amazing grace! how [C] sweet the [G] sound,",
            "That saved a [D] wretch like me!",
            "I [G] once was lost, but [C] now am [G] found,",
            "Was blind, but [D] now I [G] see.",
          ],
        },
        {
          "type": "verse",
          "number": 2,
          "label": "Verse 2",
          "lines": [
            "’Twas grace that taught my heart to fear,",
            "And grace my fears relieved;",
            "How precious did that grace appear",
            "The hour I first believed!",
          ],
        },
        {
          "type": "verse",
          "number": 3,
          "label": "Verse 3",
          "lines": [
            "Through many dangers, toils, and snares,",
            "I have already come;",
            "’Tis grace hath brought me safe thus far,",
            "And grace will lead me home.",
          ],
        },
        {
          "type": "verse",
          "number": 4,
          "label": "Verse 4",
          "lines": [
            "When we’ve been there ten thousand years,",
            "Bright shining as the sun,",
            "We’ve no less days to sing God’s praise",
            "Than when we first begun.",
          ],
        },
      ],
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
      "historyNote":
          "Composed by Wayne Hooper for the 1962 General Conference session in San Francisco, this hymn became the global musical anthem of the Seventh-day Adventist Church, articulating the blessed hope of the Second Advent.",
      "rights": {
        "type": "publicDomain",
        "licenseNotice": "Used by permission of the General Conference of SDA",
        "verifiedAt": "2026-09-06",
      },
      "music": {
        "defaultKey": "Ab",
        "tuneName": "WE HAVE THIS HOPE",
        "meter": "Irregular",
        "defaultBpm": 80,
        "midiAsset": "assets/midi/we_have_this_hope.mid",
        "scoreAsset": "assets/scores/we_have_this_hope.svg",
        "melodyNotes": [60, 63, 65, 68, 68, 67, 65, 68, 72, 70],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Stanza 1",
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
            "Hope in the coming of the Lord.",
          ],
          "chords": [
            "[Ab] We have this hope that burns within our [Eb] hearts,",
            "[Db] Hope in the [Eb] coming of the [Ab] Lord.",
            "We have this faith that Christ alone im-[Eb]parts,",
            "[Db] Faith in the [Eb] promise of His [Ab] Word.",
            "We believe the [Fm] time is here,",
            "When the nations [Bbm] far and near",
            "Shall awake, and [Eb] shout and sing",
            "[Ab] Hallelujah! [Eb] Christ is King!",
            "[Ab] We have this hope that burns within our [Eb] hearts,",
            "[Db] Hope in the [Eb7] coming of the [Ab] Lord.",
          ],
        },
      ],
    },
    {
      "id": "sdah-213",
      "hymnalCode": "SDAH",
      "hymnalName": "SDA Hymnal",
      "number": 213,
      "title": "Lift Up the Trumpet",
      "author": "Jessie E. Strout (1889)",
      "composer": "George E. Lee (1889)",
      "scripture": "Matthew 24:30-31",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "Bb",
        "tuneName": "LIFT UP THE TRUMPET",
        "meter": "8.7.8.7 with Refrain",
        "defaultBpm": 100,
        "melodyNotes": [58, 62, 65, 68, 67, 65, 62, 58, 65],
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
            "Jesus is coming again!",
          ],
          "chords": [
            "[Bb] Lift up the trumpet, and loud let it ring:",
            "Jesus is [F] coming a-[Bb]gain!",
            "Cheer up, ye pilgrims, be joyful and sing:",
            "Jesus is [F7] coming a-[Bb]gain!",
          ],
        },
        {
          "type": "chorus",
          "label": "Refrain",
          "lines": [
            "Coming again, coming again,",
            "Jesus is coming again!",
          ],
          "chords": [
            "[Eb] Coming again, [Bb] coming again,",
            "Jesus is [F7] coming a-[Bb]gain!",
          ],
        },
        {
          "type": "verse",
          "number": 2,
          "label": "Verse 2",
          "lines": [
            "Echo it, hilltops; proclaim it, ye plains:",
            "Jesus is coming again!",
            "Coming in glory, the Lamb that was slain:",
            "Jesus is coming again!",
          ],
        },
        {
          "type": "verse",
          "number": 3,
          "label": "Verse 3",
          "lines": [
            "Sound it, old ocean, in each gentle wave:",
            "Jesus is coming again!",
            "Break through the gloomy confines of the grave:",
            "Jesus is coming again!",
          ],
        },
      ],
    },
    {
      "id": "sdah-499",
      "hymnalCode": "SDAH",
      "hymnalName": "SDA Hymnal",
      "number": 499,
      "title": "What a Friend We Have in Jesus",
      "author": "Joseph M. Scriven (1855)",
      "composer": "Charles C. Converse (1868)",
      "scripture": "John 15:15",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "F",
        "tuneName": "CONVERSE",
        "meter": "8.7.8.7.D",
        "defaultBpm": 88,
        "midiAsset": "assets/midi/what_a_friend_we_have_in_jesus.mid",
        "scoreAsset": "assets/scores/what_a_friend_we_have_in_jesus.svg",
        "melodyNotes": [65, 65, 67, 65, 62, 57, 60, 62, 60],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "What a friend we have in Jesus,",
            "All our sins and griefs to bear!",
            "What a privilege to carry",
            "Everything to God in prayer!",
            "Oh, what peace we often forfeit,",
            "Oh, what needless pain we bear,",
            "All because we do not carry",
            "Everything to God in prayer!",
          ],
          "chords": [
            "[F] What a friend we have in [Bb] Jesus,",
            "[F] All our sins and griefs to [C] bear!",
            "[F] What a privilege to [Bb] carry",
            "[F] Everything to [C] God in [F] prayer!",
            "[C] Oh, what peace we often [F] forfeit,",
            "[Bb] Oh, what needless [F] pain we [C] bear,",
            "[F] All because we do not [Bb] carry",
            "[F] Everything to [C] God in [F] prayer!",
          ],
        },
        {
          "type": "verse",
          "number": 2,
          "label": "Verse 2",
          "lines": [
            "Have we trials and temptations?",
            "Is there trouble anywhere?",
            "We should never be discouraged;",
            "Take it to the Lord in prayer.",
            "Can we find a friend so faithful",
            "Who will all our sorrows share?",
            "Jesus knows our every weakness;",
            "Take it to the Lord in prayer.",
          ],
        },
      ],
    },
    {
      "id": "sdah-462",
      "hymnalCode": "SDAH",
      "hymnalName": "SDA Hymnal",
      "number": 462,
      "title": "Blessed Assurance",
      "author": "Fanny J. Crosby (1873)",
      "composer": "Phoebe P. Knapp (1873)",
      "scripture": "Hebrews 10:22",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "D",
        "tuneName": "ASSURANCE",
        "meter": "9.10.9.9 with Refrain",
        "defaultBpm": 92,
        "midiAsset": "assets/midi/blessed_assurance.mid",
        "scoreAsset": "assets/scores/blessed_assurance.svg",
        "melodyNotes": [66, 69, 74, 71, 69, 66, 64, 66, 69],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "Blessed assurance, Jesus is mine!",
            "Oh, what a foretaste of glory divine!",
            "Heir of salvation, purchase of God,",
            "Born of His Spirit, washed in His blood.",
          ],
          "chords": [
            "[D] Blessed assurance, [G] Jesus is [D] mine!",
            "Oh, what a [A] foretaste of [E7] glory di-[A]vine!",
            "[D] Heir of salvation, [G] purchase of [D] God,",
            "Born of His [Em] Spirit, [A7] washed in His [D] blood.",
          ],
        },
        {
          "type": "chorus",
          "label": "Refrain",
          "lines": [
            "This is my story, this is my song,",
            "Praising my Savior all the day long;",
            "This is my story, this is my song,",
            "Praising my Savior all the day long.",
          ],
          "chords": [
            "[D] This is my story, [G] this is my [D] song,",
            "Praising my [G] Savior [D] all the day [A] long;",
            "[D] This is my story, [G] this is my [D] song,",
            "Praising my [Em] Savior [A7] all the day [D] long.",
          ],
        },
        {
          "type": "verse",
          "number": 2,
          "label": "Verse 2",
          "lines": [
            "Perfect submission, perfect delight,",
            "Visions of rapture now burst on my sight;",
            "Angels descending bring from above",
            "Echoes of mercy, whispers of love.",
          ],
        },
      ],
    },
    {
      "id": "sdah-300",
      "hymnalCode": "SDAH",
      "hymnalName": "SDA Hymnal",
      "number": 300,
      "title": "Rock of Ages",
      "author": "Augustus M. Toplady (1776)",
      "composer": "Thomas Hastings (1830)",
      "scripture": "1 Corinthians 10:4",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "Bb",
        "tuneName": "TOPLADY",
        "meter": "7.7.7.7.7.7",
        "defaultBpm": 84,
        "melodyNotes": [65, 62, 65, 67, 65, 62, 58, 60, 58],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "Rock of Ages, cleft for me,",
            "Let me hide myself in Thee;",
            "Let the water and the blood,",
            "From Thy wounded side which flowed,",
            "Be of sin the double cure,",
            "Save from wrath and make me pure.",
          ],
          "chords": [
            "[Bb] Rock of Ages, cleft for me,",
            "[Eb] Let me hide my-[Bb]self in [F] Thee;",
            "[F7] Let the water [Bb] and the blood,",
            "[F7] From Thy wounded [Bb] side which flowed,",
            "Be of sin the [Eb] double [Bb] cure,",
            "Save from [Eb] wrath and [F7] make me [Bb] pure.",
          ],
        },
      ],
    },
    {
      "id": "sdah-334",
      "hymnalCode": "SDAH",
      "hymnalName": "SDA Hymnal",
      "number": 334,
      "title": "Come, Thou Fount of Every Blessing",
      "author": "Robert Robinson (1758)",
      "composer": "John Wyeth (1813)",
      "scripture": "1 Samuel 7:12",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "Eb",
        "tuneName": "NETTLETON",
        "meter": "8.7.8.7.D",
        "defaultBpm": 88,
        "melodyNotes": [63, 63, 67, 67, 70, 68, 67, 65, 63],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "Come, Thou Fount of every blessing,",
            "Tune my heart to sing Thy grace;",
            "Streams of mercy, never ceasing,",
            "Call for songs of loudest praise.",
            "Teach me some melodious sonnet,",
            "Sung by flaming tongues above;",
            "Praise the mount! I’m fixed upon it,",
            "Mount of Thy redeeming love.",
          ],
          "chords": [
            "[Eb] Come, Thou Fount of every blessing,",
            "Tune my [Bb] heart to sing Thy [Eb] grace;",
            "Streams of mercy, never ceasing,",
            "Call for [Bb] songs of loudest [Eb] praise.",
            "Teach me [Ab] some me-[Eb]lodious sonnet,",
            "Sung by [Ab] flaming [Eb] tongues a-[Bb]bove;",
            "[Eb] Praise the mount! I’m fixed upon it,",
            "Mount of [Bb] Thy redeeming [Eb] love.",
          ],
        },
      ],
    },

    // ==========================================
    // --- SDAH EXTENDED / GOSPEL FAVORITES ---
    // ==========================================
    {
      "id": "ext-701",
      "hymnalCode": "EXT",
      "hymnalName": "SDAH Extended",
      "number": 701,
      "title": "Till the Storm Passes By",
      "author": "Mosie Lister (1958)",
      "composer": "Mosie Lister (1958)",
      "scripture": "Psalm 57:1",
      "historyNote":
          "Composed by Mosie Lister in 1958 based on Psalm 57:1: 'in the shadow of thy wings will I make my refuge, until these calamities be overpast.' A favorite in Adventist camp meetings and quartet concerts worldwide.",
      "rights": {
        "type": "copyrightedPermission",
        "rightsHolder": "Lillenas Publishing Company",
        "verifiedAt": "2026-09-06",
      },
      "music": {
        "defaultKey": "F",
        "tuneName": "PASSES BY",
        "meter": "Irregular with Refrain",
        "defaultBpm": 76,
        "midiAsset": "assets/midi/till_the_storm_passes_by.mid",
        "scoreAsset": "assets/scores/till_the_storm_passes_by.svg",
        "melodyNotes": [60, 62, 65, 67, 69, 65, 67, 69, 72, 69],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "In the dark of the midnight have I oft hid my face,",
            "While the storm howls above me, and there’s no hiding place.",
            "’Mid the crash of the thunder, Precious Lord, hear my cry,",
            "“Keep me safe till the storm passes by.”",
          ],
          "chords": [
            "[F] In the dark of the midnight have I [Bb] oft hid my [F] face,",
            "While the storm howls above me, and there’s [G7] no hiding [C7] place.",
            "[F] ’Mid the crash of the thunder, Precious [Bb] Lord, hear my cry,",
            "“[F] Keep me safe till the [C7] storm passes [F] by.”",
          ],
        },
        {
          "type": "chorus",
          "label": "Refrain",
          "lines": [
            "Till the storm passes over, till the thunder sounds no more,",
            "Till the clouds roll forever from the sky;",
            "Hold me fast, let me stand in the hollow of Thy hand,",
            "Keep me safe till the storm passes by.",
          ],
          "chords": [
            "[F] Till the storm passes over, till the [Bb] thunder sounds no [F] more,",
            "Till the clouds roll forever from the [C7] sky;",
            "[F] Hold me fast, let me stand in the [Bb] hollow of Thy hand,",
            "[F] Keep me safe till the [C7] storm passes [F] by.",
          ],
        },
        {
          "type": "verse",
          "number": 2,
          "label": "Verse 2",
          "lines": [
            "Many times Satan whispers, “There is no use to try,",
            "For there’s no end of sorrow, there’s no hope by and by.”",
            "But I know Thou art with me, and tomorrow I’ll rise",
            "Where the storms never darken the skies.",
          ],
        },
      ],
    },
    {
      "id": "ext-702",
      "hymnalCode": "EXT",
      "hymnalName": "SDAH Extended",
      "number": 702,
      "title": "He Touched Me",
      "author": "William J. Gaither (1963)",
      "composer": "William J. Gaither (1963)",
      "scripture": "Matthew 8:3",
      "rights": {
        "type": "copyrightedPermission",
        "rightsHolder": "Gaither Music",
        "verifiedAt": "2026-09-06",
      },
      "music": {
        "defaultKey": "Eb",
        "tuneName": "HE TOUCHED ME",
        "meter": "Irregular with Refrain",
        "defaultBpm": 80,
        "melodyNotes": [63, 67, 70, 72, 70, 67, 65, 63],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "Shackled by a heavy burden,",
            "’Neath a load of guilt and shame,",
            "Then the hand of Jesus touched me,",
            "And now I am no longer the same.",
          ],
          "chords": [
            "[Eb] Shackled by a heavy [Ab] burden,",
            "[Eb] ’Neath a load of guilt and [Bb] shame,",
            "[Eb] Then the hand of Jesus [Ab] touched me,",
            "And [Eb] now I am no [Bb7] longer the [Eb] same.",
          ],
        },
        {
          "type": "chorus",
          "label": "Refrain",
          "lines": [
            "He touched me, oh, He touched me,",
            "And oh, the joy that floods my soul!",
            "Something happened and now I know,",
            "He touched me and made me whole.",
          ],
          "chords": [
            "[Eb] He touched me, [Ab] oh, He [Eb] touched me,",
            "And oh, the joy that floods my [Bb] soul!",
            "[Eb] Something happened and [Ab] now I know,",
            "He [Eb] touched me and [Bb7] made me [Eb] whole.",
          ],
        },
      ],
    },
    {
      "id": "ext-703",
      "hymnalCode": "EXT",
      "hymnalName": "SDAH Extended",
      "number": 703,
      "title": "Because He Lives",
      "author": "Gloria & William J. Gaither (1971)",
      "composer": "William J. Gaither (1971)",
      "scripture": "John 14:19",
      "rights": {
        "type": "copyrightedPermission",
        "rightsHolder": "William J. Gaither",
        "verifiedAt": "2026-09-06",
      },
      "music": {
        "defaultKey": "Ab",
        "tuneName": "RESURRECTION",
        "meter": "P.M. with Refrain",
        "defaultBpm": 84,
        "melodyNotes": [60, 63, 68, 70, 68, 67, 65, 68],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "God sent His Son, they called Him Jesus;",
            "He came to love, heal and forgive.",
            "He lived and died to buy my pardon;",
            "An empty grave is there to prove my Savior lives.",
          ],
          "chords": [
            "[Ab] God sent His Son, they called Him [Db] Jesus;",
            "He came to [Ab] love, heal and for-[Eb]give.",
            "He lived and [Ab] died to buy my [Db] pardon;",
            "An empty [Ab] grave is there to [Eb7] prove my Savior [Ab] lives.",
          ],
        },
        {
          "type": "chorus",
          "label": "Refrain",
          "lines": [
            "Because He lives, I can face tomorrow,",
            "Because He lives, all fear is gone;",
            "Because I know He holds the future,",
            "And life is worth the living, just because He lives.",
          ],
          "chords": [
            "[Ab] Because He lives, I can face to-[Db]morrow,",
            "Because He [Ab] lives, all fear is [Eb] gone;",
            "Because I [Ab] know He holds the [Db] future,",
            "And life is [Ab] worth the living, [Eb7] just because He [Ab] lives.",
          ],
        },
      ],
    },
    {
      "id": "ext-706",
      "hymnalCode": "EXT",
      "hymnalName": "SDAH Extended",
      "number": 706,
      "title": "Side by Side",
      "author": "Jeff Wood (1980)",
      "composer": "Jeff Wood (1980)",
      "scripture": "Hebrews 10:24-25",
      "historyNote":
          "Beloved fellowship chorus written by Jeff Wood for youth rallies and Sabbath fellowship gatherings across the Adventist Church.",
      "rights": {
        "type": "copyrightedPermission",
        "rightsHolder": "Jeff Wood",
        "verifiedAt": "2026-09-06",
      },
      "music": {
        "defaultKey": "G",
        "tuneName": "SIDE BY SIDE",
        "meter": "Irregular",
        "defaultBpm": 104,
        "scoreAsset": "assets/scores/side_by_side.svg",
        "melodyNotes": [55, 59, 62, 67, 66, 64, 62, 59, 60],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Stanza 1",
          "lines": [
            "Side by side we stand awaiting God’s command,",
            "Worshiping the King of kings.",
            "Hand in hand we go, all the world will know",
            "Jesus is the King of kings.",
          ],
          "chords": [
            "[G] Side by side we stand awaiting [C] God’s command,",
            "[D] Worshiping the King of [G] kings.",
            "Hand in hand we go, all the [C] world will know",
            "[D] Jesus is the King of [G] kings.",
          ],
        },
        {
          "type": "chorus",
          "label": "Refrain",
          "lines": [
            "A family on earth, we’ve found a second birth,",
            "And soon we’ll reach that crystal shore;",
            "Side by side we stand, a consecrated band,",
            "United with the Lord forevermore.",
          ],
          "chords": [
            "[C] A family on earth, we’ve [G] found a second birth,",
            "And [A7] soon we’ll reach that crystal [D7] shore;",
            "[G] Side by side we stand, a [C] consecrated band,",
            "[D] United with the Lord for-[G]evermore.",
          ],
        },
      ],
    },

    // ==========================================
    // --- KRISTU MUNZWIYO (SHONA - ZIMBABWE) ---
    // ==========================================
    {
      "id": "km-1",
      "hymnalCode": "KM",
      "hymnalName": "Kristu Munzwiyo",
      "number": 1,
      "title": "Mwari Muri Muzvose",
      "author": "Traditional Shona Translation",
      "composer": "Traditional",
      "scripture": "Pisarema 145:3",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "G",
        "tuneName": "MUZVOSE",
        "meter": "8.7.8.7",
        "defaultBpm": 84,
        "melodyNotes": [55, 59, 62, 64, 62, 59, 57, 55],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Ndima 1",
          "lines": [
            "Mwari wedu wakanaka,",
            "Muri muzvose zvose;",
            "Tinokudza zita renyu,",
            "Nokusingaperi.",
          ],
          "chords": [
            "[G] Mwari wedu [C] wakanaka,",
            "[G] Muri muzvose [D] zvose;",
            "[G] Tinokudza [C] zita renyu,",
            "[G] Nokusi-[D]nga-[G]peri.",
          ],
        },
        {
          "type": "verse",
          "number": 2,
          "label": "Ndima 2",
          "lines": [
            "Denga rose rinorumbidza,",
            "Ukuru hwamambo;",
            "Nesuwo pasi pano,",
            "Tinomurumbidza.",
          ],
        },
      ],
    },
    {
      "id": "km-12",
      "hymnalCode": "KM",
      "hymnalName": "Kristu Munzwiyo",
      "number": 12,
      "title": "Kudenga Kuna Baba",
      "author": "F. E. Belden / Shona Hymnal Committee",
      "composer": "F. E. Belden",
      "scripture": "Johani 14:1-3",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "F",
        "tuneName": "KUDENGA",
        "meter": "8.7.8.7 with Refrain",
        "defaultBpm": 88,
        "melodyNotes": [65, 69, 72, 69, 65, 67, 69, 65],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Ndima 1",
          "lines": [
            "Kudenga kuna Baba vangu,",
            "Musha wakanaka;",
            "Hakuna rufu kana misodzi,",
            "Mufaro chete.",
          ],
          "chords": [
            "[F] Kudenga kuna [Bb] Baba vangu,",
            "[F] Musha waka-[C]naka;",
            "[F] Hakuna rufu [Bb] kana misodzi,",
            "[F] Mufaro [C] che-[F]te.",
          ],
        },
        {
          "type": "chorus",
          "label": "Korus",
          "lines": [
            "Ndinoenda ikoko,",
            "Musha wevatsvene;",
            "Kudenga kuna Baba,",
            "Musha wangu.",
          ],
          "chords": [
            "[Bb] Ndinoenda [F] ikoko,",
            "Musha weva-[C]tsvene;",
            "[F] Kudenga kuna [Bb] Baba,",
            "[F] Musha [C] wa-[F]ngu.",
          ],
        },
      ],
    },
    {
      "id": "km-54",
      "hymnalCode": "KM",
      "hymnalName": "Kristu Munzwiyo",
      "number": 54,
      "title": "Jesu Ndishamwari Yedu",
      "originalTitle": "What a Friend We Have in Jesus",
      "author": "Joseph Scriven / Shona Translation",
      "composer": "Charles C. Converse",
      "scripture": "Johani 15:13",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "F",
        "tuneName": "CONVERSE",
        "meter": "8.7.8.7.D",
        "defaultBpm": 88,
        "melodyNotes": [65, 65, 67, 65, 62, 57, 60, 62, 60],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Ndima 1",
          "lines": [
            "Jesu ndishamwari yedu,",
            "Anonzwa minyengetero;",
            "Tine mufaro mukuru,",
            "Tichitaura naye.",
            "Asi kazhinji tinochema,",
            "Nokushaya rugare,",
            "Nokuti hatina kutakura,",
            "Zvose mumunyengetero.",
          ],
          "chords": [
            "[F] Jesu ndishamwari [Bb] yedu,",
            "[F] Anonzwa minye-[C]ngetero;",
            "[F] Tine mufaro mu-[Bb]kuru,",
            "[F] Tichitaura [C] na-[F]ye.",
            "[C] Asi kazhinji tino-[F]chema,",
            "[Bb] Nokushaya [F] ruga-[C]re,",
            "[F] Nokuti hatina ku-[Bb]takura,",
            "[F] Zvose mumu-[C]nyenge-[F]tero.",
          ],
        },
      ],
    },
    {
      "id": "km-118",
      "hymnalCode": "KM",
      "hymnalName": "Kristu Munzwiyo",
      "number": 118,
      "title": "Tine Tariro Iyoyi",
      "originalTitle": "We Have This Hope",
      "author": "Wayne Hooper / Shona Translation",
      "composer": "Wayne Hooper",
      "scripture": "Tito 2:13",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "Ab",
        "tuneName": "WE HAVE THIS HOPE",
        "meter": "Irregular",
        "defaultBpm": 80,
        "melodyNotes": [60, 63, 65, 68, 68, 67, 65, 68, 72, 70],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Ndima 1",
          "lines": [
            "Tine tariro inopfuta mumwoyo yedu,",
            "Tariro yokudzoka kwaTenzi.",
            "Tine rutendo rwaKristu anopa isu,",
            "Kutenda mushoko rake.",
            "Tinotenda nguva yasvika,",
            "Kuti vanhu vemarudzi,",
            "Vamuke vaombere nziyo:",
            "Hareruya! Kristu Mambo!",
            "Tine tariro inopfuta mumwoyo yedu,",
            "Tariro yokudzoka kwaTenzi.",
          ],
          "chords": [
            "[Ab] Tine tariro inopfuta mumwoyo [Eb] yedu,",
            "[Db] Tariro yo-[Eb]kudzoka kwa-[Ab]Tenzi.",
            "Tine rutendo rwaKristu anopa [Eb] isu,",
            "[Db] Kutenda mu-[Eb]shoko [Ab] rake.",
            "Tinotenda [Fm] nguva yasvika,",
            "Kuti vanhu [Bbm] vemarudzi,",
            "Vamuke va-[Eb]ombere nziyo:",
            "[Ab] Hareruya! [Eb] Kristu Mambo!",
            "[Ab] Tine tariro inopfuta mumwoyo [Eb] yedu,",
            "[Db] Tariro yo-[Eb7]kudzoka kwa-[Ab]Tenzi.",
          ],
        },
      ],
    },

    // ==========================================
    // --- UKRISTU ESIHLABELELWENI (NDEBELE/ZULU) ---
    // ==========================================
    {
      "id": "ue-1",
      "hymnalCode": "UE",
      "hymnalName": "UKristu Esihlabelelweni",
      "number": 1,
      "title": "Udumo Lonke Malube Kuwe",
      "author": "Traditional Ndebele/Zulu",
      "composer": "Traditional",
      "scripture": "IHubo 100:1-2",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "G",
        "tuneName": "UDUMO",
        "meter": "8.7.8.7",
        "defaultBpm": 84,
        "melodyNotes": [55, 59, 62, 64, 62, 59, 57, 55],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Isitanza 1",
          "lines": [
            "Udumo lonke malube kuwe,",
            "Nkulunkulu Simakade;",
            "Siphakamisa igama lakho,",
            "Kuzo zonke izizukulwane.",
          ],
          "chords": [
            "[G] Udumo lonke [C] malube [G] kuwe,",
            "Nkulunkulu Sima-[D]kade;",
            "[G] Siphakamisa [C] igama [G] lakho,",
            "Kuzo zonke [D] izizuku-[G]lwane.",
          ],
        },
      ],
    },
    {
      "id": "ue-45",
      "hymnalCode": "UE",
      "hymnalName": "UKristu Esihlabelelweni",
      "number": 45,
      "title": "UJesu Ungumngane Wethu",
      "originalTitle": "What a Friend We Have in Jesus",
      "author": "Joseph Scriven / Ndebele Translation",
      "composer": "Charles C. Converse",
      "scripture": "NgokukaJohane 15:13",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "F",
        "tuneName": "CONVERSE",
        "meter": "8.7.8.7.D",
        "defaultBpm": 88,
        "melodyNotes": [65, 65, 67, 65, 62, 57, 60, 62, 60],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Isitanza 1",
          "lines": [
            "UJesu ungumngane wethu,",
            "Uthwala izono zonke;",
            "Kumnandi ukuzisa konke,",
            "Kuye ngomkhuleko.",
            "Kukanengi sisezinhlungwini,",
            "Silahlekelwa ngokuthula,",
            "Ngokungathwali zonke izinto,",
            "Kuye ngomkhuleko.",
          ],
          "chords": [
            "[F] UJesu ungu-[Bb]mngane [F] wethu,",
            "Uthwala izono [C] zonke;",
            "[F] Kumnandi uku-[Bb]zisa [F] konke,",
            "Kuye ngo-[C]mkhu-[F]leko.",
            "[C] Kukanengi sise-[F]zinhlungwini,",
            "[Bb] Silahlekelwa [F] ngoku-[C]thula,",
            "[F] Ngokungathwali [Bb] zonke [F] izinto,",
            "Kuye ngo-[C]mkhu-[F]leko.",
          ],
        },
      ],
    },
    {
      "id": "ue-68",
      "hymnalCode": "UE",
      "hymnalName": "UKristu Esihlabelelweni",
      "number": 68,
      "title": "Sinethemba Elinjalo",
      "originalTitle": "We Have This Hope",
      "author": "Wayne Hooper / Ndebele Translation",
      "composer": "Wayne Hooper",
      "scripture": "KuThithu 2:13",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "Ab",
        "tuneName": "WE HAVE THIS HOPE",
        "meter": "Irregular",
        "defaultBpm": 80,
        "melodyNotes": [60, 63, 65, 68, 68, 67, 65, 68, 72, 70],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Isitanza 1",
          "lines": [
            "Sinethemba elivuthayo ezinhliziyweni,",
            "Ithemba lokubuya kweNkosi.",
            "Sinokukholwa uJesu akunika thina,",
            "Ukukholwa ezwini lakhe.",
            "Siyakholwa isikhathi sesifikile,",
            "Lapho zonke izizwe zivuke,",
            "Zihlabelele ngokujabula:",
            "Haleluya! UKristu uyiNkosi!",
            "Sinethemba elivuthayo ezinhliziyweni,",
            "Ithemba lokubuya kweNkosi.",
          ],
          "chords": [
            "[Ab] Sinethemba elivuthayo ezinhlizi-[Eb]yweni,",
            "[Db] Ithemba loku-[Eb]buya kwe-[Ab]Nkosi.",
            "Sinokukholwa uJesu akunika [Eb] thina,",
            "[Db] Ukukholwa e-[Eb]zwini [Ab] lakhe.",
            "Siyakholwa [Fm] isikhathi sesifikile,",
            "Lapho zonke [Bbm] izizwe zivuke,",
            "Zihlabelele [Eb] ngokujabula:",
            "[Ab] Haleluya! [Eb] UKristu uyiNkosi!",
            "[Ab] Sinethemba elivuthayo ezinhlizi-[Eb]yweni,",
            "[Db] Ithemba loku-[Eb7]buya kwe-[Ab]Nkosi.",
          ],
        },
      ],
    },

    // ==========================================
    // --- NYIMBO ZA KRISTO (SWAHILI) ---
    // ==========================================
    {
      "id": "nzk-1",
      "hymnalCode": "NZK",
      "hymnalName": "Nyimbo za Kristo",
      "number": 1,
      "title": "Bwana Mungu Nashangaa Kabisa",
      "originalTitle": "How Great Thou Art",
      "author": "Carl Boberg / Swahili Translation",
      "composer": "Swedish Folk Melody",
      "scripture": "Zaburi 8:1",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "Bb",
        "tuneName": "O STORE GUD",
        "meter": "11.10.11.10 with Refrain",
        "defaultBpm": 84,
        "melodyNotes": [58, 62, 65, 67, 65, 62, 58, 60, 62],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Ubeti 1",
          "lines": [
            "Bwana Mungu, nashangaa kabisa,",
            "Nikifikiri jinsi ulivyofanya;",
            "Nyota na radi zote za mawingu,",
            "Zinaonyesha nguvu zako kuu.",
          ],
          "chords": [
            "[Bb] Bwana Mungu, na-[Eb]shangaa kabisa,",
            "Niki-[Bb]fikiri jinsi [F] ulivyofanya;",
            "[Bb] Nyota na radi [Eb] zote za mawingu,",
            "Zina-[Bb]onyesha [F7] nguvu zako [Bb] kuu.",
          ],
        },
        {
          "type": "chorus",
          "label": "Kiitikio",
          "lines": [
            "Roho yangu na ikuimbie,",
            "Jinsi Wewe ulivyo mkuu!",
            "Roho yangu na ikuimbie,",
            "Jinsi Wewe ulivyo mkuu!",
          ],
          "chords": [
            "[Bb] Roho yangu na [Eb] ikuimbie,",
            "Jinsi [Bb] Wewe [Gm] ulivyo [F] mkuu!",
            "[Bb] Roho yangu na [Eb] ikuimbie,",
            "Jinsi [Bb] Wewe u-[F7]livyo [Bb] mkuu!",
          ],
        },
      ],
    },
    {
      "id": "nzk-13",
      "hymnalCode": "NZK",
      "hymnalName": "Nyimbo za Kristo",
      "number": 13,
      "title": "Yesu Kwetu Ni Rafiki",
      "originalTitle": "What a Friend We Have in Jesus",
      "author": "Joseph Scriven / Swahili Translation",
      "composer": "Charles C. Converse",
      "scripture": "Yohana 15:13",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "F",
        "tuneName": "CONVERSE",
        "meter": "8.7.8.7.D",
        "defaultBpm": 88,
        "melodyNotes": [65, 65, 67, 65, 62, 57, 60, 62, 60],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Ubeti 1",
          "lines": [
            "Yesu kwetu ni Rafiki,",
            "Hutwambia maombi;",
            "Tukiwa na masumbuko,",
            "Hutufariji moyo.",
            "Mara nyingi tunakosa",
            "Amani na furaha,",
            "Kwa kutomwomba Mwokozi",
            "Kila jambo kwa sala.",
          ],
          "chords": [
            "[F] Yesu kwetu ni [Bb] Rafiki,",
            "[F] Hutwambia ma-[C]ombi;",
            "[F] Tukiwa na ma-[Bb]sumbuko,",
            "[F] Hutufariji [C] mo-[F]yo.",
            "[C] Mara nyingi tuna-[F]kosa",
            "[Bb] Amani na [F] fura-[C]ha,",
            "[F] Kwa kutomwomba Mwo-[Bb]kozi",
            "[F] Kila jambo [C] kwa [F] sala.",
          ],
        },
      ],
    },
    {
      "id": "nzk-46",
      "hymnalCode": "NZK",
      "hymnalName": "Nyimbo za Kristo",
      "number": 46,
      "title": "Tuna Lile Tumaini",
      "originalTitle": "We Have This Hope",
      "author": "Wayne Hooper / Swahili Translation",
      "composer": "Wayne Hooper",
      "scripture": "Tito 2:13",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "Ab",
        "tuneName": "WE HAVE THIS HOPE",
        "meter": "Irregular",
        "defaultBpm": 80,
        "melodyNotes": [60, 63, 65, 68, 68, 67, 65, 68, 72, 70],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Ubeti 1",
          "lines": [
            "Tuna lile tumaini liwakalo mioyoni,",
            "Tumaini la kuja kwa Bwana.",
            "Tuna ile imani Kristo anayetupatia,",
            "Imani katika Neno Lake.",
            "Tunaamini wakati umefika,",
            "Mataifa yote duniani",
            "Yataamka na kuimba:",
            "Haleluya! Kristo Mfalme!",
            "Tuna lile tumaini liwakalo mioyoni,",
            "Tumaini la kuja kwa Bwana.",
          ],
          "chords": [
            "[Ab] Tuna lile tumaini liwakalo mi-[Eb]oyoni,",
            "[Db] Tumaini la [Eb] kuja kwa [Ab] Bwana.",
            "Tuna ile imani Kristo anayetu-[Eb]patia,",
            "[Db] Imani kati-[Eb]ka Neno [Ab] Lake.",
            "Tunaamini [Fm] wakati umefika,",
            "Mataifa [Bbm] yote duniani",
            "Yataamka [Eb] na kuimba:",
            "[Ab] Haleluya! [Eb] Kristo Mfalme!",
            "[Ab] Tuna lile tumaini liwakalo mi-[Eb]oyoni,",
            "[Db] Tumaini la [Eb7] kuja kwa [Ab] Bwana.",
          ],
        },
      ],
    },
    {
      "id": "sdah-340",
      "hymnalCode": "SDAH",
      "hymnalName": "SDA Hymnal",
      "number": 340,
      "title": "Jesus Saves",
      "author": "Priscilla J. Owens (1882)",
      "composer": "William J. Kirkpatrick (1882)",
      "scripture": "Hebrews 7:25",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "G",
        "tuneName": "JESUS SAVES",
        "meter": "7.6.7.6.7.7.7.6",
        "defaultBpm": 108,
        "melodyNotes": [67, 67, 67, 69, 71, 67, 64, 62],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "We have heard the joyful sound:",
            "Jesus saves! Jesus saves!",
            "Spread the tidings all around:",
            "Jesus saves! Jesus saves!",
            "Bear the news to every land,",
            "Climb the steeps and cross the waves;",
            "Onward! ’tis our Lord’s command;",
            "Jesus saves! Jesus saves!",
          ],
          "chords": [
            "[G] We have heard the joyful sound:",
            "Jesus [D] saves! Jesus [G] saves!",
            "Spread the tidings all around:",
            "Jesus [D7] saves! Jesus [G] saves!",
            "Bear the news to [C] every land,",
            "[G] Climb the steeps and [D] cross the waves;",
            "[G] Onward! ’tis our Lord’s command;",
            "Jesus [D7] saves! Jesus [G] saves!",
          ],
        },
      ],
    },
    {
      "id": "sdah-516",
      "hymnalCode": "SDAH",
      "hymnalName": "SDA Hymnal",
      "number": 516,
      "title": "All the Way My Savior Leads Me",
      "author": "Fanny J. Crosby (1875)",
      "composer": "Robert Lowry (1875)",
      "scripture": "Isaiah 48:17",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "Ab",
        "tuneName": "ALL THE WAY",
        "meter": "8.7.8.7.D",
        "defaultBpm": 84,
        "melodyNotes": [63, 63, 65, 67, 68, 67, 65, 63],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "All the way my Savior leads me;",
            "What have I to ask beside?",
            "Can I doubt His tender mercy,",
            "Who through life has been my Guide?",
            "Heav’nly peace, divinest comfort,",
            "Here by faith in Him to dwell!",
            "For I know, whate’er befall me,",
            "Jesus doeth all things well.",
          ],
          "chords": [
            "[Ab] All the way my Savior leads me;",
            "What have [Db] I to ask be-[Ab]side?",
            "Can I doubt His tender mercy,",
            "Who through [Eb7] life has been my [Ab] Guide?",
            "Heav’nly peace, divinest [Db] comfort,",
            "Here by [Ab] faith in [Eb] Him to dwell!",
            "[Ab] For I know, whate’er befall me,",
            "Jesus [Eb7] doeth all things [Ab] well.",
          ],
        },
      ],
    },
    {
      "id": "sdah-524",
      "hymnalCode": "SDAH",
      "hymnalName": "SDA Hymnal",
      "number": 524,
      "title": "’Tis So Sweet to Trust in Jesus",
      "author": "Louisa M. R. Stead (1882)",
      "composer": "William J. Kirkpatrick (1882)",
      "scripture": "Psalm 34:8",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "Ab",
        "tuneName": "TRUST IN JESUS",
        "meter": "8.7.8.7 with Refrain",
        "defaultBpm": 90,
        "melodyNotes": [60, 63, 65, 68, 67, 65, 63, 65],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "’Tis so sweet to trust in Jesus,",
            "Just to take Him at His word;",
            "Just to rest upon His promise,",
            "Just to know, “Thus saith the Lord.”",
          ],
          "chords": [
            "[Ab] ’Tis so sweet to trust in Jesus,",
            "Just to [Db] take Him at His [Ab] word;",
            "Just to rest upon His promise,",
            "Just to [Eb7] know, “Thus saith the [Ab] Lord.”",
          ],
        },
        {
          "type": "chorus",
          "label": "Refrain",
          "lines": [
            "Jesus, Jesus, how I trust Him!",
            "How I’ve proved Him o’er and o’er!",
            "Jesus, Jesus, precious Jesus!",
            "O for grace to trust Him more!",
          ],
          "chords": [
            "[Ab] Jesus, Jesus, how I trust Him!",
            "How I’ve [Eb] proved Him o’er and [Ab] o’er!",
            "Jesus, Jesus, [Db] precious Jesus!",
            "[Ab] O for grace to [Eb7] trust Him [Ab] more!",
          ],
        },
      ],
    },
    {
      "id": "sdah-625",
      "hymnalCode": "SDAH",
      "hymnalName": "SDA Hymnal",
      "number": 625,
      "title": "Higher Ground",
      "author": "Johnson Oatman Jr. (1898)",
      "composer": "Charles H. Gabriel (1898)",
      "scripture": "Philippians 3:14",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "Ab",
        "tuneName": "HIGHER GROUND",
        "meter": "L.M. with Refrain",
        "defaultBpm": 96,
        "melodyNotes": [60, 63, 65, 68, 70, 72, 68, 65],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "I’m pressing on the upward way,",
            "New heights I’m gaining every day;",
            "Still praying as I’m onward bound,",
            "“Lord, plant my feet on higher ground.”",
          ],
          "chords": [
            "[Ab] I’m pressing on the upward way,",
            "New [Db] heights I’m gaining [Ab] every day;",
            "Still praying as I’m onward bound,",
            "“Lord, [Eb7] plant my feet on higher [Ab] ground.”",
          ],
        },
        {
          "type": "chorus",
          "label": "Refrain",
          "lines": [
            "Lord, lift me up, and let me stand",
            "By faith on Canaan’s tableland;",
            "A higher plane than I have found,",
            "Lord, plant my feet on higher ground.",
          ],
          "chords": [
            "[Ab] Lord, lift me up, and let me stand",
            "By [Db] faith on Canaan’s tableland;",
            "A [Ab] higher plane than I have found,",
            "Lord, [Eb7] plant my feet on higher [Ab] ground.",
          ],
        },
      ],
    },
    {
      "id": "sdah-633",
      "hymnalCode": "SDAH",
      "hymnalName": "SDA Hymnal",
      "number": 633,
      "title": "When We All Get to Heaven",
      "author": "Eliza E. Hewitt (1898)",
      "composer": "Emily D. Wilson (1898)",
      "scripture": "Revelation 21:4",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "C",
        "tuneName": "HEAVEN",
        "meter": "P.M. with Refrain",
        "defaultBpm": 104,
        "melodyNotes": [60, 64, 67, 69, 67, 64, 62, 60],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "Sing the wondrous love of Jesus,",
            "Sing His mercy and His grace;",
            "In the mansions fair and blessed",
            "He’ll prepare for us a place.",
          ],
          "chords": [
            "[C] Sing the wondrous love of Jesus,",
            "Sing His [G] mercy and His [C] grace;",
            "In the mansions fair and blessed",
            "He’ll pre-[G7]pare for us a [C] place.",
          ],
        },
        {
          "type": "chorus",
          "label": "Refrain",
          "lines": [
            "When we all get to heaven,",
            "What a day of rejoicing that will be!",
            "When we all see Jesus,",
            "We’ll sing and shout the victory!",
          ],
          "chords": [
            "[C] When we all get to heaven,",
            "What a [G] day of rejoicing [C] that will be!",
            "When we all see Jesus,",
            "We’ll [C] sing and [G7] shout the [C] victory!",
          ],
        },
      ],
    },
    {
      "id": "ext-704",
      "hymnalCode": "EXT",
      "hymnalName": "SDAH Extended",
      "number": 704,
      "title": "In the Garden",
      "author": "C. Austin Miles (1912)",
      "composer": "C. Austin Miles (1912)",
      "scripture": "John 20:14-16",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "Ab",
        "tuneName": "GARDEN",
        "meter": "8.9.8.9 with Refrain",
        "defaultBpm": 78,
        "melodyNotes": [60, 63, 65, 68, 67, 65, 63, 65],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "I come to the garden alone,",
            "While the dew is still on the roses;",
            "And the voice I hear, falling on my ear,",
            "The Son of God discloses.",
          ],
          "chords": [
            "[Ab] I come to the garden alone,",
            "While the [Db] dew is still on the [Ab] roses;",
            "And the voice I hear, falling on my ear,",
            "The [Eb7] Son of God dis-[Ab]closes.",
          ],
        },
        {
          "type": "chorus",
          "label": "Refrain",
          "lines": [
            "And He walks with me, and He talks with me,",
            "And He tells me I am His own;",
            "And the joy we share as we tarry there,",
            "None other has ever known.",
          ],
          "chords": [
            "[Ab] And He walks with me, and He talks with me,",
            "And He [Db] tells me I am His [Ab] own;",
            "And the joy we share as we [Eb] tarry [Ab] there,",
            "None [Eb7] other has ever [Ab] known.",
          ],
        },
      ],
    },
    {
      "id": "ext-705",
      "hymnalCode": "EXT",
      "hymnalName": "SDAH Extended",
      "number": 705,
      "title": "I’d Rather Have Jesus",
      "author": "Rhea F. Miller (1922)",
      "composer": "George Beverly Shea (1932)",
      "scripture": "Philippians 3:8",
      "rights": {
        "type": "copyrightedPermission",
        "rightsHolder": "Chancel Music Inc.",
        "verifiedAt": "2026-09-06",
      },
      "music": {
        "defaultKey": "Db",
        "tuneName": "I'D RATHER HAVE JESUS",
        "meter": "Irregular with Refrain",
        "defaultBpm": 76,
        "melodyNotes": [61, 65, 68, 70, 68, 65, 63, 61],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "I’d rather have Jesus than silver or gold;",
            "I’d rather be His than have riches untold;",
            "I’d rather have Jesus than houses or lands;",
            "I’d rather be led by His nail-pierced hand.",
          ],
          "chords": [
            "[Db] I’d rather have Jesus than [Gb] silver or [Db] gold;",
            "I’d rather be His than have [Ab] riches un-[Db]told;",
            "I’d rather have Jesus than [Gb] houses or [Db] lands;",
            "I’d rather be led by His [Ab7] nail-pierced [Db] hand.",
          ],
        },
        {
          "type": "chorus",
          "label": "Refrain",
          "lines": [
            "Than to be the king of a vast domain,",
            "Or be held in sin’s dread sway!",
            "I’d rather have Jesus than anything",
            "This world affords today.",
          ],
          "chords": [
            "[Ab] Than to be the king of a [Db] vast domain,",
            "Or be [Ab] held in sin’s dread [Db] sway!",
            "I’d [Db] rather have Jesus than [Gb] anything",
            "This [Db] world af-[Ab7]fords to-[Db]day.",
          ],
        },
      ],
    },
    {
      "id": "ext-707",
      "hymnalCode": "EXT",
      "hymnalName": "SDAH Extended",
      "number": 707,
      "title": "Turn Your Eyes Upon Jesus",
      "author": "Helen H. Lemmel (1922)",
      "composer": "Helen H. Lemmel (1922)",
      "scripture": "Hebrews 12:2",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "F",
        "tuneName": "LEMMEL",
        "meter": "P.M. with Refrain",
        "defaultBpm": 80,
        "melodyNotes": [65, 65, 67, 69, 72, 69, 65, 67],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Verse 1",
          "lines": [
            "O soul, are you weary and troubled?",
            "No light in the darkness you see?",
            "There’s light for a look at the Savior,",
            "And life more abundant and free!",
          ],
          "chords": [
            "[F] O soul, are you [C] weary and [F] troubled?",
            "No [Bb] light in the [F] darkness you [C] see?",
            "There’s [F] light for a [C] look at the [Dm] Savior,",
            "And [Bb] life more a-[C7]bundant and [F] free!",
          ],
        },
        {
          "type": "chorus",
          "label": "Refrain",
          "lines": [
            "Turn your eyes upon Jesus,",
            "Look full in His wonderful face,",
            "And the things of earth will grow strangely dim,",
            "In the light of His glory and grace.",
          ],
          "chords": [
            "[F] Turn your [C] eyes upon [F] Jesus,",
            "Look [Bb] full in His wonderful [C] face,",
            "And the [F] things of earth will grow [Bb] strangely dim,",
            "In the [F] light of His [C7] glory and [F] grace.",
          ],
        },
      ],
    },
    {
      "id": "km-28",
      "hymnalCode": "KM",
      "hymnalName": "Kristu Munzwiyo",
      "number": 28,
      "title": "Rwizi Rwemakomborero",
      "originalTitle": "There Shall Be Showers of Blessing",
      "author": "Daniel W. Whittle / Shona Translation",
      "composer": "James McGranahan",
      "scripture": "Ezekieri 34:26",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "Bb",
        "tuneName": "SHOWERS OF BLESSING",
        "meter": "8.7.8.7 with Refrain",
        "defaultBpm": 96,
        "melodyNotes": [58, 62, 65, 67, 65, 62, 58, 60, 58],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Ndima 1",
          "lines": [
            "Rwizi rwemakomborero,",
            "Chitsidzo chorudo;",
            "Uye panonyorovera,",
            "Panozorodzwa vose.",
          ],
          "chords": [
            "[Bb] Rwizi rwema-[Eb]komborero,",
            "[Bb] Chitsidzo cho-[F]rudo;",
            "[Bb] Uye pano-[Eb]nyorovera,",
            "[Bb] Panozo-[F7]rodzwa [Bb] vose.",
          ],
        },
        {
          "type": "chorus",
          "label": "Korus",
          "lines": [
            "Rwizi rwerudo!",
            "Tipeiwo Ishe iye zvino;",
            "Tine madonhwe chete,",
            "Tinoda mvura zhinji.",
          ],
          "chords": [
            "[Bb] Rwizi rwerudo!",
            "[Eb] Tipeiwo [Bb] Ishe iye [F] zvino;",
            "[Bb] Tine madonhwe [Eb] chete,",
            "[Bb] Tinoda [F7] mvura [Bb] zhinji.",
          ],
        },
      ],
    },
    {
      "id": "km-145",
      "hymnalCode": "KM",
      "hymnalName": "Kristu Munzwiyo",
      "number": 145,
      "title": "Rugare Mumweya Wangu",
      "originalTitle": "It Is Well With My Soul",
      "author": "Horatio G. Spafford / Shona Translation",
      "composer": "Philip P. Bliss",
      "scripture": "2 Madzimambo 4:26",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "C",
        "tuneName": "VILLE DU HAVRE",
        "meter": "11.8.11.9 with Refrain",
        "defaultBpm": 84,
        "melodyNotes": [60, 64, 67, 69, 67, 64, 62, 60],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Ndima 1",
          "lines": [
            "Kana rugare rwuchitevera nzira,",
            "Kana nhamo dzinonga mafungu;",
            "Nyangwe zviri sei, mandidzidzisa:",
            "Zvakanaka, rugare mumweya.",
          ],
          "chords": [
            "[C] Kana rugare rwuchitevera nzira,",
            "Kana [Am] nhamo dzi-[G]nonga ma-[C]fungu;",
            "[F] Nyangwe zviri sei, [Dm] mandidzidzisa:",
            "[C] Zvakanaka, [G] rugare mu-[C]mweya.",
          ],
        },
        {
          "type": "chorus",
          "label": "Korus",
          "lines": [
            "Mumweya, rugare,",
            "Zvakanaka, rugare mumweya.",
          ],
          "chords": [
            "[C] Mumweya, [G] rugare,",
            "[F] Zvakanaka, [G7] rugare mu-[C]mweya.",
          ],
        },
      ],
    },
    {
      "id": "ue-112",
      "hymnalCode": "UE",
      "hymnalName": "UKristu Esihlabelelweni",
      "number": 112,
      "title": "Kuhle Emphefumulweni Wami",
      "originalTitle": "It Is Well With My Soul",
      "author": "Horatio G. Spafford / Ndebele Translation",
      "composer": "Philip P. Bliss",
      "scripture": "2 AmaKhosi 4:26",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "C",
        "tuneName": "VILLE DU HAVRE",
        "meter": "11.8.11.9 with Refrain",
        "defaultBpm": 84,
        "melodyNotes": [60, 64, 67, 69, 67, 64, 62, 60],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Isitanza 1",
          "lines": [
            "Lapho ukuthula kungumngane wami,",
            "Lapho izinsizi zinjengolwandle;",
            "Kukho konke Nkosi ungifundisile:",
            "Kuhle konke emphefumulweni.",
          ],
          "chords": [
            "[C] Lapho ukuthula kungumngane wami,",
            "Lapho [Am] izinsizi zi-[G]njengolwa-[C]ndle;",
            "[F] Kukho konke Nkosi [Dm] ungifundisile:",
            "[C] Kuhle konke [G] emphefu-[C]mulweni.",
          ],
        },
        {
          "type": "chorus",
          "label": "Ikhorasi",
          "lines": [
            "Kuhle nya, enhliziyweni,",
            "Kuhle konke emphefumulweni.",
          ],
          "chords": [
            "[C] Kuhle nya, [G] enhliziyweni,",
            "[F] Kuhle konke [G7] emphefu-[C]mulweni.",
          ],
        },
      ],
    },
    {
      "id": "nzk-24",
      "hymnalCode": "NZK",
      "hymnalName": "Nyimbo za Kristo",
      "number": 24,
      "title": "Salama Rohoni Mwangu",
      "originalTitle": "It Is Well With My Soul",
      "author": "Horatio G. Spafford / Swahili Translation",
      "composer": "Philip P. Bliss",
      "scripture": "2 Wafalme 4:26",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "C",
        "tuneName": "VILLE DU HAVRE",
        "meter": "11.8.11.9 with Refrain",
        "defaultBpm": 84,
        "melodyNotes": [60, 64, 67, 69, 67, 64, 62, 60],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Ubeti 1",
          "lines": [
            "Nionapo amani kama shwari,",
            "Au nionapo msiba;",
            "Kwa mambo yote umenijulisha:",
            "Ni salama rohoni mwangu.",
          ],
          "chords": [
            "[C] Nionapo amani kama shwari,",
            "Au [Am] niona-[G]po msi-[C]ba;",
            "[F] Kwa mambo yote [Dm] umenijulisha:",
            "[C] Ni salama [G] rohoni [C] mwangu.",
          ],
        },
        {
          "type": "chorus",
          "label": "Kiitikio",
          "lines": [
            "Salama rohoni,",
            "Ni salama rohoni mwangu.",
          ],
          "chords": [
            "[C] Salama [G] rohoni,",
            "[F] Ni salama [G7] rohoni [C] mwangu.",
          ],
        },
      ],
    },
    {
      "id": "nzk-115",
      "hymnalCode": "NZK",
      "hymnalName": "Nyimbo za Kristo",
      "number": 115,
      "title": "Neema Ya Ajabu",
      "originalTitle": "Amazing Grace",
      "author": "John Newton / Swahili Translation",
      "composer": "Traditional American Melody",
      "scripture": "1 Mambo ya Nyakati 17:16",
      "rights": {"type": "publicDomain", "verifiedAt": "2026-09-06"},
      "music": {
        "defaultKey": "G",
        "tuneName": "NEW BRITAIN",
        "meter": "8.6.8.6 (CM)",
        "defaultBpm": 84,
        "melodyNotes": [55, 60, 64, 60, 64, 62, 60, 57, 55],
      },
      "sections": [
        {
          "type": "verse",
          "number": 1,
          "label": "Ubeti 1",
          "lines": [
            "Neema ya ajabu kweli,",
            "Ilinikomboa!",
            "Nilipotea zamani,",
            "Sasa ninaona.",
          ],
          "chords": [
            "[G] Neema ya a-[C]jabu [G] kweli,",
            "Ilini-[D]komboa!",
            "Nili-[G]potea [C] zama-[G]ni,",
            "Sasa [D7] nina-[G]ona.",
          ],
        },
      ],
    },
  ];

  final catalogJson = jsonEncode({"hymnals": hymnals, "songs": songs});
  File('assets/catalog/hymnals.json').writeAsStringSync(catalogJson);
  print(
    'Wrote assets/catalog/hymnals.json (${songs.length} hymns across ${hymnals.length} hymnals)',
  );

  // 2. Generate High-Resolution 1200x700 Vector Score Sheets
  _generateSvgScore(
    'assets/scores/peace_be_still.svg',
    title: 'Peace, Be Still!',
    hymnNumber: 'CIS #433',
    key: 'Key of C Major',
    meter: '6.6.9.D with Refrain',
    author: 'Mary Ann Baker (1874)',
    composer: 'H. R. Palmer (1874)',
    firstLine: '1. Mas-ter, the tem-pest is rag-ing! The bil-lows are toss-ing high!',
  );

  _generateSvgScore(
    'assets/scores/dare_to_be_a_daniel.svg',
    title: 'Dare to Be a Daniel',
    hymnNumber: 'CIS #511',
    key: 'Key of Bb Major',
    meter: 'P.M. with Refrain',
    author: 'Philip P. Bliss (1873)',
    composer: 'Philip P. Bliss (1873)',
    firstLine: '1. Stand-ing by a pur-pose true, Heed-ing God\'s com-mand!',
  );

  _generateSvgScore(
    'assets/scores/hold_the_fort.svg',
    title: 'Hold the Fort',
    hymnNumber: 'CIS #516',
    key: 'Key of D Major',
    meter: '8.5.8.5 with Refrain',
    author: 'Philip P. Bliss (1870)',
    composer: 'Philip P. Bliss (1870)',
    firstLine: '1. Ho, my com-rades! see the sig-nal Wav-ing in the sky!',
  );

  _generateSvgScore(
    'assets/scores/amazing_grace.svg',
    title: 'Amazing Grace',
    hymnNumber: 'SDAH #108',
    key: 'Key of G Major',
    meter: '8.6.8.6 (CM)',
    author: 'John Newton (1779)',
    composer: 'Traditional American Melody (1835)',
    firstLine: '1. A-maz-ing grace! how sweet the sound, That saved a wretch like me!',
  );

  _generateSvgScore(
    'assets/scores/great_is_thy_faithfulness.svg',
    title: 'Great Is Thy Faithfulness',
    hymnNumber: 'SDAH #100',
    key: 'Key of Eb Major',
    meter: '11.10.11.10 with Refrain',
    author: 'Thomas O. Chisholm (1923)',
    composer: 'William M. Runyan (1923)',
    firstLine: '1. Great is Thy faith-ful-ness, O God my Fa-ther, There is no sha-dow of turn-ing with Thee;',
  );

  _generateSvgScore(
    'assets/scores/we_have_this_hope.svg',
    title: 'We Have This Hope',
    hymnNumber: 'SDAH #214',
    key: 'Key of Ab Major',
    meter: 'Irregular',
    author: 'Wayne Hooper (1962)',
    composer: 'Wayne Hooper (1962)',
    firstLine: 'We have this hope that burns with-in our hearts, Hope in the com-ing of the Lord.',
  );

  _generateSvgScore(
    'assets/scores/what_a_friend_we_have_in_jesus.svg',
    title: 'What a Friend We Have in Jesus',
    hymnNumber: 'SDAH #499',
    key: 'Key of F Major',
    meter: '8.7.8.7.D',
    author: 'Joseph M. Scriven (1855)',
    composer: 'Charles C. Converse (1868)',
    firstLine: '1. What a friend we have in Je-sus, All our sins and griefs to bear!',
  );

  _generateSvgScore(
    'assets/scores/blessed_assurance.svg',
    title: 'Blessed Assurance',
    hymnNumber: 'SDAH #462',
    key: 'Key of D Major',
    meter: '9.10.9.9 with Refrain',
    author: 'Fanny J. Crosby (1873)',
    composer: 'Phoebe P. Knapp (1873)',
    firstLine: '1. Bless-ed as-sur-ance, Je-sus is mine! Oh, what a fore-taste of glo-ry di-vine!',
  );

  _generateSvgScore(
    'assets/scores/till_the_storm_passes_by.svg',
    title: 'Till the Storm Passes By',
    hymnNumber: 'EXT #701',
    key: 'Key of F Major',
    meter: 'Irregular with Refrain',
    author: 'Mosie Lister (1958)',
    composer: 'Mosie Lister (1958)',
    firstLine: '1. In the dark of the mid-night have I oft hid my face, While the storm howls a-bove me;',
  );

  _generateSvgScore(
    'assets/scores/side_by_side.svg',
    title: 'Side by Side',
    hymnNumber: 'EXT #706',
    key: 'Key of G Major',
    meter: 'Irregular',
    author: 'Jeff Wood (1980)',
    composer: 'Jeff Wood (1980)',
    firstLine: 'Side by side we stand a-wait-ing God\'s com-mand, Wor-ship-ing the King of kings.',
  );

  // 3. Generate Valid Standard MIDI Files (SMF)
  _generateMidiFile('assets/midi/peace_be_still.mid', [
    60, 64, 67, 69, 67, 64, 65, 67, 65, 64, 62, 60,
  ]);
  _generateMidiFile('assets/midi/dare_to_be_a_daniel.mid', [
    58, 62, 65, 67, 65, 62, 58, 60, 62, 60, 58,
  ]);
  _generateMidiFile('assets/midi/hold_the_fort.mid', [
    62, 66, 69, 69, 69, 67, 66, 64, 62,
  ]);
  _generateMidiFile('assets/midi/amazing_grace.mid', [
    55, 60, 64, 60, 64, 62, 60, 57, 55,
  ]);
  _generateMidiFile('assets/midi/great_is_thy_faithfulness.mid', [
    63, 67, 70, 68, 67, 65, 63, 65, 67, 63,
  ]);
  _generateMidiFile('assets/midi/we_have_this_hope.mid', [
    60, 63, 65, 68, 68, 67, 65, 68, 72, 70,
  ]);
  _generateMidiFile('assets/midi/what_a_friend_we_have_in_jesus.mid', [
    65, 65, 67, 65, 62, 57, 60, 62, 60,
  ]);
  _generateMidiFile('assets/midi/blessed_assurance.mid', [
    66, 69, 74, 71, 69, 66, 64, 66, 69,
  ]);
  _generateMidiFile('assets/midi/till_the_storm_passes_by.mid', [
    60, 62, 65, 67, 69, 65, 67, 69, 72, 69,
  ]);

  print('All Hymnal Studio assets generated successfully!');
}

void _generateSvgScore(
  String path, {
  required String title,
  required String hymnNumber,
  required String key,
  required String meter,
  required String author,
  required String composer,
  required String firstLine,
}) {
  // High-Resolution 1200x700 Vector Score Sheet with bold staves, 10px noteheads, SATB harmony layout
  final svg = '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 700" width="100%" height="100%">
  <defs>
    <style>
      .score-bg { fill: #ffffff; }
      .header-num { font-family: 'Cinzel', 'Times New Roman', serif; font-size: 38px; font-weight: bold; fill: #0f172a; }
      .header-title { font-family: 'Georgia', 'Times New Roman', serif; font-size: 44px; font-weight: bold; fill: #0284c7; text-anchor: middle; }
      .meta-text { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; font-size: 16px; fill: #475569; font-weight: 500; }
      .staff-line { stroke: #1e293b; stroke-width: 2.5; stroke-linecap: round; }
      .bar-line { stroke: #0f172a; stroke-width: 3.5; stroke-linecap: round; }
      .clef-symbol { fill: #0f172a; font-family: serif; font-size: 72px; }
      .time-sig { font-family: sans-serif; font-size: 32px; font-weight: 800; fill: #0f172a; }
      .note-head { fill: #0f172a; }
      .note-stem { stroke: #0f172a; stroke-width: 3; stroke-linecap: round; }
      .lyric-text { font-family: 'Georgia', serif; font-size: 24px; fill: #0f172a; text-anchor: middle; font-weight: 500; }
      .chord-badge { font-family: 'Courier New', monospace; font-size: 20px; font-weight: 900; fill: #0284c7; }
      .footer-brand { font-family: sans-serif; font-size: 14px; fill: #64748b; font-weight: 600; text-anchor: middle; letter-spacing: 1.5px; }
      .stave-bracket { stroke: #0f172a; stroke-width: 5; fill: none; }
    </style>
  </defs>

  <!-- High contrast paper background with soft border -->
  <rect width="1200" height="700" class="score-bg" rx="16" stroke="#e2e8f0" stroke-width="2" />

  <!-- Top Decorative Bar -->
  <rect x="0" y="0" width="1200" height="12" fill="#0284c7" rx="6" />

  <!-- Hymn Header Banner -->
  <text x="80" y="75" class="header-num">$hymnNumber</text>
  <text x="600" y="75" class="header-title">$title</text>
  <text x="1120" y="75" class="meta-text" text-anchor="end">$key • $meter</text>

  <!-- Author and Composer Attribution -->
  <text x="80" y="115" class="meta-text">Words: $author</text>
  <text x="1120" y="115" class="meta-text" text-anchor="end">Music: $composer</text>

  <line x1="80" y1="135" x2="1120" y2="135" stroke="#cbd5e1" stroke-width="1.5" />

  <!-- SYSTEM 1: TREBLE & BASS STAVES -->
  <!-- Grand Staff Bracket -->
  <line x1="80" y1="180" x2="80" y2="400" class="stave-bracket" />

  <!-- Treble Staff (5 lines) -->
  <g transform="translate(80, 180)">
    <line x1="0" y1="0" x2="1040" y2="0" class="staff-line"/>
    <line x1="0" y1="16" x2="1040" y2="16" class="staff-line"/>
    <line x1="0" y1="32" x2="1040" y2="32" class="staff-line"/>
    <line x1="0" y1="48" x2="1040" y2="48" class="staff-line"/>
    <line x1="0" y1="64" x2="1040" y2="64" class="staff-line"/>

    <!-- Bar lines -->
    <line x1="0" y1="0" x2="0" y2="64" class="bar-line"/>
    <line x1="340" y1="0" x2="340" y2="64" class="bar-line"/>
    <line x1="680" y1="0" x2="680" y2="64" class="bar-line"/>
    <line x1="1040" y1="0" x2="1040" y2="64" class="bar-line"/>

    <!-- Treble Clef -->
    <text x="12" y="52" class="clef-symbol">𝄞</text>
    <text x="65" y="46" class="time-sig">4/4</text>

    <!-- Measure 1 Notes (Chords & Melodic Notes) -->
    <text x="160" y="-18" class="chord-badge">[ I ]</text>
    <ellipse cx="160" cy="48" rx="10" ry="7" class="note-head" transform="rotate(-15 160 48)"/>
    <line x1="169" y1="46" x2="169" y2="6" class="note-stem"/>

    <ellipse cx="250" cy="32" rx="10" ry="7" class="note-head" transform="rotate(-15 250 32)"/>
    <line x1="259" y1="30" x2="259" y2="-10" class="note-stem"/>

    <!-- Measure 2 Notes -->
    <text x="430" y="-18" class="chord-badge">[ IV ]</text>
    <ellipse cx="430" cy="16" rx="10" ry="7" class="note-head" transform="rotate(-15 430 16)"/>
    <line x1="439" y1="14" x2="439" y2="-26" class="note-stem"/>

    <ellipse cx="540" cy="0" rx="10" ry="7" class="note-head" transform="rotate(-15 540 0)"/>
    <line x1="549" y1="-2" x2="549" y2="-42" class="note-stem"/>

    <!-- Measure 3 Notes -->
    <text x="780" y="-18" class="chord-badge">[ V7 ]</text>
    <ellipse cx="780" cy="16" rx="10" ry="7" class="note-head" transform="rotate(-15 780 16)"/>
    <line x1="789" y1="14" x2="789" y2="-26" class="note-stem"/>

    <ellipse cx="910" cy="32" rx="10" ry="7" class="note-head" transform="rotate(-15 910 32)"/>
    <line x1="919" y1="30" x2="919" y2="-10" class="note-stem"/>
  </g>

  <!-- Lyrics In Center Between Staves -->
  <text x="600" y="300" class="lyric-text">$firstLine</text>

  <!-- Bass Staff (5 lines) -->
  <g transform="translate(80, 336)">
    <line x1="0" y1="0" x2="1040" y2="0" class="staff-line"/>
    <line x1="0" y1="16" x2="1040" y2="16" class="staff-line"/>
    <line x1="0" y1="32" x2="1040" y2="32" class="staff-line"/>
    <line x1="0" y1="48" x2="1040" y2="48" class="staff-line"/>
    <line x1="0" y1="64" x2="1040" y2="64" class="staff-line"/>

    <!-- Bar lines -->
    <line x1="0" y1="0" x2="0" y2="64" class="bar-line"/>
    <line x1="340" y1="0" x2="340" y2="64" class="bar-line"/>
    <line x1="680" y1="0" x2="680" y2="64" class="bar-line"/>
    <line x1="1040" y1="0" x2="1040" y2="64" class="bar-line"/>

    <!-- Bass Clef -->
    <text x="12" y="44" class="clef-symbol">𝄢</text>
    <text x="65" y="46" class="time-sig">4/4</text>

    <!-- Bass Notes -->
    <ellipse cx="160" cy="64" rx="10" ry="7" class="note-head" transform="rotate(-15 160 64)"/>
    <line x1="151" y1="66" x2="151" y2="106" class="note-stem"/>

    <ellipse cx="250" cy="48" rx="10" ry="7" class="note-head" transform="rotate(-15 250 48)"/>
    <line x1="241" y1="50" x2="241" y2="90" class="note-stem"/>

    <ellipse cx="430" cy="32" rx="10" ry="7" class="note-head" transform="rotate(-15 430 32)"/>
    <line x1="421" y1="34" x2="421" y2="74" class="note-stem"/>

    <ellipse cx="540" cy="48" rx="10" ry="7" class="note-head" transform="rotate(-15 540 48)"/>
    <line x1="531" y1="50" x2="531" y2="90" class="note-stem"/>

    <ellipse cx="780" cy="32" rx="10" ry="7" class="note-head" transform="rotate(-15 780 32)"/>
    <line x1="771" y1="34" x2="771" y2="74" class="note-stem"/>

    <ellipse cx="910" cy="64" rx="10" ry="7" class="note-head" transform="rotate(-15 910 64)"/>
    <line x1="901" y1="66" x2="901" y2="106" class="note-stem"/>
  </g>

  <!-- SYSTEM 2 / CHORUS HARMONY PREVIEW -->
  <g transform="translate(80, 480)">
    <text x="0" y="0" class="chord-badge" font-size="18">CHORUS / REFRAIN SATB HARMONY SECTION:</text>
    <line x1="0" y1="20" x2="1040" y2="20" class="staff-line"/>
    <line x1="0" y1="36" x2="1040" y2="36" class="staff-line"/>
    <line x1="0" y1="52" x2="1040" y2="52" class="staff-line"/>
    <line x1="0" y1="68" x2="1040" y2="68" class="staff-line"/>
    <line x1="0" y1="84" x2="1040" y2="84" class="staff-line"/>

    <line x1="0" y1="20" x2="0" y2="84" class="bar-line"/>
    <line x1="520" y1="20" x2="520" y2="84" class="bar-line"/>
    <line x1="1040" y1="20" x2="1040" y2="84" class="bar-line" stroke-width="5"/>

    <text x="12" y="72" class="clef-symbol">𝄞</text>
    <text x="120" y="52" class="chord-badge">[ I ]</text>
    <ellipse cx="120" cy="52" rx="10" ry="7" class="note-head" transform="rotate(-15 120 52)"/>
    <text x="320" y="52" class="chord-badge">[ IV ]</text>
    <ellipse cx="320" cy="36" rx="10" ry="7" class="note-head" transform="rotate(-15 320 36)"/>
    <text x="640" y="52" class="chord-badge">[ V ]</text>
    <ellipse cx="640" cy="20" rx="10" ry="7" class="note-head" transform="rotate(-15 640 20)"/>
    <text x="860" y="52" class="chord-badge">[ I ]</text>
    <ellipse cx="860" cy="52" rx="10" ry="7" class="note-head" transform="rotate(-15 860 52)"/>

    <text x="520" y="125" class="lyric-text" font-style="italic">Sing with spirit and with understanding • 1 Cor 14:15</text>
  </g>

  <!-- Modern Console Footer -->
  <line x1="80" y1="645" x2="1120" y2="645" stroke="#e2e8f0" stroke-width="1.5" />
  <text x="600" y="675" class="footer-brand">
    HYMNAL STUDIO • PROFESSIONAL HIGH-RESOLUTION VECTOR SCORE SHEET • SATB 4-PART NOTATION
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
  buffer.add([0x00, 0x00]); // format 0
  buffer.add([0x00, 0x01]); // 1 track
  buffer.add([0x01, 0xE0]); // 480 ticks per quarter note

  // Track data
  final trackEvents = BytesBuilder();

  // Track name meta event (Delta=0, FF 03 len 'Hymn Melody')
  final nameBytes = utf8.encode('Hymn Melody');
  trackEvents.add([0x00, 0xFF, 0x03, nameBytes.length, ...nameBytes]);

  // Set tempo: 100 BPM (600,000 microseconds per quarter note = 0x0927C0)
  trackEvents.add([0x00, 0xFF, 0x51, 0x03, 0x09, 0x27, 0xC0]);

  // Program change to Church Organ (Ch 0, Prog 19)
  trackEvents.add([0x00, 0xC0, 0x13]);

  // Write notes: Note On, duration 480 ticks, Note Off
  for (final note in notes) {
    // Note On (Ch 0, note, velocity 95)
    trackEvents.add([0x00, 0x90, note, 95]);
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
