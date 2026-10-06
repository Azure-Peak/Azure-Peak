import type { CSSProperties, ReactNode } from 'react';

import { formatPct, withPct } from '../common/format';
import {
  INK,
  INK_FAINT,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
} from '../common/parchment';
import { SummarySegment } from '../common/SummarySegment';
import {
  columnSubheadStyle,
  compactCardStyle,
  compactDataCell,
  compactHeaderCell,
  dividedTwoColumnLayout,
  Tally,
  twoColTable,
  verticalDividerStyle,
} from './styles';
import type {
  ContractsSnapshot,
  ContractStatRow,
  RoyalFavorsSnapshot,
} from './types';

type Props = {
  c: ContractsSnapshot;
  rf: RoyalFavorsSnapshot;
};

const LOW_TAKE_RATE = 10;
const LOW_TAKE_MIN_POSTED = 5;
const DS_PER_MINUTE = 600;
const DS_PER_HOUR = 36000;

const pct = (part: number, whole: number) =>
  whole > 0 ? Math.round((part / whole) * 100) : null;

const openCount = (row: ContractStatRow) =>
  Math.max(
    0,
    row.taken - row.completed - row.failed - row.abandoned - row.withdrawn,
  );

const avgMinutes = (totalDs: number, count: number) =>
  count > 0 ? `${(totalDs / count / DS_PER_MINUTE).toFixed(1)}m` : '-';

const avgOf = (total: number, count: number) =>
  count > 0 ? (total / count).toFixed(1) : '-';

const perHour = (row: ContractStatRow) =>
  row.run_ds > 0 ? `${Math.round(row.paid / (row.run_ds / DS_PER_HOUR))}m` : '-';

const isIdle = (row: ContractStatRow) => row.posted === 0 && row.taken === 0;

const lowTake = (row: ContractStatRow) => {
  const rate = pct(row.taken, row.posted);
  return row.posted >= LOW_TAKE_MIN_POSTED && rate !== null && rate < LOW_TAKE_RATE;
};

const sumRows = (rows: ContractStatRow[], players: number): ContractStatRow =>
  rows.reduce(
    (acc, r) => ({
      ...acc,
      posted: acc.posted + r.posted,
      taken: acc.taken + r.taken,
      lapsed: acc.lapsed + r.lapsed,
      completed: acc.completed + r.completed,
      failed: acc.failed + r.failed,
      abandoned: acc.abandoned + r.abandoned,
      withdrawn: acc.withdrawn + r.withdrawn,
      paid: acc.paid + r.paid,
      wait_ds: acc.wait_ds + r.wait_ds,
      run_ds: acc.run_ds + r.run_ds,
      party: acc.party + r.party,
      deaths: acc.deaths + r.deaths,
    }),
    {
      name: 'All contracts',
      posted: 0,
      taken: 0,
      lapsed: 0,
      players,
      completed: 0,
      failed: 0,
      abandoned: 0,
      withdrawn: 0,
      paid: 0,
      wait_ds: 0,
      run_ds: 0,
      party: 0,
      deaths: 0,
    },
  );

const numHead: CSSProperties = { ...compactHeaderCell, textAlign: 'right' };
const numCell: CSSProperties = { ...compactDataCell, textAlign: 'right' };
const groupEdge: CSSProperties = {
  borderLeft: `1px dotted ${INK_FAINT}`,
  paddingLeft: '6px',
};
const totalRowStyle: CSSProperties = {
  borderTop: `1px solid ${INK_FAINT}`,
  fontWeight: 'bold',
};
const emptyNote: CSSProperties = {
  color: INK_FAINT,
  fontStyle: 'italic',
  padding: '2px 0',
};

type Column = {
  label: string;
  render: (row: ContractStatRow) => ReactNode;
  color?: (row: ContractStatRow) => string | undefined;
  edge?: boolean;
};

