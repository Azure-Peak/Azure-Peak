import { INK, INK_SOFT, SEAL_RED, subtitleStyle } from '../common/parchment';
import {
  compactCardStyle,
  compactDataCell,
  compactHeaderCell,
  dividedTwoColumnLayout,
  SectionTitle,
  twoColTable,
  verticalDividerStyle,
} from './styles';
import type { BmBucket, BucketSnapshot, RealBucket } from './types';

type Props = {
  b: BucketSnapshot;
};

const subTitle = {
  ...subtitleStyle,
  textAlign: 'left',
  marginBottom: '2px',
  fontSize: '11px',
} as const;

const isChoked = (cap: number, consumed: number) =>
  cap > 0 && consumed >= cap;

const RealMarketTable = (props: { rows: RealBucket[] }) => (
  <div>
    <div style={subTitle}>Real Market</div>
    <table style={twoColTable}>
      <thead>
        <tr>
          <td style={compactHeaderCell}>Bucket</td>
          <td style={{ ...compactHeaderCell, textAlign: 'right' }}>Cap</td>
          <td style={{ ...compactHeaderCell, textAlign: 'right' }}>Used</td>
          <td
            style={{ ...compactHeaderCell, textAlign: 'right', paddingRight: 0 }}
          >
            Demand
          </td>
        </tr>
      </thead>
      <tbody>
        {props.rows.map((row) => {
          const choked = isChoked(row.capacity, row.consumed);
          return (
            <tr key={row.name}>
              <td style={compactDataCell}>{row.name}</td>
              <td
                style={{
                  ...compactDataCell,
                  textAlign: 'right',
                  color: INK_SOFT,
                }}
              >
                {row.capacity}
              </td>
              <td
                style={{
                  ...compactDataCell,
                  textAlign: 'right',
                  color: choked ? SEAL_RED : INK,
                }}
              >
                {row.consumed}
              </td>
              <td
                style={{
                  ...compactDataCell,
                  textAlign: 'right',
                  paddingRight: 0,
                }}
              >
                {row.demand_drained}
              </td>
            </tr>
          );
        })}
      </tbody>
    </table>
  </div>
);

const BlackMarketTable = (props: { rows: BmBucket[] }) => (
  <div>
    <div style={subTitle}>Black Market</div>
    <table style={twoColTable}>
      <thead>
        <tr>
          <td style={compactHeaderCell}>Bucket</td>
          <td style={{ ...compactHeaderCell, textAlign: 'right' }}>Cap</td>
          <td
            style={{ ...compactHeaderCell, textAlign: 'right', paddingRight: 0 }}
          >
            Used
          </td>
        </tr>
      </thead>
      <tbody>
        {props.rows.map((row) => {
          const choked = isChoked(row.capacity, row.consumed);
          return (
            <tr key={row.name}>
              <td style={compactDataCell}>{row.name}</td>
              <td
                style={{
                  ...compactDataCell,
                  textAlign: 'right',
                  color: INK_SOFT,
                }}
              >
                {row.capacity}
              </td>
              <td
                style={{
                  ...compactDataCell,
                  textAlign: 'right',
                  color: choked ? SEAL_RED : INK,
                  paddingRight: 0,
                }}
              >
                {row.consumed}
              </td>
            </tr>
          );
        })}
      </tbody>
    </table>
  </div>
);

export const BucketsSection = (props: Props) => {
  const { b } = props;
  return (
    <div style={compactCardStyle}>
      <SectionTitle>Navigator Buckets</SectionTitle>
      <div style={dividedTwoColumnLayout}>
        <RealMarketTable rows={b.real} />
        <div style={verticalDividerStyle} />
        <BlackMarketTable rows={b.black_market} />
      </div>
    </div>
  );
};
