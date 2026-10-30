import { useState } from 'react';
import { Stack, Tabs } from 'tgui-core/components';

import { useBackend } from '../../backend';
import { QuestActiveList } from './QuestActiveList';
import { QuestDraft } from './QuestDraft';
import type { GameMasterData } from './types';

export function QuestColumn() {
  const { data } = useBackend<GameMasterData>();
  const [showActive, setShowActive] = useState(false);

  const activeCount = data.gm_quests?.length ?? 0;

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Tabs fluid>
          <Tabs.Tab
            selected={!showActive}
            onClick={() => {
              setShowActive(false);
            }}
          >
            Draft
          </Tabs.Tab>
          <Tabs.Tab
            selected={showActive}
            onClick={() => {
              setShowActive(true);
            }}
          >
            Active ({activeCount})
          </Tabs.Tab>
        </Tabs>
      </Stack.Item>
      <Stack.Item grow>
        {showActive ? <QuestActiveList /> : <QuestDraft />}
      </Stack.Item>
    </Stack>
  );
}
