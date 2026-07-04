import { useEffect, useState } from 'react';
import { Input } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  BUTTON_BG,
  cardStyle,
  fieldRowStyle,
  FONT_BODY,
  FONT_LEAD,
  FONT_SMALL,
  FONT_TITLE,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  PARCHMENT_SHADOW,
  rulerStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  sectionHeaderStyle,
  SERIF,
  subtitleStyle,
  titleStyle,
} from './common/parchment';

type FlightDirection = 'outbound' | 'return';

type ZadcoteSlot = {
  slot: number;
  name: string;
  label: string;
  severed: boolean;
  bonded: boolean;
  in_flight: boolean;
  cage_occupied?: boolean;
  cage_has_payload?: boolean;
  flight_zads?: number;
  flight_arrival_seconds?: number;
  flight_direction?: FlightDirection;
  flight_bombs?: number;
  allow_summons?: boolean;
};

type PayloadItem = {
  name: string;
  ref: string;
  w_class: number;
};

type MailEntry = {
  slot: number;
  sender: string;
  message: string;
  items: string[];
  stamp: string;
  kind: 'sent' | 'returned';
  lost?: number;
  zads_used?: number;
  bombs?: number;
  summoned?: boolean;
};

const WEIGHT_CLASS_TINY = 1;
const WEIGHT_CLASS_SMALL = 2;
const WEIGHT_CLASS_NORMAL = 3;
const WEIGHT_CLASS_BULKY = 4;

const maxWeightForTier = (tier: number): number => {
  if (tier === 1) return WEIGHT_CLASS_SMALL;
  if (tier === 2) return WEIGHT_CLASS_NORMAL;
  return WEIGHT_CLASS_BULKY;
};

const weightLabel = (wc: number): string => {
  if (wc <= WEIGHT_CLASS_TINY) return 'tiny';
  if (wc === WEIGHT_CLASS_SMALL) return 'small';
  if (wc === WEIGHT_CLASS_NORMAL) return 'normal';
  if (wc === WEIGHT_CLASS_BULKY) return 'bulky';
  return 'too heavy';
};

type ZadcoteData = {
  faction: 'merchant' | 'steward' | 'regent' | 'bathhouse';
  motto: string;
  reserve: number;
  reserve_start: number;
  flights: number;
  flight_cap: number;
  bomb_stock: number;
  bomb_stock_cap: number;
  bomb_cooldown_remaining: number;
  allows_voyeur: boolean;
  voyeur_fund: number;
  voyeur_cost: number;
  slots: ZadcoteSlot[];
  payload_in_hand: PayloadItem[];
  mail_log: MailEntry[];
};

const MESSAGE_MAX = 500;

const formatCountdown = (totalSeconds: number): string => {
  if (totalSeconds <= 0) return '00:00';
  const m = Math.floor(totalSeconds / 60);
  const s = totalSeconds % 60;
  return `${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`;
};

const captionStyle = {
  color: SEAL_AMBER,
  fontSize: FONT_BODY,
};

const HeaderStat = (props: {
  label: string;
  value: React.ReactNode;
}) => (
  <div style={{ flex: 1, minWidth: 0 }}>
    <div
      style={{
        fontFamily: SERIF,
        fontSize: FONT_SMALL,
        color: SEAL_AMBER,
        letterSpacing: '0.04em',
      }}
    >
      {props.label}
    </div>
    <div style={{ fontFamily: SERIF, fontSize: FONT_LEAD, color: INK }}>
      {props.value}
    </div>
  </div>
);

