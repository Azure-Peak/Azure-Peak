import { formatSigned, signColor } from '../common/format';
import { SEAL_GREEN, SEAL_RED } from '../common/parchment';
import { SummarySegment } from '../common/SummarySegment';
import {
  Breakdown,
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

const VendorsColumn = (props: Props) => {
  const { e } = props;
  return (
    <div>
      <div style={columnSubheadStyle}>Vendors</div>
      <table style={twoColTable}>
        <tbody>
          <Row label="GOLDFACE Imports" value={e.goldface} />
          <Row label="SILVERFACE Imports" value={e.silverface} />
          <Row label="COPPERFACE Imports" value={e.copperface} />
          <Row label="PURITY Imports" value={e.purity} />
        </tbody>
      </table>
      <div style={{ ...columnSubheadStyle, marginTop: '6px' }}>Favor</div>
      <table style={twoColTable}>
        <tbody>
          <Row label="Send-offs" value={e.favor_from_sendoffs} />
          <Row label="Navigator" value={e.favor_from_navigator} />
          <Row label="Goldface" value={e.favor_from_goldface} />
          <Row label="Silverface" value={e.favor_from_silverface} />
          <Row label="Penalties" value={e.favor_penalties} color={SEAL_RED} />
          <Row label="Lifetime Peak" value={e.favor_high} />
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
        </tbody>
      </table>
      <div style={{ ...columnSubheadStyle, marginTop: '6px' }}>Levy</div>
      <table style={twoColTable}>
        <tbody>
          <Row
            label="Merchant's Levy Collected"
            value={e.merchant_levy_collected}
          />
          <Row label="Crown Duty on Levy" value={e.merchant_levy_taxed} />
        </tbody>
      </table>
    </div>
  );
};

export const MerchantSection = (props: Props) => {
  const { e } = props;
  const balance = e.trade_exported_total - e.trade_imported;
  return (
    <div style={compactCardStyle}>
      <SummarySegment
        title="Merchant Trade"
        items={[
          {
            label: 'Trade balance',
            value: formatSigned(balance),
            color: signColor(balance),
          },
          {
            label: 'Exported',
            value: e.trade_exported_total,
            color: SEAL_GREEN,
          },
          { label: 'Imported', value: e.trade_imported },
          { label: 'Favor peak', value: e.favor_high },
        ]}
      />
      <div style={twoColumnLayout}>
        <VendorsColumn e={e} />
        <TradeMarketsColumn e={e} />
      </div>
    </div>
  );
};
