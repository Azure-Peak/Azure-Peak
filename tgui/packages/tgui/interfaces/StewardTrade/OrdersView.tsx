import { useBackend } from '../../backend';
import type { Data, Order } from './types';
import {
  badgeStyle,
  cardStyle,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  SEAL_AMBER,
  SEAL_BLUE,
  SEAL_GREEN,
  SEAL_RED,
  SEAL_RED_SOFT,
  sectionHeaderStyle,
} from '../common/parchment';

// ── Orders view ──────────────────────────────────────────────────
export const OrdersView = (props: { data: Data }) => {
  const { act } = useBackend<Data>();
  const { active_orders, order_pool_cap, good_catalog, region_catalog } = props.data;
  const count = active_orders.length;

  return (
    <div>
      <div style={sectionHeaderStyle}>
        Active Standing Orders ({count}/{order_pool_cap})
      </div>
      {count === 0 ? (
        <div style={{ textAlign: 'center', fontStyle: 'italic', color: INK_SOFT }}>
          No active orders. Check back tomorrow.
        </div>
      ) : (
        active_orders.map((o) => {
          const isUrgent = o.days_left <= 1;
          const barColor = o.region_blockaded
            ? SEAL_RED
            : o.is_equipment
              ? SEAL_BLUE
              : isUrgent
                ? SEAL_RED_SOFT
                : INK_SOFT;
          return (
            <div
              key={o.ref}
              style={{
                ...cardStyle,
                borderLeft: `4px solid ${barColor}`,
              }}
            >
              <div style={{ marginBottom: '4px' }}>
                <span style={{ fontWeight: 'bold', fontSize: '14px' }}>
                  {o.name}
                </span>
                {!!o.region_blockaded && (
                  <span style={badgeStyle(SEAL_RED)}>BLOCKADED</span>
                )}
                {!!o.is_equipment && (
                  <span style={badgeStyle(SEAL_BLUE)}>WAREHOUSE</span>
                )}
                {isUrgent && !o.region_blockaded && !o.is_equipment && (
                  <span style={badgeStyle(SEAL_RED_SOFT)}>URGENT</span>
                )}
                {!!o.petitioned && (
                  <span style={badgeStyle('#a872c4')}>PETITIONED</span>
                )}
              </div>
              {o.description && (
                <div
                  style={{
                    color: INK_SOFT,
                    fontSize: '12px',
                    fontStyle: 'italic',
                    marginBottom: '4px',
                  }}
                >
                  {o.description}
                </div>
              )}
              <div style={{ color: INK_SOFT, fontSize: '12px' }}>
                {region_catalog[o.region_id]?.name ?? o.region_id} &middot;{' '}
                {o.days_left}d left &middot; Payout:{' '}
                <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
                  {o.payout}m
                </span>
              </div>
              <div style={{ marginTop: '4px' }}>
                <span style={{ color: INK_FAINT, fontSize: '11px' }}>
                  Items:{' '}
                </span>
                {o.items.map((it, i) => {
                  const short = !o.is_equipment && it.have < it.needed;
                  const label = good_catalog[it.good_id]?.name ?? it.good_id;
                  return (
                    <span key={it.good_id}>
                      <span
                        style={{
                          color: short ? SEAL_RED : SEAL_GREEN,
                          fontWeight: short ? 'bold' : 'normal',
                        }}
                      >
                        {it.needed} {label}
                        {!o.is_equipment && ` (${it.have})`}
                      </span>
                      {i < o.items.length - 1 && (
                        <span style={{ color: INK_FAINT }}>, </span>
                      )}
                    </span>
                  );
                })}
              </div>
              <div style={{ marginTop: '8px' }}>
                <FulfillButton order={o} onFulfill={() => act('fulfill_order', { ref: o.ref })} />
              </div>
            </div>
          );
        })
      )}
    </div>
  );
};

const FulfillButton = (props: {
  order: Order;
  onFulfill: () => void;
}) => {
  const o = props.order;
  if (o.region_blockaded) {
    return (
      <button
        type="button"
        disabled
        style={inkButtonStyle({ color: SEAL_RED, disabled: true })}
      >
        Fulfill &mdash; road blockaded
      </button>
    );
  }
  if (o.is_equipment) {
    return (
      <button
        type="button"
        onClick={props.onFulfill}
        style={inkButtonStyle({ color: SEAL_BLUE })}
      >
        Fulfill from Warehouse
      </button>
    );
  }
  if (o.can_fulfill) {
    return (
      <button
        type="button"
        onClick={props.onFulfill}
        style={inkButtonStyle({ color: SEAL_GREEN })}
      >
        Fulfill
      </button>
    );
  }
  return (
    <button
      type="button"
      disabled
      title={o.shortfall_text}
      style={inkButtonStyle({ disabled: true })}
    >
      Fulfill &mdash; {o.shortfall_text || 'insufficient stock'}
    </button>
  );
};
