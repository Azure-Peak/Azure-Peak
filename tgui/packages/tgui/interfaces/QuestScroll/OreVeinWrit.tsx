import { SealLine } from './Seals';
import { writParagraph } from './shared';

export const OreVeinWrit = (props: {
  pickupRegion?: string | null;
  reward: number;
  levyRate: number;
  levyExempt: boolean;
  rulerTitle: string;
  issuedBy?: string;
  issuedOn?: string | null;
  bearer?: string;
}) => {
  const {
    pickupRegion,
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
  const minerName = issuedBy || 'the miner';
  const region = pickupRegion || 'the deep places';
  return (
    <>
      <p style={writParagraph}>
        <i>By the trade&apos;s own purse and seal:</i>
      </p>
      <p style={writParagraph}>
        {minerName} hath prospected a vein within {region} - elemental guarded. They call for hands to escort them to the strike and to thin
        the host of elementals while they work the rock.
      </p>
      <p style={writParagraph}>
        The vein erupts only when {minerName} arrives. Once it does, fellowship
        and miner alike may swing on the seams; the ore is theirs by
        agreement.
      </p>
      <p style={writParagraph}>
        For this work the bearer is paid <b>{reward} mammon</b>
        {showLevy ? (
          <>
            , <b>{net} mammon</b> after the Crown&apos;s Levy
          </>
        ) : null}
        .
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
