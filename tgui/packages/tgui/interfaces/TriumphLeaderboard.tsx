import { Box, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Entry = {
  key: string;
  amount: number;
};

type Data = {
  season: number;
  entries: Entry[];
};

export function TriumphLeaderboard(props) {
  const { data } = useBackend<Data>();
  return (
    <Window
      width={340}
      height={520}
      title="Champions of Valmoria"
    >
      <Window.Content scrollable>
        <Section
          title="CHAMPIONS OF VALMORIA"
          buttons={<Box color="label">Season {data.season}</Box>}
        >
          {data.entries.length === 0 && (
            <Box italic color="label" textAlign="center">
              The hall of triumphs is quite empty, Yes?
            </Box>
          )}
          {data.entries.map((entry, i) => (
            <Stack key={entry.key} align="center" mb={0.5}>
              <Stack.Item width="30px" bold color={i < 3 ? 'gold' : 'label'}>
                {i + 1}.
              </Stack.Item>
              <Stack.Item grow bold={i < 3}>
                {entry.key}
              </Stack.Item>
              <Stack.Item bold>{entry.amount}</Stack.Item>
            </Stack>
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
}
