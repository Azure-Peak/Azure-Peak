import {
  type CSSProperties,
  memo,
  type ReactNode,
  useEffect,
  useMemo,
  useRef,
  useState,
} from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  FONT_BODY,
  FONT_SMALL,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  inkInputStyle,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  SEAL_GREEN,
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
  path: string;
  aliases: string;
  req_text: string;
  tool_text: string;
  catalyst_text: string;
  craftingdifficulty: string;
  sellprice: number;
  has_item_quality: number;
};

type CraftEntry = Recipe & { category: string };

type ActFn = (action: string, params?: Record<string, unknown>) => void;

type Data = PinData & {
  busy: number;
  showonlycraftable: number;
  craftability: Record<string, number>;
  crafting_recipes: Record<string, Record<string, Recipe>>;
};

const labelStyle: CSSProperties = {
  flex: '0 0 130px',
  color: SEAL_AMBER,
  fontWeight: 500,
};

const detailRowStyle: CSSProperties = {
  display: 'flex',
  padding: '3px 0',
  fontSize: FONT_BODY,
  lineHeight: 1.4,
};

const RecipeDetail = (props: { label: string; children: React.ReactNode }) => (
  <div style={detailRowStyle}>
    <div style={labelStyle}>{props.label}</div>
    <div style={{ flex: 1, color: INK }}>{props.children}</div>
  </div>
);

const CRAFT_AMOUNTS: { label: string; params: Record<string, unknown> }[] = [
  { label: '1x', params: {} },
  { label: '2x', params: { amount: 2 } },
  { label: '3x', params: { amount: 3 } },
  { label: '5x', params: { amount: 5 } },
  { label: '∞', params: { auto: true } },
];

const CraftingRecipe = memo((props: {
  recipe: Recipe;
  craftable: boolean;
  pin?: string;
  act: ActFn;
  cyclePin: (path: string) => void;
}) => {
  const { recipe, craftable, pin, act, cyclePin } = props;
  const [open, setOpen] = useState(false);

  const craft = (extra: Record<string, unknown>) =>
    act('craft', { item: recipe.path, ...extra });

  return (
    <div
      style={{
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        opacity: craftable ? 1 : 0.55,
      }}
    >
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: '8px',
          padding: '5px 4px',
        }}
      >
        <button
          type="button"
          style={inkButtonStyle({ color: craftable ? SEAL_GREEN : INK_FAINT })}
          title="Craft one"
          onClick={() => craft({})}
        >
          &#128296;
        </button>
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
          style={{
            flex: 1,
            textAlign: 'left',
            background: 'transparent',
            border: 'none',
            fontFamily: SERIF,
            fontSize: FONT_BODY,
            color: INK,
            cursor: 'pointer',
            padding: '2px 0',
          }}
          onClick={() => setOpen(!open)}
        >
          <span style={{ color: INK_SOFT, marginRight: '6px' }}>
            {open ? '▼' : '▶'}
          </span>
          {recipe.name}
          {!craftable && (
            <span style={{ color: INK_FAINT, fontSize: FONT_SMALL }}>
              {' '}
              - missing materials
            </span>
          )}
        </button>
      </div>
      {open && (
        <div
          style={{
            padding: '2px 4px 8px 8px',
          }}
        >
          {recipe.aliases && (
            <RecipeDetail label="Also known as">{recipe.aliases}</RecipeDetail>
          )}
          <RecipeDetail label="Ingredients">{recipe.req_text}</RecipeDetail>
          <RecipeDetail label="Difficulty">
            {recipe.craftingdifficulty}
          </RecipeDetail>
          {recipe.tool_text && (
            <RecipeDetail label="Tool">{recipe.tool_text}</RecipeDetail>
          )}
          {recipe.catalyst_text && (
            <RecipeDetail label="Catalyst">{recipe.catalyst_text}</RecipeDetail>
          )}
          <RecipeDetail label="Sell price">
            {recipe.sellprice || '-'}
            {!!recipe.has_item_quality && !!recipe.sellprice && (
              <span style={{ color: INK_SOFT, marginLeft: '6px' }}>
                (varies {Math.max(1, Math.round(recipe.sellprice * 0.2))}-
                {Math.round(recipe.sellprice * 1.35)} by quality)
              </span>
            )}
          </RecipeDetail>
          <div
            style={{
              display: 'flex',
              gap: '5px',
              marginTop: '6px',
              flexWrap: 'wrap',
            }}
          >
            {CRAFT_AMOUNTS.map((amt) => (
              <button
                key={amt.label}
                type="button"
                style={inkButtonStyle()}
                onClick={() => craft(amt.params)}
              >
                {amt.label}
              </button>
            ))}
          </div>
        </div>
      )}
    </div>
  );
});

