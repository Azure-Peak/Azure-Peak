import {
  FONT_BODY,
  SEAL_GREEN,
  SEAL_RED,
  subtitleStyle,
} from '../common/parchment';
import {
  Breakdown,
  compactCardStyle,
  dividerStyle,
  formatPct,
  Row,
  SectionTitle,
  twoColTable,
  twoColumnLayout,
} from './styles';
import type { TreasurySnapshot } from './types';

type Props = {
  t: TreasurySnapshot;
  balance: number;
};

const RevenueColumn = (props: { t: TreasurySnapshot }) => {
  const { t } = props;
  return (
    <div>
      <table style={twoColTable}>
        <tbody>
          <Row label="Starting Treasury" value={t.starting} />
          <Row label="Rural Taxes Collected" value={t.rural_taxes} />
          <Row label="Poll Tax Collected" value={t.poll.total} />
        </tbody>
      </table>
      <Breakdown>
        Noble {t.poll.noble} &bull; Clergy {t.poll.clergy} &bull; Inquisition{' '}
        {t.poll.inquisition} &bull; Courtier {t.poll.courtier} &bull; Garrison{' '}
        {t.poll.garrison} &bull; Guilds {t.poll.guilds} &bull; Merchant{' '}
        {t.poll.merchant} &bull; Burgher {t.poll.burgher} &bull; Adventurer{' '}
        {t.poll.adventurer} &bull; Mercenary {t.poll.mercenary} &bull; Peasant{' '}
        {t.poll.peasant}
      </Breakdown>
      <table style={twoColTable}>
        <tbody>
          <Row label="Royal Fines Collected" value={t.fines_income} />
          <Row label="Royal Taxes Collected" value={t.royal.total} />
        </tbody>
      </table>
      <Breakdown>
        Contract Levy {t.royal.contract_levy} &bull; Headeater Levy{' '}
        {t.royal.headeater_levy} &bull; Import Tariff {t.royal.import_tariff}{' '}
        &bull; Export Duty {t.royal.export_duty} &bull; Other{' '}
        {t.royal.other_fees}
      </Breakdown>
      <table style={twoColTable}>
        <tbody>
          <Row label="Stockpile Exports" value={t.stockpile_exports} />
          <Row label="Bought from Stockpile" value={t.stockpile_revenue} />
          <Row
            label="Direct Imports"
            value={t.stockpile_direct_imports}
          />
          <Row label="Standing Order Revenue" value={t.standing.revenue} />
        </tbody>
      </table>
      <Breakdown>
        {t.standing.fulfilled} fulfilled &bull; {t.standing.expired} expired{' '}
        &bull; {t.standing.petitioned} petitioned (
        {t.standing.petition_pledge_spent}p spent)
      </Breakdown>
      <table style={twoColTable}>
        <tbody>
          <Row label="Shortages Ended Early" value={t.shortages_ended} />
        </tbody>
      </table>
      <div style={dividerStyle} />
      <table style={twoColTable}>
        <tbody>
          <Row label="Total Revenue" value={t.total_revenue} color={SEAL_GREEN} />
        </tbody>
      </table>
    </div>
  );
};

