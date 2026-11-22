import { useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { formatMammon } from './common/format';
import { pageStyle, SEAL_AMBER } from './common/parchment';
import { StewardHeader } from './common/StewardHeader';
import { ArrearsBanner } from './StewardTrade/ArrearsBanner';
import { CaravansView } from './StewardTrade/CaravansView';
import { CommissionsView } from './StewardTrade/CommissionsView';
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
          </StewardHeader>

          <SequestrationBanner sequestration={data.sequestration} />
          <ArrearsBanner sequestration={data.sequestration} />

          <TabBar tab={tab} onSwitch={setTab} />

          {tab === 'caravans' && <CaravansView data={data} />}
          {tab === 'commissions' && <CommissionsView data={data} />}
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
