import {
  cardStyle,
  fieldLabelStyle,
  fieldRowStyle,
  fieldValueStyle,
  INK_FAINT,
  INK_SOFT,
  SEAL_RED,
  sectionHeaderStyle,
} from '../common/parchment';
import { PaginatedLog } from './PaginatedLog';
import { type TabProps } from './types';

export const LedgerTab = ({ data }: TabProps) => {
  const personal = data.active_loan;
  const institutional = data.institutional_loans;

  return (
    <div style={cardStyle}>
      <div style={sectionHeaderStyle}>My Debts</div>
      {!personal && (
        <div style={{ color: INK_SOFT }}>
          You owe no debts.
        </div>
      )}
      {!!personal && (
        <div style={fieldRowStyle}>
          <div style={fieldLabelStyle}>{personal.creditor}</div>
          <div style={fieldValueStyle}>
            {personal.remaining}m of {personal.principal}m at{' '}
            {personal.interest_pct}%/day
            {personal.defaulted ? (
              <span
                style={{
                  marginLeft: 8,
                  color: SEAL_RED,
                  fontWeight: 'bold',
                }}
              >
                DEFAULTED
              </span>
            ) : (
              <span style={{ marginLeft: 8, color: INK_FAINT }}>
                (due day {personal.due_on_day})
              </span>
            )}
          </div>
        </div>
      )}

      <div style={sectionHeaderStyle}>Institutional Ledger</div>
      {!institutional.length && (
        <div style={{ color: INK_SOFT }}>
          No active loans on the institutions you hold authority over.
        </div>
      )}
      {institutional.map((loan, i) => (
        <div key={i} style={fieldRowStyle}>
          <div style={fieldLabelStyle}>{loan.creditor_label}</div>
          <div style={fieldValueStyle}>
            {loan.is_institutional ? (
              <>
                Indenture to <b>{loan.target_label}</b>:{' '}
              </>
            ) : (
              <>
                Loan to <b>{loan.debtor || 'unknown'}</b>:{' '}
              </>
            )}
            {loan.remaining}m of {loan.principal}m at {loan.interest_pct}%/day
            {loan.defaulted ? (
              <span
                style={{
                  marginLeft: 8,
                  color: SEAL_RED,
                  fontWeight: 'bold',
                }}
              >
                DEFAULTED
              </span>
            ) : (
              <span style={{ marginLeft: 8, color: INK_FAINT }}>
                (due day {loan.due_on_day})
              </span>
            )}
          </div>
        </div>
      ))}

      <div style={sectionHeaderStyle}>Tally</div>
      <PaginatedLog entries={data.personal_log} />
    </div>
  );
};
