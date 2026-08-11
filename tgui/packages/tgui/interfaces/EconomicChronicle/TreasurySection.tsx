import { formatPct, formatSigned, signColor } from '../common/format';
import { SEAL_GREEN, SEAL_RED } from '../common/parchment';
import { SummarySegment } from '../common/SummarySegment';
import {
  Breakdown,
  columnSubheadStyle,
  compactCardStyle,
  dividerStyle,
  Row,
  Tally,
  twoColTable,
  twoColumnLayout,
} from './styles';
import type { TreasurySnapshot } from './types';

type Props = {
  t: TreasurySnapshot;
  balance: number;
};

const TaxationColumn = (props: { t: TreasurySnapshot }) => {
  const { t } = props;
  return (
    <div>
      <div style={columnSubheadStyle}>Taxation</div>
      <table style={twoColTable}>
        <tbody>
          <Row label="Rural Taxes Collected" value={t.rural_taxes} />
          <Row label="Poll Tax Collected" value={t.poll.total} />
        </tbody>
      </table>
      <Tally
        items={[
          { label: 'Noble', value: t.poll.noble },
          { label: 'Clergy', value: t.poll.clergy },
          { label: 'Inquisition', value: t.poll.inquisition },
          { label: 'Courtier', value: t.poll.courtier },
          { label: 'Garrison', value: t.poll.garrison },
          { label: 'Guilds', value: t.poll.guilds },
          { label: 'Merchant', value: t.poll.merchant },
          { label: 'Burgher', value: t.poll.burgher },
          { label: 'Adventurer', value: t.poll.adventurer },
          { label: 'Mercenary', value: t.poll.mercenary },
          { label: 'Peasant', value: t.poll.peasant },
        ]}
      />
      <table style={twoColTable}>
        <tbody>
          <Row label="Royal Fines Collected" value={t.fines_income} />
          <Row label="Royal Taxes Collected" value={t.royal.total} />
        </tbody>
      </table>
      <Tally
        items={[
          { label: 'Contract Levy', value: t.royal.contract_levy },
          { label: 'Headeater Levy', value: t.royal.headeater_levy },
          { label: 'Import Tariff', value: t.royal.import_tariff },
          { label: 'Export Duty', value: t.royal.export_duty },
          { label: 'Other', value: t.royal.other_fees },
        ]}
      />
    </div>
  );
};

const CommerceColumn = (props: { t: TreasurySnapshot }) => {
  const { t } = props;
  return (
    <div>
      <div style={columnSubheadStyle}>Commerce</div>
      <table style={twoColTable}>
        <tbody>
          <Row label="Stockpile Exports" value={t.stockpile_exports} />
          <Row label="Bought from Stockpile" value={t.stockpile_revenue} />
          <Row label="Direct Imports" value={t.stockpile_direct_imports} />
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
          <Row label="Trade Balance" value={formatSigned(t.trade_balance)} color={signColor(t.trade_balance)} />
          <Row label="Foreign Trade Volume" value={t.foreign_trade_volume} />
        </tbody>
      </table>
    </div>
  );
};

const NotCollectedColumn = (props: { t: TreasurySnapshot }) => {
  const { t } = props;
  return (
    <div>
      <div style={columnSubheadStyle}>Not Collected</div>
      <table style={twoColTable}>
        <tbody>
          <Row label="Forgone Revenue" value={t.exempt.total} />
        </tbody>
      </table>
      <Tally
        items={[
          { label: 'Contract', value: t.exempt.contract },
          { label: 'Headeater', value: t.exempt.headeater },
          { label: 'Import', value: t.exempt.import },
          { label: 'Export', value: t.exempt.export },
          { label: 'Fines', value: t.exempt.fines },
          { label: 'Poll Tax', value: t.exempt.poll_tax },
        ]}
      />
      <table style={twoColTable}>
        <tbody>
          <Row
            label="Royal Taxes Evaded"
            value={t.taxes_evaded}
            color={SEAL_RED}
          />
          <Row label="Forgone Share" value={formatPct(t.exemption_share)} />
        </tbody>
      </table>
    </div>
  );
};

const ObligationsColumn = (props: { t: TreasurySnapshot }) => {
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
      <div style={columnSubheadStyle}>Obligations</div>
      {t.banditry_owed > 0 && (
        <Breakdown>Banditry: {t.banditry_owed} still owed</Breakdown>
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
    </div>
  );
};

export const TreasurySection = (props: Props) => {
  const { t, balance } = props;
  const hasObligations =
    t.banditry_owed > 0 ||
    t.bankruptcy_count > 0 ||
    t.arrears_count > 0 ||
    t.treasury_debt_repaid > 0 ||
    t.treasury_debt_owed > 0 ||
    t.forfeiture_amount > 0 ||
    t.forfeiture_count > 0;
  return (
    <div style={compactCardStyle}>
      <SummarySegment
        title="Realm's Treasury"
        subtitle={`Balance: ${balance}`}
        items={[
          { label: 'Start', value: t.starting },
          { label: 'In', value: t.total_revenue, color: SEAL_GREEN },
          { label: 'Out', value: t.total_expenses, color: SEAL_RED },
          {
            label: 'Remain',
            value: `${balance} (${formatSigned(t.net_treasury)})`,
            color: signColor(t.net_treasury),
          },
          {
            label: 'Tax rate',
            value:
              t.effective_tax_rate === null
                ? null
                : formatPct(t.effective_tax_rate),
          },
        ]}
      />
      <div style={twoColumnLayout}>
        <TaxationColumn t={t} />
        <CommerceColumn t={t} />
      </div>
      <div style={dividerStyle} />
      <div style={twoColumnLayout}>
        <div>
          <table style={twoColTable}>
            <tbody>
              <Row
                label="Total Revenue"
                value={t.total_revenue}
                color={SEAL_GREEN}
              />
              {t.other_income > 0 && (
                <Row label="of which uncategorised" value={t.other_income} />
              )}
              <Row
                label="Total Expenses"
                value={t.total_expenses}
                color={SEAL_RED}
              />
              {t.unattributed_expenses > 0 && (
                <Row
                  label="of which unattributed"
                  value={t.unattributed_expenses}
                />
              )}
            </tbody>
          </table>
        </div>
        <NotCollectedColumn t={t} />
      </div>
      {hasObligations && <ObligationsColumn t={t} />}
    </div>
  );
};
