import { useState } from 'react';
import { Input } from 'tgui-core/components';

import {
  cardStyle,
  FONT_BODY,
  fieldRowStyle,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
} from '../common/parchment';
import type { ActFn, CommissionerData } from './types';

const starsIf = (text: string, canRead: boolean) =>
  canRead ? text : text.replace(/[A-Za-z0-9]/g, '*');

const CapStatus = (props: { data: CommissionerData }) => {
  const { data } = props;
  const cap = data.item_cap_per_order;
  const count = data.my_manifest_items;
  const overCap = count > cap;
  return (
    <div
      style={{
        ...cardStyle,
        marginBottom: '8px',
        fontFamily: SERIF,
        fontSize: FONT_BODY,
        color: INK_FAINT,
      }}
    >
      Your manifest holds{' '}
      <b style={{ color: overCap ? SEAL_RED : INK }}>{count}</b> of {cap}{' '}
      allowed item{cap === 1 ? '' : 's'} per commission.
    </div>
  );
};

export const ManifestTab = (props: {
  data: CommissionerData;
  act: ActFn;
  canRead: boolean;
}) => {
  const { data, act, canRead } = props;
  const lines = data.manifest;
  const total = data.manifest_total;
  const deposit = data.my_deposit;
  const cap = data.item_cap_per_order;
  const itemCount = data.my_manifest_items;
  const hasActive = !!data.has_active_order;
  const overCap = itemCount > cap;
  const canSubmit =
    lines.length > 0 && deposit >= total && total > 0 && !overCap && !hasActive;
  const shortfall = total - deposit;
  const [note, setNote] = useState('');

  if (lines.length === 0) {
    return (
      <>
        <CapStatus data={data} />
        <div
          style={{
            ...cardStyle,
            textAlign: 'center',
            color: INK_SOFT,
          }}
        >
          Your manifest is empty. Browse recipes to add work to be commissioned.
        </div>
        {deposit > 0 && (
          <div
            style={{
              ...cardStyle,
              display: 'flex',
              alignItems: 'center',
              gap: '12px',
              fontFamily: SERIF,
            }}
          >
            <div style={{ flex: 1, color: INK }}>
              You have <b style={{ color: SEAL_AMBER }}>{deposit}m</b> on
              deposit, unattached to any commission.
            </div>
            <button
              type="button"
              style={inkButtonStyle()}
              onClick={() => act('refund_deposit')}
            >
              Withdraw {deposit}m
            </button>
          </div>
        )}
      </>
    );
  }

  return (
    <>
      <CapStatus data={data} />
      <div>
        {lines.map((line) => (
          <div
            key={line.ref}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '8px',
              padding: '6px 8px',
              borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
              fontFamily: SERIF,
            }}
          >
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ fontSize: FONT_BODY, color: INK }}>
                {starsIf(line.name, canRead)}
              </div>
              <div
                style={{
                  fontSize: FONT_BODY,
                  color: INK_SOFT,
                }}
              >
                {line.category}
              </div>
            </div>
            <div
              style={{
                flex: '0 0 auto',
                color: SEAL_AMBER,
                fontSize: FONT_BODY,
              }}
            >
              {line.unit_price}m each
            </div>
            <button
              type="button"
              style={inkButtonStyle()}
              onClick={() => act('manifest_dec', { ref: line.ref, delta: 1 })}
            >
              -
            </button>
            <span
              style={{
                flex: '0 0 32px',
                textAlign: 'center',
                fontSize: FONT_BODY,
                color: INK,
                fontWeight: 'bold',
              }}
            >
              {line.qty}
            </span>
            <button
              type="button"
              style={inkButtonStyle()}
              onClick={() => act('manifest_inc', { ref: line.ref, delta: 1 })}
            >
              +
            </button>
            <div
              style={{
                flex: '0 0 60px',
                textAlign: 'right',
                fontSize: FONT_BODY,
                color: SEAL_AMBER,
                fontWeight: 'bold',
              }}
            >
              {line.line_total}m
            </div>
            <button
              type="button"
              style={inkButtonStyle()}
              onClick={() => act('manifest_remove', { ref: line.ref })}
              title="Remove this line"
            >
              x
            </button>
          </div>
        ))}
      </div>

      <div
        style={{
          ...fieldRowStyle,
          marginTop: '8px',
          paddingTop: '8px',
        }}
      >
        <div
          style={{
            flex: 1,
            fontFamily: SERIF,
            color: SEAL_AMBER,
          }}
        >
          Manifest Total
        </div>
        <div
          style={{
            fontFamily: SERIF,
            fontSize: FONT_BODY,
            color: INK,
            fontWeight: 'bold',
          }}
        >
          {total}m
        </div>
      </div>
      <div style={fieldRowStyle}>
        <div
          style={{
            flex: 1,
            fontFamily: SERIF,
            color: SEAL_AMBER,
          }}
        >
          Deposit Held
        </div>
        <div
          style={{
            fontFamily: SERIF,
            fontSize: FONT_BODY,
            color: deposit >= total ? SEAL_GREEN : SEAL_RED,
            fontWeight: 'bold',
          }}
        >
          {deposit}m
        </div>
      </div>

      {!canSubmit && shortfall > 0 && (
        <div
          style={{
            marginTop: '8px',
            textAlign: 'center',
            fontSize: FONT_BODY,
            color: SEAL_RED,
          }}
        >
          Insert {shortfall}m more in coin to submit this commission.
        </div>
      )}

      {overCap && (
        <div
          style={{
            marginTop: '8px',
            textAlign: 'center',
            fontSize: FONT_BODY,
            color: SEAL_RED,
          }}
        >
          This commission asks for {itemCount} items; the cap is {cap}. Trim the
          manifest.
        </div>
      )}

      {hasActive && (
        <div
          style={{
            marginTop: '8px',
            textAlign: 'center',
            fontSize: FONT_BODY,
            color: SEAL_RED,
          }}
        >
          You already have an active commission here. Finish or cancel it before
          posting another.
        </div>
      )}

      <div
        style={{
          marginTop: '12px',
          display: 'flex',
          alignItems: 'center',
          gap: '8px',
          fontFamily: SERIF,
        }}
      >
        <span
          style={{
            fontSize: FONT_BODY,
            color: INK_SOFT,
          }}
        >
          Note to the smith (optional):
        </span>
        <Input
          value={note}
          onChange={setNote}
          placeholder="For the militia. Urgent."
          width="100%"
          maxLength={180}
        />
      </div>

      <div
        style={{
          marginTop: '12px',
          display: 'flex',
          gap: '8px',
          justifyContent: 'center',
        }}
      >
        <button
          type="button"
          style={inkButtonStyle({ disabled: !canSubmit })}
          disabled={!canSubmit}
          onClick={() => {
            act('submit_manifest', { note });
            setNote('');
          }}
        >
          Post Commission
        </button>
        <button
          type="button"
          style={inkButtonStyle({ disabled: deposit <= 0 })}
          disabled={deposit <= 0}
          onClick={() => act('refund_deposit')}
        >
          Refund Deposit
        </button>
      </div>

      <div
        style={{
          marginTop: '10px',
          textAlign: 'center',
          fontSize: FONT_BODY,
          color: INK_SOFT,
        }}
      >
        Insert coins into the machine to build your deposit. Posting locks the
        coin in escrow; the smith collects it on completion.
      </div>

      <div
        style={{
          marginTop: '6px',
          textAlign: 'center',
          fontSize: FONT_BODY,
          color: SEAL_RED,
        }}
      >
        Warning: your REAL NAME will be shown on the posted commission.
      </div>
    </>
  );
};
