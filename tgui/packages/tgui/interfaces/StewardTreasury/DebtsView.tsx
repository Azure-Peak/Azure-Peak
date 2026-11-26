import { useBackend } from '../../backend';
import { formatMammon } from '../common/format';
import {
  compactButtonStyle,
  INK,
  INK_FAINT,
  INK_SOFT,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  SEAL_RED,
  sectionHeaderStyle,
} from '../common/parchment';
import { StatusTags } from './StatusTags';
import { bodyCell, buttonCell, rowStyle, tableStyle } from './table';
import type { Data } from './types';

const COLUMNS = 'minmax(0, 1fr) auto auto';

export const DebtsView = (props: { data: Data }) => {
  const { act } = useBackend<Data>();
  const { loans, debts, can_fiscal } = props.data;

  return (
    <div>
      <div style={sectionHeaderStyle}>Crown loans</div>
      {loans.length ? (
        loans.map((loan, i) => (
          <div
            key={i}
            style={{
              padding: '3px 0',
              color: loan.defaulted ? SEAL_RED : SEAL_AMBER,
              borderTop: `1px ${i === 0 ? 'solid' : 'dashed'} ${PARCHMENT_SHADOW}`,
            }}
          >
            {loan.text}
          </div>
        ))
      ) : (
        <div style={{ color: INK_FAINT, fontStyle: 'italic' }}>
          No active loans.
        </div>
      )}

      <div style={{ ...sectionHeaderStyle, marginTop: '16px' }}>
        Debtors and arrears
      </div>
      {debts.length ? (
        <div style={tableStyle(COLUMNS)}>
          {debts.map((row, i) => {
            const first = i === 0;
            return (
              <div key={row.ref} style={rowStyle}>
                <div style={bodyCell(first)}>
                  <span style={{ color: INK, overflowWrap: 'anywhere' }}>
                    {row.name}
                  </span>
                  <StatusTags row={row} />
                </div>
                <span style={{ ...bodyCell(first, 'right'), color: INK_SOFT }}>
                  {formatMammon(row.balance)}m
                </span>
                <div style={buttonCell(first)}>
                  {!!can_fiscal && !!row.debtor && (
                    <button
                      type="button"
                      title="Forgives their Crown loan and poll levy arrears and removes the defaulter mark."
                      style={compactButtonStyle({ color: SEAL_RED })}
                      onClick={() => act('clear_defaulter', { ref: row.ref })}
                    >
                      Clear defaulter
                    </button>
                  )}
                  {!!can_fiscal && !!row.arrears && (
                    <button
                      type="button"
                      title="Wipes their poll levy arrears."
                      style={compactButtonStyle()}
                      onClick={() => act('clear_poll_levy', { ref: row.ref })}
                    >
                      Clear poll levy
                    </button>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      ) : (
        <div style={{ color: INK_FAINT, fontStyle: 'italic' }}>
          No debtors or arrears.
        </div>
      )}
    </div>
  );
};