const StatTable = (props: {
  title: string;
  keyLabel: string;
  columns: Column[];
  rows: ContractStatRow[];
  total?: ContractStatRow;
  groups?: { label: string; span: number; edge?: boolean }[];
  emptyText?: string;
}) => {
  const { columns, rows, total } = props;
  const lastIndex = columns.length - 1;
  const cellStyle = (
    col: Column,
    i: number,
    row: ContractStatRow,
    dim: boolean,
  ): CSSProperties => ({
    ...numCell,
    ...(col.edge ? groupEdge : {}),
    ...(i === lastIndex ? { paddingRight: 0 } : {}),
    color: dim ? INK_FAINT : col.color?.(row) || INK,
  });
  const renderRow = (row: ContractStatRow, dim: boolean, style?: CSSProperties) => (
    <tr key={row.name} style={style}>
      <td style={{ ...compactDataCell, color: dim ? INK_FAINT : INK }}>
        {row.name}
      </td>
      {columns.map((col, i) => (
        <td key={col.label} style={cellStyle(col, i, row, dim)}>
          {col.render(row)}
        </td>
      ))}
    </tr>
  );
  return (
    <div style={compactCardStyle}>
      <SummarySegment title={props.title} items={[]} />
      {rows.length === 0 && props.emptyText ? (
        <div style={emptyNote}>{props.emptyText}</div>
      ) : (
        <table style={twoColTable}>
          <thead>
            {!!props.groups && (
              <tr>
                <td style={compactHeaderCell} />
                {props.groups.map((g) => (
                  <td
                    key={g.label || `gap-${g.span}`}
                    colSpan={g.span}
                    style={{ ...numHead, ...(g.edge ? groupEdge : {}) }}
                  >
                    {g.label}
                  </td>
                ))}
              </tr>
            )}
            <tr>
              <td style={compactHeaderCell}>{props.keyLabel}</td>
              {columns.map((col, i) => (
                <td
                  key={col.label}
                  style={{
                    ...numHead,
                    ...(col.edge ? groupEdge : {}),
                    ...(i === lastIndex ? { paddingRight: 0 } : {}),
                  }}
                >
                  {col.label}
                </td>
              ))}
            </tr>
          </thead>
          <tbody>
            {rows.map((row) => renderRow(row, isIdle(row)))}
            {!!total && renderRow(total, false, totalRowStyle)}
          </tbody>
        </table>
      )}
    </div>
  );
};

const takePct: Column = {
  label: 'Take %',
  render: (r) => formatPct(pct(r.taken, r.posted)),
  color: (r) => (lowTake(r) ? SEAL_RED : undefined),
};
const donePct: Column = {
  label: 'Done %',
  render: (r) => formatPct(pct(r.completed, r.taken)),
};
const doneCol = (edge = false): Column => ({
  label: 'Done',
  render: (r) => r.completed,
  color: () => SEAL_GREEN,
  edge,
});
const failedCol: Column = {
  label: 'Failed',
  render: (r) => r.failed,
  color: (r) => (r.failed > 0 ? SEAL_RED : undefined),
};
const lapsedCol: Column = {
  label: 'Lapsed',
  render: (r) => r.lapsed,
  color: (r) => (r.lapsed > 0 ? SEAL_AMBER : undefined),
};
const deathsCol = (edge = false): Column => ({
  label: 'Deaths',
  render: (r) => r.deaths,
  color: (r) => (r.deaths > 0 ? SEAL_RED : undefined),
  edge,
});
const rewardsCol = (edge = false): Column => ({
  label: 'Rewards',
  render: (r) => `${r.paid}m`,
  edge,
});

const outcomeColumns: Column[] = [
  { label: 'Posted', render: (r) => r.posted },
  { label: 'Taken', render: (r) => r.taken },
  lapsedCol,
  takePct,
  { label: 'Players', render: (r) => r.players },
  doneCol(true),
  failedCol,
  { label: 'Aband.', render: (r) => r.abandoned },
  { label: 'Withdr.', render: (r) => r.withdrawn },
  { label: 'Open', render: (r) => openCount(r) },
  donePct,
];

const effortColumns: Column[] = [
  { label: 'Avg wait', render: (r) => avgMinutes(r.wait_ds, r.taken) },
  { label: 'Avg run', render: (r) => avgMinutes(r.run_ds, r.completed) },
  { label: 'Avg party', render: (r) => avgOf(r.party, r.completed) },
  deathsCol(),
  rewardsCol(true),
  { label: 'Avg reward', render: (r) => avgOf(r.paid, r.completed) },
  { label: 'Per hour', render: perHour },
];

const regionColumns: Column[] = [
  { label: 'Posted', render: (r) => r.posted },
  { label: 'Taken', render: (r) => r.taken },
  lapsedCol,
  takePct,
  doneCol(true),
  donePct,
  deathsCol(),
  rewardsCol(true),
];

const groupColumns: Column[] = [
  { label: 'Taken', render: (r) => r.taken },
  { label: 'Players', render: (r) => r.players },
  doneCol(true),
  failedCol,
  donePct,
  deathsCol(),
  { label: 'Avg party', render: (r) => avgOf(r.party, r.completed) },
  rewardsCol(true),
];

