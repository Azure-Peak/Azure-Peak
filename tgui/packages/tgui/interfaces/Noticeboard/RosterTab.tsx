import {
  badgeStyle,
  cardStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  rulerStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
  subtitleStyle,
  titleStyle,
} from '../common/parchment';
import type { MercenaryEntry, TabProps } from './types';

export const RosterTab = ({ data }: TabProps) => {
  const roster = data.mercenary_roster;
  const total =
    (roster?.available_count ?? 0) +
    (roster?.contracted_count ?? 0) +
    (roster?.dnd_count ?? 0);

  return (
    <>
      <div
        style={{
          ...titleStyle,
          fontSize: '20px',
          marginTop: 6,
        }}
      >
        Mercenary Roster
      </div>
      <div style={subtitleStyle}>
        The names and detailings of those registered to the Mercenary Guild
      </div>
      <hr style={rulerStyle} />

      {!roster || total === 0 ? (
        <EmptyMessage text="No mercenaries have registered yet." />
      ) : (
        <>
          <SummaryLine roster={roster} total={total} />
          {roster.available.length > 0 && (
            <RosterGroup
              label="Available for Contract"
              color={SEAL_GREEN}
              entries={roster.available}
            />
          )}
          {roster.contracted.length > 0 && (
            <RosterGroup
              label="Currently Contracted"
              color={SEAL_AMBER}
              entries={roster.contracted}
            />
          )}
          {roster.dnd.length > 0 && (
            <RosterGroup
              label="Do Not Disturb"
              color={SEAL_RED}
              entries={roster.dnd}
            />
          )}
        </>
      )}

      <div
        style={{
          color: INK_FAINT,
          textAlign: 'center',
          padding: '12px 0 4px 0',
          fontSize: FONT_BODY,
        }}
      >
        Visit the Mercenary Statue for further contact.
      </div>
    </>
  );
};

const SummaryLine = ({
  roster,
  total,
}: {
  roster: TabProps['data']['mercenary_roster'];
  total: number;
}) => (
  <div
    style={{
      textAlign: 'center',
      fontSize: FONT_BODY,
      color: INK,
      padding: '4px 0 12px 0',
    }}
  >
    Total: <b>{total}</b>
    <span style={{ color: INK_FAINT }}> &middot; </span>
    <span style={{ color: SEAL_GREEN }}>
      Available: {roster.available_count}
    </span>
    <span style={{ color: INK_FAINT }}> &middot; </span>
    <span style={{ color: SEAL_AMBER }}>
      Contracted: {roster.contracted_count}
    </span>
    <span style={{ color: INK_FAINT }}> &middot; </span>
    <span style={{ color: SEAL_RED }}>DND: {roster.dnd_count}</span>
  </div>
);

const RosterGroup = ({
  label,
  color,
  entries,
}: {
  label: string;
  color: string;
  entries: MercenaryEntry[];
}) => (
  <div style={{ marginBottom: 12 }}>
    <div style={{ marginBottom: 6 }}>
      <span style={badgeStyle(color)}>{label}</span>
    </div>
    {entries.map((m, i) => (
      <div
        key={i}
        style={{
          ...cardStyle,
          paddingTop: 4,
          paddingBottom: 4,
          marginBottom: 4,
        }}
      >
        <div style={{ fontFamily: SERIF, fontSize: FONT_BODY, color: INK }}>
          <b>{m.name}</b>
          <span
            style={{
              color: INK_SOFT,
              fontSize: FONT_BODY,
              marginLeft: 6,
            }}
          >
            ({m.advjob})
          </span>
        </div>
        {!!m.message && (
          <div
            style={{
              color: INK_SOFT,
              fontStyle: 'italic',
              fontSize: FONT_BODY,
              marginTop: 2,
            }}
          >
            &ldquo;{m.message}&rdquo;
          </div>
        )}
      </div>
    ))}
  </div>
);

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
