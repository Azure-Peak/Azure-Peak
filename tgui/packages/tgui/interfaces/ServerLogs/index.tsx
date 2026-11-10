import { Stack } from 'tgui-core/components';

import { useBackend } from '../../backend';
import { Window } from '../../layouts';
import { EntryList, FilterBar, Pager } from './Entries';
import { roundLabel } from './helpers';
import { PlayerList, RoundPicker, SourceList } from './Sidebar';
import type { Data } from './types';

export const ServerLogs = () => {
  const { data } = useBackend<Data>();
  const { round, live } = data;

  return (
    <Window
      width={1300}
      height={820}
      title={`Server Logs${round ? ` - ${roundLabel(round)}` : ''}${live ? ' (live)' : ''}`}
    >
      <Window.Content>
        <Stack fill>
          <Stack.Item width="320px">
            <Stack fill vertical>
              <Stack.Item>
                <RoundPicker />
              </Stack.Item>
              <Stack.Item basis="38%">
                <SourceList />
              </Stack.Item>
              <Stack.Item grow>
                <PlayerList />
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item grow basis={0}>
            <Stack fill vertical>
              <Stack.Item>
                <FilterBar />
              </Stack.Item>
              <Stack.Item grow>
                <EntryList />
              </Stack.Item>
              <Stack.Item>
                <Pager />
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
