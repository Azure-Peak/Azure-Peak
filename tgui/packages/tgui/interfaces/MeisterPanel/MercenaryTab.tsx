import {
  cardStyle,
  fieldLabelStyle,
  fieldRowStyle,
  fieldValueStyle,
  INK_SOFT,
  inkButtonStyle,
  sectionHeaderStyle,
} from '../common/parchment';
import type { TabProps } from './types';

export const MercenaryTab = ({ data, act }: TabProps) => {
  const merc = data.merc;
  if (!merc) {
    return null;
  }
  const atCap = merc.held >= merc.max_held;

  return (
    <div style={cardStyle}>
      <div style={sectionHeaderStyle}>Mercenary Contracts</div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>Status</div>
        <div style={fieldValueStyle}>
          {merc.hired_by
            ? `Under contract with ${merc.hired_by}, day ${(merc.days_served || 0) + 1} of ${merc.days}`
            : 'Not under contract'}
        </div>
      </div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>Contracts held</div>
        <div style={fieldValueStyle}>
          {merc.held} / {merc.max_held}
        </div>
      </div>
      {!!merc.cooldown_text && (
        <div style={fieldRowStyle}>
          <div style={fieldLabelStyle}>Cooldown</div>
          <div style={fieldValueStyle}>{merc.cooldown_text}</div>
        </div>
      )}
      <div style={{ marginTop: 6, color: INK_SOFT }}>
        PLACEHOLDER: The Meister will issue you a new contract if you have lost
        yours. You may hold up to {merc.max_held} at once.
      </div>
      <div style={{ marginTop: 6, textAlign: 'right' }}>
        <button
          type="button"
          style={inkButtonStyle({ disabled: atCap })}
          disabled={atCap}
          onClick={() => act('request_merc_contract')}
        >
          Request a contract
        </button>
      </div>
    </div>
  );
};
