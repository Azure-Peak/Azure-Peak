import { useState } from 'react';

import { useBackend } from '../../backend';
import { groupByCategory } from './helpers';
import type { Data } from './types';
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
} from './styles';

// ── Market view ──────────────────────────────────────────────────
export const MarketView = (props: { data: Data }) => {
  const { act } = useBackend<Data>();
  const { market_rows, good_catalog, region_catalog } = props.data;

  const groups = groupByCategory(market_rows, good_catalog);
  const [activeCategory, setActiveCategory] = useState<string>(
    groups[0]?.category ?? '',
  );
  // If the selected category disappears (e.g. good toggled off mid-session), fall back.
  const activeGroup =
    groups.find((g) => g.category === activeCategory) ?? groups[0];

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
          const importRegionName = row.import_region_id
            ? (region_catalog[row.import_region_id]?.name ?? row.import_region_id)
            : null;
          const exportRegionName = row.export_region_id
            ? (region_catalog[row.export_region_id]?.name ?? row.export_region_id)
            : null;
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
              <div
                style={{
                  display: 'flex',
                  flexWrap: 'wrap',
                  gap: '12px',
                  alignItems: 'center',
                  fontSize: '12px',
                }}
              >
                <span style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
                  <span style={{ color: INK_FAINT, fontVariant: 'small-caps' }}>Buy:</span>
                  {importable ? (
                    importRegionName ? (
                      <>
                        <span>
                          {importRegionName} @{' '}
                          <span style={{ color: SEAL_AMBER }}>
                            {row.import_unit_price}m/u
                          </span>
                          {row.import_capacity_total > 0 && (
                            <span
                              title="Units still available today at this price. Buying beyond this exhausts the region's daily production and the price climbs."
                              style={{
                                color:
                                  row.import_capacity_today <= 0
                                    ? INK_FAINT
                                    : SEAL_BLUE,
                                marginLeft: '4px',
                                fontSize: '11px',
                              }}
                            >
                              [{row.import_capacity_today}/
                              {row.import_capacity_total}]
                            </span>
                          )}
                        </span>
                        {!!row.import_blockaded && (
                          <span style={badgeStyle(SEAL_RED)}>BLOCKADED</span>
                        )}
                        {row.import_region_id && (
                          <button
                            type="button"
                            style={inkButtonStyle({ color: SEAL_BLUE })}
                            onClick={() =>
                              act('trade_import', {
                                region_id: row.import_region_id,
                                good_id: row.good_id,
                              })
                            }
                          >
                            Import
                          </button>
                        )}
                      </>
                    ) : (
                      <span style={{ fontStyle: 'italic', color: INK_FAINT }}>
                        no producing region
                      </span>
                    )
                  ) : (
                    <span style={{ fontStyle: 'italic', color: INK_FAINT }}>
                      not importable
                    </span>
                  )}
                </span>
                <span style={{ display: 'flex', alignItems: 'center', gap: '4px' }}>
                  <span style={{ color: INK_FAINT, fontVariant: 'small-caps' }}>Sell:</span>
                  {exportRegionName ? (
                    <>
                      <span>
                        {exportRegionName} @{' '}
                        <span style={{ color: SEAL_AMBER }}>
                          {row.export_unit_price}m/u
                        </span>
                        {row.export_capacity_total > 0 && (
                          <span
                            title="Units the buyer still wants today at this price. Selling beyond this saturates the demand and the price drops."
                            style={{
                              color:
                                row.export_capacity_today <= 0
                                  ? INK_FAINT
                                  : SEAL_GREEN,
                              marginLeft: '4px',
                              fontSize: '11px',
                            }}
                          >
                            [{row.export_capacity_today}/
                            {row.export_capacity_total}]
                          </span>
                        )}
                      </span>
                      {!!row.export_blockaded && (
                        <span style={badgeStyle(SEAL_RED)}>BLOCKADED</span>
                      )}
                      {row.export_region_id && (
                        <button
                          type="button"
                          style={inkButtonStyle({ color: SEAL_GREEN })}
                          onClick={() =>
                            act('trade_export', {
                              region_id: row.export_region_id,
                              good_id: row.good_id,
                            })
                          }
                        >
                          Export
                        </button>
                      )}
                    </>
                  ) : (
                    <span style={{ fontStyle: 'italic', color: INK_FAINT }}>
                      no demanding region
                    </span>
                  )}
                </span>
              </div>
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
