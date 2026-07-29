import { Box, Button, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Marking = {
  name: string;
  color: string;
};

type Zone = {
  zone: string;
  name: string;
  markings: Marking[];
  can_add: BooleanLike;
};

type Data = {
  zones: Zone[];
};

export function BodyMarkings(props) {
  const { act, data } = useBackend<Data>();
  return (
    <Window width={560} height={700} title="Markings">
      <Window.Content scrollable>
        <Section>
          <Button onClick={() => act('use_preset')}>Use a preset</Button>
          <Button onClick={() => act('reset_all_colors')}>
            Reset marking colors
          </Button>
        </Section>
        {data.zones.map((zone) => (
          <Section
            key={zone.zone}
            title={zone.name}
            buttons={
              !!zone.can_add && (
                <Button
                  icon="plus"
                  onClick={() => act('add_marking', { zone: zone.zone })}
                >
                  Add
                </Button>
              )
            }
          >
            {zone.markings.map((marking, i) => (
              <Stack key={marking.name} align="center" mb={0.5}>
                <Stack.Item>
                  <Button
                    icon="arrow-up"
                    disabled={i === 0}
                    tooltip="Move up"
                    onClick={() =>
                      act('marking_move_up', {
                        zone: zone.zone,
                        name: marking.name,
                      })
                    }
                  />
                  <Button
                    icon="arrow-down"
                    disabled={i === zone.markings.length - 1}
                    tooltip="Move down"
                    onClick={() =>
                      act('marking_move_down', {
                        zone: zone.zone,
                        name: marking.name,
                      })
                    }
                  />
                </Stack.Item>
                <Stack.Item grow>
                  <Button
                    tooltip="Change this marking"
                    onClick={() =>
                      act('change_marking', {
                        zone: zone.zone,
                        name: marking.name,
                      })
                    }
                  >
                    {marking.name}
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    tooltip="Change color"
                    onClick={() =>
                      act('change_color', {
                        zone: zone.zone,
                        name: marking.name,
                      })
                    }
                  >
                    <Box
                      inline
                      width="20px"
                      height="10px"
                      style={{
                        backgroundColor: marking.color,
                        border: '1px solid #000',
                      }}
                    />
                  </Button>
                  <Button
                    icon="rotate-left"
                    tooltip="Reset color"
                    onClick={() =>
                      act('reset_color', {
                        zone: zone.zone,
                        name: marking.name,
                      })
                    }
                  />
                  <Button
                    icon="times"
                    color="bad"
                    tooltip="Remove"
                    onClick={() =>
                      act('remove_marking', {
                        zone: zone.zone,
                        name: marking.name,
                      })
                    }
                  />
                </Stack.Item>
              </Stack>
            ))}
            {zone.markings.length === 0 && (
              <Box color="label" italic>
                No markings.
              </Box>
            )}
          </Section>
        ))}
      </Window.Content>
    </Window>
  );
}
