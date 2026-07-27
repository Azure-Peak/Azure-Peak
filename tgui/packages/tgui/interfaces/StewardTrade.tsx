import { useEffect, useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  FONT_BODY,
  INK,
  INK_FAINT,
  pageStyle,
  rulerStyle,
  SEAL_AMBER,
  subtitleStyle,
  titleStyle,
} from './common/parchment';
import { ArrearsBanner } from './StewardTrade/ArrearsBanner';
import { ATCLoanBanner } from './StewardTrade/ATCLoanBanner';
import { AutoImportView } from './StewardTrade/AutoImportView';
import { BanditryBanner } from './StewardTrade/BanditryBanner';
import { BlockadeBanner } from './StewardTrade/BlockadeBanner';
import { EventsBanner } from './StewardTrade/EventsBanner';
import { LedgerView } from './StewardTrade/LedgerView';
import { MarketView } from './StewardTrade/MarketView';
import { OrdersView } from './StewardTrade/OrdersView';
import { PetitionView } from './StewardTrade/PetitionView';
import { RegionsView } from './StewardTrade/RegionsView';
import { RoyalCustomPanel } from './StewardTrade/RoyalCustomPanel';
import { SequesteredOverlay } from './StewardTrade/SequesteredOverlay';
import { SequestrationBanner } from './StewardTrade/SequestrationBanner';
import { TabBar } from './StewardTrade/TabBar';
import { TradeModal, type TradeModalRequest } from './StewardTrade/TradeModal';
import type { Data, TabKey } from './StewardTrade/types';

export const StewardTrade = () => {
  const { data, act } = useBackend<Data>();
  const [tab, setTab] = useState<TabKey>('orders');
  const [tradeRequest, setTradeRequest] = useState<TradeModalRequest | null>(
    null,
  );

  useEffect(() => {
    if (tab === 'ledger') {
      act('ledger_open');
      return () => act('ledger_close');
    }
  }, [tab, act]);

  const aldermanActing = !!data.is_alderman_acting;
  const warrant = data.alderman_warrant;

  return (
    <Window title="Market Scroll" width={860} height={820} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>Market & Stockpile</div>
          <div style={subtitleStyle}>
            Day {data.day} &middot; Crown's Purse:{' '}
            <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
              {data.treasury}m
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
              +{data.expected_rural_revenue}m
            </span>{' '}
            rural tax &middot;{' '}
            <span style={{ color: SEAL_AMBER }}>
              -{data.expected_wage_outlay}m
            </span>{' '}
            wages &middot; Net{' '}
            <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
              {data.expected_rural_revenue - data.expected_wage_outlay >= 0
                ? '+'
                : ''}
              {data.expected_rural_revenue - data.expected_wage_outlay}m
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
                fontSize: FONT_BODY,
                color: INK,
              }}
            >
              <div
                style={{
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
              <div style={{ color: INK_FAINT, fontSize: FONT_BODY }}>
                Trades beyond the warrant are refused. Crown&apos;s Purse still
                pays the coin.
              </div>
            </div>
          )}

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
              <MarketView data={data} onTrade={setTradeRequest} />
            </SequesteredOverlay>
          )}
          {tab === 'regions' && (
            <SequesteredOverlay
              active={!!data.sequestration?.active}
              label="Inter-Regional Trade"
            >
              <RegionsView data={data} />
            </SequesteredOverlay>
          )}
          {tab === 'auto_import' && (
            <SequesteredOverlay
              active={!!data.sequestration?.active}
              label="Imports"
            >
              <AutoImportView data={data} />
            </SequesteredOverlay>
          )}
          {tab === 'petition' && <PetitionView data={data} />}
          {tab === 'ledger' && <LedgerView data={data} />}
          {tab === 'royal_custom' && <RoyalCustomPanel />}
        </div>
        <TradeModal
          request={tradeRequest}
          onClose={() => setTradeRequest(null)}
        />
      </Window.Content>
    </Window>
  );
};
