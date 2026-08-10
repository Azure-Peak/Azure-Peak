import { Fragment } from 'react';

import {
  FONT_BODY,
  INK,
  INK_FAINT,
  SEAL_AMBER,
  SEAL_RED,
} from '../common/parchment';
import { SummarySegment } from '../common/SummarySegment';
import {
  compactCardStyle,
  compactDataCell,
  compactHeaderCell,
  SectionTitle,
  twoColTable,
} from './styles';
import type { CrownExpenseSnapshot } from './types';

type Props = {
  c: CrownExpenseSnapshot;
};

const emptyStyle = {
  color: INK_FAINT,
  fontSize: FONT_BODY,
  fontStyle: 'italic',
  padding: '4px 0',
} as const;

const mechanismCell = {
  ...compactDataCell,
  color: SEAL_AMBER,
  fontWeight: 'bold',
  paddingTop: '3px',
} as const;

const roleCell = {
  ...compactDataCell,
  paddingLeft: '12px',
} as const;

const amountCell = {
  ...compactDataCell,
  textAlign: 'right',
  paddingRight: 0,
} as const;

export const CrownExpensesSection = (props: Props) => {
  const { c } = props;
  return (
    <div style={compactCardStyle}>
      <SectionTitle>Crown Expenses</SectionTitle>
      <SummarySegment
        items={[{ label: 'Total drawn', value: `${c.total}m`, color: SEAL_RED }]}
      />
      {c.groups.length === 0 ? (
        <div style={emptyStyle}>Nothing was drawn from the Crown&apos;s Purse.</div>
      ) : (
        <table style={twoColTable}>
          <thead>
            <tr>
              <td style={compactHeaderCell}>Expense</td>
              <td
                style={{ ...compactHeaderCell, textAlign: 'right', paddingRight: 0 }}
              >
                Mammons
              </td>
            </tr>
          </thead>
          <tbody>
            {c.groups.map((group) => (
              <Fragment key={group.name}>
                <tr>
                  <td style={mechanismCell}>{group.name}</td>
                  <td style={{ ...amountCell, ...mechanismCell }}>
                    {group.total}m
                  </td>
                </tr>
                {group.rows.map((row) => (
                  <tr key={row.name}>
                    <td style={roleCell}>{row.name}</td>
                    <td style={{ ...amountCell, color: INK }}>{row.amount}m</td>
                  </tr>
                ))}
              </Fragment>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
};
