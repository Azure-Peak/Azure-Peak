import { useState } from 'react';

import { useBackend } from '../../backend';
import { groupByCategory } from './helpers';
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
import type { AutoImportRow, Data } from './types';

export const AutoImportView = (props: { data: Data }) => {
  const { act } = useBackend<Data>();
  const { auto_import, good_catalog } = props.data;
  const {
    today_spent,
    purse_floor,
    floor_target,
    batch_size,
    max_price_mult,
    essentials,
    others,
    history,
  } = auto_import;

  const [floorDraft, setFloorDraft] = useState<string>(String(purse_floor));

  const activeCount =
    essentials.filter((r) => r.active).length +
    others.filter((r) => r.active).length;

  const groupedOthers = groupByCategory(others, good_catalog);
  const [activeCategory, setActiveCategory] = useState<string>(
    groupedOthers[0]?.category ?? '',
  );
  const activeGroup =
    groupedOthers.find((g) => g.category === activeCategory) ?? groupedOthers[0];

  return (
    <div>
      <div style={sectionHeaderStyle}>Standing Imports</div>

      <div style={cardStyle}>
        <div
          style={{
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center',
            flexWrap: 'wrap',
            gap: '8px',
          }}
        >
          <div>
            <div style={{ fontSize: '12px', color: INK_SOFT }}>
              Today&apos;s spend:{' '}
              <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
                {today_spent}m
              </span>{' '}
              &middot; Goods on standing import:{' '}
              <span style={{ fontWeight: 'bold' }}>{activeCount}</span>
            </div>
            <div style={{ fontSize: '11px', color: INK_FAINT, fontStyle: 'italic' }}>
              Tops up each good by {batch_size} units every 6 minutes when stock is
              below {floor_target}, skipping when a unit would cost more than{' '}
              {max_price_mult}x its base price.
            </div>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
            <span style={{ color: INK_FAINT, fontSize: '12px' }}>Purse floor:</span>
            <input
              type="number"
              value={floorDraft}
              min={0}
              max={99999}
              style={{
                width: '80px',
                fontFamily: 'inherit',
                fontSize: '12px',
                padding: '2px 4px',
                border: `1px solid ${INK_FAINT}`,
                background: 'rgba(255,248,220,0.55)',
                color: INK,
              }}
              onChange={(e) => setFloorDraft(e.target.value)}
            />
            <button
              type="button"
              style={inkButtonStyle({ color: SEAL_BLUE })}
              onClick={() => {
                const amount = Number(floorDraft);
                if (!Number.isFinite(amount)) return;
                act('set_auto_import_purse_floor', { amount });
              }}
            >
              Set
            </button>
            <button
              type="button"
              style={inkButtonStyle({ color: SEAL_RED })}
              onClick={() => act('kill_switch_auto_import')}
              title="Strike every standing import from the ledger at once."
            >
              Strike All
            </button>
          </div>
        </div>
      </div>

      <div style={sectionHeaderStyle}>Essentials (on by default)</div>
      {essentials.length === 0 ? (
        <div style={{ textAlign: 'center', fontStyle: 'italic', color: INK_SOFT }}>
          No essentials configured.
        </div>
      ) : (
        essentials.map((row) => (
          <ToggleRow
            key={row.good_id}
            row={row}
            name={good_catalog[row.good_id]?.name ?? row.good_id}
            floorTarget={floor_target}
            onToggle={() =>
              act('toggle_auto_import', { good_id: row.good_id })
            }
          />
        ))
      )}

      <div style={sectionHeaderStyle}>Other Goods</div>
      {groupedOthers.length === 0 ? (
        <div style={{ textAlign: 'center', fontStyle: 'italic', color: INK_SOFT }}>
          No other goods may be placed on standing import at present.
        </div>
      ) : (
        <>
          <div style={subTabBarStyle}>
            {groupedOthers.map((g) => (
              <div
                key={g.category}
                style={subTabStyle(g.category === activeGroup?.category)}
                onClick={() => setActiveCategory(g.category)}
              >
                {g.label} ({g.rows.filter((r) => r.active).length}/{g.rows.length})
              </div>
            ))}
          </div>
          {activeGroup && (
            <div>
              {activeGroup.rows.map((row) => (
                <ToggleRow
                  key={row.good_id}
                  row={row}
                  name={good_catalog[row.good_id]?.name ?? row.good_id}
                  floorTarget={floor_target}
                  onToggle={() =>
                    act('toggle_auto_import', { good_id: row.good_id })
                  }
                />
              ))}
            </div>
          )}
        </>
      )}

      <div style={sectionHeaderStyle}>
        Recent Activity (last {history.length || 0} day{history.length === 1 ? '' : 's'})
      </div>
      {history.length === 0 ? (
        <div style={{ textAlign: 'center', fontStyle: 'italic', color: INK_SOFT }}>
          No auto-import history yet. First tick will record here.
        </div>
      ) : (
        [...history].reverse().map((entry, idx) => (
          <div key={`${entry.day}-${idx}`} style={cardStyle}>
            <div
              style={{
                display: 'flex',
                justifyContent: 'space-between',
                marginBottom: '4px',
              }}
            >
              <span style={{ fontWeight: 'bold' }}>Day {entry.day}</span>
              <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
                {entry.spent}m
              </span>
            </div>
            {entry.lines.length === 0 ? (
              <div style={{ color: INK_FAINT, fontSize: '11px', fontStyle: 'italic' }}>
                No auto-import activity.
              </div>
            ) : (
              <div style={{ fontSize: '11px', color: INK_SOFT }}>
                {entry.lines.map((line, i) => (
                  <div key={i}>{line}</div>
                ))}
              </div>
            )}
          </div>
        ))
      )}
    </div>
  );
};

const ToggleRow = (props: {
  row: AutoImportRow;
  name: string;
  floorTarget: number;
  onToggle: () => void;
}) => {
  const { row, name, floorTarget, onToggle } = props;
  const low = row.stock < floorTarget;
  return (
    <div
      style={{
        ...cardStyle,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        padding: '6px 12px',
      }}
    >
      <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
        <input
          type="checkbox"
          checked={!!row.active}
          onChange={onToggle}
          style={{ cursor: 'pointer' }}
        />
        <span style={{ fontWeight: 'bold' }}>{name}</span>
        {row.active && low && (
          <span style={badgeStyle(SEAL_BLUE)}>will top up</span>
        )}
        {!row.active && (
          <span style={badgeStyle(INK_FAINT)}>off</span>
        )}
      </div>
      <div style={{ fontSize: '11px', color: INK_FAINT }}>
        Stock:{' '}
        <span style={{ color: low ? SEAL_RED : SEAL_GREEN, fontWeight: 'bold' }}>
          {row.stock}
        </span>{' '}
        / target {floorTarget}
      </div>
    </div>
  );
};
