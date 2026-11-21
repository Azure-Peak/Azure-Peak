import { type CSSProperties, Fragment, useEffect, useState } from 'react';

import { useBackend } from '../../backend';
import { formatMammon } from '../common/format';
import {
  compactButtonStyle,
  FONT_SMALL,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkInputStyle,
  SEAL_AMBER,
  sectionHeaderStyle,
} from '../common/parchment';
import { bodyCell, buttonCell, headCell, rowStyle, tableStyle } from './table';
import { type Data, employedFor, type PayrollRow } from './types';

const COLUMNS = 'minmax(0, 1fr) auto auto auto auto';

const factionHeadingStyle: CSSProperties = {
  gridColumn: '1 / -1',
  padding: '10px 6px 2px 6px',
  fontSize: FONT_SMALL,
  fontWeight: 'bold',
  color: SEAL_AMBER,
};

const WageInput = (props: { row: PayrollRow }) => {
  const { act } = useBackend<Data>();
  const { job, wage, floor } = props.row;
  const [value, setValue] = useState(String(wage));

  useEffect(() => setValue(String(wage)), [wage]);

  const commit = () => {
    const amount = Number(value);
    if (value === '' || !Number.isFinite(amount) || amount === wage) {
      setValue(String(wage));
      return;
    }
    act('set_daily_pay', { job, amount });
    setValue(String(wage));
  };

  return (
    <div style={{ display: 'flex', alignItems: 'baseline', gap: '4px' }}>
      <input
        type="number"
        min={floor}
        max={999}
        step={1}
        value={value}
        onChange={(e) => setValue(e.target.value)}
        onBlur={commit}
        onKeyDown={(e) => {
          if (e.key === 'Enter') {
            e.currentTarget.blur();
          } else if (e.key === 'Escape') {
            setValue(String(wage));
          }
        }}
        style={{ ...inkInputStyle, width: 56, textAlign: 'right' }}
      />
      {floor > 0 && (
        <span
          title="Charter minimum"
          style={{ fontSize: FONT_SMALL, color: SEAL_AMBER, whiteSpace: 'nowrap' }}
        >
          min {formatMammon(floor)}m
        </span>
      )}
    </div>
  );
};

export const PayrollView = (props: { data: Data }) => {
  const { act } = useBackend<Data>();
  const { data } = props;
  const { payroll } = data;

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
        <span>Payroll</span>
        <div style={{ display: 'flex', gap: '4px', flexWrap: 'wrap' }}>
          <button
            type="button"
            style={compactButtonStyle()}
            onClick={() => act('add_daily_pay')}
          >
            Add job payment
          </button>
          <button
            type="button"
            style={compactButtonStyle()}
            onClick={() => act('add_group_daily_pay')}
          >
            Add job payment (Faction)
          </button>
        </div>
      </div>
      {payroll.length ? (
        <div style={tableStyle(COLUMNS)}>
          <span style={headCell()}>Job</span>
          <span style={headCell()}>Wage/dae</span>
          <span style={headCell('right')}>Employed</span>
          <span style={headCell('right')}>Total</span>
          <span style={headCell()} />
          {payroll.map((row, i) => {
            const first = i === 0 || payroll[i - 1].faction !== row.faction;
            const employed = employedFor(data, row.job);
            return (
              <Fragment key={row.job}>
                {first && (
                  <div style={factionHeadingStyle}>{row.faction ?? 'Other'}</div>
                )}
                <div style={rowStyle}>
                  <span style={{ ...bodyCell(first), color: INK }}>
                    <span style={{ overflowWrap: 'anywhere' }}>{row.job}</span>
                  </span>
                  <div style={bodyCell(first)}>
                    <WageInput row={row} />
                  </div>
                  <span style={{ ...bodyCell(first, 'right'), color: INK_SOFT }}>
                    {employed}
                  </span>
                  <span style={{ ...bodyCell(first, 'right'), color: INK }}>
                    {formatMammon(row.wage * employed)}m
                  </span>
                  <div style={buttonCell(first)}>
                    <button
                      type="button"
                      style={compactButtonStyle()}
                      onClick={() => act('remove_daily_pay', { job: row.job })}
                    >
                      Remove
                    </button>
                  </div>
                </div>
              </Fragment>
            );
          })}
        </div>
      ) : (
        <div style={{ color: INK_FAINT, fontStyle: 'italic' }}>
          No daily payments set.
        </div>
      )}
    </div>
  );
};
