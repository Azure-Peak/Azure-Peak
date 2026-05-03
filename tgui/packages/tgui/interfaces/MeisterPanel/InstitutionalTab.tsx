import { useState } from 'react';

import {
  cardStyle,
  fieldLabelStyle,
  fieldRowStyle,
  fieldValueStyle,
  INK_FAINT,
  inkButtonStyle,
  SEAL_AMBER,
  sectionHeaderStyle,
  tabBarStyle,
  tabStyle,
} from '../common/parchment';
import { PaginatedLog } from './PaginatedLog';
import { type FundEntry, type TabProps } from './types';

type LoanTier = 'personal' | 'indenture';

const TERM_OPTIONS: number[] = [1, 2, 3];
const RATE_OPTIONS: number[] = [10, 15, 20, 25, 50];

export const InstitutionalTab = ({ data, act }: TabProps) => {
  const accessibleFunds = data.funds.filter(
    (f) => f.can_issue || f.can_withdraw || f.can_view,
  );
  const [selectedFundId, setSelectedFundId] = useState<string>(
    accessibleFunds[0]?.id ?? '',
  );

  if (!accessibleFunds.length) {
    return (
      <div style={cardStyle}>
        <div style={{ color: INK_FAINT, fontStyle: 'italic' }}>
          You hold no institutional authority.
        </div>
      </div>
    );
  }

  const selectedFund = accessibleFunds.find((f) => f.id === selectedFundId);

  return (
    <div style={cardStyle}>
      <div style={tabBarStyle}>
        {accessibleFunds.map((f) => (
          <div
            key={f.id}
            style={tabStyle(selectedFundId === f.id)}
            onClick={() => setSelectedFundId(f.id)}
          >
            {f.label}
          </div>
        ))}
      </div>
      {!!selectedFund && (
        <FundView fund={selectedFund} data={data} act={act} />
      )}
    </div>
  );
};

const FundView = ({
  fund,
  data,
  act,
}: TabProps & { fund: FundEntry }) => {
  const balance = data.fund_balances[fund.id]?.balance ?? 0;
  const outstanding =
    data.fund_balances[fund.id]?.outstanding_principal ?? 0;
  
    const view_only = !fund.can_withdraw && !fund.can_issue && fund.can_view;
    const can_issue_loan = fund.can_issue && fund.supports_loans;

  return (
    <>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>Coffers</div>
        <div style={fieldValueStyle}>
          <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
            {balance}m
          </span>
          {outstanding > 0 && (
            <span style={{ marginLeft: 8, color: INK_FAINT }}>
              ({outstanding}m in loan circulation)
            </span>
          )}
        </div>
      </div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>Authority</div>
        <div style={fieldValueStyle}>{fund.authority_label}</div>
      </div>

      {!!fund.can_withdraw && (
        <WithdrawSection fund={fund} balance={balance} act={act} />
      )}
      {!!can_issue_loan && (
        <IssueLoanSection fund={fund} data={data} act={act} />
      )}
      {fund.id === 'bathhouse' && fund.can_issue && (
        <BathhouseAgreementSection data={data} act={act} />
      )}
      {!!view_only && (
        <div style={{ color: INK_FAINT, fontStyle: 'italic', marginTop: 8 }}>
          You may view this institution's coffers, but not act upon them.
        </div>
      )}
      <FundActivity fund={fund} data={data} />
    </>
  );
};

const BathhouseAgreementSection = ({
  data,
  act,
}: {
  data: TabProps['data'];
  act: TabProps['act'];
}) => {
  const active = !!data.bathhouse_agreement_active;
  return (
    <>
      <div style={sectionHeaderStyle}>Bathhouse Agreement</div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>Status</div>
        <div style={fieldValueStyle}>
          {active ? (
            <span style={{ color: '#3b6a35', fontWeight: 'bold' }}>
              ACTIVE
            </span>
          ) : (
            <span style={{ color: '#8b2020', fontWeight: 'bold' }}>
              SUSPENDED
            </span>
          )}
        </div>
      </div>
      <div
        style={{
          color: SEAL_AMBER,
          fontStyle: 'italic',
          marginBottom: 8,
          fontSize: '12px',
        }}
      >
        While the Agreement is in force, the Bathhouse tithes 20% of vault
        income and 10% of brassface tariffs to the Church of Azuria.
        Suspending the Agreement is publicly proclaimed.
      </div>
      <div style={{ marginTop: 6, textAlign: 'right' }}>
        <button
          type="button"
          style={inkButtonStyle({})}
          onClick={() => act('toggle_bathhouse_agreement')}
        >
          {active ? 'Suspend Agreement' : 'Restore Agreement'}
        </button>
      </div>
    </>
  );
};

const FundActivity = ({
  fund,
  data,
}: {
  fund: FundEntry;
  data: TabProps['data'];
}) => {
  const log = data.institutional_logs[fund.id] ?? [];
  return (
    <>
      <div style={sectionHeaderStyle}>Tally</div>
      <PaginatedLog entries={log} />
    </>
  );
};

const WithdrawSection = ({
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
            fontStyle: 'italic',
            marginBottom: 8,
            fontSize: '12px',
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
            style={{ width: 110 }}
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

const IssueLoanSection = ({
  fund,
  data,
  act,
}: TabProps & { fund: FundEntry }) => {
  const [tier, setTier] = useState<LoanTier>('personal');
  const [amount, setAmount] = useState<string>('');
  const [term, setTerm] = useState<number>(2);
  const [rate, setRate] = useState<number>(25);
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
        <div style={{ color: INK_FAINT, fontStyle: 'italic', marginBottom: 8 }}>
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
              fontStyle: 'italic',
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
                        target === t.id
                          ? 'rgba(200,170,100,0.4)'
                          : 'rgba(255,248,220,0.6)',
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
              type="button"
              key={t}
              style={{
                ...inkButtonStyle({}),
                marginRight: 4,
                fontWeight: term === t ? 'bold' : 'normal',
                background:
                  term === t
                    ? 'rgba(200,170,100,0.4)'
                    : 'rgba(255,248,220,0.6)',
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
              type="button"
              key={r}
              style={{
                ...inkButtonStyle({}),
                marginRight: 4,
                fontWeight: rate === r ? 'bold' : 'normal',
                background:
                  rate === r
                    ? 'rgba(200,170,100,0.4)'
                    : 'rgba(255,248,220,0.6)',
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
