import { useState } from 'react';

import {
  BUTTON_BG,
  cardStyle,
  fieldLabelStyle,
  fieldRowStyle,
  fieldValueStyle,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  inkInputStyle,
  SEAL_AMBER,
  SEAL_RED,
  sectionHeaderStyle,
} from '../common/parchment';
import type { TabProps } from './types';
import { formatMammon } from '../common/format';

const DENOMS = [
  { id: 'GOLD', label: 'Gold', value: 10 },
  { id: 'SILVER', label: 'Silver', value: 5 },
  { id: 'BRONZE', label: 'Bronze', value: 1 },
];

const toCents = (n: number) => Math.round(n * 100) / 100;

export const PersonalTab = ({ data, act }: TabProps) => {
  const [denom, setDenom] = useState<string>('GOLD');
  const [coinAmount, setCoinAmount] = useState<string>('');
  const [repayAmount, setRepayAmount] = useState<string>('');

  const numericCoins = parseInt(coinAmount, 10) || 0;
  const denomMod = DENOMS.find((d) => d.id === denom)?.value ?? 1;
  const totalDraw = numericCoins * denomMod;
  const drawDisabled =
    numericCoins < 1 || numericCoins > 20 || totalDraw > data.account_balance;

  const numericRepay = toCents(parseFloat(repayAmount) || 0);
  const loan = data.active_loan;
  const repayCap = loan
    ? toCents(Math.min(loan.remaining, data.account_balance))
    : 0;
  const repayDisabled = !loan || numericRepay <= 0 || numericRepay > repayCap;

  return (
    <div style={cardStyle}>
      <div style={sectionHeaderStyle}>Personal Account</div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>Balance</div>
        <div style={fieldValueStyle}>
          <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
            {formatMammon(data.account_balance)}m
          </span>
        </div>
      </div>

      <div style={sectionHeaderStyle}>Withdraw Coin</div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>Denomination</div>
        <div style={fieldValueStyle}>
          {DENOMS.map((d) => (
            <button
              type="button"
              key={d.id}
              style={{
                ...inkButtonStyle({}),
                marginRight: 4,
                fontWeight: denom === d.id ? 'bold' : 'normal',
                background:
                  denom === d.id ? 'var(--p-tab-active-bg)' : BUTTON_BG,
              }}
              onClick={() => setDenom(d.id)}
            >
              {d.label} ({d.value}m)
            </button>
          ))}
        </div>
      </div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>Coins</div>
        <div style={fieldValueStyle}>
          <input
            type="number"
            min={1}
            max={20}
            value={coinAmount}
            onChange={(e) => setCoinAmount(e.target.value)}
            style={{ ...inkInputStyle, width: 90 }}
          />
          <span style={{ marginLeft: 6, color: INK_FAINT }}>
            (max 20; total {totalDraw}m)
          </span>
        </div>
      </div>
      <div style={{ marginTop: 6, textAlign: 'right' }}>
        <button
          type="button"
          style={inkButtonStyle({ disabled: drawDisabled })}
          disabled={drawDisabled}
          onClick={() => {
            act('withdraw_personal', {
              denomination: denom,
              amount: numericCoins,
            });
            setCoinAmount('');
          }}
        >
          Withdraw
        </button>
      </div>

      <div style={sectionHeaderStyle}>Active Loan</div>
      {!loan && (
        <div style={{ color: INK_SOFT }}>
          No outstanding loan on your record.
        </div>
      )}
      {!!loan && (
        <>
          <div style={fieldRowStyle}>
            <div style={fieldLabelStyle}>Creditor</div>
            <div style={fieldValueStyle}>{loan.creditor}</div>
          </div>
          <div style={fieldRowStyle}>
            <div style={fieldLabelStyle}>Owed</div>
            <div style={fieldValueStyle}>
              {formatMammon(loan.remaining)}m of {loan.principal}m principal
              at {loan.interest_pct}%/day
            </div>
          </div>
          <div style={fieldRowStyle}>
            <div style={fieldLabelStyle}>Status</div>
            <div style={fieldValueStyle}>
              {loan.defaulted ? (
                <span style={{ color: SEAL_RED, fontWeight: 'bold' }}>
                  DEFAULTED on day {loan.due_on_day}
                </span>
              ) : (
                <span>
                  Due day {loan.due_on_day} ({loan.days_until_due} day
                  {loan.days_until_due === 1 ? '' : 's'} remaining)
                </span>
              )}
            </div>
          </div>
          <div style={fieldRowStyle}>
            <div style={fieldLabelStyle}>Repay</div>
            <div style={fieldValueStyle}>
              <input
                type="number"
                min={0.01}
                step={0.01}
                max={repayCap}
                value={repayAmount}
                onChange={(e) => setRepayAmount(e.target.value)}
                style={{ ...inkInputStyle, width: 110 }}
              />
              <span style={{ marginLeft: 6, color: INK_FAINT }}>mammon</span>
              <button
                type="button"
                style={{
                  ...inkButtonStyle({ disabled: repayCap <= 0 }),
                  marginLeft: 6,
                }}
                disabled={repayCap <= 0}
                onClick={() => setRepayAmount(formatMammon(repayCap))}
              >
                All
              </button>
            </div>
          </div>
          <div style={{ marginTop: 6, textAlign: 'right' }}>
            <button
              type="button"
              style={inkButtonStyle({ disabled: repayDisabled })}
              disabled={repayDisabled}
              onClick={() => {
                act('repay_loan', { amount: numericRepay });
                setRepayAmount('');
              }}
            >
              Repay
            </button>
          </div>
        </>
      )}
    </div>
  );
};
