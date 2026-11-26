import {
  fieldRowStyle,
  fieldValueStyle,
  inkButtonStyle,
  SEAL_AMBER,
  SERIF,
} from '../common/parchment';
import type { ActFn } from './types';

type Props = {
  budget: number;
  act: ActFn;
};

export const MammonRow = (props: Props) => {
  const { budget, act } = props;
  return (
    <div style={fieldRowStyle}>
      <div
        style={{
          flex: '0 0 auto',
          fontFamily: SERIF,
          color: SEAL_AMBER,
          marginRight: '12px',
        }}
      >
        Mammon Loaded
      </div>
      <div style={{ ...fieldValueStyle, fontWeight: 'bold' }}>{budget}m</div>
      <button
        type="button"
        style={inkButtonStyle({ disabled: budget <= 0 })}
        disabled={budget <= 0}
        onClick={() => act('change')}
      >
        Withdraw as Coin
      </button>
    </div>
  );
};
