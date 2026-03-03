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

// Keep these function outside to prevent re-render
const CraftingCategory = ({ crafties, key3, onlyCraftable, craftability, key, actfunc, searchText }) => {
    const visibleElements = useMemo(() => {
      return Object.entries(crafties).filter(([key2, item2]) => !onlyCraftable || 
      craftability.some(object => object[0] === item2.name && object[1] === 1))
      .sort(([, aVal], [, bVal]) => String(aVal.name).localeCompare(String(bVal.name)))
      .filter(([id, item]) => 
      { return (item.name.toLowerCase().includes(searchText)) || (item.aliases.toLowerCase().includes(searchText)); });
    }, [crafties, onlyCraftable, craftability, searchText]);
    return (visibleElements.length > 0 ? 
        <Collapsible title={key3}>
          {visibleElements.map(([key2, item2]) => (
            <CraftingRecipe recipe={item2} key={key2} craftability={craftability} actfunc={actfunc} />
          ))}
          
        </Collapsible> 
      : null);
  };

  const CraftingRecipe = ({ recipe, key, craftability, actfunc }) => {
    return(
      <Stack>
        <Stack.Item>
          <Button content="🛠" onClick={() => {
            actfunc('craft', {
              item : recipe.path,
            });
          }}
          />
        </Stack.Item>
        <Stack.Item basis="80%">
          <Collapsible title={recipe.name} style={{ backgroundColor: craftability.some(object => object[0] === recipe.name && object[1] === 1) ? "" : "grey" }}>
            <LabeledList >
              <LabeledList.Item label="Also known as" style={{ 'margin-left': '20px' }}>
                {recipe.aliases}
              </LabeledList.Item>
              <LabeledList.Item label="Ingredients" style={{ 'margin-left': '20px' }}>
                {recipe.req_text}
              </LabeledList.Item>
              <LabeledList.Item label="Difficulty" style={{ 'margin-left': '20px' }}>
                {recipe.craftingdifficulty}
              </LabeledList.Item>
              { recipe.tool_text &&
                <LabeledList.Item label="Tool" style={{ 'margin-left': '20px' }}>
                  {recipe.tool_text}
                </LabeledList.Item>
              }
              {recipe.catalyst_text && 
                  <LabeledList.Item label="Catalyst" style={{ 'margin-left': '20px' }}>
                    {recipe.catalyst_text}
                  </LabeledList.Item>
              }
              <LabeledList.Item label="Sell Price" style={{ 'margin-left': '20px' }}>
                {recipe.sellprice}
              </LabeledList.Item>
              <LabeledList.Item label="Craft it!" style={{ 'margin-left': '20px', 'gap': '4px' }}>
                <Button content="1x" onClick={() => {
                  actfunc('craft', {
                    item : recipe.path,
                  });
                }}
                />
                <Button content="2x" onClick={() => {
                  actfunc('craft', {
                    item: recipe.path,
                    amount: 2,
                  });
                }}
                />
                <Button content="3x" onClick={() => {
                  actfunc('craft', {
                    item: recipe.path,
                    amount: 3,
                  });
                }}
                />
                <Button content="5x" onClick={() => {
                  actfunc('craft', {
                    item: recipe.path,
                    amount: 5,
                  });
                }}
                />
                <Button content="∞" onClick={() => {
                  actfunc('craft', {
                    item : recipe.path,
                    auto: true,
                  });
                }}
                />
              </LabeledList.Item>
            </LabeledList>
          </Collapsible>
        </Stack.Item>
      </Stack>
    );
  };

export const MiaCraft = (props, context) => {
  const { act, data } = useBackend();
  const busy = data.busy;
  const [category, setCategory] = useState();
  const [subcategory, setSubcategory] = useState();
  const craftability = Object.entries(data.craftability);
  const [crafting_recipes] = useState(data.crafting_recipes);
  let onlyCraftable = data.showonlycraftable;
  const [searchText, setSearchText] = useState("");

  function ToggleOnlyCraftable() {
    act('checkboxonlycraftable', { state : !onlyCraftable });
  }

  function SearchTextModify(val) {
    setSearchText(val);
  }

  const renderColumn = () => {
    return (
      <Stack vertical>
          <Stack.Item style={{ 'position': 'sticky' }}>
              <Stack>
                <Stack.Item>
                  <Input placeholder="Search..." autoFocus value={searchText} onInput={(e) => SearchTextModify(e.target.value.toLowerCase())} />
                </Stack.Item>
                <Stack.Item>
                  <label>Show only craftables</label>
                  <input type="checkbox" checked={onlyCraftable} onClick={() => ToggleOnlyCraftable()} />
                </Stack.Item>
              </Stack>
          </Stack.Item>
          <Stack.Item>
            {
              Object.entries(crafting_recipes).sort(([a], [b]) => String(a).localeCompare(String(b))).map(([key, item]) => (
                <CraftingCategory crafties={item} key3={key} onlyCraftable={onlyCraftable} craftability={craftability} key={key} actfunc={act} searchText={searchText} />
              ))
            }
          </Stack.Item>
      </Stack>
    );
  };
  
  return(
    <Window title='Crafting' width={340} height={600} resizeable>
      <Window.Content scrollable>
        <Stack horizontal>
          {renderColumn()}
        </Stack>
      </Window.Content>
    </Window>
  );

  };
