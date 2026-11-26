import { FONT_BODY, INK, INK_FAINT, INK_SOFT, SERIF } from '../common/parchment';
import type { TabKey } from './types';

const TABS: { key: TabKey; label: string }[] = [
  { key: 'caravans', label: 'Caravans' },
  { key: 'commissions', label: 'Commission' },
  { key: 'market', label: 'Market' },
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

export const TabBar = (props: {
  tab: TabKey;
  onSwitch: (t: TabKey) => void;
}) => {
  const { tab, onSwitch } = props;
  return (
    <div style={tabBarStyle}>
      {TABS.map((t) => (
        <div
          key={t.key}
          style={tabStyle(tab === t.key)}
          onClick={() => onSwitch(t.key)}
        >
          {t.label}
        </div>
      ))}
    </div>
  );
};
