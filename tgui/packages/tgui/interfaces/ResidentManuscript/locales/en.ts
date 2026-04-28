import type { ResidentManuscriptTexts } from '../localization';

export const residentManuscriptEn: ResidentManuscriptTexts = {
  window_title: 'Resident Manuscript',
  title: 'Resident Manuscript',
  subtitle_prefix: 'Official writ of lawful standing',
  profiles: {
    resident: {
      display_name: 'Resident Manuscript',
      subtitle: "Under the Crown's Hand",
      description:
        "Let it be known: by the Crown's will and the Council's oversight, the bearer of this document is recognized as a lawful resident of these lands and stands beneath the shelter of common law. Every rank and office is charged to acknowledge the bearer as a faithful subject and to place no unjust obstacle in their path.",
    },
    guards: {
      display_name: 'Azurian Warden Mandate',
      subtitle: 'By the Watch and the Crown',
      description:
        'Let it be known: the bearer is a sworn warden of Azuria, charged with the keeping of city order, the law of the Crown, and the silver discipline of the watch. Wardens act in the name of public peace and lawful arrest, under command of the Marshal and the Council.',
    },
    church: {
      display_name: 'Ecclesiastical Writ of Faith',
      subtitle: 'Beneath the Tenfold Light',
      description:
        'Let it be known: the bearer is a recognized child of the Tenfold Church, walking under the protection of the sacred light, and is to be received as a faithful soul in matters of doctrine and rite. Every congregation and shrine is charged to grant the bearer the courtesy due to a confirmed believer.',
    },
    craftsmen: {
      display_name: 'Artisan Guild Charter',
      subtitle: 'By Honest Hand and Bronze',
      description:
        'Let it be known: the bearer is a recognized artisan of the Guild — that band of craftsmen sworn to Malum the Forgefather — holding the right to honest work, fair price, and the standing of the masterly estate. The bearer is bound by guild oath and protected by guild law in matters of contract and trade.',
    },
    merchant: {
      display_name: 'Merchant Shop Charter',
      subtitle: 'By the Coin and the Tusk',
      description:
        "Let it be known: the bearer is a sworn member of the Merchant Shop, the city's licensed house of trade, recognized in matters of fair sale, lawful contract, and the appraisal of treasures and lesser goods. The bearer is owed the courtesies due any honest burgher.",
    },
    mages: {
      display_name: "Mage's Guild Patent",
      subtitle: "Under the Duchy's Light, by Star and Sigil",
      description:
        "Let it be known: by the Duchy's licence and the seal of the Mage's Guild, the bearer is a recognized practitioner of potionmaking, summoning, and the bound arts of the Guild. None may obstruct the bearer in the lawful pursuit of the Guild's craft.",
    },
    inn: {
      display_name: "Innkeep's Writ",
      subtitle: 'By the Hearth and the Tankard',
      description:
        "Let it be known: the bearer is recognized as the Innkeep of the city's central inn, charged with the keeping of the hearth, the lawful sale of board and drink, and the safety of those who lodge beneath this roof.",
    },
    bathhouse: {
      display_name: 'Bathhouse Patent',
      subtitle: 'Beneath Steam and Lily',
      description:
        'Let it be known: the bearer is a recognized proprietor of the Bathhouse, granted leave by the Matron to keep the steam, scent, and lawful trade of the basement beneath the Inn, and to gather such custom as the Matron permits.',
    },
    commoner: {
      display_name: 'Commoner Manuscript',
      subtitle: 'Under the Common Law',
      description:
        'Let it be known: the bearer is recognized as a lawful commoner of these lands, neither titled nor accused, owing no duties beyond those due from any subject. No high authority is invoked here -- only the modest shelter of the common law.',
    },
    mercenary: {
      display_name: 'Mercenary Compact',
      subtitle: 'By the Coin, the Steel, and the Word',
      description:
        'Let it be known: the bearer is a free blade of recognized standing, bound by the compact of coin and steel, and sworn to the company that brought them to these lands. The bearer answers to contract and to captain, and may not be molested in the lawful pursuit of either.',
    },
    otava: {
      display_name: 'Inquisitorial Edict',
      subtitle: 'By Truth, Inquest, and the Cleansing Flame',
      description:
        "Let it be known: by the edict of Otava, the bearer is empowered to act in the name of truth, to question and to seek, and to call forth the cleansing flame against heresy. Every faithful soul is charged to render the bearer such aid as the matter demands, and to obstruct them is to obstruct the Church's justice.",
    },
  },
  labels: {
    owner: 'Name',
    age: 'Age',
    status: 'Estate',
    expires: 'Valid until',
    issued: 'Issued at',
    seals: 'Seals',
    verification: 'Authenticity',
    defects: 'Observed defects',
  },
  buttons: {
    save: 'Save',
    inspect: 'Inspect',
    stamp: 'Stamp',
    claim: 'Claim residency',
    bind: 'Bind',
  },
  tooltips: {
    save: 'Save the completed forgery.',
    inspect: 'Quietly inspect the manuscript for forgery.',
    stamp: 'Apply the official seal available to you.',
    claim: 'Use the manuscript as proof of residency.',
    bind: 'Bind the manuscript to your name.',
  },
  placeholders: {
    owner: 'Owner name',
    age: 'Age',
  },
  owner_status_options: {
    commoner: 'Unproven',
    noble: "Under Astrata's grace",
  },
  states: {
    owner: 'This manuscript is recognized as yours.',
    other: 'This manuscript belongs to another.',
    unbound: 'This manuscript is not yet bound to an owner.',
    blank_hint: 'The blank must be filled with a feather.',
    fake_edit_hint: 'The suspicious blank waits for an inscribed name.',
    seal_missing: 'not sealed',
    empty: '-',
    unknown: 'Unknown',
    unclear_hand: 'Unclear hand',
  },
  verification: {
    fake: 'The manuscript appears to be forged.',
    real: 'The manuscript appears authentic.',
    unknown: 'The manuscript shows no obvious cause for suspicion.',
    none: 'Authenticity has not been inspected.',
  },
  aria: {
    seal: 'Seal',
  },
  seals: {
    chancellor: { title: 'Chancellor', stamper: 'Chancellor' },
    elder: { title: 'Elder', stamper: 'Elder' },
    ruler: { title: 'Duke', stamper: 'Duke' },
    hand: { title: 'Hand', stamper: 'Hand' },
    sergeant: { title: 'Sergeant', stamper: 'Sergeant of the Watch' },
    marshal: { title: 'Marshal', stamper: 'Marshal' },
    bishop: { title: 'Bishop', stamper: 'Bishop' },
    guild_leader: { title: 'Guild Leader', stamper: 'Guild Leader' },
    inquisitor: { title: 'Inquisitor', stamper: 'Inquisitor' },
    court_magician: { title: 'Court Magician', stamper: 'Court Magician' },
    merchant_master: {
      title: 'Merchant Master',
      stamper: 'Merchant Master',
    },
    innkeeper: { title: 'Innkeep', stamper: 'Innkeep' },
    bathmaster: { title: 'Bathmaster', stamper: 'Bathmaster' },
  },
  description:
    "Let it be known: by the Crown's will and the Council's oversight, the bearer of this document is recognized as a lawful resident of these lands and stands beneath the shelter of common law. Every rank and office is charged to acknowledge the bearer as a faithful subject and to place no unjust obstacle in their path.",
  defects: {
    ink_blot: 'A faint ink blot marks one corner of the parchment.',
    seal_smudge: 'The ink around one seal is slightly smeared.',
    owner_wobble:
      "One letter in the owner's name was written with an unsteady hand.",
    ragged_edge: 'The parchment edge has been cut unevenly.',
    uncertain_hand: 'The signature lacks a confident hand.',
    stale_smell: 'The parchment carries a stale smell.',
    misaligned_initial:
      'The lapis initial falls out of line and dried over the main text.',
    fresh_pricking:
      'Fresh ruling pricks on the lower margin do not match the written lines.',
    cut_gilding: 'The gilded edge lies over a fresh cut in places.',
    rethreaded_cord:
      'The silk-gold cord was threaded again; broken fibers show around the holes.',
    reheated_wax:
      'One wax seal is warmer in color and shines as though recently remelted.',
    blue_halo:
      'The ink casts a blue halo mid-line, as if mixed with different water.',
    corrected_date:
      'One stroke in the date was crossed out too cleanly for a chancery hand.',
    heretical_marginalia:
      "A foreign marginal note shows between the lines: 'Zizo keeps the whisper, Graggar waits for blood, Matthios weighs the debt.'",
  },
  visual_hints: {
    heretical_marginalia_lines: [
      'Zizo keeps the whisper',
      'Graggar waits for blood',
      'Matthios weighs the debt',
    ],
    misaligned_initial: 'R',
  },
  validation_notes: {
    steady_seals:
      'The seals sit evenly, the ink is sure, and the cord bears no sign of being threaded again.',
    proper_ruling:
      'The ruling, pricks, and lines agree with one another; this is a proper manuscript.',
    matched_hand:
      'The hand, seals, and gilded edge agree. There is no obvious reason to doubt the document.',
    deep_wax:
      'The wax took its impression deeply and cleanly, and the lines show no foreign hand.',
    proper_rite:
      'The document appears to have been prepared according to chancery rite.',
  },
};
