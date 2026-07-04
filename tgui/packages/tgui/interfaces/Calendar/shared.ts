export type MonthMeta = {
  number: number;
  name: string;
  season: string;
  phase: string;
};

export type CalendarEvent = {
  id: string;
  calendar_system: string;
  month: number;
  day: number;
  duration_days: number;
  title: string;
  desc: string;
  color_tag: string;
};

export type CalendarData = {
  today_day: number;
  today_month: number;
  today_year: number;
  today_week: number;
  view_month: number;
  view_year: number;
  weekday_names: string[];
  days_in_month: number;
  days_in_week: number;
  months: MonthMeta[];
  events: CalendarEvent[];
  wrap_count: number;
};

export const MAX_BARS_PER_DAY = 3;

export const eventsForDay = (
  events: CalendarEvent[],
  day: number,
): CalendarEvent[] =>
  events.filter((e) => day >= e.day && day < e.day + e.duration_days);

export type BarSlotMap = Map<string, number>;

export const assignBarSlots = (events: CalendarEvent[]): BarSlotMap => {
  const slotByEventId: BarSlotMap = new Map();
  const sorted = [...events].sort((a, b) => {
    if (a.day !== b.day) return a.day - b.day;
    if (a.duration_days !== b.duration_days) {
      return b.duration_days - a.duration_days;
    }
    return a.id.localeCompare(b.id);
  });

  const occupancy = new Map<number, Set<number>>();
  for (const e of sorted) {
    let slot = 0;
    while (true) {
      let collides = false;
      for (let d = e.day; d < e.day + e.duration_days; d++) {
        const used = occupancy.get(d);
        if (used && used.has(slot)) {
          collides = true;
          break;
        }
      }
      if (!collides) break;
      slot++;
    }
    slotByEventId.set(e.id, slot);
    for (let d = e.day; d < e.day + e.duration_days; d++) {
      let used = occupancy.get(d);
      if (!used) {
        used = new Set<number>();
        occupancy.set(d, used);
      }
      used.add(slot);
    }
  }

  return slotByEventId;
};

export const buildWeekRows = (
  daysInMonth: number,
  daysInWeek: number,
): number[][] => {
  const weeks: number[][] = [];
  const total = Math.ceil(daysInMonth / daysInWeek);
  for (let w = 0; w < total; w++) {
    const row: number[] = [];
    for (let d = 1; d <= daysInWeek; d++) {
      row.push(w * daysInWeek + d);
    }
    weeks.push(row);
  }
  return weeks;
};
