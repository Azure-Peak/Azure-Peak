import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  cardStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  PARCHMENT_SHADOW,
  pageStyle,
  rulerStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
  sectionHeaderStyle,
  subTabBarStyle,
  subTabStyle,
  subtitleStyle,
  titleStyle,
} from './common/parchment';
import { DawnForecast, forecastVisible } from './common/DawnForecast';
import { MarketBand } from './common/MarketBand';
import { formatMammon } from './common/format';

type StockRow = {
  ref: string;
  name: string;
  desc: string;
  category: string;
  amount: number;
  limit: number;
  withdraw_price: number;
  deposit_price: number;
  royal_amount: number;
  never_supplied: BooleanLike;
  never_bought: BooleanLike;
  sold_out: BooleanLike;
  next_buy: BuyChange | null;
  next_sell: PriceChange | null;
  segments: MarketSegment[];
  market_label: string;
  event_tag: string;
  shortage_progress: number;
  shortage_target: number;
  shortage_affected: string;
  dawn_change: number;
  raided_supply: number;
  raided_demand: number;
  raided_suppliers: string[];
  raided_demanders: string[];
};

type PriceChange = {
  count: number;
  price: number;
};

type BuyChange = {
  count: number;
  price: number | null;
};

type MarketSegment = {
  label: string;
  from: number;
  to: number | null;
  price: number;
};

type Bounty = {
  name: string;
  payout_price: number;
  percent: BooleanLike;
};

type Data = {
  budget: number;
  compact: BooleanLike;
  categories: string[];
  category: string;
  food_stipend: BooleanLike;
  subsidy_remaining: number;
  wage_reserve: number;
  below_reserve: BooleanLike;
  stocks: StockRow[];
  conditions_count: number;
  bounties: Bounty[];
  no_deposit: BooleanLike;
  export_licence?: { left: number; total: number };
  next_market_day_minutes: number;
  title: string;
  subtitle: string;
};

type ActFn = (action: string, params?: Record<string, unknown>) => void;

const RowSeparator = () => (
  <span style={{ color: INK_FAINT, margin: '0 6px' }}>|</span>
);

const StockRowView = (props: {
  row: StockRow;
  data: Data;
  act: ActFn;
  compact: boolean;
}) => {
  const { row, data, act, compact } = props;
  const noDeposit = !!data.no_deposit;
  const embargoed = !!row.never_supplied;
  const subsidyCovers =
    !!data.food_stipend &&
    data.subsidy_remaining >= row.withdraw_price &&
    (row.royal_amount > 0 || (!row.sold_out && !data.below_reserve));
  const canWithdraw =
    !embargoed &&
    ((!row.sold_out && row.withdraw_price <= data.budget) || subsidyCovers);
  const subsidyUnits = Math.min(
    Math.floor(
      Math.round(data.subsidy_remaining * 100) /
        Math.round(row.withdraw_price * 100),
    ),
    row.royal_amount > 0 ? row.royal_amount : (row.next_buy?.count ?? 1),
  );
  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'center',
        flexWrap: 'wrap',
        gap: '6px',
        padding: '2px 6px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontFamily: SERIF,
        fontSize: FONT_BODY,
      }}
    >
      <div style={{ flex: '1 1 200px', minWidth: 0 }}>
        <span style={{ color: INK, fontWeight: 'bold' }}>{row.name}</span>
        <RowSeparator />
        <MarketBand label={row.market_label} />
        <span style={{ color: INK_SOFT, marginLeft: '4px' }}>
          {row.amount}/{row.limit}
        </span>
        {forecastVisible(row) && <RowSeparator />}
        <DawnForecast row={row} flush />
        {row.event_tag === 'SHORTAGE' && row.shortage_target > 0 && (
          <span
            style={{
              color: SEAL_RED,
              fontWeight: 'bold',
              fontSize: FONT_BODY,
              marginLeft: '6px',
              padding: '0 4px',
              border: `1px solid ${SEAL_RED}`,
              borderRadius: '2px',
            }}
            title="Ends once enough is sold to the market."
          >
            RELIEF: {formatMammon(Math.round(row.shortage_progress))} /{' '}
            {formatMammon(Math.round(row.shortage_target))}m
          </span>
        )}
        {!compact && row.desc && (
          <span
            style={{
              color: INK_SOFT,
              fontSize: FONT_BODY,
              marginLeft: '6px',
            }}
          >
            - {row.desc}
          </span>
        )}
      </div>
      <div
        style={{
          flex: noDeposit ? '0 0 96px' : '0 0 190px',
          display: 'flex',
          gap: '4px',
          justifyContent: 'flex-end',
          alignItems: 'center',
        }}
      >
        {!noDeposit && (
          <span
            style={{
              display: 'inline-block',
              fontFamily: SERIF,
              fontSize: FONT_BODY,
              fontWeight: 'bold',
              padding: '1px 8px',
              color: SEAL_AMBER,
              background: 'transparent',
              border: `1px dashed ${SEAL_AMBER}`,
              borderRadius: '2px',
              width: '90px',
              textAlign: 'center',
              boxSizing: 'border-box',
            }}
            title={
              !row.never_bought && row.next_sell
                ? `Next ${row.next_sell.count} at ${formatMammon(row.deposit_price)}m. After that, ${formatMammon(row.next_sell.price)}m.`
                : undefined
            }
          >
            {row.never_bought
              ? 'Closed'
              : `Sell ${formatMammon(row.deposit_price)}m`}
          </span>
        )}
        <button
          type="button"
          style={{
            ...inkButtonStyle({ disabled: !canWithdraw }),
            width: '90px',
            textAlign: 'center',
            boxSizing: 'border-box',
          }}
          disabled={!canWithdraw}
          onClick={() => act('withdraw', { ref: row.ref })}
          title={
            subsidyCovers
              ? `Next ${subsidyUnits} at ${formatMammon(row.withdraw_price)}m. Paid from royal subsidy.`
              : row.next_buy
                ? row.next_buy.price === null
                  ? `Last ${row.next_buy.count} at ${formatMammon(row.withdraw_price)}m.`
                  : `Next ${row.next_buy.count} at ${formatMammon(row.withdraw_price)}m. After that, ${formatMammon(row.next_buy.price)}m.`
                : 'The market is out of stock.'
          }
        >
          {embargoed
            ? 'Closed'
            : row.sold_out
              ? 'Out of stock'
              : `Buy ${formatMammon(row.withdraw_price)}m`}
        </button>
      </div>
      {!compact && <MarketBar row={row} />}
    </div>
  );
};

