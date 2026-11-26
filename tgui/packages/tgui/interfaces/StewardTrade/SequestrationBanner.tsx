import { bannerStyle, FONT_BODY, INK, SEAL_RED } from '../common/parchment';
import type { SequestrationState } from './types';

export const SequestrationBanner = (props: {
  sequestration: SequestrationState;
}) => {
  const { sequestration } = props;
  if (!sequestration?.active) {
    return null;
  }
  return (
    <div
      style={{
        ...bannerStyle(SEAL_RED),
        display: 'flex',
        alignItems: 'baseline',
        gap: '10px',
        textAlign: 'left',
        fontSize: FONT_BODY,
        margin: '8px 0 0 0',
      }}
    >
      <span
        title="Sealed under the ATC's mark"
        style={{ flex: '0 0 auto', letterSpacing: '0.06em' }}
      >
        SEQUESTRATION DECLARED
      </span>
      <span style={{ fontWeight: 'normal', color: INK }}>
        The Crown defaulted, so the ATC now collects the realm&apos;s revenues
        until the {sequestration.debt}m debt is repaid. You can&apos;t trade
        with the market until then. Petitions, taxes and fines still work.
      </span>
    </div>
  );
};
