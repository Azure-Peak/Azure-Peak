import { useState } from 'react';
import { NumberInput } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  INK,
  INK_FAINT,
  INK_SOFT,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  SEAL_RED_SOFT,
  SERIF,
  inkButtonStyle,
  pageStyle,
  rulerStyle,
  sectionHeaderStyle,
} from './common/parchment';

type CategoryRate = {
  category: string;
  rate: number;
};

type PollTaxRate = {
  category: string;
  label: string;
  rate: number;
};

type PollCategoryProjection = {
  category: string;
  rate: number;
  heads: number;
  taxable: number;
  per_tick: number;
};

type PollProjection = {
  income: number;
  subsidy: number;
  net: number;
  headcount: number;
  by_category: PollCategoryProjection[];
};

type Data = {
  categoryRates: CategoryRate[];
  pollTaxRates: PollTaxRate[];
  pollTaxMax: number;
  pollTaxMin: number;
  onCooldown: boolean;
  pollProjection: PollProjection;
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

const PollProjectionPanel = (props: { projection: PollProjection }) => {
  const { projection } = props;
  const net = projection.net;
  const netColor = net > 0 ? SEAL_GREEN : net < 0 ? SEAL_RED : INK_SOFT;
  const netLabel =
    net > 0 ? `+${net}m / tick` : net < 0 ? `${net}m / tick` : '0m / tick';
  return (
    <div
      style={{
        background: 'rgba(200,170,100,0.12)',
        border: `1px solid ${INK_FAINT}`,
        padding: '6px 10px',
        marginBottom: '10px',
        fontSize: '11px',
      }}
    >
      <div
        style={{
          display: 'flex',
          justifyContent: 'space-between',
          marginBottom: '4px',
        }}
      >
        <span style={{ color: INK_SOFT, fontVariant: 'small-caps', letterSpacing: '1px' }}>
          Projected per tick
        </span>
        <span style={{ color: netColor, fontWeight: 'bold' }}>{netLabel}</span>
      </div>
      <div
        style={{
          display: 'flex',
          gap: '12px',
          fontSize: '11px',
          color: INK_SOFT,
          marginBottom: '4px',
        }}
      >
        <span>
          Income:{' '}
          <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
            {projection.income}m
          </span>
        </span>
        <span>
          Subsidy:{' '}
          <span style={{ color: SEAL_RED_SOFT, fontWeight: 'bold' }}>
            -{projection.subsidy}m
          </span>
        </span>
        <span style={{ color: INK_FAINT, marginLeft: 'auto' }}>
          {projection.headcount} head{projection.headcount === 1 ? '' : 's'}
        </span>
      </div>
      <div
        style={{
          fontSize: '10px',
          color: INK_FAINT,
          fontStyle: 'italic',
        }}
      >
        Gross projection from rate × eligible heads. Ignores balance, advance, arrears.
      </div>
    </div>
  );
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
  const pollMin = data.pollTaxMin ?? 0;
  const projection = data.pollProjection;

  return (
    <Window width={760} height={640} title="Tax Roll" theme="parchment">
      <Window.Content scrollable>
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

          <div
            style={{
              display: 'flex',
              gap: '18px',
              alignItems: 'flex-start',
            }}
          >
            {/* Left column: Crown Levies */}
            <div style={{ flex: '0 0 300px' }}>
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
                    !onCooldown && act('set_rates', { categoryRates: payload })
                  }
                >
                  Make It So
                </button>
              </div>
            </div>

            {/* Right column: Poll Tax */}
            <div style={{ flex: '1 1 auto', minWidth: 0 }}>
              <div style={sectionHeaderStyle}>Poll Tax</div>
              <div
                style={{
                  fontSize: '11px',
                  color: INK_SOFT,
                  fontStyle: 'italic',
                  marginBottom: '8px',
                }}
              >
                Per category, per tick. Negative values pay the subject from the
                Crown&apos;s Purse each tick (subsidy); positive values collect.
                Subsidies reach charter-protected classes; taxes do not.
              </div>
              {projection && <PollProjectionPanel projection={projection} />}
              {data.pollTaxRates?.map((c) => (
                <div key={c.category} style={rowStyle}>
                  <span style={labelStyle}>{c.label}</span>
                  <NumberInput
                    step={1}
                    minValue={pollMin}
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
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};
