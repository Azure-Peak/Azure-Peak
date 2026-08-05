import { useState } from 'react';

import {
  cardStyle,
  fieldLabelStyle,
  fieldRowStyle,
  fieldValueStyle,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  inkInputStyle,
  sectionHeaderStyle,
} from '../common/parchment';
import type { TabProps } from './types';

export const PollTaxTab = ({ data, act }: TabProps) => {
  const [days, setDays] = useState<string>('');
  const tax = data.poll_tax;
  const taxStatic = data.poll_tax_static;
  const taxUser = data.poll_tax_user;
  const numericDays = parseInt(days, 10) || 0;

  const effectiveRate = tax.rate > 0 ? tax.rate : taxStatic.fallback_rate;
  const presumed = tax.rate <= 0;
  const capRemaining = taxStatic.max_advance_days - tax.advance_days_held;
  const affordable = Math.floor(
    data.account_balance / Math.max(1, effectiveRate),
  );
  const maxDays = Math.min(capRemaining, affordable);

  let rateLine = `${tax.rate}m per day`;
  if (tax.exempt) {
    rateLine = 'Exempt by decree';
  } else if (tax.rate < 0) {
    rateLine = `Crown subsidises ${-tax.rate}m per day`;
  } else if (tax.rate === 0) {
    rateLine = `None levied (advance at presumed ${taxStatic.fallback_rate}m/day)`;
  }

  const advanceBlocked =
    !taxUser.category ||
    tax.exempt ||
    tax.rate < 0 ||
    capRemaining <= 0 ||
    affordable <= 0;
  const submitDisabled =
    advanceBlocked || numericDays < 1 || numericDays > maxDays;

  return (
    <div style={cardStyle}>
      <div style={sectionHeaderStyle}>Poll Tax</div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>Class</div>
        <div style={fieldValueStyle}>
          {taxUser.category_label || 'No taxable class'}
        </div>
      </div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>Rate</div>
        <div style={fieldValueStyle}>{rateLine}</div>
      </div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>Held in advance</div>
        <div style={fieldValueStyle}>
          {tax.advance_days_held} day
          {tax.advance_days_held === 1 ? '' : 's'} (cap{' '}
          {taxStatic.max_advance_days})
        </div>
      </div>

      {!!tax.exempt && (
        <div style={{ color: INK_SOFT, marginTop: 8 }}>
          You owe nothing. There is nothing to advance.
        </div>
      )}

      {!advanceBlocked && (
        <>
          <div style={sectionHeaderStyle}>Advance</div>
          <div style={fieldRowStyle}>
            <div style={fieldLabelStyle}>Days</div>
            <div style={fieldValueStyle}>
              <input
                type="number"
                min={1}
                max={maxDays}
                value={days}
                onChange={(e) => setDays(e.target.value)}
                style={{ ...inkInputStyle, width: 90 }}
              />
              <span style={{ marginLeft: 6, color: INK_FAINT }}>
                (max {maxDays}; {numericDays * effectiveRate}m
                {presumed ? ' presumed' : ''})
              </span>
            </div>
          </div>
          <div style={{ marginTop: 6, textAlign: 'right' }}>
            <button
              type="button"
              style={inkButtonStyle({ disabled: submitDisabled })}
              disabled={submitDisabled}
              onClick={() => {
                act('advance_poll_tax', { days: numericDays });
                setDays('');
              }}
            >
              Pay Forward
            </button>
          </div>
        </>
      )}
    </div>
  );
};
