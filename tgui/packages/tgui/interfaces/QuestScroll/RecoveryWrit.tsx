import { RewardClause } from './RewardClause';
import { SealLine } from './Seals';
import { writParagraph } from './shared';

export const RecoveryWrit = (props: {
  realm: string;
  circumstance?: string;
  pickupRegion?: string | null;
  fetchItem?: string | null;
  fetchItemPlural?: string | null;
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
    fetchItemPlural,
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
      ? `${fetchCount} ${fetchItemPlural || fetchItem}`
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
        Whosoever shall recover {itemLabel} from {region} and bring the same
        unto the Contract Ledger shall be paid the sum of{' '}
        <RewardClause
          reward={reward}
          levyRate={levyRate}
          levyExempt={levyExempt}
          guildCutRate={guildCutRate}
        />
        .
      </p>
      <p style={writParagraph}>
        This writ shall mark itself when the goods are recovered.
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
