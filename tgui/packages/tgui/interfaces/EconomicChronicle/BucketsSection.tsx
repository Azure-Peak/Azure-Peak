import { FONT_BODY, INK_SOFT, subtitleStyle } from '../common/parchment';
import { SummarySegment } from '../common/SummarySegment';
import {
  compactCardStyle,
  compactDataCell,
  compactHeaderCell,
  dividedTwoColumnLayout,
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
  fontSize: FONT_BODY,
} as const;

const RealMarketTable = (props: { rows: RealBucket[] }) => (
  <div>
    <div style={subTitle}>Real Market</div>
    <table style={twoColTable}>
      <thead>
        <tr>
          <td style={compactHeaderCell}>Bucket</td>
          <td
            style={{ ...compactHeaderCell, textAlign: 'right' }}
            title="Value sold into the warehouse, filling up saturation."
          >
            Sold
          </td>
          <td
            style={{
              ...compactHeaderCell,
              textAlign: 'right',
              paddingRight: 0,
            }}
            title="Market saturation cleared by a ship docking."
          >
            Cleared
          </td>
        </tr>
      </thead>
      <tbody>
        {props.rows.map((row) => (
          <tr key={row.name}>
            <td style={compactDataCell}>{row.name}</td>
            <td style={{ ...compactDataCell, textAlign: 'right' }}>
              {row.sold}
            </td>
            <td
              style={{
                ...compactDataCell,
                textAlign: 'right',
                color: INK_SOFT,
                paddingRight: 0,
              }}
            >
              {row.relieved}
            </td>
          </tr>
        ))}
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
          <td
            style={{
              ...compactHeaderCell,
              textAlign: 'right',
              paddingRight: 0,
            }}
          >
            Sold
          </td>
        </tr>
      </thead>
      <tbody>
        {props.rows.map((row) => (
          <tr key={row.name}>
            <td style={compactDataCell}>{row.name}</td>
            <td
              style={{
                ...compactDataCell,
                textAlign: 'right',
                paddingRight: 0,
              }}
            >
              {row.sold}
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  </div>
);

export const BucketsSection = (props: Props) => {
  const { b } = props;
  const realSold = b.real.reduce((sum, r) => sum + r.sold, 0);
  const realRelieved = b.real.reduce((sum, r) => sum + r.relieved, 0);
  const bmSold = b.black_market.reduce((sum, r) => sum + r.sold, 0);
  return (
    <div style={compactCardStyle}>
      <SummarySegment
        title="Navigator Buckets"
        items={[
          { label: 'Real market sold', value: realSold },
          { label: 'Saturation cleared', value: realRelieved },
          { label: 'Black market sold', value: bmSold },
        ]}
      />
      <div style={dividedTwoColumnLayout}>
        <RealMarketTable rows={b.real} />
        <div style={verticalDividerStyle} />
        <BlackMarketTable rows={b.black_market} />
      </div>
    </div>
  );
};
