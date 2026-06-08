import { useState } from 'react';

import {
  compactButtonStyle,
  denseRowStyle,
  ellipsisCellStyle,
  FONT_BODY,
  FONT_HEAD,
  FONT_LEAD,
  FONT_SMALL,
  FONT_TITLE,
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
import type { ActFn, BulkLine, HarborRealm, HarborShip } from '../types';
import { RealmCard } from './RealmCard';

const formatDuration = (totalSeconds: number) => {
  if (totalSeconds <= 0) return 'now';
  const minutes = Math.floor(totalSeconds / 60);
  if (minutes < 1) return 'less than a minute';
  if (minutes === 1) return '1 minute';
  return `${minutes} minutes`;
};

const SMALL_WORDS = new Set([
  'a',
  'an',
  'and',
  'as',
  'at',
  'but',
  'by',
  'for',
  'in',
  'of',
  'on',
  'or',
  'the',
  'to',
  'with',
]);

const titleCase = (s: string) =>
  s
    .split(' ')
    .map((word, i) => {
      if (!word) return word;
      const lower = word.toLowerCase();
      if (i > 0 && SMALL_WORDS.has(lower)) return lower;
      return lower.charAt(0).toUpperCase() + lower.slice(1);
    })
    .join(' ');

type Props = {
  ship: HarborShip;
  budget: number;
  act: ActFn;
  realm?: HarborRealm;
  onHail?: () => void;
  hailDisabled?: boolean;
  hailDisabledReason?: string;
  onSendAway?: () => void;
};

type DemandGroup = 'goods' | 'food' | 'drinks';

const DEMAND_GROUP_ORDER: DemandGroup[] = ['goods', 'food', 'drinks'];

const DEMAND_GROUP_LABEL: Record<DemandGroup, string> = {
  goods: 'Goods',
  food: 'Food',
  drinks: 'Drinks',
};

const tagToDemandGroup = (tag?: string): DemandGroup => {
  if (tag === 'victualling_drinks') {
    return 'drinks';
  }
  if (tag === 'victualling_fresh' || tag === 'victualling_preserved') {
    return 'food';
  }
  return 'goods';
};

const DemandGroupDivider = (props: { label: string }) => (
  <div
    style={{
      display: 'flex',
      alignItems: 'center',
      gap: '6px',
      margin: '6px 0 2px',
    }}
  >
    <div style={{ flex: 1, borderTop: `1px dashed ${PARCHMENT_SHADOW}` }} />
    <span
      style={{
        color: SEAL_AMBER,
        fontFamily: SERIF,
        fontWeight: 'bold',
        fontSize: FONT_SMALL,
        letterSpacing: '1px',
      }}
    >
      {props.label}
    </span>
    <div style={{ flex: 1, borderTop: `1px dashed ${PARCHMENT_SHADOW}` }} />
  </div>
);

const DemandLineRow = (props: { line: BulkLine }) => {
  const { line } = props;
  const done = line.qty_fulfilled >= line.qty_target;
  const hasKin =
    line.kin_offered_price !== undefined &&
    line.kin_offered_price > line.offered_price;
  const displayedPrice = hasKin
    ? (line.kin_offered_price as number)
    : line.offered_price;
  return (
    <div
      style={{
        ...denseRowStyle,
        alignItems: 'baseline',
        padding: '2px 0',
        borderBottom: 'none',
        fontSize: FONT_BODY,
        color: SEAL_GREEN,
      }}
      title={
        hasKin
          ? `Buying ${line.qty_target} ${titleCase(line.good_name)} at ${displayedPrice}m each (Kinship +${displayedPrice - line.offered_price}m over base ${line.offered_price}m). ${line.qty_fulfilled} delivered so far.`
          : `Buying ${line.qty_target} ${titleCase(line.good_name)} at ${line.offered_price}m each (${line.qty_fulfilled} delivered so far)`
      }
    >
      <span style={ellipsisCellStyle}>{titleCase(line.good_name)}</span>
      <span style={{ flex: '0 0 auto', color: INK_SOFT }}>
        {line.qty_fulfilled}/{line.qty_target}
      </span>
      <span style={{ flex: '0 0 auto', fontWeight: 'bold' }}>
        {hasKin && (
          <span
            style={{
              color: INK_FAINT,
              textDecoration: 'line-through',
              marginRight: '4px',
              fontWeight: 'normal',
            }}
          >
            {line.offered_price}m
          </span>
        )}
        <span
          style={{
            color: done ? INK_FAINT : hasKin ? SEAL_GREEN : SEAL_AMBER,
          }}
        >
          {displayedPrice}m
        </span>
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
  const hasKin =
    line.kin_offered_price !== undefined &&
    line.kin_offered_price < line.offered_price;
  const unitPrice = hasKin ? (line.kin_offered_price as number) : line.offered_price;
  const totalCost = unitPrice * safeQty;
  const cantAfford = budget < totalCost;
  const soldOut = remaining <= 0;
  return (
    <div
      style={{
        ...denseRowStyle,
        alignItems: 'baseline',
        padding: '2px 0',
        borderBottom: 'none',
        fontSize: FONT_BODY,
        color: SEAL_RED,
      }}
      title={
        hasKin
          ? `Selling ${titleCase(line.good_name)} at ${unitPrice}m each (Kinship -${line.offered_price - unitPrice}m off ${line.offered_price}m). ${line.qty_fulfilled} of ${line.qty_target} sold.`
          : `Selling ${titleCase(line.good_name)} at ${line.offered_price}m each (${line.qty_fulfilled} of ${line.qty_target} sold)`
      }
    >
      <span style={ellipsisCellStyle}>{titleCase(line.good_name)}</span>
      <span style={{ flex: '0 0 auto', color: INK_SOFT }}>
        {line.qty_fulfilled}/{line.qty_target}
      </span>
      {hasKin ? (
        <span style={{ flex: '0 0 auto', fontWeight: 'bold' }}>
          <span
            style={{
              color: INK_FAINT,
              textDecoration: 'line-through',
              marginRight: '4px',
              fontWeight: 'normal',
            }}
          >
            {line.offered_price}m
          </span>
          <span style={{ color: SEAL_GREEN }}>{unitPrice}m</span>
        </span>
      ) : (
        <span style={{ flex: '0 0 auto', color: SEAL_AMBER, fontWeight: 'bold' }}>
          {line.offered_price}m
        </span>
      )}
      {soldOut ? (
        <span style={{ color: INK_FAINT }}>sold</span>
      ) : (
        <>
          <input
            type="number"
            min={1}
            max={remaining}
            step={1}
            value={safeQty}
            onChange={(e) => {
              const next = Number(e.target.value);
              if (!Number.isNaN(next)) setQty(next);
            }}
            style={{
              width: '42px',
              fontFamily: SERIF,
              fontSize: FONT_BODY,
              color: INK,
              background: 'var(--p-button-bg)',
              border: `1px solid ${INK_FAINT}`,
              borderRadius: '2px',
              padding: '1px 3px',
              textAlign: 'right',
            }}
          />
          <button
            type="button"
            style={compactButtonStyle({ disabled: cantAfford })}
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
    realm,
    onHail,
    hailDisabled,
    hailDisabledReason,
    onSendAway,
  } = props;
  const hasBulk =
    (ship.bulk_demands?.length ?? 0) + (ship.bulk_supplies?.length ?? 0) > 0;
  const [realmOpen, setRealmOpen] = useState(false);
  return (
    <div
      style={{
        padding: '6px 8px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontFamily: SERIF,
        fontSize: FONT_BODY,
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
          <div style={{ color: INK, fontWeight: 'bold', fontSize: FONT_TITLE }}>
            {!!ship.auto_hailed && (
              <span
                title="This vessel sailed in unbidden while no Merchant was tending the harbor. Dismiss her freely with no penalty."
                style={{
                  marginRight: '6px',
                  padding: '0 4px',
                  border: `1px solid ${SEAL_AMBER}`,
                  borderRadius: '6px',
                  color: SEAL_AMBER,
                  fontSize: FONT_BODY,
                  fontWeight: 'bold',
                  letterSpacing: '0.5px',
                  verticalAlign: 'middle',
                }}
              >
                DRIFTED IN
              </span>
            )}
            {ship.ship_name}
          </div>
          {ship.captain_name && (
            <div style={{ color: INK_SOFT, fontSize: FONT_BODY }}>
              Captain {ship.captain_name}
              {ship.port_of_origin ? ` - sailing from ${ship.port_of_origin}` : ''}
            </div>
          )}
          {!ship.captain_name && ship.port_of_origin && (
            <div style={{ color: INK_SOFT, fontSize: FONT_BODY }}>
              Sailing from {ship.port_of_origin}
            </div>
          )}
          {ship.seconds_until_departure !== undefined && (
            <div style={{ color: SEAL_AMBER, fontSize: FONT_LEAD }}>
              Departs in {formatDuration(ship.seconds_until_departure)}
            </div>
          )}
        </div>
        <div
          style={{
            flex: '0 0 auto',
            textAlign: 'right',
            color: INK_SOFT,
            fontSize: FONT_LEAD,
            lineHeight: 1.3,
          }}
        >
          <div
            title={`Tonnage scales goods on offer and expected favor. 100t baseline = 1.00x, 800t galleon caps at 2.00x. This vessel: ${ship.tonnage_mult.toFixed(2)}x.`}
            style={{ position: 'relative' }}
          >
            {realm ? (
              <button
                type="button"
                onClick={(e) => {
                  e.stopPropagation();
                  setRealmOpen((o) => !o);
                }}
                style={{
                  background: 'transparent',
                  border: 'none',
                  padding: 0,
                  margin: 0,
                  color: SEAL_AMBER,
                  fontFamily: SERIF,
                  fontSize: 'inherit',
                  cursor: 'pointer',
                  borderBottom: `1px dotted ${SEAL_AMBER}`,
                }}
                title="Click to see what this realm typically wants and sells"
              >
                {ship.realm_id}
              </button>
            ) : (
              <span style={{ color: SEAL_AMBER }}>
                {ship.realm_id}
              </span>
            )}
            <span style={{ color: INK_FAINT }}> &middot; </span>
            {ship.ship_type} &middot; {ship.tonnage}t
            {ship.tonnage_mult > 1.0 && (
              <span style={{ color: SEAL_AMBER }}>
                {' '}({ship.tonnage_mult.toFixed(2)}x)
              </span>
            )}
            {realm && realmOpen && (
              <div
                onClick={(e) => e.stopPropagation()}
                style={{
                  position: 'absolute',
                  top: '100%',
                  right: 0,
                  marginTop: '4px',
                  zIndex: 10,
                  width: '320px',
                  textAlign: 'left',
                  padding: '8px 10px',
                  background: 'var(--p-bg)',
                  border: `1px solid ${INK}`,
                  borderRadius: '2px',
                  boxShadow: '2px 3px 8px rgba(0, 0, 0, 0.35)',
                  fontFamily: SERIF,
                  fontSize: FONT_BODY,
                  color: INK,
                }}
              >
                <div
                  style={{
                    display: 'flex',
                    alignItems: 'baseline',
                    justifyContent: 'space-between',
                    marginBottom: '6px',
                  }}
                >
                  <span
                    style={{
                      color: SEAL_AMBER,
                      fontWeight: 'bold',
                      fontSize: FONT_BODY,
                    }}
                  >
                    {realm.name}
                  </span>
                  <button
                    type="button"
                    onClick={(e) => {
                      e.stopPropagation();
                      setRealmOpen(false);
                    }}
                    style={{
                      background: 'transparent',
                      border: 'none',
                      color: INK_SOFT,
                      cursor: 'pointer',
                      fontSize: FONT_BODY,
                      padding: '0 4px',
                      lineHeight: 1,
                    }}
                    title="Close"
                  >
                    ✕
                  </button>
                </div>
                <RealmCard realm={realm} />
              </div>
            )}
          </div>
          {ship.expected_favor > 0 && (
            <div
              style={{ color: SEAL_AMBER }}
              title={`Send-off favor: Honored at 100% of target gives you the full delivered value as favor plus a refunded hail. Partial at 50% gives you half delivered value as favor. Below 50% is Dishonored and costs ${Math.round(250 * ship.tonnage_mult)}m favor for this vessel.`}
            >
              {!!ship.is_kin && (
                <span
                  title="Kin ship - Kinship Bonus applies"
                  style={{
                    marginRight: '6px',
                    padding: '0 4px',
                    border: `1px solid ${SEAL_GREEN}`,
                    borderRadius: '6px',
                    color: SEAL_GREEN,
                    fontSize: FONT_BODY,
                    fontWeight: 'bold',
                    letterSpacing: '0.5px',
                    verticalAlign: 'middle',
                  }}
                >
                  KIN
                </span>
              )}
              Favor: {ship.favor_earned}m / {ship.expected_favor}m
            </div>
          )}
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
                ship.auto_hailed
                  ? 'This vessel drifted in - dismiss her freely, no penalty.'
                  : ship.can_send_away
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
            display: 'grid',
            gridTemplateColumns: '1fr 1fr',
            gap: '0 16px',
          }}
        >
          <div
            style={{
              paddingLeft: '6px',
              borderLeft: `2px solid ${SEAL_GREEN}`,
            }}
          >
            <div
              style={{
                color: SEAL_GREEN,
                fontWeight: 'bold',
                fontSize: FONT_HEAD,
                marginBottom: '3px',
              }}
            >
              Buying
            </div>
            {ship.bulk_demands?.length ? (
              (() => {
                const grouped: Record<DemandGroup, BulkLine[]> = {
                  goods: [],
                  food: [],
                  drinks: [],
                };
                for (const line of ship.bulk_demands) {
                  grouped[tagToDemandGroup(line.tag)].push(line);
                }
                return DEMAND_GROUP_ORDER.filter(
                  (g) => grouped[g].length > 0,
                ).map((g) => (
                  <div key={g}>
                    <DemandGroupDivider label={DEMAND_GROUP_LABEL[g]} />
                    {grouped[g].map((line, i) => (
                      <DemandLineRow
                        key={`d-${g}-${line.good || line.good_name}-${i}`}
                        line={line}
                      />
                    ))}
                  </div>
                ));
              })()
            ) : (
              <div style={{ color: INK_FAINT, fontSize: FONT_SMALL, fontStyle: 'italic' }}>
                Nothing wanted.
              </div>
            )}
          </div>
          <div
            style={{
              paddingLeft: '6px',
              borderLeft: `2px solid ${SEAL_RED}`,
            }}
          >
            <div
              style={{
                color: SEAL_RED,
                fontWeight: 'bold',
                fontSize: FONT_HEAD,
                marginBottom: '3px',
              }}
            >
              Selling
            </div>
            {ship.bulk_supplies?.length ? (
              ship.bulk_supplies.map((line) => (
                <SupplyLineRow
                  key={`s-${line.good}`}
                  line={line}
                  shipId={ship.ship_id}
                  budget={budget}
                  act={act}
                />
              ))
            ) : (
              <div style={{ color: INK_FAINT, fontSize: FONT_SMALL, fontStyle: 'italic' }}>
                Nothing on offer.
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
};
