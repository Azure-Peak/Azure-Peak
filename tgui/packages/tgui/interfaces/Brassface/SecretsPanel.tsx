import {
  cardStyle,
  FONT_BODY,
  INK,
  INK_SOFT,
  inkButtonStyle,
  SEAL_AMBER,
  SEAL_RED,
  sectionHeaderStyle,
  SERIF,
} from '../common/parchment';
import type { ActFn } from './types';

type Props = {
  dodging: boolean;
  act: ActFn;
};

export const SecretsPanel = (props: Props) => {
  const { dodging, act } = props;
  return (
    <div style={cardStyle}>
      <div style={sectionHeaderStyle}>Secrets of the House</div>
      <div
        style={{
          fontFamily: SERIF,
          fontSize: FONT_BODY,
          color: INK_SOFT,
          marginBottom: '8px',
          fontStyle: 'italic',
        }}
      >
        Levers known only to those who keep the keys.
      </div>
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          gap: '12px',
        }}
      >
        <div style={{ fontFamily: SERIF, fontSize: FONT_BODY, color: INK }}>
          <b>Crown Duty:</b>{' '}
          {dodging ? (
            <span style={{ color: SEAL_RED }}>EVADED (NOTAX)</span>
          ) : (
            <span style={{ color: SEAL_AMBER }}>paid honestly</span>
          )}
        </div>
        <button
          type="button"
          style={inkButtonStyle({})}
          onClick={() => act('secrets', { option: 'toggle_tax' })}
        >
          {dodging ? 'Resume Paying Duty' : 'Stop Paying Duty'}
        </button>
      </div>
    </div>
  );
};
