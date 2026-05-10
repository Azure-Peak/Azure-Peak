import {
  cardStyle,
  INK_FAINT,
  INK_SOFT,
  sectionHeaderStyle,
} from '../../common/parchment';
import type { HarborShip } from '../types';
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

const ShipList = (props: { ships: HarborShip[]; emptyMsg: string }) => {
  if (props.ships.length === 0) {
    return <EmptyCard>{props.emptyMsg}</EmptyCard>;
  }
  return (
    <div>
      {props.ships.map((s) => (
        <ShipRow key={s.ship_id} ship={s} />
      ))}
    </div>
  );
};

type Props = {
  docked: HarborShip[];
  pool: HarborShip[];
};

export const ShipsView = (props: Props) => {
  const { docked, pool } = props;
  return (
    <>
      <div style={sectionHeaderStyle}>
        Docked at the Pier ({docked.length})
      </div>
      <ShipList
        ships={docked}
        emptyMsg="No vessels at the pier. Hail one from the roads to bring it in."
      />

      <div style={{ ...sectionHeaderStyle, marginTop: '16px' }}>
        Seen on the Horizon ({pool.length})
      </div>
      <ShipList
        ships={pool}
        emptyMsg="No vessels on the horizon. The dawn brings new arrivals."
      />

      <div
        style={{
          marginTop: '12px',
          textAlign: 'center',
          fontSize: '11px',
          fontStyle: 'italic',
          color: INK_SOFT,
        }}
      >
        Hail a vessel to bring her into port. (Coming soon.)
      </div>
    </>
  );
};
