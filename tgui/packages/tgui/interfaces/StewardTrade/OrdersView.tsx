import { useBackend } from '../../backend';
import {
  badgeStyle,
  cardStyle,
  FONT_BODY,
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
import type { Data, Order } from './types';
import { formatMammon } from '../common/format';

export const OrdersView = (props: { data: Data }) => {
  const { act } = useBackend<Data>();
  const { active_orders, order_pool_cap, good_catalog, region_catalog } =
    props.data;
  const count = active_orders.length;

  return (
    <div>
      <div style={sectionHeaderStyle}>
        Active Standing Orders ({count}/{order_pool_cap})
      </div>
      {count === 0 ? (
        <div style={{ textAlign: 'center', color: INK_SOFT }}>
          No active orders. Check back tomorrow.
        </div>
      ) : (
        active_orders.map((o) => (
          <OrderCard
            key={o.ref}
            order={o}
            regionCatalog={region_catalog}
            goodCatalog={good_catalog}
            onExtend={() => act('extend_order', { ref: o.ref })}
          />
        ))
      )}
    </div>
  );
};

type CardProps = {
  order: Order;
  regionCatalog: Data['region_catalog'];
  goodCatalog: Data['good_catalog'];
  onExtend: () => void;
};

const OrderCard = (props: CardProps) => {
  const { data } = useBackend<Data>();
  const o = props.order;
  const payouts = data.quality_payouts || [];
  const qualityTooltip = [
    'Payout by quality:',
    ...payouts.map((q) => `  ${q.label} ${q.pct}%`),
  ].join('\n');
  const lowestPayout = payouts.length
    ? Math.min(...payouts.map((q) => q.pct))
    : 100;
  const highestPayout = payouts.length
    ? Math.max(...payouts.map((q) => q.pct))
    : 100;
  const isUrgent = o.days_left <= 1;
  const pureWarehouse = !!o.has_warehouse && !o.has_stockpile;
  const barColor = o.region_blockaded
    ? SEAL_RED
    : pureWarehouse
      ? SEAL_BLUE
      : isUrgent
        ? SEAL_RED_SOFT
        : INK_SOFT;
  return (
    <div style={{ ...cardStyle, borderLeft: `4px solid ${barColor}` }}>
      <div style={{ marginBottom: '4px' }}>
        <span style={{ fontWeight: 'bold', fontSize: FONT_BODY }}>
          {o.name}
        </span>
        {!!o.region_blockaded && (
          <span style={badgeStyle(SEAL_RED)}>BLOCKADED</span>
        )}
        {!!o.has_warehouse && (
          <span style={badgeStyle(SEAL_BLUE)}>WAREHOUSE</span>
        )}
        {!!o.has_stockpile && (
          <span style={badgeStyle(SEAL_GREEN)}>STOCKPILE</span>
        )}
        {isUrgent && !o.region_blockaded && !pureWarehouse && (
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
            fontSize: FONT_BODY,
            marginBottom: '4px',
          }}
        >
          {o.description}
        </div>
      )}
      <div style={{ color: INK_SOFT, fontSize: FONT_BODY }}>
        {props.regionCatalog[o.region_id]?.name ?? o.region_id} &middot;{' '}
        {o.days_left}d left &middot; Payout:{' '}
        <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
          {formatMammon(o.payout)}m
        </span>
      </div>
      <div style={{ marginTop: '4px' }}>
        <span style={{ color: INK_FAINT, fontSize: FONT_BODY }}>Items: </span>
        {o.items.map((it, i) => {
          const isStockpileItem = it.route === 'stockpile';
          const short = isStockpileItem && it.have < it.needed;
          const label = props.goodCatalog[it.good_id]?.name ?? it.good_id;
          return (
            <span key={it.good_id}>
              <span
                style={{
                  color: short ? SEAL_RED : SEAL_GREEN,
                  fontWeight: short ? 'bold' : 'normal',
                }}
              >
                {it.needed} {label}
                {isStockpileItem && ` (${it.have})`}
              </span>
              <span style={{ color: INK_FAINT }}>
                {' '}
                at {formatMammon(it.unit_pay)}m
              </span>
              {i < o.items.length - 1 && (
                <span style={{ color: INK_FAINT }}>, </span>
              )}
            </span>
          );
        })}
      </div>
      {!!o.has_warehouse && (
        <div
          style={{
            marginTop: '4px',
            color: INK_FAINT,
            fontSize: FONT_BODY,
            cursor: 'help',
          }}
          title={qualityTooltip}
        >
          Warehouse goods pay {lowestPayout - 100}% to +{highestPayout - 100}%
          based on the quality of submitted items.
        </div>
      )}
      <div style={{ marginTop: '8px', display: 'flex', gap: '6px' }}>
        <ZadButton
          order={o}
          cost={data.order_extend_cost}
          isOfficial={!!data.petition?.is_steward_role}
          onExtend={props.onExtend}
        />
      </div>
    </div>
  );
};

const ZadButton = (props: {
  order: Order;
  cost: number;
  isOfficial: boolean;
  onExtend: () => void;
}) => {
  const { order, cost, isOfficial } = props;
  const blocker = !isOfficial
    ? 'Only Crown officials can send a zad.'
    : order.extend_blocker;
  return (
    <button
      type="button"
      disabled={!!blocker}
      onClick={props.onExtend}
      title={blocker || 'Send a zad to extend the request by one dae.'}
      style={inkButtonStyle({ color: SEAL_AMBER, disabled: !!blocker })}
    >
      Send a zad - {cost}p
    </button>
  );
};
