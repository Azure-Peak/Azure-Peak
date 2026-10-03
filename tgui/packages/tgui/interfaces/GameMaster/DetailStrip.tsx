import { Box, Section, Stack, Tooltip } from 'tgui-core/components';

import { useBackend } from '../../backend';
import { ELLIPSIS, type GameMasterData, shortPath, toTitle } from './types';

export function DetailStrip() {
  const { data } = useBackend<GameMasterData>();
  const { selected_detail } = data;

  if (!selected_detail) {
    return (
      <Section>
        <Box color="label">Nothing selected.</Box>
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
        <Stack.Item bold style={ELLIPSIS}>
          {name}
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