const MarketBar = (props: { row: StockRow }) => {
  const { row } = props;
  const segments = row.segments || [];
  if (!segments.length) {
    return null;
  }
  const first = segments[0];
  const last = segments[segments.length - 1];
  const tail = Math.max(2, Math.round(last.from * 0.25));
  const span = last.from - first.from + tail;
  const width = (seg: MarketSegment) =>
    ((seg.to === null ? tail : seg.to - seg.from + 1) / span) * 100;
  const marker =
    (Math.min(Math.max(row.amount - first.from, 0), span) / span) * 100;
  return (
    <div
      style={{
        flex: '1 0 100%',
        position: 'relative',
        display: 'flex',
        height: '6px',
        margin: '2px 0 4px',
      }}
    >
      {segments.map((seg, i) => {
        const current =
          row.amount >= seg.from && (seg.to === null || row.amount <= seg.to);
        const color =
          i < 3 ? SEAL_RED : i === 3 ? INK_FAINT : SEAL_GREEN;
        return (
          <div
            key={seg.label}
            title={`${seg.label}: ${seg.from}${seg.to === null ? '+' : ` to ${seg.to}`} in stock, buy ${formatMammon(seg.price)}m`}
            style={{
              width: `${width(seg)}%`,
              background: color,
              opacity: current ? 0.9 : 0.35,
              borderRight: `1px solid ${PARCHMENT_SHADOW}`,
              boxSizing: 'border-box',
            }}
          />
        );
      })}
      <div
        style={{
          position: 'absolute',
          left: `${marker}%`,
          top: '-2px',
          width: '2px',
          height: '10px',
          background: INK,
        }}
      />
    </div>
  );
};

const CONDITIONS_KEY = '__conditions__';