const ExpensesColumn = (props: { t: TreasurySnapshot }) => {
  const { t } = props;
  const debtLabel = t.bankruptcy_count > 0 ? 'Receivership' : 'Arrears';
  const debtColor = t.bankruptcy_count > 0 ? '#c0392b' : '#e07b39';
  const debtPieces = [
    t.arrears_count > 0 ? `${t.arrears_count}x arrears` : '',
    t.bankruptcy_count > 0 ? `${t.bankruptcy_count}x bankruptcy` : '',
  ].filter(Boolean);
  const debtValue = debtPieces.join(', ');
  const showDebtRow =
    t.bankruptcy_count > 0 ||
    t.arrears_count > 0 ||
    t.treasury_debt_repaid > 0 ||
    t.treasury_debt_owed > 0;
  const showForfeiture = t.forfeiture_amount > 0 || t.forfeiture_count > 0;
  return (
    <div>
      <table style={twoColTable}>
        <tbody>
          <Row label="Salary Payments" value={t.wages_paid} />
          <Row label="Treasury Transfers" value={t.treasury_transfers} />
          <Row label="Stockpile Imports" value={t.stockpile_imports} />
          <Row
            label="Banditry Losses"
            value={t.banditry_losses}
            color={SEAL_RED}
          />
        </tbody>
      </table>
      {t.banditry_owed > 0 && (
        <Breakdown>{t.banditry_owed} still owed</Breakdown>
      )}
      {showDebtRow && (
        <table style={twoColTable}>
          <tbody>
            <Row label={debtLabel} value={debtValue} color={debtColor} />
          </tbody>
        </table>
      )}
      {(t.treasury_debt_repaid > 0 || t.treasury_debt_owed > 0) && (
        <Breakdown>
          {t.treasury_debt_repaid > 0 && `${t.treasury_debt_repaid} repaid`}
          {t.treasury_debt_repaid > 0 && t.treasury_debt_owed > 0 && ', '}
          {t.treasury_debt_owed > 0 && `${t.treasury_debt_owed} still owed`}
        </Breakdown>
      )}
      {showForfeiture && (
        <>
          <table style={twoColTable}>
            <tbody>
              <Row label="Forfeitures" value={`${t.forfeiture_amount}m`} />
            </tbody>
          </table>
          {t.forfeiture_count > 0 && (
            <Breakdown>
              from {t.forfeiture_count} departing Keep insider
              {t.forfeiture_count === 1 ? '' : 's'}
            </Breakdown>
          )}
        </>
      )}
      <table style={twoColTable}>
        <tbody>
          <Row label="Forgone Revenue" value={t.exempt.total} />
        </tbody>
      </table>
      <Breakdown>
        Contract {t.exempt.contract} &bull; Headeater {t.exempt.headeater}{' '}
        &bull; Import {t.exempt.import} &bull; Export {t.exempt.export}{' '}
        &bull; Fines {t.exempt.fines} &bull; Poll Tax {t.exempt.poll_tax}
      </Breakdown>
      <div style={dividerStyle} />
      <table style={twoColTable}>
        <tbody>
          <Row label="Total Expenses" value={t.total_expenses} color={SEAL_RED} />
        </tbody>
      </table>
    </div>
  );
};

const RealmInsight = (props: { t: TreasurySnapshot }) => {
  const { t } = props;
  const netColor = t.net_treasury >= 0 ? SEAL_GREEN : SEAL_RED;
  const tradeColor = t.trade_balance >= 0 ? SEAL_GREEN : SEAL_RED;
  const netSign = t.net_treasury >= 0 ? '+' : '';
  const tradeSign = t.trade_balance >= 0 ? '+' : '';
  return (
    <div
      style={{
        ...subtitleStyle,
        marginTop: '6px',
        marginBottom: 0,
        textAlign: 'left',
        fontSize: FONT_BODY,
      }}
    >
      <table style={twoColTable}>
        <tbody>
          <Row
            label="Net Treasury Result"
            value={`${netSign}${t.net_treasury}`}
            color={netColor}
          />
          <Row
            label="Trade Balance"
            value={`${tradeSign}${t.trade_balance}`}
            color={tradeColor}
          />
          <Row label="Foreign Trade Volume" value={t.foreign_trade_volume} />
          <Row
            label="Effective Tax Rate"
            value={formatPct(t.effective_tax_rate)}
          />
          <Row label="Forgone Share" value={formatPct(t.exemption_share)} />
        </tbody>
      </table>
    </div>
  );
};

export const TreasurySection = (props: Props) => {
  const { t, balance } = props;
  return (
    <div style={compactCardStyle}>
      <SectionTitle>Realm&apos;s Treasury - balance: {balance}</SectionTitle>
      <div style={twoColumnLayout}>
        <RevenueColumn t={t} />
        <ExpensesColumn t={t} />
      </div>
      <RealmInsight t={t} />
    </div>
  );
};
