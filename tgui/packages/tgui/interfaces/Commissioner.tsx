import { useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { BrowseTab } from './Commissioner/BrowseTab';
import { ConfigPanel } from './Commissioner/ConfigPanel';
import { ManifestTab } from './Commissioner/ManifestTab';
import { OrdersTab } from './Commissioner/OrdersTab';
import type { CommissionerData } from './Commissioner/types';
import {
  FONT_BODY,
  INK,
  INK_SOFT,
  pageStyle,
  rulerStyle,
  SEAL_AMBER,
  SERIF,
  subtitleStyle,
  tabBarStyle,
  tabStyle,
  titleStyle,
} from './common/parchment';

type CommissionerTab = 'browse' | 'manifest' | 'orders' | 'config';

export const Commissioner = () => {
  const { act, data } = useBackend<CommissionerData>();
  const [tab, setTab] = useState<CommissionerTab>('browse');
  const canRead = !!data.can_read;
  const isGuildmaster = !!data.is_guildmaster;
  const manifestCount = data.manifest.length;
  const orderCount = data.orders.length;

  let activeTab = tab;
  if (activeTab === 'config' && !isGuildmaster) activeTab = 'browse';

  return (
    <Window width={880} height={720} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>The Commissioner</div>
          <div style={subtitleStyle}>
            Commission goods from guild smiths and tailors. Orders are backed by your MEISTER account.
          </div>
          <div style={rulerStyle} />

          <div
            style={{
              display: 'flex',
              alignItems: 'baseline',
              gap: '24px',
              marginBottom: '8px',
              fontFamily: SERIF,
            }}
          >
            <span style={{ color: SEAL_AMBER }}>Escrow held</span>
            <span style={{ color: INK, fontWeight: 'bold', marginRight: 12 }}>
              {data.budget}m
            </span>
            <span style={{ color: SEAL_AMBER }}>Your balance</span>
            <span style={{ color: INK, fontWeight: 'bold' }}>
              {data.has_account ? `${data.my_balance}m` : '-'}
            </span>
            {!data.has_account && (
              <span
                style={{
                  marginLeft: 'auto',
                  fontSize: FONT_BODY,
                  color: INK_SOFT,
                }}
              >
                You have no MEISTER account
              </span>
            )}
          </div>

          <div style={tabBarStyle}>
            <div
              style={tabStyle(activeTab === 'browse')}
              onClick={() => setTab('browse')}
            >
              Browse
            </div>
            <div
              style={tabStyle(activeTab === 'manifest')}
              onClick={() => setTab('manifest')}
            >
              Manifest {manifestCount > 0 && `(${manifestCount})`}
            </div>
            <div
              style={tabStyle(activeTab === 'orders')}
              onClick={() => setTab('orders')}
            >
              Orders {orderCount > 0 && `(${orderCount})`}
            </div>
            {isGuildmaster && (
              <div
                style={tabStyle(activeTab === 'config')}
                onClick={() => setTab('config')}
              >
                Guildmaster
              </div>
            )}
          </div>

          {activeTab === 'browse' && (
            <BrowseTab data={data} act={act} canRead={canRead} />
          )}
          {activeTab === 'manifest' && (
            <ManifestTab data={data} act={act} canRead={canRead} />
          )}
          {activeTab === 'orders' && (
            <OrdersTab data={data} act={act} canRead={canRead} />
          )}
          {activeTab === 'config' && isGuildmaster && (
            <ConfigPanel data={data} act={act} />
          )}
        </div>
      </Window.Content>
    </Window>
  );
};
