import { useState } from 'react';

import {
  cardStyle,
  compactButtonStyle,
  denseRowStyle,
  ellipsisCellStyle,
  FONT_LEAD,
  FONT_SMALL,
  FONT_TITLE,
  INK,
  INK_SOFT,
  pageStyle,
  PriceTag,
  SEAL_GREEN,
  sectionHeaderStyle,
  SERIF,
  titleStyle,
} from '../../common/parchment';
import type { ActFn, CulturalStockEntry, KinshipData } from '../types';

type Props = {
  stock: CulturalStockEntry[];
  kinship?: KinshipData;
  budget: number;
  isAgent?: boolean;
  act: ActFn;
};

const StockCard = (props: {
  entry: CulturalStockEntry;
  budget: number;
  act: ActFn;
}) => {
  const { entry, budget, act } = props;
  const cantAfford = budget < entry.price;
  const hasTariff = entry.price_tariff > 0;
  const hasKin =
    !!entry.is_kin &&
    entry.price_base_pre_kin !== undefined &&
    entry.price_base_pre_kin > entry.price_base;
  const kinSaving = hasKin
    ? (entry.price_base_pre_kin as number) - entry.price_base
    : 0;
  const preKinPrice = hasKin
    ? (entry.price_base_pre_kin as number) + entry.price_tariff
    : 0;
  const priceTitle = hasKin
    ? `${entry.price_base}m + ${entry.price_tariff}m Crown duty = ${entry.price}m (Kinship -${kinSaving}m off base cost ${entry.base_cost}m)`
    : hasTariff
      ? `${entry.price_base}m + ${entry.price_tariff}m Crown duty = ${entry.price}m (was ${entry.base_cost}m)`
      : `${entry.price}m (was ${entry.base_cost}m)`;
  return (
    <div style={denseRowStyle}>
      <div
        style={{
          ...ellipsisCellStyle,
          color: INK,
          fontSize: FONT_TITLE,
        }}
        title={`${entry.name} - ${entry.qty} in stock`}
      >
        {entry.pack_qty > 1 && (
          <span
            style={{
              color: INK_SOFT,
              marginRight: '4px',
              fontSize: FONT_LEAD,
            }}
          >
            x{entry.pack_qty}
          </span>
        )}
        {entry.name}
        <span
          style={{
            color: INK_SOFT,
            marginLeft: '6px',
            fontSize: FONT_SMALL,
          }}
        >
          ({entry.qty})
        </span>
      </div>
      <PriceTag
        price={entry.price}
        tariff={entry.price_tariff}
        cantAfford={cantAfford}
        title={priceTitle}
        strikethrough={hasKin ? preKinPrice : undefined}
      />
      <div style={{ flexShrink: 0 }}>
        <button
          type="button"
          style={compactButtonStyle({ disabled: cantAfford })}
          disabled={cantAfford}
          onClick={() =>
            act('cultural_buy', {
              pack: entry.pack,
              ship_id: entry.ship_id,
            })
          }
          title={`Buy ${entry.name} for ${entry.price}m`}
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
            gridTemplateColumns: 'repeat(auto-fill, minmax(260px, 1fr))',
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

const KinshipBanner = (props: { children: React.ReactNode }) => (
  <div
    style={{
      margin: '6px 0 8px',
      padding: '6px 10px',
      border: `1px dashed ${SEAL_GREEN}`,
      color: INK,
      fontFamily: SERIF,
      fontSize: '12px',
      lineHeight: 1.4,
    }}
  >
    {props.children}
  </div>
);

export const CulturalStockTab = (props: Props) => {
  const { stock, kinship, budget, isAgent, act } = props;

  const banners = (
    <>
      {!!isAgent && (
        <KinshipBanner>
          <span
            style={{
              color: SEAL_GREEN,
              fontVariant: 'small-caps',
              fontWeight: 'bold',
              marginRight: '6px',
            }}
          >
            Chartered Agent
          </span>
          <span style={{ color: INK_SOFT }}>
            As an agent of the Azurian Trading Company, you are allowed to
            access, view, and purchase the Cultural Stock of any docked ships,
            and view and hail ships on behalf of the Factor.
          </span>
        </KinshipBanner>
      )}
      {kinship?.realm_name && (
        <KinshipBanner>
          <span
            style={{
              color: SEAL_GREEN,
              fontVariant: 'small-caps',
              fontWeight: 'bold',
              marginRight: '6px',
            }}
          >
            Kinship: {kinship.realm_name}
          </span>
          <span style={{ color: INK_SOFT }}>
            Cultural stock from {kinship.realm_name} ships costs{' '}
            {kinship.buy_pct}% less.
          </span>
        </KinshipBanner>
      )}
      {kinship?.agent_realm_name && (
        <KinshipBanner>
          <span
            style={{
              color: SEAL_GREEN,
              fontVariant: 'small-caps',
              fontWeight: 'bold',
              marginRight: '6px',
            }}
          >
            Agent Kinship: {kinship.agent_realm_name}
          </span>
          <span style={{ color: INK_SOFT }}>
            As an Agent, your buys from {kinship.agent_realm_name} ships cost{' '}
            {kinship.buy_pct}% less.
          </span>
        </KinshipBanner>
      )}
    </>
  );

  if (!stock.length) {
    return (
      <div style={pageStyle}>
        <div style={titleStyle}>Cultural Stock</div>
        {banners}
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
      {banners}
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
