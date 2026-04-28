import { useEffect, useState } from 'react';
import type { CSSProperties } from 'react';
import { TextArea } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  rulerStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
  subtitleStyle,
  titleStyle,
} from './common/parchment';

type Warrant = {
  trade_cap: number;
  trade_remaining: number;
  defense_cap: number;
  defense_remaining: number;
};

type Candidate = {
  ref: string;
  name: string;
  job: string;
  pledge: string;
  is_me: BooleanLike;
  is_alderman: BooleanLike;
};

type HistoryEntry = {
  session: number;
  day: number;
  text: string;
};

type BracketTally = {
  tally: Record<string, number>;
  nae: number;
  total: number;
  winning_bracket: number | null;
  vetoed: BooleanLike;
};

type YaeNayTally = {
  yae: number;
  nay: number;
  total: number;
  count: number;
  would_pass: BooleanLike;
};

type ElectionTally = {
  tally: Record<string, number>;
  total: number;
  leader_key: string | null;
};

type Tallies = {
  election?: ElectionTally;
  trade_auth?: BracketTally;
  defense_auth?: BracketTally;
  poll_tax?: BracketTally;
  recall?: YaeNayTally;
  censure?: YaeNayTally;
};

type Data = {
  day: number;
  session_number: number;
  next_resolution: string;
  next_resolution_seconds: number;
  current_alderman: string | null;
  is_alderman: BooleanLike;
  is_censured: BooleanLike;
  is_outlaw: BooleanLike;
  my_weight_doubled: number;
  warrant: Warrant | null;
  my_votes: Record<string, string | undefined>;
  voter_count: number;
  quorate: BooleanLike;
  candidates: Candidate[];
  tallies: Tallies;
  history: HistoryEntry[];
  trade_brackets: number[];
  defense_brackets: number[];
  poll_brackets: number[];
  quorum_voters: number;
  recall_threshold_pct: number;
  censure_threshold_pct: number;
  nae_veto_pct: number;
};

const MOTION_TRADE = 'trade_auth';
const MOTION_DEFENSE = 'defense_auth';
const MOTION_POLL = 'poll_tax';
const MOTION_RECALL = 'recall';
const MOTION_CENSURE = 'censure';
const MOTION_ELECTION = 'election';

const NO_ALDERMAN = 'NO_ALDERMAN';
const CHOICE_NAE = 'NAE';
const CHOICE_YAE = 'YAE';
const CHOICE_NAY = 'NAY';

const formatWeight = (doubled: number) =>
  doubled <= 0 ? '0' : `${doubled / 2}`;

const formatCountdown = (seconds: number): string => {
  if (seconds <= 0) return '';
  if (seconds < 60) return `${seconds}s`;
  const m = Math.floor(seconds / 60);
  const s = seconds % 60;
  return `${m}m ${s.toString().padStart(2, '0')}s`;
};

// ─ Compact ballot styles ────────────────────────────────────────────

const ballotRowStyle: CSSProperties = {
  display: 'flex',
  alignItems: 'baseline',
  gap: '6px',
  padding: '6px 0',
  borderBottom: `1px dotted ${INK_FAINT}`,
  flexWrap: 'wrap',
};

const rowLabelStyle: CSSProperties = {
  minWidth: '110px',
  color: INK,
  fontVariant: 'small-caps',
  letterSpacing: '1px',
  fontWeight: 'bold',
};

const rowHintStyle: CSSProperties = {
  color: INK_FAINT,
  fontStyle: 'italic',
  fontSize: '11px',
  flexBasis: '100%',
  paddingLeft: '118px',
  marginTop: '2px',
};

const previewStyle: CSSProperties = {
  color: INK_SOFT,
  fontSize: '11px',
  fontVariant: 'small-caps',
  letterSpacing: '1px',
  flexBasis: '100%',
  paddingLeft: '118px',
  marginTop: '2px',
};

