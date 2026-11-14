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
import type {
  AllowanceGroup,
  FundAllowance,
  FundEntry,
  TabProps,
} from '../types';

const LIMIT_MAX = 10000;

const AllowanceRow = ({
  fund,
  group,
  act,
}: {
  fund: FundEntry;
  group: AllowanceGroup;
  act: TabProps['act'];
}) => {
  const [value, setValue] = useState(String(group.limit));

  useEffect(() => {
    setValue(String(group.limit));
  }, [group.limit]);

  const limit = Number(value);
  const invalid = !Number.isInteger(limit) || limit < 0 || limit > LIMIT_MAX;

  return (
    <div style={fieldRowStyle}>
      <div style={fieldLabelStyle}>{group.label}</div>
      <div
        style={{
          ...fieldValueStyle,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          gap: 12,
        }}
      >
        {group.suspended ? (
          <span style={{ color: INK_FAINT }}>Withdrawals suspended</span>
        ) : (
          <div style={{ display: 'flex', alignItems: 'center' }}>
            <input
              type="number"
              min={0}
              max={LIMIT_MAX}
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
                act('set_withdraw_limit', {
                  fund_id: fund.id,
                  group: group.id,
                  amount: limit,
                })
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
              act('toggle_withdrawals', {
                fund_id: fund.id,
                group: group.id,
              })
            }
          >
            {group.suspended ? 'Resume' : 'Suspend'}
          </button>
        </div>
      </div>
    </div>
  );
};

export const AllowanceSection = ({
  fund,
  allowance,
  act,
}: {
  fund: FundEntry;
  allowance: FundAllowance;
  act: TabProps['act'];
}) => {
  return (
    <>
      <div style={sectionHeaderStyle}>{allowance.header}</div>
      {allowance.groups.map((group) => (
        <AllowanceRow key={group.id} fund={fund} group={group} act={act} />
      ))}
    </>
  );
};
