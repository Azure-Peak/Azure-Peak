import { type CSSProperties, Fragment, type ReactNode, useState } from 'react';

import { DawnForecast, reachLabel } from '../common/DawnForecast';
import { MarketBand } from '../common/MarketBand';
import { formatMammon } from '../common/format';
import {
  badgeStyle,
  FONT_BODY,
  FONT_SMALL,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkInputStyle,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  SEAL_RED,
  sectionHeaderStyle,
  SERIF,
  subTabStyle,
  TITLE,
  TITLE_FONT,
} from '../common/parchment';
import { CATEGORY_LABEL, groupByCategory } from './helpers';
import type { Data, MarketRow } from './types';

type Selection = { kind: 'region' | 'good'; id: string };

type ListKind = 'regions' | 'goods';

type TradeLink = {
  type: string;
  size: string;
  share?: number;
  volume?: number;
};

type TradeIndex = {
  supply: Record<string, Record<string, TradeLink>>;
  demand: Record<string, Record<string, TradeLink>>;
  tribute: Record<string, string[]>;
};

type GoodNote = { id: string; note?: string; noteTitle?: string };

type TypeRow = { type: string; size: string; goods: GoodNote[] };

const linkStyle: CSSProperties = {
  padding: 0,
  border: 'none',
  background: 'transparent',
  color: INK,
  fontFamily: SERIF,
  fontSize: FONT_BODY,
  cursor: 'pointer',
  textAlign: 'left',
};

const subheadStyle: CSSProperties = {
  ...sectionHeaderStyle,
  marginTop: '12px',
};

const detailTitleStyle: CSSProperties = {
  fontFamily: TITLE_FONT,
  fontSize: '20px',
  fontWeight: 'bold',
  color: TITLE,
};

const groupHeadStyle: CSSProperties = {
  fontWeight: 'bold',
  color: TITLE,
};

const smallSoftStyle: CSSProperties = {
  display: 'flex',
  alignItems: 'baseline',
  gap: '6px',
  color: INK_SOFT,
  fontSize: FONT_SMALL,
};

const tradeGridStyle = (columns: string): CSSProperties => ({
  display: 'grid',
  gridTemplateColumns: columns,
  gap: '4px 12px',
  alignItems: 'baseline',
});

const raidBadge = (blockaded: unknown, escorted: unknown) =>
  blockaded ? (
    <span style={badgeStyle(escorted ? SEAL_AMBER : SEAL_RED)}>
      {escorted ? 'ESCORTED' : 'RAIDED'}
    </span>
  ) : null;

const links = (
  map: Record<string, Record<string, TradeLink>>,
  key: string,
) => {
  if (!map[key]) {
    map[key] = {};
  }
  return map[key];
};

const buildIndex = (data: Data): TradeIndex => {
  const index: TradeIndex = { supply: {}, demand: {}, tribute: {} };
  for (const rid of Object.keys(data.region_catalog)) {
    const r = data.region_catalog[rid];
    for (const row of r.supply) {
      for (const g of row.goods) {
        links(index.supply, g.good_id)[rid] = {
          type: row.type,
          size: row.size,
          share: g.share,
          volume: g.volume,
        };
      }
    }
    for (const row of r.demand) {
      for (const g of row.goods) {
        links(index.demand, g.good_id)[rid] = {
          type: row.type,
          size: row.size,
          share: g.share,
          volume: g.volume,
        };
      }
    }
    for (const g of r.tribute) {
      if (!index.tribute[g]) {
        index.tribute[g] = [];
      }
      index.tribute[g].push(rid);
    }
  }
  return index;
};

const raidedPct = (data: Data, suppliers: Record<string, TradeLink>) => {
  let total = 0;
  let open = 0;
  for (const rid of Object.keys(suppliers)) {
    const volume = suppliers[rid].volume ?? 0;
    const state = data.region_caravan[rid];
    total += volume;
    if (!state?.blockaded || state?.escorted) open += volume;
  }
  return total ? 100 - Math.floor((open / total) * 100) : 0;
};

const matches = (name: string, query: string) =>
  !query || name.toLowerCase().includes(query.toLowerCase());

