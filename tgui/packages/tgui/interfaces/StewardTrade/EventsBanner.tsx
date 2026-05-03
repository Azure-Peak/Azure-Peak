import type { EconomicEvent } from './types';
import {
  cardStyle,
  INK_FAINT,
  INK_SOFT,
  SEAL_GREEN,
  SEAL_RED,
  sectionHeaderStyle,
} from '../common/parchment';

export const EventsBanner = (props: { events: EconomicEvent[] }) => {
  if (!props.events || props.events.length === 0) {
    return null;
  }
  return (
    <div style={{ marginBottom: '10px' }}>
      <div style={sectionHeaderStyle}>Active Economic Events</div>
      {props.events.map((e) => {
        const color = e.event_type === 'shortage' ? SEAL_RED : SEAL_GREEN;
        return (
          <div
            key={e.name}
            style={{
              ...cardStyle,
              borderLeft: `3px solid ${color}`,
              marginBottom: '6px',
              padding: '4px 10px',
            }}
          >
            <span style={{ fontWeight: 'bold', color: color }}>
              {e.name}
            </span>
            <span style={{ color: INK_FAINT, marginLeft: '8px' }}>
              ({e.days_left}d left)
            </span>
            <div style={{ fontStyle: 'italic', color: INK_SOFT, fontSize: '12px' }}>
              {e.description}
            </div>
          </div>
        );
      })}
    </div>
  );
};
