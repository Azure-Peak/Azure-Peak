import { INK_SOFT, SEAL_GREEN } from '../common/parchment';
import { SummarySegment } from '../common/SummarySegment';
import {
  compactCardStyle,
  compactDataCell,
  compactHeaderCell,
  dividedTwoColumnLayout,
  twoColTable,
  verticalDividerStyle,
} from './styles';
import type { RealmRow, ShipSnapshot } from './types';

type Props = {
  s: ShipSnapshot;
};

const RealmTableHeader = () => (
  <thead>
    <tr>
      <td style={compactHeaderCell}>Realm</td>
      <td style={{ ...compactHeaderCell, textAlign: 'right' }}>Hails</td>
      <td style={{ ...compactHeaderCell, textAlign: 'right' }}>Dock</td>
      <td style={{ ...compactHeaderCell, textAlign: 'right', paddingRight: 0 }}>
        Favor
      </td>
    </tr>
  </thead>
);

const RealmTableRow = (props: { row: RealmRow }) => {
  const { row } = props;
  const dockText = row.avg_dock_min === null ? '-' : `${row.avg_dock_min}m`;
  return (
    <tr>
      <td style={compactDataCell}>{row.name}</td>
      <td style={{ ...compactDataCell, textAlign: 'right' }}>{row.hails}</td>
      <td style={{ ...compactDataCell, textAlign: 'right', color: INK_SOFT }}>
        {dockText}
      </td>
      <td style={{ ...compactDataCell, textAlign: 'right', paddingRight: 0 }}>
        {row.favor_earned}
      </td>
    </tr>
  );
};

const RealmTable = (props: { rows: RealmRow[] }) => (
  <table style={twoColTable}>
    <RealmTableHeader />
    <tbody>
      {props.rows.map((row) => (
        <RealmTableRow key={row.name} row={row} />
      ))}
    </tbody>
  </table>
);

export const ShipsSection = (props: Props) => {
  const { s } = props;
  const midpoint = Math.ceil(s.realms.length / 2);
  const leftHalf = s.realms.slice(0, midpoint);
  const rightHalf = s.realms.slice(midpoint);
  const tradedWith = s.realms.filter((r) => r.hails > 0).length;
  const busiest = s.realms.find((r) => r.hails > 0);
  const totalFavor = s.realms.reduce((sum, r) => sum + r.favor_earned, 0);
  return (
    <div style={compactCardStyle}>
      <SummarySegment
        title="Foreign Ship Activity"
        subtitle={`${s.total_hails} hail${s.total_hails === 1 ? '' : 's'}`}
        items={[
          {
            label: 'Realms traded with',
            value: `${tradedWith} of ${s.realms.length}`,
          },
          {
            label: 'Busiest',
            value: busiest ? `${busiest.name} (${busiest.hails})` : null,
          },
          { label: 'Favor earned', value: totalFavor, color: SEAL_GREEN },
        ]}
      />
      <div style={dividedTwoColumnLayout}>
        <RealmTable rows={leftHalf} />
        <div style={verticalDividerStyle} />
        <RealmTable rows={rightHalf} />
      </div>
    </div>
  );
};
