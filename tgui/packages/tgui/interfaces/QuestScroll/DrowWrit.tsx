import { RecoveryAddendum } from './HumanoidWrit';
import { SealLine } from './Seals';
import { capitalize, caputLupinum, indictmentItem, indictmentList, writParagraph } from './shared';

export const DrowWrit = (props: {
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
  const folk = namePlural || 'drow';
  const band = groupWord || 'patrol';

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
        <i>By writ of the {rulerTitle} and the Holy See:</i>
      </p>
      <p style={writParagraph}>
        That {subject} hath emerged from the deep dark into the lands of{' '}
        {realm}: Astrata-shunning things, dealers in bonded souls, that traffic in
        slaves and bargain with the Archenemy.
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
        Let no man parley, let no man trade, let no priest hear their plea. By
        writ of the {rulerTitle} and the counsel of the Holy See, {subject} be
        declared <span style={caputLupinum}>ANATHEMA SIT</span>: accursed
        before the Tens, sundered from sun and grain, owed neither truce nor
        ransom.
      </p>
      <p style={writParagraph}>
        Slay them where they walk and burn what they bear, lest the blight 
        upon their persons taint the earth. Upon their death the writ shall
        fall silent and mark itself; return it to the Contract Ledger, that
        the bounty of <b>{reward} mammon</b>
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
          category="drow"
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
