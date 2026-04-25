import { SealLine } from './Seals';
import {
  capitalize,
  caputLupinum,
  CONDEMNATION_CAPUT_LUPINUM,
  CONDEMNATION_UTLAGATUS,
  CONDEMNATION_VOLKOMIR,
  indictmentItem,
  indictmentList,
  sacralPlea,
  writParagraph,
} from './shared';

export const WritOpening = (props: { realm: string }) => (
  <p style={writParagraph}>
    <i>Be it known unto all who bear arms in {props.realm}&apos;s defence:</i>
  </p>
);

export const SummonsClause = (props: {
  named?: string | null;
  ringleader?: string | null;
  groupWord?: string | null;
  namePlural?: string | null;
  realm: string;
}) => {
  const { named, ringleader, groupWord, namePlural, realm } = props;
  const courts = `the courts of ${realm}`;
  let body: React.ReactNode;
  if (named) {
    body = (
      <>
        That <b>{named}</b> hath been thrice summoned at {courts}, and to none
        of them did they answer.
      </>
    );
  } else if (ringleader && groupWord && namePlural) {
    body = (
      <>
        That a {groupWord} of {namePlural}, gathered under one called{' '}
        <b>{ringleader}</b>, hath been thrice summoned at {courts}, and to none
        of those summons did the ringleader nor any of their fellows answer.
      </>
    );
  } else if (groupWord && namePlural) {
    body = (
      <>
        That a {groupWord} of {namePlural} hath been thrice summoned at {courts}
        , and answered none.
      </>
    );
  } else {
    body = <>That the accused hath been thrice summoned, and answered none.</>;
  }
  return <p style={writParagraph}>{body}</p>;
};

export const IndictmentList = (props: { crimes: string[] }) => {
  if (!props.crimes || props.crimes.length === 0) return null;
  return (
    <>
      <p style={{ ...writParagraph, marginBottom: '4px' }}>
        Whereof they stand accused of:
      </p>
      <ul style={indictmentList}>
        {props.crimes.map((c, i) => (
          <li key={i} style={indictmentItem}>
            {capitalize(c)};
          </li>
        ))}
      </ul>
    </>
  );
};

export const SacralPlea = (props: { rulerTitle: string }) => (
  <p style={sacralPlea}>
    Wherefore the temples of the Tens have made plea unto the {props.rulerTitle},
    that this work be done with haste, lest further blasphemy compound the wrong.
  </p>
);

type CondemnationProps = {
  named?: string | null;
  ringleader?: string | null;
  groupWord?: string | null;
  rulerTitle: string;
};

const subjectNoun = (
  named?: string | null,
  ringleader?: string | null,
  groupWord?: string | null,
) => {
  if (named) return <b>{named}</b>;
  if (ringleader)
    { return (
      <>
        <b>{ringleader}</b> and all who follow their banner
      </>
    ); }
  return <>every soul of this {groupWord ?? 'gang'}</>;
};

const CondemnationCaputLupinum = (props: CondemnationProps) => {
  const { named, ringleader, groupWord, rulerTitle } = props;
  const subject = subjectNoun(named, ringleader, groupWord);
  const plural = !!ringleader || !named;
  return (
    <p style={writParagraph}>
      By writ of the {rulerTitle}, and by counsel of the estates, {subject}{' '}
      {plural ? 'are' : 'is'} declared{' '}
      <span style={caputLupinum}>CAPUT LUPINUM</span>, wolf
      {plural ? "'s heads" : "'s head"}, for that a wolf is a beast hated of
      all folk.
    </p>
  );
};

const CondemnationUtlagatus = (props: CondemnationProps) => {
  const { named, ringleader, groupWord, rulerTitle } = props;
  const subject = subjectNoun(named, ringleader, groupWord);
  const plural = !!ringleader || !named;
  return (
    <p style={writParagraph}>
      By writ of the {rulerTitle}, and by counsel of the estates, {subject}{' '}
      {plural ? 'are' : 'is'} put{' '}
      <span style={caputLupinum}>UTLAGATUS</span>, outside the law, that no
      hand owe them bread, fire, nor roof, and that any who shelter them share
      in their crime.
    </p>
  );
};

const CondemnationVolkomir = (props: CondemnationProps) => {
  const { named, ringleader, groupWord, rulerTitle } = props;
  const subject = subjectNoun(named, ringleader, groupWord);
  return (
    <p style={writParagraph}>
      By writ of the {rulerTitle}, and by counsel of the estates, let {subject}{' '}
      be named <span style={caputLupinum}>VOLKOMIR</span>, wolf cast out of the realm&apos;s peace. Driven
      from every hearth and hall, harboured by no kin, mourned by no friend.
    </p>
  );
};

