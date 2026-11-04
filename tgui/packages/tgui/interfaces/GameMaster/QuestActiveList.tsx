import { Box, Button, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../../backend';
import {
  formatSeconds,
  STATUS_COLORS,
  STATUS_LABELS,
} from '../QuestDebugPanel';
import { ELLIPSIS, type GameMasterData } from './types';

export function QuestActiveList() {
  const { act, data } = useBackend<GameMasterData>();
  const quests = data.gm_quests ?? [];

  return (
    <Section fill scrollable className="GameMaster__pane" title="Active">
      {quests.length === 0 ? (
        <Box color="label">None.</Box>
      ) : (
        quests.map((quest) => {
          const facts = [quest.type, quest.region, quest.holder, quest.progress]
            .filter(Boolean)
            .concat(`reward ${quest.reward}`);
          const closed =
            quest.status === 'complete' || quest.status === 'failed';
          return (
            <Box
              key={quest.ref}
              mb={0.5}
              pb={0.5}
              style={{ borderBottom: '1px solid rgba(122, 86, 22, 0.35)' }}
            >
              <Stack align="baseline">
                <Stack.Item grow bold style={ELLIPSIS}>
                  {quest.title}
                </Stack.Item>
                <Stack.Item color={STATUS_COLORS[quest.status]}>
                  {STATUS_LABELS[quest.status]}
                </Stack.Item>
              </Stack>
              <Box color="label" style={ELLIPSIS}>
                {facts.join(' - ')}
              </Box>
              {!!quest.timer_label && quest.timer_seconds > 0 && (
                <Box color="label">
                  {quest.timer_label} {formatSeconds(quest.timer_seconds)}
                </Box>
              )}
              <Stack mt={0.5}>
                <Stack.Item>
                  <Button
                    icon="location-arrow"
                    tooltip="Teleport to the nearest target, parcel or landmark"
                    onClick={() => {
                      act('quest_gm_jump', { ref: quest.ref });
                    }}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm
                    icon="check"
                    tooltip="Force complete the contract. It must be turned in at the Ledger except for blockades."
                    disabled={closed}
                    onClick={() => {
                      act('quest_gm_complete', { ref: quest.ref });
                    }}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm
                    icon="ban"
                    color="bad"
                    tooltip="Withdraw the contract and despawn its live targets."
                    onClick={() => {
                      act('quest_gm_withdraw', { ref: quest.ref });
                    }}
                  />
                </Stack.Item>
              </Stack>
            </Box>
          );
        })
      )}
    </Section>
  );
}
