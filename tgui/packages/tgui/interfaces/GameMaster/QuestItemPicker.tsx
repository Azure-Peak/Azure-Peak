import { Box, Button, Input } from 'tgui-core/components';

import { useBackend } from '../../backend';
import { QuestEntryList } from './QuestEntryList';
import type { GameMasterData } from './types';

export function QuestItemPicker() {
  const { act, data } = useBackend<GameMasterData>();
  const { quest, quest_static } = data;
  if (!quest) {
    return null;
  }

  return (
    <QuestEntryList
      title="Items"
      entries={quest.items}
      total={quest.item_total}
      cap={quest_static.item_cap}
      onCount={(path, count) => {
        act('quest_set_item_count', { path, count });
      }}
    >
      <Input
        fluid
        expensive
        placeholder="Search items..."
        value={quest.item_query}
        onChange={(query) => {
          act('quest_search_items', { query });
        }}
      />
      {quest.item_results.length > 0 && (
        <Box mt={0.5} mb={0.5} style={{ maxHeight: '8em', overflowY: 'auto' }}>
          {quest.item_results.map((result) => (
            <Button
              key={result.path}
              fluid
              compact
              icon="plus"
              tooltip={result.path}
              disabled={quest.item_total >= quest_static.item_cap}
              onClick={() => {
                act('quest_add_item', { path: result.path, count: 1 });
              }}
            >
              {result.name}
            </Button>
          ))}
        </Box>
      )}
    </QuestEntryList>
  );
}
