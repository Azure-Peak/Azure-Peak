import { useState } from 'react';
import { Input } from 'tgui-core/components';

import {
  badgeStyle,
  cardStyle,
  FONT_BODY,
  INK,
  INK_SOFT,
  inkButtonStyle,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  SEAL_BLUE,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
} from '../common/parchment';
import type { ActFn, CommissionerData, Order } from './types';

const starsIf = (text: string, canRead: boolean) =>
  canRead ? text : text.replace(/[A-Za-z0-9]/g, '*');

const STATUS_BADGE_COLOR: Record<string, string> = {
  open: SEAL_BLUE,
  claimed: SEAL_AMBER,
  complete: SEAL_GREEN,
};

const STATUS_LABEL: Record<string, string> = {
  open: 'OPEN',
  claimed: 'CLAIMED',
  complete: 'READY',
};

const OrderCard = (props: {
  order: Order;
  isGuildmaster: boolean;
  act: ActFn;
  canRead: boolean;
}) => {
  const { order, isGuildmaster, act, canRead } = props;
  const fulfilled = !!order.is_fulfilled;
  const isCommissioner = !!order.is_commissioner;
  const isSmith = !!order.is_smith;
  const hasProgress =
    order.done_count > 0 && order.done_count < order.needed_count;
  const [rejectOpen, setRejectOpen] = useState(false);
  const [rejectReason, setRejectReason] = useState('');
  const canReject =
    (order.status === 'open' && isGuildmaster) ||
    (order.status === 'claimed' && (isSmith || isGuildmaster));
  return (
    <div style={{ ...cardStyle, padding: '6px 8px', marginBottom: 0 }}>
      <div
        style={{
          display: 'flex',
          alignItems: 'baseline',
          flexWrap: 'wrap',
          gap: '4px',
        }}
      >
        <span style={badgeStyle(STATUS_BADGE_COLOR[order.status] || SEAL_BLUE)}>
          {STATUS_LABEL[order.status] || order.status.toUpperCase()}
        </span>
        <span
          style={{ color: SEAL_AMBER, fontWeight: 'bold', fontSize: FONT_BODY }}
        >
          {order.deposited}m
        </span>
        <span
          style={{
            fontFamily: SERIF,
            fontSize: FONT_BODY,
            color: INK,
            overflow: 'hidden',
            textOverflow: 'ellipsis',
            whiteSpace: 'nowrap',
            flex: 1,
            minWidth: 0,
          }}
        >
          <span style={{ color: INK_SOFT }}>for </span>
          <b>{starsIf(order.commissioner_name, canRead)}</b>
          {order.status !== 'open' && order.smith_name && (
            <>
              <span style={{ color: INK_SOFT }}> by </span>
              <b>{starsIf(order.smith_name, canRead)}</b>
            </>
          )}
        </span>
        {!!order.expiry_label && (
          <span
            style={{
              fontFamily: SERIF,
              fontSize: FONT_BODY,
              color: order.days_left <= 0 ? SEAL_RED : INK_SOFT,
            }}
          >
            <b style={{ color: order.days_left <= 0 ? SEAL_RED : INK }}>
              {order.days_left <= 0 ? 'today' : `${order.days_left}d`}
            </b>
          </span>
        )}
      </div>

      {!!order.note && (
        <div
          style={{
            marginTop: '3px',
            padding: '2px 6px',
            borderLeft: `2px solid ${SEAL_AMBER}`,
            fontFamily: SERIF,
            fontStyle: 'italic',
            fontSize: FONT_BODY,
            color: INK_SOFT,
            overflow: 'hidden',
            textOverflow: 'ellipsis',
          }}
        >
          &ldquo;{starsIf(order.note, canRead)}&rdquo;
        </div>
      )}

      <div style={{ marginTop: '3px' }}>
        {order.lines.map((line, idx) => (
          <div
            key={idx}
            style={{
              fontSize: FONT_BODY,
              color: INK,
              fontFamily: SERIF,
              padding: '0px',
              borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
              overflow: 'hidden',
              textOverflow: 'ellipsis',
              whiteSpace: 'nowrap',
            }}
          >
            {starsIf(line.name, canRead)}{' '}
            <span style={{ color: INK_SOFT }}>x{line.qty}</span>
          </div>
        ))}
      </div>

      {canRead && order.materials.length > 0 && (
        <div
          style={{
            marginTop: '3px',
            fontSize: FONT_BODY,
            fontFamily: SERIF,
            color: INK_SOFT,
          }}
        >
          <span style={{ color: SEAL_AMBER }}>needs: </span>
          {order.materials.map((m) => `${m.qty} ${m.name}`).join(' · ')}
        </div>
      )}

      {order.status === 'claimed' && (
        <div style={{ marginTop: '3px' }}>
          <div
            style={{
              fontSize: FONT_BODY,
              color: SEAL_AMBER,
            }}
          >
            Delivered {order.done_count} / {order.needed_count}
          </div>
          {order.fulfillment.map((f, idx) => (
            <div
              key={idx}
              style={{
                fontSize: FONT_BODY,
                fontFamily: SERIF,
                color: f.have >= f.want ? SEAL_GREEN : INK_SOFT,
              }}
            >
              {starsIf(f.name, canRead)}: {f.have} / {f.want}
            </div>
          ))}
        </div>
      )}

      <div
        style={{
          marginTop: '4px',
          display: 'flex',
          gap: '4px',
          flexWrap: 'wrap',
        }}
      >
        {order.status === 'open' && (
          <button
            type="button"
            style={inkButtonStyle()}
            onClick={() => act('claim_order', { ref: order.ref })}
          >
            Claim (Smith)
          </button>
        )}
        {order.status === 'open' && isCommissioner && (
          <button
            type="button"
            style={inkButtonStyle({ color: SEAL_RED })}
            onClick={() => act('cancel_order', { ref: order.ref })}
          >
            Cancel &amp; Refund
          </button>
        )}
        {order.status === 'claimed' && isSmith && (
          <>
            <button
              type="button"
              style={inkButtonStyle()}
              onClick={() => act('release_order', { ref: order.ref })}
            >
              Release Claim
            </button>
            {hasProgress && (
              <button
                type="button"
                style={inkButtonStyle({ color: SEAL_AMBER })}
                onClick={() => act('settle_partial', { ref: order.ref })}
                title="Collect pro-rata pay for delivered items (20% haircut, rest refunds to commissioner)"
              >
                Settle Partial
              </button>
            )}
            <button
              type="button"
              style={inkButtonStyle({
                color: SEAL_GREEN,
                disabled: !fulfilled,
              })}
              disabled={!fulfilled}
              onClick={() => act('complete_order', { ref: order.ref })}
            >
              Complete &amp; Collect Pay
            </button>
          </>
        )}
        {order.status === 'complete' && isCommissioner && (
          <button
            type="button"
            style={inkButtonStyle({ color: SEAL_GREEN })}
            onClick={() => act('collect_order', { ref: order.ref })}
          >
            Collect Items
          </button>
        )}
        {isGuildmaster && order.status === 'claimed' && !isSmith && (
          <button
            type="button"
            style={inkButtonStyle({ color: SEAL_AMBER })}
            onClick={() => act('force_release_order', { ref: order.ref })}
            title="Guildmaster override: release this stalled claim"
          >
            Force Release
          </button>
        )}
        {canReject && (
          <button
            type="button"
            style={inkButtonStyle({ color: SEAL_RED })}
            onClick={() => setRejectOpen((v) => !v)}
            title="Refuse this commission. Deposit returns to the commissioner's deposit pool."
          >
            Reject Order
          </button>
        )}
      </div>

      {rejectOpen && canReject && (
        <div
          style={{
            marginTop: '8px',
            padding: '8px',
            border: `1px solid ${SEAL_RED}`,
            borderRadius: '2px',
            fontFamily: SERIF,
          }}
        >
          <div
            style={{
              fontSize: FONT_BODY,
              color: INK_SOFT,
              marginBottom: '4px',
            }}
          >
            State your reason publicly. The commissioner will be notified and
            their deposit returned.
          </div>
          <div style={{ display: 'flex', gap: '6px', alignItems: 'center' }}>
            <Input
              value={rejectReason}
              onChange={setRejectReason}
              placeholder="Insulting wage. Take it elsewhere."
              width="100%"
              maxLength={180}
            />
            <button
              type="button"
              style={inkButtonStyle({ color: SEAL_RED })}
              onClick={() => {
                act('reject_order', {
                  ref: order.ref,
                  reason: rejectReason,
                });
                setRejectOpen(false);
                setRejectReason('');
              }}
            >
              Confirm Reject
            </button>
            <button
              type="button"
              style={inkButtonStyle()}
              onClick={() => {
                setRejectOpen(false);
                setRejectReason('');
              }}
            >
              Cancel
            </button>
          </div>
        </div>
      )}

      {order.status === 'claimed' && isSmith && !fulfilled && (
        <div
          style={{
            marginTop: '6px',
            fontSize: FONT_BODY,
            color: INK_SOFT,
          }}
        >
          Strike each finished item against the machine to deposit it.
        </div>
      )}
    </div>
  );
};

export const OrdersTab = (props: {
  data: CommissionerData;
  act: ActFn;
  canRead: boolean;
}) => {
  const { data, act, canRead } = props;
  const isGuildmaster = !!data.is_guildmaster;
  if (data.orders.length === 0) {
    return (
      <div
        style={{
          ...cardStyle,
          textAlign: 'center',
          color: INK_SOFT,
        }}
      >
        No posted orders. Build a manifest and post a commission to begin.
      </div>
    );
  }
  return (
    <div
      style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(2, minmax(0, 1fr))',
        gap: '6px',
      }}
    >
      {data.orders.map((order) => (
        <OrderCard
          key={order.ref}
          order={order}
          isGuildmaster={isGuildmaster}
          act={act}
          canRead={canRead}
        />
      ))}
    </div>
  );
};
