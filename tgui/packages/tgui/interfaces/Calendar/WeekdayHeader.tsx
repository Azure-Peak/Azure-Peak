import type { CSSProperties } from 'react';

import { INK_FAINT, INK_SOFT } from '../common/parchment';

const rowStyle: CSSProperties = {
  display: 'grid',
  gridTemplateColumns: 'repeat(7, 1fr)',
  gap: '2px',
  borderBottom: `1px solid ${INK_FAINT}`,
  marginBottom: '4px',
};

const cellStyle: CSSProperties = {
  textAlign: 'center',
  fontVariant: 'small-caps',
  letterSpacing: '1px',
  fontSize: '11px',
  color: INK_SOFT,
  padding: '4px 0',
};

type Props = { names: string[] };

export const WeekdayHeader = ({ names }: Props) => (
  <div style={rowStyle}>
    {names.map((name) => (
      <div key={name} style={cellStyle}>
        {name}
      </div>
    ))}
  </div>
);
