import { useState } from 'react';
import { NumberInput } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  inkInputStyle,
  pageStyle,
  rulerStyle,
  SEAL_AMBER,
  SEAL_RED_SOFT,
  SERIF,
  sectionHeaderStyle,
} from './common/parchment';

type CategoryRate = {
  category: string;
  rate: number;
};

type PollLevyClass = {
  category: string;
  label: string;
  exempt_charter: string | null;
  heads: number;
  cap: number;
  cap_charters: string[];
};

type PollLevy = {
  authority: 'duke' | 'steward' | null;
  blocked_reason: string | null;
  levies_used: number;
  levies_max: number;
  min_balance: number;
  classes: PollLevyClass[];
};

type Data = {
  categoryRates: CategoryRate[];
  concordatFloor: number;
  levyCooldown: boolean;
  pollLevy: PollLevy;
  pollLevyMax: number;
  pollLevyReasonMin: number;
  pollLevyReasonMax: number;
};

const rowStyle: React.CSSProperties = {
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',
  padding: '3px 0',
  borderBottom: '1px solid rgba(120,80,30,0.1)',
};

const labelStyle: React.CSSProperties = {
  fontFamily: SERIF,
  fontSize: FONT_BODY,
  color: INK,
};

const noteStyle: React.CSSProperties = {
  fontSize: FONT_BODY,
  color: INK_SOFT,
  marginBottom: '8px',
};

const bannerStyle: React.CSSProperties = {
  background: 'rgba(140,60,30,0.12)',
  border: `1px solid ${SEAL_RED_SOFT}`,
  color: SEAL_RED_SOFT,
  padding: '6px 10px',
  textAlign: 'center',
  fontWeight: 'bold',
  marginBottom: '10px',
};

const PollLevyPanel = (props: {
  levy: PollLevy;
  levyMax: number;
  reasonMin: number;
  reasonMax: number;
  onEnact: (
    amounts: { category: string; amount: number }[],
    reason: string,
  ) => void;
}) => {
  const { levy, levyMax, reasonMin, reasonMax, onEnact } = props;
  const [amounts, setAmounts] = useState<Record<string, number>>({});
  const [reason, setReason] = useState('');
  const [confirming, setConfirming] = useState(false);

  const blocked = !!levy.blocked_reason;
  const reasonLength = reason.trim().length;
  const payload = levy.classes
    .filter((c) => !c.exempt_charter && (amounts[c.category] || 0) > 0)
    .map((c) => ({ category: c.category, amount: amounts[c.category] }));
  const canSubmit =
    !blocked && payload.length > 0 && reasonLength >= reasonMin;

  return (
    <>
      <div style={sectionHeaderStyle}>Poll Levy</div>
      <div style={noteStyle}>
        Levies raised this week: {levy.levies_used} / {levy.levies_max}
      </div>
      <div style={noteStyle}>
        Maximum: {levyMax}m per head. Min. Bal: {levy.min_balance}m.
      </div>
      {blocked && <div style={bannerStyle}>{levy.blocked_reason}</div>}
      {levy.classes.map((c) => (
        <div key={c.category} style={rowStyle}>
          <span style={labelStyle}>
            {c.label}{' '}
            <span style={{ color: INK_FAINT }}>({c.heads})</span>
            {c.cap < levyMax && (
              <span
                title={c.cap_charters.join('\n')}
                style={{ color: SEAL_AMBER, marginLeft: '6px' }}
              >
                (MAX {c.cap}m)
              </span>
            )}
          </span>
          {c.exempt_charter ? (
            <span
              title={c.exempt_charter}
              style={{ color: SEAL_AMBER, fontWeight: 'bold' }}
            >
              EXEMPT
            </span>
          ) : (
            <NumberInput
              step={1}
              minValue={0}
              maxValue={c.cap}
              unit="m"
              disabled={blocked}
              value={amounts[c.category] || 0}
              onChange={(v: number) => {
                const clamped = Math.max(0, Math.min(v, c.cap));
                setAmounts((prev) => ({ ...prev, [c.category]: clamped }));
                setConfirming(false);
              }}
            />
          )}
        </div>
      ))}
      <div style={{ ...noteStyle, marginTop: '8px' }}>For reasons of:</div>
      <textarea
        value={reason}
        maxLength={reasonMax}
        disabled={blocked}
        onChange={(e) => {
          setReason(e.target.value);
          setConfirming(false);
        }}
        style={{
          ...inkInputStyle,
          width: '100%',
          height: '70px',
          boxSizing: 'border-box',
          resize: 'none',
        }}
      />
      <div
        style={{
          ...noteStyle,
          color: reasonLength >= reasonMin ? INK_SOFT : SEAL_RED_SOFT,
        }}
      >
        {reasonMin} to {reasonMax} characters ({reasonLength}/{reasonMax})
      </div>
      <hr style={rulerStyle} />
      <div style={{ textAlign: 'center' }}>
        <button
          disabled={!canSubmit}
          style={{
            ...inkButtonStyle({
              disabled: !canSubmit,
              color: confirming ? SEAL_RED_SOFT : undefined,
            }),
            padding: '5px 24px',
            fontSize: FONT_BODY,
          }}
          onClick={() => {
            if (!canSubmit) return;
            if (!confirming) {
              setConfirming(true);
              return;
            }
            setConfirming(false);
            onEnact(payload, reason);
          }}
        >
          {confirming ? 'Confirm' : 'Enact Levy'}
        </button>
      </div>
    </>
  );
};

