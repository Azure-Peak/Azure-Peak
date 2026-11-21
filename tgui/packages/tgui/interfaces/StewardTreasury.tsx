import { useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { formatMammon } from './common/format';
import {
  compactButtonStyle,
  INK_SOFT,
  pageStyle,
  SEAL_AMBER,
  tabBarStyle,
  tabStyle,
  TITLE,
  TITLE_FONT,
} from './common/parchment';
import { AccountsView } from './StewardTreasury/AccountsView';
import { DebtsView } from './StewardTreasury/DebtsView';
import { PayrollView } from './StewardTreasury/PayrollView';
import { type Data, payrollTotal, type TabKey } from './StewardTreasury/types';

const TABS: { key: TabKey; label: string }[] = [
  { key: 'accounts', label: 'Accounts' },
  { key: 'payroll', label: 'Payroll' },
  { key: 'debts', label: 'Debts' },
];

export const StewardTreasury = () => {
  const { data, act } = useBackend<Data>();
  const [tab, setTab] = useState<TabKey>('accounts');

  return (
    <Window title="Treasury" width={760} height={720} theme="parchment">
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
              Treasury
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
              <span>
                Treasury:{' '}
                <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
                  {formatMammon(data.treasury)}m
                </span>
              </span>
              <span>
                Payroll:{' '}
                <span style={{ color: SEAL_AMBER }}>
                  {formatMammon(payrollTotal(data))}m
                </span>{' '}
                a dae
              </span>
              <button
                type="button"
                onClick={() => act('open_trade')}
                style={compactButtonStyle()}
              >
                Trade
              </button>
            </div>
          </div>

          <div style={tabBarStyle}>
            {TABS.map((t) => (
              <div
                key={t.key}
                style={tabStyle(tab === t.key)}
                onClick={() => setTab(t.key)}
              >
                {t.label}
                {t.key === 'debts' && data.debts.length > 0
                  ? ` (${data.debts.length})`
                  : ''}
              </div>
            ))}
          </div>

          {tab === 'accounts' && <AccountsView data={data} />}
          {tab === 'payroll' && <PayrollView data={data} />}
          {tab === 'debts' && <DebtsView data={data} />}
        </div>
      </Window.Content>
    </Window>
  );
};
