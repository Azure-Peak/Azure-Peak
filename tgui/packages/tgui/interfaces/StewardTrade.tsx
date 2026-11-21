import { useEffect, useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { formatMammon } from './common/format';
import {
  compactButtonStyle,
  INK_SOFT,
  pageStyle,
  SEAL_AMBER,
  TITLE,
  TITLE_FONT,
} from './common/parchment';
import { ArrearsBanner } from './StewardTrade/ArrearsBanner';
import { CaravansView } from './StewardTrade/CaravansView';
import { CommissionsView } from './StewardTrade/CommissionsView';
import { dispatchCount, DispatchesView } from './StewardTrade/DispatchesView';
import { LedgerView } from './StewardTrade/LedgerView';
import { MarketView } from './StewardTrade/MarketView';
import { PetitionView } from './StewardTrade/PetitionView';
import { RegionsView } from './StewardTrade/RegionsView';
import { SequesteredOverlay } from './StewardTrade/SequesteredOverlay';
import { SequestrationBanner } from './StewardTrade/SequestrationBanner';
import { TabBar } from './StewardTrade/TabBar';
import type { Data, TabKey } from './StewardTrade/types';

export const StewardTrade = () => {
  const { data, act } = useBackend<Data>();
  const [tab, setTab] = useState<TabKey>('caravans');

  useEffect(() => {
    if (tab === 'ledger') {
      act('ledger_open');
      return () => act('ledger_close');
    }
  }, [tab, act]);

  const net = data.expected_rural_revenue - data.expected_wage_outlay;

  return (
    <Window title="Market Scroll" width={860} height={820} theme="parchment">
      <Window.Content scrollable>
        <div style={{ ...pageStyle, padding: '12px 20px 16px 20px' }}>
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
              Market & Stockpile
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
              <span>Day {data.day}</span>
              <span>
                Treasury:{' '}
                <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
                  {formatMammon(data.treasury)}m
                </span>
              </span>
              <span>
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
                  {net >= 0 ? '+' : ''}
                  {formatMammon(net)}m
                </span>
              </span>
              <button
                type="button"
                onClick={() => act('open_treasury')}
                style={compactButtonStyle()}
              >
                Treasury
              </button>
            </div>
          </div>

          <SequestrationBanner sequestration={data.sequestration} />
          <ArrearsBanner sequestration={data.sequestration} />

          <TabBar
            tab={tab}
            onSwitch={setTab}
            dispatchCount={dispatchCount(data)}
          />

          {tab === 'caravans' && <CaravansView data={data} />}
          {tab === 'commissions' && <CommissionsView data={data} />}
          {tab === 'dispatches' && <DispatchesView data={data} />}
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
