import { useState } from 'react';

import {
  cardStyle,
  FONT_BODY,
  fieldRowStyle,
  INK,
  INK_SOFT,
  pageStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SERIF,
  subTabBarStyle,
  subTabStyle,
} from '../../common/parchment';
import type { ActFn, HarborData } from '../types';
import { RealmsView } from './RealmsView';
import { ShipsView } from './ShipsView';

type HarborSubTab = 'ships' | 'realms';

const BudgetPair = (props: { label: string; value: React.ReactNode }) => (
  <div
    style={{
      display: 'flex',
      alignItems: 'baseline',
      gap: '8px',
    }}
  >
    <span
      style={{
        fontFamily: SERIF,
        color: SEAL_AMBER,
        fontSize: FONT_BODY,
      }}
    >
      {props.label}
    </span>
    <span style={{ fontFamily: SERIF, fontSize: FONT_BODY, color: INK }}>
      {props.value}
    </span>
  </div>
);

const BudgetStrip = (props: { harbor: HarborData }) => {
  const { harbor } = props;
  return (
    <div
      style={{
        ...fieldRowStyle,
        display: 'flex',
        gap: '32px',
        justifyContent: 'flex-start',
      }}
    >
      <BudgetPair
        label="Hails Today"
        value={
          <>
            <b>{harbor.hails_remaining}</b> / {harbor.hails_per_day}
          </>
        }
      />
      <BudgetPair
        label="Pier Spots"
        value={
          <>
            <b>{harbor.dock_spots_used}</b> / {harbor.dock_spots_max}
          </>
        }
      />
    </div>
  );
};

export const HarborTab = (props: {
  harbor?: HarborData;
  budget: number;
  isAgent?: boolean;
  act: ActFn;
}) => {
  const { harbor, budget, isAgent, act } = props;
  const [tab, setTab] = useState<HarborSubTab>('ships');

  const agentBanner = isAgent ? (
    <div
      style={{
        margin: '6px 0 8px',
        padding: '6px 10px',
        border: `1px dashed ${SEAL_GREEN}`,
        color: INK,
        fontFamily: SERIF,
        fontSize: FONT_BODY,
        lineHeight: 1.4,
      }}
    >
      <span
        style={{
          color: SEAL_GREEN,
          fontWeight: 'bold',
          marginRight: '6px',
        }}
      >
        Chartered Agent
      </span>
      <span style={{ color: INK_SOFT }}>
        As an agent of the Azurian Trading Company, you are allowed to access,
        view, and purchase the Cultural Stock of any docked ships, and view and
        hail ships on behalf of the Factor.
      </span>
    </div>
  ) : null;

  if (!harbor) {
    return (
      <div style={pageStyle}>
        {agentBanner}
        <div
          style={{
            ...cardStyle,
            textAlign: 'center',
            color: INK_SOFT,
          }}
        >
          The harbor reports are not yet drawn up.
        </div>
      </div>
    );
  }

  return (
    <div style={pageStyle}>
      {agentBanner}
      <BudgetStrip harbor={harbor} />
      <div
        style={{
          margin: '4px 0 6px',
          fontFamily: SERIF,
          fontSize: FONT_BODY,
          color: INK_SOFT,
        }}
      >
        Tip: Ctrl+F in this window to find a good or realm quickly.
      </div>
      {harbor.kinship?.realm_name && (
        <div
          style={{
            margin: '6px 0 8px',
            padding: '6px 10px',
            border: `1px dashed ${SEAL_GREEN}`,
            color: INK,
            fontFamily: SERIF,
            fontSize: FONT_BODY,
            lineHeight: 1.4,
          }}
        >
          <span
            style={{
              color: SEAL_GREEN,
              fontWeight: 'bold',
              marginRight: '6px',
            }}
          >
            Kinship: {harbor.kinship.realm_name}
          </span>
          <span style={{ color: INK_SOFT }}>
            At least one ship from {harbor.kinship.realm_name} will sail per
            dae, sell {harbor.kinship.buy_pct}% cheaper, and pay{' '}
            {harbor.kinship.sell_pct}% more on bulk demand.
          </span>
        </div>
      )}
      {harbor.kinship?.agent_realm_name && (
        <div
          style={{
            margin: '6px 0 8px',
            padding: '6px 10px',
            border: `1px dashed ${SEAL_GREEN}`,
            color: INK,
            fontFamily: SERIF,
            fontSize: FONT_BODY,
            lineHeight: 1.4,
          }}
        >
          <span
            style={{
              color: SEAL_GREEN,
              fontWeight: 'bold',
              marginRight: '6px',
            }}
          >
            Agent Kinship: {harbor.kinship.agent_realm_name}
          </span>
          <span style={{ color: INK_SOFT }}>
            As an Agent, your buys from {harbor.kinship.agent_realm_name} ships
            cost {harbor.kinship.buy_pct}% less.
          </span>
        </div>
      )}
      <div style={subTabBarStyle}>
        <button
          type="button"
          style={subTabStyle(tab === 'ships')}
          onClick={() => setTab('ships')}
        >
          Ships
        </button>
        <button
          type="button"
          style={subTabStyle(tab === 'realms')}
          onClick={() => setTab('realms')}
        >
          Realms
        </button>
      </div>
      {tab === 'ships' && (
        <ShipsView
          docked={harbor.ships_docked}
          pool={harbor.ships_pool}
          dockSpotsUsed={harbor.dock_spots_used}
          dockSpotsMax={harbor.dock_spots_max}
          hailsRemaining={harbor.hails_remaining}
          budget={budget}
          act={act}
          realms={harbor.realms}
        />
      )}
      {tab === 'realms' && <RealmsView realms={harbor.realms} />}
    </div>
  );
};
