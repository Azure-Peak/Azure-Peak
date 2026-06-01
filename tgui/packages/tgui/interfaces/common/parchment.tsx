import type { CSSProperties } from 'react';

export const FONT_TINY = 'var(--p-font-tiny)';
export const FONT_SMALL = 'var(--p-font-small)';
export const FONT_BODY = 'var(--p-font-body)';
export const FONT_LEAD = 'var(--p-font-lead)';
export const FONT_TITLE = 'var(--p-font-title)';
export const FONT_HEAD = 'var(--p-font-head)';

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
export const TITLE = 'var(--p-title)';
export const TITLE_FONT = 'var(--p-title-font)';

export const SERIF = '"Lora", Georgia, serif';

export const pageStyle: CSSProperties = {
  position: 'relative',
  minHeight: '100%',
  padding: '18px 28px 28px 28px',
  fontFamily: SERIF,
  color: INK,
  fontSize: FONT_BODY,
  lineHeight: 1.5,
};

export const titleStyle: CSSProperties = {
  textAlign: 'center',
  fontSize: '22px',
  fontWeight: 'bold',
  fontFamily: TITLE_FONT,
  color: TITLE,
  margin: '0 0 4px 0',
};

export const subtitleStyle: CSSProperties = {
  textAlign: 'center',
  color: INK_SOFT,
  fontStyle: 'italic',
  fontSize: FONT_BODY,
  marginBottom: '10px',
};

export const rulerStyle: CSSProperties = {
  height: '1px',
  background: `linear-gradient(90deg, transparent 0%, ${INK_FAINT} 20%, ${INK_FAINT} 80%, transparent 100%)`,
  border: 'none',
  margin: '8px 0 14px 0',
};

export const sectionHeaderStyle: CSSProperties = {
  fontSize: FONT_TITLE,
  color: TITLE,
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
  fontSize: FONT_BODY,
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
  fontSize: FONT_BODY,
  padding: '3px 10px',
  color: active ? INK : INK_FAINT,
  background: active ? 'var(--p-tab-active-bg)' : 'transparent',
  border: `1px solid ${active ? INK_SOFT : INK_FAINT}`,
  borderRadius: '2px',
  cursor: 'pointer',
  fontWeight: active ? 'bold' : 'normal',
  whiteSpace: 'nowrap',
});

/// Wiki-style table-of-contents link. Renders as plain text with a dashed separator
/// between rows, a subtle background tint when selected, and a hover underline.
/// Apply via `style={tocLinkStyle(active)} className="toc-link"` on a button or anchor.
/// Hover style lives in parchment.scss (and variants) keyed off the .toc-link class.
export const tocLinkStyle = (active: boolean): CSSProperties => ({
  display: 'block',
  width: '100%',
  textAlign: 'left',
  background: active ? 'var(--p-tab-active-bg)' : 'transparent',
  border: 'none',
  borderBottom: `1px dashed ${INK_FAINT}`,
  padding: '4px 8px',
  fontFamily: SERIF,
  fontSize: FONT_TITLE,
  color: active ? INK : INK_SOFT,
  fontWeight: active ? 'bold' : 'normal',
  cursor: 'pointer',
  whiteSpace: 'normal',
  lineHeight: 1.3,
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
  fontSize: FONT_BODY,
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
  fontSize: FONT_BODY,
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
    fontSize: FONT_BODY,
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
  fontSize: FONT_BODY,
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
  fontSize: FONT_BODY,
};

export const fieldLabelStyle: CSSProperties = {
  flex: '0 0 145px',
  fontWeight: 500,
  color: SEAL_AMBER,
};

export const fieldValueStyle: CSSProperties = {
  color: INK,
  flex: 1,
  fontFamily: SERIF,
  fontSize: FONT_BODY,
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
