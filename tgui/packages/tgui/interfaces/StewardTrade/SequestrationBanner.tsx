import { bannerStyle, FONT_BODY, SEAL_RED } from '../common/parchment';
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
        position: 'relative',
        fontSize: FONT_BODY,
        padding: '12px 16px',
      }}
    >
      <div
        style={{
          position: 'absolute',
          top: '4px',
          right: '8px',
          fontSize: FONT_BODY,
          fontStyle: 'italic',
          fontVariant: 'normal',
          color: SEAL_RED,
          opacity: 0.7,
        }}
      >
        sealed under the ATC&apos;s mark
      </div>
      <div
        style={{
          fontSize: '18px',
          fontWeight: 'bold',
          marginBottom: '4px',
        }}
      >
        SEQUESTRATION DECLARED
      </div>
      <div style={{ fontVariant: 'normal' }}>
        The Crown defaulted, so the ATC now collects the realm&apos;s revenues
        until the {sequestration.debt}m debt is repaid. You can&apos;t change
        trade settings or stockpile prices until then. Petitions, taxes and
        fines still work.
      </div>
    </div>
  );
};
