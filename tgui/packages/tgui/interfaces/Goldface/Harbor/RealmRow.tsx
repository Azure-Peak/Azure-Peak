import { useState } from 'react';

import {
  INK,
  INK_FAINT,
  INK_SOFT,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
} from '../../common/parchment';
import type { HarborRealm, MarketCondition } from '../types';

const summarize = (items: string[], cap: number) => {
  if (items.length === 0) return '—';
  if (items.length <= cap) return items.join(', ');
  return `${items.slice(0, cap).join(', ')}, +${items.length - cap} more`;
};

const Unknown = () => (
  <span style={{ color: INK_FAINT, fontStyle: 'italic' }}>UNKNOWN</span>
);

const ConditionPill = (props: { name: string }) => (
  <span
    style={{
      display: 'inline-block',
      padding: '1px 7px',
      marginRight: '4px',
      marginBottom: '2px',
      border: `1px solid ${SEAL_AMBER}`,
      borderRadius: '8px',
      color: SEAL_AMBER,
      fontSize: '10px',
      fontVariant: 'small-caps',
      letterSpacing: '0.5px',
      fontWeight: 'bold',
      whiteSpace: 'nowrap',
    }}
  >
    {props.name}
  </span>
);

const MarketConditionsCell = (props: { realm: HarborRealm }) => {
  const { realm } = props;
  if (!realm.discovered) return <Unknown />;
  const conditions = realm.market_conditions ?? [];
  if (conditions.length === 0) {
    return (
      <span style={{ color: INK_SOFT, fontStyle: 'italic' }}>—</span>
    );
  }
  return (
    <div style={{ textAlign: 'right' }}>
      {conditions.map((c: MarketCondition) => (
        <ConditionPill key={c.name} name={c.name} />
      ))}
    </div>
  );
};

const TradeListBlock = (props: {
  label: string;
  items: string[];
  labelColor: string;
}) => {
  const { label, items, labelColor } = props;
  return (
    <div style={{ marginBottom: '4px' }}>
      <span
        style={{
          color: labelColor,
          fontStyle: 'italic',
          marginRight: '6px',
          fontWeight: 'bold',
        }}
      >
        {label}:
      </span>
      {items.length === 0 ? (
        <span style={{ color: INK_FAINT, fontStyle: 'italic' }}>none</span>
      ) : (
        items.join(', ')
      )}
    </div>
  );
};

export const RealmRow = (props: { realm: HarborRealm }) => {
  const { realm } = props;
  const [expanded, setExpanded] = useState(false);
  const conditions = realm.market_conditions ?? [];

  return (
    <div
      style={{
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontFamily: SERIF,
      }}
    >
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: '12px',
          padding: '6px 8px',
          cursor: 'pointer',
        }}
        onClick={() => setExpanded((e) => !e)}
      >
        <div style={{ flex: '0 0 16px', color: INK_SOFT, fontSize: '11px' }}>
          {expanded ? '▾' : '▸'}
        </div>
        <div style={{ flex: '0 0 130px' }}>
          <div
            style={{
              color: SEAL_AMBER,
              fontVariant: 'small-caps',
              letterSpacing: '1px',
              fontSize: '13px',
              fontWeight: 'bold',
            }}
          >
            {realm.name}
          </div>
        </div>
        <div
          style={{
            flex: 1,
            fontSize: '11px',
            color: INK,
          }}
        >
          <div>
            <span style={{ color: SEAL_GREEN, fontWeight: 'bold' }}>Buys</span>
            {' '}
            <span style={{ color: INK_SOFT }}>
              {summarize(realm.basic_buys, 3)}
            </span>
          </div>
          <div>
            <span style={{ color: SEAL_RED, fontWeight: 'bold' }}>Sells</span>
            {' '}
            <span style={{ color: INK_SOFT }}>
              {summarize(realm.basic_sells, 3)}
            </span>
          </div>
        </div>
        <div
          style={{
            flex: '0 0 180px',
            textAlign: 'right',
            fontSize: '12px',
          }}
        >
          <MarketConditionsCell realm={realm} />
        </div>
      </div>
      {expanded && (
        <div
          style={{
            padding: '6px 8px 10px 36px',
            fontSize: '12px',
            color: INK,
          }}
        >
          <TradeListBlock
            label="Always Buys"
            items={realm.basic_buys}
            labelColor={SEAL_GREEN}
          />
          <TradeListBlock
            label="Sometimes Buys"
            items={realm.rare_buys}
            labelColor={SEAL_GREEN}
          />
          <TradeListBlock
            label="Always Sells"
            items={realm.basic_sells}
            labelColor={SEAL_RED}
          />
          <TradeListBlock
            label="Sometimes Sells"
            items={realm.rare_sells}
            labelColor={SEAL_RED}
          />
          <div style={{ marginTop: '6px' }}>
            <div
              style={{
                color: SEAL_AMBER,
                fontStyle: 'italic',
                fontWeight: 'bold',
                marginBottom: '4px',
              }}
            >
              Market Conditions:
            </div>
            {!realm.discovered ? (
              <Unknown />
            ) : conditions.length === 0 ? (
              <span style={{ color: INK_SOFT, fontStyle: 'italic' }}>
                No notable conditions reported.
              </span>
            ) : (
              conditions.map((c: MarketCondition) => (
                <div key={c.name} style={{ marginBottom: '6px' }}>
                  <ConditionPill name={c.name} />
                  <div
                    style={{
                      marginTop: '2px',
                      color: INK_SOFT,
                      fontSize: '11px',
                      lineHeight: '1.4',
                    }}
                  >
                    {c.description}
                  </div>
                </div>
              ))
            )}
          </div>
        </div>
      )}
    </div>
  );
};
