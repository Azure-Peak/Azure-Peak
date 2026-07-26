import { useState } from 'react';
import {
  Box,
  Button,
  NoticeBox,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type TriumphItem = {
  ref: string;
  desc: string;
  cost: number;
  buyer: string | null;
  state: 'buy' | 'unbuy' | 'conflict' | 'round_started';
};

type Data = {
  triumphs: number;
  categories: string[];
  items: Record<string, TriumphItem[]>;
};

const ItemRow = (props: { item: TriumphItem }) => {
  const { act } = useBackend<Data>();
  const { item } = props;
  return (
    <Stack align="center" mb={0.5}>
      <Stack.Item grow>
        {item.desc}
        {item.buyer && (
          <Box inline color="label" ml={1}>
            | Bought by: {item.buyer}
          </Box>
        )}
      </Stack.Item>
      <Stack.Item bold width="40px" textAlign="center">
        {item.cost}
      </Stack.Item>
      <Stack.Item width="110px" textAlign="center">
        {item.state === 'buy' && (
          <Button fluid onClick={() => act('buy', { ref: item.ref })}>
            BUY
          </Button>
        )}
        {item.state === 'unbuy' && (
          <Button
            fluid
            color="bad"
            onClick={() => act('buy', { ref: item.ref })}
          >
            UNBUY
          </Button>
        )}
        {item.state === 'conflict' && (
          <Box color="bad" style={{ textDecoration: 'line-through' }}>
            CONFLICT
          </Box>
        )}
        {item.state === 'round_started' && (
          <Box color="bad" style={{ textDecoration: 'line-through' }}>
            ROUND STARTED
          </Box>
        )}
      </Stack.Item>
    </Stack>
  );
};

export function TriumphBuyMenu(props) {
  const { data } = useBackend<Data>();
  const [category, setCategory] = useState(data.categories[0]);
  const items = data.items[category] || [];
  return (
    <Window width={520} height={700} theme="parchment" title="Triumph Buys">
      <Window.Content scrollable>
        <NoticeBox info>I have {data.triumphs} Triumphs</NoticeBox>
        <Tabs>
          {data.categories.map((cat) => (
            <Tabs.Tab
              key={cat}
              selected={cat === category}
              onClick={() => setCategory(cat)}
            >
              {cat}
            </Tabs.Tab>
          ))}
        </Tabs>
        <Section>
          <Stack bold color="label" mb={1}>
            <Stack.Item grow>Description</Stack.Item>
            <Stack.Item width="40px" textAlign="center">
              Cost
            </Stack.Item>
            <Stack.Item width="110px" textAlign="center">
              Redeem
            </Stack.Item>
          </Stack>
          {items.map((item) => (
            <ItemRow key={item.ref} item={item} />
          ))}
          {items.length === 0 && (
            <Box color="label" italic textAlign="center">
              Currently nothing here.
            </Box>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
}
