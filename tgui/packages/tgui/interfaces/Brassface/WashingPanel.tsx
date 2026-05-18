import {
  cardStyle,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  SEAL_AMBER,
  sectionHeaderStyle,
  SERIF,
} from '../common/parchment';
import type { ActFn, WashingData } from './types';

const TIER_LABELS = ['10%', '25%', '50%'];

type Props = {
  washing: WashingData;
  budget: number;
  act: ActFn;
};

export const WashingPanel = (props: Props) => {
  const { washing, budget, act } = props;
  const tierLabel = TIER_LABELS[washing.cut_tier] ?? '10%';

  return (
    <div style={cardStyle}>
      <div style={sectionHeaderStyle}>Mammon Washing</div>
      <div
        style={{
          fontFamily: SERIF,
          fontSize: '12px',
          color: INK_SOFT,
          fontStyle: 'italic',
          marginBottom: '8px',
        }}
      >
        What flows through PURITY can be skimmed quietly. Master's eyes only.
      </div>
      <div
        style={{
          display: 'flex',
          flexWrap: 'wrap',
          gap: '12px 24px',
          fontFamily: SERIF,
          fontSize: '13px',
          marginBottom: '8px',
        }}
      >
        <span>
          <span style={{ color: INK_SOFT }}>Recent take:</span>{' '}
          <b style={{ color: INK }}>{washing.recent_payments}m</b>
        </span>
        <span>
          <span style={{ color: INK_SOFT }}>Current cut:</span>{' '}
          <b style={{ color: SEAL_AMBER }}>{tierLabel}</b>
        </span>
        <span>
          <span style={{ color: INK_SOFT }}>Your purse:</span>{' '}
          <b style={{ color: INK }}>{washing.secret_budget}m</b>
        </span>
      </div>
      <div style={{ display: 'flex', flexWrap: 'wrap', gap: '6px' }}>
        <button
          type="button"
          style={inkButtonStyle({ disabled: washing.secret_budget < 1 })}
          disabled={washing.secret_budget < 1}
          onClick={() => act('washing', { option: 'withdraw_bank' })}
        >
          Withdraw to Bank
        </button>
        <button
          type="button"
          style={inkButtonStyle({ disabled: washing.secret_budget < 1 })}
          disabled={washing.secret_budget < 1}
          onClick={() => act('washing', { option: 'withdraw_direct' })}
        >
          Withdraw as Coin
        </button>
        {washing.cut_tier < 1 && (
          <button
            type="button"
            style={inkButtonStyle({ disabled: budget < washing.tier_a_cost })}
            disabled={budget < washing.tier_a_cost}
            onClick={() => act('washing', { option: 'unlock_25' })}
          >
            Unlock 25% Cut ({washing.tier_a_cost}m)
          </button>
        )}
        {washing.cut_tier === 1 && (
          <button
            type="button"
            style={inkButtonStyle({ disabled: budget < washing.tier_b_cost })}
            disabled={budget < washing.tier_b_cost}
            onClick={() => act('washing', { option: 'unlock_50' })}
          >
            Unlock 50% Cut ({washing.tier_b_cost}m)
          </button>
        )}
        {washing.cut_tier >= 2 && (
          <span
            style={{
              fontFamily: SERIF,
              fontSize: '12px',
              color: INK_FAINT,
              fontStyle: 'italic',
              alignSelf: 'center',
              marginLeft: '4px',
            }}
          >
            All wash tiers unlocked.
          </span>
        )}
      </div>
    </div>
  );
};
