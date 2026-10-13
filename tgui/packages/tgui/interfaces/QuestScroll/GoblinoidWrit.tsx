import { RecoveryAddendum } from './HumanoidWrit';
import { RewardClause } from './RewardClause';
import { SealLine } from './Seals';
import { caputLupinum, writParagraph } from './shared';

export const GoblinoidWrit = (props: {
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
  const folk = namePlural || 'spawn';
  const band = groupWord || 'warband';
  return (
    <>
      <p style={writParagraph}>
        <i>Notice posted by writ of the {rulerTitle}:</i>
      </p>
      <p style={writParagraph}>
        A {band} of <b>{folk}</b> infests the lands of {realm}. They are spawn
        of the dark stars and answer to no law. No summons is owed them.
      </p>
      <p style={writParagraph}>
        <span style={caputLupinum}>SLAY THEM</span>, root and branch, where they
        nest. This writ shall mark itself when they are slain.
      </p>
      <p style={writParagraph}>
        Return it then to the Contract Ledger, and the sum of{' '}
        <RewardClause
          reward={reward}
          levyRate={levyRate}
          levyExempt={levyExempt}
          guildCutRate={guildCutRate}
        />{' '}
        shall be paid.
      </p>
      {hasRecoveryAddendum && (
        <RecoveryAddendum
          shipment={recoveryShipment}
          destination={recoveryDestination}
          circumstance={recoveryCircumstance}
          category="goblinoid"
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
