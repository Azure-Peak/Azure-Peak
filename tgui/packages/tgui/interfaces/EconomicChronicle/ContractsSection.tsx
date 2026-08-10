import { withPct } from '../common/format';
import { SEAL_AMBER, SEAL_GREEN, SEAL_RED } from '../common/parchment';
import { SummarySegment } from '../common/SummarySegment';
import {
  Breakdown,
  compactCardStyle,
  dividedTwoColumnLayout,
  dividerStyle,
  Row,
  twoColTable,
  verticalDividerStyle,
} from './styles';
import type { ContractsSnapshot, RoyalFavorsSnapshot } from './types';

type Props = {
  c: ContractsSnapshot;
  rf: RoyalFavorsSnapshot;
};

const ContractsColumn = (props: { c: ContractsSnapshot }) => {
  const { c } = props;
  return (
    <div>
      <table style={twoColTable}>
        <tbody>
          <Row label="Contracts Issued" value={c.generated_total} />
        </tbody>
      </table>
      <Breakdown>
        Guild {c.generated_pool} &bull; Tavern {c.generated_rumor} &bull; Crown{' '}
        {c.generated_defense}
      </Breakdown>
      <table style={twoColTable}>
        <tbody>
          <Row label="Contracts Taken" value={c.taken_total} />
        </tbody>
      </table>
      <Breakdown>
        Guild {c.taken_pool} &bull; Tavern {c.taken_rumor} &bull; Crown{' '}
        {c.taken_defense}
      </Breakdown>
      <table style={twoColTable}>
        <tbody>
          <Row
            label="Contracts Completed"
            value={c.completed_total}
            color={SEAL_GREEN}
          />
        </tbody>
      </table>
      <Breakdown>
        Guild {c.completed_pool} &bull; Tavern {c.completed_rumor} &bull; Crown{' '}
        {c.completed_defense}
      </Breakdown>
      <table style={twoColTable}>
        <tbody>
          <Row label="Abandoned" value={c.abandoned} />
          <Row label="Rerolled" value={c.rerolled} />
        </tbody>
      </table>
    </div>
  );
};

const FavorsColumn = (props: {
  c: ContractsSnapshot;
  rf: RoyalFavorsSnapshot;
}) => {
  const { c, rf } = props;
  return (
    <div>
      <table style={twoColTable}>
        <tbody>
          <Row label="Mammons Paid" value={c.mammons_paid} />
          <Row label="Mammons Taxed" value={c.mammons_taxed} />
          <Row
            label="Mammons Forfeited"
            value={c.mammons_forfeited}
            color={SEAL_RED}
          />
        </tbody>
      </table>
      <div style={dividerStyle} />
      <table style={twoColTable}>
        <tbody>
          <Row label="Pledge Generated" value={rf.pledge_generated} />
          <Row label="Pledge Consumed" value={rf.pledge_consumed} />
          <Row
            label="Pledge Unused"
            value={rf.pledge_unused}
            color={SEAL_AMBER}
          />
          <Row label="Rumor Points Generated" value={rf.rumor_generated} />
          <Row label="Rumor Points Consumed" value={rf.rumor_consumed} />
          <Row
            label="Rumor Points Unused"
            value={rf.rumor_unused}
            color={SEAL_AMBER}
          />
        </tbody>
      </table>
    </div>
  );
};

export const ContractsSection = (props: Props) => {
  const { c } = props;
  const completion =
    c.taken_total > 0
      ? Math.round((c.completed_total / c.taken_total) * 1000) / 10
      : null;
  return (
    <div style={compactCardStyle}>
      <SummarySegment
        title="Guild Contracts &amp; Royal Favors"
        items={[
          { label: 'Issued', value: c.generated_total },
          { label: 'Taken', value: c.taken_total },
          {
            label: 'Completed',
            value: withPct(c.completed_total, completion),
            color: SEAL_GREEN,
          },
          { label: 'Paid out', value: `${c.mammons_paid}m` },
        ]}
      />
      <div style={dividedTwoColumnLayout}>
        <ContractsColumn c={props.c} />
        <div style={verticalDividerStyle} />
        <FavorsColumn c={props.c} rf={props.rf} />
      </div>
    </div>
  );
};
