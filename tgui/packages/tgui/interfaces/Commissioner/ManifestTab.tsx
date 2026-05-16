import { useState } from 'react';
import { Input } from 'tgui-core/components';

import {
  cardStyle,
  fieldRowStyle,
  INK,
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

export const ManifestTab = (props: {
  data: CommissionerData;
  act: ActFn;
  canRead: boolean;
}) => {
  const { data, act, canRead } = props;
  const lines = data.manifest;
  const total = data.manifest_total;
  const deposit = data.my_deposit;
  const canSubmit = lines.length > 0 && deposit >= total && total > 0;
  const shortfall = total - deposit;
  const [note, setNote] = useState('');

  if (lines.length === 0) {
    return (
      <>
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
              <div style={{ fontSize: '13px', color: INK }}>
                {starsIf(line.name, canRead)}
              </div>
              <div
                style={{
                  fontSize: '10px',
                  fontStyle: 'italic',
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
                fontSize: '11px',
                fontStyle: 'italic',
              }}
            >
              {line.unit_price}m each
            </div>
            <button
              type="button"
              style={inkButtonStyle()}
              onClick={() =>
                act('manifest_dec', { ref: line.ref, delta: 1 })
              }
            >
              -
            </button>
            <span
              style={{
                flex: '0 0 32px',
                textAlign: 'center',
                fontSize: '13px',
                color: INK,
                fontWeight: 'bold',
              }}
            >
              {line.qty}
            </span>
            <button
              type="button"
              style={inkButtonStyle()}
              onClick={() =>
                act('manifest_inc', { ref: line.ref, delta: 1 })
              }
            >
              +
            </button>
            <div
              style={{
                flex: '0 0 60px',
                textAlign: 'right',
                fontSize: '13px',
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
            fontVariant: 'small-caps',
            color: SEAL_AMBER,
            fontStyle: 'italic',
          }}
        >
          Manifest Total
        </div>
        <div
          style={{
            fontFamily: SERIF,
            fontSize: '14px',
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
            fontVariant: 'small-caps',
            color: SEAL_AMBER,
            fontStyle: 'italic',
          }}
        >
          Deposit Held
        </div>
        <div
          style={{
            fontFamily: SERIF,
            fontSize: '14px',
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
            fontSize: '12px',
            color: SEAL_RED,
          }}
        >
          Insert {shortfall}m more in coin to submit this commission.
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
            fontSize: '11px',
            fontStyle: 'italic',
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
          fontSize: '12px',
          color: INK_SOFT,
        }}
      >
        Insert coins into the machine to build your deposit. Posting locks the
        coin in escrow; the smith collects it on completion.
      </div>
    </>
  );
};
