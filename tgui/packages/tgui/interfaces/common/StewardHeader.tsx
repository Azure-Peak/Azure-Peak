import type { ReactNode } from 'react';

import { useBackend } from '../../backend';
import { compactButtonStyle, INK_SOFT, TITLE, TITLE_FONT } from './parchment';

export type StewardWindow = 'front' | 'trade' | 'treasury' | 'ledger';

const WINDOWS: { key: StewardWindow; label: string }[] = [
  { key: 'front', label: 'Nerve Master' },
  { key: 'trade', label: 'Trade' },
  { key: 'treasury', label: 'Treasury' },
  { key: 'ledger', label: 'Ledger' },
];

export const StewardHeader = (props: {
  title: string;
  current: StewardWindow;
  children?: ReactNode;
}) => {
  const { act } = useBackend();
  return (
    <div
      style={{
        display: 'flex',
        flexWrap: 'wrap',
        alignItems: 'baseline',
        justifyContent: 'space-between',
        gap: '4px 16px',
      }}
    >
      <div
        style={{
          fontFamily: TITLE_FONT,
          fontSize: '22px',
          fontWeight: 'bold',
          color: TITLE,
        }}
      >
        {props.title}
      </div>
      <div
        style={{
          display: 'flex',
          flexWrap: 'wrap',
          alignItems: 'baseline',
          gap: '2px 12px',
          color: INK_SOFT,
        }}
      >
        {props.children}
        {WINDOWS.filter((w) => w.key !== props.current).map((w) => (
          <button
            key={w.key}
            type="button"
            onClick={() => act('open_window', { window: w.key })}
            style={compactButtonStyle()}
          >
            {w.label}
          </button>
        ))}
      </div>
    </div>
  );
};
