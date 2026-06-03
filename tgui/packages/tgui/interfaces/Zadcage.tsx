import { useEffect, useState } from 'react';
import { Input } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  bannerStyle,
  cardStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  rulerStyle,
  SEAL_RED,
  sectionHeaderStyle,
  SERIF,
  subtitleStyle,
  titleStyle,
} from './common/parchment';

type PayloadItem = { name: string; ref: string; w_class?: number };
type StoredItem = { name: string };

const WEIGHT_CLASS_SMALL = 2;
const WEIGHT_CLASS_NORMAL = 3;
const WEIGHT_CLASS_BULKY = 4;

const maxWeightForTier = (tier: number): number => {
  if (tier === 1) return WEIGHT_CLASS_SMALL;
  if (tier === 2) return WEIGHT_CLASS_NORMAL;
  return WEIGHT_CLASS_BULKY;
};

const weightLabel = (wc: number): string => {
  if (wc <= 1) return 'tiny';
  if (wc === 2) return 'small';
  if (wc === 3) return 'normal';
  if (wc === 4) return 'bulky';
  return 'too heavy';
};

type ZadcageData = {
  bonded: boolean;
  severed: boolean;
  slot_label: string;
  slot_index: number;
  cote_name: string;
  cote_motto: string;
  allow_summons: boolean;
  pending_flight: boolean;
  occupied: boolean;
  time_remaining?: number;
  warning_tail?: boolean;
  capacity?: number;
  has_bombs?: boolean;
  reply_message?: string;
  payload_in_hand: PayloadItem[];
  stored_payload: StoredItem[];
};

const formatCountdown = (seconds: number) => {
  const m = Math.floor(seconds / 60);
  const s = seconds % 60;
  return `${m}:${s.toString().padStart(2, '0')}`;
};

const helpButtonStyle = {
  position: 'absolute' as const,
  top: '8px',
  right: '8px',
  ...inkButtonStyle(),
};

export const Zadcage = () => {
  const { act, data } = useBackend<ZadcageData>();
  return (
    <Window title="Zadcage" width={480} height={560} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <button style={helpButtonStyle} onClick={() => act('help')}>
            ?
          </button>
          <div style={titleStyle}>Zadcage</div>
          <div style={subtitleStyle}>
            {data.bonded
              ? `${data.cote_name} - Slot ${data.slot_index}: ${data.slot_label}`
              : 'Unbonded - strike against a zadcote to bond.'}
          </div>
          <hr style={rulerStyle} />
          {!!data.severed && (
            <div style={bannerStyle(SEAL_RED)}>The zadlink has been severed.</div>
          )}
          {!data.occupied && data.bonded && !data.severed && data.stored_payload.length === 0 && (
            <div style={{ color: INK_SOFT, fontStyle: 'italic', textAlign: 'center', margin: '14px 0' }}>
              No zad in the cage. Wait for one to arrive.
            </div>
          )}
          <SummonPanel />
          {data.stored_payload.length > 0 && <StoredPanel />}
          {!!data.occupied && <OccupancyPanel />}
        </div>
      </Window.Content>
    </Window>
  );
};

const SummonPanel = () => {
  const { act, data } = useBackend<ZadcageData>();
  const pending = !!data.pending_flight;
  const [zads, setZads] = useState(1);

  const may_summon = !data.occupied && data.bonded && !data.severed && data.allow_summons;

  if(!may_summon) return null;

  return (
    <div style={cardStyle}>
      <div style={{ fontWeight: 'bold', color: INK, marginBottom: '4px' }}>
        Summon a flight
      </div>
      <div style={{ color: INK_SOFT, fontSize: FONT_BODY, marginBottom: '6px' }}>
        {pending
          ? 'A flight is already on the way.'
          : `Call a flight from ${data.cote_name || 'the zadcote'}. It will arrive in about a minute. Load any package onto it once it lands.`}
      </div>
      {!pending && (
        <div style={{ marginBottom: '8px' }}>
          <div
            style={{
              color: INK_SOFT,
              fontSize: FONT_BODY,
              marginBottom: '2px',
            }}
          >
            Zads
          </div>
          <div style={{ display: 'flex', gap: '4px' }}>
            {[1, 2, 3].map((opt) => {
              const active = opt === zads;
              return (
                <button
                  key={opt}
                  type="button"
                  style={{
                    ...inkButtonStyle(),
                    padding: '2px 12px',
                    fontWeight: active ? 'bold' : 'normal',
                    borderColor: active ? INK : INK_FAINT,
                    color: active ? INK : INK_SOFT,
                  }}
                  onClick={() => setZads(opt)}
                >
                  {opt}
                </button>
              );
            })}
          </div>
          <div
            style={{
              color: INK_FAINT,
              fontSize: FONT_BODY,
              marginTop: '2px',
            }}
          >
            {zads === 1
              ? '1 zad: tiny or small return parcel.'
              : zads === 2
                ? '2 zads: pouch, helmet, or normal-sized return.'
                : '3 zads: bulky return parcel or large container.'}
          </div>
        </div>
      )}
      <div style={{ textAlign: 'center' }}>
        <button
          type="button"
          style={inkButtonStyle({ disabled: pending })}
          disabled={pending}
          onClick={() => act('request_summon', { zads })}
        >
          Summon
        </button>
      </div>
    </div>
  );
};

