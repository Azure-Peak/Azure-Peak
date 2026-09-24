import { Box, Button, NoticeBox, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Organ = {
  ref: string;
  name: string;
  is_bone: boolean;
  state: string;
  state_color: string;
  severe?: boolean;
  fractured?: boolean;
};

type Data = {
  zone_name: string;
  on_surface: boolean;
  organs: Organ[];
};

export const BodyCavity = (props) => {
  const { act, data } = useBackend<Data>();
  const { zone_name, on_surface, organs = [] } = data;

  return (
    <Window width={460} height={460}>
      <Window.Content scrollable>
        {!on_surface && (
          <NoticeBox warning>
            The patient is not on a bed or table. Extractions and grave-wound
            repairs need a proper operating surface.
          </NoticeBox>
        )}
        <Section title={'Inside the ' + zone_name}>
          {organs.length === 0 ? (
            <Box color="label">Nothing here to work on.</Box>
          ) : (
            <Stack vertical>
              {organs.map((organ) => (
                <Stack.Item key={organ.ref}>
                  <Stack align="center">
                    <Stack.Item grow>
                      <b>{organ.name}</b>
                      {' - '}
                      <Box inline color={organ.state_color}>
                        {organ.state}
                      </Box>
                    </Stack.Item>
                    {!organ.is_bone && (
                      <Stack.Item>
                        <Button
                          disabled={!organ.severe}
                          tooltip="Stitch a grave wound (needs a suture in hand)."
                          onClick={() => act('repair', { ref: organ.ref })}
                        >
                          Repair
                        </Button>
                      </Stack.Item>
                    )}
                    {organ.is_bone && (
                      <Stack.Item>
                        <Button
                          disabled={!organ.fractured}
                          tooltip="Set the fracture (needs a bonesetter in hand)."
                          onClick={() => act('setbone', { ref: organ.ref })}
                        >
                          Set
                        </Button>
                      </Stack.Item>
                    )}
                    <Stack.Item>
                      <Button
                        color="bad"
                        tooltip="Pull it free (needs a hemostat in hand)."
                        onClick={() => act('extract', { ref: organ.ref })}
                      >
                        Extract
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              ))}
            </Stack>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
