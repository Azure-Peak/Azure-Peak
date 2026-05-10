import { useState } from 'react';

import {
  cardStyle,
  INK_SOFT,
  pageStyle,
  subTabBarStyle,
  subTabStyle,
} from '../../common/parchment';
import type { HarborData } from '../types';
import { NationsView } from './NationsView';
import { ShipsView } from './ShipsView';

type HarborSubTab = 'ships' | 'nations';

export const HarborTab = (props: { harbor?: HarborData }) => {
  const { harbor } = props;
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
        <ShipsView docked={harbor.ships_docked} pool={harbor.ships_pool} />
      )}
      {tab === 'nations' && <NationsView nations={harbor.nations} />}
    </div>
  );
};
