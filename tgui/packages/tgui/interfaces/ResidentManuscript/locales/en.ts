import type { ResidentManuscriptTexts } from '../localization';

export const residentManuscriptEn: ResidentManuscriptTexts = {
  window_title: 'Resident Manuscript',
  title: 'Resident Manuscript',
  subtitle_prefix: 'Inkbound writ beneath a dying law',
  profiles: {
    resident: {
      display_name: 'Resident Manuscript',
      subtitle: "Under the Crown's Hand",
      description:
        "Let it be known: under cold crown-wax and black ink, the bearer is counted among the named souls of these lands. Gate, hearth, and gallows alike must know them until law or death strikes them from the roll.",
    },
    guards: {
      display_name: 'Azurian Warden Mandate',
      subtitle: 'By the Watch and the Crown',
      description:
        'Let it be known: the bearer walks as a warden of Azuria, sworn to keep the lanterns burning and the streets obedient. Their word carries iron, and their hand may drag peace from blood, mud, and fear.',
    },
    church: {
      display_name: 'Ecclesiastical Writ of Faith',
      subtitle: 'Beneath the Tenfold Light',
      description:
        'Let it be known: the bearer is marked beneath the Tenfold Light, where mercy burns as keenly as judgment. Let shrine and altar receive them, unless shadow or heresy claims their name first.',
    },
    craftsmen: {
      display_name: 'Artisan Guild Charter',
      subtitle: 'By Honest Hand and Bronze',
      description:
        'Let it be known: the bearer is bound to furnace, awl, chisel, and oath. Their work may pass under guild protection, and their debt to craft shall be weighed in coin, sweat, and blood.',
    },
    merchant: {
      display_name: 'Merchant Shop Charter',
      subtitle: 'By the Coin and the Tusk',
      description:
        'Let it be known: the bearer serves the counting house, where coin is weighed like sin and every bargain has a shadow. Their trade is lawful, their ledgers answerable, and their debts remembered.',
    },
    mages: {
      display_name: "Mage's Guild Patent",
      subtitle: "Under the Duchy's Light, by Star and Sigil",
      description:
        'Let it be known: by ducal leave and guild sigil, the bearer may traffic in star, draught, and summoned whisper. Let none hinder their art, unless the art hungers beyond its chain.',
    },
    commoner: {
      display_name: 'Townsfolk Manuscript',
      subtitle: "By the Towner Elder's mark",
      description:
        'Let it be known: the bearer is a plain soul of the town, scratched into cheap ink and rag paper. They are suffered among lawful folk without flourish, privilege, or noble mercy.',
    },
    mercenary: {
      display_name: 'Mercenary Contract',
      subtitle: 'By the Coin, the Steel, and the Word',
      description:
        "Let it be known: the bearer is a blade sold under witness, bound by coin, steel, and the captain's word. They may spill blood by contract, and answer for it when the ink dries.",
    },
    otava: {
      display_name: 'Inquisitorial Edict',
      subtitle: 'By Truth, Inquest, and the Cleansing Flame',
      description:
        "Let it be known: by Otava's silver edict, the bearer may prise truth from locked mouths and call flame upon the rot of heresy. To bar their path is to stand where ash is due.",
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
  },
  owner_age_options: {
    Adult: 'Adult',
    'Middle-Aged': 'Middle-Aged',
    Old: 'Old',
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
  },
  description:
    'Let it be known: this writ binds a name to law, wax, and witness beneath a darkening crown.',
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
