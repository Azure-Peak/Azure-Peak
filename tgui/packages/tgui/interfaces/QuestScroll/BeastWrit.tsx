import { RecoveryAddendum } from './HumanoidWrit';
import { SealLine } from './Seals';
import { writParagraph } from './shared';

export const BeastWrit = (props: {
  nameSingular?: string | null;
  realm: string;
  crimes: string[];
  reward: number;
  levyRate: number;
  levyExempt: boolean;
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
  const showLevy = !levyExempt && levyRate > 0;
  const net = showLevy ? Math.round(reward * (1 - levyRate)) : reward;
  const deeds =
    crimes && crimes.length > 0 ? (
      <>
        It hath{' '}
        {crimes.map((c, i) => (
          <span key={i}>
            {c}
            {i < crimes.length - 2 ? ', ' : i === crimes.length - 2 ? ', and ' : ''}
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
        The writ knows the beast and shall mark itself when the deed is done.
        Return it then to the Contract Ledger, and the bounty of{' '}
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
