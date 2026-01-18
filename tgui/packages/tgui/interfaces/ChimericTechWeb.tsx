import { Dispatch, SetStateAction, useState } from 'react';
import {
  Box,
  Button,
  Input,
  NoticeBox,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type TechNode = {
  name: string;
  desc: string;
  cost: number;
  path: string;
  required_tier: number;
  can_afford: boolean;
};

type UnlockedNode = {
  name: string;
  desc: string;
  tier: number;
};

type Data = {
  choices: TechNode[];
  unlocked: UnlockedNode[];
  points: number;
  tier: number;
};

// EXACT COPY FROM ANVIL
export const SearchBar = (props: {
  search: string;
  setSearch: Dispatch<SetStateAction<string>>;
}) => {
  const { search, setSearch } = props;
  return <Input value={search} onChange={setSearch} fluid />;
};

export const ChimericTechWeb = (props) => {
  const [search, setSearch] = useState('');
  const [tab, setTab] = useState('research');
  const { act, data } = useBackend<Data>();

  const { choices = [], unlocked = [], points, tier } = data;

  // Filter Research Tab
  const filteredChoices = choices
    .filter((node) => {
      if (search) {
        return node.name.toLowerCase().includes(search.toLowerCase());
      }
      return true;
    })
    .sort((a, b) => 
      (b.can_afford as any) - (a.can_afford as any) ||
      a.required_tier - b.required_tier ||
      a.name.localeCompare(b.name)
    );

  // Filter History Tab
  const filteredUnlocked = unlocked.filter((node) => {
    if (search) {
      return node.name.toLowerCase().includes(search.toLowerCase());
    }
    return true;
  });

  return (
    <Window width={600} height={500} title="Chimeric Tech Web">
      <Window.Content scrollable>
        {/* Status Header */}
        <Section>
          <Stack align="center" justify="space-between">
            <Stack.Item>
               <Box color="label">Points: <Box inline color="white" bold>{points}</Box></Box>
               <Box color="label">Tier: <Box inline color="white" bold>{tier}</Box></Box>
            </Stack.Item>
            <Stack.Item>
              <Tabs>
                <Tabs.Tab 
                  selected={tab === 'research'} 
                  onClick={() => setTab('research')}>
                  Available ({choices.length})
                </Tabs.Tab>
                <Tabs.Tab 
                  selected={tab === 'history'} 
                  onClick={() => setTab('history')}>
                  Unlocked ({unlocked.length})
                </Tabs.Tab>
              </Tabs>
            </Stack.Item>
          </Stack>
        </Section>

        {/* Research View */}
        {tab === 'research' && (
          <Section
            title="Available Research"
            buttons={<SearchBar search={search} setSearch={setSearch} />}
          >
            {filteredChoices.length === 0 && (
              <NoticeBox>No research matches your search.</NoticeBox>
            )}
            {filteredChoices.map((node) => (
              <Box 
                key={node.path} 
                mb={1} 
                py={1} 
                style={{ borderBottom: '1px solid rgba(255,255,255,0.1)' }}
              >
                <Stack align="center">
                  <Stack.Item grow>
                    <Box bold fontSize="1.1em" color="teal">{node.name}</Box>
                    <Box color="label">Tier {node.required_tier} | Cost {node.cost}</Box>
                    <Box italic color="gray">{node.desc}</Box>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="flask"
                      color={node.can_afford ? 'good' : 'bad'}
                      disabled={!node.can_afford}
                      onClick={() => act('unlock_node', { path: node.path })}
                    >
                      {node.can_afford ? 'Unlock' : 'Too Expensive'}
                    </Button>
                  </Stack.Item>
                </Stack>
              </Box>
            ))}
          </Section>
        )}

        {/* History View */}
        {tab === 'history' && (
          <Section 
            title="Unlocked Knowledge"
            buttons={<SearchBar search={search} setSearch={setSearch} />}
          >
            {filteredUnlocked.length === 0 && (
              <NoticeBox>No discovered technologies found.</NoticeBox>
            )}
            {filteredUnlocked.map((node, i) => (
              <Box 
                key={i} 
                mb={1} 
                py={1} 
                style={{ borderBottom: '1px solid rgba(255,255,255,0.1)' }}
              >
                <Box bold color="good">{node.name}</Box>
                <Box color="label" fontSize="0.9em">Tier {node.tier}</Box>
                <Box color="white" mt={0.5}>{node.desc}</Box>
              </Box>
            ))}
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
