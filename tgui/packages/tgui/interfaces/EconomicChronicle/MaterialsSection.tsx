import { useState } from 'react';

import { formatSigned, signColor } from '../common/format';
import {
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  subTabBarStyle,
  subTabStyle,
} from '../common/parchment';
import { SummarySegment } from '../common/SummarySegment';
import {
  compactCardStyle,
  compactDataCell,
  compactHeaderCell,
  twoColTable,
} from './styles';
import type { MaterialFlowColumn, MaterialFlowSnapshot } from './types';

type Props = {
  m: MaterialFlowSnapshot;
};

const emptyStyle = {
  color: INK_FAINT,
  fontSize: FONT_BODY,
  fontStyle: 'italic',
  padding: '4px 0',
} as const;

const groupHeaderCell = (color: string) =>
  ({
    ...compactHeaderCell,
    textAlign: 'center',
    color: color,
    fontWeight: 'bold',
    borderBottom: `1px solid ${INK_FAINT}`,
    paddingBottom: '1px',
  }) as const;

const codeCell = {
  ...compactHeaderCell,
  textAlign: 'right',
  paddingRight: '6px',
} as const;

const dirColor = (dir: string) => (dir === 'in' ? SEAL_GREEN : SEAL_RED);

const numCell = {
  ...compactDataCell,
  textAlign: 'right',
  paddingRight: '6px',
} as const;

const totalRowStyle = {
  borderTop: `1px solid ${INK_FAINT}`,
} as const;

const legendStyle = {
  color: INK_SOFT,
  fontSize: FONT_BODY,
  marginBottom: '2px',
  lineHeight: '1.35em',
} as const;

const noteStyle = {
  color: INK_FAINT,
  fontSize: FONT_BODY,
  fontStyle: 'italic',
  marginTop: '4px',
  lineHeight: '1.35em',
} as const;

const legendTitleStyle = {
  color: INK,
  fontWeight: 'bold',
  letterSpacing: '1px',
  marginRight: '6px',
} as const;

const LegendRow = (props: {
  title: string;
  color: string;
  columns: MaterialFlowColumn[];
}) => (
  <div style={legendStyle}>
    <span style={{ ...legendTitleStyle, color: props.color }}>
      {props.title}
    </span>
    {props.columns.map((col, i) => (
      <span key={col.code}>
        {i > 0 && <span style={{ color: INK_FAINT }}> &bull; </span>}
        <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
          {col.code}
        </span>{' '}
        {col.label}
      </span>
    ))}
  </div>
);

export const MaterialsSection = (props: Props) => {
  const { m } = props;
  const [cat, setCat] = useState<string | null>(null);
  const shown = cat ? m.rows.filter((r) => r.cat === cat) : m.rows;
  const present = m.categories.filter((c) =>
    m.rows.some((r) => r.cat === c.code),
  );
  const colTotal = (code: string) =>
    shown.reduce((sum, r) => sum + (r.cells[code] || 0), 0);
  const active = m.columns.filter((c) => colTotal(c.code) > 0);
  const inCols = active.filter((c) => c.dir === 'in');
  const outCols = active.filter((c) => c.dir === 'out');
  const ordered = [...inCols, ...outCols];
  const openTotal = shown.reduce((sum, r) => sum + r.open, 0);
  const netTotal = shown.reduce((sum, r) => sum + r.net, 0);
  return (
    <div style={compactCardStyle}>
      <SummarySegment
        title="Material Flow"
        items={[
          { label: 'Open demand', value: m.total_open },
          { label: 'Commissions', value: `${m.total_mammons}m` },
          { label: 'Scrap paid', value: `${m.scrap_value}m` },
        ]}
      />
      {m.rows.length === 0 ? (
        <div style={emptyStyle}>No materials moved this round.</div>
      ) : (
        <>
          {inCols.length > 0 && (
            <LegendRow title="INFLOW" color={SEAL_GREEN} columns={inCols} />
          )}
          {outCols.length > 0 && (
            <LegendRow title="OUTFLOW" color={SEAL_RED} columns={outCols} />
          )}
          {present.length > 1 && (
            <div style={subTabBarStyle}>
              <div style={subTabStyle(cat === null)} onClick={() => setCat(null)}>
                All
              </div>
              {present.map((c) => (
                <div
                  key={c.code}
                  style={subTabStyle(cat === c.code)}
                  onClick={() => setCat(c.code)}
                >
                  {c.label}
                </div>
              ))}
            </div>
          )}
          <table style={{ ...twoColTable, marginTop: '4px' }}>
            <thead>
              <tr>
                <td />
                {inCols.length > 0 && (
                  <td
                    style={groupHeaderCell(SEAL_GREEN)}
                    colSpan={inCols.length}
                  >
                    INFLOW
                  </td>
                )}
                {outCols.length > 0 && (
                  <td style={groupHeaderCell(SEAL_RED)} colSpan={outCols.length}>
                    OUTFLOW
                  </td>
                )}
                <td />
                <td />
              </tr>
              <tr>
                <td style={compactHeaderCell}>Material</td>
                {ordered.map((col) => (
                  <td
                    key={col.code}
                    style={{ ...codeCell, color: dirColor(col.dir) }}
                    title={col.label}
                  >
                    {col.code}
                  </td>
                ))}
                <td style={codeCell} title="Demand still open at round end">
                  OPEN
                </td>
                <td
                  style={{ ...codeCell, paddingRight: 0 }}
                  title="Inflow minus outflow"
                >
                  NET
                </td>
              </tr>
            </thead>
            <tbody>
              {shown.map((row) => (
                <tr key={row.name}>
                  <td style={compactDataCell}>{row.name}</td>
                  {ordered.map((col) => {
                    const v = row.cells[col.code] || 0;
                    return (
                      <td
                        key={col.code}
                        style={{
                          ...numCell,
                          color: v === 0 ? INK_FAINT : INK,
                        }}
                      >
                        {v}
                      </td>
                    );
                  })}
                  <td
                    style={{
                      ...numCell,
                      color: row.open === 0 ? INK_FAINT : INK_SOFT,
                    }}
                  >
                    {row.open}
                  </td>
                  <td
                    style={{
                      ...numCell,
                      paddingRight: 0,
                      color: signColor(row.net),
                      fontWeight: 'bold',
                    }}
                  >
                    {formatSigned(row.net)}
                  </td>
                </tr>
              ))}
              <tr style={totalRowStyle}>
                <td style={{ ...compactDataCell, color: SEAL_AMBER }}>Total</td>
                {ordered.map((col) => (
                  <td
                    key={col.code}
                    style={{ ...numCell, color: SEAL_AMBER }}
                  >
                    {colTotal(col.code)}
                  </td>
                ))}
                <td style={{ ...numCell, color: SEAL_AMBER }}>
                  {openTotal}
                </td>
                <td
                  style={{
                    ...numCell,
                    paddingRight: 0,
                    color: signColor(netTotal),
                    fontWeight: 'bold',
                  }}
                >
                  {formatSigned(netTotal)}
                </td>
              </tr>
            </tbody>
          </table>
          <div style={noteStyle}>
            Ores and ingots share the Metal category. Ores are only accounted
            for in the import and export flow - smelting one in town records
            the bar under DOM and the ore under SMT. DOM only counts town
            smelting and town farming, to avoid overcounting goods that do often not
            reach town, like butchering or wood.
          </div>
        </>
      )}
    </div>
  );
};
