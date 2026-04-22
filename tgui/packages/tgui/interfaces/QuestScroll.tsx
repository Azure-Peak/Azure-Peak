import { useBackend } from '../backend';
import { Window } from '../layouts';
import type { BooleanLike } from 'tgui-core/react';

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
};

const parchment: React.CSSProperties = {
  background:
    'linear-gradient(180deg, hsl(40, 40%, 88%) 0%, hsl(38, 36%, 82%) 100%)',
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

const stampBase: React.CSSProperties = {
  display: 'inline-block',
  padding: '3px 10px',
  fontSize: '0.8em',
  fontWeight: 'bold',
  letterSpacing: '2px',
  color: 'hsl(42, 80%, 92%)',
  textShadow: '1px 1px 0 hsla(0, 0%, 0%, 0.35)',
  boxShadow: '0 1px 2px hsla(0, 0%, 0%, 0.4)',
  transform: 'rotate(-3deg)',
  marginRight: '6px',
};

const rumorStamp: React.CSSProperties = {
  ...stampBase,
  backgroundColor: 'hsl(280, 45%, 28%)',
  border: '1px solid hsl(280, 50%, 18%)',
};

const commissionStamp: React.CSSProperties = {
  ...stampBase,
  backgroundColor: 'hsl(38, 70%, 32%)',
  border: '1px solid hsl(38, 72%, 20%)',
};

const exemptStamp: React.CSSProperties = {
  ...stampBase,
  backgroundColor: 'hsl(130, 45%, 28%)',
  border: '1px solid hsl(130, 52%, 18%)',
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
      <Window title="Contract Scroll" width={480} height={520}>
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

  const has_banner = !!(data.is_rumor || data.is_defense || data.levy_exempt);

  return (
    <Window title="Contract Scroll" width={480} height={620}>
      <Window.Content scrollable>
        <div style={parchment}>
          <div style={headline}>HELP NEEDED</div>
          <div style={titleStyle}>{data.title}</div>

          {has_banner && (
            <div style={{ textAlign: 'center', marginBottom: '10px' }}>
              {data.is_rumor ? <span style={rumorStamp}>RUMORED</span> : null}
              {data.is_defense ? (
                <span style={commissionStamp}>COMMISSIONED</span>
              ) : null}
              {data.levy_exempt ? (
                <span style={exemptStamp}>LEVY EXEMPT</span>
              ) : null}
            </div>
          )}

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
                Return this scroll to the Notice Board to claim your reward.
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
        </div>
      </Window.Content>
    </Window>
  );
};
