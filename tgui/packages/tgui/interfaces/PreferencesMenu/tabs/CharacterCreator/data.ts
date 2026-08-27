import type { Color, Path } from 'pm/data';
import type { BooleanLike } from 'tgui-core/react';

// --------------- AllPagesData ---------------
export type AllPagesData = {
  character_preview_view: string | null; // null indicates error
  preview_background: string | null; // null indicates error

  loaded_slot: number;
  real_name: string;
  headshot_link: string | null; // null indicates unset

  pq: TrustedHTML;
  hide_pq: BooleanLike;
  triumphs: number;

  agevet: BooleanLike;
};

// --------------- AppearanceData ---------------
export type AppearanceData = BodyData & FeaturesData & MarkingsData;

export type BodyData = {
  body_type: string | null; // null indicates agender species

  // Appearance stuff
  use_skintones: BooleanLike;
  skin_tone_wording: string;
  available_skin_tones: Record<string, string>;
  skin_tone: string; // VALUE of available_skin_tones
  body_size: number;

  update_mutant_colors: BooleanLike;
  use_mutcolor: BooleanLike;
  mcolor: Color;
  mcolor2: Color;
  mcolor3: Color;

  // Taur stuff
  taur_type: Path | null; // null indicates no taur
  taur_name: string;
  taur_color: Color;
  allowed_taur_types: Path[];
};

// Customizers from code/modules/client/customizers
export type FeaturesData = {
  customizers: Customizer[];
};

export type Customizer = {
  name: string;
  type: Path;
  disabled: BooleanLike;
  allows_disabling: BooleanLike;
  customizer_choices_enabled: BooleanLike;
  choices: CustomizerChoice;
};

export interface CustomizerChoice {
  template: string;
  name: string;
  accessory: Accessory | null; // null indicates no accessory
}

export type Accessory = {
  name: string;
  colors: AccessoryColor[] | null; // null indicates accessory colors are not allowed
};

export type AccessoryColor = {
  name: string;
  index: number;
  color: Color;
};

// MARKINGS
export type MarkingsData = {
  marking_zones: MarkingZone[];
};

export type MarkingZone = {
  zone: string;
  name: string;
  may_add: BooleanLike;
  markings: Marking[] | null; // null signifies no markings data at all; order matters
};

export type Marking = {
  key: string;
  color: Color;
  can_move_up: BooleanLike;
  can_move_down: BooleanLike;
};

// --------------- ClassData ---------------
export type ClassData = {
  joblessrole: string;
  classes: Class[];
};

export type Class = {
  title: string;
  unavailable: ClassAvailability;
  unavailable_details: string;
  spawn_positions: number;
  pref: ClassPreference | null; // null means "NEVER"
};

export enum ClassAvailability {
  AVAILABLE = 0,
  UNAVAILABLE_GENERIC = 1,
  UNAVAILABLE_BANNED = 2,
  UNAVAILABLE_PLAYTIME = 3,
  UNAVAILABLE_ACCOUNTAGE = 4,
  UNAVAILABLE_PATRON = 5,
  UNAVAILABLE_RACE = 6,
  UNAVAILABLE_SEX = 7,
  UNAVAILABLE_AGE = 8,
  UNAVAILABLE_WTEAM = 9,
  UNAVAILABLE_LASTCLASS = 10,
  UNAVAILABLE_JOB_COOLDOWN = 11,
  UNAVAILABLE_SLOTFULL = 12,
  UNAVAILABLE_VIRTUESVICE = 13,
  UNAVAILABLE_PQ = 14,
}

export const CLASSAVAIL_NAME = {
  [ClassAvailability.AVAILABLE]: '',
  [ClassAvailability.UNAVAILABLE_GENERIC]: 'Unavailable',
  [ClassAvailability.UNAVAILABLE_BANNED]: 'BANNED',
  [ClassAvailability.UNAVAILABLE_PLAYTIME]: 'Playtime Too Low',
  [ClassAvailability.UNAVAILABLE_ACCOUNTAGE]: 'Account Too Young',
  [ClassAvailability.UNAVAILABLE_PATRON]: 'Patron Locked',
  [ClassAvailability.UNAVAILABLE_RACE]: 'Race Locked',
  [ClassAvailability.UNAVAILABLE_SEX]: 'Sex Locked',
  [ClassAvailability.UNAVAILABLE_AGE]: 'Age Locked',
  [ClassAvailability.UNAVAILABLE_WTEAM]: 'WTEAM',
  [ClassAvailability.UNAVAILABLE_LASTCLASS]: 'Played Recently',
  [ClassAvailability.UNAVAILABLE_JOB_COOLDOWN]: 'Respawn Delay',
  [ClassAvailability.UNAVAILABLE_SLOTFULL]: 'Slot Full',
  [ClassAvailability.UNAVAILABLE_VIRTUESVICE]: 'Virtue/Vice Locked',
  [ClassAvailability.UNAVAILABLE_PQ]: 'PQ',
};