export const MiaCraft = () => {
  const { act, data } = useBackend<Data>();
  const onlyCraftable = !!data.showonlycraftable;
  const [searchText, setSearchText] = useState('');
  const [view, setView] = useState<string>(RAIL_ALL);
  const searchRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    searchRef.current?.focus();
  }, []);

  const pins = data.pins || {};
  const cyclePin = usePinSync(act, 'crafting', data);
  const craftable = (name: string) => data.craftability[name] === 1;

  const categories = useMemo(
    () =>
      Object.keys(data.crafting_recipes).sort((a, b) => a.localeCompare(b)),
    [data.crafting_recipes],
  );

  const entries = useMemo(() => {
    const out: CraftEntry[] = [];
    for (const category of categories) {
      for (const recipe of Object.values(data.crafting_recipes[category])) {
        out.push({ ...recipe, category });
      }
    }
    return out.sort((a, b) => String(a.name).localeCompare(String(b.name)));
  }, [data.crafting_recipes, categories]);

  const listed = entries.filter(
    (recipe) => !onlyCraftable || craftable(recipe.name),
  );
  const pinned = entries.filter((recipe) => pins[recipe.path]);

  const counts: Record<string, number> = {};
  for (const recipe of listed) {
    counts[recipe.category] = (counts[recipe.category] || 0) + 1;
  }

  const nodes: RailNode[] = [
    { key: RAIL_PINNED, label: '★ Pinned', count: pinned.length },
    { key: RAIL_ALL, label: 'All', count: listed.length },
    ...categories
      .filter((category) => counts[category] || category === view)
      .map((category) => ({
        key: category,
        label: category,
        count: counts[category] || 0,
      })),
  ];

  let shown: CraftEntry[];
  if (searchText) {
    shown = listed.filter(
      (recipe) =>
        recipe.name.toLowerCase().includes(searchText) ||
        recipe.aliases.toLowerCase().includes(searchText),
    );
  } else if (view === RAIL_PINNED) {
    shown = pinned;
  } else if (view === RAIL_ALL) {
    shown = listed;
  } else {
    shown = listed.filter((recipe) => recipe.category === view);
  }
  shown = [...shown].sort(pinnedFirst(pins));

  const grouped = !!searchText || view === RAIL_PINNED || view === RAIL_ALL;

  const renderRecipe = (recipe: CraftEntry) => (
    <CraftingRecipe
      key={recipe.path}
      recipe={recipe}
      craftable={craftable(recipe.name)}
      pin={pins[recipe.path]}
      act={act}
      cyclePin={cyclePin}
    />
  );

  let body: ReactNode;
  if (!shown.length) {
    body = (
      <div style={recipeEmptyStyle}>
        {view === RAIL_PINNED && !searchText
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
    <Window width={720} height={760} theme="parchment" title="Crafting">
      <Window.Content>
        <RecipeRailLayout
          header={
            <>
              <input
                ref={searchRef}
                style={{ ...inkInputStyle, flex: 1 }}
                placeholder="Search..."
                value={searchText}
                onChange={(e) => setSearchText(e.target.value.toLowerCase())}
              />
              <button
                type="button"
                style={{
                  ...inkButtonStyle({
                    color: onlyCraftable ? SEAL_GREEN : INK_SOFT,
                  }),
                  display: 'flex',
                  alignItems: 'center',
                  whiteSpace: 'nowrap',
                }}
                onClick={() =>
                  act('checkboxonlycraftable', { state: !onlyCraftable })
                }
              >
                <span
                  style={{
                    display: 'inline-block',
                    width: '12px',
                    textAlign: 'center',
                    marginRight: '4px',
                  }}
                >
                  {onlyCraftable ? '✓' : ''}
                </span>
                Craftable only
              </button>
            </>
          }
          rail={
            <RecipeRail
              nodes={nodes}
              selected={searchText ? null : view}
              onSelect={(key) => {
                setView(key);
                setSearchText('');
              }}
            />
          }
        >
          {body}
        </RecipeRailLayout>
      </Window.Content>
    </Window>
  );
};
