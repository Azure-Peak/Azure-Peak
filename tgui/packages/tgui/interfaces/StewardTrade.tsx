import { useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { AutoImportView } from './StewardTrade/AutoImportView';
import { BanditryBanner } from './StewardTrade/BanditryBanner';
import { BlockadeBanner } from './StewardTrade/BlockadeBanner';
import { EventsBanner } from './StewardTrade/EventsBanner';
import { MarketView } from './StewardTrade/MarketView';
import { OrdersView } from './StewardTrade/OrdersView';
import { RegionsView } from './StewardTrade/RegionsView';
import {
  INK,
  INK_FAINT,
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

  const aldermanActing = !!data.is_alderman_acting;
  const warrant = data.alderman_warrant;

  return (
    <Window
      title="Steward's Trade Scroll"
      width={860}
      height={820}
      theme="parchment"
    >
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

          {aldermanActing && warrant && (
            <div
              style={{
                background: 'rgba(200,170,100,0.18)',
                border: `1px solid ${SEAL_AMBER}`,
                padding: '6px 12px',
                marginBottom: '10px',
                fontSize: '12px',
                color: INK,
              }}
            >
              <div
                style={{
                  fontVariant: 'small-caps',
                  letterSpacing: '2px',
                  color: SEAL_AMBER,
                  fontWeight: 'bold',
                  marginBottom: '2px',
                }}
              >
                Alderman&apos;s Writ
              </div>
              <div>
                Trade warrant:{' '}
                <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
                  {warrant.trade_remaining}m
                </span>{' '}
                of {warrant.trade_cap}m remaining today
              </div>
              <div style={{ color: INK_FAINT, fontSize: '11px', fontStyle: 'italic' }}>
                Trades beyond the warrant are refused. Crown&apos;s Purse still pays the coin.
              </div>
            </div>
          )}

          <BlockadeBanner regions={data.blockaded_regions} />
          <BanditryBanner projection={data.banditry_projection} />
          <EventsBanner events={data.active_events} />

          <TabBar tab={tab} onSwitch={setTab} />
          <hr style={rulerStyle} />

          {tab === 'orders' && <OrdersView data={data} />}
          {tab === 'market' && <MarketView data={data} />}
          {tab === 'regions' && <RegionsView data={data} />}
          {tab === 'auto_import' && <AutoImportView data={data} />}
        </div>
      </Window.Content>
    </Window>
  );
};
