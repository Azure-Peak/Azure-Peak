import { useState } from 'react';
import {
  Box,
  Button,
  Input,
  Section,
  Stack,
  Table,
  Tabs,
  TextArea,
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
const ColorSwatch = (props: {
  color: string;
  size?: number;
  onClick?: () => void;
}) => (
  <Box
    inline
    style={{
      width: `${(props.size || 0.9) * 12}px`,
      height: `${(props.size || 0.9) * 12}px`,
      marginLeft: '3px',
      backgroundColor: props.color,
      display: 'inline-block',
      border: '1px solid rgba(255,255,255,0.3)',
      borderRadius: '2px',
      verticalAlign: 'middle',
      cursor: props.onClick ? 'pointer' : undefined,
    }}
    onClick={props.onClick}
  />
);

/** Clickable color link: swatch + label, clicking opens the color picker modal */
const ColorLink = (props: {
  label: string;
  currentColor: string | null;
  action: string;
  itemName: string;
}) => {
  const { act } = useBackend<Data>();
  const { label, currentColor, action, itemName } = props;

  return (
    <Box inline mr={1.5}>
      <Box
        inline
        style={{ cursor: 'pointer' }}
        onClick={(e: React.MouseEvent) => {
          e.stopPropagation();
          act(action, { name: itemName });
        }}
      >
        <Box inline color="label" mr={0.5}>
          {label}:
        </Box>
        {currentColor ? (
          <ColorSwatch color={currentColor} size={1} />
        ) : (
          <Box inline color="average" fontSize={0.85}>
            None
          </Box>
        )}
      </Box>
      {currentColor && (
        <Box
          inline
          color="bad"
          ml={0.5}
          fontSize={0.8}
          style={{ cursor: 'pointer' }}
          onClick={(e: React.MouseEvent) => {
            e.stopPropagation();
            act(action, { name: itemName, clear: true });
          }}
        >
          &#x2715;
        </Box>
      )}
    </Box>
  );
};

/** Two-line tweak row for a selected item: colors on line 1, name/desc on line 2 */
const TweakRow = (props: {
  itemName: string;
  meta: SelectedItem | undefined;
  colorChannels: string[];
}) => {
  const { itemName, meta, colorChannels } = props;
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
          ml={1.2}
          pl={0.75}
          py={0.3}
          style={{
            background: 'rgba(255,255,255,0.04)',
            borderLeft: '2px solid rgba(80,200,120,0.5)',
          }}
        >
          {/* Line 1: Color channels */}
          <Box mb={0.3}>
            <ColorLink
              label="Color"
              currentColor={meta?.color || null}
              action="set_color"
              itemName={itemName}
            />
            {colorChannels.includes('detail') && (
              <ColorLink
                label="Detail"
                currentColor={meta?.detail_color || null}
                action="set_detail_color"
                itemName={itemName}
              />
            )}
            {colorChannels.includes('altdetail') && (
              <ColorLink
                label="Alt"
                currentColor={meta?.altdetail_color || null}
                action="set_altdetail_color"
                itemName={itemName}
              />
            )}
          </Box>
          {/* Line 2: Custom name */}
          <Box>
            <Box inline mr={1}>
              <Box inline color="label" mr={0.5}>
                Name:
              </Box>
              <Input
                width="200px"
                maxLength={42}
                placeholder="Custom name..."
                value={localName}
                onChange={(val) => setLocalName(val)}
                onEnter={(val) => commitName(val)}
                onBlur={(val) => commitName(val)}
              />
            </Box>
          </Box>
          {/* Line 3: Custom desc (full width textarea) */}
          <Box mt={0.3}>
            <Box color="label" mb={0.3}>
              Description (max 1024 chars):
            </Box>
            <TextArea
              fluid
              maxLength={1024}
              height="60px"
              placeholder="Custom description..."
              value={localDesc}
              onChange={(val) => setLocalDesc(val)}
              onBlur={(val) => commitDesc(val)}
              dontUseTabForIndent
            />
          </Box>
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
    total_triumph_cost,
    player_triumphs,
  } = data;

  const currentCategory = activeCategory || categories[0] || '';

  const selectedNames = new Set(selected.map((s) => s.name));
  const selectedMap = new Map(selected.map((s) => [s.name, s]));
  const channelsMap = new Map(items.map((i) => [i.name, i.color_channels]));

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
                <Table.Cell pl={2.5}>Name</Table.Cell>
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
                    style={{
                      cursor: 'pointer',
                      verticalAlign: 'middle',
                      borderBottom: '1px solid rgba(255,255,255,0.07)',
                    }}
                    onClick={() => act('toggle_item', { name: item.name })}
                  >
                    <Table.Cell py={0.4}>
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
                        <Box bold={isSelected} fontSize={0.9} py={0.5}>
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
        <Box px={1} py={0.25}>
          <Stack align="center">
            <Stack.Item grow>
              <Box inline bold fontSize={0.95} color={total_cost >= max_points ? 'bad' : undefined} mr={1.5}>
                Budget: {total_cost}/{max_points}
              </Box>
              <Box inline bold fontSize={0.95} color={total_triumph_cost > player_triumphs ? 'bad' : 'gold'} mr={1.5}>
                Triumphs: {total_triumph_cost}/{player_triumphs}
              </Box>
              <Box inline color="label" fontSize={0.85}>
                Free loadout items cannot be sold, smelted, or salvaged. Triumph items are exempt.
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
