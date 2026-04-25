import type { CSSProperties } from 'react';
import type { BooleanLike } from 'tgui-core/react';

export type QuestScrollData = {
  empty?: BooleanLike;
  title?: string;
  realm_name?: string;
  ruler_title?: string;
  issued_by?: string;
  issued_to?: string;
  issued_on?: string | null;
  objective?: string;
  named_target?: string | null;
  band_leader?: string | null;
  faction_category?: string | null;
  faction_group_word?: string | null;
  faction_name_singular?: string | null;
  faction_name_plural?: string | null;
  faction_progress_noun?: string | null;
  crimes?: string[];
  sacral_invoked?: BooleanLike;
  oath_breach?: BooleanLike;
  condemnation?: string;
  writ_type?: string;
  circumstance?: string;
  pickup_region?: string | null;
  delivery_destination?: string | null;
  delivery_item?: string | null;
  fetch_item?: string | null;
  fetch_count?: number;
  recovery_shipment?: string | null;
  reward?: number;
  levy_rate?: number;
  progress_required?: number;
  progress_current?: number;
  compass_direction?: string;
  z_hint?: string;
  complete?: BooleanLike;
  levy_exempt?: BooleanLike;
  is_rumor?: BooleanLike;
  is_defense?: BooleanLike;
  blockade_timer_label?: string;
  blockade_timer_seconds?: number;
  blockade_current_wave?: number;
  blockade_total_waves?: number;
  blockade_armed?: BooleanLike;
  blockade_failed?: BooleanLike;
};

export const FACTION_CAT_HUMANOID = 'humanoid';
export const FACTION_CAT_BEAST = 'beast';
export const FACTION_CAT_BOG_DESERTER = 'bog_deserter';
export const FACTION_CAT_GRONN = 'gronn';
export const FACTION_CAT_GOBLINOID = 'goblinoid';
export const FACTION_CAT_DROW = 'drow';
export const FACTION_CAT_UNDEAD = 'undead';

export const CONDEMNATION_CAPUT_LUPINUM = 'caput_lupinum';
export const CONDEMNATION_UTLAGATUS = 'utlagatus';
export const CONDEMNATION_VOLKOMIR = 'volkomir';

export const WRIT_TYPE_RECOVERY = 'recovery';
export const WRIT_TYPE_CARRIAGE = 'carriage';

export const formatMinSec = (totalSeconds: number) => {
  if (totalSeconds <= 0) return '0:00';
  const minutes = Math.floor(totalSeconds / 60);
  const seconds = totalSeconds % 60;
  return `${minutes}:${seconds.toString().padStart(2, '0')}`;
};

export const capitalize = (s: string) =>
  s.length > 0 ? s.charAt(0).toUpperCase() + s.slice(1) : s;

export const parchment: CSSProperties = {
  color: 'hsl(28, 42%, 18%)',
  fontFamily: "Georgia, 'Palatino Linotype', Palatino, serif",
  padding: '24px 28px',
  minHeight: '100%',
  boxSizing: 'border-box',
  lineHeight: '1.55em',
};

export const writBody: CSSProperties = {
  fontSize: '0.97em',
};

export const writParagraph: CSSProperties = {
  marginBottom: '12px',
};

export const indictmentList: CSSProperties = {
  listStyle: 'none',
  padding: 0,
  margin: '4px 0 12px 18px',
};

export const indictmentItem: CSSProperties = {
  marginBottom: '2px',
  textIndent: '-12px',
  paddingLeft: '12px',
};

export const sacralPlea: CSSProperties = {
  fontStyle: 'italic',
  marginBottom: '12px',
  color: 'hsl(28, 50%, 25%)',
};

export const caputLupinum: CSSProperties = {
  fontWeight: 'bold',
  letterSpacing: '1.5px',
};

export const sealLine: CSSProperties = {
  fontStyle: 'italic',
  fontSize: '0.92em',
  color: 'hsl(28, 50%, 25%)',
  marginTop: '14px',
  marginBottom: '8px',
};

export const divider: CSSProperties = {
  border: 'none',
  borderTop: '1px solid hsl(30, 30%, 50%)',
  margin: '14px 0',
};

export const marginalia: CSSProperties = {
  background: 'hsla(46, 40%, 76%, 0.4)',
  border: '1px solid hsl(30, 30%, 60%)',
  borderRadius: '2px',
  padding: '8px 12px',
  marginTop: '12px',
  fontSize: '0.92em',
};

export const marginaliaLine: CSSProperties = {
  marginBottom: '4px',
};

export const marginaliaLabel: CSSProperties = {
  fontStyle: 'italic',
  color: 'hsl(30, 38%, 35%)',
  marginRight: '6px',
};

export const completionStamp: CSSProperties = {
  textAlign: 'center',
  fontWeight: 'bold',
  color: 'hsl(130, 45%, 28%)',
  fontSize: '1.08em',
  marginTop: '14px',
};

export const failedStamp: CSSProperties = {
  textAlign: 'center',
  fontWeight: 'bold',
  color: 'hsl(0, 55%, 32%)',
  fontSize: '1.08em',
  marginTop: '14px',
};

export const titleHint: CSSProperties = {
  fontSize: '0.78em',
  letterSpacing: '4px',
  textAlign: 'center',
  color: 'hsl(28, 52%, 30%)',
  marginBottom: '18px',
  fontVariant: 'small-caps',
};
