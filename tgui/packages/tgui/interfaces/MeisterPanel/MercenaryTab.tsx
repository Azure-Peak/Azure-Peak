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
  const hired = !!merc.hired_by;

  return (
    <div style={cardStyle}>
      <div style={sectionHeaderStyle}>Mercenary Contracts</div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>Status</div>
        <div style={fieldValueStyle}>
          {merc.hired_by
            ? `Under contract with ${merc.hired_by}, dae ${(merc.days_served || 0) + 1} of ${merc.days}`
            : 'Not under contract'}
        </div>
      </div>
      {!!merc.cooldown_text && (
        <div style={fieldRowStyle}>
          <div style={fieldLabelStyle}>Cooldown</div>
          <div style={fieldValueStyle}>{merc.cooldown_text}</div>
        </div>
      )}
      <div style={{ marginTop: 6, color: INK_SOFT }}>
        Print a new contract here once your last one has ended.
        Printing one voids any unsigned contract you still have, wherever it
        is.
      </div>
      <div style={{ marginTop: 6, textAlign: 'right' }}>
        <button
          type="button"
          style={inkButtonStyle({ disabled: hired })}
          disabled={hired}
          title={hired ? 'You are under contract.' : undefined}
          onClick={() => act('request_merc_contract')}
        >
          Print a contract
        </button>
      </div>
    </div>
  );
};
