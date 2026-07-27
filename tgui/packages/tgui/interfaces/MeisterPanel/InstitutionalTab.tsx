import { useState } from 'react';

import {
  cardStyle,
  INK_SOFT,
  tabBarStyle,
  tabStyle,
} from '../common/parchment';
import { FundView } from './Institutional/FundView';
import type { TabProps } from './types';

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
        <div style={{ color: INK_SOFT }}>
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
      {!!selectedFund && <FundView fund={selectedFund} data={data} act={act} />}
    </div>
  );
};
