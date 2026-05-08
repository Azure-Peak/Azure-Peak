import { bannerStyle, INK, SEAL_AMBER } from '../common/parchment';
import type { SequestrationState } from './types';

export const ArrearsBanner = (props: {
  sequestration: SequestrationState;
}) => {
  const { sequestration } = props;
  if (!sequestration?.in_arrears) {
    return null;
  }
  return (
    <div
      style={{
        ...bannerStyle(SEAL_AMBER),
        position: 'relative',
        fontSize: '13px',
        padding: '10px 14px',
      }}
    >
      <div
        style={{
          fontSize: '15px',
          fontWeight: 'bold',
          letterSpacing: '3px',
          marginBottom: '3px',
          color: SEAL_AMBER,
        }}
      >
        ARREARS WITH THE BURGHERS
      </div>
      <div style={{ fontStyle: 'italic', fontVariant: 'normal', color: INK }}>
        The Crown owes <b>{sequestration.debt}m</b> to the Burghers of Azuria
        for the day's interest-free advance. All inflow into the Crown's Purse
        is skimmed against the debt until it is settled. Should the Crown miss
        the next dawn's payroll, the realm enters sequestration.
      </div>
    </div>
  );
};