const ReserveHeader = (props: {
  data: ZadcoteData;
  onHelp: () => void;
  act: (action: string, payload?: Record<string, unknown>) => void;
}) => {
  const { data, onHelp, act } = props;
  const lowReserve = data.reserve <= Math.max(2, Math.floor(data.reserve_start * 0.2));
  const bombsReady = data.bomb_cooldown_remaining <= 0;
  return (
    <div style={{ position: 'relative' }}>
      <button
        type="button"
        title="Open the zadcote handbook"
        style={{ ...inkButtonStyle({}), position: 'absolute', top: 8, right: 8 }}
        onClick={onHelp}
      >
        ?
      </button>
      <div style={{ ...titleStyle, paddingRight: '40px' }}>{data.motto || 'Zadcote'}</div>
      <div style={subtitleStyle}>A flock of trained zads at your call.</div>
      <hr style={rulerStyle} />
      <div style={cardStyle}>
        <div style={fieldRowStyle}>
          <HeaderStat
            label="Reserve"
            value={
              <>
                <span style={{ color: lowReserve ? SEAL_RED : INK, fontWeight: 'bold' }}>
                  {data.reserve}
                </span>
                <span style={{ color: INK_SOFT }}> / {data.reserve_start}</span>
              </>
            }
          />
          <HeaderStat
            label="Flights"
            value={
              <>
                <span style={{ fontWeight: 'bold' }}>{data.flights}</span>
                <span style={{ color: INK_SOFT }}> / {data.flight_cap}</span>
              </>
            }
          />
          <HeaderStat
            label="Bombs"
            value={
              <>
                <span style={{ fontWeight: 'bold' }}>{data.bomb_stock}</span>
                <span style={{ color: INK_SOFT }}> / {data.bomb_stock_cap}</span>
              </>
            }
          />
          {!bombsReady && (
            <HeaderStat
              label="Bombs ready in"
              value={
                <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
                  {formatCountdown(data.bomb_cooldown_remaining)}
                </span>
              }
            />
          )}
          {data.allows_voyeur && (
            <HeaderStat
              label="Scrying fund"
              value={
                <div style={{ display: 'flex', alignItems: 'baseline', gap: '8px' }}>
                  <div>
                    <span style={{ color: data.voyeur_fund < data.voyeur_cost ? SEAL_RED : INK, fontWeight: 'bold' }}>
                      {data.voyeur_fund}m
                    </span>
                    <span style={{ color: INK_SOFT }}> ({data.voyeur_cost}m / scry)</span>
                  </div>
                  <button
                    type="button"
                    disabled={data.voyeur_fund <= 0}
                    style={inkButtonStyle({ disabled: data.voyeur_fund <= 0 })}
                    title={
                      data.voyeur_fund <= 0
                        ? 'The scrying basin is empty.'
                        : `Drain ${data.voyeur_fund}m from the scrying basin into coin.`
                    }
                    onClick={() => {
                      if (data.voyeur_fund <= 0) return;
                      act('withdraw_voyeur');
                    }}
                  >
                    Withdraw
                  </button>
                </div>
              }
            />
          )}
        </div>
      </div>
    </div>
  );
};

const StatusPill = (props: { slot: ZadcoteSlot }) => {
  const { slot } = props;
  if (slot.in_flight) {
    const direction = slot.flight_direction === 'return' ? 'returning' : 'outbound';
    const arriving = slot.flight_arrival_seconds ?? 0;
    return (
      <span
        style={{
          color: SEAL_AMBER,
          fontWeight: 'bold',
          fontSize: FONT_BODY,
        }}
        title={`A flight is ${direction}, arriving in ${formatCountdown(arriving)}`}
      >
        {direction} {slot.flight_zads ? `(${slot.flight_zads})` : ''}{' '}
        <span style={{ color: INK_SOFT, fontWeight: 'normal' }}>
          {formatCountdown(arriving)}
        </span>
      </span>
    );
  }
  if (slot.severed) {
    return (
      <span
        style={{
          color: SEAL_RED,
          fontWeight: 'bold',
          fontSize: FONT_BODY,
        }}
      >
        Severed
      </span>
    );
  }
  if (!slot.bonded) {
    return (
      <span
        style={{
          color: INK_FAINT,
          fontStyle: 'italic',
          fontSize: FONT_BODY,
        }}
      >
        Awaiting a cage
      </span>
    );
  }
  return (
    <span
      style={{
        color: SEAL_GREEN,
        fontWeight: 'bold',
        fontSize: FONT_BODY,
      }}
    >
      Linked
    </span>
  );
};

