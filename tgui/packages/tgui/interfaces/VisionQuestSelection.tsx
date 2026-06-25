import { useState } from 'react';
import { Box, Button, Icon, NoticeBox, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type RewardOption = {
  path: string;
  name: string;
};

type QuestChoice = {
  id: string;
  name: string;
  summary: string;
  target_name: string;
  target_description: string;
  rewards: RewardOption[];
  bonus_reward_name: string;
};

type Data = {
  choices: QuestChoice[];
};

export const VisionQuestSelection = (props) => {
  const { act, data } = useBackend<Data>();
  const [selectedQuestId, setSelectedQuestId] = useState<string | null>(null);
  const [selectedReward, setSelectedReward] = useState<string | null>(null);

  const { choices = [] } = data;
  const selectedQuest = choices.find((q) => q.id === selectedQuestId);

  const handleSelectQuest = (questId: string) => {
    setSelectedQuestId(questId);
    setSelectedReward(null);
  };

  const handleSelectReward = (path: string) => {
    setSelectedReward(path);
  };

  const handleConfirm = () => {
    if (selectedQuest && selectedReward) {
      act('confirm_quest', {
        quest_id: selectedQuest.id,
        reward_path: selectedReward,
      });
    }
  };

  return (
    <Window width={850} height={600} title="Vision Quest Selection">
      <Window.Content scrollable>
        <Section title="Available Visions">
          <Stack>
            <Stack.Item grow={1}>
              <NoticeBox info>
                <Icon name="eye" /> Choose a vision to pursue.
              </NoticeBox>
              {choices.length === 0 && (
                <NoticeBox>No visions are available.</NoticeBox>
              )}
              {choices.map((quest) => (
                <Box
                  key={quest.id}
                  mb={1}
                  p={1}
                  style={{
                    border: `1px solid ${selectedQuestId === quest.id ? '#ffffff' : 'rgba(255,255,255,0.1)'}`,
                    borderRadius: '4px',
                    cursor: 'pointer',
                  }}
                  onClick={() => handleSelectQuest(quest.id)}
                >
                  <Box bold>{quest.name}</Box>
                  <Box color="label" fontSize="0.9em">
                    Target: {quest.target_description}
                  </Box>
                  <Box color="gray" fontSize="0.9em" italic>
                    {quest.summary}
                  </Box>
                </Box>
              ))}
            </Stack.Item>

            <Stack.Item grow={1.5}>
              {selectedQuest ? (
                <Box>
                  <Section title="Vision Details">
                    <Box bold>{selectedQuest.name}</Box>
                    <Box color="label" fontSize="0.9em">
                      Target: {selectedQuest.target_name} ({selectedQuest.target_description})
                    </Box>
                  </Section>

                  <Section title="Choose Your Reward (x3)">
                    <Stack wrap>
                      {selectedQuest.rewards.map((reward) => (
                        <Stack.Item key={reward.path}>
                          <Button
                            selected={selectedReward === reward.path}
                            onClick={() => handleSelectReward(reward.path)}
                          >
                            {reward.name}
                          </Button>
                        </Stack.Item>
                      ))}
                    </Stack>
                  </Section>

                  <Section title="Locked Bonus Reward">
                    <NoticeBox info>
                      <Icon name="gift" /> Pre-destined Bonus: <b>{selectedQuest.bonus_reward_name}</b>
                    </NoticeBox>
                  </Section>

                  <Button
                    fluid
                    mt={1}
                    color="good"
                    disabled={!selectedReward}
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
