import { useState } from 'react';

import {
  cardStyle,
  compactButtonStyle,
  denseRowStyle,
  ellipsisCellStyle,
  FONT_BODY,
  FONT_LEAD,
  FONT_SMALL,
  FONT_TITLE,
  INK,
  INK_SOFT,
  pageStyle,
  PriceTag,
  SEAL_GREEN,
  SEAL_RED,
  sectionHeaderStyle,
  SERIF,
  titleStyle,
} from '../../common/parchment';
import type {
  ActFn,
  CatalogData,
  CatalogEntry,
  CulturalStockEntry,
  KinshipData,
} from '../types';

type Props = {
  stock: CulturalStockEntry[];
  catalogs?: CatalogData[];
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
        <span style={{ color: INK_SOFT, fontSize: FONT_BODY }}>
          {expanded ? '▾' : '▸'}
        </span>
        <span>{shipName}</span>
        <span
          style={{
            color: INK_SOFT,
            fontSize: FONT_BODY,
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

const CatalogStockCard = (props: {
  catalogId: string;
  entry: CatalogEntry;
  budget: number;
  act: ActFn;
}) => {
  const { catalogId, entry, budget, act } = props;
  const soldOut = entry.qty <= 0;
  const cantAfford = budget < entry.price;
  const disabled = soldOut || cantAfford;
  const hasTariff = entry.price_tariff > 0;
  const hasKin = entry.price_base_pre_kin > entry.price_base;
  const kinSaving = hasKin ? entry.price_base_pre_kin - entry.price_base : 0;
  const preKinPrice = hasKin ? entry.price_base_pre_kin + entry.price_tariff : 0;
  const priceTitle = hasKin
    ? `${entry.price_base}m + ${entry.price_tariff}m Crown duty = ${entry.price}m (Kinship -${kinSaving}m)`
    : hasTariff
      ? `${entry.price_base}m + ${entry.price_tariff}m Crown duty = ${entry.price}m`
      : `${entry.price}m`;
  return (
    <div style={denseRowStyle}>
      <div
        style={{ ...ellipsisCellStyle, color: INK, fontSize: FONT_TITLE }}
        title={entry.name}
      >
        {entry.pack_qty > 1 && (
          <span
            style={{ color: INK_SOFT, marginRight: '4px', fontSize: FONT_LEAD }}
          >
            x{entry.pack_qty}
          </span>
        )}
        {entry.name}
        <span
          style={{
            color: soldOut ? SEAL_RED : INK_SOFT,
            marginLeft: '6px',
            fontSize: FONT_SMALL,
          }}
          title={`${entry.qty} of ${entry.stock_max} in stock - restocks to full each day`}
        >
          ({entry.qty}/{entry.stock_max})
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
          style={compactButtonStyle({ disabled })}
          disabled={disabled}
          onClick={() => act('catalog_buy', { catalog: catalogId, pack: entry.pack })}
          title={
            soldOut
              ? `${entry.name} is out of stock - the caravan restocks to full each day`
              : `Order ${entry.name} for ${entry.price}m`
          }
        >
          {soldOut ? 'Out' : 'Buy'}
        </button>
      </div>
    </div>
  );
};

const CatalogSection = (props: {
  catalog: CatalogData;
  budget: number;
  act: ActFn;
}) => {
  const { catalog, budget, act } = props;
  const accessible = !!catalog.accessible;
  const [expanded, setExpanded] = useState(accessible);
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
        <span style={{ color: INK_SOFT, fontSize: FONT_BODY }}>
          {expanded ? '▾' : '▸'}
        </span>
        <span>{catalog.name}</span>
        <span
          style={{
            color: accessible ? SEAL_GREEN : INK_SOFT,
            fontSize: FONT_BODY,
            textTransform: 'none',
            fontVariant: 'normal',
            fontWeight: 'normal',
            marginLeft: '6px',
          }}
        >
          {catalog.origin_access
            ? `(open to you - ${catalog.discount_pct}% off)`
            : catalog.unlocked
              ? '(agreement signed)'
              : `(sealed - ${catalog.favor_cost} favor to sign)`}
        </span>
      </div>
      {expanded && (
        <>
          <div
            style={{
              ...noteStyleItalic,
              padding: '2px 0 6px',
            }}
          >
            {catalog.desc}
          </div>
          {accessible && (
            <div
              style={{
                ...noteStyleItalic,
                fontStyle: 'normal',
                padding: '0 0 6px',
              }}
            >
              The caravan restocks to its full load each day.
            </div>
          )}
          {accessible ? (
            <div
              style={{
                display: 'grid',
                gridTemplateColumns: 'repeat(auto-fill, minmax(260px, 1fr))',
                gap: '0 12px',
              }}
            >
              {catalog.entries.map((entry) => (
                <CatalogStockCard
                  key={entry.pack}
                  catalogId={catalog.id}
                  entry={entry}
                  budget={budget}
                  act={act}
                />
              ))}
            </div>
          ) : (
            // TODO: flavor
            <div style={{ ...cardStyle, color: INK_SOFT, textAlign: 'center' }}>
              This charter is sealed. Open it in Management for{' '}
              {catalog.favor_cost} favor.
            </div>
          )}
        </>
      )}
    </div>
  );
};

const noteStyleItalic = {
  color: INK_SOFT,
  fontStyle: 'italic' as const,
  fontSize: FONT_BODY,
  lineHeight: 1.4,
};

const KinshipBanner = (props: { children: React.ReactNode }) => (
  <div
    style={{
      margin: '6px 0 8px',
      padding: '6px 10px',
      border: `1px dashed ${SEAL_GREEN}`,
      color: INK,
      fontFamily: SERIF,
      fontSize: FONT_BODY,
      lineHeight: 1.4,
    }}
  >
    {props.children}
  </div>
);

export const CulturalStockTab = (props: Props) => {
  const { stock, catalogs = [], kinship, budget, isAgent, act } = props;

  const companyKinCatalogs = catalogs.filter(
    (c) => c.access_basis === 'kinship',
  );
  const agentKinCatalogs = catalogs.filter((c) => c.access_basis === 'agent');

  const catalogSections = catalogs.length > 0 && (
    <>
      <div
        style={{
          ...sectionHeaderStyle,
          marginTop: '12px',
        }}
      >
        Trade Agreements
      </div>
      {catalogs.map((catalog) => (
        <CatalogSection
          key={catalog.id}
          catalog={catalog}
          budget={budget}
          act={act}
        />
      ))}
    </>
  );

  const banners = (
    <>
      {!!isAgent && (
        <KinshipBanner>
          <span
            style={{
              color: SEAL_GREEN,
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
      {companyKinCatalogs.map((c) => (
        <KinshipBanner key={`mk-${c.id}`}>
          <span
            style={{
              color: SEAL_GREEN,
              fontVariant: 'small-caps',
              fontWeight: 'bold',
              marginRight: '6px',
            }}
          >
            Merchant Kinship: {c.home_realm_name}
          </span>
          <span style={{ color: INK_SOFT }}>
            The {c.name} is open to the Company — wares cost {c.discount_pct}%
            less.
          </span>
        </KinshipBanner>
      ))}
      {agentKinCatalogs.map((c) => (
        <KinshipBanner key={`ak-${c.id}`}>
          <span
            style={{
              color: SEAL_GREEN,
              fontVariant: 'small-caps',
              fontWeight: 'bold',
              marginRight: '6px',
            }}
          >
            Agent Kinship: {c.home_realm_name}
          </span>
          <span style={{ color: INK_SOFT }}>
            As kin, the {c.name} is open to you — wares cost {c.discount_pct}%
            less.
          </span>
        </KinshipBanner>
      ))}
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
        {catalogSections}
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
          fontSize: FONT_BODY,
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
      {catalogSections}
    </div>
  );
};