export const RegionsView = (props: { data: Data }) => {
  const { data } = props;
  const firstRegion =
    data.caravan_routes[0]?.subroutes[0]?.region_ids[0] ??
    Object.keys(data.region_catalog)[0];
  const [sel, setSel] = useState<Selection>({
    kind: 'region',
    id: firstRegion,
  });
  const [list, setList] = useState<ListKind>('regions');
  const [query, setQuery] = useState('');
  const [groups, setGroups] = useState<Record<string, boolean>>({});
  const index = buildIndex(data);

  const storedOpen = (key: string) => groups[key] ?? key.startsWith('route:');
  const groupOpen = (key: string) => !!query || storedOpen(key);
  const toggleGroup = (key: string) =>
    setGroups({ ...groups, [key]: !storedOpen(key) });

  const jumpToRegion = (id: string) => {
    const route = data.caravan_routes.find((rt) =>
      rt.subroutes.some((s) => s.region_ids.includes(id)),
    );
    if (route) setGroups({ ...groups, [`route:${route.id}`]: true });
    setSel({ kind: 'region', id });
    setList('regions');
    setQuery('');
  };
  const jumpToGood = (id: string) => {
    const category = data.good_catalog[id]?.category ?? 'misc';
    setGroups({ ...groups, [`cat:${category}`]: true });
    setSel({ kind: 'good', id });
    setList('goods');
    setQuery('');
  };

  return (
    <div
      style={{
        display: 'grid',
        gridTemplateColumns: '220px minmax(0, 1fr)',
        gap: '16px',
        alignItems: 'start',
        marginTop: '10px',
      }}
    >
      <div>
        <div style={{ display: 'flex', gap: '4px', marginBottom: '6px' }}>
          {(['regions', 'goods'] as ListKind[]).map((kind) => (
            <div
              key={kind}
              style={{
                ...subTabStyle(list === kind),
                flex: '1 1 0',
                textAlign: 'center',
              }}
              onClick={() => setList(kind)}
            >
              {kind === 'regions' ? 'Regions' : 'Goods'}
            </div>
          ))}
        </div>
        <input
          type="text"
          value={query}
          placeholder="Search"
          onChange={(e) => setQuery(e.target.value)}
          style={{
            ...inkInputStyle,
            width: '100%',
            boxSizing: 'border-box',
            marginBottom: '8px',
          }}
        />
        {list === 'regions' ? (
          <RegionList
            data={data}
            sel={sel}
            index={index}
            query={query}
            groupOpen={groupOpen}
            onToggle={toggleGroup}
            onPick={(id) => setSel({ kind: 'region', id })}
          />
        ) : (
          <GoodList
            data={data}
            sel={sel}
            index={index}
            query={query}
            groupOpen={groupOpen}
            onToggle={toggleGroup}
            onPick={(id) => setSel({ kind: 'good', id })}
          />
        )}
      </div>
      <div
        style={{
          position: 'sticky',
          top: 0,
          maxHeight: 'calc(100vh - 60px)',
          overflowY: 'auto',
        }}
      >
        {sel.kind === 'region' ? (
          <RegionDetail data={data} id={sel.id} onGood={jumpToGood} />
        ) : (
          <GoodDetail
            data={data}
            id={sel.id}
            index={index}
            onRegion={jumpToRegion}
          />
        )}
      </div>
    </div>
  );
};

const ListRow = (props: {
  active: boolean;
  dim: boolean;
  label: string;
  marks: ReactNode;
  onClick: () => void;
}) => {
  const { active, dim, label, marks, onClick } = props;
  return (
    <button
      type="button"
      onClick={onClick}
      style={{
        ...linkStyle,
        display: 'flex',
        width: '100%',
        alignItems: 'baseline',
        gap: '6px',
        padding: '1px 6px',
        borderRadius: '2px',
        border: `1px solid ${active ? INK_SOFT : 'transparent'}`,
        background: active ? 'var(--p-tab-active-bg)' : 'transparent',
        color: dim ? INK_FAINT : INK,
        fontWeight: active ? 'bold' : 'normal',
      }}
    >
      <span style={{ flex: '1 1 auto', minWidth: 0 }}>{label}</span>
      {marks}
    </button>
  );
};

const GroupHead = (props: {
  label: string;
  count: number;
  open: boolean;
  onToggle: () => void;
}) => (
  <button
    type="button"
    onClick={props.onToggle}
    style={{
      ...linkStyle,
      ...groupHeadStyle,
      display: 'flex',
      width: '100%',
      alignItems: 'baseline',
      gap: '6px',
    }}
  >
    <span style={{ width: '10px', color: INK_SOFT }}>
      {props.open ? '▾' : '▸'}
    </span>
    <span style={{ flex: '1 1 auto', minWidth: 0 }}>{props.label}</span>
    <span style={{ color: INK_FAINT, fontSize: FONT_SMALL, fontWeight: 'normal' }}>
      {props.count}
    </span>
  </button>
);

