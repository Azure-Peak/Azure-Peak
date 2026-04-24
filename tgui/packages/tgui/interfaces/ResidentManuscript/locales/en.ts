import type { ResidentManuscriptTexts } from '../localization';

export const residentManuscriptEn: ResidentManuscriptTexts = {
  window_title: 'Resident Manuscript',
  title: 'Resident Manuscript',
  subtitle_prefix: "Under the Crown's Hand",
  labels: {
    owner: 'Name',
    age: 'Age',
    class: 'Vocation',
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
    class: 'Vocation or station',
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
