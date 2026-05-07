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

export type NoticeboardData = {
  realm_name: string;
  postings: Posting[];
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
