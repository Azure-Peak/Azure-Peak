import { RecoveryAddendum } from './HumanoidWrit';
import { SealLine } from './Seals';
import { capitalize, caputLupinum, indictmentItem, indictmentList, writParagraph } from './shared';

export const GronnWrit = (props: {
  realm: string;
  rulerTitle: string;
  named?: string | null;
  ringleader?: string | null;
  groupWord?: string | null;
  namePlural?: string | null;
  crimes: string[];
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
    named,
    ringleader,
    groupWord,
    namePlural,
    crimes,
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
  const folk = namePlural || 'raiders';
  const band = groupWord || 'warband';

  let subject: React.ReactNode;
  if (named) subject = <b>{named}</b>;
  else if (ringleader)
    { subject = (
      <>
        a {band} of {folk} under one called <b>{ringleader}</b>
      </>
    ); }
  else subject = <>a {band} of {folk}</>;

  return (
    <>
      <p style={writParagraph}>
        <i>Be it known unto all who bear arms in {realm}&apos;s defence:</i>
      </p>
      <p style={writParagraph}>
        That {subject} hath been seen upon these shores, sworn to the false
        Four, refusing the holy chrism of the Tens.
      </p>
      {crimes.length > 0 && (
        <>
          <p style={{ ...writParagraph, marginBottom: '4px' }}>
            Whereof they stand accused of:
          </p>
          <ul style={indictmentList}>
            {crimes.map((c, i) => (
              <li key={i} style={indictmentItem}>
                {capitalize(c)};
              </li>
            ))}
          </ul>
        </>
      )}
      <p style={writParagraph}>
        By writ of the {rulerTitle}, and by counsel of the Holy See, let{' '}
        {subject} be declared{' '}
        <span style={caputLupinum}>ANATHEMA</span>: cut off from the body of
        the faithful, harboured by no temple, mourned by no priest. Pursue them
        upon the strand and the cliff; let them not gain the sea before steel
        finds them.
      </p>
      <p style={writParagraph}>
        Upon their death the writ shall fall silent and mark itself; return it
        then to the Contract Ledger, that the bounty of <b>{reward} mammon</b>
        {showLevy ? (
          <>
            , <b>{net} mammon</b> after the Crown&apos;s Levy
          </>
        ) : null}{' '}
        be paid.
      </p>
      {hasRecoveryAddendum && (
        <RecoveryAddendum
          shipment={recoveryShipment}
          destination={recoveryDestination}
          circumstance={recoveryCircumstance}
          category="gronn"
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
