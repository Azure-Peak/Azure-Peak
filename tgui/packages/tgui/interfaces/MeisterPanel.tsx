import { useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  pageStyle,
  rulerStyle,
  SEAL_AMBER,
  subtitleStyle,
  tabBarStyle,
  tabStyle,
  titleStyle,
} from './common/parchment';
import { InstitutionalTab } from './MeisterPanel/InstitutionalTab';
import { LedgerTab } from './MeisterPanel/LedgerTab';
import { PatronageTab } from './MeisterPanel/PatronageTab';
import { PersonalTab } from './MeisterPanel/PersonalTab';
import { PollTaxTab } from './MeisterPanel/PollTaxTab';
import type { Data, TabKey } from './MeisterPanel/types';

export const MeisterPanel = () => {
  const { data, act } = useBackend<Data>();
  const [tab, setTab] = useState<TabKey>('personal');

  const accessibleInstitutional = data.funds.some(
    (f) => f.can_issue || f.can_withdraw || f.can_view,
  );
  const accessiblePatronage = data.funds.some(
    (f) => f.has_patronage && data.patron_rosters_static[f.id]?.can_manage,
  );

  return (
    <Window title="Meister" width={620} height={620} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>The Meister</div>
          <div style={subtitleStyle}>
            Day {data.day} &middot; Personal balance:{' '}
            <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
              {data.account_balance}m
            </span>
          </div>
          <hr style={rulerStyle} />

          <div style={tabBarStyle}>
            <div
              style={tabStyle(tab === 'personal')}
              onClick={() => setTab('personal')}
            >
              Personal
            </div>
            {accessibleInstitutional && (
              <div
                style={tabStyle(tab === 'institutional')}
                onClick={() => setTab('institutional')}
              >
                Institutional
              </div>
            )}
            {accessiblePatronage && (
              <div
                style={tabStyle(tab === 'patronage')}
                onClick={() => setTab('patronage')}
              >
                Patronage
              </div>
            )}
            <div
              style={tabStyle(tab === 'polltax')}
              onClick={() => setTab('polltax')}
            >
              Poll Tax
            </div>
            <div
              style={tabStyle(tab === 'ledger')}
              onClick={() => setTab('ledger')}
            >
              Ledger
            </div>
          </div>

          {tab === 'personal' && <PersonalTab data={data} act={act} />}
          {tab === 'institutional' && accessibleInstitutional && (
            <InstitutionalTab data={data} act={act} />
          )}
          {tab === 'patronage' && accessiblePatronage && (
            <PatronageTab data={data} act={act} />
          )}
          {tab === 'polltax' && <PollTaxTab data={data} act={act} />}
          {tab === 'ledger' && <LedgerTab data={data} act={act} />}
        </div>
      </Window.Content>
    </Window>
  );
};
