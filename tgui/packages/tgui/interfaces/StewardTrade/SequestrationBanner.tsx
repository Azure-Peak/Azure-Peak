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
        sealed under the Burghers&apos; mark
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
        Following the Crown&apos;s default, the Azurian Trading Company holds
        the sequestered revenues of the realm and farms the customs and salt
        tolls in perpetuity until the {sequestration.debt}m debt is repaid.
        Trade controls and stockpile pricing stand locked. Petitions, taxation,
        and the lash of fines remain.
      </div>
    </div>
  );
};
