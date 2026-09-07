import { formatSigned, signColor } from '../common/format';
import { SEAL_GREEN } from '../common/parchment';
import { SummarySegment } from '../common/SummarySegment';
import {
  columnSubheadStyle,
  compactCardStyle,
  Row,
  twoColTable,
  twoColumnLayout,
} from './styles';
import type { EconomySnapshot } from './types';

type Props = {
  e: EconomySnapshot;
};

const CoinColumn = (props: Props) => {
  const { e } = props;
  return (
    <div>
      <div style={columnSubheadStyle}>Coin in Circulation</div>
      <table style={twoColTable}>
        <tbody>
          <Row label="Held by Subjects" value={e.mammons_held} />
          <Row label="Deposited" value={e.mammons_deposited} />
          <Row label="Withdrawn" value={e.mammons_withdrawn} />
        </tbody>
      </table>
    </div>
  );
};

const PrivateEarningsColumn = (props: Props) => {
  const { e } = props;
  return (
    <div>
      <div style={columnSubheadStyle}>Private Earnings</div>
      <table style={twoColTable}>
        <tbody>
          <Row label="Noble Estates" value={e.noble_income} />
          <Row label="Bathmatron Vault" value={e.bathmatron_vault} />
          <Row label="Sold to Stockpile" value={e.sold_to_stockpile} />
          <Row label="Peddler" value={e.peddler} />
        </tbody>
      </table>
    </div>
  );
};

export const EconomySection = (props: Props) => {
  const { e } = props;
  const netFlow = e.mammons_deposited - e.mammons_withdrawn;
  const earnings =
    e.noble_income + e.bathmatron_vault + e.sold_to_stockpile + e.peddler;
  return (
    <div style={compactCardStyle}>
      <SummarySegment
        title="Private Wealth"
        items={[
          { label: 'Circulating', value: e.mammons_held },
          {
            label: 'Banked net',
            value: formatSigned(netFlow),
            color: signColor(netFlow),
          },
          { label: 'Private earnings', value: earnings, color: SEAL_GREEN },
        ]}
      />
      <div style={twoColumnLayout}>
        <CoinColumn e={e} />
        <PrivateEarningsColumn e={e} />
      </div>
    </div>
  );
};
