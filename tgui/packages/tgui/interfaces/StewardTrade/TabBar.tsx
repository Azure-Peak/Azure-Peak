import type { TabKey } from './types';
import { tabBarStyle, tabStyle } from './styles';

export const TabBar = (props: {
  tab: TabKey;
  onSwitch: (t: TabKey) => void;
}) => {
  const { tab, onSwitch } = props;
  return (
    <div style={tabBarStyle}>
      <div style={tabStyle(tab === 'orders')} onClick={() => onSwitch('orders')}>
        Standing Orders
      </div>
      <div style={tabStyle(tab === 'market')} onClick={() => onSwitch('market')}>
        Market
      </div>
      <div style={tabStyle(tab === 'regions')} onClick={() => onSwitch('regions')}>
        Regions
      </div>
    </div>
  );
};
