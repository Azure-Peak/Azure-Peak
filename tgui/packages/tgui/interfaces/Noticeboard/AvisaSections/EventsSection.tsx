import {
  badgeStyle,
  cardStyle,
  FONT_BODY,
  FONT_TITLE,
  INK,
  INK_FAINT,
  INK_SOFT,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
} from '../../common/parchment';
import { type EconomicEvent, type NoticeboardData } from '../types';

const eventGridStyle: React.CSSProperties = {
  display: 'grid',
  gridTemplateColumns: '1fr 1fr',
  gap: 10,
  alignItems: 'start',
};

export const EventsSection = ({ data }: { data: NoticeboardData }) => {
  const events = data.economic_events ?? [];
  if (events.length === 0) {
    return (
      <EmptyMessage text="The realm's trade is calm. No events disturb the markets." />
    );
  }
  return (
    <div style={eventGridStyle}>
      {events.map((e, i) => (
        <EventCard key={i} event={e} />
      ))}
    </div>
  );
};

const EventCard = ({ event }: { event: EconomicEvent }) => {
  const isShortage = event.event_type === 'shortage';
  return (
    <div style={{ ...cardStyle, marginBottom: 0, minHeight: 120 }}>
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          flexWrap: 'wrap',
          gap: 8,
        }}
      >
        {isShortage ? (
          <span style={badgeStyle(SEAL_RED)}>SHORTAGE</span>
        ) : (
          <span style={badgeStyle(SEAL_GREEN)}>GLUT</span>
        )}
        <span
          style={{
            fontSize: FONT_TITLE,
            fontWeight: 'bold',
            color: INK,
            fontFamily: SERIF,
          }}
        >
          {event.name}
        </span>
        <span
          style={{
            color: INK_SOFT,
            fontSize: FONT_BODY,
            marginLeft: 'auto',
          }}
        >
          settles in {event.days_left}d
        </span>
      </div>
      {!!event.description && (
        <div
          style={{
            color: INK,
            fontSize: FONT_BODY,
            marginTop: 6,
            whiteSpace: 'pre-wrap',
          }}
        >
          {event.description}
        </div>
      )}
      {event.affected_goods.length > 0 && (
        <div style={{ marginTop: 6, fontSize: FONT_BODY, color: INK }}>
          <span
            style={{
              color: INK_SOFT,
              marginRight: 6,
            }}
          >
            Affected goods:
          </span>
          {event.affected_goods.join(', ')}
        </div>
      )}
    </div>
  );
};

const EmptyMessage = ({ text }: { text: string }) => (
  <div
    style={{
      color: INK_FAINT,
      textAlign: 'center',
      padding: '24px 0',
    }}
  >
    {text}
  </div>
);
