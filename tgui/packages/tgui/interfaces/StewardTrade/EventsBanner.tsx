import type { EconomicEvent, GoodCatalogEntry } from './types';
import {
  cardStyle,
  FONT_BODY,
  INK_FAINT,
  INK_SOFT,
  SEAL_GREEN,
  SEAL_RED,
  sectionHeaderStyle,
} from '../common/parchment';

export const EventsBanner = (props: {
  events: EconomicEvent[];
  goodCatalog: Record<string, GoodCatalogEntry>;
}) => {
  if (!props.events || props.events.length === 0) {
    return null;
  }
  return (
    <div style={{ marginBottom: '10px' }}>
      <div style={sectionHeaderStyle}>Active Economic Events</div>
      {props.events.map((e) => {
        const color = e.event_type === 'shortage' ? SEAL_RED : SEAL_GREEN;
        const isShortage = e.event_type === 'shortage';
        const target = e.saturation_target || 0;
        const progress = e.saturation_progress || 0;
        const pct =
          isShortage && target > 0
            ? Math.min(100, Math.round((progress / target) * 100))
            : 0;
        const affectedNames = (e.affected_goods || [])
          .map((gid) => props.goodCatalog[gid]?.name || gid)
          .join(', ');
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
            <div style={{ color: INK_SOFT, fontSize: FONT_BODY }}>
              {e.description}
            </div>
            {isShortage && target > 0 && (
              <div style={{ marginTop: '4px' }}>
                <div style={{ color: INK_FAINT, fontSize: FONT_BODY, marginBottom: '2px' }}>
                  Relief: {progress} / {target} units delivered ({pct}%). Accepts: {affectedNames} 
                </div>
                <div
                  style={{
                    height: '4px',
                    background: '#3a2a1a',
                    border: '1px solid #5a4a3a',
                    borderRadius: '1px',
                  }}
                >
                  <div
                    style={{
                      height: '100%',
                      width: `${pct}%`,
                      background: SEAL_GREEN,
                    }}
                  />
                </div>
              </div>
            )}
          </div>
        );
      })}
    </div>
  );
};
