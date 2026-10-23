import type { ReactNode } from 'react';
import {
  Box,
  Button,
  NumberInput,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';

import { ELLIPSIS, type QuestEntry, TRAILING } from './types';

type Props = {
  title: string;
  entries: QuestEntry[];
  total: number;
  cap: number;
  onCount: (path: string, count: number) => void;
  summary?: ReactNode;
  children?: ReactNode;
};

export function QuestEntryList(props: Props) {
  const { title, entries, total, cap, onCount, summary, children } = props;

  return (
    <Section
      title={`${title} (${total}/${cap})`}
      buttons={summary && <Box color="label">{summary}</Box>}
    >
      {children}
      {entries.map((entry) => (
        <Stack key={entry.path} align="center" mb={0.2}>
          <Stack.Item grow style={ELLIPSIS}>
            <Tooltip content={entry.path}>
              <Box style={ELLIPSIS}>{entry.name}</Box>
            </Tooltip>
          </Stack.Item>
          {entry.threat !== undefined && (
            <Stack.Item style={TRAILING}>tp {entry.threat}</Stack.Item>
          )}
          <Stack.Item>
            <NumberInput
              width="3rem"
              minValue={0}
              maxValue={entry.count + cap - total}
              step={1}
              value={entry.count}
              onChange={(value) => {
                onCount(entry.path, value);
              }}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="xmark"
              color="transparent"
              onClick={() => {
                onCount(entry.path, 0);
              }}
            />
          </Stack.Item>
        </Stack>
      ))}
    </Section>
  );
}
