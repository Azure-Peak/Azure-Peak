import {
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  SERIF,
} from '../common/parchment';
import type { TabKey } from './types';

const tabBarStyle = {
  display: 'flex',
  flexWrap: 'wrap' as const,
  gap: '4px',
  margin: '8px 0 4px 0',
};

const tabStyle = (active: boolean) => ({
  fontFamily: SERIF,
  fontSize: FONT_BODY,
  padding: '2px 8px',
  color: active ? INK : INK_FAINT,
  background: active ? 'rgba(200,170,100,0.25)' : 'transparent',
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
      <div
        style={tabStyle(tab === 'orders')}
        onClick={() => onSwitch('orders')}
      >
        Standing Orders
      </div>
      <div
        style={tabStyle(tab === 'market')}
        onClick={() => onSwitch('market')}
      >
        Market
      </div>
      <div
        style={tabStyle(tab === 'regions')}
        onClick={() => onSwitch('regions')}
      >
        Regions
      </div>
      <div
        style={tabStyle(tab === 'auto_import')}
        onClick={() => onSwitch('auto_import')}
      >
        Imports
      </div>
      <div
        style={tabStyle(tab === 'petition')}
        onClick={() => onSwitch('petition')}
      >
        Petition
      </div>
      <div
        style={tabStyle(tab === 'ledger')}
        onClick={() => onSwitch('ledger')}
      >
        Ledger
      </div>
      <div
        style={tabStyle(tab === 'royal_custom')}
        onClick={() => onSwitch('royal_custom')}
      >
        Royal Custom
      </div>
    </div>
  );
};
