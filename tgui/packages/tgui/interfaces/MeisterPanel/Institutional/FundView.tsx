import {
  fieldLabelStyle,
  fieldRowStyle,
  fieldValueStyle,
  INK_FAINT,
  SEAL_AMBER,
} from '../../common/parchment';
import { type FundEntry, type TabProps } from '../types';
import { BathhouseOrdinanceSection } from './BathhouseOrdinanceSection';
import { FundActivity } from './FundActivity';
import { IssueLoanSection } from './IssueLoanSection';
import { WithdrawSection } from './WithdrawSection';

export const FundView = ({
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
      {(fund.id === 'bathhouse' || fund.id === 'church') && fund.can_issue && (
        <BathhouseOrdinanceSection data={data} act={act} />
      )}
      {!!view_only && (
        <div style={{ color: INK_FAINT, marginTop: 8 }}>
          {'You may view this institution\'s coffers, but not act upon them.'}
        </div>
      )}
      <FundActivity fund={fund} data={data} />
    </>
  );
};
