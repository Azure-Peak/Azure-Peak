import { RecoveryAddendum } from './HumanoidWrit';
import { RewardClause } from './RewardClause';
import { SealLine } from './Seals';
import {
  capitalize,
  caputLupinum,
  indictmentItem,
  indictmentList,
  writParagraph,
} from './shared';

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
    named,
    ringleader,
    groupWord,
    namePlural,
    crimes,
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
  const folk = namePlural || 'drow';
  const band = groupWord || 'patrol';

  let subject: React.ReactNode;
  if (named) subject = <b>{named}</b>;
  else if (ringleader) {
    subject = (
      <>
        a {band} of {folk} under one called <b>{ringleader}</b>
      </>
    );
  } else
    subject = (
      <>
        a {band} of {folk}
      </>
    );

  return (
    <>
      <p style={writParagraph}>
        <i>By writ of the {rulerTitle} and the Holy See:</i>
      </p>
      <p style={writParagraph}>
        That {subject} hath emerged from the deep dark into the lands of {realm}
        : shunners of Astrata, who traffic in slaves and bargain with the
        Archenemy.
      </p>
      {crimes.length > 0 && (
        <>
          <p style={{ ...writParagraph, marginBottom: '4px' }}>
            Whereof they stand accused:
          </p>
          <ul style={indictmentList}>
            {crimes.map((c, i) => (
              <li key={i} style={indictmentItem}>
                {capitalize(c)}
              </li>
            ))}
          </ul>
        </>
      )}
      <p style={writParagraph}>
        By writ of the {rulerTitle}, and by counsel of the Holy See, let{' '}
        {subject} be declared <span style={caputLupinum}>ANATHEMA SIT</span>:
        accursed before the Tens, owed neither truce nor ransom. Let none parley
        or trade with them.
      </p>
      <p style={writParagraph}>
        Slay them and burn what they carry. Upon their death this writ shall
        mark itself. Return it then to the Contract Ledger, that the sum of{' '}
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
