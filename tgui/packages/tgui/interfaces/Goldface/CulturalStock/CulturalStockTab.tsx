import { useState } from 'react';

import {
  cardStyle,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  sectionHeaderStyle,
  SERIF,
  titleStyle,
} from '../../common/parchment';
import type { ActFn, CulturalStockEntry } from '../types';

type Props = {
  stock: CulturalStockEntry[];
  budget: number;
  act: ActFn;
};

const StockCard = (props: {
  entry: CulturalStockEntry;
  budget: number;
  act: ActFn;
}) => {
  const { entry, budget, act } = props;
  const cantAfford = budget < entry.price;
  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'center',
        gap: '8px',
        padding: '4px 8px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontFamily: SERIF,
      }}
    >
      <div style={{ flex: 1, minWidth: 0 }}>
        <div
          style={{
            color: INK,
            fontWeight: 'bold',
            fontSize: '12px',
            overflow: 'hidden',
            textOverflow: 'ellipsis',
            whiteSpace: 'nowrap',
          }}
        >
          {entry.name}
        </div>
        <div style={{ color: INK_SOFT, fontSize: '10px' }}>
          {entry.pack_qty > 1 ? `x${entry.pack_qty} - ` : ''}{entry.qty} in stock
        </div>
      </div>
      <div style={{ textAlign: 'right', flexShrink: 0 }}>
        <div
          style={{
            fontSize: '12px',
            color: cantAfford ? INK_FAINT : INK,
            fontWeight: 'bold',
          }}
          title={
            entry.price_tariff > 0
              ? `${entry.price_base}m + ${entry.price_tariff}m Crown duty`
              : undefined
          }
        >
          {entry.price}m
        </div>
        <div
          style={{
            fontSize: '9px',
            color: SEAL_AMBER,
            fontStyle: 'italic',
            textDecoration: 'line-through',
          }}
        >
          {entry.base_cost}m
        </div>
      </div>
      <div style={{ flexShrink: 0 }}>
        <button
          type="button"
          style={inkButtonStyle({ disabled: cantAfford })}
          disabled={cantAfford}
          onClick={() =>
            act('cultural_buy', {
              pack: entry.pack,
              ship_id: entry.ship_id,
            })
          }
        >
          Buy
        </button>
      </div>
    </div>
  );
};

const ShipSection = (props: {
  shipId: string;
  shipName: string;
  entries: CulturalStockEntry[];
  budget: number;
  act: ActFn;
  defaultExpanded: boolean;
}) => {
  const { shipName, entries, budget, act, defaultExpanded } = props;
  const [expanded, setExpanded] = useState(defaultExpanded);
  return (
    <div style={{ marginBottom: '8px' }}>
      <div
        style={{
          ...sectionHeaderStyle,
          cursor: 'pointer',
          display: 'flex',
          alignItems: 'center',
          gap: '6px',
          marginTop: '4px',
        }}
        onClick={() => setExpanded((e) => !e)}
      >
        <span style={{ color: INK_SOFT, fontSize: '11px' }}>
          {expanded ? '▾' : '▸'}
        </span>
        <span>{shipName}</span>
        <span
          style={{
            color: INK_SOFT,
            fontSize: '11px',
            textTransform: 'none',
            fontVariant: 'normal',
            fontWeight: 'normal',
            marginLeft: '6px',
          }}
        >
          ({entries.length} wares)
        </span>
      </div>
      {expanded && (
        <div
          style={{
            display: 'grid',
            gridTemplateColumns: '1fr 1fr',
            gap: '0 12px',
          }}
        >
          {entries.map((entry) => (
            <StockCard
              key={entry.pack}
              entry={entry}
              budget={budget}
              act={act}
            />
          ))}
        </div>
      )}
    </div>
  );
};

export const CulturalStockTab = (props: Props) => {
  const { stock, budget, act } = props;

  if (!stock.length) {
    return (
      <div style={pageStyle}>
        <div style={titleStyle}>Cultural Stock</div>
        <div
          style={{
            ...cardStyle,
            textAlign: 'center',
            color: INK_SOFT,
            marginTop: '12px',
          }}
        >
          No foreign vessel is at the pier. Hail one to access her cultural
          stores.
        </div>
      </div>
    );
  }

  const byShip = new Map<string, { name: string; entries: CulturalStockEntry[] }>();
  for (const entry of stock) {
    const existing = byShip.get(entry.ship_id);
    if (existing) {
      existing.entries.push(entry);
    } else {
      byShip.set(entry.ship_id, {
        name: entry.ship_name,
        entries: [entry],
      });
    }
  }
  const ships = Array.from(byShip.entries());

  return (
    <div style={pageStyle}>
      <div style={titleStyle}>Cultural Stock</div>
      <div
        style={{
          textAlign: 'center',
          color: INK_SOFT,
          fontSize: '12px',
          marginBottom: '8px',
        }}
      >
        Goods of distinction unloaded by docked vessels. They depart when she
        sails.
      </div>
      {ships.map(([shipId, info]) => (
        <ShipSection
          key={shipId}
          shipId={shipId}
          shipName={info.name}
          entries={info.entries}
          budget={budget}
          act={act}
          defaultExpanded={ships.length === 1}
        />
      ))}
    </div>
  );
};
