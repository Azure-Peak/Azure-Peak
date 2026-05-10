import {
  INK,
  INK_SOFT,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  SERIF,
} from '../../common/parchment';
import type { HarborShip } from '../types';

export const ShipRow = (props: { ship: HarborShip }) => {
  const { ship } = props;
  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'baseline',
        gap: '12px',
        padding: '6px 8px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontFamily: SERIF,
        fontSize: '13px',
      }}
    >
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ color: INK, fontWeight: 'bold' }}>{ship.ship_name}</div>
        {ship.captain_name && (
          <div
            style={{ color: INK_SOFT, fontSize: '11px', fontStyle: 'italic' }}
          >
            Captain {ship.captain_name}
          </div>
        )}
      </div>
      <div
        style={{
          flex: '0 0 auto',
          textAlign: 'right',
          color: INK_SOFT,
          fontSize: '11px',
        }}
      >
        <div style={{ color: SEAL_AMBER, fontVariant: 'small-caps', letterSpacing: '1px' }}>
          {ship.nationality_id}
        </div>
        <div>
          {ship.ship_type} &middot; {ship.tonnage}t
        </div>
      </div>
    </div>
  );
};
