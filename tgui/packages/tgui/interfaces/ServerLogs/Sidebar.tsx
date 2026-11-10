import { useState } from 'react';
import {
  Box,
  Button,
  Collapsible,
  Dropdown,
  Icon,
  Input,
  Section,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../../backend';
import { categoryColor, formatBytes, roundLabel } from './helpers';
import { type Data, type Source, SourceState } from './types';

export const RoundPicker = () => {
  const { act, data } = useBackend<Data>();
  const { days, day, rounds, round, live } = data;
  const index = day ? days.indexOf(day) : -1;

  return (
    <Section
      title="Round"
      buttons={
        <>
          <Button
            icon="satellite-dish"
            selected={live}
            tooltip="Jump to the round being played right now"
            onClick={() => act('live')}
          >
            Live
          </Button>
          <Button
            icon="sync"
            tooltip="Rescan folders and re-read files that grew"
            onClick={() => act('refresh')}
          />
        </>
      }
    >
      <Stack vertical>
        <Stack.Item>
          <Stack>
            <Stack.Item>
              <Button
                icon="chevron-left"
                tooltip="Previous day"
                disabled={index < 0 || index >= days.length - 1}
                onClick={() => act('day', { day: days[index + 1] })}
              />
            </Stack.Item>
            <Stack.Item grow>
              <Dropdown
                fluid
                options={days}
                selected={day ?? undefined}
                placeholder="Pick a day"
                onSelected={(value) => act('day', { day: value })}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="chevron-right"
                tooltip="Next day"
                disabled={index <= 0}
                onClick={() => act('day', { day: days[index - 1] })}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Dropdown
            fluid
            options={rounds.map((name) => ({
              value: name,
              displayText: roundLabel(name),
            }))}
            selected={round ?? undefined}
            displayText={round ? roundLabel(round) : 'Pick a round'}
            disabled={!rounds.length}
            onSelected={(value) => act('round', { round: value })}
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const SourceRow = (props: { source: Source }) => {
  const { act } = useBackend<Data>();
  const { source } = props;
  const huge = source.state === SourceState.Huge;

  return (
    <Box mb={0.5}>
      <Stack align="center">
        <Stack.Item grow>
          <Button.Checkbox
            fluid
            checked={source.on}
            disabled={huge}
            onClick={() => act('source', { name: source.name })}
          >
            {source.name}
          </Button.Checkbox>
        </Stack.Item>
        <Stack.Item color="label" fontSize={0.9}>
          {source.state === SourceState.Loading ? (
            <Icon name="spinner" spin />
          ) : huge ? (
            <Box inline color="bad">
              too big
            </Box>
          ) : (
            formatBytes(source.bytes)
          )}
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="download"
            tooltip="Download the raw file"
            onClick={() => act('download', { file: source.file })}
          />
        </Stack.Item>
      </Stack>
      {!!source.on && source.cats.length > 1 && (
        <Box ml={2}>
          {source.cats.map((cat) => (
            <Button.Checkbox
              key={cat.name}
              checked={cat.on}
              fontSize={0.9}
              onClick={() => act('cat', { name: cat.name })}
            >
              <Box inline color={categoryColor(cat.name)}>
                {cat.name}
              </Box>{' '}
              <Box inline color="label">
                {cat.count}
              </Box>
            </Button.Checkbox>
          ))}
        </Box>
      )}
    </Box>
  );
};

export const SourceList = () => {
  const { act, data } = useBackend<Data>();
  const { sources, others = [] } = data;

  return (
    <Section title="Logs" fill scrollable>
      {sources.map((source) => (
        <SourceRow key={source.name} source={source} />
      ))}
      {!sources.length && <Box color="label">No log files in this round.</Box>}
      {!!others.length && (
        <Collapsible title={`Other files (${others.length})`}>
          {others.map((file) => (
            <Stack key={file} align="center">
              <Stack.Item grow style={{ wordBreak: 'break-all' }}>
                {file}
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="external-link-alt"
                  tooltip="Open in your text editor"
                  onClick={() => act('download', { file, open: true })}
                />
                <Button
                  icon="download"
                  tooltip="Download"
                  onClick={() => act('download', { file })}
                />
              </Stack.Item>
            </Stack>
          ))}
        </Collapsible>
      )}
    </Section>
  );
};

export const PlayerList = () => {
  const { act, data } = useBackend<Data>();
  const { people, players, chars } = data;
  const [query, setQuery] = useState('');

  const needle = query.trim().toLowerCase();
  const known = new Set(people.map((person) => person.ckey));
  const shown = people.filter(
    (person) =>
      !needle ||
      person.ckey.includes(needle) ||
      person.key.toLowerCase().includes(needle) ||
      person.names.some((name) => name.toLowerCase().includes(needle)) ||
      person.jobs.some((job) => job.toLowerCase().includes(needle)),
  );
  const loose = players.filter((who) => !known.has(who));

  return (
    <Section
      title="Players"
      fill
      scrollable
      buttons={
        <Button.Checkbox
          checked={chars}
          tooltip="Also match entries that only mention a picked player's character names"
          onClick={() => act('chars')}
        >
          Characters
        </Button.Checkbox>
      }
    >
      <Input
        fluid
        placeholder="Find by ckey, name or job. Enter adds it."
        value={query}
        onChange={setQuery}
        onEnter={(value) => {
          if (value.trim()) {
            act('player', { who: value.trim() });
            setQuery('');
          }
        }}
      />
      {loose.map((who) => (
        <Button.Checkbox
          key={who}
          fluid
          checked
          mt={0.5}
          tooltip="Free text, not seen logging in this round"
          onClick={() => act('player', { who })}
        >
          {who}
        </Button.Checkbox>
      ))}
      {shown.map((person) => (
        <Box key={person.ckey} mt={0.5}>
          <Button.Checkbox
            fluid
            checked={players.includes(person.ckey)}
            onClick={() => act('player', { who: person.ckey })}
          >
            <b>{person.key}</b>
            {!!person.jobs.length && (
              <Box inline color="label" ml={1}>
                {person.jobs.join(', ')}
              </Box>
            )}
          </Button.Checkbox>
          {!!person.names.length && (
            <Box ml={2.5} color="label" fontSize={0.9}>
              {person.names.join(', ')}
            </Box>
          )}
        </Box>
      ))}
      {!people.length && (
        <Box color="label" mt={1}>
          Nobody found yet. Players show up once the game or manifest log is
          loaded.
        </Box>
      )}
    </Section>
  );
};
