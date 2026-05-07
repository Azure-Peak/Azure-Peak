import { RewardClause } from './RewardClause';
import { SealLine } from './Seals';
import { writParagraph } from './shared';

export const RecoveryWrit = (props: {
  realm: string;
  circumstance?: string;
  pickupRegion?: string | null;
  fetchItem?: string | null;
  fetchCount?: number;
  reward: number;
  levyRate: number;
  levyExempt: boolean;
  guildCutRate: number;
  rulerTitle: string;
  issuedBy?: string;
  issuedOn?: string | null;
  bearer?: string;
}) => {
  const {
    realm,
    circumstance,
    pickupRegion,
    fetchItem,
    fetchCount,
    reward,
    levyRate,
    levyExempt,
    guildCutRate,
    rulerTitle,
    issuedBy,
    issuedOn,
    bearer,
  } = props;
  const region = pickupRegion || realm;
  const itemLabel =
    fetchItem && fetchCount && fetchCount > 1
      ? `${fetchCount} ${fetchItem}s`
      : fetchItem
        ? `a ${fetchItem}`
        : 'goods of the realm';
  return (
    <>
      <p style={writParagraph}>
        <i>Be it known by writ of the {rulerTitle}:</i>
      </p>
      {circumstance && <p style={writParagraph}>{circumstance}</p>}
      <p style={writParagraph}>
        Whosoever shall recover {itemLabel} from {region} and bring them unto
        the Contract Ledger shall be paid the bounty of{' '}
        <RewardClause
          reward={reward}
          levyRate={levyRate}
          levyExempt={levyExempt}
          guildCutRate={guildCutRate}
        />
        .
      </p>
      <p style={writParagraph}>
        The writ knows the goods and shall mark itself when the deed is done.
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
