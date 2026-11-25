import {
  Fragment,
  type ReactNode,
  useEffect,
  useMemo,
  useRef,
  useState,
} from 'react';

import { IncrementalList } from './IncrementalList';
import { inkInputStyle } from './parchment';
import { type PinMap, pinnedFirst } from './pins';
import {
  buildGroupedRail,
  compareGroupedCategories,
  groupOf,
  RAIL_ALL,
  RAIL_PINNED,
  type RailNode,
  RecipeRail,
  RecipeRailLayout,
  recipeEmptyStyle,
  recipeGroupHeaderStyle,
} from './RecipeRail';

export type BrowsableRecipe = {
  path: string;
  name: string;
  category: string;
};

const matchesName = (recipe: BrowsableRecipe, needle: string) =>
  recipe.name.toLowerCase().includes(needle);

export const RecipeBrowser = <T extends BrowsableRecipe>(props: {
  recipes: T[];
  pins: PinMap;
  renderRow: (recipe: T) => ReactNode;
  listed?: (recipe: T) => boolean;
  matches?: (recipe: T, needle: string) => boolean;
  groupOrder?: string[];
  headerExtra?: ReactNode;
  autoFocusSearch?: boolean;
  pinnedOnTop?: boolean;
}) => {
  const {
    recipes,
    pins,
    renderRow,
    listed,
    matches = matchesName,
    groupOrder,
    headerExtra,
    autoFocusSearch,
    pinnedOnTop,
  } = props;
  const [view, setView] = useState<string>(RAIL_ALL);
  const [search, setSearch] = useState('');
  const searchRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    if (autoFocusSearch) {
      searchRef.current?.focus();
    }
  }, []);

  const sorted = useMemo(
    () =>
      [...recipes].sort((a, b) => String(a.name).localeCompare(String(b.name))),
    [recipes],
  );

  const categories = useMemo(
    () =>
      Array.from(new Set(sorted.map((recipe) => recipe.category))).sort(
        groupOrder
          ? compareGroupedCategories(groupOrder)
          : (a, b) => a.localeCompare(b),
      ),
    [sorted, groupOrder],
  );

  const visible = listed ? sorted.filter(listed) : sorted;
  const pinned = sorted.filter((recipe) => pins[recipe.path]);
  const needle = search.trim().toLowerCase();

  const counts: Record<string, number> = {};
  for (const recipe of visible) {
    counts[recipe.category] = (counts[recipe.category] || 0) + 1;
  }

  const railCategories = categories.filter(
    (category) => counts[category] || category === view,
  );
  const nodes: RailNode[] = [
    { key: RAIL_PINNED, label: '★ Pinned', count: pinned.length },
    { key: RAIL_ALL, label: 'All', count: visible.length },
    ...(groupOrder
      ? buildGroupedRail(railCategories, counts)
      : railCategories.map((category) => ({
          key: category,
          label: category,
          count: counts[category] || 0,
        }))),
  ];

  let shown: T[];
  if (needle) {
    shown = visible.filter((recipe) => matches(recipe, needle));
  } else if (view === RAIL_PINNED) {
    shown = pinned;
  } else if (view === RAIL_ALL) {
    shown = visible;
  } else {
    shown = visible.filter(
      (recipe) =>
        recipe.category === view ||
        (!!groupOrder && groupOf(recipe.category) === view),
    );
  }
  shown = [...shown].sort(pinnedFirst(pins));

  const items: ReactNode[] = [];
  const row = (recipe: T) => (
    <Fragment key={recipe.path}>{renderRow(recipe)}</Fragment>
  );
  if (!needle && categories.includes(view)) {
    items.push(...shown.map(row));
  } else {
    const leadPinned = pinnedOnTop && view !== RAIL_PINNED;
    if (leadPinned) {
      const lead = shown.filter((recipe) => pins[recipe.path]);
      if (lead.length) {
        items.push(
          <div key="header:pinned" style={recipeGroupHeaderStyle}>
            ★ Pinned
          </div>,
          ...lead.map(row),
        );
      }
    }
    const buckets: Record<string, T[]> = {};
    for (const recipe of shown) {
      if (leadPinned && pins[recipe.path]) {
        continue;
      }
      if (!buckets[recipe.category]) {
        buckets[recipe.category] = [];
      }
      buckets[recipe.category].push(recipe);
    }
    for (const category of categories) {
      if (!buckets[category]) {
        continue;
      }
      items.push(
        <div key={`header:${category}`} style={recipeGroupHeaderStyle}>
          {category}
        </div>,
        ...buckets[category].map(row),
      );
    }
  }

  const listKey = `${view}|${needle}`;

  return (
    <RecipeRailLayout
      scrollKey={listKey}
      header={
        <>
          <input
            ref={searchRef}
            style={{ ...inkInputStyle, flex: 1 }}
            placeholder="Search..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
          {headerExtra}
        </>
      }
      rail={
        <RecipeRail
          nodes={nodes}
          selected={needle ? null : view}
          onSelect={(key) => {
            setView(key);
            setSearch('');
          }}
        />
      }
    >
      {items.length ? (
        <IncrementalList key={listKey}>{items}</IncrementalList>
      ) : (
        <div style={recipeEmptyStyle}>
          {view === RAIL_PINNED && !needle
            ? 'No pinned recipes.'
            : 'No recipes found.'}
        </div>
      )}
    </RecipeRailLayout>
  );
};
