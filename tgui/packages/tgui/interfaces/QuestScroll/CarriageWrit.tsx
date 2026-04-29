import { SealLine } from './Seals';
import { writParagraph } from './shared';

export const CarriageWrit = (props: {
  realm: string;
  circumstance?: string;
  pickupRegion?: string | null;
  destination?: string | null;
  deliveryItem?: string | null;
  reward: number;
  levyRate: number;
  levyExempt: boolean;
  rulerTitle: string;
  issuedBy?: string;
  issuedOn?: string | null;
  bearer?: string;
}) => {
  const {
    realm,
    circumstance,
    pickupRegion,
    destination,
    deliveryItem,
    reward,
    levyRate,
    levyExempt,
    rulerTitle,
    issuedBy,
    issuedOn,
    bearer,
  } = props;
  const showLevy = !levyExempt && levyRate > 0;
  const net = showLevy ? Math.round(reward * (1 - levyRate)) : reward;
  const dest = destination || 'its appointed recipient';
  const pickup = pickupRegion || realm;
  const what = deliveryItem ? `a parcel of ${deliveryItem}` : 'a sealed parcel';
  return (
    <>
      <p style={writParagraph}>
        <i>Be it known by writ of the {rulerTitle}:</i>
      </p>
      <p style={writParagraph}>
        {what} awaits carriage from {pickup} to <b>{dest}</b>. The bearer of
        this writ holds safe passage upon the Duke&apos;s Road for the duration of
        the carriage.
      </p>
      {circumstance && <p style={writParagraph}>{circumstance}</p>}
      <p style={writParagraph}>
        Deliver the parcel and return this writ unto the Contract Ledger; the
        bounty of <b>{reward} mammon</b>
        {showLevy ? (
          <>
            , <b>{net} mammon</b> after the Crown&apos;s Levy
          </>
        ) : null}{' '}
        shall be paid.
      </p>
      <p style={writParagraph}>
        The writ knows the parcel and shall mark itself when the carriage is
        complete.
      </p>
      <SealLine
        rulerTitle={rulerTitle}
        issuedBy={issuedBy}
        issuedOn={issuedOn}
        bearer={bearer}
      />
    </>
  );
};
