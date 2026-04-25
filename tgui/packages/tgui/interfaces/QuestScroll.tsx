import { useEffect, useState } from 'react';
import { useBackend } from '../backend';
import { Window } from '../layouts';
import type { BooleanLike } from 'tgui-core/react';
import { WaxSeal, type WaxSealColor } from './common/WaxSeal';

type QuestScrollData = {
  empty?: BooleanLike;
  title?: string;
  type?: string;
  difficulty?: string;
  issued_by?: string;
  issued_to?: string;
  issued_on?: string | null;
  objective?: string;
  location_fields?: [string, string][];
  compass_direction?: string;
  z_hint?: string;
  reward?: number;
  progress_current?: number;
  progress_required?: number;
  complete?: BooleanLike;
  levy_exempt?: BooleanLike;
  is_rumor?: BooleanLike;
  is_defense?: BooleanLike;
  blockade_timer_label?: string;
  blockade_timer_seconds?: number;
  blockade_current_wave?: number;
  blockade_total_waves?: number;
  blockade_armed?: BooleanLike;
  blockade_failed?: BooleanLike;
};

const formatMinSec = (totalSeconds: number) => {
  if (totalSeconds <= 0) return '0:00';
  const minutes = Math.floor(totalSeconds / 60);
  const seconds = totalSeconds % 60;
  return `${minutes}:${seconds.toString().padStart(2, '0')}`;
};

// Client-side tick so the countdown ticks every second between backend refreshes.
// Resets whenever the server pushes a new baseline.
const BlockadeTimer = (props: { label: string; seconds: number }) => {
  const [remaining, setRemaining] = useState(props.seconds);
  useEffect(() => {
    setRemaining(props.seconds);
  }, [props.seconds]);
  useEffect(() => {
    if (remaining <= 0) return;
    const t = setTimeout(() => setRemaining((s) => Math.max(0, s - 1)), 1000);
    return () => clearTimeout(t);
  }, [remaining]);
  const danger = remaining <= 30;
  return (
    <div style={rowStyle}>
      <span style={rowLabel}>{props.label}</span>
      <span
        style={{
          ...rowValue,
          fontSize: '1.2em',
          color: danger ? 'hsl(0, 65%, 35%)' : 'hsl(25, 55%, 22%)',
          fontFamily: "'Courier New', monospace",
        }}
      >
        {formatMinSec(remaining)}
      </span>
    </div>
  );
};

const parchment: React.CSSProperties = {
  color: 'hsl(28, 42%, 18%)',
  fontFamily: "Georgia, 'Palatino Linotype', Palatino, serif",
  padding: '24px 28px',
  minHeight: '100%',
  boxSizing: 'border-box',
};

const headline: React.CSSProperties = {
  fontSize: '0.85em',
  letterSpacing: '5px',
  textAlign: 'center',
  color: 'hsl(28, 52%, 30%)',
  marginBottom: '6px',
};

const titleStyle: React.CSSProperties = {
  fontSize: '1.55em',
  fontWeight: 'bold',
  textAlign: 'center',
  color: 'hsl(25, 55%, 22%)',
  marginBottom: '18px',
  lineHeight: '1.2em',
};

const divider: React.CSSProperties = {
  border: 'none',
  borderTop: '1px solid hsl(30, 30%, 50%)',
  margin: '12px 0',
};

const prominentBlock: React.CSSProperties = {
  background: 'hsla(46, 40%, 76%, 0.6)',
  border: '1px solid hsl(30, 30%, 55%)',
  borderRadius: '2px',
  padding: '10px 14px',
  margin: '12px 0',
};

type SealBanner = { mark: string; label: string; color: WaxSealColor };

const COMMISSION_SEAL: SealBanner = {
  mark: 'C',
  label: 'Commissioned',
  color: 'amber',
};
const EXEMPT_SEAL: SealBanner = {
  mark: 'E',
  label: 'Levy Exempt',
  color: 'green',
};

const sealBannerStyle: React.CSSProperties = {
  display: 'inline-flex',
  flexDirection: 'column',
  alignItems: 'center',
  gap: '2px',
  margin: '0 8px',
};

const sealCaptionStyle: React.CSSProperties = {
  fontVariant: 'small-caps',
  letterSpacing: '2px',
  fontSize: '0.72em',
  color: 'hsl(28, 50%, 25%)',
  fontWeight: 'bold',
};

const SealBannerView = (props: { seal: SealBanner }) => {
  const { seal } = props;
  return (
    <div style={sealBannerStyle}>
      <WaxSeal mark={seal.mark} label={seal.label} color={seal.color} size={48} />
      <div style={sealCaptionStyle}>{seal.label}</div>
    </div>
  );
};

const rowStyle: React.CSSProperties = {
  display: 'flex',
  justifyContent: 'space-between',
  alignItems: 'flex-start',
  gap: '12px',
  marginBottom: '4px',
  fontSize: '0.95em',
};

const rowLabel: React.CSSProperties = {
  flexShrink: 0,
  color: 'hsl(30, 38%, 35%)',
  fontStyle: 'italic',
};

const rowValue: React.CSSProperties = {
  flex: 1,
  minWidth: 0,
  color: 'hsl(28, 52%, 20%)',
  fontWeight: 'bold',
  textAlign: 'right',
  wordBreak: 'break-word',
};

