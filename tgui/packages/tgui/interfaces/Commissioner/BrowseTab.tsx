import { useEffect, useMemo, useState } from 'react';
import { Input } from 'tgui-core/components';

import {
  cardStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  SERIF,
} from '../common/parchment';
import type { ActFn, CommissionerData } from './types';

const ALL = '__all__';
const PAGE_SIZE = 40;

const DEFAULT_GROUP_ORDER = [
  'Armor',
  'Weapons',
  'Tools',
  'Valuables',
  'Decoration',
  'Engineering',
  'Other',
];

const groupFor = (category: string, order: string[]): string => {
  const paren = category.indexOf(' (');
  if (paren === -1) {
    return order.includes(category) ? category : 'Other';
  }
  const head = category.slice(0, paren);
  return order.includes(head) ? head : 'Other';
};

const starsIf = (text: string, canRead: boolean) =>
  canRead ? text : text.replace(/[A-Za-z0-9]/g, '*');

const railHeaderStyle = {
  fontFamily: SERIF,
  fontSize: FONT_BODY,
  color: SEAL_AMBER,
  marginBottom: '4px',
  marginTop: '4px',
};

const railRowStyle = (active: boolean, indent = false) => ({
  display: 'block',
  width: '100%',
  textAlign: 'left' as const,
  fontFamily: SERIF,
  fontSize: FONT_BODY,
  padding: indent ? '2px 8px 2px 20px' : '3px 8px',
  color: active ? INK : INK_FAINT,
  background: active ? 'rgba(200,170,100,0.25)' : 'transparent',
  border: `1px solid ${active ? INK_SOFT : 'transparent'}`,
  borderRadius: '2px',
  cursor: 'pointer',
  fontWeight: active ? ('bold' as const) : ('normal' as const),
  marginBottom: '2px',
});

const groupHeaderStyle = (active: boolean) => ({
  ...railRowStyle(active),
  color: active ? INK : INK_SOFT,
  fontWeight: 'bold' as const,
});

