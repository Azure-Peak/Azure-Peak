import { memo, useMemo } from 'react';
import { Box, DmIcon, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  FONT_BODY,
  INK,
  INK_FAINT,
  inkButtonStyle,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  SERIF,
} from './common/parchment';
import { type PinData, pinGlyph, pinTitle, usePinSync } from './common/pins';
import { RecipeBrowser } from './common/RecipeBrowser';
import { SMITHING_GROUP_ORDER } from './common/RecipeRail';

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
  const { recipes, hingot_type } = data;
  const pins = data.pins || {};
  const cyclePin = usePinSync(act, 'anvil', data);

  const available = useMemo(
    () =>
      recipes.filter(
        (recipe) =>
          recipe.req_bar === hingot_type || recipe.req_blade === hingot_type,
      ),
    [recipes, hingot_type],
  );

  return (
    <RecipeBrowser
      menu="anvil"
      recipes={available}
      pins={pins}
      pinsReady={!!data.pins_imported}
      groupOrder={SMITHING_GROUP_ORDER}
      renderRow={(recipe) => (
        <AnvilRecipe
          recipe={recipe}
          pin={pins[recipe.path]}
          act={act}
          cyclePin={cyclePin}
        />
      )}
    />
  );
};
