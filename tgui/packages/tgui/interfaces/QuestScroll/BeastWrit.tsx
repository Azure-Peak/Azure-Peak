import { RecoveryAddendum } from './HumanoidWrit';
import { RewardClause } from './RewardClause';
import { SealLine } from './Seals';
import { writParagraph } from './shared';

export const BeastWrit = (props: {
  nameSingular?: string | null;
  realm: string;
  crimes: string[];
  reward: number;
  levyRate: number;
  levyExempt: boolean;
  guildCutRate: number;
  rulerTitle: string;
  issuedBy?: string;
  issuedOn?: string | null;
  bearer?: string;
  hasRecoveryAddendum?: boolean;
  recoveryShipment?: string | null;
  recoveryDestination?: string | null;
  recoveryCircumstance?: string;
}) => {
  const {
    nameSingular,
    realm,
    crimes,
    reward,
    levyRate,
    levyExempt,
    guildCutRate,
    rulerTitle,
    issuedBy,
    issuedOn,
    bearer,
    hasRecoveryAddendum,
    recoveryShipment,
    recoveryDestination,
    recoveryCircumstance,
  } = props;
  const beast = nameSingular || 'beast';
  const deeds =
    crimes && crimes.length > 0 ? (
      <>
        It hath{' '}
        {crimes.map((c, i) => (
          <span key={i}>
            {c}
            {i < crimes.length - 2
              ? ', '
              : i === crimes.length - 2
                ? ', and '
                : ''}
          </span>
        ))}
        .
      </>
    ) : null;
  return (
    <>
      <p style={writParagraph}>
        A {beast} preys upon {realm}, to the great hurt of the country.
      </p>
      {deeds && <p style={writParagraph}>{deeds}</p>}
      <p style={writParagraph}>
        This writ shall mark itself when the beast is slain. Return it then to
        the Contract Ledger, and the sum of{' '}
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
          category="beast"
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
