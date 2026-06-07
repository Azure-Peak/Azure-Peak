import type { CSSProperties } from 'react';

export const FONT_TINY = '10px';
export const FONT_SMALL = '11px';
export const FONT_BODY = '12px';
export const FONT_LEAD = '13px';
export const FONT_TITLE = '14px';
export const FONT_HEAD = '15px';

export const INK = 'var(--p-ink)';
export const INK_SOFT = 'var(--p-ink-soft)';
export const INK_FAINT = 'var(--p-ink-faint)';
export const PARCHMENT = 'var(--p-bg)';
export const PARCHMENT_DEEP = 'var(--p-bg-deep)';
export const PARCHMENT_SHADOW = 'var(--p-bg-shadow)';
export const SEAL_RED = 'var(--p-seal-red)';
export const SEAL_RED_SOFT = 'var(--p-seal-red-soft)';
export const SEAL_GREEN = 'var(--p-seal-green)';
export const SEAL_BLUE = 'var(--p-seal-blue)';
export const SEAL_AMBER = 'var(--p-seal-amber)';
export const BUTTON_BG = 'var(--p-button-bg)';

export const SERIF = '"Palatino Linotype", Palatino, "Book Antiqua", Georgia, serif';

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
  background: active ? 'var(--p-tab-active-bg)' : 'transparent',
  border: `1px solid ${active ? INK_SOFT : 'transparent'}`,
  borderRadius: '2px',
  cursor: 'pointer',
  fontWeight: active ? 'bold' : 'normal',
});

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
  background: active ? 'var(--p-tab-active-bg)' : 'transparent',
  border: `1px solid ${active ? INK_SOFT : INK_FAINT}`,
  borderRadius: '2px',
  cursor: 'pointer',
  fontWeight: active ? 'bold' : 'normal',
  whiteSpace: 'nowrap',
});

export const cardStyle: CSSProperties = {
  background: 'var(--p-card-bg)',
  border: `1px solid ${INK_FAINT}`,
  borderRadius: '2px',
  padding: '8px 12px',
  marginBottom: '10px',
  boxShadow: '1px 1px 4px var(--p-card-shadow)',
};

export const dashedFrameStyle: CSSProperties = {
  padding: '8px 10px',
  border: `1px dashed ${INK_FAINT}`,
  textAlign: 'left',
  fontSize: '12px',
  lineHeight: 1.4,
  color: INK_SOFT,
};

export const stickyLeftCellStyle: CSSProperties = {
  position: 'sticky',
  left: 0,
  background: 'var(--p-card-bg)',
};

export const badgeStyle = (color: string): CSSProperties => ({
  display: 'inline-block',
  fontFamily: SERIF,
  fontSize: '10px',
  fontVariant: 'small-caps',
  padding: '1px 7px',
  marginLeft: '6px',
  color: 'var(--p-badge-text)',
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

export const inkInputStyle: CSSProperties = {
  fontFamily: SERIF,
  fontSize: '13px',
  color: INK,
  background: BUTTON_BG,
  border: `1px solid ${INK_FAINT}`,
  borderRadius: '2px',
  padding: '2px 6px',
  outline: 'none',
};

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

export const bannerStyle = (color: string, soft: boolean = false): CSSProperties => ({
  background: soft
    ? 'var(--p-banner-bg-soft)'
    : 'var(--p-banner-bg)',
  border: `1px solid ${color}`,
  color: color,
  padding: '6px 12px',
  marginBottom: '10px',
  textAlign: 'center',
  fontVariant: 'small-caps',
  fontWeight: 'bold',
});

export const denseRowStyle: CSSProperties = {
  display: 'flex',
  alignItems: 'center',
  gap: '6px',
  padding: '4px 6px',
  borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
  fontFamily: SERIF,
  lineHeight: 1.3,
};

export const ellipsisCellStyle: CSSProperties = {
  flex: 1,
  minWidth: 0,
  overflow: 'hidden',
  textOverflow: 'ellipsis',
  whiteSpace: 'nowrap',
};

export const compactButtonStyle = (opts: {
  color?: string;
  disabled?: boolean;
} = {}): CSSProperties => ({
  ...inkButtonStyle(opts),
  padding: '1px 7px',
  fontSize: FONT_LEAD,
});

export const PriceTag = (props: {
  price: number;
  tariff?: number;
  cantAfford?: boolean;
  title?: string;
  strikethrough?: number;
}) => {
  const { price, tariff, cantAfford, title, strikethrough } = props;
  const hasTariff = !!tariff && tariff > 0;
  const hasStrike = !!strikethrough && strikethrough > price;
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
      {hasStrike && (
        <span
          style={{
            color: INK_FAINT,
            textDecoration: 'line-through',
            marginRight: '4px',
            fontSize: FONT_BODY,
          }}
        >
          {strikethrough}m
        </span>
      )}
      <span style={{ color: hasStrike ? SEAL_GREEN : 'inherit' }}>{price}</span>
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
