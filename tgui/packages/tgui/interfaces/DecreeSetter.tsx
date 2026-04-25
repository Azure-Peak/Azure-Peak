import { useEffect, useRef, useState } from 'react';
import { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  badgeStyle,
  cardStyle,
  inkButtonStyle,
  INK,
  INK_FAINT,
  INK_SOFT,
  pageStyle,
  rulerStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  subtitleStyle,
  tabBarStyle,
  tabStyle,
  titleStyle,
} from './common/parchment';

type DecreeCategory = 'ancient' | 'new';

type Decree = {
  id: string;
  name: string;
  year: number;
  category: DecreeCategory;
  mechanical: string;
  flavor: string;
};

type DecreeState = {
  id: string;
  active: BooleanLike;
  cooldown_left: number;
};

type Data = {
  decrees: Decree[];
  states: DecreeState[];
  revoke_used_today: BooleanLike;
  restore_used_today: BooleanLike;
};

const formatCooldown = (seconds: number): string => {
  if (seconds <= 0) return '';
  const m = Math.floor(seconds / 60);
  const s = seconds % 60;
  if (m > 0) return `${m}m ${s}s`;
  return `${s}s`;
};

const CATEGORY_LABELS: Record<DecreeCategory, string> = {
  ancient: 'Ancient Charters',
  new: 'New Charters',
};

const cardHeaderStyle: React.CSSProperties = {
  display: 'flex',
  alignItems: 'baseline',
  gap: '8px',
  marginBottom: '6px',
};

const cardTitleStyle: React.CSSProperties = {
  fontVariant: 'small-caps',
  letterSpacing: '2px',
  fontSize: '15px',
  fontWeight: 'bold',
  color: INK,
  flex: 1,
};

const cardYearStyle: React.CSSProperties = {
  color: INK_FAINT,
  fontStyle: 'italic',
  fontSize: '12px',
};

const mechanicalStyle: React.CSSProperties = {
  fontSize: '12px',
  color: INK,
  margin: '4px 0 6px',
};

const flavorToggleStyle: React.CSSProperties = {
  fontSize: '11px',
  color: INK_SOFT,
  fontStyle: 'italic',
  cursor: 'pointer',
  userSelect: 'none',
  display: 'inline-block',
  marginTop: '2px',
};

const flavorBodyStyle: React.CSSProperties = {
  fontSize: '12px',
  color: INK,
  marginTop: '6px',
  whiteSpace: 'pre-wrap',
  borderTop: `1px dashed ${INK_FAINT}`,
  paddingTop: '6px',
  fontFamily: '"Palatino Linotype", Palatino, "Book Antiqua", Georgia, serif',
  lineHeight: 1.55,
};

const proclamationNoteStyle: React.CSSProperties = {
  textAlign: 'center',
  fontStyle: 'italic',
  fontSize: '11px',
  color: SEAL_AMBER,
  margin: '4px 0 8px',
};

type DecreeCardProps = {
  decree: Decree;
  state: DecreeState | undefined;
  revokeUsed: boolean;
  restoreUsed: boolean;
  onToggle: () => void;
};

const CONFIRM_TIMEOUT_MS = 3000;

