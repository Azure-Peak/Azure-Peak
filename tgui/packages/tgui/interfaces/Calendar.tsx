import { useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { DayDetail } from './Calendar/DayDetail';
import { MonthGrid } from './Calendar/MonthGrid';
import { Nav } from './Calendar/Nav';
import { type CalendarData, eventsForDay } from './Calendar/shared';
import { WeekdayHeader } from './Calendar/WeekdayHeader';
import {
  FONT_BODY,
  INK_FAINT,
  pageStyle,
  rulerStyle,
  subtitleStyle,
  titleStyle,
} from './common/parchment';

const WRAP_NOTES = [
  'Huh. Could have sworn this was the same yil.',
  'The pages turn, and the yil does not.',
  'Surely the wheel must move, and yet the yil remains still.',
  'In the yil 1514 AP. There is a Grand Duchy built on-',
  'In the yil 1514 AP. In the yil 1514 AP. In the yil 1514 AP.',
  'Psydon? Where art thee, Psydon? The yil remains the same, but the world is not as it was.',
  "Haven't we been here before? So many familiar sights, familiar faces, heart broken and mended, men killed and resurrected. The yil is the same?",
  'What',
  'Time has folded back upon itself once more.',
];

const wrapNoteStyle = {
  textAlign: 'center' as const,
  fontStyle: 'italic' as const,
  color: INK_FAINT,
  fontSize: FONT_BODY,
  marginTop: '-4px',
  marginBottom: '8px',
};

export const Calendar = () => {
  const { act, data } = useBackend<CalendarData>();
  const {
    today_day,
    today_month,
    today_year,
    today_week,
    view_month,
    view_year,
    weekday_names,
    days_in_month,
    days_in_week,
    months,
    events,
    wrap_count,
  } = data;

  const [selectedDay, setSelectedDay] = useState<number | null>(null);

  const viewingToday = view_month === today_month && view_year === today_year;
  const currentMeta = months.find((m) => m.number === view_month);
  const monthName = currentMeta?.name ?? `Month ${view_month}`;
  const seasonLine = currentMeta
    ? `${currentMeta.phase} ${currentMeta.season}`
    : '';

  const detailDay = selectedDay ?? (viewingToday ? today_day : null);
  const detailEvents =
    detailDay !== null ? eventsForDay(events, detailDay) : [];

  const goPrev = () => {
    setSelectedDay(null);
    act('prev_month');
  };
  const goNext = () => {
    setSelectedDay(null);
    act('next_month');
  };
  const goToday = () => {
    setSelectedDay(null);
    act('today');
  };

  return (
    <Window width={620} height={680} title="Calendar" theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>The Azurian Calendar</div>
          <div style={subtitleStyle}>Year {view_year} AP</div>
          <hr style={rulerStyle} />

          <Nav
            monthName={monthName}
            seasonLine={seasonLine}
            showReturn={!viewingToday}
            onPrev={goPrev}
            onNext={goNext}
            onReturn={goToday}
          />

          {wrap_count > 0 && (
            <div style={wrapNoteStyle}>
              {WRAP_NOTES[Math.min(wrap_count - 1, WRAP_NOTES.length - 1)]}
            </div>
          )}

          <WeekdayHeader names={weekday_names} />

          <MonthGrid
            events={events}
            daysInMonth={days_in_month}
            daysInWeek={days_in_week}
            selectedDay={selectedDay}
            todayDay={today_day}
            todayWeek={today_week}
            viewingToday={viewingToday}
            onSelectDay={setSelectedDay}
          />

          <DayDetail
            monthName={monthName}
            year={view_year}
            selectedDay={detailDay}
            events={detailEvents}
          />
        </div>
      </Window.Content>
    </Window>
  );
};
