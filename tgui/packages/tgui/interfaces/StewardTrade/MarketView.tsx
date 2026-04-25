import { useState } from 'react';

import { useBackend } from '../../backend';
import { groupByCategory } from './helpers';
import type { Data, MarketRegionOption } from './types';
import {
  badgeStyle,
  cardStyle,
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

// ── Market view ──────────────────────────────────────────────────
export const MarketView = (props: { data: Data; onTrade: OnTrade }) => {
  const { market_rows, good_catalog } = props.data;
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
