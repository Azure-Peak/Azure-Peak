import { useState } from 'react';
import {
  Box,
  Button,
  NumberInput,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';

import { useBackend } from '../../backend';
import { ELLIPSIS, type GameMasterData, shortPath, toTitle } from './types';

export function DetailStrip() {
  const { act, data } = useBackend<GameMasterData>();
  const { selected_detail, quest_open, quest, quest_static } = data;
  const [questCount, setQuestCount] = useState(1);

  const questRoom = quest_static.mob_cap - (quest?.mob_total ?? 0);
  const questControls = !!quest_open && (
    <>
      <Stack.Item>
        <NumberInput
          width="3.5rem"
          minValue={1}
          maxValue={quest_static.mob_cap}
          step={1}
          value={questCount}
          onChange={setQuestCount}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          icon="plus"
          disabled={!selected_detail || questRoom <= 0}
          onClick={() => {
            act('quest_add_selected', { count: questCount });
          }}
        >
          Add
        </Button>
      </Stack.Item>
    </>
  );

  if (!selected_detail) {
    return (
      <Section>
        <Stack align="center">
          <Stack.Item grow color="label">
            Nothing selected.
          </Stack.Item>
          {questControls}
        </Stack>
      </Section>
    );
  }

  const { name, category, threat, path, size, members } = selected_detail;
  const facts = [toTitle(category), threat > 0 ? `tp ${threat}` : 'no tp'];
  if (size) {
    facts.push(`${size} ${size === 1 ? 'mob' : 'mobs'}`);
  }

  return (
    <Section>
      <Stack vertical>
        <Stack.Item>
          <Stack align="center">
            <Stack.Item grow bold style={ELLIPSIS}>
              {name}
            </Stack.Item>
            {questControls}
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Stack>
            <Stack.Item grow color="label" style={ELLIPSIS}>
              {facts.join(' - ')}
            </Stack.Item>
            <Stack.Item grow textAlign="right" style={ELLIPSIS}>
              <Tooltip content={path}>
                <Box
                  color="label"
                  fontFamily="monospace"
                  fontSize="0.85rem"
                  style={ELLIPSIS}
                >
                  {shortPath(path)}
                </Box>
              </Tooltip>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        {!!members && members.length > 0 && (
          <Stack.Item mt={0.5}>
            <Box className="GameMaster__members">
              {members.map((member) => (
                <Tooltip key={member.name} content={`tp ${member.threat} each`}>
                  <Box className="GameMaster__member">
                    <Box inline bold>
                      {member.count}&times;
                    </Box>
                    <Box inline>{member.name}</Box>
                  </Box>
                </Tooltip>
              ))}
            </Box>
          </Stack.Item>
        )}
      </Stack>
    </Section>
  );
}