const TradeMarks = (props: {
  share?: number;
  demand?: number;
  raidedSupply?: number;
  raidedDemand?: number;
}) => (
  <>
    {props.share !== undefined && (
      <span style={{ color: SEAL_AMBER, fontSize: FONT_SMALL }}>
        {props.share}%
      </span>
    )}
    {props.demand !== undefined && (
      <span style={{ color: INK_SOFT, fontSize: FONT_SMALL }}>
        demand {props.demand}%
      </span>
    )}
    {!!(props.raidedSupply || props.raidedDemand) && (
      <span
        title="Share of the realm's supply (S) and demand (D) still reachable. The rest is cut off by raids."
        style={{ color: SEAL_RED, fontSize: FONT_SMALL, cursor: 'help' }}
      >
        {reachLabel(props.raidedSupply, props.raidedDemand)}
      </span>
    )}
  </>
);

const EmptyList = () => <div style={{ color: INK_FAINT }}>No matches.</div>;

const RegionList = (props: {
  data: Data;
  sel: Selection;
  index: TradeIndex;
  query: string;
  groupOpen: (key: string) => boolean;
  onToggle: (key: string) => void;
  onPick: (id: string) => void;
}) => {
  const { data, sel, index, query, groupOpen, onToggle, onPick } = props;
  const regionName = (id: string) => data.region_catalog[id]?.name ?? id;
  const shown = (id: string) => matches(regionName(id), query);
  const routed = new Set<string>();
  for (const route of data.caravan_routes) {
    for (const sub of route.subroutes) {
      for (const id of sub.region_ids) routed.add(id);
    }
  }
  const unrouted = Object.keys(data.region_catalog).filter(
    (id) => !routed.has(id) && shown(id),
  );
  const routes = data.caravan_routes
    .map((route) => ({
      route,
      subroutes: route.subroutes
        .map((sub) => ({ sub, ids: sub.region_ids.filter(shown) }))
        .filter((s) => s.ids.length),
    }))
    .filter((r) => r.subroutes.length);

  const row = (id: string) => {
    const share =
      sel.kind === 'good' ? index.supply[sel.id]?.[id]?.share : undefined;
    const demand =
      sel.kind === 'good' ? index.demand[sel.id]?.[id]?.share : undefined;
    return (
      <ListRow
        key={id}
        active={sel.kind === 'region' && sel.id === id}
        dim={sel.kind === 'good' && share === undefined && demand === undefined}
        label={regionName(id)}
        marks={<TradeMarks share={share} demand={demand} />}
        onClick={() => onPick(id)}
      />
    );
  };

  if (!routes.length && !unrouted.length) {
    return <EmptyList />;
  }
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
      {routes.map(({ route, subroutes }) => (
        <div key={route.id}>
          <GroupHead
            label={route.name}
            count={subroutes.reduce((n, s) => n + s.ids.length, 0)}
            open={groupOpen(`route:${route.id}`)}
            onToggle={() => onToggle(`route:${route.id}`)}
          />
          {groupOpen(`route:${route.id}`) &&
            subroutes.map(({ sub, ids }) => (
              <div key={sub.id} style={{ paddingLeft: '8px', marginTop: '2px' }}>
                <div style={smallSoftStyle}>
                  {sub.name}
                  {raidBadge(
                    sub.region_ids.some((id) => data.region_caravan[id]?.blockaded),
                    sub.region_ids.some((id) => data.region_caravan[id]?.escorted),
                  )}
                </div>
                {ids.map(row)}
              </div>
            ))}
        </div>
      ))}
      {unrouted.length > 0 && <div>{unrouted.map(row)}</div>}
    </div>
  );
};

