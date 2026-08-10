import { FONT_BODY, INK_FAINT, INK_SOFT, subtitleStyle } from '../common/parchment';
import {
  compactCardStyle,
  compactDataCell,
  compactHeaderCell,
  dividedTwoColumnLayout,
  formatPct,
  SectionTitle,
  twoColTable,
  verticalDividerStyle,
} from './styles';
import type {
  MaterialDemandRow,
  MaterialFlowSnapshot,
  MaterialSupplyRow,
} from './types';

type Props = {
  m: MaterialFlowSnapshot;
};

const subTitle = {
  ...subtitleStyle,
  textAlign: 'left',
  marginBottom: '2px',
  fontSize: FONT_BODY,
} as const;

const emptyStyle = {
  color: INK_FAINT,
  fontSize: FONT_BODY,
  fontStyle: 'italic',
  padding: '2px 0',
} as const;

const DemandTable = (props: { rows: MaterialDemandRow[] }) => (
  <div>
    <div style={subTitle}>Demanded — Commissioner</div>
    {props.rows.length === 0 ? (
      <div style={emptyStyle}>No commissions were posted.</div>
    ) : (
      <table style={twoColTable}>
        <thead>
          <tr>
            <td style={compactHeaderCell}>Material</td>
            <td style={{ ...compactHeaderCell, textAlign: 'right' }}>Filled</td>
            <td
              style={{
                ...compactHeaderCell,
                textAlign: 'right',
                paddingRight: 0,
              }}
            >
              Demand
            </td>
          </tr>
        </thead>
        <tbody>
          {props.rows.map((row) => (
            <tr key={row.name}>
              <td style={compactDataCell}>{row.name}</td>
              <td style={{ ...compactDataCell, textAlign: 'right' }}>
                {row.fulfilled}
              </td>
              <td
                style={{
                  ...compactDataCell,
                  textAlign: 'right',
                  color: INK_SOFT,
                  paddingRight: 0,
                }}
              >
                {row.demanded}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    )}
  </div>
);

const SupplyTable = (props: { rows: MaterialSupplyRow[] }) => (
  <div>
    <div style={subTitle}>Scrap Supplied — Rag-Picker &amp; Scrapper</div>
    {props.rows.length === 0 ? (
      <div style={emptyStyle}>Nothing was fed to the scrappers.</div>
    ) : (
      <table style={twoColTable}>
        <thead>
          <tr>
            <td style={compactHeaderCell}>Material</td>
            <td style={{ ...compactHeaderCell, textAlign: 'right' }}>Units</td>
            <td
              style={{
                ...compactHeaderCell,
                textAlign: 'right',
                paddingRight: 0,
              }}
            >
              Paid
            </td>
          </tr>
        </thead>
        <tbody>
          {props.rows.map((row) => (
            <tr key={row.name}>
              <td style={compactDataCell}>{row.name}</td>
              <td style={{ ...compactDataCell, textAlign: 'right' }}>
                {row.units}
              </td>
              <td
                style={{
                  ...compactDataCell,
                  textAlign: 'right',
                  color: INK_SOFT,
                  paddingRight: 0,
                }}
              >
                {row.value}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    )}
  </div>
);

export const MaterialsSection = (props: Props) => {
  const { m } = props;
  return (
    <div style={compactCardStyle}>
      <SectionTitle>Material Flow</SectionTitle>
      <div style={dividedTwoColumnLayout}>
        <DemandTable rows={m.demand} />
        <div style={verticalDividerStyle} />
        <SupplyTable rows={m.supply} />
      </div>
      <div
        style={{
          color: INK_SOFT,
          fontSize: FONT_BODY,
          borderTop: `1px dotted ${INK_FAINT}`,
          marginTop: '4px',
          paddingTop: '2px',
        }}
      >
        Commissioned {m.total_fulfilled} of {m.total_demanded} units (
        {formatPct(m.fulfillment_rate)}) &bull; Scrapped {m.total_units} units
        for {m.total_value}m
      </div>
    </div>
  );
};
