import { useEffect, useState } from 'react';

import {
  FONT_BODY,
  fieldLabelStyle,
  fieldRowStyle,
  fieldValueStyle,
  INK_FAINT,
  inkButtonStyle,
  inkInputStyle,
  sectionHeaderStyle,
} from '../../common/parchment';
import type { TabProps } from '../types';

export const BathhouseWithdrawalSection = ({
  data,
  act,
}: {
  data: TabProps['data'];
  act: TabProps['act'];
}) => {
  const [workerLimit, setWorkerLimit] = useState(
    String(data.bathhouse_worker_withdraw_limit),
  );
  const [agentLimit, setAgentLimit] = useState(
    String(data.bathhouse_agent_withdraw_limit),
  );

  useEffect(() => {
    setWorkerLimit(String(data.bathhouse_worker_withdraw_limit));
    setAgentLimit(String(data.bathhouse_agent_withdraw_limit));
  }, [
    data.bathhouse_worker_withdraw_limit,
    data.bathhouse_agent_withdraw_limit,
  ]);

  const renderLimitControl = (
    group: 'worker' | 'agent',
    label: string,
    value: string,
    setValue: (value: string) => void,
    suspended: boolean,
  ) => {
    const limit = Number(value);
    const invalid = !Number.isInteger(limit) || limit < 0 || limit > 10000;

    return (
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>{label}</div>
        <div
          style={{
            ...fieldValueStyle,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
            gap: 12,
          }}
        >
          {suspended ? (
            <span style={{ color: INK_FAINT }}>Withdrawals suspended</span>
          ) : (
            <div style={{ display: 'flex', alignItems: 'center' }}>
              <input
                type="number"
                min={0}
                max={10000}
                step={1}
                value={value}
                onChange={(e) => setValue(e.target.value)}
                style={{ ...inkInputStyle, width: 100 }}
              />
              <span style={{ marginLeft: 6, color: INK_FAINT }}>
                mammon / day
              </span>
              <button
                type="button"
                style={{
                  ...inkButtonStyle({ disabled: invalid }),
                  marginLeft: 8,
                  fontSize: FONT_BODY,
                  padding: '2px 6px',
                }}
                disabled={invalid}
                onClick={() =>
                  act('set_bathhouse_withdraw_limit', { group, amount: limit })
                }
              >
                Set
              </button>
            </div>
          )}
          <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
            <button
              type="button"
              style={inkButtonStyle({})}
              onClick={() =>
                act('toggle_bathhouse_withdrawals', { group })
              }
            >
              {suspended ? 'Resume' : 'Suspend'}
            </button>
          </div>
        </div>
      </div>
    );
  };

  return (
    <>
      <div style={sectionHeaderStyle}>Employee Allowance</div>
      {renderLimitControl(
        'worker',
        'Workers',
        workerLimit,
        setWorkerLimit,
        data.bathhouse_worker_withdrawals_suspended,
      )}
      {renderLimitControl(
        'agent',
        'Agents',
        agentLimit,
        setAgentLimit,
        data.bathhouse_agent_withdrawals_suspended,
      )}
    </>
  );
};