const SegmentedPicker = (props: {
  options: number[];
  value: number;
  onChange: (v: number) => void;
  disabled?: boolean;
}) => {
  const { options, value, onChange, disabled } = props;
  return (
    <div style={{ display: 'flex', gap: '4px' }}>
      {options.map((opt) => {
        const active = opt === value;
        return (
          <button
            key={opt}
            type="button"
            disabled={disabled}
            style={{
              ...inkButtonStyle({ disabled }),
              padding: '2px 12px',
              background: active ? 'var(--p-tab-active-bg)' : BUTTON_BG,
              borderColor: active ? INK : INK_FAINT,
              fontWeight: active ? 'bold' : 'normal',
              color: active ? INK : INK_SOFT,
            }}
            onClick={() => {
              if (disabled) return;
              onChange(opt);
            }}
          >
            {opt}
          </button>
        );
      })}
    </div>
  );
};

const SendPanel = (props: {
  data: ZadcoteData;
  slot: ZadcoteSlot;
  act: (action: string, payload?: Record<string, unknown>) => void;
  onClose: () => void;
}) => {
  const { data, slot, act, onClose } = props;
  const [message, setMessage] = useState('');
  const [zads, setZads] = useState(1);
  const [bombs, setBombs] = useState(0);
  const [bombCaw, setBombCaw] = useState('');
  const [selectedRefs, setSelectedRefs] = useState<Record<string, boolean>>({});

  const bombsAvailable = data.bomb_stock > 0 && data.bomb_cooldown_remaining <= 0;
  const bombOptions = bombsAvailable
    ? [0, 1, 2, 3].filter((n) => n <= data.bomb_stock)
    : [0];
  const effectiveZads = bombs > 0 ? Math.max(zads, bombs) : zads;
  const overLimit = message.length > MESSAGE_MAX;
  const refsList = Object.entries(selectedRefs)
    .filter(([, on]) => on)
    .map(([ref]) => ref);

  const refusedReason = (() => {
    if (slot.severed) return 'The zadlink is severed.';
    if (!slot.bonded) return 'No cage is bonded to this slot.';
    if (slot.in_flight) return 'A flight is already on this slot.';
    if (slot.cage_occupied) return 'That zadcage is already occupied.';
    if (slot.cage_has_payload) return 'Unclaimed parcels still sit in that cage.';
    if (data.flights >= data.flight_cap) return 'Too many flights in the air.';
    if (data.reserve < effectiveZads) return `Only ${data.reserve} zads remain in the cote.`;
    if (overLimit) return `Message exceeds ${MESSAGE_MAX} characters.`;
    return null;
  })();

  const sendable = !refusedReason;

  return (
    <div
      style={{
        marginTop: '8px',
        padding: '8px 10px',
        background: 'var(--p-card-bg)',
        border: `1px dashed ${INK_FAINT}`,
        borderRadius: '2px',
      }}
    >
      <div
        style={{
          display: 'flex',
          alignItems: 'baseline',
          justifyContent: 'space-between',
          marginBottom: '6px',
        }}
      >
        <span
          style={{
            fontFamily: SERIF,
            fontSize: FONT_TITLE,
            color: INK,
            fontWeight: 'bold',
          }}
        >
          Dispatch to {slot.label}
        </span>
        <button type="button" style={inkButtonStyle({})} onClick={onClose}>
          Close
        </button>
      </div>

      <div style={{ marginBottom: '8px' }}>
        <div style={{ display: 'flex', alignItems: 'baseline' }}>
          <div style={{ ...captionStyle, flex: 1 }}>Message</div>
          <div
            style={{
              color: overLimit ? SEAL_RED : INK_FAINT,
              fontSize: FONT_BODY,
            }}
          >
            {message.length} / {MESSAGE_MAX}
          </div>
        </div>
        <textarea
          value={message}
          onChange={(e) => setMessage(e.target.value)}
          rows={4}
          style={{
            width: '100%',
            fontFamily: SERIF,
            fontSize: FONT_BODY,
            background: BUTTON_BG,
            border: `1px solid ${INK_FAINT}`,
            color: INK,
            padding: '4px 6px',
            resize: 'vertical',
          }}
        />
      </div>

      <div style={{ marginBottom: '8px', opacity: bombs > 0 ? 0.4 : 1 }}>
        <div style={captionStyle}>Payload in hand</div>
        {bombs > 0 ? (
          <div
            style={{
              color: SEAL_AMBER,
              fontSize: FONT_SMALL,
              fontStyle: 'italic',
              padding: '4px 0',
            }}
          >
            Bombs are loaded - no other payload will fly with them.
          </div>
        ) : data.payload_in_hand.length === 0 ? (
          <div
            style={{
              color: INK_FAINT,
              fontSize: FONT_SMALL,
              fontStyle: 'italic',
              padding: '4px 0',
            }}
          >
            Hold a parcel in your active hand to send it with the zad.
          </div>
        ) : (
          data.payload_in_hand.map((item) => {
            const tierMax = maxWeightForTier(effectiveZads);
            const tooHeavy = item.w_class > tierMax;
            const on = !!selectedRefs[item.ref] && !tooHeavy;
            const disabled = bombs > 0 || tooHeavy;
            return (
              <label
                key={item.ref}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '8px',
                  padding: '2px 0',
                  fontSize: FONT_BODY,
                  color: tooHeavy ? INK_FAINT : INK,
                  cursor: disabled ? 'not-allowed' : 'pointer',
                  opacity: tooHeavy ? 0.6 : 1,
                }}
              >
                <input
                  type="checkbox"
                  checked={on}
                  disabled={disabled}
                  onChange={() =>
                    setSelectedRefs((prev) => ({ ...prev, [item.ref]: !prev[item.ref] }))
                  }
                />
                <span>{item.name}</span>
                <span
                  style={{
                    color: tooHeavy ? SEAL_RED : INK_FAINT,
                    fontSize: FONT_SMALL,
                    marginLeft: 'auto',
                  }}
                >
                  {tooHeavy
                    ? `${weightLabel(item.w_class)} - needs more zads`
                    : weightLabel(item.w_class)}
                </span>
              </label>
            );
          })
        )}
      </div>

      <div style={{ display: 'flex', gap: '24px', marginBottom: '8px' }}>
        <div>
          <div style={captionStyle}>Zads</div>
          <SegmentedPicker
            options={[1, 2, 3]}
            value={effectiveZads}
            onChange={(v) => {
              setZads(v);
              if (bombs > v) setBombs(v);
            }}
            disabled={bombs > 0}
          />
          <div style={{ color: INK_FAINT, fontSize: FONT_SMALL, marginTop: '4px' }}>
            {effectiveZads === 1
              ? '1 zad: tiny or small parcel.'
              : effectiveZads === 2
                ? '2 zads: pouch, helmet, or normal-sized item.'
                : '3 zads: bulky parcel, large container, or a great weapon.'}
          </div>
        </div>
        {bombsAvailable && (
          <div>
            <div style={captionStyle}>Bottlebombs</div>
            <SegmentedPicker
              options={bombOptions}
              value={bombs}
              onChange={(v) => {
                setBombs(v);
                if (v > zads) setZads(v);
              }}
            />
          </div>
        )}
      </div>
      {bombs > 0 && (
        <div style={{ marginBottom: '8px' }}>
          <div style={captionStyle}>Bomb caw (optional, 40 chars)</div>
          <Input
            fluid
            value={bombCaw}
            maxLength={40}
            placeholder="The zads will caw this before they drop. Leave blank for silence."
            onChange={setBombCaw}
          />
        </div>
      )}

      <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
        <button
          type="button"
          disabled={!sendable}
          style={inkButtonStyle({ disabled: !sendable })}
          title={refusedReason ?? 'Loose the zads'}
          onClick={() => {
            if (!sendable) return;
            act('dispatch', {
              slot: slot.slot,
              zads: effectiveZads,
              bombs,
              message,
              payload_refs: refsList,
              bomb_caw: bombs > 0 ? bombCaw : '',
            });
            onClose();
          }}
        >
          Send
        </button>
        {refusedReason && (
          <span style={{ color: SEAL_RED, fontSize: FONT_BODY }}>
            {refusedReason}
          </span>
        )}
      </div>
    </div>
  );
};

