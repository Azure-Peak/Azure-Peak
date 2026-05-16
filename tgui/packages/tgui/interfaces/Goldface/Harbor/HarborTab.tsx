import { useState } from 'react';

import {
  cardStyle,
  fieldRowStyle,
  INK,
  INK_SOFT,
  pageStyle,
  SEAL_AMBER,
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
        fontVariant: 'small-caps',
        color: SEAL_AMBER,
        fontStyle: 'italic',
        fontSize: '11px',
      }}
    >
      {props.label}
    </span>
    <span style={{ fontFamily: SERIF, fontSize: '13px', color: INK }}>
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
  act: ActFn;
}) => {
  const { harbor, budget, act } = props;
  const [tab, setTab] = useState<HarborSubTab>('ships');

  if (!harbor) {
    return (
      <div style={pageStyle}>
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
      <BudgetStrip harbor={harbor} />
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
        />
      )}
      {tab === 'realms' && <RealmsView realms={harbor.realms} />}
    </div>
  );
};