const StoredPanel = () => {
  const { act, data } = useBackend<ZadcageData>();
  if (!data.stored_payload.length) return null;
  return (
    <div style={cardStyle}>
      <div style={{ fontWeight: 'bold', color: INK, marginBottom: '4px' }}>
        Held in the cage
      </div>
      {data.stored_payload.map((item, idx) => (
        <div key={idx} style={{ fontSize: FONT_BODY, color: INK }}>
          - {item.name}
        </div>
      ))}
      <div style={{ marginTop: '8px', textAlign: 'center' }}>
        <button type="button" style={inkButtonStyle()} onClick={() => act('retrieve')}>
          Retrieve
        </button>
      </div>
    </div>
  );
};

const OccupancyPanel = () => {
  const { act, data } = useBackend<ZadcageData>();
  const remaining = data.time_remaining ?? 0;
  const warning = !!data.warning_tail;
  const capacity = data.capacity ?? 1;
  const serverReply = data.reply_message ?? '';
  const [draft, setDraft] = useState(serverReply);
  const [selectedRef, setSelectedRef] = useState<string | null>(null);
  useEffect(() => {
    setDraft(serverReply);
  }, [serverReply]);
  useEffect(() => {
    if (
      selectedRef &&
      !data.payload_in_hand.find((item) => item.ref === selectedRef)
    ) {
      setSelectedRef(null);
    }
  }, [data.payload_in_hand, selectedRef]);
  const dirty = draft.trim() !== serverReply.trim();
  const tierMax = maxWeightForTier(capacity);
  return (
    <div>
      <div style={cardStyle}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div>
            <div style={{ fontWeight: 'bold', color: INK }}>
              A flight waits in the cage
            </div>
            <div style={{ color: INK_SOFT, fontSize: FONT_BODY }}>
              Capacity for return: {capacity} {capacity === 1 ? 'zad' : 'zads'}
            </div>
          </div>
          <div
            style={{
              fontFamily: SERIF,
              fontWeight: 'bold',
              color: warning ? SEAL_RED : INK,
              fontSize: '18px',
            }}
          >
            {formatCountdown(remaining)}
          </div>
        </div>
        {warning && (
          <div style={{ color: SEAL_RED, fontSize: FONT_BODY, marginTop: '4px' }}>
            Auto-depart imminent. Auto-depart will NOT carry your reply or package.
          </div>
        )}
      </div>
      <div style={sectionHeaderStyle}>Reply</div>
      <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
        <Input
          fluid
          value={draft}
          maxLength={500}
          placeholder="A few words back..."
          onChange={setDraft}
        />
        <button
          type="button"
          disabled={!dirty}
          style={inkButtonStyle({ disabled: !dirty })}
          onClick={() => {
            if (!dirty) return;
            act('set_reply_message', { message: draft });
          }}
        >
          Set
        </button>
      </div>
      <div style={sectionHeaderStyle}>Return Package</div>
      <div style={{ color: INK_FAINT, fontSize: FONT_BODY, marginBottom: '6px' }}>
        Hold a parcel in your active hand to send it back.
        {capacity === 1
          ? ' This return can carry a tiny or small item.'
          : capacity === 2
            ? ' This return can carry up to a normal-sized item (helmet, pouch).'
            : ' This return can carry a bulky parcel or large container.'}
      </div>
      {data.payload_in_hand.length === 0 ? (
        <div style={{ color: INK_FAINT, fontStyle: 'italic', fontSize: FONT_BODY }}>
          Empty-handed - hold something to offer it as the return parcel.
        </div>
      ) : (
        <div>
          {data.payload_in_hand.map((item) => {
            const wc = item.w_class ?? 0;
            const tooHeavy = wc > tierMax;
            const checked = !tooHeavy && selectedRef === item.ref;
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
                  cursor: tooHeavy ? 'not-allowed' : 'pointer',
                  opacity: tooHeavy ? 0.6 : 1,
                }}
              >
                <input
                  type="checkbox"
                  checked={checked}
                  disabled={tooHeavy}
                  onChange={() =>
                    setSelectedRef(checked ? null : item.ref)
                  }
                />
                <span>{item.name}</span>
                <span
                  style={{
                    color: tooHeavy ? SEAL_RED : INK_FAINT,
                    marginLeft: 'auto',
                  }}
                >
                  {tooHeavy
                    ? `${weightLabel(wc)} - too heavy for ${capacity} zad${capacity === 1 ? '' : 's'}`
                    : weightLabel(wc)}
                </span>
              </label>
            );
          })}
        </div>
      )}
      <div style={{ marginTop: '14px', textAlign: 'center' }}>
        <button
          type="button"
          style={inkButtonStyle()}
          onClick={() =>
            act('send_reply', selectedRef ? { payload_ref: selectedRef } : {})
          }
        >
          Send Reply
        </button>
      </div>
    </div>
  );
};
