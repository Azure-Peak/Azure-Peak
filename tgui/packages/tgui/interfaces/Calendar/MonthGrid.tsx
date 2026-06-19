import type { CSSProperties } from 'react';

import { INK_SOFT } from '../common/parchment';
import { AMBER_TINT_SOFT } from './parchment_calendar';
import { DayCell } from './DayCell';
import {
  assignBarSlots,
  buildWeekRows,
  type CalendarEvent,
  eventsForDay,
  MAX_BARS_PER_DAY,
} from './shared';

const weekRowStyle = (isCurrentWeek: boolean): CSSProperties => ({
  position: 'relative',
  display: 'grid',
  gridTemplateColumns: 'repeat(7, 1fr)',
  gap: '2px',
  marginBottom: '2px',
  padding: '2px',
  border: isCurrentWeek ? `1px solid ${INK_SOFT}` : '1px solid transparent',
  borderRadius: '2px',
  background: isCurrentWeek ? AMBER_TINT_SOFT : 'transparent',
});

type MonthGridProps = {
  events: CalendarEvent[];
  daysInMonth: number;
  daysInWeek: number;
  selectedDay: number | null;
  todayDay: number;
  todayWeek: number;
  viewingToday: boolean;
  onSelectDay: (day: number) => void;
};

export const MonthGrid = (props: MonthGridProps) => {
  const {
    events,
    daysInMonth,
    daysInWeek,
    selectedDay,
    todayDay,
    todayWeek,
    viewingToday,
    onSelectDay,
  } = props;

  const slotByEventId = assignBarSlots(events);
  const weeks = buildWeekRows(daysInMonth, daysInWeek);

  return (
    <>
      {weeks.map((row, weekIndex) => {
        const weekNumber = weekIndex + 1;
        const isCurrentWeek = viewingToday && weekNumber === todayWeek;
        return (
          <div key={weekIndex} style={weekRowStyle(isCurrentWeek)}>
            {row.map((day) => {
              const dayEvents = eventsForDay(events, day);
              const slotted = dayEvents
                .map((e) => ({ event: e, slot: slotByEventId.get(e.id) ?? 0 }))
                .sort((a, b) => a.slot - b.slot);
              const visible = slotted.slice(0, MAX_BARS_PER_DAY);
              const overflow = slotted.length - visible.length;
              return (
                <DayCell
                  key={day}
                  day={day}
                  isToday={viewingToday && day === todayDay}
                  isSelected={selectedDay === day}
                  events={dayEvents}
                  visible={visible}
                  overflow={overflow}
                  onClick={() => onSelectDay(day)}
                />
              );
            })}
          </div>
        );
      })}
    </>
  );
};
