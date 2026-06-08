import {
  cardStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  pageStyle,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  sectionHeaderStyle,
  SERIF,
} from '../../common/parchment';
import type { FundLogEntry, HarborData } from '../types';

const labelStyle = {
  fontFamily: SERIF,
  fontSize: FONT_BODY,
  color: SEAL_AMBER,
  letterSpacing: '0.04em',
};

const valueStyle = {
  fontFamily: SERIF,
  fontSize: FONT_BODY,
  color: INK,
};

const noteStyle = {
  fontFamily: SERIF,
  fontSize: FONT_BODY,
  fontStyle: 'italic' as const,
  color: INK_SOFT,
  lineHeight: 1.4,
};

const BalanceCard = (props: { balance: number }) => (
  <div
    style={{
      ...cardStyle,
      marginTop: '4px',
      marginBottom: '6px',
      padding: '4px 12px',
      display: 'grid',
      gridTemplateColumns: '1fr auto',
      alignItems: 'baseline',
      columnGap: '12px',
    }}
  >
    <span style={labelStyle}>Merchant Fund balance</span>
    <span
      style={{
        fontFamily: SERIF,
        fontSize: '18px',
        fontWeight: 'bold',
        color: INK,
      }}
    >
      {props.balance}m
    </span>
  </div>
);

const StatRow = (props: { label: string; value: string; tone?: string }) => (
  <>
    <span style={{ color: INK }}>{props.label}</span>
    <span
      style={{
        ...valueStyle,
        textAlign: 'right',
        fontWeight: 'bold',
        color: props.tone || INK,
      }}
    >
      {props.value}
    </span>
  </>
);

const FundLogRow = (props: { entry: FundLogEntry }) => {
  const { entry } = props;
  const color = entry.amount >= 0 ? SEAL_GREEN : SEAL_RED;
  const sign = entry.amount >= 0 ? '+' : '';
  return (
    <div
      style={{
        display: 'grid',
        gridTemplateColumns: 'minmax(0, 1fr) 80px',
        columnGap: '8px',
        padding: '3px 4px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontSize: FONT_BODY,
        color: INK,
      }}
    >
      <span
        style={{
          overflow: 'hidden',
          textOverflow: 'ellipsis',
          whiteSpace: 'nowrap',
        }}
      >
        {entry.source}
      </span>
      <span style={{ textAlign: 'right', color, fontWeight: 'bold' }}>
        {sign}
        {entry.amount}m
      </span>
    </div>
  );
};

export const LedgerTab = (props: { harbor?: HarborData }) => {
  const { harbor } = props;
  if (!harbor) {
    return (
      <div style={pageStyle}>
        <div style={{ ...cardStyle, textAlign: 'center', color: INK_SOFT }}>
          The ledgers are not yet drawn up.
        </div>
      </div>
    );
  }
  const ledger = harbor.ledger;
  return (
    <div style={pageStyle}>
      <BalanceCard balance={ledger.merchant_fund_balance} />

      <div style={{ ...cardStyle, marginTop: '0', marginBottom: '6px', padding: '6px 12px' }}>
        <div style={{ ...sectionHeaderStyle, marginTop: 0, marginBottom: '4px' }}>Week Audit</div>
        <div
          style={{
            display: 'grid',
            gridTemplateColumns: '1fr auto',
            rowGap: '4px',
            columnGap: '12px',
            paddingTop: '4px',
          }}
        >
          <StatRow
            label="Merchant's levy collected"
            value={`+${ledger.levy_collected}m`}
            tone={SEAL_GREEN}
          />
          <StatRow
            label="Crown duty paid on levy"
            value={`-${ledger.levy_taxed}m`}
            tone={SEAL_RED}
          />
          <StatRow
            label="Company Gnomes margin"
            value={`+${ledger.gnome_margin_collected}m`}
            tone={SEAL_GREEN}
          />
        </div>
        <div style={{ ...noteStyle, marginTop: '6px' }}>
          All credits deposit into the Merchant Fund at your Jawbank. The Crown
          taxes the levy at the prevailing export duty rate; the gnome margin is
          captured at the listed Silverface rate.
        </div>
      </div>

      <div style={{ ...cardStyle, marginTop: '0', marginBottom: '6px', padding: '6px 12px' }}>
        <div style={{ ...sectionHeaderStyle, marginTop: 0, marginBottom: '4px' }}>Recent Fund Movements</div>
        {ledger.fund_log.length === 0 ? (
          <div style={{ ...noteStyle, padding: '4px 0' }}>
            No movements recorded yet this week.
          </div>
        ) : (
          ledger.fund_log.map((entry, idx) => (
            <FundLogRow key={idx} entry={entry} />
          ))
        )}
        {ledger.fund_log.length > 0 && (
          <div style={{ ...noteStyle, marginTop: '6px' }}>
            Most recent first. Older entries roll off after twelve.
          </div>
        )}
      </div>

      <div style={{ ...cardStyle, marginTop: '0', marginBottom: '6px', padding: '6px 12px' }}>
        <div style={{ ...sectionHeaderStyle, marginTop: 0, marginBottom: '4px' }}>Silverface Margin</div>
        {harbor.favor.gnome_unlocked ? (
          <>
            <div style={{ ...noteStyle, marginBottom: '4px' }}>
              By writ of the Azurean Guild of Gnomes Porters, the public stalls now run under their hand. They take their cost in labour and remit the margin of <b>+{ledger.silverface_margin_percent}%</b> on every sale unto the Merchant Fund. Adjust the rate from the Management tab as you see fit.
            </div>
            <div style={{ color: INK_FAINT, fontSize: FONT_BODY, fontStyle: 'italic' }}>
              A heavier margin fattens the Fund per sale; a lighter one draws more buyers to the stalls.
            </div>
          </>
        ) : (
          <div style={noteStyle}>
            By standing pact, the Azurean Guild of Porters and Stevedores hold the margin upon a fixed measure of trade each week. Should you push enough goods through the Company&apos;s books, your standing shall earn the right to call in their Gnomes - who will take their wage in labour alone and remit the margin to your Fund.
          </div>
        )}
      </div>
    </div>
  );
};
