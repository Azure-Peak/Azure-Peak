import { useState } from 'react';
import { NumberInput } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  INK,
  INK_SOFT,
  SEAL_RED_SOFT,
  SERIF,
  inkButtonStyle,
  pageStyle,
  rulerStyle,
  sectionHeaderStyle,
} from './StewardTrade/styles';

type CategoryRate = {
  category: string;
  rate: number;
};

type PollTaxRate = {
  category: string;
  label: string;
  rate: number;
};

type Data = {
  categoryRates: CategoryRate[];
  pollTaxRates: PollTaxRate[];
  pollTaxMax: number;
  onCooldown: boolean;
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
  fontSize: '13px',
  color: INK,
};

export const TaxSetter = (props: any, context: any) => {
  const { act, data } = useBackend<Data>();
  const onCooldown = !!data.onCooldown;

  const [rates, setRates] = useState<Record<string, number>>(() => {
    if (!data.categoryRates) return {};
    return Object.fromEntries(
      data.categoryRates.map((c) => [c.category, c.rate]),
    );
  });

  const [pollRates, setPollRates] = useState<Record<string, number>>(() => {
    if (!data.pollTaxRates) return {};
    return Object.fromEntries(
      data.pollTaxRates.map((c) => [c.category, c.rate]),
    );
  });

  const updateRate = (category: string, newRate: number) => {
    setRates((prev) => ({ ...prev, [category]: newRate }));
  };

  const updatePollRate = (category: string, newRate: number) => {
    setPollRates((prev) => ({ ...prev, [category]: newRate }));
  };

  const payload = Object.entries(rates).map(([category, rate]) => ({
    category,
    rate,
  }));

  const pollPayload = Object.entries(pollRates).map(([category, rate]) => ({
    category,
    rate,
  }));

  const pollMax = data.pollTaxMax ?? 50;

  return (
    <Window width={360} height={780}>
      <Window.Content fitted>
        <div style={pageStyle}>
          <div
            style={{
              textAlign: 'center',
              fontStyle: 'italic',
              fontSize: '11px',
              color: INK_SOFT,
              marginBottom: '10px',
            }}
          >
            Tax rates may only be changed once per day - choose wisely.
          </div>

          {onCooldown && (
            <div
              style={{
                background: 'rgba(140,60,30,0.12)',
                border: `1px solid ${SEAL_RED_SOFT}`,
                color: SEAL_RED_SOFT,
                padding: '6px 10px',
                textAlign: 'center',
                fontVariant: 'small-caps',
                letterSpacing: '1px',
                fontWeight: 'bold',
                marginBottom: '10px',
              }}
            >
              Rates adjusted today - locked until tomorrow.
            </div>
          )}

          <div style={sectionHeaderStyle}>Crown Levies</div>
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
          <div style={{ textAlign: 'center', marginBottom: '12px' }}>
            <button
              disabled={onCooldown}
              style={{
                ...inkButtonStyle({ disabled: onCooldown }),
                padding: '5px 24px',
                fontSize: '13px',
                letterSpacing: '3px',
              }}
              onClick={() =>
                !onCooldown && act('set_rates', { categoryRates: payload })
              }
            >
              Make It So
            </button>
          </div>

          <div style={sectionHeaderStyle}>Poll Tax</div>
          <div
            style={{
              fontSize: '11px',
              color: INK_SOFT,
              fontStyle: 'italic',
              marginBottom: '8px',
            }}
          >
            Per category, per day
          </div>
          {data.pollTaxRates?.map((c) => (
            <div key={c.category} style={rowStyle}>
              <span style={labelStyle}>{c.label}</span>
              <NumberInput
                step={1}
                minValue={0}
                maxValue={pollMax}
                unit="m"
                value={pollRates[c.category] ?? c.rate}
                onChange={(v: number) => updatePollRate(c.category, v)}
              />
            </div>
          ))}

          <hr style={rulerStyle} />
          <div style={{ textAlign: 'center' }}>
            <button
              disabled={onCooldown}
              style={{
                ...inkButtonStyle({ disabled: onCooldown }),
                padding: '5px 24px',
                fontSize: '13px',
                letterSpacing: '3px',
              }}
              onClick={() =>
                !onCooldown &&
                act('set_poll_rates', { pollTaxRates: pollPayload })
              }
            >
              Set Poll Taxes
            </button>
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};
