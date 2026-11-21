import { useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { formatMammon } from './common/format';
import { pageStyle, SEAL_AMBER } from './common/parchment';
import { StewardHeader } from './common/StewardHeader';
import { ArrearsBanner } from './StewardTrade/ArrearsBanner';
import { CaravansView } from './StewardTrade/CaravansView';
import { CommissionsView } from './StewardTrade/CommissionsView';
import { dispatchCount, DispatchesView } from './StewardTrade/DispatchesView';
import { MarketView } from './StewardTrade/MarketView';
import { PetitionView } from './StewardTrade/PetitionView';
import { RegionsView } from './StewardTrade/RegionsView';
import { SequesteredOverlay } from './StewardTrade/SequesteredOverlay';
import { SequestrationBanner } from './StewardTrade/SequestrationBanner';
import { TabBar } from './StewardTrade/TabBar';
import type { Data, TabKey } from './StewardTrade/types';

export const StewardTrade = () => {
  const { data } = useBackend<Data>();
  const [tab, setTab] = useState<TabKey>('caravans');

  const net = data.expected_rural_revenue - data.expected_wage_outlay;

  return (
    <Window title="Market Scroll" width={860} height={820} theme="parchment">
      <Window.Content scrollable>
        <div style={{ ...pageStyle, padding: '12px 20px 16px 20px' }}>
          <StewardHeader title="Market & Stockpile" current="trade">
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
          </StewardHeader>

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
        </div>
      </Window.Content>
    </Window>
  );
};
