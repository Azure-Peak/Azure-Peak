import { useState } from 'react';

import { type RoutedActFunctionType, useBackend } from '../backend';
import { Window } from '../layouts';
import {
  cardStyle,
  fieldLabelStyle,
  fieldRowStyle,
  fieldValueStyle,
  INK_FAINT,
  inkButtonStyle,
  pageStyle,
  rulerStyle,
  SEAL_AMBER,
  sectionHeaderStyle,
  subtitleStyle,
  tabBarStyle,
  tabStyle,
  titleStyle,
} from './common/parchment';

type Data = {
  fund_name: string;
  fund_id: string;
  faction_label: string;
  bash_floor: number;
  balance: number;
  can_withdraw: boolean;
  can_issue_loan: boolean;
  can_accept_indenture: boolean;
  day: number;
  max_issuance_day: number;
};

type TabKey = 'withdraw' | 'issue';
type LoanTier = 'personal' | 'indenture';

type TabProps = {
  data: Data;
  act: RoutedActFunctionType;
};

export const JawbankPanel = () => {
  const { data, act } = useBackend<Data>();
  const [tab, setTab] = useState<TabKey>('withdraw');

  return (
    <Window title="Jawbank Ledger" width={520} height={520} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>{data.fund_name}</div>
          <div style={subtitleStyle}>
            Day {data.day} &middot; Holdings:{' '}
            <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
              {data.balance}m
            </span>
          </div>
          <hr style={rulerStyle} />

          <div style={tabBarStyle}>
            <div
              style={tabStyle(tab === 'withdraw')}
              onClick={() => setTab('withdraw')}
            >
              Withdraw
            </div>
            <div
              style={tabStyle(tab === 'issue')}
              onClick={() => setTab('issue')}
            >
              Issue Loan
            </div>
          </div>

          {tab === 'withdraw' && (
            <WithdrawTab data={data} act={act} />
          )}
          {tab === 'issue' && (
            <IssueTab data={data} act={act} />
          )}
        </div>
      </Window.Content>
    </Window>
  );
};

const WithdrawTab = ({ data, act }: TabProps) => {
  const [amount, setAmount] = useState<string>('');
  const numericAmount = parseInt(amount, 10) || 0;
  const disabled =
    !data.can_withdraw || numericAmount <= 0 || numericAmount > data.balance;

  return (
    <div style={cardStyle}>
      <div style={sectionHeaderStyle}>Direct Withdrawal</div>
      {!data.can_withdraw && (
        <div style={{ color: INK_FAINT, fontStyle: 'italic', marginBottom: 8 }}>
          Withdrawal is not available to you at this jawbank.
        </div>
      )}
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>Reserve</div>
        <div style={fieldValueStyle}>{data.bash_floor}m kept by force</div>
      </div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>Amount</div>
        <div style={fieldValueStyle}>
          <input
            type="number"
            min={1}
            max={data.balance}
            value={amount}
            onChange={(e) => setAmount(e.target.value)}
            style={{ width: 110 }}
          />
          <span style={{ marginLeft: 6, color: INK_FAINT }}>mammon</span>
        </div>
      </div>
      <div style={{ marginTop: 10, textAlign: 'right' }}>
        <button
          style={inkButtonStyle({ disabled })}
          disabled={disabled}
          onClick={() => {
            act('withdraw', { amount: numericAmount });
            setAmount('');
          }}
        >
          Draw Coin
        </button>
      </div>
    </div>
  );
};

const TERM_OPTIONS: number[] = [1, 2, 3];
const RATE_OPTIONS: number[] = [10, 15, 20, 25, 50];

const IssueTab = ({ data, act }: TabProps) => {
  const [tier, setTier] = useState<LoanTier>('personal');
  const [amount, setAmount] = useState<string>('');
  const [term, setTerm] = useState<number>(2);
  const [rate, setRate] = useState<number>(25);

  const numericAmount = parseInt(amount, 10) || 0;
  const past_window = data.day > data.max_issuance_day;
  const personalValid = numericAmount >= 50 && numericAmount <= 500;
  const indentureValid = numericAmount >= 501 && numericAmount <= 2000;
  const valid = tier === 'personal' ? personalValid : indentureValid;
  const disabled = !data.can_issue_loan || past_window || !valid;

  return (
    <div style={cardStyle}>
      <div style={sectionHeaderStyle}>Draft a Writ</div>
      {past_window && (
        <div style={{ color: INK_FAINT, fontStyle: 'italic', marginBottom: 8 }}>
          New writs may not be drawn after day {data.max_issuance_day}.
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
        <div
          style={{
            color: SEAL_AMBER,
            fontStyle: 'italic',
            textAlign: 'center',
            marginBottom: 10,
          }}
        >
          Indentures are publicly proclaimed upon acceptance and upon default.
          The whole realm will hear.
        </div>
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
            style={{ width: 110 }}
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
              key={t}
              style={{
                ...inkButtonStyle({}),
                marginRight: 4,
                fontWeight: term === t ? 'bold' : 'normal',
                background:
                  term === t ? 'rgba(200,170,100,0.4)' : 'rgba(255,248,220,0.6)',
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
          {RATE_OPTIONS.map((r) => (
            <button
              key={r}
              style={{
                ...inkButtonStyle({}),
                marginRight: 4,
                fontWeight: rate === r ? 'bold' : 'normal',
                background:
                  rate === r ? 'rgba(200,170,100,0.4)' : 'rgba(255,248,220,0.6)',
              }}
              onClick={() => setRate(r)}
            >
              {r}%
            </button>
          ))}
        </div>
      </div>

      <div style={{ marginTop: 10, textAlign: 'right' }}>
        <button
          style={inkButtonStyle({ disabled })}
          disabled={disabled}
          onClick={() => {
            act(tier === 'personal' ? 'issue_personal' : 'issue_indenture', {
              amount: numericAmount,
              term,
              rate,
            });
            setAmount('');
          }}
        >
          Stamp Writ
        </button>
      </div>
    </div>
  );
};