const headerBarStyle: CSSProperties = {
  display: 'flex',
  justifyContent: 'space-between',
  alignItems: 'baseline',
  color: INK_SOFT,
  fontVariant: 'small-caps',
  letterSpacing: '1px',
  fontSize: '12px',
  marginBottom: '4px',
};

const quorumBannerStyle = (quorate: boolean): CSSProperties => ({
  background: quorate ? 'rgba(60, 130, 60, 0.12)' : 'rgba(180, 60, 40, 0.12)',
  border: `1px solid ${quorate ? SEAL_GREEN : SEAL_RED}`,
  color: quorate ? SEAL_GREEN : SEAL_RED,
  padding: '4px 10px',
  marginBottom: '10px',
  fontVariant: 'small-caps',
  letterSpacing: '1px',
  fontWeight: 'bold',
  fontSize: '12px',
  textAlign: 'center',
});

const aldermanPanelStyle: CSSProperties = {
  background: 'rgba(200,170,100,0.18)',
  border: `1px solid ${SEAL_AMBER}`,
  padding: '8px 12px',
  marginBottom: '14px',
  fontFamily: SERIF,
};

const aldermanRowStyle: CSSProperties = {
  display: 'flex',
  justifyContent: 'space-between',
  padding: '2px 0',
  color: INK,
};

const standLinkStyle: CSSProperties = {
  cursor: 'pointer',
  color: INK_SOFT,
  fontStyle: 'italic',
  fontSize: '11px',
  textDecoration: 'underline',
  marginTop: '4px',
};

const candidateLineStyle: CSSProperties = {
  display: 'flex',
  alignItems: 'baseline',
  gap: '6px',
  padding: '2px 0',
  flexWrap: 'wrap',
};

const candidateNameStyle: CSSProperties = {
  color: INK,
  fontWeight: 'bold',
};

const candidateJobStyle: CSSProperties = {
  color: INK_SOFT,
  fontStyle: 'italic',
  fontSize: '11px',
};

const candidatePledgeStyle: CSSProperties = {
  color: INK_FAINT,
  fontStyle: 'italic',
  fontSize: '11px',
  flexBasis: '100%',
  paddingLeft: '28px',
};

const tallyChipStyle: CSSProperties = {
  color: INK_SOFT,
  fontSize: '10px',
  fontWeight: 'normal',
  marginLeft: '2px',
};

