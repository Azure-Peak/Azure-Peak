import {
  INK_SOFT,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  SEAL_RED_SOFT,
} from './parchment';

const BAND_COLOR: Record<string, string> = {
  Shortage: SEAL_RED,
  'Very Scarce': SEAL_RED,
  Scarce: SEAL_RED_SOFT,
  Low: SEAL_AMBER,
  Steady: INK_SOFT,
  Plentiful: SEAL_GREEN,
  Abundant: SEAL_GREEN,
  Overstocked: SEAL_GREEN,
  Glut: SEAL_GREEN,
};

const EVENT_BANDS = ['Shortage', 'Glut'];

export const MarketBand = (props: { label: string }) => {
  const { label } = props;
  const color = BAND_COLOR[label] ?? INK_SOFT;
  if (EVENT_BANDS.includes(label)) {
    return (
      <span
        style={{
          color,
          fontWeight: 'bold',
          padding: '0 4px',
          border: `1px solid ${color}`,
          borderRadius: '2px',
        }}
      >
        {label}
      </span>
    );
  }
  return <span style={{ color }}>{label}</span>;
};
