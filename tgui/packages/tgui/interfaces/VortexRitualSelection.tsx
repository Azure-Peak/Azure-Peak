import { useState } from 'react';
import { Box, Button, Icon, NoticeBox, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type IngredientLine = {
  name: string;
  required: number;
};

type RitualChoice = {
  id: string;
  name: string;
  desc: string;
  channel_time: number;
  has_materials: boolean;
  ingredients: IngredientLine[];
};

type Data = {
  rituals: RitualChoice[];
};

export const VortexRitualSelection = (props) => {
  const { act, data } = useBackend<Data>();
  const [selectedRitualId, setSelectedRitualId] = useState<string | null>(null);

  const { rituals = [] } = data;
  const selectedRitual = rituals.find((r) => r.id === selectedRitualId);

  const handleSelectRitual = (ritualId: string) => {
    setSelectedRitualId(ritualId);
  };

  const handleConfirm = () => {
    if (selectedRitual) {
      act('execute_ritual', {
        ritual_id: selectedRitual.id,
      });
    }
  };

  return (
    <Window width={850} height={600} title="Vortex Ritual Chamber">
      <Window.Content scrollable>
        <Section title="Available Invocations">
          <Stack>
            <Stack.Item grow={1}>
              <NoticeBox info>
                <Icon name="eye" /> Choose an abyssal ritual to execute.
              </NoticeBox>
              {rituals.length === 0 && (
                <NoticeBox>No rituals are available.</NoticeBox>
              )}
              {rituals.map((ritual) => (
                <Box
                  key={ritual.id}
                  mb={1}
                  p={1}
                  style={{
                    border: `1px solid ${selectedRitualId === ritual.id ? '#ffffff' : 'rgba(255,255,255,0.1)'}`,
                    borderRadius: '4px',
                    cursor: 'pointer',
                  }}
                  onClick={() => handleSelectRitual(ritual.id)}
                >
                  <Box bold>{ritual.name}</Box>
                  <Box color="label" fontSize="0.9em">
                    Status: {ritual.has_materials ? 'Ready' : 'Missing Materials'}
                  </Box>
                  <Box color="gray" fontSize="0.9em" italic>
                    {ritual.desc}
                  </Box>
                </Box>
              ))}
            </Stack.Item>

            <Stack.Item grow={1.5}>
              {selectedRitual ? (
                <Box>
                  <Section title="Ritual Details">
                    <Box bold>{selectedRitual.name}</Box>
                    <Box color="label" fontSize="0.9em">
                      Channel Time: {selectedRitual.channel_time} seconds
                    </Box>
                  </Section>

                  <Section title="Required Materials">
                    {selectedRitual.ingredients.length === 0 && (
                      <NoticeBox info>No external offerings required.</NoticeBox>
                    )}
                    {selectedRitual.ingredients.map((ing) => (
                      <Box key={ing.name} fontSize="0.9em">
                        {ing.required}x {ing.name}
                      </Box>
                    ))}
                  </Section>

                  <Section title="Ritual Readiness">
                    {selectedRitual.has_materials ? (
                      <NoticeBox info>
                        <Icon name="gift" /> All alignment materials are arrayed on the outer rim.
                      </NoticeBox>
                    ) : (
                      <NoticeBox>
                        <Icon name="gift" /> Materials are missing or incorrectly placed.
                      </NoticeBox>
                    )}
                  </Section>

                  <Button
                    fluid
                    mt={1}
                    color="good"
                    disabled={!selectedRitual.has_materials}
                    onClick={handleConfirm}
                  >
                    Accept Vision
                  </Button>
                </Box>
              ) : (
                <NoticeBox info>Select a vision from the left.</NoticeBox>
              )}
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
