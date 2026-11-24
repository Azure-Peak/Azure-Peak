import { memo, type ReactNode, useState } from 'react';
import { Box, DmIcon, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  FONT_BODY,
  INK,
  INK_FAINT,
  inkButtonStyle,
  inkInputStyle,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  SERIF,
} from './common/parchment';
import {
  type PinData,
  pinGlyph,
  pinnedFirst,
  pinTitle,
  usePinSync,
} from './common/pins';
import {
  RAIL_ALL,
  RAIL_PINNED,
  type RailNode,
  RecipeRail,
  RecipeRailLayout,
  recipeEmptyStyle,
  recipeGroupHeaderStyle,
} from './common/RecipeRail';

type Recipe = {
  name: string;
  category: string;
  req_bar: string;
  req_blade: string;
  ref: string;
  path: string;
  icon: string;
};

type ActFn = (action: string, params?: Record<string, unknown>) => void;

type Data = PinData & {
  hingot_type?: string | null;
  recipes: Recipe[];
};

const GROUP_ORDER = [
  'Armor',
  'Weapons',
  'Tools',
  'Valuables',
  'Decoration',
  'Engineering',
];

const groupOf = (category: string) => {
  const paren = category.indexOf(' (');
  return paren === -1 ? category : category.slice(0, paren);
};

const subcategoryOf = (category: string) => {
  const paren = category.indexOf(' (');
  return paren === -1 ? category : category.slice(paren + 2, -1);
};

const groupRank = (group: string) => {
  const rank = GROUP_ORDER.indexOf(group);
  return rank === -1 ? GROUP_ORDER.length : rank;
};

const compareCategories = (a: string, b: string) =>
  groupRank(groupOf(a)) - groupRank(groupOf(b)) || a.localeCompare(b);

const buildRail = (categories: string[], counts: Record<string, number>) => {
  const groups: string[] = [];
  const members: Record<string, string[]> = {};
  for (const category of categories) {
    const group = groupOf(category);
    if (!members[group]) {
      members[group] = [];
      groups.push(group);
    }
    members[group].push(category);
  }
  return groups.map((group): RailNode => {
    const cats = members[group];
    if (cats.length === 1) {
      return { key: cats[0], label: cats[0], count: counts[cats[0]] };
    }
    return {
      key: group,
      label: group,
      count: cats.reduce((sum, category) => sum + counts[category], 0),
      children: cats.map((category) => ({
        key: category,
        label: subcategoryOf(category),
        count: counts[category],
      })),
    };
  });
};

export const Anvil = () => {
  const { data } = useBackend<Data>();

  if (!data.hingot_type) {
    return (
      <Window width={400} height={400} theme="parchment">
        <Window.Content>
          <LonelyAnvil />
        </Window.Content>
      </Window>
    );
  }

  return (
    <Window width={640} height={540} theme="parchment">
      <Window.Content>
        <RecipeDisplay />
      </Window.Content>
    </Window>
  );
};

export const LonelyAnvil = () => {
  return (
    <Stack align="center" justify="center" fill>
      <Stack.Item>
        <Stack vertical align="center" justify="center">
          <Stack.Item fontSize={2}>This Anvil Sits Idle.</Stack.Item>
          <Stack.Item>
            <DmIcon
              icon="icons/roguetown/misc/forge.dmi"
              icon_state="anvil"
              width={16}
              height={16}
            />
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

const AnvilRecipe = memo((props: {
  recipe: Recipe;
  pin?: string;
  act: ActFn;
  cyclePin: (path: string) => void;
}) => {
  const { recipe, pin, act, cyclePin } = props;
  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'center',
        gap: '8px',
        padding: '3px 4px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
      }}
    >
      <button
        type="button"
        style={inkButtonStyle({ color: pin ? SEAL_AMBER : INK_FAINT })}
        title={pinTitle(pin)}
        onClick={() => cyclePin(recipe.path)}
      >
        {pinGlyph(pin)}
      </button>
      <button
        type="button"
        className="toc-link"
        style={{
          flex: 1,
          display: 'flex',
          alignItems: 'center',
          gap: '8px',
          textAlign: 'left',
          background: 'transparent',
          border: 'none',
          fontFamily: SERIF,
          fontSize: FONT_BODY,
          color: INK,
          cursor: 'pointer',
          padding: '2px 0',
        }}
        onClick={() => act('choose_recipe', { ref: recipe.ref })}
      >
        <Box className={recipe.icon} inline />
        {recipe.name}
      </button>
    </div>
  );
});

export const RecipeDisplay = () => {
  const { act, data } = useBackend<Data>();
  const [search, setSearch] = useState('');
  const [view, setView] = useState<string>(RAIL_ALL);

  const { recipes, hingot_type } = data;
  const pins = data.pins || {};
  const cyclePin = usePinSync(act, 'anvil', data);

  const available = recipes
    .filter(
      (recipe) =>
        recipe.req_bar === hingot_type || recipe.req_blade === hingot_type,
    )
    .sort((a, b) => (a.name || '').localeCompare(b.name || ''));

  const counts: Record<string, number> = {};
  for (const recipe of available) {
    counts[recipe.category] = (counts[recipe.category] || 0) + 1;
  }
  const categories = Object.keys(counts).sort(compareCategories);

  const pinned = available.filter((recipe) => pins[recipe.path]);

  const nodes: RailNode[] = [
    { key: RAIL_PINNED, label: '★ Pinned', count: pinned.length },
    { key: RAIL_ALL, label: 'All', count: available.length },
    ...buildRail(categories, counts),
  ];

  const needle = search.toLowerCase();
  let shown: Recipe[];
  if (needle) {
    shown = available.filter((recipe) =>
      recipe.name.toLowerCase().includes(needle),
    );
  } else if (view === RAIL_PINNED) {
    shown = pinned;
  } else if (view === RAIL_ALL) {
    shown = available;
  } else {
    shown = available.filter(
      (recipe) => recipe.category === view || groupOf(recipe.category) === view,
    );
  }
  shown = [...shown].sort(pinnedFirst(pins));

  const grouped = !!needle || counts[view] === undefined;

  const renderRecipe = (recipe: Recipe) => (
    <AnvilRecipe
      key={recipe.ref}
      recipe={recipe}
      pin={pins[recipe.path]}
      act={act}
      cyclePin={cyclePin}
    />
  );

  let body: ReactNode;
  if (!shown.length) {
    body = (
      <div style={recipeEmptyStyle}>
        {view === RAIL_PINNED && !needle
          ? 'No pinned recipes.'
          : 'No recipes found.'}
      </div>
    );
  } else if (!grouped) {
    body = shown.map(renderRecipe);
  } else {
    body = categories.map((category) => {
      const rows = shown.filter((recipe) => recipe.category === category);
      if (!rows.length) {
        return null;
      }
      return (
        <div key={category}>
          <div style={recipeGroupHeaderStyle}>{category}</div>
          {rows.map(renderRecipe)}
        </div>
      );
    });
  }

  return (
    <RecipeRailLayout
      header={
        <input
          style={{ ...inkInputStyle, flex: 1 }}
          placeholder="Search..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
        />
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
      {body}
    </RecipeRailLayout>
  );
};
