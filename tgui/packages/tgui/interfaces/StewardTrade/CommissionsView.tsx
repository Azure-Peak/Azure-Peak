import { useState } from 'react';

import { useBackend } from '../../backend';
import { formatMammon } from '../common/format';
import {
  FONT_BODY,
  FONT_SMALL,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  sectionHeaderStyle,
  SERIF,
} from '../common/parchment';
import type { Data } from './types';

const ROW = 'minmax(0, 1fr) 80px 110px 120px';

const minutes = (n: number) => `${n} ${n === 1 ? 'minute' : 'minutes'}`;
const capitalize = (s: string) => s.charAt(0).toUpperCase() + s.slice(1);

export const CommissionsView = (props: { data: Data }) => {
  const { act } = useBackend<Data>();
  const { kits, orders, lead_minutes } = props.data.commissions;
  const [open, setOpen] = useState<Record<string, boolean>>({});

  return (
    <div>
      <div style={sectionHeaderStyle}>Special Commission</div>
      <div style={{ color: INK_SOFT, marginBottom: '8px' }}>
        Orders are delivered from the Royal Armoury {minutes(lead_minutes)}{' '}
        after a commission.
      </div>

      {kits.map((kit, i) => (
        <div
          key={kit.ref}
          style={{
            display: 'grid',
            gridTemplateColumns: ROW,
            gap: '8px',
            alignItems: 'center',
            padding: '4px 0',
            borderTop: `1px ${i === 0 ? 'solid' : 'dashed'} ${PARCHMENT_SHADOW}`,
          }}
        >
          <button
            type="button"
            onClick={() => setOpen({ ...open, [kit.ref]: !open[kit.ref] })}
            style={{
              minWidth: 0,
              padding: 0,
              border: 'none',
              background: 'transparent',
              textAlign: 'left',
              cursor: 'pointer',
              fontFamily: SERIF,
              fontSize: FONT_BODY,
              color: INK,
            }}
          >
            <b>{kit.name}</b>{' '}
            <span style={{ fontSize: FONT_SMALL, color: INK_SOFT }}>
              {open[kit.ref] ? '▴' : '▾'}
            </span>
            <div style={{ fontSize: FONT_SMALL, color: INK_SOFT }}>
              {kit.desc}
            </div>
          </button>
          <span style={{ textAlign: 'right', color: INK }}>
            {formatMammon(kit.price)}m
          </span>
          <span
            style={{
              fontSize: FONT_SMALL,
              color: kit.stock > 0 ? INK_SOFT : INK_FAINT,
            }}
          >
            {kit.stock} of {kit.daily_stock} left today
          </span>
          <button
            type="button"
            disabled={!!kit.blocker}
            title={kit.blocker || undefined}
            onClick={() => act('place_commission', { ref: kit.ref })}
            style={{
              ...inkButtonStyle({ color: SEAL_AMBER, disabled: !!kit.blocker }),
              width: '100%',
            }}
          >
            Commission
          </button>
          {open[kit.ref] && (
            <div
              style={{
                gridColumn: '1 / -1',
                display: 'grid',
                gridTemplateColumns: 'repeat(auto-fill, minmax(200px, 1fr))',
                gap: '2px 12px',
                padding: '0 0 4px 12px',
                fontSize: FONT_SMALL,
                color: INK_SOFT,
              }}
            >
              {kit.contents.map((item, j) => (
                <span key={j}>
                  {capitalize(item.name)}
                  {item.count > 1 ? ` ×${item.count}` : ''}
                </span>
              ))}
            </div>
          )}
        </div>
      ))}

      <div style={{ ...sectionHeaderStyle, marginTop: '16px' }}>On Order</div>
      {orders.length ? (
        orders.map((order, i) => (
          <div
            key={i}
            style={{ display: 'flex', gap: '8px', padding: '2px 0' }}
          >
            <span style={{ color: INK }}>{order.name}</span>
            <span
              style={{ marginLeft: 'auto', fontSize: FONT_SMALL, color: INK_SOFT }}
            >
              arrives in {minutes(order.minutes_left)}
            </span>
          </div>
        ))
      ) : (
        <div style={{ color: INK_FAINT, fontStyle: 'italic' }}>
          Nothing on order.
        </div>
      )}
    </div>
  );
};
