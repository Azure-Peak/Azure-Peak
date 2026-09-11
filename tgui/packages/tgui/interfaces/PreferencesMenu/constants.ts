export const TAB_CHARACTER = 0;
export const TAB_GAMESETTINGS = 1;
export const TAB_KEYBIND = 2;

export const MAX_CLASS_TUTORIAL_LENGTH = 400;

export const PRONOUN_TO_ICON: Record<string, string> = {
  'he/him': 'mars',
  'she/her': 'venus',
  'they/them': 'mars-and-venus',
  'it/its': 'genderless',
};

export const TITLEPREF_TO_ICON: Record<string, string> = {
  'Lord / Ser': 'mars',
  'Lady / Dame': 'venus',
  // used downstream! Does no harm to keep in the code to avoid merge conflicts.
  'Non-Binary': 'transgender',
};

export const CLOTHESPREF_TO_ICON: Record<string, string> = {
  Masculine: 'mars',
  Feminine: 'venus',
};

export const VOICETYPE_TO_ICON: Record<string, string> = {
  Masculine: 'mars',
  Feminine: 'venus',
  Androgynous: 'transgender',
};

// Markings bitflags
export const HEAD = 1 << 0;
export const CHEST = 1 << 1;
export const GROIN = 1 << 2;
export const LEG_LEFT = 1 << 3;
export const LEG_RIGHT = 1 << 4;
export const LEGS = LEG_LEFT | LEG_RIGHT;
export const FOOT_LEFT = 1 << 5;
export const FOOT_RIGHT = 1 << 6;
export const FEET = FOOT_LEFT | FOOT_RIGHT;
export const ARM_LEFT = 1 << 7;
export const ARM_RIGHT = 1 << 8;
export const ARMS = ARM_LEFT | ARM_RIGHT;
export const HAND_LEFT = 1 << 9;
export const HAND_RIGHT = 1 << 10;
export const HANDS = HAND_LEFT | HAND_RIGHT;
export const NECK = 1 << 11;
export const VITALS = 1 << 13;
export const MOUTH = 1 << 14;
export const EARS = 1 << 15;
export const NOSE = 1 << 16;
export const RIGHT_EYE = 1 << 17;
export const LEFT_EYE = 1 << 18;
export const HAIR = 1 << 19;
export const EYES = LEFT_EYE | RIGHT_EYE;
export const FACE = MOUTH | NOSE | EYES | EARS;
export const FULL_HEAD = HEAD | MOUTH | NOSE | EYES | EARS | HAIR;
export const BELOW_HEAD = CHEST | GROIN | VITALS | ARMS | HANDS | LEGS | FEET;
export const BELOW_CHEST = GROIN | VITALS | LEGS | FEET; //for water;
export const FULL_BODY = FULL_HEAD | NECK | BELOW_HEAD;
export const FULL_BODY_NO_CHEST =
  GROIN | VITALS | LEGS | FEET | ARMS | HANDS | FULL_HEAD | NECK;