const DecreeCard = (props: DecreeCardProps) => {
  const { decree, state, revokeUsed, restoreUsed, onToggle } = props;
  const [expanded, setExpanded] = useState(false);
  const [armed, setArmed] = useState(false);
  const armedTimerRef = useRef<number | null>(null);
  const active = !!state?.active;
  const cooldownLeft = state?.cooldown_left ?? 0;
  const onCooldown = cooldownLeft > 0;
  const slotUsed = active ? revokeUsed : restoreUsed;
  const disabled = onCooldown || slotUsed;
  const tooltip = onCooldown
    ? `On cooldown: ${formatCooldown(cooldownLeft)}`
    : slotUsed
      ? active
        ? 'A revocation has already been proclaimed today.'
        : 'A restoration has already been proclaimed today.'
      : armed
        ? 'Click again to confirm. Auto-cancels in 3 seconds.'
        : active
          ? 'Suspend this decree'
          : 'Restore this decree';

  const statusColor = active ? SEAL_GREEN : SEAL_RED;
  const statusLabel = active ? 'In force' : 'Suspended';
  const baseLabel = active ? 'Suspend' : 'Restore';
  const buttonLabel = armed ? `Confirm ${baseLabel}?` : baseLabel;
  const buttonColor = active ? SEAL_RED : SEAL_GREEN;

  useEffect(() => {
    return () => {
      if (armedTimerRef.current !== null) {
        window.clearTimeout(armedTimerRef.current);
      }
    };
  }, []);

  // Re-arm cancellation when state changes (e.g. toggle succeeded, button now means the opposite).
  useEffect(() => {
    setArmed(false);
    if (armedTimerRef.current !== null) {
      window.clearTimeout(armedTimerRef.current);
      armedTimerRef.current = null;
    }
  }, [active]);

  const handleClick = () => {
    if (disabled) return;
    if (!armed) {
      setArmed(true);
      armedTimerRef.current = window.setTimeout(() => {
        setArmed(false);
        armedTimerRef.current = null;
      }, CONFIRM_TIMEOUT_MS);
      return;
    }
    if (armedTimerRef.current !== null) {
      window.clearTimeout(armedTimerRef.current);
      armedTimerRef.current = null;
    }
    setArmed(false);
    onToggle();
  };

  return (
    <div style={cardStyle}>
      <div style={cardHeaderStyle}>
        <span style={cardTitleStyle}>{decree.name}</span>
        <span style={cardYearStyle}>of {decree.year}</span>
        <span style={badgeStyle(statusColor)}>{statusLabel}</span>
        <button
          type="button"
          style={inkButtonStyle({ color: buttonColor, disabled })}
          disabled={disabled}
          title={tooltip}
          onClick={handleClick}
        >
          {buttonLabel}
        </button>
      </div>
      {decree.mechanical && (
        <div style={mechanicalStyle}>{decree.mechanical}</div>
      )}
      {onCooldown && (
        <div style={{ fontSize: '11px', color: SEAL_AMBER, fontStyle: 'italic' }}>
          Cooldown: {formatCooldown(cooldownLeft)}
        </div>
      )}
      {decree.flavor && (
        <>
          <span
            style={flavorToggleStyle}
            onClick={() => setExpanded((v) => !v)}
          >
            {expanded ? '▼ Hide charter text' : '▶ Read charter text'}
          </span>
          {expanded && <div style={flavorBodyStyle}>{decree.flavor}</div>}
        </>
      )}
    </div>
  );
};

export const DecreeSetter = () => {
  const { act, data } = useBackend<Data>();
  const [tab, setTab] = useState<DecreeCategory>('ancient');

  const stateById = Object.fromEntries(
    (data.states ?? []).map((s) => [s.id, s]),
  );
  const revokeUsed = !!data.revoke_used_today;
  const restoreUsed = !!data.restore_used_today;

  const decrees = data.decrees ?? [];
  const ancient = decrees.filter((d) => d.category === 'ancient');
  const newer = decrees.filter((d) => d.category === 'new');
  const visible = tab === 'ancient' ? ancient : newer;

  return (
    <Window
      width={620}
      height={720}
      title="Charters of the Realm"
      theme="parchment"
    >
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>Charters of the Realm</div>
          <div style={subtitleStyle}>
            Speak by ancient writ, or proclaim a new charter.
          </div>
          <hr style={rulerStyle} />

          {(revokeUsed || restoreUsed) && (
            <div style={proclamationNoteStyle}>
              {revokeUsed && 'A revocation has been proclaimed today. '}
              {restoreUsed && 'A restoration has been proclaimed today. '}
              Further proclamations of that kind must await the dawn.
            </div>
          )}

          <div style={tabBarStyle}>
            <div style={tabStyle(tab === 'ancient')} onClick={() => setTab('ancient')}>
              {CATEGORY_LABELS.ancient} ({ancient.length})
            </div>
            <div style={tabStyle(tab === 'new')} onClick={() => setTab('new')}>
              {CATEGORY_LABELS.new} ({newer.length})
            </div>
          </div>

          {visible.length === 0 ? (
            <div
              style={{
                textAlign: 'center',
                fontStyle: 'italic',
                color: INK_FAINT,
                padding: '20px',
              }}
            >
              No charters in this category.
            </div>
          ) : (
            visible.map((d) => (
              <DecreeCard
                key={d.id}
                decree={d}
                state={stateById[d.id]}
                revokeUsed={revokeUsed}
                restoreUsed={restoreUsed}
                onToggle={() => act('toggle', { id: d.id })}
              />
            ))
          )}
        </div>
      </Window.Content>
    </Window>
  );
};
