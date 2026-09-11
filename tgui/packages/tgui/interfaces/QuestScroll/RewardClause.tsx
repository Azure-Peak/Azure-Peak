import { netReward } from './shared';

const deductionsLabel = (
  showLevy: boolean,
  showGuildCut: boolean,
): string | null => {
  if (showLevy && showGuildCut) return "the Crown's Levy and the Guild's cut";
  if (showLevy) return "the Crown's Levy";
  if (showGuildCut) return "the Guild's cut";
  return null;
};

export const RewardClause = (props: {
  reward: number;
  levyRate: number;
  levyExempt: boolean;
  guildCutRate: number;
}) => {
  const { reward, levyRate, levyExempt, guildCutRate } = props;
  const showLevy = !levyExempt && levyRate > 0;
  const showGuildCut = guildCutRate > 0;
  const net = netReward(reward, levyRate, levyExempt, guildCutRate);
  const deductions = deductionsLabel(showLevy, showGuildCut);
  return (
    <>
      <b>{reward} mammon</b>
      {deductions ? (
        <>
          , <b>{net} mammon</b> after {deductions}
        </>
      ) : null}
    </>
  );
};
