import { useState } from 'react';
import { Box, Button, Icon, Stack } from 'tgui-core/components';

import { useBackend } from '../../backend';
import { Window } from '../../layouts';
import { ActionStrip } from './ActionStrip';
import { CreaturePane } from './CreaturePane';
import { DetailStrip } from './DetailStrip';
import { FactionRail } from './FactionRail';
import { QuestColumn } from './QuestColumn';
import type { GameMasterData } from './types';

export function GameMaster() {
  const { act, data } = useBackend<GameMasterData>();
  const [factionQuery, setFactionQuery] = useState('');
  const [creatureQuery, setCreatureQuery] = useState('');

  const questOpen = !!data.quest_open;

  return (
    <Window
      title="Game Master Menu"
      width={questOpen ? 1030 : 590}
      height={700}
      theme="parchment"
    >
      <Window.Content>
        <Stack fill>
          <Stack.Item
            grow={!questOpen}
            basis={questOpen ? '54%' : undefined}
            style={{ minWidth: 0 }}
          >
            <Stack fill vertical>
              <Stack.Item grow>
                <Stack fill>
                  <Stack.Item basis="13rem" shrink={0} style={{ minWidth: 0 }}>
                    <FactionRail
                      query={factionQuery}
                      onQuery={setFactionQuery}
                    />
                  </Stack.Item>
                  <Stack.Item grow style={{ minWidth: 0 }}>
                    <CreaturePane
                      query={creatureQuery}
                      onQuery={setCreatureQuery}
                    />
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item>
                <DetailStrip />
              </Stack.Item>
              {!questOpen && (
                <Stack.Item>
                  <ActionStrip />
                </Stack.Item>
              )}
            </Stack>
          </Stack.Item>
          <Stack.Item shrink={0}>
            <Button
              className="GameMaster__drawerToggle"
              selected={questOpen}
              onClick={() => {
                act('toggle_quest_drawer');
              }}
            >
              <Box className="GameMaster__drawerLabel">Quest</Box>
              <Icon name={questOpen ? 'angles-left' : 'angles-right'} />
            </Button>
          </Stack.Item>
          {questOpen && (
            <Stack.Item grow style={{ minWidth: 0 }}>
              <QuestColumn />
            </Stack.Item>
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
}