const Headline = (props: Props & { total: ContractStatRow }) => {
  const { c, rf, total } = props;
  return (
    <div style={compactCardStyle}>
      <SummarySegment
        title="Guild Contracts &amp; Royal Favors"
        items={[
          { label: 'Posted', value: total.posted },
          { label: 'Taken', value: total.taken },
          {
            label: 'Completed',
            value: withPct(total.completed, pct(total.completed, total.taken)),
            color: SEAL_GREEN,
          },
          { label: 'Players', value: c.players_total },
          { label: 'Rewards', value: `${total.paid}m` },
        ]}
      />
      <div style={dividedTwoColumnLayout}>
        <div>
          <div style={columnSubheadStyle}>Mammons</div>
          <Tally
            items={[
              { label: 'Ledger take-home', value: `${c.mammons_paid}m` },
              { label: 'Crown levy', value: `${c.mammons_taxed}m` },
              { label: 'Guild cut', value: `${c.guild_cut}m` },
              { label: 'Forfeited', value: `${c.mammons_forfeited}m` },
              { label: 'Refunded', value: `${c.mammons_refunded}m` },
            ]}
          />
        </div>
        <div style={verticalDividerStyle} />
        <div>
          <div style={columnSubheadStyle}>Royal Favors</div>
          <Tally
            items={[
              { label: 'Pledge raised', value: rf.pledge_generated },
              { label: 'Rumor raised', value: rf.rumor_generated },
              { label: 'Pledge spent', value: rf.pledge_consumed },
              { label: 'Rumor spent', value: rf.rumor_consumed },
              { label: 'Pledge unused', value: rf.pledge_unused },
              { label: 'Rumor unused', value: rf.rumor_unused },
            ]}
          />
        </div>
      </div>
    </div>
  );
};

type SourceRow = {
  label: string;
  posted: number;
  taken: number;
  completed: number;
  lapsed: number;
};

const SourceTable = (props: { c: ContractsSnapshot }) => {
  const { c } = props;
  const rows: SourceRow[] = [
    {
      label: 'Guild board',
      posted: c.generated_pool,
      taken: c.taken_pool,
      completed: c.completed_pool,
      lapsed: c.lapsed_pool,
    },
    {
      label: 'Tavern rumor',
      posted: c.generated_rumor,
      taken: c.taken_rumor,
      completed: c.completed_rumor,
      lapsed: c.lapsed_rumor,
    },
    {
      label: 'Crown commission',
      posted: c.generated_defense,
      taken: c.taken_defense,
      completed: c.completed_defense,
      lapsed: c.lapsed_defense,
    },
  ];
  return (
    <div style={compactCardStyle}>
      <SummarySegment title="Source" items={[]} />
      <table style={twoColTable}>
        <thead>
          <tr>
            <td style={compactHeaderCell}>Source</td>
            <td style={numHead}>Posted</td>
            <td style={numHead}>Taken</td>
            <td style={numHead}>Take %</td>
            <td style={{ ...numHead, ...groupEdge }}>Done</td>
            <td style={numHead}>Done %</td>
            <td style={{ ...numHead, paddingRight: 0 }}>Lapsed</td>
          </tr>
        </thead>
        <tbody>
          {rows.map((row) => (
            <tr key={row.label}>
              <td style={compactDataCell}>{row.label}</td>
              <td style={numCell}>{row.posted}</td>
              <td style={numCell}>{row.taken}</td>
              <td style={numCell}>{formatPct(pct(row.taken, row.posted))}</td>
              <td style={{ ...numCell, ...groupEdge, color: SEAL_GREEN }}>
                {row.completed}
              </td>
              <td style={numCell}>
                {formatPct(pct(row.completed, row.taken))}
              </td>
              <td
                style={{
                  ...numCell,
                  paddingRight: 0,
                  color: row.lapsed > 0 ? SEAL_AMBER : INK,
                }}
              >
                {row.lapsed}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export const ContractsSection = (props: Props) => {
  const { c, rf } = props;
  const types = c.types || [];
  const total = sumRows(types, c.players_total);
  const takenTypes = types.filter((r) => r.taken > 0);
  const activeRegions = (c.regions || []).filter((r) => !isIdle(r));
  const activeGroups = (c.groups || []).filter((r) => r.taken > 0);
  return (
    <>
      <Headline c={c} rf={rf} total={total} />
      <SourceTable c={c} />
      <StatTable
        title="Contract Types"
        keyLabel="Contract"
        columns={outcomeColumns}
        rows={types}
        total={total}
        groups={[
          { label: 'Uptake', span: 5 },
          { label: 'Outcome', span: 6, edge: true },
        ]}
      />
      <StatTable
        title="Efforts"
        keyLabel="Contract"
        columns={effortColumns}
        rows={takenTypes}
        total={takenTypes.length ? total : undefined}
        groups={[
          { label: 'Effort', span: 4 },
          { label: 'Reward', span: 3, edge: true },
        ]}
        emptyText="No contracts taken yet."
      />
      <StatTable
        title="Region"
        keyLabel="Region"
        columns={regionColumns}
        rows={activeRegions}
        emptyText="No contracts posted yet."
      />
      <StatTable
        title="Roles"
        keyLabel="Role"
        columns={groupColumns}
        rows={activeGroups}
        emptyText="No contracts taken yet."
      />
    </>
  );
};