export const CityAssembly = () => {
  const { act, data } = useBackend<Data>();
  const [pledgeDraft, setPledgeDraft] = useState('');
  const [standOpen, setStandOpen] = useState(false);
  const [historyOpen, setHistoryOpen] = useState(false);

  const [tick, setTick] = useState(0);
  useEffect(() => {
    const t = setInterval(() => setTick((n) => n + 1), 1000);
    return () => clearInterval(t);
  }, []);
  const countdown = Math.max(
    0,
    (data.next_resolution_seconds || 0) - tick,
  );

  const canVote = !data.is_outlaw && data.my_weight_doubled > 0;
  const hasAlderman = !!data.current_alderman;

  return (
    <Window title="The City Assembly" width={780} height={740}>
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>The City Assembly</div>
          <div style={subtitleStyle}>
            Voice of the respectable citizenry of Azuria
          </div>
          <hr style={rulerStyle} />

          <div style={headerBarStyle}>
            <span>
              Session #{data.session_number}
              {countdown > 0
                ? ` • resolves in ${formatCountdown(countdown)}`
                : ` • resolves at ${data.next_resolution}`}
            </span>
            <span>
              {data.voter_count} voter{data.voter_count === 1 ? '' : 's'} &middot;
              your weight {formatWeight(data.my_weight_doubled)}
              {data.is_censured ? ' (censured)' : ''}
              {data.is_outlaw ? ' (outlaw)' : ''}
            </span>
          </div>

          <div style={quorumBannerStyle(!!data.quorate)}>
            {data.quorate
              ? `✓ QUORUM MET - motions will resolve as voted`
              : `✗ QUORUM NOT MET - ${data.quorum_voters} voices required, only ${data.voter_count} cast. Status quo holds if the session resolves now.`}
          </div>

          {data.is_alderman && data.warrant ? (
            <AldermanStrip
              warrant={data.warrant}
              onResign={() => act('resign_alderman')}
              onTrade={() => act('alderman_trade')}
            />
          ) : null}

          <ElectionRow
            data={data}
            canVote={canVote}
            standOpen={standOpen}
            setStandOpen={setStandOpen}
            pledgeDraft={pledgeDraft}
            setPledgeDraft={setPledgeDraft}
            onVote={(choice) =>
              act('cast_vote', { motion: MOTION_ELECTION, choice })
            }
            onClear={() => act('retract_vote', { motion: MOTION_ELECTION })}
            onDeclare={() => {
              act('declare_candidacy', { pledge: pledgeDraft });
              setPledgeDraft('');
              setStandOpen(false);
            }}
            onWithdraw={() => act('withdraw_candidacy')}
          />

          <BracketRow
            label="Trade"
            hint="Set the Alderman's daily Crown spending cap."
            motion={MOTION_TRADE}
            brackets={data.trade_brackets}
            suffix="m"
            myVote={data.my_votes?.[MOTION_TRADE]}
            tally={data.tallies?.trade_auth}
            disabled={!canVote}
          />

          <BracketRow
            label="Defense"
            hint="Set the Alderman's daily Pledge cap for defense writs."
            motion={MOTION_DEFENSE}
            brackets={data.defense_brackets}
            suffix="p"
            myVote={data.my_votes?.[MOTION_DEFENSE]}
            tally={data.tallies?.defense_auth}
            disabled={!canVote}
          />

          {/* Poll Tax disabled pending anti-dodge design. */}

          {hasAlderman ? (
            <>
              <YaeNayRow
                label="Recall"
                hint={`Remove ${data.current_alderman} from office. ${data.recall_threshold_pct}% YAE carries.`}
                motion={MOTION_RECALL}
                myVote={data.my_votes?.[MOTION_RECALL]}
                tally={data.tallies?.recall}
                disabled={!canVote}
              />
              <YaeNayRow
                label="Censure"
                hint={`Strike ${data.current_alderman}'s name - barred from office for the round. ${data.censure_threshold_pct}% YAE carries.`}
                motion={MOTION_CENSURE}
                myVote={data.my_votes?.[MOTION_CENSURE]}
                tally={data.tallies?.censure}
                disabled={!canVote}
              />
            </>
          ) : null}

          <div
            style={{ ...standLinkStyle, marginTop: '12px' }}
            onClick={() => setHistoryOpen(!historyOpen)}
          >
            {historyOpen ? 'Hide record' : 'Show record'} ({data.history.length})
          </div>
          {historyOpen && <HistoryBlock history={data.history} />}
        </div>
      </Window.Content>
    </Window>
  );
};

// ─ Alderman-only status strip ───────────────────────────────────────

const AldermanStrip = (props: {
  warrant: Warrant;
  onResign: () => void;
  onTrade: () => void;
}) => {
  const canTrade = props.warrant.trade_remaining > 0;
  return (
    <div style={aldermanPanelStyle}>
      <div
        style={{
          fontVariant: 'small-caps',
          letterSpacing: '2px',
          color: SEAL_AMBER,
          fontWeight: 'bold',
          marginBottom: '4px',
        }}
      >
        Alderman&apos;s Writ
      </div>
      <div style={aldermanRowStyle}>
        <span>Trade warrant</span>
        <span>
          <b>{props.warrant.trade_remaining}m</b> of {props.warrant.trade_cap}m remaining today
        </span>
      </div>
      <div style={aldermanRowStyle}>
        <span>Defense warrant</span>
        <span>
          <b>{props.warrant.defense_remaining}p</b> of {props.warrant.defense_cap}p remaining today
        </span>
      </div>
      <div style={{ marginTop: '6px', display: 'flex', gap: '6px', flexWrap: 'wrap' }}>
        <button
          type="button"
          style={inkButtonStyle({
            color: canTrade ? SEAL_AMBER : INK_FAINT,
            disabled: !canTrade,
          })}
          disabled={!canTrade}
          onClick={props.onTrade}
          title={
            canTrade
              ? "Open the Nerve Master's trade panel under the Alderman's writ. Draws from the trade warrant, not the Crown's Purse."
              : 'The Commons have set no trade warrant for you, or its coin is spent for the day.'
          }
        >
          Alderman — Trade
        </button>
        <button
          type="button"
          style={inkButtonStyle({ color: SEAL_RED })}
          onClick={props.onResign}
        >
          Resign the seat
        </button>
      </div>
    </div>
  );
};

