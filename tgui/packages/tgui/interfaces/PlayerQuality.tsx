import { Box, LabeledList, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type CommendRow = {
  giver: string;
  amount: number;
};

type CurseRow = {
  name: string;
  enabled: BooleanLike;
};

type Data = {
  ckey: string;
  pq_text: string;
  pq_num: number;
  commends: number;
  roundpoints: number;
  roundsplayed: number;
  history: string[];
  is_admin: BooleanLike;
  commend_rows?: CommendRow[];
  curse_rows?: CurseRow[];
};

export function PlayerQuality(props) {
  const { data } = useBackend<Data>();
  return (
    <Window width={420} height={560} theme="parchment" title="Player Quality">
      <Window.Content scrollable>
        <Section textAlign="center">
          <Box bold>{data.ckey}</Box>
          <Box>
            PQ: {/* PQ rating text is server-authored colored HTML */}
            <span dangerouslySetInnerHTML={{ __html: data.pq_text }} /> (
            {data.pq_num})
          </Box>
        </Section>
        <Section>
          <Stack textAlign="center">
            <Stack.Item grow>
              Commends: <b>{data.commends}</b>
            </Stack.Item>
            <Stack.Item grow>
              Round Contributor Points: <b>{data.roundpoints}</b>
            </Stack.Item>
            <Stack.Item grow>
              Rounds Survived: <b>{data.roundsplayed}</b>
            </Stack.Item>
          </Stack>
        </Section>
        {!!data.is_admin && (
          <Section title="Curses">
            <LabeledList>
              {(data.curse_rows || []).map((curse) => (
                <LabeledList.Item key={curse.name} label={curse.name}>
                  <Box color={curse.enabled ? 'bad' : 'good'} bold>
                    {curse.enabled ? 'ENABLED' : 'DISABLED'}
                  </Box>
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>
        )}
        {!!data.is_admin && (data.commend_rows || []).length > 0 && (
          <Section title="Commends">
            <LabeledList>
              {(data.commend_rows || []).map((row) => (
                <LabeledList.Item key={row.giver} label={row.giver}>
                  {row.amount}
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>
        )}
        <Section title="History">
          {data.history.length === 0 && (
            <Box italic color="label">
              No data on record. Create some.
            </Box>
          )}
          {data.history.map((line, i) => (
            <Box key={i} mb={0.5}>
              {/* History lines are server-authored and may contain markup */}
              <span dangerouslySetInnerHTML={{ __html: line }} />
            </Box>
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
}
