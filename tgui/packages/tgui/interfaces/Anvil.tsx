import { type Dispatch, type SetStateAction, useState } from 'react';
import {
  Box,
  Button,
  DmIcon,
  Input,
  Section,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { type PinMap, pinGlyph, pinTitle, usePinSync } from './common/pins';

type Recipe = {
  name: string;
  category: string;
  req_bar: string;
  req_blade: string;
  ref: string;
  path: string;
  icon: string;
};

type Data = {
  hingot_type?: string | null;
  pins?: PinMap;
  pin_key?: string | null;
  recipes: Recipe[];
};

export const Anvil = () => {
  const { data } = useBackend<Data>();

  if (!data.hingot_type) {
    return (
      <Window width={400} height={400}>
        <Window.Content>
          <LonelyAnvil />
        </Window.Content>
      </Window>
    );
  }

  return (
    <Window width={600} height={400}>
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

export const SearchBar = (props: {
  search: string;
  setSearch: Dispatch<SetStateAction<string>>;
}) => {
  const { search, setSearch } = props;
  return <Input value={search} onChange={setSearch} fluid />;
};

export const RecipeDisplay = () => {
  const [search, setSearch] = useState('');

  const { act, data } = useBackend<Data>();

  const { recipes, hingot_type } = data;
  const pins = data.pins || {};
  const cyclePin = usePinSync(act, 'anvil', data.pin_key, pins);

  const availableRecipes = recipes
    .filter((recipe) => {
      return recipe.req_bar === hingot_type || recipe.req_blade === hingot_type;
    })
    .filter((recipe) => {
      if (search) {
        return recipe.name.toLowerCase().includes(search.toLowerCase());
      } else {
        return true;
      }
    })
    .sort(
      (a, b) =>
        Number(!!pins[b.path]) - Number(!!pins[a.path]) ||
        (a.category || '').localeCompare(b.category || '') ||
        (a.name || '').localeCompare(b.name || ''),
    );

  return (
    <Section
      title="Recipes"
      fill
      scrollable
      buttons={<SearchBar search={search} setSearch={setSearch} />}
    >
      {availableRecipes.map((recipe) => (
        <Stack key={recipe.ref} align="center" mb={0.5}>
          <Stack.Item grow>
            <Button
              fluid
              onClick={() => act('choose_recipe', { ref: recipe.ref })}
            >
              <Stack align="center">
                <Stack.Item>
                  <Box className={recipe.icon} mr={2} inline />
                </Stack.Item>
                <Stack.Item>
                  {recipe.category} - {recipe.name}
                </Stack.Item>
              </Stack>
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              tooltip={pinTitle(pins[recipe.path])}
              color={pins[recipe.path] ? 'good' : 'transparent'}
              onClick={() => cyclePin(recipe.path)}
            >
              {pinGlyph(pins[recipe.path])}
            </Button>
          </Stack.Item>
        </Stack>
      ))}
    </Section>
  );
};
