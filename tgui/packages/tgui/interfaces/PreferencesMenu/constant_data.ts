import { atom, type ExtractAtomValue, useAtom } from 'jotai';
import type { BooleanLike } from 'tgui-core/react';
import type { Path } from './data';

export type ConstantData = {
  MAX_VICES: number;
  MINIMUM_FLAVOR_TEXT: number;
  MINIMUM_OOC_NOTES: number;
  MAX_KEYS_PER_KEYBIND: number;
  MAX_NOTE_SIZE: number;
  MAXIMUM_MARKINGS_PER_LIMB: number;
  MIN_VOICE_PITCH: number;
  MAX_VOICE_PITCH: number;
  // lists
  barksounds: string[];
  charflaws: Record<Path, ConstantCharflaw>;
  classes: Record<string, ConstantClass>;
  combat_music: Record<string, ConstantCombatMusic>;
  culinary: ConstantCulinary;
  customizer_choices: Record<Path, ConstantCustomizerChoice>;
  customizers: Record<Path, ConstantCustomizer>;
  descriptor_choices: Record<Path, ConstantDescriptorChoice>;
  descriptors: Record<Path, ConstantDescriptor>;
  faiths: Record<Path, ConstantFaith>;
  markings_by_zone: Record<string, ConstantMarking[]>;
  patrons: Record<Path, ConstantPatron>;
  preview_backgrounds: string[];
  species: ConstantSpecies[];
  sprite_accessories: Record<Path, ConstantSpriteAccessory>;
  statpacks: Record<Path, ConstantStatpack>;
  taur_types: Record<Path, ConstantTaurType>;
  tgui_themes: Record<string, string>;
  virtues: Record<Path, ConstantVirtue>;
  voicepacks: string[];
  // other data
  lore_primer: TrustedHTML;
};

/** {@link ConstantData.charflaws} */
export type ConstantCharflaw = {
  name: string;
  desc: TrustedHTML;
  icon: string | null;
  needs_extra_vice: BooleanLike;
  restricted_species: string[];
};

/** {@link ConstantData.classes} */
export function getClassDisplayTitle(
  c: ConstantData,
  title: string,
  titles_pref: string,
): string {
  return c.classes[title].titles[titles_pref] || title;
}

export function getClassDepartment(
  c: ConstantData,
  title: string,
): DepartmentEnum {
  return (
    DEPARTMENT_FLAG_TO_ENUM[c.classes[title].department_flag] ||
    DepartmentEnum.NONE
  );
}

export function getClassDisplayOrder(c: ConstantData, title: string): number {
  return c.classes[title].display_order || 0;
}

export type ConstantClass = {
  titles: Record<string, string>;
  department_flag: DepartmentFlag;
  display_order: number;
  class_setup_examine: BooleanLike;
  tutorial: string;
  round_contrib_points: number;
  has_subprefs: BooleanLike;
};

export enum DepartmentFlag {
  NOBLEMEN = 1 << 0,
  COURTIERS = 1 << 1,
  RETINUE = 1 << 2,
  GARRISON = 1 << 3,
  CHURCHMEN = 1 << 4,
  BURGHERS = 1 << 5,
  PEASANTS = 1 << 6,
  SIDEFOLK = 1 << 7,
  WANDERERS = 1 << 8,
  INQUISITION = 1 << 9,
  ANTAGONIST = 1 << 10,
}

export enum DepartmentEnum {
  NOBLEMEN = 'NOBLEMEN',
  COURTIERS = 'COURTIERS',
  SIDEFOLK = 'SIDEFOLK',
  RETINUE = 'RETINUE',
  GARRISON = 'GARRISON',
  BURGHERS = 'BURGHERS',
  CHURCHMEN = 'CHURCHMEN',
  INQUISITION = 'INQUISITION',
  ANTAGONIST = 'ANTAGONIST',
  PEASANTS = 'PEASANTS',
  WANDERERS = 'WANDERERS',
  NONE = 'NONE',
}

export const DEPARTMENT_FLAG_TO_ENUM = {
  [DepartmentFlag.NOBLEMEN]: DepartmentEnum.NOBLEMEN,
  [DepartmentFlag.COURTIERS]: DepartmentEnum.COURTIERS,
  [DepartmentFlag.RETINUE]: DepartmentEnum.RETINUE,
  [DepartmentFlag.GARRISON]: DepartmentEnum.GARRISON,
  [DepartmentFlag.CHURCHMEN]: DepartmentEnum.CHURCHMEN,
  [DepartmentFlag.BURGHERS]: DepartmentEnum.BURGHERS,
  [DepartmentFlag.PEASANTS]: DepartmentEnum.PEASANTS,
  [DepartmentFlag.SIDEFOLK]: DepartmentEnum.SIDEFOLK,
  [DepartmentFlag.WANDERERS]: DepartmentEnum.WANDERERS,
  [DepartmentFlag.INQUISITION]: DepartmentEnum.INQUISITION,
  [DepartmentFlag.ANTAGONIST]: DepartmentEnum.ANTAGONIST,
};

/** {@link ConstantData.combat_music} */
export type ConstantCombatMusic = {
  type: string;
  name: string;
  desc: string;
  shortname: string;
  credits: string;
};

