import { useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { tabBarStyle, tabStyle } from './common/parchment';
import { HarborTab } from './Goldface/Harbor/HarborTab';
import type { VendingData } from './Goldface/types';
import { VendingPanel } from './Goldface/VendingPanel';

type GoldfaceTab = 'goods' | 'harbor';

export const Goldface = () => {
  const { act, data } = useBackend<VendingData>();
  const [tab, setTab] = useState<GoldfaceTab>('goods');
  const isCommand = !!data.is_command_center;

  if (!isCommand) {
    return (
      <Window width={720} height={800} theme="parchment">
        <Window.Content scrollable>
          <VendingPanel data={data} act={act} />
        </Window.Content>
      </Window>
    );
  }

  const canSeeHarbor = !!data.is_proprietor;
  const activeTab = tab === 'harbor' && !canSeeHarbor ? 'goods' : tab;

  return (
    <Window width={720} height={800} theme="parchment">
      <Window.Content scrollable>
        <div style={tabBarStyle}>
          <div
            style={tabStyle(activeTab === 'goods')}
            onClick={() => setTab('goods')}
          >
            Goods
          </div>
          {canSeeHarbor && (
            <div
              style={tabStyle(activeTab === 'harbor')}
              onClick={() => setTab('harbor')}
            >
              Harbor
            </div>
          )}
        </div>
        {activeTab === 'goods' && <VendingPanel data={data} act={act} />}
        {activeTab === 'harbor' && canSeeHarbor && (
          <HarborTab harbor={data.harbor} />
        )}
      </Window.Content>
    </Window>
  );
};
