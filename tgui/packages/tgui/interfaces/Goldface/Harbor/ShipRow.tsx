import {
  INK,
  INK_SOFT,
  inkButtonStyle,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  SERIF,
} from '../../common/parchment';
import type { HarborShip } from '../types';

const formatDuration = (totalSeconds: number) => {
  if (totalSeconds <= 0) return 'now';
  const minutes = Math.floor(totalSeconds / 60);
  if (minutes < 1) return 'less than a minute';
  if (minutes === 1) return '1 minute';
  return `${minutes} minutes`;
};

type Props = {
  ship: HarborShip;
  onHail?: () => void;
  hailDisabled?: boolean;
  hailDisabledReason?: string;
  onSendAway?: () => void;
};

export const ShipRow = (props: Props) => {
  const { ship, onHail, hailDisabled, hailDisabledReason, onSendAway } = props;
  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'center',
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
        {ship.seconds_until_departure !== undefined && (
          <div
            style={{ color: SEAL_AMBER, fontSize: '11px', fontStyle: 'italic' }}
          >
            Departs in {formatDuration(ship.seconds_until_departure)}
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
        <div
          style={{
            color: SEAL_AMBER,
            fontVariant: 'small-caps',
            letterSpacing: '1px',
          }}
        >
          {ship.nationality_id}
        </div>
        <div>
          {ship.ship_type} &middot; {ship.tonnage}t
        </div>
      </div>
      {onHail && (
        <div style={{ flexShrink: 0 }}>
          <button
            type="button"
            style={inkButtonStyle({ disabled: !!hailDisabled })}
            disabled={!!hailDisabled}
            title={hailDisabled ? hailDisabledReason : 'Hail this vessel'}
            onClick={onHail}
          >
            Hail
          </button>
        </div>
      )}
      {onSendAway && (
        <div style={{ flexShrink: 0 }}>
          <button
            type="button"
            style={inkButtonStyle({ disabled: !ship.can_send_away })}
            disabled={!ship.can_send_away}
            title={
              ship.can_send_away
                ? 'Send this vessel away early.'
                : 'She has only just docked.'
            }
            onClick={onSendAway}
          >
            Send Away
          </button>
        </div>
      )}
    </div>
  );
};
