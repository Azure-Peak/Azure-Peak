export type SpawnDetail = {
  name: string;
  category: string;
  threat: number;
  path: string;
};

export type GameMasterData = {
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

export function filterLabel(value: string): string {
  return value === FILTER_ALL ? 'All creatures' : toTitle(value);
}
