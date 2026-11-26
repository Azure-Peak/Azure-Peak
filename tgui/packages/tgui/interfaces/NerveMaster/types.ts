import type { BooleanLike } from 'tgui-core/react';

import type { SequestrationState } from '../StewardTrade/types';

export type EconomicEvent = {
  name: string;
  description: string;
  days_left: number;
  shortage_goods: string[];
  glut_goods: string[];
  saturation_target: number;
  saturation_progress: number;
};

export type BanditryRow = {
  region: string;
  level: string;
  cost: number;
  detail: string;
};

export type BanditryProjection = {
  total: number;
  rows: BanditryRow[];
  debt: number;
  hoard_total: number;
};

export type BlockadeLeg = {
  name: string;
  threat_region: string;
  raiders: string;
  regions: string[];
};

export type BlockadeRow = {
  name: string;
  legs: BlockadeLeg[];
};

export type AtcLoanState = {
  available: BooleanLike;
  can_view: BooleanLike;
  min: number;
  max: number;
  closed_day: number;
  interest_pct: number;
  blocker: string;
  arrears_consumed: BooleanLike;
  loans_drawn: number;
  outstanding: number;
};

export type Data = {
  day: number;
  treasury: number;
  expected_rural_revenue: number;
  expected_wage_outlay: number;
  sequestration: SequestrationState;
  banditry_projection: BanditryProjection;
  blockades: BlockadeRow[];
  events: EconomicEvent[];
  atc_loan: AtcLoanState;
};
