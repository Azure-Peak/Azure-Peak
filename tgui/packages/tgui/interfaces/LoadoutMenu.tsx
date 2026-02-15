import { useState } from 'react';
import {
  Box,
  Button,
  Dropdown,
  Input,
  Section,
  Stack,
  Table,
  Tabs,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type LoadoutItem = {
  name: string;
  desc: string;
  category: string;
  cost: number;
  triumph_cost: number | null;
  color_channels: string[];
};

type SelectedItem = {
  name: string;
  color: string | null;
  detail_color: string | null;
  altdetail_color: string | null;
  custom_name: string | null;
  custom_desc: string | null;
};

type Data = {
  // Static
  categories: string[];
  items: LoadoutItem[];
  max_points: number;
  colors: Record<string, string>;
  // Dynamic
  selected: SelectedItem[];
  total_cost: number;
  total_triumph_cost: number;
  player_triumphs: number;
};

export const LoadoutMenu = () => {
  const { data } = useBackend<Data>();

  if (!data.categories || !data.items) {
    return (
      <Window width={780} height={600}>
        <Window.Content>
          <Stack align="center" justify="center" fill>
            <Stack.Item fontSize={1.5}>Loading loadout data...</Stack.Item>
          </Stack>
        </Window.Content>
      </Window>
    );
  }

  return (
    <Window width={780} height={600}>
      <Window.Content>
        <LoadoutDisplay />
      </Window.Content>
    </Window>
  );
};

/** Small inline color swatch */
const ColorSwatch = (props: { color: string; onClick?: () => void }) => (
  <Box
    inline
    width={1}
    height={1}
    ml={0.25}
    backgroundColor={props.color}
    onClick={props.onClick}
    style={{
      border: '1px solid rgba(255,255,255,0.3)',
      verticalAlign: 'middle',
      cursor: props.onClick ? 'pointer' : undefined,
    }}
  />
);

/** Compact inline color picker: label + swatch that opens a dropdown */
const ColorPicker = (props: {
  label: string;
  currentColor: string | null;
  colors: Record<string, string>;
  colorNames: string[];
  action: string;
  itemName: string;
}) => {
  const { act } = useBackend<Data>();
  const { label, currentColor, colors, colorNames, action, itemName } = props;

  return (
    <Box inline mr={1}>
      <Box inline color="label" mr={0.5}>
        {label}:
      </Box>
      <Dropdown
        width="100px"
        selected={
          currentColor
            ? colorNames.find((cn) => colors[cn] === currentColor) || 'None'
            : 'None'
        }
        options={['None', ...colorNames]}
        onSelected={(val) =>
          act(action, {
            name: itemName,
            color: val === 'None' ? '' : val,
          })
        }
      />
      {currentColor && <ColorSwatch color={currentColor} />}
    </Box>
  );
};

/** Inline tweak row for a selected item - all customization on one row */
const TweakRow = (props: {
  itemName: string;
  meta: SelectedItem | undefined;
  colorChannels: string[];
  colors: Record<string, string>;
  colorNames: string[];
}) => {
  const { itemName, meta, colorChannels, colors, colorNames } = props;
  const { act } = useBackend<Data>();

  const [localName, setLocalName] = useState(meta?.custom_name || '');
  const [localDesc, setLocalDesc] = useState(meta?.custom_desc || '');

  const commitName = (val: string) => {
    act('set_custom_name', { name: itemName, custom_name: val });
  };

  const commitDesc = (val: string) => {
    act('set_custom_desc', { name: itemName, custom_desc: val });
  };

  return (
    <Table.Row>
      <Table.Cell colSpan={3}>
        <Box
          pl={2}
          py={0.25}
          style={{
            background: 'rgba(255,255,255,0.03)',
          }}
        >
          <Stack align="center" wrap>
            {/* Color pickers */}
            <Stack.Item>
              <ColorPicker
                label="Color"
                currentColor={meta?.color || null}
                colors={colors}
                colorNames={colorNames}
                action="set_color"
                itemName={itemName}
              />
            </Stack.Item>
            {colorChannels.includes('detail') && (
              <Stack.Item>
                <ColorPicker
                  label="Dtl"
                  currentColor={meta?.detail_color || null}
                  colors={colors}
                  colorNames={colorNames}
                  action="set_detail_color"
                  itemName={itemName}
                />
              </Stack.Item>
            )}
            {colorChannels.includes('altdetail') && (
              <Stack.Item>
                <ColorPicker
                  label="Alt"
                  currentColor={meta?.altdetail_color || null}
                  colors={colors}
                  colorNames={colorNames}
                  action="set_altdetail_color"
                  itemName={itemName}
                />
              </Stack.Item>
            )}
            {/* Custom name */}
            <Stack.Item>
              <Box inline color="label" mr={0.5}>
                Name:
              </Box>
              <Input
                width="120px"
                maxLength={42}
                placeholder="Custom name..."
                value={localName}
                onChange={(val) => setLocalName(val)}
                onEnter={(val) => commitName(val)}
                onBlur={(val) => commitName(val)}
              />
            </Stack.Item>
            {/* Custom description */}
            <Stack.Item grow>
              <Box inline color="label" mr={0.5}>
                Desc:
              </Box>
              <Input
                width="140px"
                maxLength={1024}
                placeholder="Custom desc..."
                value={localDesc}
                onChange={(val) => setLocalDesc(val)}
                onEnter={(val) => commitDesc(val)}
                onBlur={(val) => commitDesc(val)}
              />
            </Stack.Item>
          </Stack>
          {localName && (
            <Box color="label" fontSize={0.85} pl={0.5}>
              Shows as: &quot;{localName} ({itemName})&quot;
            </Box>
          )}
        </Box>
      </Table.Cell>
    </Table.Row>
  );
};

const LoadoutDisplay = () => {
  const [search, setSearch] = useState('');
  const [activeCategory, setActiveCategory] = useState('');

  const { act, data } = useBackend<Data>();
  const {
    categories,
    items,
    selected,
    total_cost,
    max_points,
    colors,
    total_triumph_cost,
    player_triumphs,
  } = data;

  const currentCategory = activeCategory || categories[0] || '';

  const selectedNames = new Set(selected.map((s) => s.name));
  const selectedMap = new Map(selected.map((s) => [s.name, s]));
  const channelsMap = new Map(items.map((i) => [i.name, i.color_channels]));
  const colorNames = colors ? Object.keys(colors) : [];

  // Count selected items per category
  const categoryCounts: Record<string, number> = {};
  for (const item of items) {
    if (selectedNames.has(item.name)) {
      categoryCounts[item.category] = (categoryCounts[item.category] || 0) + 1;
    }
  }

  const filteredItems = items
    .filter((item) => {
      if (search) {
        return item.name.toLowerCase().includes(search.toLowerCase());
      }
      return item.category === currentCategory;
    })
    .sort((a, b) => a.name.localeCompare(b.name));

  return (
    <Stack fill vertical>
      {/* Category tabs */}
      <Stack.Item>
        <Tabs>
          {categories.map((cat) => {
            const count = categoryCounts[cat] || 0;
            return (
              <Tabs.Tab
                key={cat}
                selected={currentCategory === cat}
                onClick={() => setActiveCategory(cat)}
              >
                {cat}
                {count > 0 && ` (${count})`}
              </Tabs.Tab>
            );
          })}
        </Tabs>
      </Stack.Item>
      {/* Search bar */}
      <Stack.Item>
        <Input
          fluid
          placeholder="Search items..."
          value={search}
          onChange={(val) => setSearch(val)}
        />
      </Stack.Item>

      {/* Items table */}
      <Stack.Item grow>
        <Section fill scrollable fitted>
          {filteredItems.length === 0 ? (
            <Box color="label" textAlign="center" mt={2}>
              No items found.
            </Box>
          ) : (
            <Table>
              <Table.Row header>
                <Table.Cell>Name</Table.Cell>
                <Table.Cell collapsing textAlign="center">Cost</Table.Cell>
                <Table.Cell>Description</Table.Cell>
              </Table.Row>
              {filteredItems.map((item) => {
                const isSelected = selectedNames.has(item.name);
                const meta = selectedMap.get(item.name);

                return [
                  <Table.Row
                    key={item.name}
                    className="candystripe"
                    style={{ cursor: 'pointer', verticalAlign: 'middle' }}
                    onClick={() => act('toggle_item', { name: item.name })}
                  >
                    <Table.Cell>
                      <Box style={{ display: 'flex', alignItems: 'baseline' }}>
                        <Box
                          inline
                          width={1.2}
                          textAlign="center"
                          bold
                          color={isSelected ? 'good' : 'label'}
                          style={{ flexShrink: 0 }}
                        >
                          {isSelected ? '\u2713' : '\u25CB'}
                        </Box>
                        <Box bold={isSelected}>
                          {item.name}
                          {isSelected &&
                            (meta?.color ||
                              meta?.detail_color ||
                              meta?.altdetail_color) && (
                              <Box inline ml={0.5}>
                                {meta?.color && (
                                  <ColorSwatch color={meta.color} />
                                )}
                                {meta?.detail_color && (
                                  <ColorSwatch color={meta.detail_color} />
                                )}
                                {meta?.altdetail_color && (
                                  <ColorSwatch color={meta.altdetail_color} />
                                )}
                              </Box>
                            )}
                        </Box>
                      </Box>
                    </Table.Cell>
                    <Table.Cell collapsing color="label" textAlign="center">
                      {item.cost}pt
                      {item.triumph_cost ? (
                        <Box color="gold" bold fontSize={0.85}>
                          {item.triumph_cost} tri
                        </Box>
                      ) : null}
                    </Table.Cell>
                    <Table.Cell color="label" fontSize={0.9}>
                      {item.desc}
                    </Table.Cell>
                  </Table.Row>,
                  isSelected && (
                    <TweakRow
                      key={item.name + '_tweak'}
                      itemName={item.name}
                      meta={meta}
                      colorChannels={
                        channelsMap.get(item.name) || ['primary']
                      }
                      colors={colors}
                      colorNames={colorNames}
                    />
                  ),
                ];
              })}
            </Table>
          )}
        </Section>
      </Stack.Item>

      {/* Footer: budget + confirm */}
      <Stack.Item>
        <Box py={0.5} px={1}>
          <Stack align="center">
            <Stack.Item grow>
              <Box
                bold
                fontSize={0.95}
                color={total_cost >= max_points ? 'bad' : undefined}
              >
                Budget: {total_cost} / {max_points} pts
              </Box>
              {total_triumph_cost > 0 && (
                <Box
                  bold
                  fontSize={0.95}
                  color={
                    total_triumph_cost > player_triumphs ? 'bad' : 'gold'
                  }
                >
                  Triumphs: {total_triumph_cost} / {player_triumphs} available
                  {total_triumph_cost > player_triumphs && ' (not enough!)'}
                </Box>
              )}
              <Box color="label" fontSize={0.85}>
                Loadout items cannot be sold, smelted, or salvaged.
              </Box>
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="check"
                color="good"
                fontSize={1.1}
                onClick={() => act('confirm')}
              >
                Confirm
              </Button>
            </Stack.Item>
          </Stack>
        </Box>
      </Stack.Item>
    </Stack>
  );
};
