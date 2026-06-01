import { SEAL_RED } from '../common/parchment';
import {
  Breakdown,
  columnSubheadStyle,
  compactCardStyle,
  Row,
  SectionTitle,
  threeColumnLayout,
  twoColTable,
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
      <div style={{ ...columnSubheadStyle, marginTop: '6px' }}>Vendors</div>
      <table style={twoColTable}>
        <tbody>
          <Row label="GOLDFACE Imports" value={e.goldface} />
          <Row label="SILVERFACE Imports" value={e.silverface} />
          <Row label="COPPERFACE Imports" value={e.copperface} />
          <Row label="PURITY Imports" value={e.purity} />
        </tbody>
      </table>
    </div>
  );
};

const TradeMarketsColumn = (props: Props) => {
  const { e } = props;
  return (
    <div>
      <div style={columnSubheadStyle}>Trade &amp; Markets</div>
      <table style={twoColTable}>
        <tbody>
          <Row label="Trade Value Exported" value={e.trade_exported_total} />
        </tbody>
      </table>
      <Breakdown>
        Real Market {e.trade_exported_real} &bull; Black Market{' '}
        {e.trade_exported_bm}
      </Breakdown>
      <table style={twoColTable}>
        <tbody>
          <Row label="Trade Value Imported" value={e.trade_imported} />
          <Row label="Company Gnomes Margin" value={e.gnome_margin} />
          <Row label="Favor - Send-offs" value={e.favor_from_sendoffs} />
          <Row label="Favor - Navigator" value={e.favor_from_navigator} />
          <Row label="Favor - Goldface" value={e.favor_from_goldface} />
          <Row label="Favor - Silverface" value={e.favor_from_silverface} />
          <Row
            label="Favor - Penalties"
            value={e.favor_penalties}
            color={SEAL_RED}
          />
          <Row label="Favor - Lifetime Peak" value={e.favor_high} />
        </tbody>
      </table>
    </div>
  );
};

export const EconomySection = (props: Props) => {
  return (
    <div style={compactCardStyle}>
      <SectionTitle>Economy</SectionTitle>
      <div style={threeColumnLayout}>
        <GeneralMammonsColumn e={props.e} />
        <RoyalCrownColumn e={props.e} />
        <TradeMarketsColumn e={props.e} />
      </div>
    </div>
  );
};
