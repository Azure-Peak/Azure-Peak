import { useState } from 'react';
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

type Entry = {
  type: string;
  name: string;
  icon: string;
  icon_state: string;
  quality?: number | string;
};

type Data = {
  foods: Entry[];
  drinks: Entry[];
  favourite_food: Entry | null;
  hated_food: Entry | null;
  favourite_drink: Entry | null;
  hated_drink: Entry | null;
};

type Slot = {
  key: string;
  label: string;
  current: Entry | null;
  action: string;
  hated: 0 | 1;
};

export function CulinaryPreferences(props) {
  const { act, data } = useBackend<Data>();
  const [selecting, setSelecting] = useState<Slot | null>(null);
  const [search, setSearch] = useState('');

  const slots: Slot[] = [
    {
      key: 'favourite_food',
      label: 'Favourite Food',
      current: data.favourite_food,
      action: 'set_food',
      hated: 0,
    },
    {
      key: 'favourite_drink',
      label: 'Favourite Drink',
      current: data.favourite_drink,
      action: 'set_drink',
      hated: 0,
    },
    {
      key: 'hated_food',
      label: 'Hated Food',
      current: data.hated_food,
      action: 'set_food',
      hated: 1,
    },
    {
      key: 'hated_drink',
      label: 'Hated Drink',
      current: data.hated_drink,
      action: 'set_drink',
      hated: 1,
    },
  ];

  const catalog = selecting?.action === 'set_drink' ? data.drinks : data.foods;
  const filtered = selecting
    ? catalog.filter((entry) =>
        entry.name.toLowerCase().includes(search.toLowerCase()),
      )
    : [];

  return (
    <Window
      width={420}
      height={600}
      title="Culinary Preferences"
    >
      <Window.Content scrollable>
        {!selecting && (
          <Section title="Culinary Preferences">
            {slots.map((slot) => (
              <Stack key={slot.key} align="center" mb={1}>
                <Stack.Item width="120px" color="label" bold>
                  {slot.label}
                </Stack.Item>
                <Stack.Item>
                  {slot.current && (
                    <DmIcon
                      icon={slot.current.icon}
                      icon_state={slot.current.icon_state}
                      width="32px"
                      height="32px"
                      verticalAlign="middle"
                    />
                  )}
                </Stack.Item>
                <Stack.Item grow>
                  <Button
                    onClick={() => {
                      setSearch('');
                      setSelecting(slot);
                    }}
                  >
                    {slot.current ? slot.current.name : 'None'}
                  </Button>
                </Stack.Item>
              </Stack>
            ))}
          </Section>
        )}
        {selecting && (
          <Section
            title={`Select ${selecting.label}`}
            buttons={
              <Button icon="arrow-left" onClick={() => setSelecting(null)}>
                Back
              </Button>
            }
          >
            <Input
              fluid
              autoFocus
              placeholder="Search..."
              value={search}
              onInput={(_, value) => setSearch(value)}
              mb={1}
            />
            {filtered.map((entry) => (
              <Stack key={entry.type} align="center" mb={0.5}>
                <Stack.Item>
                  <DmIcon
                    icon={entry.icon}
                    icon_state={entry.icon_state}
                    width="32px"
                    height="32px"
                    verticalAlign="middle"
                  />
                </Stack.Item>
                <Stack.Item grow>
                  <Button
                    onClick={() => {
                      act(selecting.action, {
                        type: entry.type,
                        hated: selecting.hated,
                      });
                      setSelecting(null);
                    }}
                  >
                    {entry.name}
                  </Button>
                  <Box inline color="label" ml={1}>
                    (Quality: {entry.quality})
                  </Box>
                </Stack.Item>
              </Stack>
            ))}
          </Section>
        )}
      </Window.Content>
    </Window>
  );
}