const SlotNameField = (props: {
  slot: ZadcoteSlot;
  act: (action: string, payload?: Record<string, unknown>) => void;
}) => {
  const { slot, act } = props;
  const [draft, setDraft] = useState(slot.name);

  useEffect(() => {
    setDraft(slot.name);
  }, [slot.name]);

  const dirty = draft.trim() !== slot.name.trim();
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: '6px', flex: 1, minWidth: 0 }}>
      <span
        style={{
          color: INK_SOFT,
          fontFamily: SERIF,
          fontSize: FONT_BODY,
          width: '32px',
          flex: '0 0 32px',
          textAlign: 'right',
          fontVariantNumeric: 'tabular-nums',
        }}
      >
        #{slot.slot}
      </span>
      <Input
        value={draft}
        onChange={setDraft}
        placeholder={`Slot ${slot.slot}`}
        maxLength={32}
        width="220px"
      />
      <button
        type="button"
        disabled={!dirty}
        style={inkButtonStyle({ disabled: !dirty })}
        onClick={() => {
          if (!dirty) return;
          act('set_slot_name', { slot: slot.slot, name: draft });
        }}
      >
        Set
      </button>
    </div>
  );
};

const SlotRow = (props: {
  data: ZadcoteData;
  slot: ZadcoteSlot;
  expanded: boolean;
  onToggle: () => void;
  act: (action: string, payload?: Record<string, unknown>) => void;
}) => {
  const { data, slot, expanded, onToggle, act } = props;
  const canSever = slot.bonded && !slot.severed;
  const fundsOk = data.voyeur_fund >= data.voyeur_cost;
  const canVoyeur = data.allows_voyeur && slot.bonded && !slot.severed && fundsOk;
  return (
    <div
      style={{
        padding: '6px 8px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontFamily: SERIF,
        fontSize: FONT_BODY,
      }}
    >
      <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
        <SlotNameField slot={slot} act={act} />
        <div style={{ flex: '0 0 auto', textAlign: 'right' }}>
          <StatusPill slot={slot} />
        </div>
        <div style={{ flexShrink: 0, display: 'flex', gap: '4px' }}>
          <button
            type="button"
            style={inkButtonStyle({ disabled: slot.severed })}
            disabled={slot.severed}
            title={
              slot.in_flight
                ? 'Send a dispatch on this slot. The zad in flight will land first.'
                : 'Send a dispatch on this slot.'
            }
            onClick={onToggle}
          >
            {expanded ? 'Hide' : 'Send'}
          </button>
          {data.allows_voyeur && (
            <button
              type="button"
              style={inkButtonStyle({ disabled: !canVoyeur })}
              disabled={!canVoyeur}
              title={
                !fundsOk
                  ? `Scrying fund empty. Feed mammon coins into the zadcote (needs ${data.voyeur_cost}m).`
                  : canVoyeur
                    ? `Scry through the bonded zad. Costs ${data.voyeur_cost}m from the zadcote's scrying fund.`
                    : 'Voyeur unavailable.'
              }
              onClick={() => {
                if (!canVoyeur) return;
                act('voyeur', { slot: slot.slot });
              }}
            >
              Scry
            </button>
          )}
          <button
            type="button"
            style={inkButtonStyle({ disabled: !canSever })}
            disabled={!canSever}
            title={
              slot.allow_summons
                ? 'Summons are allowed. The cage holder may summon a zad on demand.'
                : 'Summons are blocked. The cage holder cannot summon zads.'
            }
            onClick={() => {
              if (!canSever) return;
              act('toggle_summons', { slot: slot.slot });
            }}
          >
            {slot.allow_summons ? 'Summons: on' : 'Summons: off'}
          </button>
          <button
            type="button"
            style={inkButtonStyle({ disabled: !canSever })}
            disabled={!canSever}
            title={
              canSever
                ? 'Sever this zadlink. A zad in flight will complete its trip first.'
                : 'Nothing to sever.'
            }
            onClick={() => {
              if (!canSever) return;
              act('sever', { slot: slot.slot });
            }}
          >
            Sever
          </button>
        </div>
      </div>
      {expanded && !slot.severed && slot.bonded && (
        <SendPanel data={data} slot={slot} act={act} onClose={onToggle} />
      )}
    </div>
  );
};

