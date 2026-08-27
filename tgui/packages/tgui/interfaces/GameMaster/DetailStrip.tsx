import { Box, Section, Stack, Tooltip } from 'tgui-core/components';

import { useBackend } from '../../backend';
import {
  ELLIPSIS,
  type GameMasterData,
  shortPath,
  toTitle,
} from './types';

export function DetailStrip(props) {
  const { data } = useBackend<GameMasterData>();
  const { selected_detail } = data;

  if (!selected_detail) {
    return (
      <Section>
        <Box color="label">Nothing selected.</Box>
      </Section>
    );
  }

  const { name, category, threat, path } = selected_detail;
  const facts = [
    toTitle(category),
    threat > 0 ? `tp ${threat}` : 'no tp',
  ];

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
      </Stack>
    </Section>
  );
}
