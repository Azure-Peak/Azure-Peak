export type WarbandType = {
  title: string;
  summary: string;
  storyinfluence?: string;
  subtyperequired: boolean;
  rarity: number;
  subtypes: string[][];
  aspects: string[];
  points: number;
  type: string;
  warlordclasses: string[];
  lieuclasses: string[];
  gruntclasses: string[];
};

export type SubType = {
  title: string;
  summary: string;
  storyinfluence?: string;
  rarity: number;
  aspects: string[];
  points: number;
  type: string;
  quote?: string;
  quote_followup?: string;
  warlordclasses: string[];
  lieuclasses: string[];
  gruntclasses: string[];
};

export type AspectType = {
  title: string;
  summary: string;
  storyinfluence?: string;
  rarity: number;
  class: string | null;
  points: number;
  type: string;
  warlordclasses: string[];
  lieuclasses: string[];
  gruntclasses: string[];
};

export type ClassType = {
  name: string;
  desc: string;
  alt_name: string;
  storyinfluence?: string;
  rarity: number;
  slots: number;
  type: string;
};

export type StorytellerType = {
  title: string;
  summary: string;
  type: string;
};

export type NobleType = {
  name: string;
  job: string;
  special_role?: string;
  in_lobby?: boolean;
};

export type CasusBelliTerm = {
  name: string;
  desc: string;
  hint?: string;
  requires_text: boolean;
  requires_number: boolean;
  open_signatures: boolean;
  target_options: number;
  type: string;
  warbandlock?: string;
  custom_name?: string;
  text?: string;
  number?: number;
  target?: string;
  receiver?: string;
  obj_target?: string;
};

export type CasusBelliProposal = {
  proposal_id: string; // a proposal's ID is the user ckey's + worldtime
  term_type: string;
  term_name: string;
  term_desc: string;
  vote_count: number;
  pending_count: number;
  is_user_proposal: boolean;
  is_user_vote: boolean;
  is_user_vote_confirmed: boolean;
  is_warlord_selected: boolean;
  term_custom_name?: string;
  term_text?: string;
  term_number?: number;
  term_target?: string;
  term_receiver?: string;
  term_obj_target?: string;
};

export type Data = {
  user_role?: string;
  finalized_status?: boolean;
  creation_stage: number;
  warlord_spawned: boolean;
  is_warlord: boolean;
  time_remaining: number;
  timer_active: boolean;
  warbands?: WarbandType[];
  subtypes?: SubType[];
  aspects?: AspectType[];
  classes?: ClassType[];
  backendstorytellers?: StorytellerType[];
  backend_warband?: WarbandType[];
  backend_subtype?: SubType[];
  backend_aspects?: AspectType[];
  nobles?: NobleType[];
  allies?: NobleType[];
  all_terms?: CasusBelliTerm[];
  casus_belli_proposals?: CasusBelliProposal[];
  user_proposal?: string | null;
  user_vote?: string | null;
  user_vote_confirmed?: boolean;
  warlord_selected_proposal?: string | null;
  warlord_casus_belli?: CasusBelliTerm | null;
  backend_factions?: any[];
  backend_territories?: any[];
};
