import { type CSSProperties, useState } from 'react';
import { ImageButton, Tooltip } from 'tgui-core/components';
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

type Recipe = {
  name: string;
  path: string;
  catalyst: string;
  input_text: string;
  output_text: string;
  materia_reqs: Record<string, string>;
  craftingdifficulty: string;
};

type Craftability = [string, number][];

type ActFn = (action: string, params?: Record<string, unknown>) => void;

type Data = {
  busy: number;
  showonlycraftable: number;
  craftability: Record<string, number>;
  catalysts: Record<string, string>;
  transmutation_recipes: Record<string, Recipe>;
  selectedcatalyst: string;
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

const TransRecipe = (props: {
  recipe: Recipe;
  craftable: boolean;
  act: ActFn;
}) => {
  const { recipe, craftable, act } = props;
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
          <RecipeDetail label="Needs:">{recipe.input_text}</RecipeDetail>
          <RecipeDetail label="Makes:">{recipe.output_text}</RecipeDetail>
          <RecipeDetail label="Materia:">
            {recipe.materia_reqs &&
              Object.entries(recipe.materia_reqs).map((m) => (
                <Tooltip key={m[0]} content={m[1]}>
                  {m[0]}
                </Tooltip>
              ))}
          </RecipeDetail>
          <RecipeDetail label="Skill required:">
            {recipe.craftingdifficulty}
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

export const TransCraft = () => {
  const { act, data } = useBackend<Data>();
  const craftability: Craftability | null = data.craftability
    ? Object.entries(data.craftability)
    : null;
  const selectedCatalyst: string = data.selectedcatalyst;

  return (
    <Window width={560} height={760} theme="parchment" title="Transmutation">
      <Window.Content scrollable>
        <div
          style={{
            display: 'block',
            position: 'relative',
            padding: '18px 28px 28px 8px',
            fontFamily: SERIF,
            color: INK,
            fontSize: FONT_BODY,
            lineHeight: 1.5,
          }}
        >
          <div
            style={{
              minWidth: 40,
              maxWidth: 40,
              minHeight: '530px',
              float: 'left',
              display: 'inline-block',
              borderWidth: '0px 2px 0px 0px',
              borderColor: 'black',
              borderStyle: 'double',
            }}
          >
            {data.catalysts &&
              Object.entries(data.catalysts).map((c) => {
                return (
                  <ImageButton
                    style={{
                      padding: 0,
                      margin: 0,
                      float: 'left',
                    }}
                    width="32px"
                    height="32px"
                    key={c[0]}
                    dmIcon="icons/roguetown/items/magic_resources.dmi"
                    dmIconState={c[1]}
                    imageSize={32}
                    tooltip={c[0]}
                    onClick={() => {
                      act('setcatalyst', { catalyst: c[0] });
                    }}
                  />
                );
              })}
          </div>
          <div
            style={{
              display: 'inline-block',
            }}
          >
            {data.transmutation_recipes
              ? Object.entries(data.transmutation_recipes)
                  .filter((k) => {
                    return k[1].catalyst === selectedCatalyst;
                  })
                  .map((r) => (
                    <TransRecipe
                      key={r[0]}
                      recipe={r[1]}
                      craftable={
                        craftability == null
                          ? true
                          : isCraftable(craftability, r[0])
                      }
                      act={act}
                    />
                  ))
              : 'Select a catalyst to view recipes.'}
            {selectedCatalyst ? '' : 'Select a catalyst to view recipes.'}
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};
