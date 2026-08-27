import { Box, Button, Input, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../../backend';
import {
  ELLIPSIS,
  filterLabel,
  type GameMasterData,
  ROW,
  TRAILING,
  VIEW_INDIVIDUAL,
  VIEW_WARBAND,
} from './types';

type Props = {
  query: string;
  onQuery: (value: string) => void;
};

export function CreaturePane(props: Props) {
  const { query, onQuery } = props;
  const { act, data } = useBackend<GameMasterData>();
  const {
    selected_view,
    selected_filter,
    selected_mob_name,
    selectable_mobs = [],
    mob_threats = {},
  } = data;

  const warband = selected_view === VIEW_WARBAND;
  const needle = query.toLowerCase();
  const shown = selectable_mobs.filter((name) =>
    name.toLowerCase().includes(needle),
  );

  return (
    <Section
      fill
      className="GameMaster__pane"
      title={warband ? 'Warbands' : 'Creatures'}
      buttons={
        <>
          <Button
            compact
            selected={!warband}
            onClick={() => {
              act('set_selected_view', { new_view: VIEW_INDIVIDUAL });
            }}
          >
            Individual
          </Button>
          <Button
            compact
            selected={warband}
            tooltip="Not built yet - reserved for the ambush config rework."
            onClick={() => {
              act('set_selected_view', { new_view: VIEW_WARBAND });
            }}
          >
            Warband
          </Button>
        </>
      }
    >
      <Stack fill vertical>
        <Stack.Item>
          <Input
            fluid
            placeholder={`Search ${filterLabel(selected_filter).toLowerCase()}...`}
            value={query}
            onChange={onQuery}
          />
        </Stack.Item>
        <Stack.Item
          grow
          mt={0.5}
          style={{ overflowY: 'auto', overflowX: 'hidden', minWidth: 0 }}
        >
          {warband ? (
            <Box color="label" mt={1} textAlign="center">
              No warbands yet.
              <br />
              Reserved for the ambush config rework.
            </Box>
          ) : shown.length === 0 ? (
            <Box color="label" mt={1} textAlign="center">
              Nothing matches.
            </Box>
          ) : (
            shown.map((name) => (
              <Button
                key={name}
                fluid
                compact
                selected={name === selected_mob_name}
                onClick={() => {
                  act('set_selected_mob', { new_mob: name });
                }}
              >
                <Box style={ROW}>
                  <Box style={ELLIPSIS}>{name}</Box>
                  <Box style={TRAILING}>{mob_threats[name] ?? 0}</Box>
                </Box>
              </Button>
            ))
          )}
        </Stack.Item>
      </Stack>
    </Section>
  );
}