export const Zadcote = () => {
  const { data, act } = useBackend<ZadcoteData>();
  const [expandedSlot, setExpandedSlot] = useState<number | null>(null);
  const [tab, setTab] = useState<'slots' | 'log'>('slots');

  return (
    <Window title="Zadcote" width={720} height={760} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <ReserveHeader data={data} onHelp={() => act('help')} act={act} />
          <div style={{ display: 'flex', gap: '6px', margin: '8px 0' }}>
            <TabButton active={tab === 'slots'} onClick={() => setTab('slots')}>
              Zadlinks
            </TabButton>
            <TabButton active={tab === 'log'} onClick={() => setTab('log')}>
              Mail Ledger {data.mail_log.length > 0 ? `(${data.mail_log.length})` : ''}
            </TabButton>
          </div>
          {tab === 'slots' && (
            <div style={cardStyle}>
              {data.slots.length === 0 ? (
                <div
                  style={{
                    textAlign: 'center',
                    color: INK_SOFT,
                    fontStyle: 'italic',
                    padding: '6px 0',
                  }}
                >
                  No zadlinks. Strike a zadcage on the cote to bond one.
                </div>
              ) : (
                data.slots.map((slot) => (
                  <SlotRow
                    key={slot.slot}
                    data={data}
                    slot={slot}
                    expanded={expandedSlot === slot.slot}
                    onToggle={() =>
                      setExpandedSlot((prev) => (prev === slot.slot ? null : slot.slot))
                    }
                    act={act}
                  />
                ))
              )}
            </div>
          )}
          {tab === 'log' && <MailLog entries={data.mail_log} />}
        </div>
      </Window.Content>
    </Window>
  );
};