export const BrowseTab = (props: {
  data: CommissionerData;
  act: ActFn;
  canRead: boolean;
}) => {
  const { data, act, canRead } = props;
  const [category, setCategory] = useState<string>(ALL);
  const [ingot, setIngot] = useState<string>(ALL);
  const [search, setSearch] = useState('');
  const [page, setPage] = useState(0);
  const [openGroups, setOpenGroups] = useState<Record<string, boolean>>({});

  const groupOrder =
    data.group_order && data.group_order.length > 0
      ? data.group_order
      : DEFAULT_GROUP_ORDER;

  const grouped = useMemo(() => {
    const byGroup: Record<string, string[]> = {};
    for (const cat of data.categories) {
      const g = groupFor(cat, groupOrder);
      if (!byGroup[g]) byGroup[g] = [];
      byGroup[g].push(cat);
    }
    for (const g of Object.keys(byGroup)) byGroup[g].sort();
    return byGroup;
  }, [data.categories, groupOrder]);

  const activeGroup = category === ALL ? null : groupFor(category, groupOrder);

  useEffect(() => {
    if (activeGroup && !openGroups[activeGroup]) {
      setOpenGroups((prev) => ({ ...prev, [activeGroup]: true }));
    }
  }, [activeGroup, openGroups]);

  const toggleGroup = (g: string) => {
    setOpenGroups((prev) => ({ ...prev, [g]: !prev[g] }));
  };

  const filtered = useMemo(() => {
    const needle = search.toLowerCase();
    return data.catalog.filter((entry) => {
      if (category !== ALL && entry.category !== category) return false;
      if (ingot !== ALL && entry.ingot !== ingot) return false;
      if (needle && !entry.name.toLowerCase().includes(needle)) return false;
      return true;
    });
  }, [data.catalog, category, ingot, search]);

  useEffect(() => {
    setPage(0);
  }, [category, ingot, search]);

  const manifestQty: Record<string, number> = useMemo(() => {
    const m: Record<string, number> = {};
    for (const line of data.manifest) m[line.ref] = line.qty;
    return m;
  }, [data.manifest]);

  const totalPages = Math.max(1, Math.ceil(filtered.length / PAGE_SIZE));
  const safePage = Math.min(page, totalPages - 1);
  const start = safePage * PAGE_SIZE;
  const displayed = filtered.slice(start, start + PAGE_SIZE);

  return (
    <div style={{ display: 'flex', gap: '12px', alignItems: 'flex-start' }}>
      <div
        style={{
          flex: '0 0 180px',
          borderRight: `1px solid ${PARCHMENT_SHADOW}`,
          paddingRight: '8px',
        }}
      >
        <div style={railHeaderStyle}>Category</div>
        <button
          type="button"
          style={railRowStyle(category === ALL)}
          onClick={() => setCategory(ALL)}
        >
          All ({data.catalog.length})
        </button>
        {groupOrder.map((g) => {
          const cats = grouped[g];
          if (!cats || cats.length === 0) return null;
          const expanded = !!openGroups[g];
          const groupActive = activeGroup === g;
          return (
            <div key={g}>
              <button
                type="button"
                style={groupHeaderStyle(groupActive)}
                onClick={() => toggleGroup(g)}
              >
                {expanded ? '▾ ' : '▸ '}
                {g}
              </button>
              {expanded &&
                cats.map((cat) => (
                  <button
                    type="button"
                    key={cat}
                    style={railRowStyle(category === cat, true)}
                    onClick={() => setCategory(cat)}
                  >
                    {cat.includes(' (')
                      ? cat.slice(cat.indexOf('(') + 1, -1)
                      : cat}
                  </button>
                ))}
            </div>
          );
        })}

        {data.ingots.length > 0 && (
          <>
            <div style={{ ...railHeaderStyle, marginTop: '12px' }}>
              Material
            </div>
            <button
              type="button"
              style={railRowStyle(ingot === ALL)}
              onClick={() => setIngot(ALL)}
            >
              Any
            </button>
            {data.ingots.map((ing) => (
              <button
                type="button"
                key={ing}
                style={railRowStyle(ingot === ing)}
                onClick={() => setIngot(ing)}
              >
                {ing}
              </button>
            ))}
          </>
        )}
      </div>

      <div style={{ flex: 1, minWidth: 0 }}>
        <div
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '8px',
            marginBottom: '8px',
          }}
        >
          <span
            style={{
              fontFamily: SERIF,
              fontSize: FONT_BODY,
              color: INK_SOFT,
            }}
          >
            Search:
          </span>
          <Input
            value={search}
            onChange={setSearch}
            placeholder="Filter by name..."
            width="100%"
          />
          {!!search && (
            <button
              type="button"
              style={inkButtonStyle()}
              onClick={() => setSearch('')}
            >
              Clear
            </button>
          )}
        </div>

        {displayed.length === 0 ? (
          <div
            style={{
              ...cardStyle,
              textAlign: 'center',
              color: INK_SOFT,
            }}
          >
            {data.catalog.length === 0
              ? 'No recipes available.'
              : 'No recipes match the filter.'}
          </div>
        ) : (
          <>
            <div
              style={{
                columnCount: 2,
                columnGap: '12px',
              }}
            >
              {displayed.map((entry) => {
                const inManifest = manifestQty[entry.ref] || 0;
                return (
                  <div
                    key={entry.ref}
                    style={{
                      breakInside: 'avoid',
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
                          fontSize: FONT_BODY,
                          color: INK,
                          overflow: 'hidden',
                          textOverflow: 'ellipsis',
                        }}
                      >
                        {starsIf(entry.name, canRead)}
                      </div>
                      {category === ALL && (
                        <div
                          style={{
                            fontSize: FONT_BODY,
                            color: INK_SOFT,
                          }}
                        >
                          {entry.category}
                        </div>
                      )}
                    </div>
                    <div
                      style={{
                        flex: '0 0 auto',
                        textAlign: 'right',
                        fontSize: FONT_BODY,
                        color: SEAL_AMBER,
                        fontWeight: 'bold',
                      }}
                    >
                      {entry.price}m
                    </div>
                    {inManifest > 0 && (
                      <div
                        style={{
                          flex: '0 0 auto',
                          fontSize: FONT_BODY,
                          color: INK_SOFT,
                        }}
                      >
                        x{inManifest}
                      </div>
                    )}
                    <button
                      type="button"
                      style={inkButtonStyle()}
                      onClick={() =>
                        act('manifest_inc', { ref: entry.ref, delta: 1 })
                      }
                    >
                      +
                    </button>
                  </div>
                );
              })}
            </div>
            {totalPages > 1 && (
              <div
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  gap: '8px',
                  marginTop: '8px',
                  fontFamily: SERIF,
                  fontSize: FONT_BODY,
                  color: INK_FAINT,
                }}
              >
                <button
                  type="button"
                  style={inkButtonStyle({ disabled: safePage <= 0 })}
                  disabled={safePage <= 0}
                  onClick={() => setPage(safePage - 1)}
                >
                  Prev
                </button>
                <span>
                  Page {safePage + 1} of {totalPages} ({filtered.length} wares)
                </span>
                <button
                  type="button"
                  style={inkButtonStyle({
                    disabled: safePage >= totalPages - 1,
                  })}
                  disabled={safePage >= totalPages - 1}
                  onClick={() => setPage(safePage + 1)}
                >
                  Next
                </button>
              </div>
            )}
          </>
        )}
      </div>
    </div>
  );
};
