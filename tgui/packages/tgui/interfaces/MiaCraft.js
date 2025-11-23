import { useMemo, useState } from 'react';
import {
  Button,
  Collapsible,
  Input,
  LabeledList,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

/* ---------------------------------------------
 * CraftingRecipe (optimized)
 * --------------------------------------------- */
const CraftingRecipe = ({ recipe, craftableSet, actfunc }) => {
  const isCraftable = craftableSet.has(recipe.name);

  return (
    <Stack>
      <Stack.Item>
        <Button
          content="🛠"
          onClick={() =>
            actfunc('craft', {
              item: recipe.path,
            })
          }
        />
      </Stack.Item>

      <Stack.Item basis="80%">
        <Collapsible
          title={recipe.name}
          style={{ backgroundColor: isCraftable ? '' : 'grey' }}
        >
          <LabeledList>
            <LabeledList.Item label="Ingredients" style={{ marginLeft: 20 }}>
              {recipe.req_text}
            </LabeledList.Item>

            <LabeledList.Item label="Difficulty" style={{ marginLeft: 20 }}>
              {recipe.craftingdifficulty}
            </LabeledList.Item>

            {recipe.tool_text && (
              <LabeledList.Item label="Tool" style={{ marginLeft: 20 }}>
                {recipe.tool_text}
              </LabeledList.Item>
            )}

            {recipe.catalyst_text && (
              <LabeledList.Item label="Catalyst" style={{ marginLeft: 20 }}>
                {recipe.catalyst_text}
              </LabeledList.Item>
            )}

            <LabeledList.Item label="Sell Price" style={{ marginLeft: 20 }}>
              {recipe.sellprice}
            </LabeledList.Item>

            <LabeledList.Item
              label="Craft it!"
              style={{ marginLeft: 20, gap: '4px' }}
            >
              {[1, 2, 3, 5].map((amount) => (
                <Button
                  key={amount}
                  content={`${amount}x`}
                  onClick={() =>
                    actfunc('craft', {
                      item: recipe.path,
                      amount,
                    })
                  }
                />
              ))}

              <Button
                content="∞"
                onClick={() =>
                  actfunc('craft', {
                    item: recipe.path,
                    auto: true,
                  })
                }
              />
            </LabeledList.Item>
          </LabeledList>
        </Collapsible>
      </Stack.Item>
    </Stack>
  );
};

/* ---------------------------------------------
 * CraftingCategory (optimized)
 * --------------------------------------------- */
const CraftingCategory = ({
  crafties,
  title,
  onlyCraftable,
  craftableSet,
  actfunc,
  searchText,
}) => {
  const visibleElements = useMemo(() => {
    const searchLower = searchText.toLowerCase();

    return Object.entries(crafties)
      .filter(([_, item]) => {
        if (onlyCraftable && !craftableSet.has(item.name)) return false;
        return item.name.toLowerCase().includes(searchLower);
      })
      .sort(([, a], [, b]) => a.name.localeCompare(b.name));
  }, [crafties, onlyCraftable, craftableSet, searchText]);

  if (!visibleElements.length) return null;

  return (
    <Collapsible title={title}>
      {visibleElements.map(([key, item]) => (
        <CraftingRecipe
          key={key}
          recipe={item}
          craftableSet={craftableSet}
          actfunc={actfunc}
        />
      ))}
    </Collapsible>
  );
};

/* ---------------------------------------------
 * Main Component
 * --------------------------------------------- */
export const MiaCraft = () => {
  const { act, data } = useBackend();
  const craftabilityEntries = Object.entries(data.craftability);

  // Local UI state
  const [searchText, setSearchText] = useState('');

  // Pull once & never reassign
  const crafting_recipes = data.crafting_recipes;

  // Controlled checkbox state lives in backend
  const onlyCraftable = data.showonlycraftable;

  // O(1) lookup of craftable items
  const craftableSet = useMemo(() => {
    return new Set(
      craftabilityEntries
        .filter(([_, can]) => can === 1)
        .map(([name]) => name)
    );
  }, [craftabilityEntries]);

  // Pre-sorted categories
  const sortedCategories = useMemo(() => {
    return Object.entries(crafting_recipes).sort(([a], [b]) =>
      a.localeCompare(b)
    );
  }, [crafting_recipes]);

  return (
    <Window title="Crafting" width={340} height={600} resizable>
      <Window.Content scrollable>
        <Stack horizontal>
          <Stack vertical>

            {/* Search + Filter */}
            <Stack.Item style={{ position: 'sticky' }}>
              <Stack>
                <Stack.Item>
                  <Input
                    placeholder="Search..."
                    autoFocus
                    value={searchText}
                    onChange={(e) =>
                      setSearchText(e.target.value.toLowerCase())
                    }
                  />
                </Stack.Item>

                <Stack.Item>
                  <label>Show only craftables</label>
                  <input
                    type="checkbox"
                    checked={onlyCraftable}
                    onChange={() =>
                      act('checkboxonlycraftable', {
                        state: !onlyCraftable,
                      })
                    }
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>

            {/* Categories */}
            <Stack.Item>
              {sortedCategories.map(([key, items]) => (
                <CraftingCategory
                  key={key}
                  title={key}
                  crafties={items}
                  onlyCraftable={onlyCraftable}
                  craftableSet={craftableSet}
                  actfunc={act}
                  searchText={searchText}
                />
              ))}
            </Stack.Item>

          </Stack>
        </Stack>
      </Window.Content>
    </Window>
  );
};
