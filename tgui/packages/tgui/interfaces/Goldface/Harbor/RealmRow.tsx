import { useState } from 'react';

import {
  BUTTON_BG,
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

const toneToColor = (tone?: string) => {
  switch (tone) {
    case 'good':
      return SEAL_GREEN;
    case 'bad':
      return SEAL_RED;
    default:
      return SEAL_AMBER;
  }
};

const ConditionPill = (props: { condition: MarketCondition }) => {
  const color = toneToColor(props.condition.tone);
  return (
    <span
      title={props.condition.description}
      style={{
        display: 'inline-block',
        padding: '1px 7px',
        marginRight: '4px',
        marginBottom: '2px',
        border: `1px solid ${color}`,
        borderRadius: '8px',
        color: color,
        fontSize: '10px',
        fontVariant: 'small-caps',
        fontWeight: 'bold',
        whiteSpace: 'nowrap',
      }}
    >
      {props.condition.name}
    </span>
  );
};

const CategoryPill = (props: { name: string }) => (
  <span
    style={{
      display: 'inline-block',
      padding: '0px 5px',
      marginRight: '3px',
      marginBottom: '2px',
      border: `1px solid ${INK_FAINT}`,
      borderRadius: '3px',
      color: INK,
      background: BUTTON_BG,
      fontSize: '10px',
      whiteSpace: 'nowrap',
    }}
  >
    {props.name}
  </span>
);

const GoodPill = (props: { name: string; rare: boolean; color: string }) => {
  const { name, rare, color } = props;
  return (
    <span
      title={rare ? 'Sometimes' : 'Always'}
      style={{
        display: 'inline-block',
        padding: '0px 5px',
        marginRight: '3px',
        marginBottom: '2px',
        border: `1px ${rare ? 'dashed' : 'solid'} ${color}`,
        borderRadius: '3px',
        color: color,
        background: rare ? 'transparent' : BUTTON_BG,
        fontSize: '10px',
        whiteSpace: 'nowrap',
        opacity: rare ? 0.85 : 1,
      }}
    >
      {name}
    </span>
  );
};

const RowLabel = (props: { children: React.ReactNode; color: string }) => (
  <span
    style={{
      color: props.color,
      fontStyle: 'italic',
      fontSize: '10px',
      fontVariant: 'small-caps',
      fontWeight: 'bold',
      marginRight: '6px',
    }}
  >
    {props.children}
  </span>
);

export const REALM_GRID_COLUMNS = '14px 150px minmax(0, 1fr)';

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
          display: 'grid',
          gridTemplateColumns: REALM_GRID_COLUMNS,
          alignItems: 'start',
          columnGap: '8px',
          padding: '6px',
          cursor: 'pointer',
          fontSize: '11px',
        }}
        onClick={() => setExpanded((e) => !e)}
      >
        <div
          style={{
            color: INK_SOFT,
            fontSize: '11px',
            paddingTop: '2px',
          }}
        >
          {expanded ? '▾' : '▸'}
        </div>

        <div style={{ minWidth: 0 }}>
          <div
            style={{
              color: SEAL_AMBER,
              fontVariant: 'small-caps',
              fontSize: '13px',
              fontWeight: 'bold',
              overflow: 'hidden',
              textOverflow: 'ellipsis',
              whiteSpace: 'nowrap',
              marginBottom: '3px',
            }}
          >
            {realm.name}
          </div>
          <div style={{ lineHeight: '1.5' }}>
            {conditions.length === 0 ? (
              <span
                style={{
                  color: INK_SOFT,
                  fontStyle: 'italic',
                  fontSize: '10px',
                }}
              >
                no conditions
              </span>
            ) : (
              conditions.map((c) => (
                <ConditionPill key={c.name} condition={c} />
              ))
            )}
          </div>
        </div>

        <div style={{ minWidth: 0 }}>
          <div style={{ lineHeight: '1.5', marginBottom: '3px' }}>
            <RowLabel color={SEAL_AMBER}>Demand</RowLabel>
            {realm.demanded_categories.length === 0 ? (
              <span style={{ color: INK_FAINT, fontStyle: 'italic' }}>—</span>
            ) : (
              realm.demanded_categories.map((cat) => (
                <CategoryPill key={cat} name={cat} />
              ))
            )}
          </div>
          <div style={{ lineHeight: '1.5', marginBottom: '3px' }}>
            <RowLabel color={SEAL_GREEN}>Buys</RowLabel>
            {realm.basic_buys.length + realm.rare_buys.length === 0 ? (
              <span style={{ color: INK_FAINT, fontStyle: 'italic' }}>none</span>
            ) : (
              <>
                {realm.basic_buys.map((g) => (
                  <GoodPill
                    key={`b-${g}`}
                    name={g}
                    rare={false}
                    color={SEAL_GREEN}
                  />
                ))}
                {realm.rare_buys.map((g) => (
                  <GoodPill
                    key={`br-${g}`}
                    name={g}
                    rare
                    color={SEAL_GREEN}
                  />
                ))}
              </>
            )}
          </div>
          <div style={{ lineHeight: '1.5' }}>
            <RowLabel color={SEAL_RED}>Sells</RowLabel>
            {realm.basic_sells.length + realm.rare_sells.length === 0 ? (
              <span style={{ color: INK_FAINT, fontStyle: 'italic' }}>none</span>
            ) : (
              <>
                {realm.basic_sells.map((g) => (
                  <GoodPill
                    key={`s-${g}`}
                    name={g}
                    rare={false}
                    color={SEAL_RED}
                  />
                ))}
                {realm.rare_sells.map((g) => (
                  <GoodPill
                    key={`sr-${g}`}
                    name={g}
                    rare
                    color={SEAL_RED}
                  />
                ))}
              </>
            )}
          </div>
        </div>
      </div>
      {expanded && (
        <div
          style={{
            padding: '6px 8px 10px 36px',
            fontSize: '12px',
            color: INK,
            background: 'var(--p-card-bg)',
          }}
        >
          {realm.cultural_pack_names.length > 0 && (
            <div style={{ marginBottom: '8px' }}>
              <div
                style={{
                  color: SEAL_AMBER,
                  fontStyle: 'italic',
                  fontWeight: 'bold',
                  marginBottom: '4px',
                }}
              >
                Cultural Stock:
              </div>
              <div style={{ lineHeight: '1.6' }}>
                {realm.cultural_pack_names.map((p) => (
                  <CategoryPill key={p} name={p} />
                ))}
              </div>
            </div>
          )}
          {conditions.length > 0 && (
            <div style={{ marginBottom: '8px' }}>
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
              {conditions.map((c) => (
                <div key={c.name} style={{ marginBottom: '6px' }}>
                  <ConditionPill condition={c} />
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
              ))}
            </div>
          )}
        </div>
      )}
    </div>
  );
};
