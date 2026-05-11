import {
  cardStyle,
  INK_FAINT,
  sectionHeaderStyle,
} from '../../common/parchment';
import type { ActFn, HarborShip } from '../types';
import { ShipRow } from './ShipRow';

const EmptyCard = (props: { children: React.ReactNode }) => (
  <div
    style={{
      ...cardStyle,
      textAlign: 'center',
      fontStyle: 'italic',
      color: INK_FAINT,
      fontSize: '12px',
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
  } = props;
  const dockFull = dockSpotsUsed >= dockSpotsMax;
  const noHails = hailsRemaining <= 0;
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
        <div>
          {pool.map((s) => (
            <ShipRow
              key={s.ship_id}
              ship={s}
              budget={budget}
              act={act}
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
