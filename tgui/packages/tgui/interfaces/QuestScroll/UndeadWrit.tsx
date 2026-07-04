import { RecoveryAddendum } from './HumanoidWrit';
import { RewardClause } from './RewardClause';
import { SealLine } from './Seals';
import { writParagraph } from './shared';

export const UndeadWrit = (props: {
  realm: string;
  rulerTitle: string;
  groupWord?: string | null;
  namePlural?: string | null;
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

  return (
    <>
      <p style={writParagraph}>
        <i>By writ of the {rulerTitle}, in the keeping of Necra:</i>
      </p>
      <p style={writParagraph}>
        The dead walk again upon {realm}. A {host} of {folk}, denied the rest
        that is their due, stir from earth and barrow. They bear no name worth
        speaking, no oath worth breaking, no soul to weigh: only the wound
        that has not closed.
      </p>
      <p style={writParagraph}>
        <i>
          Requiem aeternam. They are not to be hated. They are to be put back
          into the keeping of Necra, that her veil may close over them once
          more.
        </i>
      </p>
      <p style={writParagraph}>
        Bring them down with steel, with fire, with prayer. The writ knows
        their stirring and shall mark itself when peace is restored. Return
        the writ to the Contract Ledger, that the bounty of{' '}
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
