import type { CSSProperties } from 'react';

// ── Font scale ───────────────────────────────────────────────────
// Use these constants rather than raw px values. Bumping body text
// site-wide is then a one-line change here.
export const FONT_TINY = '10px';
export const FONT_SMALL = '11px';
export const FONT_BODY = '12px';
export const FONT_LEAD = '13px';
export const FONT_TITLE = '14px';
export const FONT_HEAD = '15px';

// ── Parchment palette ────────────────────────────────────────────
export const INK = '#3a2a14';
export const INK_SOFT = '#5a3f1f';
export const INK_FAINT = '#7a5e3a';
export const PARCHMENT = '#f4e7c6';
export const PARCHMENT_DEEP = '#e6d4a3';
export const PARCHMENT_SHADOW = '#c7a86a';
export const SEAL_RED = '#8b2020';
export const SEAL_RED_SOFT = '#a8433a';
export const SEAL_GREEN = '#3b6a35';
export const SEAL_BLUE = '#2e4a78';
export const SEAL_AMBER = '#7a5616';
export const BUTTON_BG = 'rgba(255,248,220,0.6)';
export const BUTTON_HOVER_BG = 'rgba(200,170,100,0.35)';

export const SERIF = '"Palatino Linotype", Palatino, "Book Antiqua", Georgia, serif';

// ── Shared styles ────────────────────────────────────────────────
export const pageStyle: CSSProperties = {
  position: 'relative',
  minHeight: '100%',
  padding: '18px 28px 28px 28px',
  fontFamily: SERIF,
  color: INK,
  fontSize: '13px',
  lineHeight: 1.5,
};

export const titleStyle: CSSProperties = {
  textAlign: 'center',
  fontSize: '22px',
  fontVariant: 'small-caps',
  fontWeight: 'bold',
  color: INK,
  margin: '0 0 4px 0',
};

export const subtitleStyle: CSSProperties = {
  textAlign: 'center',
  color: INK_SOFT,
  fontStyle: 'italic',
  fontSize: '12px',
  marginBottom: '10px',
};

export const rulerStyle: CSSProperties = {
  height: '1px',
  background: `linear-gradient(90deg, transparent 0%, ${INK_FAINT} 20%, ${INK_FAINT} 80%, transparent 100%)`,
  border: 'none',
  margin: '8px 0 14px 0',
};

export const sectionHeaderStyle: CSSProperties = {
  fontVariant: 'small-caps',
  fontSize: '15px',
  color: INK,
  fontWeight: 'bold',
  borderBottom: `1px solid ${INK_FAINT}`,
  paddingBottom: '2px',
  marginTop: '10px',
  marginBottom: '8px',
};

export const tabBarStyle: CSSProperties = {
  display: 'flex',
  gap: '6px',
  justifyContent: 'center',
  margin: '10px 0 6px 0',
};

export const tabStyle = (active: boolean): CSSProperties => ({
  fontFamily: SERIF,
  fontSize: '14px',
  fontVariant: 'small-caps',
  padding: '4px 18px',
  color: active ? INK : INK_FAINT,
  background: active ? 'rgba(200,170,100,0.25)' : 'transparent',
  border: `1px solid ${active ? INK_SOFT : 'transparent'}`,
  borderRadius: '2px',
  cursor: 'pointer',
  fontWeight: active ? 'bold' : 'normal',
});

// Sub-category tab row. Many categories at once — wraps to multiple rows rather than
// overflowing horizontally. Smaller per-tab padding than primary tabs.
export const subTabBarStyle: CSSProperties = {
  display: 'flex',
  flexWrap: 'wrap',
  gap: '4px',
  justifyContent: 'flex-start',
  margin: '6px 0',
};

export const subTabStyle = (active: boolean): CSSProperties => ({
  fontFamily: SERIF,
  fontSize: '12px',
  fontVariant: 'small-caps',
  padding: '3px 10px',
  color: active ? INK : INK_FAINT,
  background: active ? 'rgba(200,170,100,0.25)' : 'transparent',
  border: `1px solid ${active ? INK_SOFT : INK_FAINT}`,
  borderRadius: '2px',
  cursor: 'pointer',
  fontWeight: active ? 'bold' : 'normal',
  whiteSpace: 'nowrap',
});

export const cardStyle: CSSProperties = {
  background: 'rgba(255,248,220,0.45)',
  border: `1px solid ${INK_FAINT}`,
  borderRadius: '2px',
  padding: '8px 12px',
  marginBottom: '10px',
  boxShadow: '1px 1px 4px rgba(80,50,10,0.12)',
};

export const badgeStyle = (color: string): CSSProperties => ({
  display: 'inline-block',
  fontFamily: SERIF,
  fontSize: '10px',
  fontVariant: 'small-caps',
  padding: '1px 7px',
  marginLeft: '6px',
  color: '#f7eccb',
  background: color,
  border: `1px solid ${color}`,
  borderRadius: '2px',
  verticalAlign: 'middle',
});

