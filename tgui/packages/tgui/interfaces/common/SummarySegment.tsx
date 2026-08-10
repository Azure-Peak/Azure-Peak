import type { CSSProperties } from 'react';

import {
  FONT_BODY,
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
  subtitle?: string;
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
  letterSpacing: '1px',
};

const subheadingStyle: CSSProperties = {
  fontFamily: SERIF,
  fontSize: FONT_BODY,
  color: INK_SOFT,
  fontStyle: 'italic',
  marginBottom: '2px',
};

const bodyStyle: CSSProperties = {
  fontFamily: SERIF,
  fontSize: FONT_LEAD,
  color: INK_SOFT,
  lineHeight: '1.4em',
};

export const SummarySegment = (props: SummarySegmentProps) => {
  const shown = props.items.filter((item) => item.value != null);
  if (!shown.length && !props.title) {
    return null;
  }
  return (
    <div style={segmentStyle}>
      {!!props.title && <div style={headingStyle}>{props.title}</div>}
      {!!props.subtitle && (
        <div style={subheadingStyle}>{props.subtitle}</div>
      )}
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
