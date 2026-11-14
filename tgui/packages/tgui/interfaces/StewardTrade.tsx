import { useEffect, useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  FONT_BODY,
  INK_FAINT,
  pageStyle,
  rulerStyle,
  SEAL_AMBER,
  subtitleStyle,
  titleStyle,
} from './common/parchment';
import { ArrearsBanner } from './StewardTrade/ArrearsBanner';
import { ATCLoanBanner } from './StewardTrade/ATCLoanBanner';
import { BanditryBanner } from './StewardTrade/BanditryBanner';
import { BlockadeBanner } from './StewardTrade/BlockadeBanner';
import { EventsBanner } from './StewardTrade/EventsBanner';
import { LedgerView } from './StewardTrade/LedgerView';
import { MarketView } from './StewardTrade/MarketView';
import { OrdersView } from './StewardTrade/OrdersView';
import { PetitionView } from './StewardTrade/PetitionView';
import { RegionsView } from './StewardTrade/RegionsView';
import { SequesteredOverlay } from './StewardTrade/SequesteredOverlay';
import { SequestrationBanner } from './StewardTrade/SequestrationBanner';
import { TabBar } from './StewardTrade/TabBar';
import type { Data, TabKey } from './StewardTrade/types';
import { formatMammon } from './common/format';

export const StewardTrade = () => {
  const { data, act } = useBackend<Data>();
  const [tab, setTab] = useState<TabKey>('orders');

  useEffect(() => {
    if (tab === 'ledger') {
      act('ledger_open');
      return () => act('ledger_close');
    }
  }, [tab, act]);

  return (
    <Window title="Market Scroll" width={860} height={820} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>Market & Stockpile</div>
          <div style={subtitleStyle}>
            Day {data.day} &middot; Treasury:{' '}
            <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
              {formatMammon(data.treasury)}m
            </span>
          </div>
          <div
            style={{
              ...subtitleStyle,
              color: INK_FAINT,
              fontSize: FONT_BODY,
              marginTop: '2px',
            }}
          >
            At dawn:{' '}
            <span style={{ color: SEAL_AMBER }}>
              +{formatMammon(data.expected_rural_revenue)}m
            </span>{' '}
            <span
              style={{ cursor: 'help' }}
              title="A modest stipend from the countryside manors, sent while the Steward's own hand is thin on the ground. It dwindles as the guilds and artisans fill their benches - once enough hands are at the forge, the loom, and the apothecary's counter to sustain trade themselves, the lands keep what they raise."
            >
              rural subsidy
            </span>{' '}
            &middot;{' '}
            <span style={{ color: SEAL_AMBER }}>
              -{formatMammon(data.expected_wage_outlay)}m
            </span>{' '}
            wages &middot; Net{' '}
            <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
              {data.expected_rural_revenue - data.expected_wage_outlay >= 0
                ? '+'
                : ''}
              {formatMammon(data.expected_rural_revenue - data.expected_wage_outlay)}m
            </span>
          </div>
          <hr style={rulerStyle} />

          <SequestrationBanner sequestration={data.sequestration} />
          <ArrearsBanner sequestration={data.sequestration} />
          <ATCLoanBanner atc_loan={data.atc_loan} />
          <BlockadeBanner regions={data.blockaded_regions} />
          <BanditryBanner projection={data.banditry_projection} />
          <EventsBanner
            events={data.active_events}
            goodCatalog={data.good_catalog}
          />

          <TabBar tab={tab} onSwitch={setTab} />
          <hr style={rulerStyle} />

          {tab === 'orders' && <OrdersView data={data} />}
          {tab === 'market' && (
            <SequesteredOverlay
              active={!!data.sequestration?.active}
              label="Market & Stockpile"
            >
              <MarketView data={data} />
            </SequesteredOverlay>
          )}
          {tab === 'regions' && <RegionsView data={data} />}
          {tab === 'petition' && <PetitionView data={data} />}
          {tab === 'ledger' && <LedgerView data={data} />}
        </div>
      </Window.Content>
    </Window>
  );
};
