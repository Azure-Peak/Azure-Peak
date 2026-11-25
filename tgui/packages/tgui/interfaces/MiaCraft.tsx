import { type CSSProperties, memo, useMemo, useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  FONT_BODY,
  FONT_SMALL,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  SEAL_GREEN,
  SERIF,
} from './common/parchment';
import { type PinData, pinGlyph, pinTitle, usePinSync } from './common/pins';
import { RecipeBrowser } from './common/RecipeBrowser';

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
  const pins = data.pins || {};
  const cyclePin = usePinSync(act, 'crafting', data);
  const craftable = (name: string) => data.craftability[name] === 1;

  const entries = useMemo(() => {
    const out: CraftEntry[] = [];
    for (const [category, recipes] of Object.entries(data.crafting_recipes)) {
      for (const recipe of Object.values(recipes)) {
        out.push({ ...recipe, category });
      }
    }
    return out;
  }, [data.crafting_recipes]);

  return (
    <Window width={720} height={760} theme="parchment" title="Crafting">
      <Window.Content>
        <RecipeBrowser
          menu="crafting"
          recipes={entries}
          pins={pins}
          pinsReady={!!data.pins_imported}
          autoFocusSearch
          listed={(recipe) => !onlyCraftable || craftable(recipe.name)}
          matches={(recipe, needle) =>
            recipe.name.toLowerCase().includes(needle) ||
            recipe.aliases.toLowerCase().includes(needle)
          }
          renderRow={(recipe) => (
            <CraftingRecipe
              recipe={recipe}
              craftable={craftable(recipe.name)}
              pin={pins[recipe.path]}
              act={act}
              cyclePin={cyclePin}
            />
          )}
          headerExtra={
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
          }
        />
      </Window.Content>
    </Window>
  );
};
