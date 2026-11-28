import { useBackend } from '../../backend';
import { formatMammon } from '../common/format';
import {
  compactButtonStyle,
  INK,
  INK_FAINT,
  INK_SOFT,
  SEAL_AMBER,
  SEAL_RED,
  sectionHeaderStyle,
} from '../common/parchment';
import { StatusTags } from './StatusTags';
import { bodyCell, buttonCell, headCell, rowStyle, tableStyle } from './table';
import type { AccountRow, Data } from './types';

const COLUMNS = 'minmax(0, 1.2fr) minmax(0, 1fr) auto auto';

const flagged = (row: AccountRow) => (row.debtor || row.arrears ? 1 : 0);

export const AccountsView = (props: { data: Data }) => {
  const { act } = useBackend<Data>();
  const { accounts, can_fiscal } = props.data;
  const sorted = [...accounts].sort((a, b) => flagged(b) - flagged(a));

  return (
    <div>
      <div
        style={{
          ...sectionHeaderStyle,
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'baseline',
        }}
      >
        <span>Accounts</span>
        <button
          type="button"
          style={compactButtonStyle()}
          onClick={() => act('pay_by_class')}
        >
          Pay by class
        </button>
      </div>
      {sorted.length ? (
        <div style={tableStyle(COLUMNS)}>
          <span style={headCell()}>Name</span>
          <span style={headCell()}>Job</span>
          <span style={headCell('right')}>Balance</span>
          <span style={headCell()} />
          {sorted.map((row, i) => {
            const first = i === 0;
            return (
              <div key={row.ref} style={rowStyle}>
                <div style={bodyCell(first)}>
                  <span style={{ color: INK, overflowWrap: 'anywhere' }}>
                    {row.name}
                    {!!row.suspended && (
                      <b style={{ color: SEAL_RED, marginLeft: '6px' }}>
                        (SUSPENDED)
                      </b>
                    )}
                  </span>
                  <StatusTags row={row} />
                </div>
                <span style={{ ...bodyCell(first), color: INK_SOFT }}>
                  <span style={{ overflowWrap: 'anywhere' }}>{row.job}</span>
                </span>
                <span style={{ ...bodyCell(first, 'right'), color: INK }}>
                  {formatMammon(row.balance)}m
                </span>
                <div style={buttonCell(first)}>
                  <button
                    type="button"
                    style={compactButtonStyle()}
                    onClick={() => act('give_money', { ref: row.ref })}
                  >
                    Give
                  </button>
                  {!!can_fiscal && (
                    <>
                      <button
                        type="button"
                        disabled={row.max_fine <= 0}
                        title={
                          row.max_fine > 0
                            ? `Up to ${formatMammon(row.max_fine)}m`
                            : 'Exempt or empty'
                        }
                        style={compactButtonStyle({
                          color: SEAL_RED,
                          disabled: row.max_fine <= 0,
                        })}
                        onClick={() => act('fine', { ref: row.ref })}
                      >
                        Fine
                      </button>
                      <button
                        type="button"
                        style={compactButtonStyle({
                          color: row.suspended ? SEAL_AMBER : undefined,
                        })}
                        onClick={() => act('toggle_wages', { ref: row.ref })}
                      >
                        <span style={{ display: 'inline-grid' }}>
                          <span
                            style={{
                              gridArea: '1 / 1',
                              visibility: row.suspended ? 'hidden' : 'visible',
                            }}
                          >
                            Suspend
                          </span>
                          <span
                            style={{
                              gridArea: '1 / 1',
                              visibility: row.suspended ? 'visible' : 'hidden',
                            }}
                          >
                            Reinstate
                          </span>
                        </span>
                      </button>
                    </>
                  )}
                </div>
              </div>
            );
          })}
        </div>
      ) : (
        <div style={{ color: INK_FAINT, fontStyle: 'italic' }}>No accounts.</div>
      )}
    </div>
  );
};
