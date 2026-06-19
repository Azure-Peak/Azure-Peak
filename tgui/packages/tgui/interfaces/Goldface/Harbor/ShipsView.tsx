import { useMemo } from 'react';

import {
  cardStyle,
  FONT_BODY,
  INK_FAINT,
  sectionHeaderStyle,
} from '../../common/parchment';
import type { ActFn, HarborRealm, HarborShip } from '../types';
import { ShipRow } from './ShipRow';

const EmptyCard = (props: { children: React.ReactNode }) => (
  <div
    style={{
      ...cardStyle,
      textAlign: 'center',
      color: INK_FAINT,
      fontSize: FONT_BODY,
    }}
  >
    {props.children}
  </div>
);

type Props = {
  docked: HarborShip[];
  pool: HarborShip[];
  dockSpotsUsed: number;
  dockSpotsMax: number;
  hailsRemaining: number;
  budget: number;
  act: ActFn;
  realms: HarborRealm[];
};

export const ShipsView = (props: Props) => {
  const {
    docked,
    pool,
    dockSpotsUsed,
    dockSpotsMax,
    hailsRemaining,
    budget,
    act,
    realms,
  } = props;
  const dockFull = dockSpotsUsed >= dockSpotsMax;
  const noHails = hailsRemaining <= 0;
  const realmsById = useMemo(() => {
    const map: Record<string, HarborRealm> = {};
    for (const r of realms) map[r.id] = r;
    return map;
  }, [realms]);
  return (
    <>
      <div style={sectionHeaderStyle}>
        Docked at the Pier ({docked.length})
      </div>
      {docked.length === 0 ? (
        <EmptyCard>
          No vessels at the pier. Hail one from the horizon to bring her in.
        </EmptyCard>
      ) : (
        <div>
          {docked.map((s) => (
            <ShipRow
              key={s.ship_id}
              ship={s}
              budget={budget}
              act={act}
              realm={realmsById[s.realm_id]}
              onSendAway={() => act('send_away', { ship_id: s.ship_id })}
            />
          ))}
        </div>
      )}

      <div style={{ ...sectionHeaderStyle, marginTop: '16px' }}>
        Seen on the Horizon ({pool.length})
      </div>
      {pool.length === 0 ? (
        <EmptyCard>
          No vessels on the horizon. The dawn brings new arrivals.
        </EmptyCard>
      ) : (
        <div
          style={{
            display: 'grid',
            gridTemplateColumns: '1fr 1fr',
            gap: '0 12px',
          }}
        >
          {pool.map((s) => (
            <ShipRow
              key={s.ship_id}
              ship={s}
              budget={budget}
              act={act}
              realm={realmsById[s.realm_id]}
              hailDisabled={dockFull || noHails}
              hailDisabledReason={
                noHails
                  ? 'No hails left today.'
                  : dockFull
                    ? 'The pier is full.'
                    : undefined
              }
              onHail={() => act('hail', { ship_id: s.ship_id })}
            />
          ))}
        </div>
      )}
    </>
  );
};
