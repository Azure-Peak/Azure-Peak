import { RecoveryAddendum } from './HumanoidWrit';
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
    issuedBy,
    issuedOn,
    bearer,
    hasRecoveryAddendum,
    recoveryShipment,
    recoveryDestination,
    recoveryCircumstance,
  } = props;
  const showLevy = !levyExempt && levyRate > 0;
  const net = showLevy ? Math.round(reward * (1 - levyRate)) : reward;
  const folk = namePlural || 'spawn';
  const band = groupWord || 'warband';
  return (
    <>
      <p style={writParagraph}>
        <i>Notice posted by writ of the {rulerTitle}:</i>
      </p>
      <p style={writParagraph}>
        A {band} of <b>{folk}</b> infests the lands of {realm}. Spawn of the
        dark stars, who sing to false gods and answer to no law. Such things
        bear no name worth summons, no oath worth breaking, no soul worth
        weighing.
      </p>
      <p style={writParagraph}>
        <span style={caputLupinum}>SLAY THEM</span>, root and branch, where
        they nest. The writ knows the brood and shall mark itself when the
        deed is done.
      </p>
      <p style={writParagraph}>
        Return the writ to the Contract Ledger and the bounty of{' '}
        <b>{reward} mammon</b>
        {showLevy ? (
          <>
            , <b>{net} mammon</b> after the Crown&apos;s Levy
          </>
        ) : null}{' '}
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