const GoodList = (props: {
  data: Data;
  sel: Selection;
  index: TradeIndex;
  query: string;
  groupOpen: (key: string) => boolean;
  onToggle: (key: string) => void;
  onPick: (id: string) => void;
}) => {
  const { data, sel, index, query, groupOpen, onToggle, onPick } = props;
  const goodName = (id: string) => data.good_catalog[id]?.name ?? id;
  const ids = new Set([
    ...Object.keys(index.supply),
    ...Object.keys(index.demand),
    ...Object.keys(index.tribute),
  ]);
  const rows = [...ids]
    .filter((id) => matches(goodName(id), query))
    .sort((a, b) => goodName(a).localeCompare(goodName(b)))
    .map((good_id) => ({ good_id }));
  const groups = groupByCategory(rows, data.good_catalog);

  if (!groups.length) {
    return <EmptyList />;
  }
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
      {groups.map((group) => (
        <div key={group.category}>
          <GroupHead
            label={group.label}
            count={group.rows.length}
            open={groupOpen(`cat:${group.category}`)}
            onToggle={() => onToggle(`cat:${group.category}`)}
          />
          {groupOpen(`cat:${group.category}`) && (
            <div style={{ paddingLeft: '8px', marginTop: '2px' }}>
              {group.rows.map(({ good_id: id }) => {
                const share =
                  sel.kind === 'region'
                    ? index.supply[id]?.[sel.id]?.share
                    : undefined;
                const demand =
                  sel.kind === 'region'
                    ? index.demand[id]?.[sel.id]?.share
                    : undefined;
                return (
                  <ListRow
                    key={id}
                    active={sel.kind === 'good' && sel.id === id}
                    dim={
                      sel.kind === 'region' &&
                      share === undefined &&
                      demand === undefined
                    }
                    label={goodName(id)}
                    marks={
                      <TradeMarks
                        share={share}
                        demand={demand}
                        raidedSupply={raidedPct(data, index.supply[id] ?? {})}
                        raidedDemand={raidedPct(data, index.demand[id] ?? {})}
                      />
                    }
                    onClick={() => onPick(id)}
                  />
                );
              })}
            </div>
          )}
        </div>
      ))}
    </div>
  );
};

const TypeTable = (props: {
  rows: TypeRow[];
  goodName: (id: string) => string;
  onGood: (id: string) => void;
}) => {
  const { rows, goodName, onGood } = props;
  if (!rows.length) {
    return <div style={{ color: INK_FAINT }}>Nothing.</div>;
  }
  return (
    <div style={tradeGridStyle('auto auto minmax(0, 1fr)')}>
      {rows.map((row) => (
        <Fragment key={row.type}>
          <span style={{ color: INK }}>{row.type}</span>
          <span style={{ color: INK_FAINT, fontSize: FONT_SMALL }}>
            {row.size}
          </span>
          <span style={{ color: INK_SOFT }}>
            {row.goods.map((g, i) => (
              <Fragment key={g.id}>
                {i > 0 && ', '}
                <button
                  type="button"
                  style={{ ...linkStyle, color: INK_SOFT }}
                  onClick={() => onGood(g.id)}
                >
                  {goodName(g.id)}
                </button>
                {g.note && (
                  <span
                    title={g.noteTitle}
                    style={{
                      color: SEAL_AMBER,
                      fontSize: FONT_SMALL,
                      cursor: g.noteTitle ? 'help' : undefined,
                    }}
                  >
                    {' '}
                    {g.note}
                  </span>
                )}
              </Fragment>
            ))}
          </span>
        </Fragment>
      ))}
    </div>
  );
};

