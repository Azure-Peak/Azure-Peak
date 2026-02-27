import { useState } from 'react';
import { Box, Button, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Rite = {
  name: string;
  desc: string;
  explanation: string;
  type_path: string;
  eligible: boolean;
};

type Data = {
  rites: Rite[];
};

export const RiteSelection = (props) => {
  const { data, act } = useBackend<Data>();
  const { rites = [] } = data;
  const [selectedIndex, setSelectedIndex] = useState(0);

  const selected = rites[selectedIndex] || null;

  return (
    <Window width={620} height={380} title="Rites of Succession">
      <Window.Content>
        <Stack fill>
          <Stack.Item basis="40%" mr={1}>
            <Section title="Available Rites" fill scrollable>
              {rites.map((rite, index) => (
                <Button
                  key={rite.type_path}
                  fluid
                  selected={selectedIndex === index}
                  color={!rite.eligible ? 'grey' : undefined}
                  opacity={!rite.eligible ? 0.5 : 1}
                  onClick={() => setSelectedIndex(index)}
                  mb={1}
                >
                  {rite.name}
                </Button>
              ))}
            </Section>
          </Stack.Item>
          <Stack.Item grow basis={0}>
            {selected ? (
              <Stack vertical fill>
                <Stack.Item grow basis={0}>
                  <Section title={selected.name} fill scrollable>
                    <Box
                      italic
                      color="label"
                      mb={1}
                      opacity={selected.eligible ? 1 : 0.6}
                    >
                      {selected.desc}
                    </Box>
                    <Box
                      opacity={selected.eligible ? 1 : 0.6}
                      dangerouslySetInnerHTML={{
                        __html: selected.explanation,
                      }}
                    />
                  </Section>
                </Stack.Item>
                <Stack.Item>
                  {selected.eligible ? (
                    <Button
                      fluid
                      textAlign="center"
                      color="good"
                      fontSize={1.2}
                      onClick={() =>
                        act('choose_rite', {
                          type_path: selected.type_path,
                        })
                      }
                    >
                      Invoke This Rite
                    </Button>
                  ) : (
                    <Box textAlign="center" color="bad" italic py={0.5}>
                      You do not meet the requirements for this rite.
                    </Box>
                  )}
                </Stack.Item>
              </Stack>
            ) : (
              <Section title="No Rite Selected" fill>
                <Box color="label">
                  Select a rite from the left to see its details.
                </Box>
              </Section>
            )}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
