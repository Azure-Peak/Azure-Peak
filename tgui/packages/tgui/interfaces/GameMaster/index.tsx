import { useState } from 'react';
import { Stack } from 'tgui-core/components';

import { Window } from '../../layouts';
import { ActionStrip } from './ActionStrip';
import { CreaturePane } from './CreaturePane';
import { DetailStrip } from './DetailStrip';
import { FactionRail } from './FactionRail';

export function GameMaster(props) {
  const [factionQuery, setFactionQuery] = useState('');
  const [creatureQuery, setCreatureQuery] = useState('');

  return (
    <Window title="Game Master Menu" width={560} height={700} theme="parchment">
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item grow>
            <Stack fill>
              <Stack.Item basis="13rem" shrink={0} style={{ minWidth: 0 }}>
                <FactionRail query={factionQuery} onQuery={setFactionQuery} />
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
          <Stack.Item>
            <ActionStrip />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
}
