import { useEffect, useMemo, useRef, useState } from 'react';
import {
  Box,
  Button,
  Icon,
  Input,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../../backend';
import {
  buildMarker,
  categoryColor,
  clockOf,
  highlight,
  prettyData,
} from './helpers';
import type { Data, Filters, Row } from './types';

const filtersOf = (data: Data): Filters => ({
  search: data.search,
  pattern: !!data.pattern,
  exclude: data.exclude,
  from: data.from,
  till: data.till,
});

export const FilterBar = () => {
  const { act, data } = useBackend<Data>();
  const { busy, error, total, newest } = data;
  const [draft, setDraft] = useState<Filters>(filtersOf(data));

  useEffect(() => {
    setDraft(filtersOf(data));
  }, [data.search, data.pattern, data.exclude, data.from, data.till]);

  const apply = (changes: Partial<Filters> = {}) => {
    const next = { ...draft, ...changes };
    setDraft(next);
    act('filter', next);
  };
  const edit = (key: keyof Filters) => (value: string) =>
    setDraft({ ...draft, [key]: value });

  return (
    <Section>
      <Stack vertical>
        <Stack.Item>
          <Stack align="center">
            <Stack.Item grow={2}>
              <Input
                fluid
                placeholder={
                  draft.pattern ? 'Regex, e.g. stab|slash' : 'Contains text...'
                }
                value={draft.search}
                onChange={edit('search')}
                onEnter={() => apply()}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="code"
                selected={draft.pattern}
                tooltip="Treat the search as a regex"
                onClick={() => apply({ pattern: !draft.pattern })}
              />
            </Stack.Item>
            <Stack.Item grow={1}>
              <Input
                fluid
                placeholder="Hide entries with... (comma separated)"
                value={draft.exclude}
                onChange={edit('exclude')}
                onEnter={() => apply()}
              />
            </Stack.Item>
            <Stack.Item>
              <Input
                width="70px"
                placeholder="From"
                value={draft.from}
                onChange={edit('from')}
                onEnter={() => apply()}
              />
            </Stack.Item>
            <Stack.Item>
              <Input
                width="70px"
                placeholder="To"
                value={draft.till}
                onChange={edit('till')}
                onEnter={() => apply()}
              />
            </Stack.Item>
            <Stack.Item>
              <Button icon="filter" onClick={() => apply()}>
                Apply
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="eraser"
                color="bad"
                tooltip="Clear every filter, including picked players"
                onClick={() => act('clear')}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Stack align="center">
            <Stack.Item grow color="label">
              {busy ? (
                <>
                  <Icon name="spinner" spin /> Reading logs...
                </>
              ) : (
                `${total.toLocaleString()} entries`
              )}
            </Stack.Item>
            <Stack.Item>
              <Button
                icon={newest ? 'sort-amount-down' : 'sort-amount-up'}
                onClick={() => act('newest')}
              >
                {newest ? 'Newest first' : 'Oldest first'}
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="file-export"
                disabled={!total || !!busy}
                tooltip="Export logs with current filters"
                onClick={() => act('export')}
              >
                Export
              </Button>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        {!!error && (
          <Stack.Item>
            <NoticeBox danger>{error}</NoticeBox>
          </Stack.Item>
        )}
      </Stack>
    </Section>
  );
};

const EntryRow = (props: {
  row: Row;
  marker: RegExp | null;
  focused: boolean;
}) => {
  const { act, data } = useBackend<Data>();
  const { row, marker, focused } = props;
  const [open, setOpen] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (focused) {
      ref.current?.scrollIntoView({ block: 'center' });
    }
  }, [focused]);

  const setTime = (key: 'from' | 'till') =>
    act('filter', { ...filtersOf(data), [key]: clockOf(row.ts) });

  return (
    <div
      ref={ref}
      style={{
        padding: '2px 4px',
        borderBottom: '1px solid rgba(255, 255, 255, 0.06)',
        background: focused
          ? 'rgba(255, 200, 0, 0.15)'
          : open
            ? 'rgba(255, 255, 255, 0.05)'
            : undefined,
      }}
    >
      <Stack onClick={() => setOpen(!open)} style={{ cursor: 'pointer' }}>
        <Stack.Item color="label" fontFamily="monospace">
          {clockOf(row.ts)}
        </Stack.Item>
        <Stack.Item
          width="110px"
          color={categoryColor(row.cat)}
          style={{ overflow: 'hidden', textOverflow: 'ellipsis' }}
        >
          {row.cat}
        </Stack.Item>
        <Stack.Item
          grow
          basis={0}
          style={{ whiteSpace: 'pre-wrap', wordBreak: 'break-word' }}
        >
          {highlight(row.msg, marker)}
          {!!row.data && <Icon name="database" color="label" ml={1} />}
        </Stack.Item>
      </Stack>
      {open && (
        <Box ml={2} mt={0.5} mb={0.5}>
          <Box color="label">
            {row.ts} · {row.src} · entry {row.i}
          </Box>
          <Box mt={0.5}>
            <Button
              icon="crosshairs"
              tooltip="Drop the text, player and time filters and jump here"
              onClick={() => act('context', { src: row.src, i: row.i })}
            >
              Show in context
            </Button>
            <Button icon="hourglass-start" onClick={() => setTime('from')}>
              From here
            </Button>
            <Button icon="hourglass-end" onClick={() => setTime('till')}>
              To here
            </Button>
          </Box>
          {!!row.data && (
            <Box
              as="pre"
              mt={0.5}
              p={0.5}
              style={{
                background: 'rgba(0, 0, 0, 0.3)',
                whiteSpace: 'pre-wrap',
                wordBreak: 'break-word',
              }}
            >
              {prettyData(row.data)}
            </Box>
          )}
        </Box>
      )}
    </div>
  );
};

export const EntryList = () => {
  const { data } = useBackend<Data>();
  const { rows, marks, search, pattern, focus, busy, total, sources } = data;
  const ticked = sources.some((source) => source.on);
  const marker = useMemo(
    () => buildMarker(marks, search, !!pattern),
    [marks.join('\n'), search, pattern],
  );

  return (
    <Section fill scrollable>
      {rows.map((row) => {
        const id = `${row.src}:${row.i}`;
        return (
          <EntryRow key={id} row={row} marker={marker} focused={focus === id} />
        );
      })}
      {!total && !busy && (
        <Box color="label" textAlign="center" mt={4}>
          {ticked
            ? 'Nothing matches. Tick more logs on the left or loosen the filters.'
            : 'Tick a log on the left to start.'}
        </Box>
      )}
    </Section>
  );
};

export const Pager = () => {
  const { act, data } = useBackend<Data>();
  const { page, pages } = data;
  const go = (to: number) => act('page', { page: to });

  return (
    <Stack align="center" justify="center">
      <Stack.Item>
        <Button
          icon="angle-double-left"
          disabled={page <= 1}
          onClick={() => go(1)}
        />
        <Button
          icon="angle-left"
          disabled={page <= 1}
          onClick={() => go(page - 1)}
        />
      </Stack.Item>
      <Stack.Item>
        Page{' '}
        <Input
          width="50px"
          value={String(page)}
          onEnter={(value) => go(Number.parseInt(value, 10) || 1)}
        />{' '}
        of {pages}
      </Stack.Item>
      <Stack.Item>
        <Button
          icon="angle-right"
          disabled={page >= pages}
          onClick={() => go(page + 1)}
        />
        <Button
          icon="angle-double-right"
          disabled={page >= pages}
          onClick={() => go(pages)}
        />
      </Stack.Item>
    </Stack>
  );
};