const RegionDetail = (props: {
  data: Data;
  id: string;
  onGood: (id: string) => void;
}) => {
  const { data, id, onGood } = props;
  const r = data.region_catalog[id];
  if (!r) {
    return null;
  }
  const goodName = (gid: string) => data.good_catalog[gid]?.name ?? gid;
  const state = data.region_caravan[id];
  const route = data.caravan_routes.find((rt) =>
    rt.subroutes.some((s) => s.id === r.subroute),
  );
  const sub = route?.subroutes.find((s) => s.id === r.subroute);

  return (
    <div>
      <div style={{ display: 'flex', alignItems: 'baseline', gap: '8px' }}>
        <span style={detailTitleStyle}>{r.name}</span>
        {raidBadge(state?.blockaded, state?.escorted)}
      </div>
      <div style={{ color: INK_SOFT, fontSize: FONT_SMALL, marginTop: '2px' }}>
        {[sub?.name, route?.name].filter(Boolean).join(', ')}
      </div>
      {r.tribute.length > 0 && (
        <div style={{ marginTop: '6px', color: INK_SOFT }}>
          Tribute:{' '}
          {r.tribute.map((gid, i) => (
            <Fragment key={gid}>
              {i > 0 && ', '}
              <button type="button" style={linkStyle} onClick={() => onGood(gid)}>
                {goodName(gid)}
              </button>
            </Fragment>
          ))}
        </div>
      )}
      {r.gifts.length > 0 && (
        <div style={{ marginTop: '2px', color: INK_SOFT }}>
          Gifts: <span style={{ color: INK }}>{r.gifts.join(', ')}</span>
        </div>
      )}

      <div style={subheadStyle}>Supply</div>
      <TypeTable
        rows={r.supply.map((row) => ({
          type: row.type,
          size: row.size,
          goods: row.goods.map((g) => ({
            id: g.good_id,
            note: `${g.share}%`,
            noteTitle: `Supplies ${g.share}% of the realm's ${goodName(g.good_id)}.`,
          })),
        }))}
        goodName={goodName}
        onGood={onGood}
      />

      <div style={subheadStyle}>Demand</div>
      <TypeTable
        rows={r.demand.map((row) => ({
          type: row.type,
          size: row.size,
          goods: row.goods.map((g) => ({
            id: g.good_id,
            note: `${g.share}%`,
            noteTitle: `Takes ${g.share}% of the realm's demand for ${goodName(g.good_id)}.`,
          })),
        }))}
        goodName={goodName}
        onGood={onGood}
      />

      {!!r.description && (
        <div
          style={{
            marginTop: '12px',
            paddingTop: '8px',
            borderTop: `1px dashed ${PARCHMENT_SHADOW}`,
            color: INK_SOFT,
          }}
        >
          {r.description}
        </div>
      )}
    </div>
  );
};

const MarketLine = (props: { row: MarketRow }) => {
  const { row } = props;
  const value: CSSProperties = { color: INK, fontWeight: 'bold' };
  return (
    <div
      style={{
        display: 'flex',
        flexWrap: 'wrap',
        alignItems: 'baseline',
        gap: '4px 12px',
        marginTop: '4px',
        color: INK_SOFT,
      }}
    >
      <span>
        Market: <MarketBand label={row.market_label} />{' '}
        <span style={value}>
          {row.market_stock}/{row.market_target}
        </span>
      </span>
      <span>
        Buy: <span style={value}>{formatMammon(row.market_buy)}m</span>
      </span>
      <span>
        Sell: <span style={value}>{formatMammon(row.market_sell)}m</span>
      </span>
      <span>
        Royal stock: <span style={value}>{row.stock}</span>
      </span>
      <DawnForecast row={row} />
    </div>
  );
};

const ShareBar = (props: { share: number; raided: boolean }) => (
  <span style={{ display: 'inline-flex', alignItems: 'center', gap: '6px' }}>
    <span
      style={{
        display: 'inline-block',
        width: '60px',
        height: '6px',
        background: PARCHMENT_SHADOW,
        borderRadius: '1px',
        overflow: 'hidden',
      }}
    >
      <span
        style={{
          display: 'block',
          width: `${props.share}%`,
          height: '100%',
          background: props.raided ? SEAL_RED : SEAL_AMBER,
        }}
      />
    </span>
    <span
      style={{
        minWidth: '32px',
        textAlign: 'right',
        color: props.raided ? SEAL_RED : SEAL_AMBER,
      }}
    >
      {props.share}%
    </span>
  </span>
);

