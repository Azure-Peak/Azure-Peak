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
  sold_out: BooleanLike;
  next_buy: PriceChange | null;
  next_sell: PriceChange | null;
  segments: MarketSegment[];
  market_label: string;
  event_tag: string;
  shortage_progress: number;
  shortage_target: number;
  shortage_affected: string;
};

type PriceChange = {
  count: number;
  price: number;
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
  treasury_floor: number;
  below_floor: BooleanLike;
  stocks: StockRow[];
  bounties: Bounty[];
  no_deposit: BooleanLike;
  next_market_day_minutes: number;
  title: string;
  subtitle: string;
};

type ActFn = (action: string, params?: Record<string, unknown>) => void;

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
    (row.royal_amount > 0 || (!row.sold_out && !data.below_floor));
  const canWithdraw =
    !embargoed &&
    ((!row.sold_out && row.withdraw_price <= data.budget) || subsidyCovers);
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
        <span style={{ color: INK_SOFT, marginLeft: '6px' }}>
          {`${row.market_label} `}
          {row.amount}/{row.limit}
        </span>
        {!!row.event_tag && (
          <span
            style={{
              color: row.event_tag === 'GLUT' ? SEAL_GREEN : SEAL_RED,
              fontWeight: 'bold',
              fontSize: FONT_BODY,
              marginLeft: '6px',
              padding: '0 4px',
              border: `1px solid ${row.event_tag === 'GLUT' ? SEAL_GREEN : SEAL_RED}`,
              borderRadius: '2px',
            }}
            title={
              row.event_tag === 'SHORTAGE' && row.shortage_target > 0
                ? 'Shortage ends once sufficient goods are supplied to the market'
                : undefined
            }
          >
            {row.event_tag}
            {row.event_tag === 'SHORTAGE' && row.shortage_target > 0 && (
              <span style={{ marginLeft: '4px', fontWeight: 'normal' }}>
                ({row.shortage_progress} / {row.shortage_target})
              </span>
            )}
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
              row.next_sell
                ? `The next ${row.next_sell.count} sell for ${formatMammon(row.deposit_price)}m each. After that, ${formatMammon(row.next_sell.price)}m.`
                : 'The price will not fall further.'
            }
          >
            Sell {formatMammon(row.deposit_price)}m
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
              ? `Your royal subsidy pays. ${formatMammon(data.subsidy_remaining)}m of it left today.`
              : row.next_buy
                ? `The next ${row.next_buy.count} cost ${formatMammon(row.withdraw_price)}m each. After that, ${formatMammon(row.next_buy.price)}m.`
                : 'The price will not rise further.'
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
  const last = segments[segments.length - 1];
  const tail = Math.max(2, Math.round(last.from * 0.25));
  const span = last.from + tail;
  const width = (seg: MarketSegment) =>
    ((seg.to === null ? tail : seg.to - seg.from + 1) / span) * 100;
  const marker = (Math.min(Math.max(row.amount, 0), span) / span) * 100;
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
            title={`${seg.label}: ${seg.from}${seg.to === null ? '+' : `-${seg.to}`} in stock, buy ${formatMammon(seg.price)}m`}
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
  const conditionsCount = data.stocks.filter((r) => !!r.event_tag).length;
  const isConditionsTab = data.category === CONDITIONS_KEY;
  const filtered = isConditionsTab
    ? data.stocks.filter((r) => !!r.event_tag)
    : data.stocks.filter((r) => r.category === data.category);
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
                title={`Roles with royal subsidy purchase from the market using treasury fund, so long as there's enough fund above the treasury floor (${formatMammon(data.treasury_floor)}m) to cover the cost. Selling goods will go directly into the royal stockpile instead of the market`}
              >
                Royal Subsidy {formatMammon(data.subsidy_remaining)}m
              </span>
            )}
            {!!data.food_stipend && !!data.below_floor && (
              <span style={{ color: SEAL_RED }}>crown ledger thin</span>
            )}
            <span
              style={{ color: INK_SOFT }}
              title="Every dae other traders will correct the market and adjust the stocks and price toward the norm, according to regional demand and supply. This will only apply on non-blockaded region"
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
              ? `Market Conditions (${filtered.length})`
              : `${data.category} (${filtered.length})`}
          </div>
          {filtered.length === 0 ? (
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
            filtered.map((row) => (
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
