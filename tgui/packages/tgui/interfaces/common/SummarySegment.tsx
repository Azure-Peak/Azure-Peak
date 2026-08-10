import type { CSSProperties } from 'react';

import {
  FONT_LEAD,
  INK,
  INK_FAINT,
  INK_SOFT,
  SEAL_RED,
  SERIF,
} from './parchment';

export type SummaryItem = {
  label: string;
  value: number | string | null;
  color?: string;
};

type SummarySegmentProps = {
  items: SummaryItem[];
  title?: string;
};

const segmentStyle: CSSProperties = {
  textAlign: 'center',
  padding: '2px 6px 6px 6px',
  marginBottom: '6px',
  borderBottom: `1px solid ${INK_FAINT}`,
};

const headingStyle: CSSProperties = {
  fontFamily: SERIF,
  fontSize: FONT_LEAD,
  color: SEAL_RED,
  fontWeight: 'bold',
  letterSpacing: '3px',
  marginBottom: '3px',
};

const bodyStyle: CSSProperties = {
  fontFamily: SERIF,
  fontSize: FONT_LEAD,
  color: INK_SOFT,
  lineHeight: '1.4em',
};

export const SummarySegment = (props: SummarySegmentProps) => {
  const shown = props.items.filter((item) => item.value != null);
  if (!shown.length) {
    return null;
  }
  return (
    <div style={segmentStyle}>
      <div style={headingStyle}>{props.title || 'SUMMARY'}</div>
      <div style={bodyStyle}>
        {shown.map((item, i) => (
          <span key={item.label}>
            {i > 0 && <span style={{ color: INK_FAINT }}> &bull; </span>}
            <span>{item.label} </span>
            <span style={{ color: item.color || INK, fontWeight: 'bold' }}>
              {item.value}
            </span>
          </span>
        ))}
      </div>
    </div>
  );
};