const Field = (props: { label: string; value?: string | number | null }) => {
  if (props.value === null || props.value === undefined || props.value === '')
    return null;
  return (
    <div style={rowStyle}>
      <span style={rowLabel}>{props.label}</span>
      <span style={rowValue}>{props.value}</span>
    </div>
  );
};

export const QuestScroll = () => {
  const { data } = useBackend<QuestScrollData>();

  if (data.empty) {
    return (
      <Window title="Contract Scroll" width={480} height={520} theme="parchment">
        <Window.Content scrollable>
          <div style={parchment}>
            <div style={{ textAlign: 'center', fontStyle: 'italic' }}>
              This scroll bears no active contract.
            </div>
          </div>
        </Window.Content>
      </Window>
    );
  }

  const progress =
    data.progress_required && data.progress_required > 1
      ? `${data.progress_current ?? 0} / ${data.progress_required}`
      : null;

  const compassText = data.compass_direction
    ? `${data.compass_direction}${data.z_hint ? ` (${data.z_hint})` : ''}`
    : null;

  const has_banner = !!(data.is_defense || data.levy_exempt);

  return (
    <Window title="Contract Scroll" width={480} height={620} theme="parchment">
      <Window.Content scrollable>
        <div style={parchment}>
          <div style={headline}>HELP NEEDED</div>
          <div style={titleStyle}>{data.title}</div>

          <hr style={divider} />

          <Field label="Issued by" value={data.issued_by} />
          <Field label="Issued to" value={data.issued_to} />
          <Field label="Issued on" value={data.issued_on} />
          <Field label="Type" value={data.type} />
          <Field label="Difficulty" value={data.difficulty} />

          <div style={prominentBlock}>
            <Field label="Objective" value={data.objective} />
            {progress && <Field label="Progress" value={progress} />}
            {(data.location_fields || []).map(([label, value], i) => (
              <Field key={`loc-${i}`} label={label} value={value} />
            ))}
            {compassText && <Field label="Direction" value={compassText} />}
            {data.blockade_timer_label &&
              (data.blockade_timer_seconds ?? 0) > 0 && (
                <BlockadeTimer
                  label={data.blockade_timer_label}
                  seconds={data.blockade_timer_seconds ?? 0}
                />
              )}
            {!!data.blockade_armed && !data.blockade_timer_label && (
              <div
                style={{
                  fontStyle: 'italic',
                  fontSize: '0.9em',
                  color: 'hsl(30, 35%, 40%)',
                  marginTop: '6px',
                }}
              >
                Travel to the blockade - waves descend on arrival.
              </div>
            )}
          </div>

          <div style={prominentBlock}>
            <div style={rowStyle}>
              <span style={rowLabel}>Reward</span>
              <span
                style={{
                  ...rowValue,
                  fontSize: '1.15em',
                  color: 'hsl(36, 72%, 30%)',
                }}
              >
                {data.reward} mammon upon completion
              </span>
            </div>
          </div>

          {data.complete ? (
            <>
              <hr style={divider} />
              <div
                style={{
                  textAlign: 'center',
                  fontWeight: 'bold',
                  color: 'hsl(130, 45%, 28%)',
                  fontSize: '1.1em',
                }}
              >
                CONTRACT COMPLETE
              </div>
              <div style={{ textAlign: 'center', marginTop: '8px' }}>
                Return this scroll to the Contract Ledger to claim your reward.
              </div>
              <div
                style={{
                  textAlign: 'center',
                  fontStyle: 'italic',
                  fontSize: '0.9em',
                  marginTop: '4px',
                  color: 'hsl(30, 35%, 40%)',
                }}
              >
                Place it on the marked area next to the book.
              </div>
            </>
          ) : data.blockade_failed ? (
            <>
              <hr style={divider} />
              <div
                style={{
                  textAlign: 'center',
                  fontWeight: 'bold',
                  color: 'hsl(0, 55%, 32%)',
                  fontSize: '1.1em',
                }}
              >
                BLOCKADE HELD - THE WRIT HAS LAPSED
              </div>
            </>
          ) : (
            <>
              <hr style={divider} />
              <div
                style={{
                  textAlign: 'center',
                  fontStyle: 'italic',
                  color: 'hsl(30, 35%, 40%)',
                  fontSize: '0.9em',
                }}
              >
                The magic in this scroll will update as you progress.
              </div>
            </>
          )}

          {data.levy_exempt ? (
            <>
              <hr style={divider} />
              <div
                style={{
                  textAlign: 'center',
                  fontStyle: 'italic',
                  color: 'hsl(130, 45%, 28%)',
                  fontSize: '0.92em',
                  letterSpacing: '0.5px',
                }}
              >
                By Royal Seal and Ducal Prerogative, the bearer of this
                contract is held exempt from the Crown&apos;s Levy upon its reward.
              </div>
            </>
          ) : null}

          {has_banner && (
            <div
              style={{
                display: 'flex',
                justifyContent: 'center',
                alignItems: 'flex-start',
                gap: '4px',
                marginTop: '18px',
              }}
            >
              {data.is_defense && <SealBannerView seal={COMMISSION_SEAL} />}
              {data.levy_exempt && <SealBannerView seal={EXEMPT_SEAL} />}
            </div>
          )}
        </div>
      </Window.Content>
    </Window>
  );
};
