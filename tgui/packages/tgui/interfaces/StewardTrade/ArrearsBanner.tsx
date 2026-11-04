import {
  bannerStyle,
  FONT_BODY,
  FONT_TITLE,
  INK,
  SEAL_AMBER,
} from '../common/parchment';
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
        position: 'relative',
        fontSize: FONT_BODY,
        padding: '10px 14px',
      }}
    >
      <div
        style={{
          fontSize: FONT_TITLE,
          fontWeight: 'bold',
          marginBottom: '3px',
          color: SEAL_AMBER,
        }}
      >
        ARREARS WITH THE BURGHERS
      </div>
      <div style={{ fontVariant: 'normal', color: INK }}>
        The Burghers covered the missed wages, and the Crown owes them{' '}
        <b>{sequestration.debt}m</b>. Everything paid into the Treasury goes to
        them until the debt is cleared. Miss the next payroll as well and the
        realm is sequestered.
      </div>
    </div>
  );
};
