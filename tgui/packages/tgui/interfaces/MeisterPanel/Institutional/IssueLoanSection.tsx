import { useState } from 'react';

import {
  BUTTON_BG,
  fieldLabelStyle,
  fieldRowStyle,
  fieldValueStyle,
  INK_FAINT,
  inkButtonStyle,
  inkInputStyle,
  SEAL_AMBER,
  sectionHeaderStyle,
  tabBarStyle,
  tabStyle,
} from '../../common/parchment';
import type { FundEntry, TabProps } from '../types';

type LoanTier = 'personal' | 'indenture';

const TERM_OPTIONS: number[] = [1, 2, 3];
const RATE_OPTIONS: number[] = [10, 15, 20, 25, 50];

export const IssueLoanSection = ({
  fund,
  data,
  act,
}: TabProps & { fund: FundEntry }) => {
  const [tier, setTier] = useState<LoanTier>('personal');
  const [amount, setAmount] = useState<string>('');
  const [term, setTerm] = useState<number>(2);
  const [rate, setRate] = useState<number>(25);
  const rateOptions = fund.allow_zero_rate
    ? [0, ...RATE_OPTIONS]
    : RATE_OPTIONS;
  const indentureTargets = data.funds.filter(
    (f) => f.id !== fund.id && f.supports_loans,
  );
  const [target, setTarget] = useState<string>(indentureTargets[0]?.id ?? '');

  const numeric = parseInt(amount, 10) || 0;
  const pastWindow = data.day > data.max_issuance_day;
  const personalValid = numeric >= 50 && numeric <= 500;
  const indentureValid = numeric >= 501 && numeric <= 2000;
  const targetValid = tier === 'personal' || target !== '';
  const valid =
    (tier === 'personal' ? personalValid : indentureValid) && targetValid;
  const disabled = pastWindow || !valid;

  return (
    <>
      <div style={sectionHeaderStyle}>Draft a Loan</div>
      {pastWindow && (
        <div style={{ color: INK_FAINT, marginBottom: 8 }}>
          New loans may not be drawn after day {data.max_issuance_day}.
        </div>
      )}
      <div style={tabBarStyle}>
        <div
          style={tabStyle(tier === 'personal')}
          onClick={() => setTier('personal')}
        >
          Personal
        </div>
        <div
          style={tabStyle(tier === 'indenture')}
          onClick={() => setTier('indenture')}
        >
          Indenture
        </div>
      </div>

      {tier === 'indenture' && (
        <>
          <div
            style={{
              color: SEAL_AMBER,
              textAlign: 'center',
              marginBottom: 10,
            }}
          >
            Indentures are publicly proclaimed upon acceptance and upon default.
            The whole realm will hear.
          </div>
          <div style={fieldRowStyle}>
            <div style={fieldLabelStyle}>Target</div>
            <div style={fieldValueStyle}>
              {indentureTargets.length ? (
                indentureTargets.map((t) => (
                  <button
                    type="button"
                    key={t.id}
                    style={{
                      ...inkButtonStyle({}),
                      marginRight: 4,
                      fontWeight: target === t.id ? 'bold' : 'normal',
                      background:
                        target === t.id ? 'var(--p-tab-active-bg)' : BUTTON_BG,
                    }}
                    onClick={() => setTarget(t.id)}
                  >
                    {t.label}
                  </button>
                ))
              ) : (
                <span style={{ color: INK_FAINT, fontStyle: 'italic' }}>
                  No target institutions available.
                </span>
              )}
            </div>
          </div>
        </>
      )}

      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>Principal</div>
        <div style={fieldValueStyle}>
          <input
            type="number"
            min={tier === 'personal' ? 50 : 501}
            max={tier === 'personal' ? 500 : 2000}
            value={amount}
            onChange={(e) => setAmount(e.target.value)}
            style={{ ...inkInputStyle, width: 110 }}
          />
          <span style={{ marginLeft: 6, color: INK_FAINT }}>
            {tier === 'personal' ? '(50 - 500m)' : '(501 - 2000m)'}
          </span>
        </div>
      </div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>Term</div>
        <div style={fieldValueStyle}>
          {TERM_OPTIONS.map((t) => (
            <button
              type="button"
              key={t}
              style={{
                ...inkButtonStyle({}),
                marginRight: 4,
                fontWeight: term === t ? 'bold' : 'normal',
                background: term === t ? 'var(--p-tab-active-bg)' : BUTTON_BG,
              }}
              onClick={() => setTerm(t)}
            >
              {t} day{t > 1 ? 's' : ''}
            </button>
          ))}
        </div>
      </div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>Rate</div>
        <div style={fieldValueStyle}>
          {rateOptions.map((r) => (
            <button
              type="button"
              key={r}
              style={{
                ...inkButtonStyle({}),
                marginRight: 4,
                fontWeight: rate === r ? 'bold' : 'normal',
                background: rate === r ? 'var(--p-tab-active-bg)' : BUTTON_BG,
              }}
              onClick={() => setRate(r)}
            >
              {r}%
            </button>
          ))}
        </div>
      </div>
      <div style={{ marginTop: 6, textAlign: 'right' }}>
        <button
          type="button"
          style={inkButtonStyle({ disabled })}
          disabled={disabled}
          onClick={() => {
            act(tier === 'personal' ? 'issue_personal' : 'issue_indenture', {
              fund_id: fund.id,
              amount: numeric,
              term,
              rate,
              target: tier === 'indenture' ? target : undefined,
            });
            setAmount('');
          }}
        >
          Stamp Writ
        </button>
      </div>
    </>
  );
};