export const Stockpile = () => {
  const { act, data } = useBackend<Data>();
  const compact = !!data.compact;
  const conditionsCount = data.conditions_count;
  const isConditionsTab = data.category === CONDITIONS_KEY;
  const rows = data.stocks;
  const noDeposit = !!data.no_deposit;
  return (
    <Window width={780} height={720} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>{data.title || 'Town Stockpile'}</div>
          <div style={subtitleStyle}>
            {data.subtitle ||
              'Drop goods at the machine to sell them. Put coins in to buy.'}
          </div>
          <div style={rulerStyle} />

          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '8px',
              padding: '4px 8px',
              borderBottom: `1px solid ${PARCHMENT_SHADOW}`,
              fontFamily: SERIF,
              fontSize: FONT_BODY,
              marginBottom: '6px',
              flexWrap: 'wrap',
            }}
          >
            <span style={{ color: SEAL_AMBER }}>Coinpouch</span>
            <span
              style={{
                color: data.budget > 0 ? INK : INK_FAINT,
                fontWeight: 'bold',
              }}
            >
              {formatMammon(data.budget)}m
            </span>
            {!!data.food_stipend && (
              <span
                style={{ color: SEAL_GREEN }}
                title={`Roles with royal subsidy will pull from the royal stockpile, and then buy from the market using treasury money if the royal stock is empty, so long as there's enough fund above tomorrow's wages (${formatMammon(data.wage_reserve)}m) to cover the cost. Selling goods will go directly into the royal stockpile instead of the market`}
              >
                Royal Subsidy {formatMammon(data.subsidy_remaining)}m
              </span>
            )}
            {!!data.food_stipend && !!data.below_reserve && (
              <span style={{ color: SEAL_RED }}>The Crown is broke</span>
            )}
            <span
              style={{ color: INK_SOFT }}
              title="Every dae traders will arrive and adjust the stocks and price toward the norm, according to regional supply and demand. This will only apply on non-blockaded region"
            >
              Next market dae in {data.next_market_day_minutes}{' '}
              {data.next_market_day_minutes === 1 ? 'minute' : 'minutes'}
            </span>
            <div style={{ marginLeft: 'auto', display: 'flex', gap: '4px' }}>
              <button
                type="button"
                style={inkButtonStyle({ disabled: data.budget <= 0 })}
                disabled={data.budget <= 0}
                onClick={() => act('refund_budget')}
              >
                Refund
              </button>
              <button
                type="button"
                style={inkButtonStyle()}
                onClick={() => act('toggle_compact')}
              >
                {compact ? 'Detailed' : 'Compact'}
              </button>
            </div>
          </div>

          <div style={subTabBarStyle}>
            <div
              style={subTabStyle(isConditionsTab)}
              onClick={() => act('set_category', { category: CONDITIONS_KEY })}
            >
              Conditions {conditionsCount > 0 && `(${conditionsCount})`}
            </div>
            {data.categories.map((c) => (
              <div
                key={c}
                style={subTabStyle(c === data.category)}
                onClick={() => act('set_category', { category: c })}
              >
                {c}
              </div>
            ))}
          </div>

          <div style={sectionHeaderStyle}>
            {isConditionsTab
              ? `Market Conditions (${rows.length})`
              : `${data.category} (${rows.length})`}
          </div>
          <div
            style={{
              fontStyle: 'italic',
              color: INK_SOFT,
              fontSize: FONT_BODY,
              padding: '2px 8px 6px',
            }}
          >
            {data.export_licence ? (
              <>
                The ATC holds a monopoly on re-export of town goods. Export
                License: {formatMammon(data.export_licence.left)}m out of{' '}
                {formatMammon(data.export_licence.total)}m left todae.
              </>
            ) : (
              <>
                Goods sold from the market CANNOT be re-exported at the
                Navigator, the Black Market or the ship crates due to the law
                against cabotage.
              </>
            )}
          </div>
          {rows.length === 0 ? (
            <div
              style={{
                ...cardStyle,
                textAlign: 'center',
                fontStyle: 'italic',
                color: INK_SOFT,
              }}
            >
              No stock in this category.
            </div>
          ) : (
            rows.map((row) => (
              <StockRowView
                key={row.ref}
                row={row}
                data={data}
                act={act}
                compact={compact}
              />
            ))
          )}

          {!noDeposit && data.bounties.length > 0 && (
            <>
              <div style={{ ...sectionHeaderStyle, marginTop: '16px' }}>
                Prices Paid
              </div>
              {data.bounties.map((b) => (
                <div
                  key={b.name}
                  style={{
                    display: 'flex',
                    gap: '8px',
                    padding: '4px 8px',
                    borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
                    fontFamily: SERIF,
                    fontSize: FONT_BODY,
                  }}
                >
                  <span style={{ flex: 1, color: INK }}>{b.name}</span>
                  <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
                    {b.payout_price}
                    {b.percent ? '%' : 'm'}
                  </span>
                </div>
              ))}
            </>
          )}
        </div>
      </Window.Content>
    </Window>
  );
};
