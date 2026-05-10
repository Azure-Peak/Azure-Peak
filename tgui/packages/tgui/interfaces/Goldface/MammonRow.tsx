import {
  fieldRowStyle,
  INK,
  inkButtonStyle,
  SEAL_AMBER,
  SERIF,
} from '../common/parchment';
import type { ActFn } from './types';
import { starsIfIlliterate } from './util';

type Props = {
  budget: number;
  canRead: boolean;
  isProprietor: boolean;
  isPublic: boolean;
  act: ActFn;
};

export const MammonRow = (props: Props) => {
  const { budget, canRead, isProprietor, isPublic, act } = props;
  return (
    <div style={fieldRowStyle}>
      <div
        style={{
          flex: '0 0 auto',
          fontFamily: SERIF,
          fontVariant: 'small-caps',
          letterSpacing: '2px',
          color: SEAL_AMBER,
          fontStyle: 'italic',
          marginRight: '12px',
        }}
      >
        Mammon Loaded
      </div>
      <div
        style={{
          flex: 1,
          fontFamily: SERIF,
          fontSize: '14px',
          color: INK,
          fontWeight: 'bold',
        }}
      >
        {budget}m
      </div>
      <div style={{ display: 'flex', gap: '6px' }}>
        <button
          type="button"
          style={inkButtonStyle({ disabled: budget <= 0 })}
          disabled={budget <= 0}
          onClick={() => act('change')}
        >
          Withdraw as Coin
        </button>
        {isProprietor && !isPublic && (
          <button
            type="button"
            style={inkButtonStyle()}
            onClick={() => act('secrets')}
          >
            {starsIfIlliterate('Secrets', canRead)}
          </button>
        )}
      </div>
    </div>
  );
};
