import { useState } from 'react';

import {
  FONT_BODY,
  fieldLabelStyle,
  fieldRowStyle,
  fieldValueStyle,
  INK_FAINT,
  inkButtonStyle,
  inkInputStyle,
  SEAL_AMBER,
  sectionHeaderStyle,
} from '../../common/parchment';
import type { FundEntry, TabProps } from '../types';

export const WithdrawSection = ({
  fund,
  balance,
  act,
}: {
  fund: FundEntry;
  balance: number;
  act: TabProps['act'];
}) => {
  const [amount, setAmount] = useState<string>('');
  const numeric = parseInt(amount, 10) || 0;
  const disabled = numeric <= 0 || numeric > balance;

  return (
    <>
      <div style={sectionHeaderStyle}>Direct Withdrawal</div>
      {!!fund.withdraw_rule && (
        <div
          style={{
            color: SEAL_AMBER,
            marginBottom: 8,
            fontSize: FONT_BODY,
          }}
        >
          {fund.withdraw_rule}
        </div>
      )}
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>Amount</div>
        <div style={fieldValueStyle}>
          <input
            type="number"
            min={1}
            max={balance}
            value={amount}
            onChange={(e) => setAmount(e.target.value)}
            style={{ ...inkInputStyle, width: 110 }}
          />
          <span style={{ marginLeft: 6, color: INK_FAINT }}>mammon</span>
        </div>
      </div>
      <div style={{ marginTop: 6, textAlign: 'right' }}>
        <button
          type="button"
          style={inkButtonStyle({ disabled })}
          disabled={disabled}
          onClick={() => {
            act('withdraw_institutional', {
              fund_id: fund.id,
              amount: numeric,
            });
            setAmount('');
          }}
        >
          Draw Coin
        </button>
      </div>
    </>
  );
};