export const CLASSAVAIL_COLOR = {
  [ClassAvailability.AVAILABLE]: '',
  [ClassAvailability.UNAVAILABLE_GENERIC]: '#a59461',
  [ClassAvailability.UNAVAILABLE_BANNED]: '#a70202',
  [ClassAvailability.UNAVAILABLE_PLAYTIME]: '#a59461',
  [ClassAvailability.UNAVAILABLE_ACCOUNTAGE]: '#a59461',
  [ClassAvailability.UNAVAILABLE_PATRON]: '#a59461',
  [ClassAvailability.UNAVAILABLE_RACE]: '#a59461',
  [ClassAvailability.UNAVAILABLE_SEX]: '#a59461',
  [ClassAvailability.UNAVAILABLE_AGE]: '#a59461',
  [ClassAvailability.UNAVAILABLE_WTEAM]: '#a59461',
  [ClassAvailability.UNAVAILABLE_LASTCLASS]: '#a59461',
  [ClassAvailability.UNAVAILABLE_JOB_COOLDOWN]: '#a59461',
  [ClassAvailability.UNAVAILABLE_SLOTFULL]: '#6d6d6c',
  [ClassAvailability.UNAVAILABLE_VIRTUESVICE]: '#a59461',
  [ClassAvailability.UNAVAILABLE_PQ]: '#a59461',
};

export enum ClassPreference {
  JP_LOW = 1,
  JP_MEDIUM = 2,
  JP_HIGH = 3,
}

// --------------- DescriptorData ---------------
export type DescriptorData = {
  descriptors: Descriptor[];
  descriptors_custom: CustomDescriptor[];
} & ExamineData;

export type Descriptor = {
  name: string;
  type: Path;
  selected: Path;
};

export type CustomDescriptor = {
  index: number;
  name: string;
  content: string | null; // null means unset
  prefix_display: string | null; // null indicates it is not prefixed
};

export type ExamineData = {
  examine_theme: string | null; // null indicates unset
  ooc_extra: string | null; // null indicates unset
  song_artist: string | null; // null indicates unset
  song_title: string | null; // null indicates unset

  img_gallery: string[];
  nsfw_img_gallery: string[];

  flavortext: string | null; // null indicates unset
  nsfwflavortext: string | null; // null indicates unset
  ooc_notes: string | null; // null indicates unset
  erpprefs: string | null; // null indicates unset
  rumour: string | null; // null indicates unset
  noble_gossip: string | null; // null indicates unset

  flavortext_cached: TrustedHTML | null; // null indicates unset
  nsfwflavortext_cached: TrustedHTML | null; // null indicates unset
  ooc_notes_cached: TrustedHTML | null; // null indicates unset
  erpprefs_cached: TrustedHTML | null; // null indicates unset
  rumour_cached: TrustedHTML | null; // null indicates unset
  noble_gossip_cached: TrustedHTML | null; // null indicates unset
};

// --------------- IdentityData ---------------
export type IdentityData = {
  species_base_name: string;
  species_sub_name: string;
  species_check: BooleanLike;
  race_bonus: string | null; // null indicates no race bonus

  nickname: string;
  highlight_color: Color;
  age: string;

  pronouns: string;
  titles_pref: string;
  clothes_pref: string;

  statpack_name: string;
  domhand: number;
  combat_music: string;
  dnr_pref: BooleanLike;

  favorite_cuisine: number; // bitflag
  favorite_dish: number; // bitflag
  favorite_drink: number; // bitflag

  loadout_cost: number;
  loadout_tri_cost: number;

  virtue_origin: string;
  free_language: string;

  selected_faith: string;
  selected_patron: string;

  voice_type: string;
  voice_color: Color;
  voice_pack: string;
  voice_pitch: number;

  bark_id: string;
  bark_name: string;
  bark_speed: number;
  min_bark_speed: number;
  max_bark_speed: number;
  bark_pitch: number;
  min_bark_pitch: number;
  max_bark_pitch: number;
  bark_variance: number;
  min_bark_variance: number;
  max_bark_variance: number;

  virtues: VirtueWithMetadata[];

  charflaws: CharFlaw[]; // look at constant.MAX_VICES
  has_averse: BooleanLike;
  averse_chosen_faction: string;
};

export type VirtueWithMetadata = {
  id: number;
  slot_name: string;
  virtue: Virtue;
  spawn_error: string | null; // null indicates all is okay
};

export type Virtue = {
  name: string;
  picked_choices: VirtueChoice[]; // note: may be length less than max_choices, show add button in that case
  max_choices: number;
  next_cost: number;
  tricost: number;
};

export type VirtueChoice = {
  index: number;
  choice: string;
  tooltip: string | null; // null indicates no details
};

export type CharFlaw = {
  name: string;
  type: Path;
  warning: BooleanLike;
};

// --------------- VillainData ---------------
export type VillainData = {
  antag_banned: BooleanLike;

  lich_headshot_link: string | null; // null means unset
  vampire_headshot_link: string | null; // null means unset

  vampire_skin: string | null; // null means unset
  vampire_eyes: string | null; // null means unset
  vampire_hair: string | null; // null means unset
  vampire_ears: string | null; // null means unset

  qsr_pref: BooleanLike;

  preset_bounty_enabled: BooleanLike; // controls showing next three
  preset_bounty_crime: string | null; // null means unset

  bounty_posters: string | null; // null means unset
  wretch_severities: string | null; // null means unset
  bandit_severities: string | null; // null means unset
  vagabond_severities: string | null; // null means unset
};