/** {@link ConstantData.culinary} */
export type ConstantCulinary = {
  cuisines: Record<string, number>; // map from Label -> Bitflag
  dishes: Record<string, number>; // map from Label -> Bitflag
  drinks: Record<string, number>; // map from Label -> Bitflag
};

export enum CulinaryAxisNames {
  Cuisine = 'cuisine',
  Dish = 'dish',
  Drink = 'drink',
}

export const getCulinaryDataForAxis = (
  constantData: ConstantData,
  axis: CulinaryAxisNames,
) => {
  switch (axis) {
    case CulinaryAxisNames.Cuisine:
      return constantData.culinary.cuisines;
    case CulinaryAxisNames.Dish:
      return constantData.culinary.dishes;
    case CulinaryAxisNames.Drink:
      return constantData.culinary.drinks;
  }
};

export const getCulinaryNameFromBitflag = (
  constantData: ConstantData,
  axis: CulinaryAxisNames,
  number: number,
) => {
  switch (axis) {
    case CulinaryAxisNames.Cuisine:
      return Object.entries(constantData.culinary.cuisines).find(
        ([k, v]) => v === number,
      )?.[0];
    case CulinaryAxisNames.Dish:
      return Object.entries(constantData.culinary.dishes).find(
        ([k, v]) => v === number,
      )?.[0];
    case CulinaryAxisNames.Drink:
      return Object.entries(constantData.culinary.drinks).find(
        ([k, v]) => v === number,
      )?.[0];
  }
};

export const getCulinaryBitflagFromName = (
  constantData: ConstantData,
  axis: CulinaryAxisNames,
  label: string,
) => {
  switch (axis) {
    case CulinaryAxisNames.Cuisine:
      return Object.entries(constantData.culinary.cuisines).find(
        ([k, v]) => k === label,
      )?.[1];
    case CulinaryAxisNames.Dish:
      return Object.entries(constantData.culinary.dishes).find(
        ([k, v]) => k === label,
      )?.[1];
    case CulinaryAxisNames.Drink:
      return Object.entries(constantData.culinary.drinks).find(
        ([k, v]) => k === label,
      )?.[1];
  }
};

/** {@link ConstantData.customizer_choices} */
export type ConstantCustomizerChoice = {
  name: string;
  sprite_accessories: string[]; // key into sprite_accessories
};

/** {@link ConstantData.customizers} */
export type ConstantCustomizer = {
  name: string;
  choices: string[]; // key into customizer_choices
};

/** {@link ConstantData.descriptor_choices} */
export type ConstantDescriptorChoice = {
  name: string;
  descriptors: Path[];
};

/** {@link ConstantData.descriptors} */
export type ConstantDescriptor = {
  name: string;
};

/** {@link ConstantData.faiths} */
export type ConstantFaith = {
  name: string;
  desc: TrustedHTML;
  worshippers: string;
  godhead: Path;
};

/** {@link ConstantData.markings_by_zone} */
export type ConstantMarking = {
  name: string;
  type: Path;
  icon: string;
  icon_state: string;
};

/** {@link ConstantData.patrons} */
export type ConstantPatron = {
  name: string;
  domain: string;
  desc: TrustedHTML;
  worshippers: string;
  associated_faith: Path;
};

/** {@link ConstantData.species} */
export type ConstantSpecies = {
  name: string;
  base_name: string;
  sub_name: string;
  id: string;
  type: Path;
  is_subrace: BooleanLike;
  desc: string;
  desc_title: string;
  bonus_stats: TrustedHTML | null;
  bonus_traits: TrustedHTML | null;
  mechanics: TrustedHTML | null;
  languages: TrustedHTML | null;
};

/** {@link ConstantData.sprite_accessories} */
export type ConstantSpriteAccessory = {
  name: string;
  icon: string;
  pixel_x: number;
  preview_states: string[];
};

/** {@link ConstantData.statpacks} */
export type ConstantStatpack = {
  name: string;
  desc: TrustedHTML;
  icon: string;
};

/** {@link ConstantData.taur_types} */
export type ConstantTaurType = {
  name: string;
  icon: string;
  taur_icon_state: string;
  offset_x: number;
};

/** {@link ConstantData.virtues} */
export type ConstantVirtue = {
  name: string;
  desc: TrustedHTML;
  icon: string | null;
  softcap: BooleanLike;
  is_origin: BooleanLike;
  origin_desc: TrustedHTML;
  custom_text: string;
  stackable: BooleanLike;
  added_skills: Skill[];
  added_traits: Trait[];
  added_stashed_items: string[];
  added_languages: string[];
};

export type Skill = {
  name: string;
  level: number;
  max_level: string;
};

export type Trait = {
  name: string;
  desc: TrustedHTML;
};

// Internal UI state
type StateWithSetter<T> = [T, (nextState: T) => void];

export const constantDataAtom = atom<ConstantData | undefined>(undefined);

/**
 * ## WARNING: MAY RETURN UNDEFINED
 * ## THIS MUST BE HANDLED GRACEFULLY
 */
export function useConstantPrefs(): StateWithSetter<
  ExtractAtomValue<typeof constantDataAtom>
> {
  return useAtom(constantDataAtom);
}
