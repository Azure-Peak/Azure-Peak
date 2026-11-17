import {
  FONT_BODY,
  FONT_SMALL,
  INK,
  INK_FAINT,
  INK_SOFT,
  SEAL_RED,
  SERIF,
} from '../common/parchment';
import type { TabKey } from './types';

const TABS: { key: TabKey; label: string }[] = [
  { key: 'caravans', label: 'Caravans' },
  { key: 'dispatches', label: 'Dispatches' },
  { key: 'market', label: 'Market' },
  { key: 'ledger', label: 'Ledger' },
  { key: 'regions', label: 'Regions' },
  { key: 'petition', label: 'Petition' },
];

const tabBarStyle = {
  display: 'flex',
  flexWrap: 'wrap' as const,
  gap: '4px',
  margin: '8px 0 0 0',
  paddingBottom: '6px',
  borderBottom: `1px solid ${INK_FAINT}`,
};

const tabStyle = (active: boolean) => ({
  display: 'inline-flex',
  alignItems: 'center',
  gap: '6px',
  fontFamily: SERIF,
  fontSize: FONT_BODY,
  padding: '2px 10px',
  color: active ? INK : INK_FAINT,
  background: active ? 'var(--p-tab-active-bg)' : 'transparent',
  border: `1px solid ${active ? INK_SOFT : 'transparent'}`,
  borderRadius: '2px',
  cursor: 'pointer',
  fontWeight: active ? ('bold' as const) : ('normal' as const),
  whiteSpace: 'nowrap' as const,
});

const badgeStyle = {
  display: 'inline-block',
  minWidth: '16px',
  padding: '0 4px',
  fontSize: FONT_SMALL,
  fontWeight: 'bold' as const,
  lineHeight: '16px',
  textAlign: 'center' as const,
  color: 'var(--p-badge-text)',
  background: SEAL_RED,
  borderRadius: '8px',
};

export const TabBar = (props: {
  tab: TabKey;
  onSwitch: (t: TabKey) => void;
  dispatchCount: number;
}) => {
  const { tab, onSwitch, dispatchCount } = props;
  return (
    <div style={tabBarStyle}>
      {TABS.map((t) => (
        <div
          key={t.key}
          style={tabStyle(tab === t.key)}
          onClick={() => onSwitch(t.key)}
        >
          {t.label}
          {t.key === 'dispatches' && dispatchCount > 0 && (
            <span style={badgeStyle}>{dispatchCount}</span>
          )}
        </div>
      ))}
    </div>
  );
};
