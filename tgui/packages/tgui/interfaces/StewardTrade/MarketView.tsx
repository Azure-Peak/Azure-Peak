import { useState } from 'react';

import { useBackend } from '../../backend';
import { DawnForecast } from '../common/DawnForecast';
import { MarketBand } from '../common/MarketBand';
import { MinutesLeft } from '../common/MinutesLeft';
import {
  cardStyle,
  compactButtonStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  SEAL_BLUE,
  SEAL_GREEN,
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
      <MarketDae data={props.data} />
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
                return (
                  <div key={row.good_id} style={cardStyle}>
                    <div style={{ marginBottom: '4px' }}>
                      <span style={{ fontWeight: 'bold' }}>{name}</span>
                      <span
                        style={{
                          color: INK_SOFT,
                          marginLeft: '8px',
                          fontSize: FONT_BODY,
                        }}
                      >
                        Royal stock:{' '}
                        <span style={{ color: INK, fontWeight: 'bold' }}>
                          {row.stock}
                        </span>
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

const MarketDae = (props: { data: Data }) => {
  const { act } = useBackend<Data>();
  const {
    market_dae: dae,
    rental_pay,
    rental_rate,
    market_day_base_rate,
    market_day_floor,
    is_steward_role,
  } = props.data;
  const midday = dae.rate - 100;
  const tradeHover = `Every dae, traders will come in and replenish stock toward the target, or remove excessive stock and move it toward the market target. A minimum of ${market_day_floor}% movement will be done, but otherwise, ${market_day_base_rate}% of the gap between the target and the current stock will be adjusted. Every rented caravan increases this by ${rental_rate}%, and if it exceeds 100%, then there will be a midday trade too.`;
  const rentBlocker = !is_steward_role
    ? 'Only Crown officials can rent out caravans.'
    : dae.rent_blocker;
  const returnBlocker = !is_steward_role
    ? 'Only Crown officials can take back caravans.'
    : dae.returnable <= 0
      ? dae.rented > 0
        ? "A caravan rented today can't be taken back before dawn."
        : 'No caravans are rented.'
      : '';
  return (
    <div>
      <div style={sectionHeaderStyle}>Market Dae</div>
      <div style={{ color: INK, marginBottom: '4px' }}>
        Next market dae in <MinutesLeft seconds={dae.next_seconds} />.{' '}
        <span title={tradeHover} style={{ cursor: 'help' }}>
          Trade {dae.rate}%
          {midday > 0 ? `, then ${midday}% more at midday` : ''}.
        </span>
        {dae.midday_rate > 0 &&
          ` A ${dae.midday_rate}% midday trade is due today.`}
      </div>
      <div
        style={{
          display: 'flex',
          flexWrap: 'wrap',
          alignItems: 'baseline',
          gap: '4px 12px',
          color: INK_SOFT,
        }}
      >
        <span>
          {dae.rented} caravan{dae.rented === 1 ? '' : 's'} rented, paying{' '}
          {formatMammon(dae.rented * rental_pay)}m at dawn.
        </span>
        <span style={{ display: 'flex', gap: '4px', marginLeft: 'auto' }}>
          <button
            type="button"
            disabled={!!rentBlocker}
            title={
              rentBlocker ||
              `${rental_pay}m at each dawn and +${rental_rate}% trade. It stays out until taken back, at least until dawn.`
            }
            onClick={() => act('rent_caravan')}
            style={compactButtonStyle({ disabled: !!rentBlocker })}
          >
            Rent out
          </button>
          <button
            type="button"
            disabled={!!returnBlocker}
            title={returnBlocker || undefined}
            onClick={() => act('return_rental')}
            style={compactButtonStyle({ disabled: !!returnBlocker })}
          >
            Take back
          </button>
        </span>
      </div>
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
      `Buy how many ${goodName} from the market? ${row.market_left} left before it is out of stock. This is paid from the treasury.`,
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
        Market: <MarketBand label={row.market_label} />
        <span style={stripValueStyle}>
          {row.market_stock}/{row.market_target}
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
      <DawnForecast row={row} />
      <button
        type="button"
        style={inkButtonStyle({ color: SEAL_GREEN, disabled: cannotSell })}
        disabled={cannotSell}
        onClick={sellToMarket}
        title={
          row.never_supplied
            ? 'The market is closed.'
            : `Sell royal stock to the market. The first sells for ${formatMammon(row.market_sell)}m.`
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
            ? 'The market is closed.'
            : row.sold_out
              ? 'The market is out of stock.'
              : `Buy from the market into royal stock, paid by the Treasury. The first costs ${formatMammon(row.market_buy)}m.`
        }
      >
        Buy from Market
      </button>
    </div>
  );
};
