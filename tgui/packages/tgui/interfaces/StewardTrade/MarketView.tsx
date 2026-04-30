import { useState } from 'react';

import { useBackend } from '../../backend';
import { groupByCategory } from './helpers';
import type { Data, MarketRegionOption, MarketRow } from './types';
import {
  badgeStyle,
  cardStyle,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  SEAL_AMBER,
  SEAL_BLUE,
  SEAL_GREEN,
  SEAL_RED,
  sectionHeaderStyle,
  subTabBarStyle,
  subTabStyle,
} from '../common/parchment';

type Side = 'import' | 'export';

type OnTrade = (req: {
  side: Side;
  regionId: string;
  goodId: string;
}) => void;

const promptNumber = (label: string, current: number): number | null => {
  const raw = window.prompt(label, String(current));
  if (raw === null) return null;
  const n = parseInt(raw, 10);
  if (isNaN(n) || n < 0) return null;
  return n;
};

const promptMultiplier = (label: string): number | null => {
  const raw = window.prompt(label, '1.0');
  if (raw === null) return null;
  const n = parseFloat(raw);
  if (isNaN(n) || n <= 0) return null;
  return n;
};

// ── Market view ──────────────────────────────────────────────────
export const MarketView = (props: { data: Data; onTrade: OnTrade }) => {
  const { act } = useBackend<Data>();
  const {
    market_rows,
    good_catalog,
    total_arbitrage_potential,
    autoexport_percentage,
  } = props.data;
  const { onTrade } = props;

  const groups = groupByCategory(market_rows, good_catalog);
  const [activeCategory, setActiveCategory] = useState<string>(
    groups[0]?.category ?? '',
  );
  const [expanded, setExpanded] = useState<Set<string>>(new Set());

  // If the selected category disappears (e.g. good toggled off mid-session), fall back.
  const activeGroup =
    groups.find((g) => g.category === activeCategory) ?? groups[0];

  const toggleExpanded = (key: string) => {
    setExpanded((prev) => {
      const next = new Set(prev);
      if (next.has(key)) next.delete(key);
      else next.add(key);
      return next;
    });
  };

  return (
    <div>
      <div style={sectionHeaderStyle}>
        Market &middot; auto-routed to best region
      </div>
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          gap: '12px',
          marginBottom: '6px',
          fontSize: '12px',
        }}
      >
        <div style={{ color: INK_SOFT, fontStyle: 'italic' }}>
          Crown spread on held stockpile:{' '}
          <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
            {total_arbitrage_potential}m
          </span>{' '}
          potential at current prices
        </div>
        <div style={{ display: 'flex', gap: '6px' }}>
          <button
            type="button"
            style={inkButtonStyle({ color: SEAL_AMBER })}
            onClick={() => {
              const raw = window.prompt(
                'Surplus threshold (0-100%). Stock above (limit × threshold) is "surplus" - the daily Crown sweep and the Export Surplus button move that excess to the highest-paying region, capped at that region\'s daily demand. Lower = more aggressive export.',
                String(autoexport_percentage),
              );
              if (raw === null) return;
              const n = parseInt(raw, 10);
              if (isNaN(n) || n < 0 || n > 100) return;
              act('set_autoexport_percentage', { pct: n });
            }}
            title={`Surplus threshold: ${autoexport_percentage}%. Click to change.`}
          >
            Threshold {autoexport_percentage}%
          </button>
          <button
            type="button"
            style={inkButtonStyle({ color: SEAL_GREEN })}
            onClick={() => act('export_surplus_all')}
            title="Export every auto-priced entry's stock above the threshold to its best-paying region, capped at remaining daily demand. Manual-priced entries are skipped."
          >
            Export Surplus
          </button>
          <button
            type="button"
            style={inkButtonStyle({ color: INK })}
            onClick={() => act('autoprice_all')}
            title="Reset every stockpile entry to automatic pricing (snaps to current market, ratchets engaged)."
          >
            Auto-Price All
          </button>
          <button
            type="button"
            style={inkButtonStyle({ color: INK })}
            onClick={() => act('autolimit_all')}
            title="Recompute every stockpile cap from total demand × pop × 2 days."
          >
            Auto-Limit All
          </button>
          <button
            type="button"
            style={inkButtonStyle({ color: SEAL_BLUE })}
            onClick={() => {
              const m = promptMultiplier(
                'Multiply ALL buy prices by (e.g. 0.8 to slash bid 20%). Sets each entry to manual.',
              );
              if (m !== null) act('multiply_all_buy', { multiplier: m });
            }}
            title="Bulk-multiply every buy price (Crown's bid). Flips affected entries to manual."
          >
            Buy ×
          </button>
          <button
            type="button"
            style={inkButtonStyle({ color: SEAL_GREEN })}
            onClick={() => {
              const m = promptMultiplier(
                'Multiply ALL sell prices by (e.g. 0.8 to discount ask 20%). Sets each entry to manual.',
              );
              if (m !== null) act('multiply_all_sell', { multiplier: m });
            }}
            title="Bulk-multiply every sell price (Crown's ask). Flips affected entries to manual."
          >
            Sell ×
          </button>
        </div>
      </div>
      {market_rows.length === 0 ? (
        <div style={{ textAlign: 'center', fontStyle: 'italic', color: INK_SOFT }}>
          No goods accepted at present.
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
              <div
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'flex-end',
                  gap: '6px',
                  marginBottom: '6px',
                  fontSize: '11px',
                  color: INK_SOFT,
                }}
              >
                <span style={{ fontStyle: 'italic' }}>
                  {activeGroup.label}:
                </span>
                <button
                  type="button"
                  style={inkButtonStyle({ color: SEAL_GREEN })}
                  onClick={() =>
                    act('export_surplus_category', {
                      category: activeGroup.category,
                    })
                  }
                  title={`Export ${activeGroup.label} surplus (stock over threshold) to best-paying regions.`}
                >
                  Export Surplus
                </button>
                <button
                  type="button"
                  style={inkButtonStyle({ color: INK })}
                  onClick={() =>
                    act('autoprice_category', { category: activeGroup.category })
                  }
                  title={`Reset all ${activeGroup.label} entries to automatic pricing.`}
                >
                  Auto-Price
                </button>
                <button
                  type="button"
                  style={inkButtonStyle({ color: INK })}
                  onClick={() =>
                    act('autolimit_category', { category: activeGroup.category })
                  }
                  title={`Recompute all ${activeGroup.label} stockpile caps from demand.`}
                >
                  Auto-Limit
                </button>
                <button
                  type="button"
                  style={inkButtonStyle({ color: SEAL_BLUE })}
                  onClick={() => {
                    const m = promptMultiplier(
                      `Multiply ${activeGroup.label} buy prices by (e.g. 0.8 to slash bid 20%). Sets each to manual.`,
                    );
                    if (m !== null)
                      act('multiply_category_buy', {
                        category: activeGroup.category,
                        multiplier: m,
                      });
                  }}
                  title={`Bulk-multiply ${activeGroup.label} buy prices. Flips affected entries to manual.`}
                >
                  Buy ×
                </button>
                <button
                  type="button"
                  style={inkButtonStyle({ color: SEAL_GREEN })}
                  onClick={() => {
                    const m = promptMultiplier(
                      `Multiply ${activeGroup.label} sell prices by (e.g. 0.8 to discount ask 20%). Sets each to manual.`,
                    );
                    if (m !== null)
                      act('multiply_category_sell', {
                        category: activeGroup.category,
                        multiplier: m,
                      });
                  }}
                  title={`Bulk-multiply ${activeGroup.label} sell prices. Flips affected entries to manual.`}
                >
                  Sell ×
                </button>
                <button
                  type="button"
                  style={inkButtonStyle({ color: SEAL_GREEN })}
                  onClick={() =>
                    act('accept_category', { category: activeGroup.category })
                  }
                  title={`Accept deposits for all ${activeGroup.label}.`}
                >
                  Open All
                </button>
                <button
                  type="button"
                  style={inkButtonStyle({ color: SEAL_RED })}
                  onClick={() =>
                    act('reject_category', { category: activeGroup.category })
                  }
                  title={`Reject deposits for all ${activeGroup.label}.`}
                >
                  Close All
                </button>
              </div>
              {activeGroup.rows.map((row) => {
                const good = good_catalog[row.good_id];
                const name = good?.name ?? row.good_id;
                const importable = !!good?.importable;
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
                        <span style={badgeStyle(eventColor)}>{row.event_tag}</span>
                      )}
                      <span style={{ color: INK_FAINT, marginLeft: '8px', fontSize: '11px' }}>
                        Stock: {row.stock}/{row.stock_limit}
                      </span>
                    </div>
                    <SideBlock
                      side="import"
                      label="Buy"
                      color={SEAL_BLUE}
                      regions={row.import_regions}
                      unavailableLabel={
                        importable ? 'no producing region' : 'not importable'
                      }
                      goodId={row.good_id}
                      expanded={expanded.has(`${row.good_id}-import`)}
                      onToggle={() => toggleExpanded(`${row.good_id}-import`)}
                      onTrade={onTrade}
                    />
                    <SideBlock
                      side="export"
                      label="Sell"
                      color={SEAL_GREEN}
                      regions={row.export_regions}
                      unavailableLabel="no demanding region"
                      goodId={row.good_id}
                      expanded={expanded.has(`${row.good_id}-export`)}
                      onToggle={() => toggleExpanded(`${row.good_id}-export`)}
                      onTrade={onTrade}
                    />
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

// ── Per-side block (buy or sell) ─────────────────────────────────
const SideBlock = (props: {
  side: Side;
  label: string;
  color: string;
  regions: MarketRegionOption[];
  unavailableLabel: string;
  goodId: string;
  expanded: boolean;
  onToggle: () => void;
  onTrade: OnTrade;
}) => {
  const {
    side,
    label,
    color,
    regions,
    unavailableLabel,
    goodId,
    expanded,
    onToggle,
    onTrade,
  } = props;

  if (regions.length === 0) {
    return (
      <div style={sideLineStyle}>
        <span style={{ color: INK_FAINT, fontVariant: 'small-caps', width: '34px' }}>
          {label}:
        </span>
        <span style={{ fontStyle: 'italic', color: INK_FAINT, marginLeft: '6px' }}>
          {unavailableLabel}
        </span>
      </div>
    );
  }

  const best = regions[0];
  const others = regions.slice(1);

  return (
    <>
      <div style={sideLineStyle}>
        <span style={{ color: INK_FAINT, fontVariant: 'small-caps', width: '34px' }}>
          {label}:
        </span>
        <RegionRow
          side={side}
          color={color}
          region={best}
          goodId={goodId}
          isPrimary
          onTrade={onTrade}
        />
        <span style={{ color: INK_FAINT, fontSize: '11px', marginLeft: '8px' }}>
          ({regions.length} region{regions.length === 1 ? '' : 's'})
        </span>
        {others.length > 0 && (
          <button
            type="button"
            style={chevronStyle}
            onClick={onToggle}
            title={expanded ? 'Hide other regions' : 'Show other regions'}
          >
            {expanded ? '▲' : '▼'}
          </button>
        )}
      </div>
      {expanded &&
        others.map((r) => (
          <div key={r.region_id} style={{ ...sideLineStyle, marginLeft: '40px' }}>
            <RegionRow
              side={side}
              color={color}
              region={r}
              goodId={goodId}
              isPrimary={false}
              onTrade={onTrade}
            />
          </div>
        ))}
    </>
  );
};

// ── One region line (used for primary + expanded entries) ────────
const RegionRow = (props: {
  side: Side;
  color: string;
  region: MarketRegionOption;
  goodId: string;
  isPrimary: boolean;
  onTrade: OnTrade;
}) => {
  const { data } = useBackend<Data>();
  const { region_catalog } = data;
  const { side, color, region, goodId, onTrade } = props;
  const regionName = region_catalog[region.region_id]?.name ?? region.region_id;
  const saturated = region.capacity_today <= 0;
  const actionLabel = side === 'import' ? 'Import' : 'Export';
  const capacityColor = saturated
    ? INK_FAINT
    : side === 'import'
      ? SEAL_BLUE
      : SEAL_GREEN;
  return (
    <span style={{ display: 'flex', alignItems: 'center', gap: '4px', flexWrap: 'wrap' }}>
      <span>
        {regionName} @{' '}
        <span style={{ color: SEAL_AMBER }}>{region.unit_price}m/u</span>
        {region.capacity_total > 0 && (
          <span
            title={
              side === 'import'
                ? 'Units available today at this price. Buying beyond exhausts daily production and the price climbs.'
                : 'Units the buyer still wants today at this price. Selling beyond saturates demand and the price drops.'
            }
            style={{
              color: capacityColor,
              marginLeft: '4px',
              fontSize: '11px',
            }}
          >
            [{region.capacity_today}/{region.capacity_total}]
          </span>
        )}
      </span>
      {!!region.is_blockaded && <span style={badgeStyle(SEAL_RED)}>BLOCKADED</span>}
      {saturated && (
        <span style={badgeStyle(INK_FAINT)} title="No remaining capacity today - oversupply decay applies.">
          SATURATED
        </span>
      )}
      <button
        type="button"
        style={inkButtonStyle({ color })}
        onClick={() =>
          onTrade({
            side,
            regionId: region.region_id,
            goodId,
          })
        }
      >
        {actionLabel}
      </button>
    </span>
  );
};

const sideLineStyle = {
  display: 'flex',
  flexWrap: 'wrap' as const,
  alignItems: 'center',
  fontSize: '12px',
  marginBottom: '3px',
};

const chevronStyle = {
  fontFamily: 'inherit',
  fontSize: '12px',
  padding: '1px 6px',
  marginLeft: '6px',
  border: `1px solid ${INK_FAINT}`,
  background: 'rgba(255,248,220,0.5)',
  color: INK_SOFT,
  cursor: 'pointer',
  borderRadius: '2px',
};

// ── Stockpile management strip (Steward-only controls; visible to Alderman) ──
const stripStyle: React.CSSProperties = {
  display: 'flex',
  flexWrap: 'wrap',
  alignItems: 'center',
  gap: '8px',
  marginTop: '6px',
  paddingTop: '6px',
  borderTop: `1px dashed ${INK_FAINT}`,
  fontSize: '11px',
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

const stripValueButtonStyle: React.CSSProperties = {
  ...stripValueStyle,
  background: 'transparent',
  border: 'none',
  padding: '0 2px',
  cursor: 'pointer',
  textDecoration: 'underline dotted',
  fontFamily: 'inherit',
  fontSize: '11px',
};

const flagPillStyle = (active: boolean): React.CSSProperties => ({
  fontSize: '9px',
  fontVariant: 'small-caps',
  letterSpacing: '1px',
  padding: '0 4px',
  border: `1px solid ${active ? SEAL_GREEN : INK_FAINT}`,
  color: active ? SEAL_GREEN : INK_FAINT,
  borderRadius: '2px',
  cursor: 'pointer',
  background: 'transparent',
  fontFamily: 'inherit',
});

const StockpileStrip = (props: { row: MarketRow }) => {
  const { act } = useBackend<Data>();
  const { row } = props;
  const goodId = row.good_id;
  const isAuto = !!row.automatic_price;
  const limitAuto = !!row.automatic_limit;
  const accepting = !!row.accepting;
  const withdrawDisabled = !!row.withdraw_disabled;
  const margin = row.margin_per_unit;
  const potential = row.arbitrage_potential;

  const editBuy = () => {
    const n = promptNumber(`Set buy price for ${goodId}`, row.buy_price);
    if (n !== null) act('set_buy_price', { good_id: goodId, price: n });
  };
  const editSell = () => {
    const n = promptNumber(`Set sell price for ${goodId}`, row.sell_price);
    if (n !== null) act('set_sell_price', { good_id: goodId, price: n });
  };
  const editLimit = () => {
    const n = promptNumber(`Set stockpile limit for ${goodId}`, row.stock_limit);
    if (n !== null) act('set_stockpile_limit', { good_id: goodId, limit: n });
  };

  return (
    <div style={stripStyle}>
      <span style={stripCellStyle}>
        Buy:{' '}
        <button type="button" style={stripValueButtonStyle} onClick={editBuy}>
          {row.buy_price}m
        </button>
        <button
          type="button"
          style={flagPillStyle(isAuto)}
          onClick={() => act('toggle_auto_price', { good_id: goodId })}
          title={
            isAuto
              ? 'Automatic — deposit ratchets up only, withdraw ratchets down only.'
              : 'Manual — Steward set this price by hand.'
          }
        >
          {isAuto ? 'Auto' : 'Manual'}
        </button>
      </span>
      <span style={stripCellStyle}>
        Sell:{' '}
        <button type="button" style={stripValueButtonStyle} onClick={editSell}>
          {row.sell_price}m
        </button>
      </span>
      <span style={stripCellStyle}>
        Limit:{' '}
        <button type="button" style={stripValueButtonStyle} onClick={editLimit}>
          {row.stock_limit}
        </button>
        <button
          type="button"
          style={flagPillStyle(limitAuto)}
          onClick={() => act('toggle_auto_limit', { good_id: goodId })}
          title={
            limitAuto
              ? 'Automatic — total demand × pop × 2 days.'
              : 'Manual — Steward set this cap by hand.'
          }
        >
          {limitAuto ? 'Auto' : 'Manual'}
        </button>
      </span>
      {margin > 0 && (
        <span style={{ ...stripCellStyle, color: SEAL_AMBER }}>
          +{margin}m/u → {potential}m
        </span>
      )}
      <span style={{ flex: 1 }} />
      <button
        type="button"
        style={flagPillStyle(accepting)}
        onClick={() => act('toggle_stockpile_accept', { good_id: goodId })}
        title="Accept player deposits."
      >
        {accepting ? 'Accept' : 'Reject'}
      </button>
      <button
        type="button"
        style={flagPillStyle(!withdrawDisabled)}
        onClick={() => act('toggle_withdraw_disabled', { good_id: goodId })}
        title="Allow player withdraws."
      >
        {withdrawDisabled ? 'No-W' : 'W-OK'}
      </button>
    </div>
  );
};