const GoodDetail = (props: {
  data: Data;
  id: string;
  index: TradeIndex;
  onRegion: (id: string) => void;
}) => {
  const { data, id, index, onRegion } = props;
  const good = data.good_catalog[id];
  const market = data.market_rows.find((m) => m.good_id === id);
  const suppliers = index.supply[id] ?? {};
  const demanders = index.demand[id] ?? {};
  const tribute = index.tribute[id] ?? [];
  const regionName = (rid: string) => data.region_catalog[rid]?.name ?? rid;
  const subName = (rid: string) => {
    const subId = data.region_catalog[rid]?.subroute;
    for (const route of data.caravan_routes) {
      const sub = route.subroutes.find((s) => s.id === subId);
      if (sub) return sub.name;
    }
    return '';
  };
  const byName = (a: string, b: string) =>
    regionName(a).localeCompare(regionName(b));
  const byShare = (links: Record<string, TradeLink>) => (a: string, b: string) =>
    (links[b].share ?? 0) - (links[a].share ?? 0);
  const supplyIds = Object.keys(suppliers).sort(byShare(suppliers));
  const demandIds = Object.keys(demanders).sort(byShare(demanders));

  const regionLink = (rid: string) => (
    <button type="button" style={linkStyle} onClick={() => onRegion(rid)}>
      {regionName(rid)}
    </button>
  );
  const typeCell = (link: TradeLink) => (
    <span style={{ color: INK_FAINT, fontSize: FONT_SMALL }}>
      {link.type}, {link.size}
    </span>
  );
  const routeCell = (rid: string) => {
    const state = data.region_caravan[rid];
    return (
      <span style={smallSoftStyle}>
        {subName(rid)}
        {raidBadge(state?.blockaded, state?.escorted)}
      </span>
    );
  };

  return (
    <div>
      <div style={{ display: 'flex', alignItems: 'baseline', gap: '8px' }}>
        <span style={detailTitleStyle}>{good?.name ?? id}</span>
        {!!good?.category && (
          <span style={{ fontStyle: 'italic', color: INK_SOFT }}>
            {CATEGORY_LABEL[good.category] ?? good.category}
          </span>
        )}
      </div>
      {market && <MarketLine row={market} />}

      <TradeSection
        title="Supply"
        help="Each region's share of the realm's supply. A raided region sends nothing at the Market dae."
        raidedHelp="of supply is raided and won't reach the Market."
        links={suppliers}
        ids={supplyIds}
        shareTitle={(rid, share) =>
          `${regionName(rid)} supplies ${share}% of the realm's ${good?.name ?? id}.`
        }
        empty="No region supplies it."
        data={data}
        regionLink={regionLink}
        typeCell={typeCell}
        routeCell={routeCell}
      />
      {tribute.length > 0 && (
        <div style={{ marginTop: '6px', color: INK_SOFT }}>
          Tribute from:{' '}
          {[...tribute].sort(byName).map((rid, i) => (
            <Fragment key={rid}>
              {i > 0 && ', '}
              {regionLink(rid)}
            </Fragment>
          ))}
        </div>
      )}

      <TradeSection
        title="Demand"
        help="Each region's share of the realm's demand. A raided region takes none of the Market's surplus at the Market dae."
        raidedHelp="of demand is raided, so that much of a surplus can't be traded away."
        links={demanders}
        ids={demandIds}
        shareTitle={(rid, share) =>
          `${regionName(rid)} takes ${share}% of the realm's demand for ${good?.name ?? id}.`
        }
        empty="No region demands it."
        data={data}
        regionLink={regionLink}
        typeCell={typeCell}
        routeCell={routeCell}
      />
    </div>
  );
};

const TradeSection = (props: {
  title: string;
  help: string;
  raidedHelp: string;
  links: Record<string, TradeLink>;
  ids: string[];
  shareTitle: (rid: string, share: number) => string;
  empty: string;
  data: Data;
  regionLink: (rid: string) => ReactNode;
  typeCell: (link: TradeLink) => ReactNode;
  routeCell: (rid: string) => ReactNode;
}) => {
  const { title, help, raidedHelp, links, ids, shareTitle, empty, data } = props;
  const raided = raidedPct(data, links);
  return (
    <>
      <div
        style={{
          ...subheadStyle,
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'baseline',
        }}
      >
        <span title={help} style={{ cursor: 'help' }}>
          {title}{' '}
          <span style={{ color: INK_SOFT, fontSize: FONT_SMALL }}>(?)</span>
        </span>
        {raided > 0 && (
          <span
            title={`${raided}% ${raidedHelp}`}
            style={{
              color: SEAL_RED,
              fontSize: FONT_BODY,
              fontWeight: 'normal',
              cursor: 'help',
            }}
          >
            {raided}% raided
          </span>
        )}
      </div>
      {ids.length ? (
        <div style={tradeGridStyle('auto auto auto minmax(0, 1fr)')}>
          {ids.map((rid) => {
            const state = data.region_caravan[rid];
            const share = links[rid].share ?? 0;
            return (
              <Fragment key={rid}>
                {props.regionLink(rid)}
                <span title={shareTitle(rid, share)} style={{ cursor: 'help' }}>
                  <ShareBar
                    share={share}
                    raided={!!state?.blockaded && !state?.escorted}
                  />
                </span>
                {props.typeCell(links[rid])}
                {props.routeCell(rid)}
              </Fragment>
            );
          })}
        </div>
      ) : (
        <div style={{ color: INK_FAINT }}>{empty}</div>
      )}
    </>
  );
};