export const CondemnationDeclaration = (
  props: CondemnationProps & { variant?: string },
) => {
  switch (props.variant) {
    case CONDEMNATION_UTLAGATUS:
      return <CondemnationUtlagatus {...props} />;
    case CONDEMNATION_VOLKOMIR:
      return <CondemnationVolkomir {...props} />;
    case CONDEMNATION_CAPUT_LUPINUM:
    default:
      return <CondemnationCaputLupinum {...props} />;
  }
};

export const CorruptionOfBloodClause = () => (
  <p style={{ ...writParagraph, fontStyle: 'italic' }}>
    And for that they have broken faith sworn before Ravox, their blood is held
    corrupt: no kin of their line shall inherit name, land, or honour from
    them, nor claim any title by their blood. The taint passes through the
    line, and there it ends.
  </p>
);

export const LicenceToSlay = (props: {
  reward: number;
  levyRate: number;
  levyExempt: boolean;
}) => {
  const showLevy = !props.levyExempt && props.levyRate > 0;
  const net = showLevy
    ? Math.round(props.reward * (1 - props.levyRate))
    : props.reward;
  return (
    <p style={writParagraph}>
      From this day forward it is lawful for any to slay them as wolves. Upon
      their death the writ shall fall silent and mark itself; return it then to
      the Contract Ledger, that the bounty of <b>{props.reward} mammon</b>
      {showLevy ? (
        <>
          , <b>{net} mammon</b> after the Crown&apos;s Levy
        </>
      ) : null}{' '}
      be paid.
    </p>
  );
};

export const RecoveryAddendum = (props: {
  shipment?: string | null;
  destination?: string | null;
  circumstance?: string;
  category?: string | null;
}) => {
  const { shipment, destination, circumstance, category } = props;
  const what = shipment ? <b>{shipment}</b> : <>the lost goods</>;
  const dest = destination || 'their rightful keeping';
  let lead: React.ReactNode;
  switch (category) {
    case 'beast':
      lead = (
        <>
          And further: scattered where the beast attacked lies {what}, fallen
          from lawful carriage.
        </>
      );
      break;
    case 'undead':
      lead = (
        <>
          And further: strewn where the dead now wander lies {what}, dropped
          in the breaking of lawful carriage.
        </>
      );
      break;
    default:
      lead = (
        <>
          And further: among the spoils of this band lies {what}, taken from
          lawful carriage.
        </>
      );
  }
  return (
    <p style={writParagraph}>
      {lead} Recover the sealed parcel and bear it unto <b>{dest}</b>.
      {circumstance ? <> {circumstance}</> : null}
    </p>
  );
};

export const HumanoidWrit = (props: {
  realm: string;
  rulerTitle: string;
  named?: string | null;
  ringleader?: string | null;
  groupWord?: string | null;
  namePlural?: string | null;
  crimes: string[];
  sacralInvoked: boolean;
  oathBreach: boolean;
  condemnation?: string;
  reward: number;
  levyRate: number;
  levyExempt: boolean;
  hasRecoveryAddendum: boolean;
  recoveryShipment?: string | null;
  recoveryDestination?: string | null;
  recoveryCircumstance?: string;
  issuedBy?: string;
  issuedOn?: string | null;
  bearer?: string;
}) => (
  <>
    <WritOpening realm={props.realm} />
    <SummonsClause
      named={props.named}
      ringleader={props.ringleader}
      groupWord={props.groupWord}
      namePlural={props.namePlural}
      realm={props.realm}
    />
    <IndictmentList crimes={props.crimes} />
    {props.sacralInvoked && <SacralPlea rulerTitle={props.rulerTitle} />}
    <CondemnationDeclaration
      variant={props.condemnation}
      named={props.named}
      ringleader={props.ringleader}
      groupWord={props.groupWord}
      rulerTitle={props.rulerTitle}
    />
    <LicenceToSlay
      reward={props.reward}
      levyRate={props.levyRate}
      levyExempt={props.levyExempt}
    />
    {props.oathBreach && <CorruptionOfBloodClause />}
    {props.hasRecoveryAddendum && (
      <RecoveryAddendum
        shipment={props.recoveryShipment}
        destination={props.recoveryDestination}
        circumstance={props.recoveryCircumstance}
        category="humanoid"
      />
    )}
    <SealLine
      rulerTitle={props.rulerTitle}
      issuedBy={props.issuedBy}
      issuedOn={props.issuedOn}
      bearer={props.bearer}
    />
  </>
);
