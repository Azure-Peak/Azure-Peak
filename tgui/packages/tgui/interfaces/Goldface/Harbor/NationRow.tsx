import { useState } from 'react';

import {
  INK,
  INK_FAINT,
  INK_SOFT,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  SERIF,
} from '../../common/parchment';
import type { HarborNation } from '../types';

const summarize = (items: string[], cap: number) => {
  if (items.length === 0) return '—';
  if (items.length <= cap) return items.join(', ');
  return `${items.slice(0, cap).join(', ')}, +${items.length - cap} more`;
};

const Unknown = () => (
  <span style={{ color: INK_FAINT, fontStyle: 'italic' }}>UNKNOWN</span>
);

const MarketConditionsCell = (props: { nation: HarborNation }) => {
  const { nation } = props;
  if (!nation.discovered) return <Unknown />;
  const conditions = nation.market_conditions ?? [];
  if (conditions.length === 0) {
    return (
      <span style={{ color: INK_SOFT, fontStyle: 'italic' }}>
        No notable conditions
      </span>
    );
  }
  return <span style={{ color: INK }}>{summarize(conditions, 2)}</span>;
};

export const NationRow = (props: { nation: HarborNation }) => {
  const { nation } = props;
  const [expanded, setExpanded] = useState(false);
  const conditions = nation.market_conditions ?? [];
  const hasGoods = nation.cultural_goods.length > 0;

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
        <div
          style={{
            flex: '0 0 16px',
            color: INK_SOFT,
            fontSize: '11px',
          }}
        >
          {expanded ? '▾' : '▸'}
        </div>
        <div style={{ flex: '0 0 140px' }}>
          <div
            style={{
              color: SEAL_AMBER,
              fontVariant: 'small-caps',
              letterSpacing: '1px',
              fontSize: '13px',
              fontWeight: 'bold',
            }}
          >
            {nation.name}
          </div>
        </div>
        <div
          style={{
            flex: 1,
            color: INK_SOFT,
            fontSize: '12px',
            fontStyle: hasGoods ? 'normal' : 'italic',
          }}
        >
          {summarize(nation.cultural_goods, 3)}
        </div>
        <div
          style={{
            flex: '0 0 200px',
            textAlign: 'right',
            fontSize: '12px',
          }}
        >
          <MarketConditionsCell nation={nation} />
        </div>
      </div>
      {expanded && (
        <div
          style={{
            padding: '4px 8px 10px 36px',
            fontSize: '12px',
            color: INK,
          }}
        >
          <div style={{ marginBottom: '6px' }}>
            <span
              style={{
                color: SEAL_AMBER,
                fontStyle: 'italic',
                marginRight: '6px',
              }}
            >
              Cultural Goods:
            </span>
            {hasGoods ? (
              nation.cultural_goods.join(', ')
            ) : (
              <span style={{ color: INK_FAINT, fontStyle: 'italic' }}>
                No goods of distinction recorded.
              </span>
            )}
          </div>
          <div>
            <span
              style={{
                color: SEAL_AMBER,
                fontStyle: 'italic',
                marginRight: '6px',
              }}
            >
              Market Conditions:
            </span>
            {!nation.discovered ? (
              <Unknown />
            ) : conditions.length === 0 ? (
              <span style={{ color: INK_SOFT, fontStyle: 'italic' }}>
                No notable conditions reported.
              </span>
            ) : (
              conditions.join(', ')
            )}
          </div>
        </div>
      )}
    </div>
  );
};