// ─ Election ballot row ──────────────────────────────────────────────

type ElectionRowProps = {
  data: Data;
  canVote: boolean;
  standOpen: boolean;
  setStandOpen: (v: boolean) => void;
  pledgeDraft: string;
  setPledgeDraft: (v: string) => void;
  onVote: (choice: string) => void;
  onClear: () => void;
  onDeclare: () => void;
  onWithdraw: () => void;
};

const ElectionRow = (props: ElectionRowProps) => {
  const { data } = props;
  const mySelection = data.my_votes?.[MOTION_ELECTION];
  const canStand = !data.is_censured && !data.is_outlaw && props.canVote;
  const amCandidate = data.candidates.some((c) => c.is_me);
  const tally = data.tallies?.election;

  const leaderLabel = (() => {
    if (!tally || !tally.leader_key || tally.total === 0) return null;
    if (tally.leader_key === NO_ALDERMAN) return 'NO ALDERMAN leads';
    const match = data.candidates.find((c) => c.ref === tally.leader_key);
    if (match) return `${match.name} leads`;
    return null;
  })();

  return (
    <div style={ballotRowStyle}>
      <span style={rowLabelStyle}>Alderman</span>
      <div style={{ flex: 1, minWidth: 0 }}>
        {data.candidates.length === 0 && (
          <div style={{ color: INK_FAINT, fontStyle: 'italic' }}>
            No one has stood yet.
          </div>
        )}
        {data.candidates.map((c) => {
          const selected = mySelection === c.ref;
          const weight = formatWeight(tally?.tally?.[c.ref] ?? 0);
          return (
            <div key={c.ref} style={candidateLineStyle}>
              <button
                type="button"
                style={inkButtonStyle({
                  color: selected ? SEAL_AMBER : INK,
                  disabled: !props.canVote,
                })}
                disabled={!props.canVote}
                onClick={() => props.onVote(c.ref)}
              >
                {selected ? '[x]' : '[ ]'}
              </button>
              <span style={candidateNameStyle}>{c.name}</span>
              <span style={candidateJobStyle}>&ldquo;{c.job}&rdquo;</span>
              {c.is_alderman ? (
                <span style={{ color: SEAL_AMBER, fontSize: '11px' }}>
                  (sitting)
                </span>
              ) : null}
              {c.is_me ? (
                <span style={{ color: INK_SOFT, fontSize: '11px' }}>
                  (you)
                </span>
              ) : null}
              <span style={tallyChipStyle}>[{weight}]</span>
              <span style={candidatePledgeStyle}>
                {c.pledge || <i>(no pledge)</i>}
              </span>
            </div>
          );
        })}

        <div style={candidateLineStyle}>
          <button
            type="button"
            style={inkButtonStyle({
              color: mySelection === NO_ALDERMAN ? SEAL_AMBER : INK,
              disabled: !props.canVote,
            })}
            disabled={!props.canVote}
            onClick={() => props.onVote(NO_ALDERMAN)}
          >
            {mySelection === NO_ALDERMAN ? '[x]' : '[ ]'}
          </button>
          <span style={{ color: INK }}>NO ALDERMAN</span>
          <span style={tallyChipStyle}>
            [{formatWeight(tally?.tally?.[NO_ALDERMAN] ?? 0)}]
          </span>
          {mySelection ? (
            <button
              type="button"
              style={{ ...inkButtonStyle(), marginLeft: '4px' }}
              onClick={props.onClear}
            >
              clear
            </button>
          ) : null}
        </div>

        {leaderLabel ? (
          <div style={previewStyle}>
            &rarr; {leaderLabel} ({formatWeight(tally?.total ?? 0)} total weight)
          </div>
        ) : null}

        {canStand && !props.standOpen ? (
          <div
            style={standLinkStyle}
            onClick={() => props.setStandOpen(true)}
          >
            {amCandidate ? 'Update my pledge...' : 'Stand for the chair...'}
          </div>
        ) : null}
        {canStand && amCandidate && !props.standOpen ? (
          <div
            style={{ ...standLinkStyle, color: SEAL_RED }}
            onClick={props.onWithdraw}
          >
            Withdraw my candidacy
          </div>
        ) : null}
        {canStand && props.standOpen ? (
          <div style={{ marginTop: '6px' }}>
            <TextArea
              value={props.pledgeDraft}
              onChange={(v) => props.setPledgeDraft(v)}
              placeholder="Your pledge (max 300 characters)..."
              style={{
                background: 'rgba(255,248,220,0.6)',
                border: `1px solid ${INK_FAINT}`,
                padding: '4px 6px',
                fontFamily: SERIF,
                fontSize: '12px',
                color: INK,
                minHeight: '50px',
                width: '100%',
              }}
            />
            <div style={{ marginTop: '4px' }}>
              <button
                type="button"
                style={inkButtonStyle({ color: SEAL_GREEN })}
                onClick={props.onDeclare}
              >
                {amCandidate ? 'Update' : 'Declare'}
              </button>
              <button
                type="button"
                style={{ ...inkButtonStyle(), marginLeft: '4px' }}
                onClick={() => {
                  props.setStandOpen(false);
                  props.setPledgeDraft('');
                }}
              >
                Cancel
              </button>
            </div>
          </div>
        ) : null}
      </div>
    </div>
  );
};

