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
import { MinutesLeft } from '../common/MinutesLeft';
import type {
  CommissionCatalogEntry,
  CommissionOrder,
  CommissionRow,
  Data,
} from './types';

const ROW = 'minmax(0, 1fr) 80px 110px 120px';

const minutes = (n: number) => `${n} ${n === 1 ? 'minute' : 'minutes'}`;
const capitalize = (s: string) => s.charAt(0).toUpperCase() + s.slice(1);

const CommissionLine = (props: {
  row: CommissionRow;
  entry?: CommissionCatalogEntry;
  first: boolean;
  open: boolean;
  onToggle: () => void;
  onCommission: () => void;
}) => {
  const { row, entry, open } = props;
  const contents = entry?.contents;
  const expandable = !!contents?.length;
  return (
    <div
      style={{
        display: 'grid',
        gridTemplateColumns: ROW,
        gap: '8px',
        alignItems: 'center',
        padding: '4px 0',
        borderTop: `1px ${props.first ? 'solid' : 'dashed'} ${PARCHMENT_SHADOW}`,
      }}
    >
      <button
        type="button"
        onClick={expandable ? props.onToggle : undefined}
        style={{
          minWidth: 0,
          padding: 0,
          border: 'none',
          background: 'transparent',
          textAlign: 'left',
          cursor: expandable ? 'pointer' : 'default',
          fontFamily: SERIF,
          fontSize: FONT_BODY,
          color: INK,
        }}
      >
        <b>{entry?.name}</b>
        {expandable && (
          <span style={{ fontSize: FONT_SMALL, color: INK_SOFT }}>
            {' '}
            {open ? '▴' : '▾'}
          </span>
        )}
        <div style={{ fontSize: FONT_SMALL, color: INK_SOFT }}>{entry?.desc}</div>
      </button>
      <span style={{ textAlign: 'right', color: INK }}>
        {formatMammon(row.price)}m
      </span>
      <span
        style={{
          fontSize: FONT_SMALL,
          color: row.stock > 0 ? INK_SOFT : INK_FAINT,
        }}
      >
        {row.stock} of {entry?.daily_stock} left today
      </span>
      <button
        type="button"
        disabled={!!row.blocker}
        title={row.blocker || undefined}
        onClick={props.onCommission}
        style={{
          ...inkButtonStyle({ color: SEAL_AMBER, disabled: !!row.blocker }),
          width: '100%',
        }}
      >
        Commission
      </button>
      {open && contents && contents.length > 0 && (
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
          {contents.map((item, j) => (
            <span key={j}>
              {capitalize(item.name)}
              {item.count > 1 ? ` ×${item.count}` : ''}
            </span>
          ))}
        </div>
      )}
    </div>
  );
};

const OrderLine = (props: { order: CommissionOrder }) => {
  return (
    <div style={{ display: 'flex', gap: '8px', padding: '2px 0' }}>
      <span style={{ color: INK }}>{props.order.name}</span>
      <span style={{ marginLeft: 'auto', fontSize: FONT_SMALL, color: INK_SOFT }}>
        arrives in <MinutesLeft seconds={props.order.seconds_left} />
      </span>
    </div>
  );
};

export const CommissionsView = (props: { data: Data }) => {
  const { act } = useBackend<Data>();
  const { kits, local, orders } = props.data.commissions;
  const catalog = props.data.commission_catalog;
  const lead_minutes = props.data.commission_lead_minutes;
  const [open, setOpen] = useState<Record<string, boolean>>({});
  const toggle = (ref: string) => setOpen({ ...open, [ref]: !open[ref] });

  return (
    <div>
      <div style={sectionHeaderStyle}>Special Commission</div>
      <div style={{ color: INK_SOFT, marginBottom: '8px' }}>
        Orders are delivered from the Royal Armoury {minutes(lead_minutes)}{' '}
        after a commission.
      </div>
      {kits.map((kit, i) => (
        <CommissionLine
          key={kit.ref}
          row={kit}
          entry={catalog[kit.ref]}
          first={i === 0}
          open={!!open[kit.ref]}
          onToggle={() => toggle(kit.ref)}
          onCommission={() => act('place_commission', { ref: kit.ref })}
        />
      ))}

      <div style={{ ...sectionHeaderStyle, marginTop: '16px' }}>
        Local Commission
      </div>
      <div style={{ color: INK_SOFT, marginBottom: '8px' }}>
        Delivered to the warehouse at once.
      </div>
      {(local || []).map((row, i) => (
        <CommissionLine
          key={row.ref}
          row={row}
          entry={catalog[row.ref]}
          first={i === 0}
          open={false}
          onToggle={() => undefined}
          onCommission={() => act('place_local_commission', { ref: row.ref })}
        />
      ))}

      <div style={{ ...sectionHeaderStyle, marginTop: '16px' }}>On Order</div>
      {orders.length ? (
        orders.map((order, i) => <OrderLine key={i} order={order} />)
      ) : (
        <div style={{ color: INK_FAINT, fontStyle: 'italic' }}>
          Nothing on order.
        </div>
      )}
    </div>
  );
};
