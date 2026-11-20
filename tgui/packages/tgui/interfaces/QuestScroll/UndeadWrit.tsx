import { RecoveryAddendum } from './HumanoidWrit';
import { RewardClause } from './RewardClause';
import { SealLine } from './Seals';
import { writParagraph } from './shared';

export const UndeadWrit = (props: {
  realm: string;
  rulerTitle: string;
  groupWord?: string | null;
  namePlural?: string | null;
  ringleader?: string | null;
  reward: number;
  levyRate: number;
  levyExempt: boolean;
  guildCutRate: number;
  issuedBy?: string;
  issuedOn?: string | null;
  bearer?: string;
  hasRecoveryAddendum?: boolean;
  recoveryShipment?: string | null;
  recoveryDestination?: string | null;
  recoveryCircumstance?: string;
}) => {
  const {
    realm,
    rulerTitle,
    groupWord,
    namePlural,
    ringleader,
    reward,
    levyRate,
    levyExempt,
    guildCutRate,
    issuedBy,
    issuedOn,
    bearer,
    hasRecoveryAddendum,
    recoveryShipment,
    recoveryDestination,
    recoveryCircumstance,
  } = props;
  const folk = namePlural || 'unquiet dead';
  const host = groupWord || 'host';
  const leader = ringleader ? (
    <>
      {' '}
      and led by one called <b>{ringleader}</b>
    </>
  ) : null;

  return (
    <>
      <p style={writParagraph}>
        <i>By writ of the {rulerTitle}, in the keeping of Necra:</i>
      </p>
      <p style={writParagraph}>
        The dead walk again upon {realm}: a {host} of {folk}, risen from their
        graves
        {leader}.
      </p>
      <p style={writParagraph}>
        <i>
          Requiem aeternam. Return them to the keeping of Necra, that her veil
          may close over them once more.
        </i>
      </p>
      <p style={writParagraph}>
        Put them down by steel or fire. This writ shall mark itself when they
        are destroyed. Return it then to the Contract Ledger, that the sum
        of{' '}
        <RewardClause
          reward={reward}
          levyRate={levyRate}
          levyExempt={levyExempt}
          guildCutRate={guildCutRate}
        />{' '}
        be paid.
      </p>
      {hasRecoveryAddendum && (
        <RecoveryAddendum
          shipment={recoveryShipment}
          destination={recoveryDestination}
          circumstance={recoveryCircumstance}
          category="undead"
        />
      )}
      <SealLine
        rulerTitle={rulerTitle}
        issuedBy={issuedBy}
        issuedOn={issuedOn}
        bearer={bearer}
      />
    </>
  );
};
