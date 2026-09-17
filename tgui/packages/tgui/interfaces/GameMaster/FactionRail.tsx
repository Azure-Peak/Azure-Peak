import { Box, Button, Icon, Input, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../../backend';
import {
  ELLIPSIS,
  FILTER_ALL,
  filterLabel,
  type GameMasterData,
  ROW,
  TRAILING,
} from './types';

type Props = {
  query: string;
  onQuery: (value: string) => void;
};

export function FactionRail(props: Props) {
  const { query, onQuery } = props;
  const { act, data } = useBackend<GameMasterData>();
  const {
    selected_filter,
    pinned_factions = [],
    spawn_filters = [],
    filter_counts = {},
    max_pinned,
  } = data;

  const needle = query.toLowerCase();
  const matches = spawn_filters.filter((value) =>
    filterLabel(value).toLowerCase().includes(needle),
  );
  const pinned = matches.filter((value) => pinned_factions.includes(value));
  const rest = matches.filter((value) => !pinned_factions.includes(value));

  function renderRow(value: string) {
    const isPinned = pinned_factions.includes(value);
    const pinnable = value !== FILTER_ALL;
    const atCap = !isPinned && pinned_factions.length >= max_pinned;

    return (
      <Stack key={value} align="center" mb={0.2}>
        <Stack.Item shrink={0}>
          {pinnable ? (
            <Icon
              name={isPinned ? 'star' : 'star-o'}
              mr={0.5}
              style={{
                cursor: atCap ? 'default' : 'pointer',
                opacity: isPinned ? 1 : atCap ? 0.15 : 0.35,
              }}
              onClick={() => {
                if (!atCap) {
                  act('toggle_pin_faction', { faction: value });
                }
              }}
            />
          ) : (
            <Box inline mr={0.5} width="1em" />
          )}
        </Stack.Item>
        <Stack.Item grow style={{ minWidth: 0 }}>
          <Button
            fluid
            compact
            selected={selected_filter === value}
            onClick={() => {
              act('set_selected_filter', { new_filter: value });
            }}
          >
            <Box style={ROW}>
              <Box style={ELLIPSIS}>{filterLabel(value)}</Box>
              <Box style={TRAILING}>{filter_counts[value] ?? 0}</Box>
            </Box>
          </Button>
        </Stack.Item>
      </Stack>
    );
  }

  return (
    <Section fill className="GameMaster__pane" title="Factions">
      <Stack fill vertical>
        <Stack.Item>
          <Input
            fluid
            placeholder="Filter..."
            value={query}
            onChange={onQuery}
          />
        </Stack.Item>
        <Stack.Item
          grow
          mt={0.5}
          style={{ overflowY: 'auto', overflowX: 'hidden', minWidth: 0 }}
        >
          {pinned.length > 0 && (
            <>
              {pinned.map(renderRow)}
              <Box mt={0.5} mb={0.5} style={{ borderTop: '1px solid rgba(122, 86, 22, 0.35)' }} />
            </>
          )}
          {rest.map(renderRow)}
        </Stack.Item>
      </Stack>
    </Section>
  );
}
