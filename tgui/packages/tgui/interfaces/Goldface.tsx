import { useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { tabBarStyle, tabStyle } from './common/parchment';
import { CulturalStockTab } from './Goldface/CulturalStock/CulturalStockTab';
import { HarborTab } from './Goldface/Harbor/HarborTab';
import { MammonRow } from './Goldface/MammonRow';
import type { VendingData } from './Goldface/types';
import { VendingPanel } from './Goldface/VendingPanel';

type GoldfaceTab = 'goods' | 'cultural' | 'harbor';

export const Goldface = () => {
  const { act, data } = useBackend<VendingData>();
  const [tab, setTab] = useState<GoldfaceTab>('goods');
  const isCommand = !!data.is_command_center;
  const canRead = !!data.can_read;
  const isPublic = !!data.is_public;
  const isProprietor = !!data.is_proprietor;

  const mammonBar = (
    <div style={{ padding: '6px 28px 0 28px' }}>
      <MammonRow
        budget={data.budget}
        canRead={canRead}
        isProprietor={isProprietor}
        isPublic={isPublic}
        act={act}
      />
    </div>
  );

  if (!isCommand) {
    return (
      <Window width={720} height={800} theme="parchment">
        <Window.Content scrollable>
          {mammonBar}
          <VendingPanel data={data} act={act} />
        </Window.Content>
      </Window>
    );
  }

  const canSeeMerchantTabs = isProprietor;
  const culturalStock = data.harbor?.cultural_stock ?? [];
  let activeTab = tab;
  if (
    (activeTab === 'harbor' || activeTab === 'cultural') &&
    !canSeeMerchantTabs
  )
    activeTab = 'goods';

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
          {canSeeMerchantTabs && (
            <div
              style={tabStyle(activeTab === 'cultural')}
              onClick={() => setTab('cultural')}
            >
              Cultural Stock
            </div>
          )}
          {canSeeMerchantTabs && (
            <div
              style={tabStyle(activeTab === 'harbor')}
              onClick={() => setTab('harbor')}
            >
              Harbor
            </div>
          )}
        </div>
        {mammonBar}
        {activeTab === 'goods' && <VendingPanel data={data} act={act} />}
        {activeTab === 'cultural' && canSeeMerchantTabs && (
          <CulturalStockTab
            stock={culturalStock}
            budget={data.budget}
            act={act}
          />
        )}
        {activeTab === 'harbor' && canSeeMerchantTabs && (
          <HarborTab harbor={data.harbor} budget={data.budget} act={act} />
        )}
      </Window.Content>
    </Window>
  );
};
