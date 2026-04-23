import { useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { BanditryBanner } from './StewardTrade/BanditryBanner';
import { BlockadeBanner } from './StewardTrade/BlockadeBanner';
import { EventsBanner } from './StewardTrade/EventsBanner';
import { MarketView } from './StewardTrade/MarketView';
import { OrdersView } from './StewardTrade/OrdersView';
import { RegionsView } from './StewardTrade/RegionsView';
import {
  pageStyle,
  rulerStyle,
  SEAL_AMBER,
  subtitleStyle,
  titleStyle,
} from './StewardTrade/styles';
import { TabBar } from './StewardTrade/TabBar';
import type { Data, TabKey } from './StewardTrade/types';

export const StewardTrade = () => {
  const { data } = useBackend<Data>();
  const [tab, setTab] = useState<TabKey>('orders');

  return (
    <Window title="Steward's Trade Scroll" width={860} height={820}>
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>Regions in Trade</div>
          <div style={subtitleStyle}>
            Day {data.day} &middot; Crown's Purse:{' '}
            <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
              {data.treasury}m
            </span>
          </div>
          <hr style={rulerStyle} />

          <BlockadeBanner regions={data.blockaded_regions} />
          <BanditryBanner projection={data.banditry_projection} />
          <EventsBanner events={data.active_events} />

          <TabBar tab={tab} onSwitch={setTab} />
          <hr style={rulerStyle} />

          {tab === 'orders' && <OrdersView data={data} />}
          {tab === 'market' && <MarketView data={data} />}
          {tab === 'regions' && <RegionsView data={data} />}
        </div>
      </Window.Content>
    </Window>
  );
};
