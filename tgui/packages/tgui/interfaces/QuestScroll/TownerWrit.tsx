import { SealLine } from './Seals';
import { writParagraph } from './shared';

export const TownerWrit = (props: {
  intro?: string;
  sealNote?: string;
  reward: number;
  levyRate: number;
  levyExempt: boolean;
  rulerTitle: string;
  issuedBy?: string;
  issuedOn?: string | null;
  bearer?: string;
}) => {
  const {
    intro,
    sealNote,
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
  const posterName = issuedBy || 'the poster';
  return (
    <>
      <p style={writParagraph}>
        <i>Be it known, under {posterName}&apos;s own hand and seal:</i>
      </p>
      {!!intro && <p style={writParagraph}>{intro}</p>}
      {!!sealNote && <p style={writParagraph}>{sealNote}</p>}
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
