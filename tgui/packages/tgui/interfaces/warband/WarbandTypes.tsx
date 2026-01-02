export type ClassType = {
  name: string;
  alt_name: string;
  desc: string;
  type: string;
  storyinfluence: string;
  slots: number;
  rarity: number;
  can_multiclass: boolean;
}

export type NobleType = {
  name: string;
  job: string;
  special_role?: string;
  in_lobby?: boolean;
}

export type StorytellerType = {
  title: string;
  summary: string;
  type: string;
};

export type AspectType = {
  title: string;
  summary: string;
  storyinfluence: string;
  class: string;
  points: number;
  rarity: number;
  type: string;
  warlordclasses: string[];
  lieuclasses: string[];
  gruntclasses: string[];
};

export type SubType = {
  title: string;
  summary: string;
  quote: string;
  quote_followup: string;
  storyinfluence: string;
  points: number;
  rarity: number;
  aspects: string[];
  type: string;
  warlordclasses: string[];
  lieuclasses: string[];
  gruntclasses: string[];
};

export type WarbandType = {
  title: string;
  summary: string;
  storyinfluence: string;
  subtyperequired: boolean;
  points: number;
  rarity: number;
  subtypes: string[][];
  aspects: string[];
  type: string;
  warlordclasses: string[];
  lieuclasses: string[];
  gruntclasses: string[];
};

export type Data = {
  user_role?: string;
  finalized_status?: boolean;
  warbands?: WarbandType[];
  subtypes?: SubType[];
  aspects?: AspectType[];
  backendstorytellers?: StorytellerType[];
  backend_warband?: WarbandType[];
  backend_subtype?: SubType[];
  backend_aspects?: AspectType[];
  nobles?: NobleType[];
  allies?: NobleType[];
  classes?: ClassType[];
  creation_stage?: number;
  warlord_spawned?: boolean;
  is_warlord?: boolean;
  time_remaining?: number;
  timer_active?: boolean;
};
