import { Fragment } from 'react';

import {
  FONT_BODY,
  INK_FAINT,
  INK_SOFT,
  SEAL_AMBER,
  subtitleStyle,
} from '../common/parchment';
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
import type { MaterialDemandBlock, MaterialFlowSnapshot, MaterialSupplyBlock } from './types';

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

const sourceLabelCell = {
  ...compactDataCell,
  color: SEAL_AMBER,
  paddingTop: '3px',
  paddingRight: 0,
} as const;

const dividerCell = {
  borderTop: `1px dashed ${INK_FAINT}`,
  padding: 0,
  height: '4px',
} as const;

const rightCell = {
  ...compactDataCell,
  textAlign: 'right',
} as const;

const rightSoftCell = {
  ...compactDataCell,
  textAlign: 'right',
  color: INK_SOFT,
  paddingRight: 0,
} as const;

const Divider = () => (
  <tr>
    <td colSpan={3} style={dividerCell} />
  </tr>
);

const DemandTable = (props: { blocks: MaterialDemandBlock[] }) => (
  <div>
    <div style={subTitle}>Commissioned Demand</div>
    {props.blocks.length === 0 ? (
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
          {props.blocks.map((block, i) => (
            <Fragment key={block.source}>
              {i > 0 && <Divider />}
              <tr>
                <td colSpan={2} style={sourceLabelCell}>
                  {block.source}
                </td>
                <td style={{ ...sourceLabelCell, textAlign: 'right' }}>
                  {block.mammons}m
                </td>
              </tr>
              {block.rows.map((row) => (
                <tr key={row.name}>
                  <td style={{ ...compactDataCell, paddingLeft: '10px' }}>
                    {row.name}
                  </td>
                  <td style={rightCell}>{row.fulfilled}</td>
                  <td style={rightSoftCell}>{row.demanded}</td>
                </tr>
              ))}
            </Fragment>
          ))}
        </tbody>
      </table>
    )}
  </div>
);

const SupplyTable = (props: { blocks: MaterialSupplyBlock[] }) => (
  <div>
    <div style={subTitle}>Scrap Supplied</div>
    {props.blocks.length === 0 ? (
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
          {props.blocks.map((block, i) => (
            <Fragment key={block.source}>
              {i > 0 && <Divider />}
              <tr>
                <td colSpan={2} style={sourceLabelCell}>
                  {block.source}
                </td>
                <td style={{ ...sourceLabelCell, textAlign: 'right' }}>
                  {block.value}m
                </td>
              </tr>
              {block.rows.map((row) => (
                <tr key={row.name}>
                  <td style={{ ...compactDataCell, paddingLeft: '10px' }}>
                    {row.name}
                  </td>
                  <td style={rightCell}>{row.units}</td>
                  <td style={rightSoftCell}>{row.value}</td>
                </tr>
              ))}
            </Fragment>
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
        <DemandTable blocks={m.demand} />
        <div style={verticalDividerStyle} />
        <SupplyTable blocks={m.supply} />
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
        {formatPct(m.fulfillment_rate)}) for {m.total_mammons}m &bull; Scrapped{' '}
        {m.total_units} units for {m.total_value}m
      </div>
    </div>
  );
};
