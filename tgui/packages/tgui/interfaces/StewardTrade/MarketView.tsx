import { useState } from 'react';

import { useBackend } from '../../backend';
import {
  BUTTON_BG,
  badgeStyle,
  cardStyle,
  FONT_BODY,
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
import { groupByCategory } from './helpers';
import type { Data, MarketRegionOption, MarketRow } from './types';

type Side = 'import' | 'export';

type OnTrade = (req: { side: Side; regionId: string; goodId: string }) => void;

const promptNumber = (label: string, current: number): number | null => {
  const raw = window.prompt(label, String(current));
  if (raw === null) return null;
  const n = parseInt(raw, 10);
  if (Number.isNaN(n) || n < 0) return null;
  return n;
};

const promptMultiplier = (label: string): number | null => {
  const raw = window.prompt(label, '1.0');
  if (raw === null) return null;
  const n = parseFloat(raw);
  if (Number.isNaN(n) || n <= 0) return null;
  return n;
};

export const MarketView = (props: { data: Data; onTrade: OnTrade }) => {
  const { act } = useBackend<Data>();
  const {
    market_rows,
    good_catalog,
    total_arbitrage_potential,
    autoexport_percentage,
  } = props.data;
  const { onTrade } = props;
  const aldermanActing = !!props.data.is_alderman_acting;
  const aldermanBlockTitle =
    "As Alderman, you can't change this.";

  const groups = groupByCategory(market_rows, good_catalog);
  const [activeCategory, setActiveCategory] = useState<string>(
    groups[0]?.category ?? '',
  );
  const [expanded, setExpanded] = useState<Set<string>>(new Set());

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
      <div style={sectionHeaderStyle}>Market</div>
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          gap: '12px',
          marginBottom: '6px',
          fontSize: FONT_BODY,
        }}
      >
        <div style={{ color: INK_SOFT }}>
          Arbitrage potential:{' '}
          <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
            {total_arbitrage_potential}m
          </span>
        </div>
        <div style={{ display: 'flex', gap: '6px' }}>
          <button
            type="button"
            style={inkButtonStyle({
              color: SEAL_AMBER,
              disabled: aldermanActing,
            })}
            disabled={aldermanActing}
            onClick={() => {
              const raw = window.prompt(
                "Surplus threshold (0-100%). Anything above this share of a good's limit is surplus. It is sold abroad each dawn, or when you press Export Surplus, up to what the best paying region still wants. Lower means more gets sold.",
                String(autoexport_percentage),
              );
              if (raw === null) return;
              const n = parseInt(raw, 10);
              if (Number.isNaN(n) || n < 0 || n > 100) return;
              act('set_autoexport_percentage', { pct: n });
            }}
            title={aldermanActing ? aldermanBlockTitle : undefined}
          >
            Threshold {autoexport_percentage}%
          </button>
          <button
            type="button"
            style={inkButtonStyle({
              color: SEAL_GREEN,
              disabled: aldermanActing,
            })}
            disabled={aldermanActing}
            onClick={() => act('export_surplus_all')}
            title={
              aldermanActing
                ? aldermanBlockTitle
                : "Sell the surplus of every autopriced good to whichever region pays most, up to what it still wants today. Goods you priced by hand are skipped."
            }
          >
            Export Surplus
          </button>
          <button
            type="button"
            style={inkButtonStyle({ color: INK, disabled: aldermanActing })}
            disabled={aldermanActing}
            onClick={() => act('autoprice_all')}
            title={
              aldermanActing
                ? aldermanBlockTitle
                : 'Put every good back on automatic pricing.'
            }
          >
            Autoprice All
          </button>
          <button
            type="button"
            style={inkButtonStyle({ color: INK, disabled: aldermanActing })}
            disabled={aldermanActing}
            onClick={() => act('autolimit_all')}
            title={
              aldermanActing
                ? aldermanBlockTitle
                : `Recompute every stockpile limit from ${props.data.auto_limit_days} days of total demand.`
            }
          >
            Autolimit All
          </button>
          <button
            type="button"
            style={inkButtonStyle({
              color: SEAL_BLUE,
              disabled: aldermanActing,
            })}
            disabled={aldermanActing}
            onClick={() => {
              const m = promptMultiplier(
                'Multiply ALL buy prices. Sets each entry to manual.',
              );
              if (m !== null) act('multiply_all_buy', { multiplier: m });
            }}
            title={
              aldermanActing
                ? aldermanBlockTitle
                : "Multiply all buy prices. Sets each entry to manual."
            }
          >
            Buy ×
          </button>
          <button
            type="button"
            style={inkButtonStyle({
              color: SEAL_GREEN,
              disabled: aldermanActing,
            })}
            disabled={aldermanActing}
            onClick={() => {
              const m = promptMultiplier(
                'Multiply ALL sell prices. Sets each entry to manual.',
              );
              if (m !== null) act('multiply_all_sell', { multiplier: m });
            }}
            title={
              aldermanActing
                ? aldermanBlockTitle
                : "Multiply all sell prices. Sets each entry to manual."
            }
          >
            Sell ×
          </button>
        </div>
      </div>
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
              <div
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'flex-start',
                  gap: '6px',
                  flexWrap: 'wrap',
                  marginBottom: '6px',
                  fontSize: FONT_BODY,
                  color: INK_SOFT,
                }}
              >
                <span>Actions:</span>
                <button
                  type="button"
                  style={inkButtonStyle({
                    color: SEAL_GREEN,
                    disabled: aldermanActing,
                  })}
                  disabled={aldermanActing}
                  onClick={() =>
                    act('export_surplus_category', {
                      category: activeGroup.category,
                    })
                  }
                  title={
                    aldermanActing
                      ? aldermanBlockTitle
                      : `Sell ${activeGroup.label} surplus to whichever regions pay most.`
                  }
                >
                  Export Surplus
                </button>
                <button
                  type="button"
                  style={inkButtonStyle({
                    color: INK,
                    disabled: aldermanActing,
                  })}
                  disabled={aldermanActing}
                  onClick={() =>
                    act('autoprice_category', {
                      category: activeGroup.category,
                    })
                  }
                  title={
                    aldermanActing
                      ? aldermanBlockTitle
                      : `Put all ${activeGroup.label} back on automatic pricing.`
                  }
                >
                  Autoprice
                </button>
                <button
                  type="button"
                  style={inkButtonStyle({
                    color: INK,
                    disabled: aldermanActing,
                  })}
                  disabled={aldermanActing}
                  onClick={() =>
                    act('autolimit_category', {
                      category: activeGroup.category,
                    })
                  }
                  title={
                    aldermanActing
                      ? aldermanBlockTitle
                      : `Set all ${activeGroup.label} limits back to automatic.`
                  }
                >
                  Autolimit
                </button>
                <button
                  type="button"
                  style={inkButtonStyle({
                    color: SEAL_BLUE,
                    disabled: aldermanActing,
                  })}
                  disabled={aldermanActing}
                  onClick={() => {
                    const m = promptMultiplier(
                      `Multiply ${activeGroup.label} buy prices. Sets each to manual.`,
                    );
                    if (m !== null)
                      act('multiply_category_buy', {
                        category: activeGroup.category,
                        multiplier: m,
                      });
                  }}
                  title={
                    aldermanActing
                      ? aldermanBlockTitle
                      : `Multiply ${activeGroup.label} buy prices. Sets each to manual.`
                  }
                >
                  Buy ×
                </button>
                <button
                  type="button"
                  style={inkButtonStyle({
                    color: SEAL_GREEN,
                    disabled: aldermanActing,
                  })}
                  disabled={aldermanActing}
                  onClick={() => {
                    const m = promptMultiplier(
                      `Multiply ${activeGroup.label} sell prices. Sets each to manual.`,
                    );
                    if (m !== null)
                      act('multiply_category_sell', {
                        category: activeGroup.category,
                        multiplier: m,
                      });
                  }}
                  title={
                    aldermanActing
                      ? aldermanBlockTitle
                      : `Multiply ${activeGroup.label} sell prices. Sets each to manual.`
                  }
                >
                  Sell ×
                </button>
              </div>
              <div
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'flex-start',
                  gap: '6px',
                  flexWrap: 'wrap',
                  marginBottom: '6px',
                  fontSize: FONT_BODY,
                  color: INK_SOFT,
                }}
              >
                <span>Permissions:</span>
                <button
                  type="button"
                  style={inkButtonStyle({
                    color: SEAL_GREEN,
                    disabled: aldermanActing,
                  })}
                  disabled={aldermanActing}
                  onClick={() =>
                    act('accept_category', { category: activeGroup.category })
                  }
                  title={
                    aldermanActing
                      ? aldermanBlockTitle
                      : `Accept deposits for all ${activeGroup.label}.`
                  }
                >
                  Open All
                </button>
                <button
                  type="button"
                  style={inkButtonStyle({
                    color: SEAL_RED,
                    disabled: aldermanActing,
                  })}
                  disabled={aldermanActing}
                  onClick={() =>
                    act('reject_category', { category: activeGroup.category })
                  }
                  title={
                    aldermanActing
                      ? aldermanBlockTitle
                      : `Reject deposits for all ${activeGroup.label}.`
                  }
                >
                  Close All
                </button>
                <button
                  type="button"
                  style={inkButtonStyle({
                    color: SEAL_GREEN,
                    disabled: aldermanActing,
                  })}
                  disabled={aldermanActing}
                  onClick={() =>
                    act('allow_withdraw_category', {
                      category: activeGroup.category,
                    })
                  }
                  title={
                    aldermanActing
                      ? aldermanBlockTitle
                      : `Allow withdrawals for all ${activeGroup.label}.`
                  }
                >
                  Withdrawals On
                </button>
                <button
                  type="button"
                  style={inkButtonStyle({
                    color: SEAL_RED,
                    disabled: aldermanActing,
                  })}
                  disabled={aldermanActing}
                  onClick={() =>
                    act('bar_withdraw_category', {
                      category: activeGroup.category,
                    })
                  }
                  title={
                    aldermanActing
                      ? aldermanBlockTitle
                      : `Bar withdrawals for all ${activeGroup.label}.`
                  }
                >
                  Withdrawals Off
                </button>
                <button
                  type="button"
                  style={inkButtonStyle({
                    color: SEAL_GREEN,
                    disabled: aldermanActing,
                  })}
                  disabled={aldermanActing}
                  onClick={() =>
                    act('allow_autoexport_category', {
                      category: activeGroup.category,
                    })
                  }
                  title={
                    aldermanActing
                      ? aldermanBlockTitle
                      : `Let the daily autoexport ship ${activeGroup.label} surplus abroad.`
                  }
                >
                  Autoexport On
                </button>
                <button
                  type="button"
                  style={inkButtonStyle({
                    color: SEAL_RED,
                    disabled: aldermanActing,
                  })}
                  disabled={aldermanActing}
                  onClick={() =>
                    act('bar_autoexport_category', {
                      category: activeGroup.category,
                    })
                  }
                  title={
                    aldermanActing
                      ? aldermanBlockTitle
                      : `Stop autoexporting ${activeGroup.label} surplus.`
                  }
                >
                  Autoexport Off
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
                    <StockpileStrip row={row} aldermanActing={aldermanActing} />
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
        <span style={{ color: INK_FAINT, width: '34px' }}>{label}:</span>
        <span
          style={{ fontStyle: 'italic', color: INK_FAINT, marginLeft: '6px' }}
        >
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
        <span style={{ color: INK_FAINT, width: '34px' }}>{label}:</span>
        <RegionRow
          side={side}
          color={color}
          region={best}
          goodId={goodId}
          isPrimary
          onTrade={onTrade}
        />
        <span
          style={{ color: INK_FAINT, fontSize: FONT_BODY, marginLeft: '8px' }}
        >
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
          <div
            key={r.region_id}
            style={{ ...sideLineStyle, marginLeft: '40px' }}
          >
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
    <span
      style={{
        display: 'flex',
        alignItems: 'center',
        gap: '4px',
        flexWrap: 'wrap',
      }}
    >
      <span>
        {regionName} @{' '}
        <span style={{ color: SEAL_AMBER }}>{region.unit_price}m/u</span>
        {region.capacity_total > 0 && (
          <span
            title={
              side === 'import'
                ? `${region.capacity_today} of ${region.capacity_total} units left today at this price, up to ${region.batch_capacity} per shipment. Buying beyond that increases the price.`
                : `${region.capacity_today} of ${region.capacity_total} units of demand left today at this price, up to ${region.batch_capacity} per shipment. Selling beyond that drops the price.`
            }
            style={{
              color: capacityColor,
              marginLeft: '4px',
              fontSize: FONT_BODY,
            }}
          >
            [{region.capacity_today}/{region.capacity_total}]
          </span>
        )}
      </span>
      {!!region.is_blockaded && (
        <span style={badgeStyle(SEAL_RED)}>BLOCKADED</span>
      )}
      {saturated && (
        <span
          style={badgeStyle(INK_FAINT)}
          title={
            side === 'import'
              ? 'No supply left today. Further purchases cost more.'
              : 'No demand left today. Further sales pay less.'
          }
        >
          {side === 'import' ? 'NO SUPPLY' : 'NO DEMAND'}
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
  fontSize: FONT_BODY,
  marginBottom: '3px',
};

const chevronStyle = {
  fontFamily: 'inherit',
  fontSize: FONT_BODY,
  padding: '1px 6px',
  marginLeft: '6px',
  border: `1px solid ${INK_FAINT}`,
  background: BUTTON_BG,
  color: INK_SOFT,
  cursor: 'pointer',
  borderRadius: '2px',
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

const stripValueButtonStyle: React.CSSProperties = {
  ...stripValueStyle,
  background: 'transparent',
  border: 'none',
  padding: '0 2px',
  cursor: 'pointer',
  textDecoration: 'underline dotted',
  fontFamily: 'inherit',
  fontSize: FONT_BODY,
};

const flagPillStyle = (active: boolean): React.CSSProperties => ({
  fontSize: FONT_BODY,
  padding: '0 4px',
  border: `1px solid ${active ? SEAL_GREEN : INK_FAINT}`,
  color: active ? SEAL_GREEN : INK_FAINT,
  borderRadius: '2px',
  cursor: 'pointer',
  background: 'transparent',
  fontFamily: 'inherit',
});

const StockpileStrip = (props: { row: MarketRow; aldermanActing: boolean }) => {
  const { act, data } = useBackend<Data>();
  const { row, aldermanActing } = props;
  const goodId = row.good_id;
  const goodName = data.good_catalog[goodId]?.name ?? goodId;
  const isAuto = !!row.automatic_price;
  const limitAuto = !!row.automatic_limit;
  const accepting = !!row.accepting;
  const withdrawDisabled = !!row.withdraw_disabled;
  const autoexportDisabled = !!row.autoexport_disabled;
  const margin = row.margin_per_unit;
  const potential = row.arbitrage_potential;
  const blockTitle =
    "As Alderman, you can't change this.";
  const stripStyleEffective: React.CSSProperties = aldermanActing
    ? { ...stripStyle, opacity: 0.55, textDecoration: 'line-through' }
    : stripStyle;
  const valueBtnStyle: React.CSSProperties = aldermanActing
    ? { ...stripValueButtonStyle, cursor: 'not-allowed' }
    : stripValueButtonStyle;

  const editBuy = () => {
    if (aldermanActing) return;
    const n = promptNumber(`Set buy price for ${goodName}`, row.buy_price);
    if (n !== null) act('set_buy_price', { good_id: goodId, price: n });
  };
  const editSell = () => {
    if (aldermanActing) return;
    const n = promptNumber(`Set sell price for ${goodName}`, row.sell_price);
    if (n !== null) act('set_sell_price', { good_id: goodId, price: n });
  };
  const editLimit = () => {
    if (aldermanActing) return;
    const n = promptNumber(
      `Set stockpile limit for ${goodName}`,
      row.stock_limit,
    );
    if (n !== null) act('set_stockpile_limit', { good_id: goodId, limit: n });
  };

  return (
    <div
      style={stripStyleEffective}
      title={aldermanActing ? blockTitle : undefined}
    >
      <span style={stripCellStyle}>
        Buy:{' '}
        <button
          type="button"
          style={valueBtnStyle}
          disabled={aldermanActing}
          onClick={editBuy}
        >
          {row.buy_price}m
        </button>
        <button
          type="button"
          style={flagPillStyle(isAuto)}
          disabled={aldermanActing}
          onClick={() => act('toggle_auto_price', { good_id: goodId })}
          title={
            aldermanActing
              ? blockTitle
              : isAuto
                ? 'Automatic: follows the going rate.'
                : undefined
          }
        >
          {isAuto ? 'Auto' : 'Manual'}
        </button>
      </span>
      <span style={stripCellStyle}>
        Sell:{' '}
        <button
          type="button"
          style={valueBtnStyle}
          disabled={aldermanActing}
          onClick={editSell}
        >
          {row.sell_price}m
        </button>
      </span>
      <span style={stripCellStyle}>
        Limit:{' '}
        <button
          type="button"
          style={valueBtnStyle}
          disabled={aldermanActing}
          onClick={editLimit}
        >
          {row.stock_limit}
        </button>
        <button
          type="button"
          style={flagPillStyle(limitAuto)}
          disabled={aldermanActing}
          onClick={() => act('toggle_auto_limit', { good_id: goodId })}
          title={
            aldermanActing
              ? blockTitle
              : limitAuto
                ? `Automatic: ${data.auto_limit_days} days of demand, more when the town is livelier.`
                : undefined
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
        disabled={aldermanActing}
        onClick={() => act('toggle_stockpile_accept', { good_id: goodId })}
        title={aldermanActing ? blockTitle : 'Let people deposit this good.'}
      >
        {accepting ? 'Accept' : 'Reject'}
      </button>
      <button
        type="button"
        style={flagPillStyle(!withdrawDisabled)}
        disabled={aldermanActing}
        onClick={() => act('toggle_withdraw_disabled', { good_id: goodId })}
        title={aldermanActing ? blockTitle : 'Let people withdraw this good.'}
      >
        {withdrawDisabled ? 'No-W' : 'W-OK'}
      </button>
      <button
        type="button"
        style={flagPillStyle(!autoexportDisabled)}
        disabled={aldermanActing}
        onClick={() => act('toggle_autoexport_disabled', { good_id: goodId })}
        title={
          aldermanActing
            ? blockTitle
            : 'Toggle Autoexport. When off, surplus stays in the stockpile.'
        }
      >
        {autoexportDisabled ? 'No-X' : 'X-OK'}
      </button>
    </div>
  );
};