export const TaxSetter = (props: any, context: any) => {
  const { act, data } = useBackend<Data>();
  const levyCooldown = !!data.levyCooldown;

  const [rates, setRates] = useState<Record<string, number>>(() => {
    if (!data.categoryRates) return {};
    return Object.fromEntries(
      data.categoryRates.map((c) => [c.category, c.rate]),
    );
  });

  const updateRate = (category: string, newRate: number) => {
    setRates((prev) => ({ ...prev, [category]: newRate }));
  };

  const payload = Object.entries(rates).map(([category, rate]) => ({
    category,
    rate,
  }));

  return (
    <Window width={760} height={640} title="Tax Roll" theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div
            style={{
              display: 'flex',
              gap: '18px',
              alignItems: 'flex-start',
            }}
          >
            <div style={{ flex: '0 0 300px' }}>
              <div style={sectionHeaderStyle}>Crown Levies</div>
              <div style={noteStyle}>
                The Crown takes this share of contract rewards, head bounties,
                imports, exports and recovered spoils. While the Concordat of
                Zenitstadt is in force, no levy can go below{' '}
                {data.concordatFloor}%. You can change the levies once per day.
              </div>
              {levyCooldown && (
                <div style={bannerStyle}>
                  You changed the levies today. Try again tomorrow.
                </div>
              )}
              {data.categoryRates?.map((c) => (
                <div key={c.category} style={rowStyle}>
                  <span style={labelStyle}>{c.category}</span>
                  <NumberInput
                    step={1}
                    minValue={0}
                    maxValue={100}
                    unit="%"
                    value={rates[c.category] ?? c.rate}
                    onChange={(v: number) => updateRate(c.category, v)}
                  />
                </div>
              ))}
              <hr style={rulerStyle} />
              <div style={{ textAlign: 'center' }}>
                <button
                  disabled={levyCooldown}
                  style={{
                    ...inkButtonStyle({ disabled: levyCooldown }),
                    padding: '5px 24px',
                    fontSize: FONT_BODY,
                  }}
                  onClick={() =>
                    !levyCooldown &&
                    act('set_rates', { categoryRates: payload })
                  }
                >
                  Set Levies
                </button>
              </div>
            </div>

            <div style={{ flex: '1 1 auto', minWidth: 0 }}>
              {data.pollLevy && (
                <PollLevyPanel
                  levy={data.pollLevy}
                  levyMax={data.pollLevyMax}
                  reasonMin={data.pollLevyReasonMin}
                  reasonMax={data.pollLevyReasonMax}
                  onEnact={(amounts, reason) =>
                    act('enact_poll_levy', { amounts, reason })
                  }
                />
              )}
            </div>
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};
