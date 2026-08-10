import { formatSigned, signColor } from '../common/format';
import { SEAL_GREEN, SEAL_RED } from '../common/parchment';
import { SummarySegment } from '../common/SummarySegment';
import {
  columnSubheadStyle,
  compactCardStyle,
  Row,
  SectionTitle,
  twoColTable,
  twoColumnLayout,
} from './styles';
import type { EconomySnapshot } from './types';

type Props = {
  e: EconomySnapshot;
};

const GeneralMammonsColumn = (props: Props) => {
  const { e } = props;
  return (
    <div>
      <div style={columnSubheadStyle}>General Mammons</div>
      <table style={twoColTable}>
        <tbody>
          <Row label="Mammons Circulating" value={e.mammons_held} />
          <Row label="Mammons Deposited" value={e.mammons_deposited} />
          <Row label="Mammons Withdrawn" value={e.mammons_withdrawn} />
          <Row label="Noble Estates Revenue" value={e.noble_income} />
          <Row label="Bathmatron Vault Revenue" value={e.bathmatron_vault} />
          <Row label="Sold to Stockpile" value={e.sold_to_stockpile} />
          <Row label="Peddler Revenue" value={e.peddler} />
        </tbody>
      </table>
    </div>
  );
};

const RoyalCrownColumn = (props: Props) => {
  const { e } = props;
  return (
    <div>
      <div style={columnSubheadStyle}>Royal &amp; Crown</div>
      <table style={twoColTable}>
        <tbody>
          <Row
            label="Merchant's Levy Collected"
            value={e.merchant_levy_collected}
          />
          <Row label="Crown Duty on Levy" value={e.merchant_levy_taxed} />
          <Row
            label="Royal Taxes Evaded"
            value={e.taxes_evaded}
            color={SEAL_RED}
          />
        </tbody>
      </table>
    </div>
  );
};

export const EconomySection = (props: Props) => {
  const { e } = props;
  const netFlow = e.mammons_deposited - e.mammons_withdrawn;
  return (
    <div style={compactCardStyle}>
      <SectionTitle>Economy</SectionTitle>
      <SummarySegment
        items={[
          { label: 'Circulating', value: e.mammons_held },
          {
            label: 'Banked net',
            value: formatSigned(netFlow),
            color: signColor(netFlow),
          },
          {
            label: 'Levy collected',
            value: e.merchant_levy_collected,
            color: SEAL_GREEN,
          },
        ]}
      />
      <div style={twoColumnLayout}>
        <GeneralMammonsColumn e={e} />
        <RoyalCrownColumn e={e} />
      </div>
    </div>
  );
};
