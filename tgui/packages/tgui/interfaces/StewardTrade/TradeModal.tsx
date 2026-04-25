import { useEffect, useRef, useState } from 'react';

import { useBackend } from '../../backend';
import {
  badgeStyle,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  PARCHMENT,
  PARCHMENT_DEEP,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  SEAL_BLUE,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
} from '../common/parchment';
import type { Data, TradeQuote } from './types';

export type TradeModalRequest = {
  side: 'import' | 'export';
  regionId: string;
  goodId: string;
};

type TradeModalProps = {
  request: TradeModalRequest | null;
  onClose: () => void;
};

const overlayStyle: React.CSSProperties = {
  position: 'fixed',
  inset: 0,
  background: 'rgba(28, 18, 8, 0.55)',
  zIndex: 1000,
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
};

const modalStyle: React.CSSProperties = {
  width: '460px',
  maxWidth: '90vw',
  background: PARCHMENT,
  border: `3px double ${SEAL_AMBER}`,
  outline: `1px solid ${PARCHMENT_SHADOW}`,
  outlineOffset: '-6px',
  boxShadow: '0 8px 24px rgba(28, 18, 8, 0.55)',
  fontFamily: SERIF,
  color: INK,
  padding: '20px 24px',
};

const headerStyle: React.CSSProperties = {
  textAlign: 'center',
  fontVariant: 'small-caps',
  letterSpacing: '4px',
  fontSize: '18px',
  fontWeight: 'bold',
  color: INK,
  borderBottom: `1px solid ${INK_FAINT}`,
  paddingBottom: '4px',
  marginBottom: '12px',
};

const stepperRowStyle: React.CSSProperties = {
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  gap: '8px',
  margin: '12px 0',
};

const stepperButtonStyle = (disabled: boolean): React.CSSProperties => ({
  fontFamily: SERIF,
  fontSize: '20px',
  fontWeight: 'bold',
  width: '32px',
  height: '32px',
  border: `1px solid ${INK_SOFT}`,
  background: disabled ? 'transparent' : PARCHMENT_DEEP,
  color: disabled ? INK_FAINT : INK,
  borderRadius: '2px',
  cursor: disabled ? 'default' : 'pointer',
  opacity: disabled ? 0.5 : 1,
});

const quantityInputStyle: React.CSSProperties = {
  fontFamily: SERIF,
  fontSize: '20px',
  fontWeight: 'bold',
  textAlign: 'center',
  width: '64px',
  height: '32px',
  padding: 0,
  border: `1px solid ${INK_SOFT}`,
  background: PARCHMENT_DEEP,
  color: INK,
  borderRadius: '2px',
  MozAppearance: 'textfield',
  WebkitAppearance: 'none',
  appearance: 'textfield',
};

const lineStyle: React.CSSProperties = {
  display: 'flex',
  justifyContent: 'space-between',
  alignItems: 'baseline',
  padding: '3px 0',
  fontSize: '13px',
};

const lineLabelStyle: React.CSSProperties = {
  color: INK_SOFT,
  fontStyle: 'italic',
};

const lineValueStyle: React.CSSProperties = {
  color: INK,
  fontWeight: 'bold',
};

const totalLineStyle: React.CSSProperties = {
  ...lineStyle,
  borderTop: `1px solid ${INK_FAINT}`,
  marginTop: '4px',
  paddingTop: '6px',
  fontSize: '15px',
};

const warningStyle: React.CSSProperties = {
  fontSize: '11px',
  fontStyle: 'italic',
  textAlign: 'center',
  marginTop: '8px',
};

const footerStyle: React.CSSProperties = {
  display: 'flex',
  justifyContent: 'flex-end',
  gap: '8px',
  marginTop: '16px',
};

const QUOTE_DEBOUNCE_MS = 120;

