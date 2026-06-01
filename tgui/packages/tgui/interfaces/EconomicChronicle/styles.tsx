import type { CSSProperties, ReactNode } from 'react';

import {
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  SEAL_AMBER,
  SERIF,
} from '../common/parchment';

export const twoColTable: CSSProperties = {
  width: '100%',
  borderCollapse: 'collapse',
  fontFamily: SERIF,
  fontSize: FONT_BODY,
};

export const labelCell: CSSProperties = {
  color: SEAL_AMBER,
  padding: '1px 6px 1px 0',
  whiteSpace: 'nowrap',
};

export const valueCell: CSSProperties = {
  color: INK,
  padding: '1px 0',
  textAlign: 'right',
};

export const breakdownStyle: CSSProperties = {
  color: INK_FAINT,
  fontSize: FONT_BODY,
  paddingLeft: '10px',
  lineHeight: '1.2em',
  marginBottom: '2px',
};

export const dividerStyle: CSSProperties = {
  borderTop: `1px dashed ${INK_FAINT}`,
  margin: '3px 0',
};

export const twoColumnLayout: CSSProperties = {
  display: 'grid',
  gridTemplateColumns: '1fr 1fr',
  gap: '14px',
};

export const threeColumnLayout: CSSProperties = {
  display: 'grid',
  gridTemplateColumns: '1fr 1fr 1fr',
  gap: '14px',
};

export const dividedTwoColumnLayout: CSSProperties = {
  display: 'grid',
  gridTemplateColumns: '1fr 1px 1fr',
  gap: '14px',
  alignItems: 'stretch',
};

export const verticalDividerStyle: CSSProperties = {
  width: '1px',
  background: `linear-gradient(to bottom, transparent 0%, ${INK_FAINT} 15%, ${INK_FAINT} 85%, transparent 100%)`,
};

export const compactCardStyle: CSSProperties = {
  background: 'var(--p-card-bg)',
  border: `1px solid ${INK_FAINT}`,
  borderRadius: '2px',
  padding: '4px 8px',
  marginBottom: '5px',
  boxShadow: '1px 1px 4px var(--p-card-shadow)',
};

export const compactPageStyle: CSSProperties = {
  position: 'relative',
  minHeight: '100%',
  padding: '8px 14px 14px 14px',
  fontFamily: SERIF,
  color: INK,
  fontSize: FONT_BODY,
  lineHeight: 1.3,
};

export const compactSectionHeader: CSSProperties = {
  fontSize: FONT_BODY,
  color: INK,
  fontWeight: 'bold',
  borderBottom: `1px solid ${INK_FAINT}`,
  paddingBottom: '1px',
  marginTop: '3px',
  marginBottom: '4px',
};

export const compactHeaderCell: CSSProperties = {
  padding: '2px 6px 2px 0',
  color: INK_SOFT,
};

export const compactDataCell: CSSProperties = {
  padding: '1px 6px 1px 0',
  color: INK,
};

export const columnSubheadStyle: CSSProperties = {
  fontSize: FONT_BODY,
  color: INK_SOFT,
  borderBottom: `1px dotted ${INK_FAINT}`,
  paddingBottom: '1px',
  marginBottom: '3px',
  letterSpacing: '0.5px',
};

export const Row = (props: {
  label: string;
  value: number | string;
  color?: string;
}) => (
  <tr>
    <td style={labelCell}>{props.label}</td>
    <td style={{ ...valueCell, color: props.color || INK }}>{props.value}</td>
  </tr>
);

export const Breakdown = (props: { children: ReactNode }) => (
  <div style={breakdownStyle}>{props.children}</div>
);

export const SectionTitle = (props: { children: ReactNode }) => (
  <div style={compactSectionHeader}>{props.children}</div>
);

export const formatPct = (n: number | null) =>
  n === null ? 'n/a' : `${n}%`;
