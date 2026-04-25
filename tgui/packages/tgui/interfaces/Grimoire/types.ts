export type Spell = {
  path: string;
  name: string;
  desc: string;
  fluff_desc: string;
  cost: number;
};

export type VariantSwap = {
  from: string;
  to: Spell;
};

export type Variant = {
  name: string;
  swaps: VariantSwap[];
};

export type Aspect = {
  path: string;
  name: string;
  latin_name: string;
  desc: string;
  aspect_type: string;
  attuned_name: string;
  school_color: string;
  pointbuy_budget: number;
  fixed_spells: Spell[];
  choice_spells: Spell[];
  pointbuy_spells: Spell[];
  variants: Variant[];
};

export type Data = {
  read_only: boolean;
  major_aspects: Aspect[];
  minor_aspects: Aspect[];
  utility_spells: Spell[];
  user_tier: number;
  max_majors: number;
  max_minors: number;
  max_utilities: number;
  initial_setup: boolean;
  attuned_majors: string[];
  attuned_minors: string[];
  selected_utilities: string[];
  locked_aspects: string[];
  staged_choices: Record<string, string>;
  pointbuy_selections: Record<string, string[]>;
  all_selected_spells: string[];
  spent_budgets: Record<string, number>;
  utility_points_spent: number;
  reset_budget: number;
  reset_budget_max: number;
  resets_used: number;
  staged_unbind_aspects: string[];
  staged_unbind_utilities: string[];
  known_utilities: string[];
  given_utilities: string[];
  variant_overrides: Record<string, string>;
};

export type Tab = 'major' | 'minor' | 'utilities';