// ─ Bracket ballot row ───────────────────────────────────────────────

type BracketRowProps = {
  label: string;
  hint: string;
  motion: string;
  brackets: number[];
  suffix: string;
  myVote?: string;
  tally?: BracketTally;
  disabled?: boolean;
};

const BracketRow = (props: BracketRowProps) => {
  const { act, data } = useBackend<Data>();
  const t = props.tally;
  const naeWeight = formatWeight(t?.nae ?? 0);
  const total = t?.total ?? 0;

  const preview = (() => {
    if (!t || total === 0) return 'No votes yet.';
    if (t.vetoed)
      return `Would be vetoed (NAE >= ${data.nae_veto_pct}% of ${formatWeight(total)} cast)`;
    if (t.winning_bracket !== null && t.winning_bracket !== undefined) {
      return `Would carry at ${t.winning_bracket}${props.suffix}/day (${formatWeight(total)} cast)`;
    }
    return `No bracket carries - ${formatWeight(total)} cast`;
  })();

  return (
    <div style={ballotRowStyle}>
      <span style={rowLabelStyle}>{props.label}</span>
      <button
        type="button"
        style={inkButtonStyle({
          color: props.myVote === CHOICE_NAE ? SEAL_RED : INK,
          disabled: props.disabled,
        })}
        disabled={props.disabled}
        onClick={() =>
          act('cast_vote', { motion: props.motion, choice: CHOICE_NAE })
        }
      >
        NAE <span style={tallyChipStyle}>[{naeWeight}]</span>
      </button>
      {props.brackets.map((b) => {
        const choiceStr = `${b}`;
        const selected = props.myVote === choiceStr;
        const w = formatWeight(t?.tally?.[choiceStr] ?? 0);
        return (
          <button
            type="button"
            key={choiceStr}
            style={inkButtonStyle({
              color: selected ? SEAL_AMBER : INK,
              disabled: props.disabled,
            })}
            disabled={props.disabled}
            onClick={() =>
              act('cast_vote', { motion: props.motion, choice: choiceStr })
            }
          >
            {b}
            {props.suffix} <span style={tallyChipStyle}>[{w}]</span>
          </button>
        );
      })}
      {props.myVote ? (
        <button
          type="button"
          style={inkButtonStyle({ disabled: props.disabled })}
          disabled={props.disabled}
          onClick={() => act('retract_vote', { motion: props.motion })}
        >
          clear
        </button>
      ) : null}
      <span style={previewStyle}>&rarr; {preview}</span>
      <span style={rowHintStyle}>{props.hint}</span>
    </div>
  );
};

