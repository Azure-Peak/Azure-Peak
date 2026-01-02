export type FactionType = {
  name: string;
  desc: string;
  type: string;
  icon: string;
  territories: any[];
  vault: number;
  owner?: string;
  job_owner?: string;
}

export type TerritoryType = {
  name: string;
  desc: string;
  faction_name?: string;
  prized_good?: string;
  aspects?: Array<{name: string; desc: string}>;
}

export type TermType = {
  name: string;
  custom_name?: string;
  desc: string;
  hint: string;
  text?: string;
  original_name?: string;  
  signed?: boolean;
  number?: number;
  requires_text?: boolean;
  requires_number?: boolean;
  index?: number;
  target_options?: number;
  target?: string;
  receiver?: string;
  obj_target?: string;
  authorities?: string[];
  signatures?: string[];
  minimum_signatures?: number;
  open_signatures?: boolean;
}

export type Data = {
  user_role?: string;
  is_expert?: boolean;
  firstparty?: FactionType;
  secondparty?: FactionType;
  terms?: TermType[];
  all_terms?: TermType[];
  backend_factions?: FactionType[];
  backend_territories?: TerritoryType[];
};
