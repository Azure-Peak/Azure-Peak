import type { BooleanLike } from 'tgui-core/react';

import type { QuestRow } from '../QuestDebugPanel';

export type WarbandMember = {
  name: string;
  count: number;
  threat: number;
};

export type SpawnDetail = {
  name: string;
  category: string;
  threat: number;
  path: string;
  size?: number;
  members?: WarbandMember[];
};

export type QuestEntry = {
  path: string;
  name: string;
  count: number;
  threat?: number;
};

export type QuestItemResult = {
  path: string;
  name: string;
};

export type QuestRegion = {
  name: string;
  free_landmarks: number;
};

export type QuestDraftData = {
  kind: string;
  title: string;
  description: string;
  group_word: string;
  foe_name: string;
  reward: number;
  threat_bands: number;
  region: string | null;
  crimes: string;
  fellowship_size: number;
  on_floor: BooleanLike;
  mobs: QuestEntry[];
  mob_total: number;
  shipment_name: string;
  destination: string | null;
  items: QuestEntry[];
  item_total: number;
  item_query: string;
  item_results: QuestItemResult[];
  regions: QuestRegion[];
  ready: BooleanLike;
  posted: BooleanLike;
  levy_rate: number;
};

export type QuestStaticData = {
  default_group_word: string;
  default_foe_name: string;
  foe_len: number;
  kill_kind: string;
  recovery_kind: string;
  destinations: QuestItemResult[];
  max_reward: number;
  title_len: number;
  description_len: number;
  crimes_len: number;
  kill_objective: string;
  mob_cap: number;
  item_cap: number;
  max_threat_bands: number;
  max_fellowship: number;
  guild_cut_rate: number;
};

export type GmQuestRow = QuestRow & {
  reward: number;
};

export type GameMasterData = {
  quest_open: BooleanLike;
  quest?: QuestDraftData;
  gm_quests?: GmQuestRow[];
  quest_static: QuestStaticData;
  selected_view: string;
  pinned_factions: string[];
  max_pinned: number;
  selected_filter: string;
  selected_mob_name: string;
  selected_faction: string;
  selected_detail: SpawnDetail | null;
  spawn_count: number;
  spawn_ai: boolean;
  spawn_taints_loot: boolean;
  spawn_dust: boolean;
  spawn_dust_leave_head: boolean;
  spawn_dust_delete_gear: boolean;
  spawn_spread: boolean;
  spawn_click_intercept: boolean;
  selectable_mobs: string[];
  spawn_filters: string[];
  filter_counts: Record<string, number>;
  spawn_factions: string[];
  mob_threats: Record<string, number>;
};

export const VIEW_INDIVIDUAL = 'individual';
export const VIEW_WARBAND = 'warband';
export const FILTER_ALL = 'all';
export const NATIVE_FACTION_VALUE = '';
export const NATIVE_FACTION_LABEL = 'Native';

export function toTitle(value: string): string {
  return value
    .replace(/[-_]/g, ' ')
    .split(' ')
    .filter(Boolean)
    .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
    .join(' ');
}

export function shortPath(path: string): string {
  const parts = path.split('/').filter(Boolean);
  if (parts.length <= 3) {
    return `/${parts.join('/')}`;
  }
  return `.../${parts.slice(-3).join('/')}`;
}

export const ELLIPSIS = {
  minWidth: 0,
  overflow: 'hidden',
  textOverflow: 'ellipsis',
  whiteSpace: 'nowrap',
} as const;

export const ROW = {
  display: 'flex',
  alignItems: 'baseline',
  justifyContent: 'space-between',
  gap: '0.5em',
  minWidth: 0,
} as const;

export const TRAILING = {
  flex: '0 0 auto',
  opacity: 0.6,
  fontVariantNumeric: 'tabular-nums',
} as const;

export function filterLabel(value: string, warband = false): string {
  if (value === FILTER_ALL) {
    return warband ? 'All warbands' : 'All creatures';
  }
  return toTitle(value);
}