export const TradeModal = (props: TradeModalProps) => {
  const { request, onClose } = props;
  const { act, data } = useBackend<Data>();
  const [quantity, setQuantity] = useState(1);
  const debounceRef = useRef<number | null>(null);
  const lastQuoteRef = useRef<TradeQuote | null>(null);

  useEffect(() => {
    if (!request) {
      lastQuoteRef.current = null;
      return;
    }
    setQuantity(1);
    lastQuoteRef.current = null;
  }, [request]);

  useEffect(() => {
    if (!request) return;
    if (debounceRef.current !== null) {
      window.clearTimeout(debounceRef.current);
    }
    debounceRef.current = window.setTimeout(() => {
      act('trade_quote', {
        side: request.side,
        region_id: request.regionId,
        good_id: request.goodId,
        quantity,
      });
    }, QUOTE_DEBOUNCE_MS);
    return () => {
      if (debounceRef.current !== null) {
        window.clearTimeout(debounceRef.current);
      }
    };
  }, [request, quantity, act]);

  if (!request) return null;

  const incoming: TradeQuote | null =
    data.trade_quote &&
    data.trade_quote.region_id === request.regionId &&
    data.trade_quote.good_id === request.goodId &&
    data.trade_quote.side === request.side
      ? data.trade_quote
      : null;
  if (incoming) {
    lastQuoteRef.current = incoming;
  }
  const quote = lastQuoteRef.current;

  const close = () => {
    act('trade_quote_close');
    onClose();
  };

  const confirm = () => {
    act(request.side === 'import' ? 'trade_import' : 'trade_export', {
      region_id: request.regionId,
      good_id: request.goodId,
      quantity,
    });
    onClose();
  };

  const maxUnits = quote?.max_units ?? 50;
  const isImport = request.side === 'import';
  const sideLabel = isImport ? 'Import' : 'Export';
  const blockaded = !!quote?.is_blockaded;
  const escalation = quote?.escalation_subtotal ?? 0;
  const hasEscalation = escalation > 0;
  const escalationColor = isImport ? SEAL_RED : SEAL_RED;
  const submitDisabled =
    !quote ||
    !quote.ok ||
    (isImport && !quote.can_afford) ||
    !quote.warrant_ok;
  const submitTooltip = !quote
    ? 'Calculating...'
    : !quote.ok
      ? quote.reason
      : isImport && !quote.can_afford
        ? 'Treasury cannot cover this trade.'
        : !quote.warrant_ok
          ? "Warrant cannot cover this trade."
          : '';

  const change = (delta: number) => {
    setQuantity((q) => Math.max(1, Math.min(maxUnits, q + delta)));
  };

  return (
    <div style={overlayStyle} onClick={close}>
      <div style={modalStyle} onClick={(e) => e.stopPropagation()}>
        <div style={headerStyle}>
          {sideLabel} {quote?.good_name ?? '...'}
        </div>
        <div style={{ ...lineStyle, justifyContent: 'center', fontSize: '12px', color: INK_SOFT, marginBottom: '4px' }}>
          {isImport ? 'from' : 'to'} {quote?.region_name ?? request.regionId}
          {blockaded && <span style={badgeStyle(SEAL_RED)}>BLOCKADED</span>}
        </div>

        <div style={stepperRowStyle}>
          <button
            type="button"
            style={stepperButtonStyle(quantity <= 1)}
            disabled={quantity <= 1}
            onClick={() => change(-10)}
            title="-10"
          >
            «
          </button>
          <button
            type="button"
            style={stepperButtonStyle(quantity <= 1)}
            disabled={quantity <= 1}
            onClick={() => change(-1)}
          >
            -
          </button>
          <input
            type="number"
            style={quantityInputStyle}
            value={quantity}
            min={1}
            max={maxUnits}
            onChange={(e) => {
              const n = parseInt(e.target.value, 10);
              if (!isNaN(n)) {
                setQuantity(Math.max(1, Math.min(maxUnits, n)));
              }
            }}
          />
          <button
            type="button"
            style={stepperButtonStyle(quantity >= maxUnits)}
            disabled={quantity >= maxUnits}
            onClick={() => change(1)}
          >
            +
          </button>
          <button
            type="button"
            style={stepperButtonStyle(quantity >= maxUnits)}
            disabled={quantity >= maxUnits}
            onClick={() => change(10)}
            title="+10"
          >
            »
          </button>
        </div>

        <div style={{ ...lineStyle, fontSize: '11px', color: INK_FAINT, justifyContent: 'center' }}>
          (max {maxUnits} units per trade)
        </div>

        <div
          style={{
            fontSize: '11px',
            color: INK_FAINT,
            fontStyle: 'italic',
            textAlign: 'center',
            margin: '6px 0 4px',
            minHeight: '30px',
            lineHeight: '1.35',
          }}
        >
          {quote ? (
            isImport ? (
              <>
                {quote.capacity_today} unit{quote.capacity_today === 1 ? '' : 's'} available
                at base price today.
                <br />
                Buying past that drives the price up the more you take.
              </>
            ) : (
              <>
                {quote.capacity_today} unit{quote.capacity_today === 1 ? '' : 's'} of demand
                left today.
                <br />
                Selling past that floods the market and the price drops.
              </>
            )
          ) : (
            '...'
          )}
        </div>

        <div style={{ marginTop: '6px' }}>
          <div style={lineStyle}>
            <span style={lineLabelStyle}>Units within capacity</span>
            <span style={lineValueStyle}>
              {quote
                ? `${Math.min(quote.quantity, quote.capacity_today)} / ${quote.quantity}`
                : '...'}
            </span>
          </div>
          <div style={lineStyle}>
            <span style={lineLabelStyle}>Units past capacity</span>
            <span
              style={{
                ...lineValueStyle,
                color: hasEscalation ? escalationColor : INK,
              }}
            >
              {quote
                ? `${Math.max(0, quote.quantity - quote.capacity_today)}`
                : '...'}
            </span>
          </div>
          <div style={lineStyle}>
            <span style={lineLabelStyle}>Base unit price</span>
            <span style={lineValueStyle}>
              {quote ? `${quote.base_unit_price}m / unit` : '...'}
            </span>
          </div>
          <div style={lineStyle}>
            <span style={lineLabelStyle}>Base subtotal</span>
            <span style={lineValueStyle}>
              {quote ? `${quote.base_subtotal}m` : '...'}
            </span>
          </div>
          <div
            style={{
              ...lineStyle,
              visibility: hasEscalation ? 'visible' : 'hidden',
            }}
          >
            <span style={{ ...lineLabelStyle, color: escalationColor, fontWeight: 'bold' }}>
              {isImport ? 'Escalation surcharge' : 'Revenue lost to oversupply'}
            </span>
            <span style={{ ...lineValueStyle, color: escalationColor }}>
              {isImport ? '+' : '-'}{escalation}m
            </span>
          </div>
          <div style={totalLineStyle}>
            <span style={{ ...lineLabelStyle, color: INK, fontStyle: 'normal', fontWeight: 'bold' }}>
              {isImport ? 'Total cost' : 'Total revenue'}
            </span>
            <span style={{ ...lineValueStyle, color: SEAL_AMBER, fontSize: '17px' }}>
              {quote ? `${quote.total}m` : '...'}
            </span>
          </div>
          <div style={lineStyle}>
            <span style={lineLabelStyle}>Crown's Purse after</span>
            <span
              style={{
                ...lineValueStyle,
                color: !quote
                  ? INK
                  : isImport
                    ? quote.can_afford
                      ? INK
                      : SEAL_RED
                    : SEAL_GREEN,
              }}
            >
              {quote ? `${quote.balance_after}m` : '...'}
            </span>
          </div>
          <div
            style={{
              ...lineStyle,
              visibility:
                quote && quote.is_alderman_acting && quote.warrant_remaining >= 0
                  ? 'visible'
                  : 'hidden',
            }}
          >
            <span style={lineLabelStyle}>Warrant remaining</span>
            <span
              style={{
                ...lineValueStyle,
                color: quote?.warrant_ok ? SEAL_AMBER : SEAL_RED,
              }}
            >
              {quote && quote.warrant_remaining >= 0
                ? `${quote.warrant_remaining}m`
                : '0m'}
            </span>
          </div>
        </div>

        <div style={{ minHeight: '34px', marginTop: '6px' }}>
          {blockaded && (
            <div style={{ ...warningStyle, color: SEAL_RED }}>
              This route is blockaded. {isImport ? 'Cost is doubled.' : 'Revenue is halved.'}
            </div>
          )}
        </div>

        <div style={footerStyle}>
          <button
            type="button"
            style={inkButtonStyle({ color: INK_SOFT })}
            onClick={close}
          >
            Cancel
          </button>
          <button
            type="button"
            style={inkButtonStyle({
              color: isImport ? SEAL_BLUE : SEAL_GREEN,
              disabled: submitDisabled,
            })}
            disabled={submitDisabled}
            title={submitTooltip}
            onClick={confirm}
          >
            Confirm {sideLabel}
          </button>
        </div>
      </div>
    </div>
  );
};
