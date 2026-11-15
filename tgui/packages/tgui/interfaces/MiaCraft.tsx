import {
  type CSSProperties,
  useEffect,
  useMemo,
  useRef,
  useState,
} from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  FONT_BODY,
  FONT_LEAD,
  FONT_SMALL,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  inkInputStyle,
  PARCHMENT_SHADOW,
  pageStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SERIF,
  TITLE,
} from './common/parchment';
import { type PinMap, pinGlyph, pinTitle } from './common/pins';

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

type Craftability = [string, number][];

type ActFn = (action: string, params?: Record<string, unknown>) => void;

type Data = {
  busy: number;
  showonlycraftable: number;
  craftability: Record<string, number>;
  pins: PinMap;
  crafting_recipes: Record<string, Record<string, Recipe>>;
};

const isCraftable = (craftability: Craftability, name: string): boolean =>
  craftability.some((entry) => entry[0] === name && entry[1] === 1);

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

const CraftingRecipe = (props: {
  recipe: Recipe;
  craftable: boolean;
  pin?: string;
  act: ActFn;
}) => {
  const { recipe, craftable, pin, act } = props;
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
          onClick={() => act('cycle_pin', { path: recipe.path })}
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
};

const CraftingCategory = (props: {
  title: string;
  recipes: Record<string, Recipe>;
  onlyCraftable: boolean;
  craftability: Craftability;
  searchText: string;
  pins: PinMap;
  defaultOpen?: boolean;
  act: ActFn;
}) => {
  const {
    title,
    recipes,
    onlyCraftable,
    craftability,
    searchText,
    pins,
    defaultOpen,
    act,
  } = props;
  const [open, setOpen] = useState(!!defaultOpen);

  const visible = useMemo(
    () =>
      Object.values(recipes)
        .filter(
          (recipe) => !onlyCraftable || isCraftable(craftability, recipe.name),
        )
        .filter(
          (recipe) =>
            recipe.name.toLowerCase().includes(searchText) ||
            recipe.aliases.toLowerCase().includes(searchText),
        )
        .sort((a, b) => String(a.name).localeCompare(String(b.name))),
    [recipes, onlyCraftable, craftability, searchText],
  );

  if (visible.length === 0) {
    return null;
  }

  return (
    <div style={{ marginBottom: '6px' }}>
      <button
        type="button"
        style={{
          display: 'flex',
          alignItems: 'center',
          width: '100%',
          textAlign: 'left',
          fontFamily: SERIF,
          fontSize: FONT_LEAD,
          fontWeight: 'bold',
          color: TITLE,
          background: 'var(--p-card-bg)',
          border: `1px solid ${INK_FAINT}`,
          borderRadius: '2px',
          padding: '7px 12px',
          cursor: 'pointer',
        }}
        onClick={() => setOpen(!open)}
      >
        <span style={{ color: INK_SOFT, marginRight: '10px' }}>
          {open ? '▼' : '▶'}
        </span>
        {title}
        <span
          style={{ color: INK_SOFT, fontWeight: 'normal', marginLeft: '6px' }}
        >
          ({visible.length})
        </span>
      </button>
      {open && (
        <div style={{ padding: '2px 4px 4px 4px' }}>
          {visible.map((recipe) => (
            <CraftingRecipe
              key={recipe.path}
              recipe={recipe}
              craftable={isCraftable(craftability, recipe.name)}
              pin={pins[recipe.path]}
              act={act}
            />
          ))}
        </div>
      )}
    </div>
  );
};

export const MiaCraft = () => {
  const { act, data } = useBackend<Data>();
  const craftability: Craftability = Object.entries(data.craftability);
  const onlyCraftable = !!data.showonlycraftable;
  const [searchText, setSearchText] = useState('');
  const searchRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    searchRef.current?.focus();
  }, []);

  const pins = data.pins || {};

  // Every pinned recipe, gathered from all categories
  const pinnedRecipes = useMemo(() => {
    const out: Record<string, Recipe> = {};
    for (const recipes of Object.values(data.crafting_recipes)) {
      for (const recipe of Object.values(recipes)) {
        if (pins[recipe.path]) {
          out[recipe.path] = recipe;
        }
      }
    }
    return out;
  }, [data.crafting_recipes, pins]);

  const categories = useMemo(
    () =>
      Object.entries(data.crafting_recipes).sort(([a], [b]) =>
        String(a).localeCompare(String(b)),
      ),
    [data.crafting_recipes],
  );

  return (
    <Window width={560} height={760} theme="parchment" title="Crafting">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '8px',
              position: 'sticky',
              top: 0,
              zIndex: 1,
              background: 'var(--p-bg)',
              padding: '6px 0 8px 0',
              marginBottom: '4px',
            }}
          >
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
          </div>

          <CraftingCategory
            title="★ Pinned"
            recipes={pinnedRecipes}
            onlyCraftable={false}
            craftability={craftability}
            searchText={searchText}
            pins={pins}
            defaultOpen
            act={act}
          />

          {categories.map(([title, recipes]) => (
            <CraftingCategory
              key={title}
              title={title}
              recipes={recipes}
              onlyCraftable={onlyCraftable}
              craftability={craftability}
              searchText={searchText}
              pins={pins}
              act={act}
            />
          ))}
        </div>
      </Window.Content>
    </Window>
  );
};