const TabButton = (props: {
  active: boolean;
  onClick: () => void;
  children: React.ReactNode;
}) => (
  <button
    type="button"
    onClick={props.onClick}
    style={{
      ...inkButtonStyle({}),
      fontWeight: props.active ? 'bold' : 'normal',
      background: props.active ? BUTTON_BG : 'transparent',
      borderColor: props.active ? INK : INK_FAINT,
    }}
  >
    {props.children}
  </button>
);

const MailLog = (props: { entries: MailEntry[] }) => {
  const { entries } = props;
  const sent = entries.filter((e) => e.kind === 'sent');
  const received = entries.filter((e) => e.kind === 'returned');
  return (
    <div style={{ display: 'flex', gap: '8px' }}>
      <MailColumn title="SENT" entries={sent} accent={SEAL_AMBER} />
      <MailColumn title="RECEIVED" entries={received} accent={SEAL_GREEN} />
    </div>
  );
};

const MailColumn = (props: {
  title: string;
  entries: MailEntry[];
  accent: string;
}) => {
  const { title, entries, accent } = props;
  const [expandedIdx, setExpandedIdx] = useState<number | null>(null);
  return (
    <div style={{ ...cardStyle, flex: 1, minWidth: 0 }}>
      <div
        style={{
          ...sectionHeaderStyle,
          marginTop: 0,
          color: accent,
          borderBottomColor: accent,
        }}
      >
        {title} ({entries.length})
      </div>
      {entries.length === 0 ? (
        <div
          style={{
            textAlign: 'center',
            color: INK_SOFT,
            fontStyle: 'italic',
            padding: '6px 0',
            fontSize: FONT_SMALL,
          }}
        >
          Nothing yet.
        </div>
      ) : (
        entries.map((entry, idx) => {
          const expanded = expandedIdx === idx;
          const hasMessage = !!entry.message && entry.message.length > 0;
          return (
            <div
              key={idx}
              style={{
                padding: '4px 0',
                borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
                fontSize: FONT_BODY,
                cursor: hasMessage ? 'pointer' : 'default',
              }}
              onClick={() => {
                if (hasMessage) setExpandedIdx(expanded ? null : idx);
              }}
            >
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', gap: '6px' }}>
                <span style={{ fontWeight: 'bold', color: INK, overflow: 'hidden', textOverflow: 'ellipsis' }}>
                  #{entry.slot} {entry.sender}
                  {hasMessage && (
                    <span style={{ color: INK_FAINT, marginLeft: '4px' }}>
                      {expanded ? '▾' : '▸'}
                    </span>
                  )}
                </span>
                <span style={{ color: INK_FAINT, fontSize: FONT_SMALL, fontFamily: 'monospace', flexShrink: 0 }}>
                  {entry.stamp}
                </span>
              </div>
              {(() => {
                const zads = entry.zads_used ?? 0;
                if (zads <= 0) return null;
                const verb =
                  entry.kind === 'returned'
                    ? 'Returned'
                    : entry.summoned
                      ? 'Summoned'
                      : 'Sent';
                return (
                  <div style={{ color: INK_SOFT, fontSize: FONT_SMALL, paddingLeft: '8px' }}>
                    {verb}: {zads} zad{zads === 1 ? '' : 's'}
                  </div>
                );
              })()}
              {entry.items && entry.items.length > 0 ? (
                <div style={{ color: INK_SOFT, fontSize: FONT_SMALL, paddingLeft: '8px' }}>
                  {entry.kind === 'sent' ? 'Carried' : 'Brought'}: {entry.items.join(', ')}
                </div>
              ) : null}
              {entry.kind === 'sent' && (entry.bombs ?? 0) > 0 ? (
                <div style={{ color: SEAL_RED, fontSize: FONT_SMALL, paddingLeft: '8px' }}>
                  {entry.bombs} bottlebomb{entry.bombs === 1 ? '' : 's'} attached
                </div>
              ) : null}
              {entry.kind === 'returned' && (entry.lost ?? 0) > 0 ? (
                <div style={{ color: SEAL_RED, fontSize: FONT_SMALL, paddingLeft: '8px' }}>
                  {entry.lost} of {entry.zads_used} zad{entry.zads_used === 1 ? '' : 's'} lost to exhaustion
                </div>
              ) : null}
              {hasMessage && expanded && (
                <div
                  style={{
                    color: INK,
                    fontStyle: 'italic',
                    padding: '4px 8px',
                    marginTop: '4px',
                    background: 'rgba(0,0,0,0.04)',
                    borderLeft: `2px solid ${INK_FAINT}`,
                    fontSize: FONT_SMALL,
                  }}
                >
                  &ldquo;{entry.message}&rdquo;
                </div>
              )}
            </div>
          );
        })
      )}
    </div>
  );
};
