import { useState } from 'react';

import { useBackend } from '../../backend';
import {
  badgeStyle,
  cardStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  SEAL_BLUE,
  SEAL_GREEN,
  SEAL_RED,
  sectionHeaderStyle,
  subTabBarStyle,
  subTabStyle,
} from '../common/parchment';
import { groupByCategory } from './helpers';
import type { Data, MarketRow } from './types';
import { formatMammon } from '../common/format';

export const MarketView = (props: { data: Data }) => {
  const { market_rows, good_catalog } = props.data;

  const groups = groupByCategory(market_rows, good_catalog);
  const [activeCategory, setActiveCategory] = useState<string>(
    groups[0]?.category ?? '',
  );

  const activeGroup =
    groups.find((g) => g.category === activeCategory) ?? groups[0];

  return (
    <div>
      <div style={sectionHeaderStyle}>Market</div>
      {market_rows.length === 0 ? (
        <div style={{ textAlign: 'center', color: INK_SOFT }}>
          The stockpile isn&apos;t taking any goods right now.
        </div>
      ) : (
        <>
          <div style={subTabBarStyle}>
            {groups.map((g) => (
              <div
                key={g.category}
                style={subTabStyle(g.category === activeGroup?.category)}
                onClick={() => setActiveCategory(g.category)}
              >
                {g.label} ({g.rows.length})
              </div>
            ))}
          </div>
          {activeGroup && (
            <div style={{ marginTop: '6px', minHeight: '650px' }}>
              {activeGroup.rows.map((row) => {
                const good = good_catalog[row.good_id];
                const name = good?.name ?? row.good_id;
                const eventColor =
                  row.event_tag === 'SHORTAGE'
                    ? SEAL_RED
                    : row.event_tag === 'GLUT'
                      ? SEAL_GREEN
                      : null;
                return (
                  <div key={row.good_id} style={cardStyle}>
                    <div style={{ marginBottom: '4px' }}>
                      <span style={{ fontWeight: 'bold' }}>{name}</span>
                      {eventColor && (
                        <span style={badgeStyle(eventColor)}>
                          {row.event_tag}
                        </span>
                      )}
                      <span
                        style={{
                          color: INK_FAINT,
                          marginLeft: '8px',
                          fontSize: FONT_BODY,
                        }}
                      >
                        Royal stock: {row.stock}
                      </span>
                    </div>
                    <StockpileStrip row={row} />
                  </div>
                );
              })}
            </div>
          )}
        </>
      )}
    </div>
  );
};

const stripStyle: React.CSSProperties = {
  display: 'flex',
  flexWrap: 'wrap',
  alignItems: 'center',
  gap: '8px',
  marginTop: '6px',
  paddingTop: '6px',
  borderTop: `1px dashed ${INK_FAINT}`,
  fontSize: FONT_BODY,
  color: INK_SOFT,
};

const stripCellStyle: React.CSSProperties = {
  display: 'inline-flex',
  alignItems: 'center',
  gap: '3px',
};

const stripValueStyle: React.CSSProperties = {
  color: INK,
  fontWeight: 'bold',
};

const StockpileStrip = (props: { row: MarketRow }) => {
  const { act, data } = useBackend<Data>();
  const { row } = props;
  const goodId = row.good_id;
  const goodName = data.good_catalog[goodId]?.name ?? goodId;
  const cannotSell = !!row.never_supplied || row.stock <= 0;
  const cannotBuy = !!row.never_supplied || !!row.sold_out;

  const sellToMarket = () => {
    if (cannotSell) return;
    const raw = window.prompt(
      `Sell how many ${goodName} to the market? Royal stock: ${row.stock}.`,
      '1',
    );
    if (raw === null) return;
    const n = parseInt(raw, 10);
    if (Number.isNaN(n) || n <= 0) return;
    act('sell_to_market', { good_id: goodId, quantity: n });
  };

  const buyFromMarket = () => {
    if (cannotBuy) return;
    const raw = window.prompt(
      `Buy how many ${goodName} from the market? The Treasury pays.`,
      '1',
    );
    if (raw === null) return;
    const n = parseInt(raw, 10);
    if (Number.isNaN(n) || n <= 0) return;
    act('buy_from_market', { good_id: goodId, quantity: n });
  };

  return (
    <div style={stripStyle}>
      <span style={stripCellStyle}>
        Market:{' '}
        <span style={stripValueStyle}>
          {row.market_label} {row.market_stock}/{row.market_target}
        </span>
      </span>
      <span style={stripCellStyle}>
        Buy:{' '}
        <span style={stripValueStyle}>{formatMammon(row.market_buy)}m</span>
      </span>
      <span style={stripCellStyle}>
        Sell:{' '}
        <span style={stripValueStyle}>{formatMammon(row.market_sell)}m</span>
      </span>
      <button
        type="button"
        style={inkButtonStyle({ color: SEAL_GREEN, disabled: cannotSell })}
        disabled={cannotSell}
        onClick={sellToMarket}
        title={
          row.never_supplied
            ? 'The market does not take this good.'
            : `Sell royal stock to the market. The first sells for ${formatMammon(row.market_sell)}m, and the price falls as the market fills.`
        }
      >
        Sell to Market
      </button>
      <button
        type="button"
        style={inkButtonStyle({ color: SEAL_BLUE, disabled: cannotBuy })}
        disabled={cannotBuy}
        onClick={buyFromMarket}
        title={
          row.never_supplied
            ? 'The market does not supply this good.'
            : row.sold_out
              ? 'The market is out of this good.'
              : `Buy from the market into royal stock, paid by the Treasury. The first costs ${formatMammon(row.market_buy)}m, and the price rises as the market empties.`
        }
      >
        Buy from Market
      </button>
    </div>
  );
};
