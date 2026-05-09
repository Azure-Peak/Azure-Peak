import { type RoutedActFunctionType } from '../../backend';

export const POSTING_TIER_NOTICE = 'notice';
export const POSTING_TIER_LISTING = 'listing';

export type PostingTier = typeof POSTING_TIER_NOTICE | typeof POSTING_TIER_LISTING;

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

export type NoticeboardData = {
  realm_name: string;
  postings: Posting[];
  scout_regions: ScoutRegion[];
  trade_orders: TradeOrder[];
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
  act: RoutedActFunctionType;
};
