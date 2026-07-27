import { useMemo, useState } from 'react';

import {
  badgeStyle,
  cardStyle,
  FONT_BODY,
  FONT_TITLE,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  SEAL_AMBER,
  SEAL_BLUE,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
} from '../../common/parchment';
import type { NoticeboardData, TradeOrder } from '../types';

const PETITION_PURPLE = '#7a3aa6';

const orderGridStyle: React.CSSProperties = {
  display: 'grid',
  gridTemplateColumns: '1fr 1fr',
  gap: 10,
  alignItems: 'start',
};

const orderBucket = (o: TradeOrder): number => {
  if (o.blockaded) return 2;
  if (o.urgent) return 0;
  return 1;
};

export const TradeOrdersSection = ({ data }: { data: NoticeboardData }) => {
  const rawOrders = data.trade_orders ?? [];
  const orders = useMemo(
    () =>
      rawOrders.slice().sort((a, b) => {
        const bucketA = orderBucket(a);
        const bucketB = orderBucket(b);
        if (bucketA !== bucketB) {
          return bucketA - bucketB;
        }
        return b.total_payout - a.total_payout;
      }),
    [rawOrders],
  );
  const [helpOpen, setHelpOpen] = useState(false);

  return (
    <>
      <div style={{ marginBottom: 10 }}>
        <button
          type="button"
          style={{
            ...inkButtonStyle({}),
            fontSize: FONT_BODY,
            padding: '2px 6px',
          }}
          onClick={() => setHelpOpen((v) => !v)}
        >
          {helpOpen ? 'Hide About Trade Orders' : 'About Trade Orders'}
        </button>
        {helpOpen && <HelpPanel />}
      </div>

      {orders.length === 0 ? (
        <EmptyMessage text="No standing orders posted. Check back later." />
      ) : (
        <div style={orderGridStyle}>
          {orders.map((o, i) => (
            <OrderCard key={i} order={o} />
          ))}
        </div>
      )}
    </>
  );
};

const OrderCard = ({ order }: { order: TradeOrder }) => {
  return (
    <div style={{ ...cardStyle, marginBottom: 0, minHeight: 280 }}>
      <div
        style={{ display: 'flex', alignItems: 'baseline', flexWrap: 'wrap' }}
      >
        {!!order.urgent && <span style={badgeStyle(SEAL_RED)}>URGENT</span>}
        {!!order.blockaded && (
          <span style={badgeStyle(SEAL_RED)}>BLOCKADED</span>
        )}
        {!!order.warehouse && (
          <span style={badgeStyle(SEAL_BLUE)}>WAREHOUSE</span>
        )}
        {!!order.stockpile && (
          <span style={badgeStyle(SEAL_GREEN)}>STOCKPILE</span>
        )}
        {!!order.petitioned && (
          <span style={badgeStyle(PETITION_PURPLE)}>
            STEWARD&apos;S PETITION
          </span>
        )}
      </div>

      <div
        style={{
          fontSize: FONT_TITLE,
          fontWeight: 'bold',
          color: INK,
          fontFamily: SERIF,
          marginTop: 6,
        }}
      >
        {order.name}
      </div>
      <div
        style={{
          color: INK_SOFT,
          fontSize: FONT_BODY,
          marginTop: 2,
        }}
      >
        {order.region_label} &middot; {order.days_left}d remaining
      </div>

      {!!order.description && (
        <div
          style={{
            color: INK,
            fontSize: FONT_BODY,
            marginTop: 6,
            whiteSpace: 'pre-wrap',
          }}
        >
          {order.description}
        </div>
      )}

      <div style={{ marginTop: 8 }}>
        <div style={fieldLabelStyle}>Required</div>
        <div style={{ marginTop: 2, color: INK }}>
          {order.requirements.length === 0 ? (
            <span style={{ color: INK_FAINT, fontStyle: 'italic' }}>
              - nothing on record -
            </span>
          ) : (
            order.requirements.map((r) => `${r.quantity} ${r.label}`).join(', ')
          )}
        </div>
      </div>

      <div
        style={{
          marginTop: 8,
          display: 'flex',
          alignItems: 'baseline',
          gap: 8,
        }}
      >
        <span style={fieldLabelStyle}>Payout</span>
        <span
          style={{
            color: SEAL_AMBER,
            fontWeight: 'bold',
            fontSize: FONT_BODY,
          }}
        >
          {order.total_payout}m
        </span>
      </div>
    </div>
  );
};

const fieldLabelStyle: React.CSSProperties = {
  color: SEAL_AMBER,
  fontSize: FONT_BODY,
};

const EmptyMessage = ({ text }: { text: string }) => (
  <div
    style={{
      color: INK_FAINT,
      textAlign: 'center',
      padding: '24px 0',
    }}
  >
    {text}
  </div>
);

const HelpPanel = () => (
  <div
    style={{
      marginTop: 8,
      padding: '8px 12px',
      background: 'var(--p-card-bg)',
      border: `1px solid ${INK_FAINT}`,
      color: INK_SOFT,
      fontSize: FONT_BODY,
      lineHeight: 1.5,
    }}
  >
    <p style={{ margin: '0 0 6px 0' }}>
      Standing orders are demands posted by the realm&apos;s stockpiles and
      merchants. Speak with the Steward or Clerk at the Nerve Master to fulfill
      a stockpile order.
    </p>
    <p style={{ margin: '0 0 6px 0' }}>
      <b>WAREHOUSE</b>-tagged orders require finished goods to be left at the
      export machine for collection. Goods that belongs in the stockpile should
      still be delivered to the stockpile.
    </p>
    <p style={{ margin: '0 0 6px 0' }}>
      Orders may be settled short once at least 50% by value is on hand, paid at
      85% of the delivered share - the rest is forfeit.
    </p>
    <p style={{ margin: 0 }}>
      <b>BLOCKADED</b> regions cannot be reached by trade caravans until the
      blockade is lifted; <b>STEWARD&apos;S PETITION</b> orders were directly
      requested by the Steward and pay out at a reduced rate.
    </p>
  </div>
);
