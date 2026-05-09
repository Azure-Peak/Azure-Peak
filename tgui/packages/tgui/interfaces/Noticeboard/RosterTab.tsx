import {
  INK_FAINT,
  inkButtonStyle,
  rulerStyle,
  SEAL_AMBER,
  subtitleStyle,
  titleStyle,
} from '../common/parchment';
import { type TabProps } from './types';

export const RosterTab = ({ act }: TabProps) => {
  return (
    <>
      <div
        style={{
          ...titleStyle,
          fontSize: '20px',
          marginTop: 6,
          letterSpacing: '6px',
        }}
      >
        {/* TODO: flavor */}
        Mercenary Roster
      </div>
      <div style={subtitleStyle}>
        {/* TODO: flavor */}
        The names and detailings of those registered to the Mercenary Guild
      </div>
      <hr style={rulerStyle} />

      <div
        style={{
          color: SEAL_AMBER,
          fontStyle: 'italic',
          textAlign: 'center',
          padding: '14px 0',
          fontSize: '13px',
        }}
      >
        {/* TODO: flavor */}
        - the scribe is yet at work on this section -
      </div>

      <div
        style={{
          color: INK_FAINT,
          fontStyle: 'italic',
          textAlign: 'center',
          padding: '4px 0 12px 0',
          fontSize: '12px',
        }}
      >
        {/* TODO: flavor */}
        For now, consult the old board for the standing roster.
      </div>

      <div style={{ textAlign: 'center', marginTop: 8 }}>
        <button
          type="button"
          style={inkButtonStyle({})}
          onClick={() => act('open_legacy_board')}
        >
          {/* TODO: flavor */}
          Open the Old Board
        </button>
      </div>
    </>
  );
};