// ─ YAE/NAY ballot row (recall, censure) ─────────────────────────────

type YaeNayProps = {
  label: string;
  hint: string;
  motion: string;
  myVote?: string;
  tally?: YaeNayTally;
  disabled?: boolean;
};

const YaeNayRow = (props: YaeNayProps) => {
  const { act } = useBackend<Data>();
  const t = props.tally;
  const yae = formatWeight(t?.yae ?? 0);
  const nay = formatWeight(t?.nay ?? 0);
  const preview = (() => {
    if (!t || t.count === 0) return 'No votes yet.';
    if (t.would_pass) return `Would pass (${yae} YAE vs ${nay} NAY)`;
    return `Would fail (${yae} YAE vs ${nay} NAY)`;
  })();

  return (
    <div style={ballotRowStyle}>
      <span style={rowLabelStyle}>{props.label}</span>
      <button
        type="button"
        style={inkButtonStyle({
          color: props.myVote === CHOICE_YAE ? SEAL_GREEN : INK,
          disabled: props.disabled,
        })}
        disabled={props.disabled}
        onClick={() =>
          act('cast_vote', { motion: props.motion, choice: CHOICE_YAE })
        }
      >
        YAE <span style={tallyChipStyle}>[{yae}]</span>
      </button>
      <button
        type="button"
        style={inkButtonStyle({
          color: props.myVote === CHOICE_NAY ? SEAL_RED : INK,
          disabled: props.disabled,
        })}
        disabled={props.disabled}
        onClick={() =>
          act('cast_vote', { motion: props.motion, choice: CHOICE_NAY })
        }
      >
        NAY <span style={tallyChipStyle}>[{nay}]</span>
      </button>
      {props.myVote ? (
        <button
          type="button"
          style={inkButtonStyle({ disabled: props.disabled })}
          disabled={props.disabled}
          onClick={() => act('retract_vote', { motion: props.motion })}
        >
          clear
        </button>
      ) : null}
      <span style={previewStyle}>&rarr; {preview}</span>
      <span style={rowHintStyle}>{props.hint}</span>
    </div>
  );
};

// ─ History (collapsed by default) ───────────────────────────────────

const HistoryBlock = (props: { history: HistoryEntry[] }) => {
  if (props.history.length === 0) {
    return (
      <div style={{ color: INK_FAINT, fontStyle: 'italic', marginTop: '6px' }}>
        No sessions have yet been written into the record.
      </div>
    );
  }
  return (
    <div style={{ marginTop: '6px' }}>
      {props.history.map((h) => (
        <div
          key={h.session}
          style={{
            borderLeft: `2px solid ${INK_FAINT}`,
            paddingLeft: '8px',
            marginBottom: '8px',
          }}
        >
          <div style={{ color: INK_SOFT, fontSize: '11px', fontVariant: 'small-caps', letterSpacing: '1px' }}>
            Session {h.session} &mdash; Day {h.day}
          </div>
          <div
            style={{ color: INK, lineHeight: 1.5, fontSize: '12px' }}
            dangerouslySetInnerHTML={{ __html: h.text }}
          />
        </div>
      ))}
    </div>
  );
};