export const inkButtonStyle = (opts: {
  color?: string;
  disabled?: boolean;
} = {}): CSSProperties => {
  const col = opts.color || INK;
  return {
    fontFamily: SERIF,
    fontSize: '12px',
    fontWeight: 'bold',
    padding: '2px 10px',
    color: col,
    background: opts.disabled ? 'transparent' : BUTTON_BG,
    border: opts.disabled
      ? `1px dashed ${INK_FAINT}`
      : `1px solid ${col}`,
    borderRadius: '2px',
    cursor: opts.disabled ? 'default' : 'pointer',
    opacity: opts.disabled ? 0.7 : 1,
    transition: 'background-color 80ms linear',
  };
};

export const chipStyle = (color: string = INK_SOFT): CSSProperties => ({
  display: 'inline-block',
  fontFamily: SERIF,
  fontSize: '12px',
  fontWeight: 'bold',
  padding: '1px 8px',
  color: color,
  background: 'transparent',
  border: `1px dashed ${color}`,
  borderRadius: '2px',
});

export const fieldRowStyle: CSSProperties = {
  display: 'flex',
  padding: '5px 0',
  borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
  fontSize: '13px',
};

export const fieldLabelStyle: CSSProperties = {
  flex: '0 0 145px',
  fontVariant: 'small-caps',
  color: SEAL_AMBER,
  fontStyle: 'italic',
};

export const fieldValueStyle: CSSProperties = {
  color: INK,
  flex: 1,
  fontFamily: SERIF,
  fontSize: '14px',
};

export const framedShellStyle: CSSProperties = {
  position: 'relative',
  padding: '24px 28px',
  border: `3px double ${SEAL_AMBER}`,
  outline: `1px solid ${PARCHMENT_SHADOW}`,
  outlineOffset: '-6px',
  boxShadow: `inset 0 0 100px rgba(122, 86, 22, 0.22), inset 0 0 6px ${SEAL_AMBER}`,
};

export const bannerStyle = (color: string, soft: boolean = false): CSSProperties => ({
  background: soft
    ? 'rgba(180,60,40,0.12)'
    : 'rgba(180,60,40,0.18)',
  border: `1px solid ${color}`,
  color: color,
  padding: '6px 12px',
  marginBottom: '10px',
  textAlign: 'center',
  fontVariant: 'small-caps',
  fontWeight: 'bold',
});

// ── Dense list primitives ────────────────────────────────────────
// Shared scaffold for compact "name … price [Buy]" rows used by
// PackRow, StockCard, ShipRow bulk lines, etc. Pass alignItems
// 'baseline' for text-only rows; defaults to 'center' for rows
// containing inputs/buttons.
export const denseRowStyle: CSSProperties = {
  display: 'flex',
  alignItems: 'center',
  gap: '6px',
  padding: '4px 6px',
  borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
  fontFamily: SERIF,
  lineHeight: 1.3,
};

// The truncating name cell used inside a dense row. Combine with
// fontSize / fontWeight / color on the consumer side.
export const ellipsisCellStyle: CSSProperties = {
  flex: 1,
  minWidth: 0,
  overflow: 'hidden',
  textOverflow: 'ellipsis',
  whiteSpace: 'nowrap',
};

// Tighter Buy/Send button variant for dense rows.
export const compactButtonStyle = (opts: {
  color?: string;
  disabled?: boolean;
} = {}): CSSProperties => ({
  ...inkButtonStyle(opts),
  padding: '1px 7px',
  fontSize: FONT_LEAD,
});

// ── PriceTag ─────────────────────────────────────────────────────
// {price}{+tariff?}{m} triplet used by every "buy this for N mammon"
// row. Bold price (faints when unaffordable), amber bold tariff
// suffix, soft 'm' unit. Pass `title` for the hover breakdown.
export const PriceTag = (props: {
  price: number;
  tariff?: number;
  cantAfford?: boolean;
  title?: string;
}) => {
  const { price, tariff, cantAfford, title } = props;
  const hasTariff = !!tariff && tariff > 0;
  return (
    <div
      style={{
        fontSize: FONT_LEAD,
        color: cantAfford ? INK_FAINT : INK,
        flexShrink: 0,
        whiteSpace: 'nowrap',
      }}
      title={title}
    >
      {price}
      {hasTariff && (
        <span
          style={{
            color: SEAL_AMBER,
            fontSize: FONT_BODY,
            marginLeft: '2px',
          }}
        >
          +{tariff}
        </span>
      )}
      <span style={{ color: INK_SOFT, fontSize: FONT_SMALL }}>m</span>
    </div>
  );
};
