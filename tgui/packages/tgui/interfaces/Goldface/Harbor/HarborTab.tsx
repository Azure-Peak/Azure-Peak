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
import { NationsView } from './NationsView';
import { ShipsView } from './ShipsView';

type HarborSubTab = 'ships' | 'nations';

const BudgetStrip = (props: { harbor: HarborData }) => {
  const { harbor } = props;
  return (
    <div style={fieldRowStyle}>
      <div
        style={{
          flex: 1,
          fontFamily: SERIF,
          fontVariant: 'small-caps',
          letterSpacing: '2px',
          color: SEAL_AMBER,
          fontStyle: 'italic',
          fontSize: '11px',
        }}
      >
        Hails Today
      </div>
      <div
        style={{
          flex: '0 0 auto',
          fontFamily: SERIF,
          fontSize: '13px',
          color: INK,
          marginRight: '20px',
        }}
      >
        <b>{harbor.hails_remaining}</b> / {harbor.hails_per_day}
      </div>
      <div
        style={{
          flex: 1,
          fontFamily: SERIF,
          fontVariant: 'small-caps',
          letterSpacing: '2px',
          color: SEAL_AMBER,
          fontStyle: 'italic',
          fontSize: '11px',
        }}
      >
        Pier Spots
      </div>
      <div
        style={{
          flex: '0 0 auto',
          fontFamily: SERIF,
          fontSize: '13px',
          color: INK,
        }}
      >
        <b>{harbor.dock_spots_used}</b> / {harbor.dock_spots_max}
      </div>
    </div>
  );
};

export const HarborTab = (props: { harbor?: HarborData; act: ActFn }) => {
  const { harbor, act } = props;
  const [tab, setTab] = useState<HarborSubTab>('ships');

  if (!harbor) {
    return (
      <div style={pageStyle}>
        <div
          style={{
            ...cardStyle,
            textAlign: 'center',
            fontStyle: 'italic',
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
          style={subTabStyle(tab === 'nations')}
          onClick={() => setTab('nations')}
        >
          Nations
        </button>
      </div>
      {tab === 'ships' && (
        <ShipsView
          docked={harbor.ships_docked}
          pool={harbor.ships_pool}
          dockSpotsUsed={harbor.dock_spots_used}
          dockSpotsMax={harbor.dock_spots_max}
          hailsRemaining={harbor.hails_remaining}
          act={act}
        />
      )}
      {tab === 'nations' && <NationsView nations={harbor.nations} />}
    </div>
  );
};
