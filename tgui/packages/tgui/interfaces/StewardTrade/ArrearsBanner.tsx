import { bannerStyle, FONT_BODY, INK, SEAL_AMBER } from '../common/parchment';
import type { SequestrationState } from './types';

export const ArrearsBanner = (props: { sequestration: SequestrationState }) => {
  const { sequestration } = props;
  if (!sequestration?.in_arrears) {
    return null;
  }
  return (
    <div
      style={{
        ...bannerStyle(SEAL_AMBER),
        display: 'flex',
        alignItems: 'baseline',
        gap: '10px',
        textAlign: 'left',
        fontSize: FONT_BODY,
        margin: '8px 0 0 0',
      }}
    >
      <span style={{ flex: '0 0 auto', letterSpacing: '0.06em' }}>
        ARREARS WITH THE BURGHERS
      </span>
      <span style={{ fontWeight: 'normal', color: INK }}>
        The Burghers covered the missed wages, and the Crown owes them{' '}
        <b>{sequestration.debt}m</b>. Everything paid into the Treasury goes to
        them until the debt is cleared. Miss the next payroll as well and the
        realm is sequestered.
      </span>
    </div>
  );
};
