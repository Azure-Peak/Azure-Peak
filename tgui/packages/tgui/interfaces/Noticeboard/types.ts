import type { sendAct } from 'tgui/events/act';

export const POSTING_TIER_NOTICE = 'notice';
export const POSTING_TIER_LISTING = 'listing';

export type PostingTier =
  | typeof POSTING_TIER_NOTICE
  | typeof POSTING_TIER_LISTING;

export type Posting = {
  posting_id: string;
  tier: PostingTier;
  title: string;
  body: string;
  poster_name: string;
  poster_title: string;
  poster_job: string;
  signature_attested: boolean;
  posted_at_label: string;
  expires_in_label: string;
  is_own: boolean;
  can_authority_remove: boolean;
};

export type ScoutRegion = {
  region_name: string;
  danger_level: string;
  danger_color: string;
  ic_descriptions: string[];
  blockaded: boolean;
  blockade_writ_out: boolean;
  blockade_faction_label: string;
  blockade_region_label: string;
  blockade_days_active: number;
};

export type TradeOrderRequirement = {
  label: string;
  quantity: number;
};

export type TradeOrder = {
  name: string;
  region_label: string;
  description: string;
  days_left: number;
  total_payout: number;
  urgent: boolean;
  blockaded: boolean;
  warehouse: boolean;
  stockpile: boolean;
  petitioned: boolean;
  requirements: TradeOrderRequirement[];
};

export type HarborDemandLine = {
  good_name: string;
  qty_target: number;
  qty_fulfilled: number;
  qty_remaining: number;
  offered_price: number;
};

export type HarborCulturalEntry = {
  name: string;
  qty: number;
  base_cost: number;
  price: number;
};

export type HarborDemand = {
  ship_id: string;
  ship_name: string;
  realm_name: string;
  realm_id: string;
  seconds_until_departure: number;
  lines: HarborDemandLine[];
  cultural_stock: HarborCulturalEntry[];
};

export type Charter = {
  name: string;
  year: string | number;
  active: boolean;
  flavor_text: string;
};

export type EconomicEvent = {
  name: string;
  description: string;
  event_type: string;
  days_left: number;
  affected_goods: string[];
};

export type MercenaryEntry = {
  name: string;
  advjob: string;
  message: string;
};

export type MarketCategory = {
  category: string;
  capacity: number;
  consumed: number;
  fill_ratio: number;
  refused: boolean;
  demand_mult: number;
  pending_ship_demand: number;
};

export type RealmDemandRow = {
  realm_id: string;
  name: string;
  demanded: string[];
};

export type MarketData = {
  categories: MarketCategory[];
  pop_snapshot: number;
  category_count: number;
  theme_dispatch?: string;
  realm_demand_matrix?: RealmDemandRow[];
  all_buckets?: string[];
};

export type MercenaryRoster = {
  available: MercenaryEntry[];
  contracted: MercenaryEntry[];
  dnd: MercenaryEntry[];
  available_count: number;
  contracted_count: number;
  dnd_count: number;
};

export type NoticeboardData = {
  realm_name: string;
  postings: Posting[];
  scout_regions: ScoutRegion[];
  trade_orders: TradeOrder[];
  harbor_demands: HarborDemand[];
  charters: Charter[];
  economic_events: EconomicEvent[];
  mercenary_roster: MercenaryRoster;
  market_data: MarketData;
  can_post_listing: boolean;
  can_authority_remove: boolean;
  user_real_name: string;
  user_default_name: string;
  user_default_role: string;
  has_active_notice: boolean;
  has_active_listing: boolean;
};

export type TabKey = 'postings' | 'avisa' | 'roster';

export type TabProps = {
  data: NoticeboardData;
  act: typeof sendAct;
};
