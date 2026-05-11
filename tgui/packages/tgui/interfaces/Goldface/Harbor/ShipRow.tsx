import { useState } from 'react';
import { NumberInput } from 'tgui-core/components';

import {
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
} from '../../common/parchment';
import type { ActFn, BulkLine, HarborShip } from '../types';

const formatDuration = (totalSeconds: number) => {
  if (totalSeconds <= 0) return 'now';
  const minutes = Math.floor(totalSeconds / 60);
  if (minutes < 1) return 'less than a minute';
  if (minutes === 1) return '1 minute';
  return `${minutes} minutes`;
};

type Props = {
  ship: HarborShip;
  budget: number;
  act: ActFn;
  onHail?: () => void;
  hailDisabled?: boolean;
  hailDisabledReason?: string;
  onSendAway?: () => void;
};

const DemandLineRow = (props: { line: BulkLine }) => {
  const { line } = props;
  const done = line.qty_fulfilled >= line.qty_target;
  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'baseline',
        gap: '8px',
        padding: '2px 0',
        fontSize: '11px',
        color: INK,
      }}
    >
      <span style={{ flex: '0 0 70px', color: SEAL_GREEN, fontWeight: 'bold' }}>
        Buying
      </span>
      <span style={{ flex: 1 }}>
        {line.good_name} &times;{line.qty_target}
      </span>
      <span style={{ flex: '0 0 auto', color: INK_SOFT }}>
        {line.qty_fulfilled} / {line.qty_target}
      </span>
      <span
        style={{
          flex: '0 0 auto',
          color: done ? INK_FAINT : SEAL_AMBER,
          fontWeight: 'bold',
        }}
      >
        {line.offered_price}m ea
      </span>
    </div>
  );
};

const SupplyLineRow = (props: {
  line: BulkLine;
  shipId: string;
  budget: number;
  act: ActFn;
}) => {
  const { line, shipId, budget, act } = props;
  const remaining = Math.max(0, line.qty_target - line.qty_fulfilled);
  const initial = Math.min(remaining, 1);
  const [qty, setQty] = useState(initial);
  const safeQty = Math.min(Math.max(1, qty), remaining || 1);
  const totalCost = line.offered_price * safeQty;
  const cantAfford = budget < totalCost;
  const soldOut = remaining <= 0;
  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'baseline',
        gap: '8px',
        padding: '2px 0',
        fontSize: '11px',
        color: INK,
      }}
    >
      <span style={{ flex: '0 0 70px', color: SEAL_RED, fontWeight: 'bold' }}>
        Selling
      </span>
      <span style={{ flex: 1 }}>
        {line.good_name} &times;{line.qty_target}
      </span>
      <span style={{ flex: '0 0 auto', color: INK_SOFT }}>
        {line.qty_fulfilled} / {line.qty_target}
      </span>
      <span style={{ flex: '0 0 auto', color: SEAL_AMBER, fontWeight: 'bold' }}>
        {line.offered_price}m ea
      </span>
      {soldOut ? (
        <span style={{ color: INK_FAINT, fontStyle: 'italic' }}>sold out</span>
      ) : (
        <>
          <NumberInput
            value={safeQty}
            minValue={1}
            maxValue={remaining}
            step={1}
            stepPixelSize={4}
            width="44px"
            onChange={(v: number) => setQty(v)}
          />
          <button
            type="button"
            style={inkButtonStyle({ disabled: cantAfford })}
            disabled={cantAfford}
            title={
              cantAfford
                ? `Need ${totalCost}m, have ${budget}m`
                : `Buy ${safeQty} for ${totalCost}m`
            }
            onClick={() =>
              act('bulk_buy', {
                ship_id: shipId,
                good: line.good,
                qty: safeQty,
              })
            }
          >
            Buy
          </button>
        </>
      )}
    </div>
  );
};

export const ShipRow = (props: Props) => {
  const {
    ship,
    budget,
    act,
    onHail,
    hailDisabled,
    hailDisabledReason,
    onSendAway,
  } = props;
  const hasBulk =
    (ship.bulk_demands?.length ?? 0) + (ship.bulk_supplies?.length ?? 0) > 0;
  return (
    <div
      style={{
        padding: '6px 8px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontFamily: SERIF,
        fontSize: '13px',
      }}
    >
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: '12px',
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
              style={{
                color: SEAL_AMBER,
                fontSize: '11px',
                fontStyle: 'italic',
              }}
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
            {ship.realm_id}
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
      {hasBulk && (
        <div
          style={{
            marginTop: '4px',
            paddingLeft: '6px',
            borderLeft: `2px solid ${PARCHMENT_SHADOW}`,
          }}
        >
          {ship.bulk_demands?.map((line) => (
            <DemandLineRow key={`d-${line.good}`} line={line} />
          ))}
          {ship.bulk_supplies?.map((line) => (
            <SupplyLineRow
              key={`s-${line.good}`}
              line={line}
              shipId={ship.ship_id}
              budget={budget}
              act={act}
            />
          ))}
        </div>
      )}
    </div>
  );
};
