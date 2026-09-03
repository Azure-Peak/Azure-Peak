import {
  Button,
  Dropdown,
  NumberInput,
  Section,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../../backend';
import {
  type GameMasterData,
  NATIVE_FACTION_LABEL,
  NATIVE_FACTION_VALUE,
  toTitle,
} from './types';

export function ActionStrip(props) {
  const { act, data } = useBackend<GameMasterData>();
  const {
    selected_faction,
    spawn_count,
    spawn_ai,
    spawn_taints_loot,
    spawn_dust,
    spawn_dust_leave_head,
    spawn_dust_delete_gear,
    spawn_click_intercept,
    spawn_factions = [],
  } = data;

  const factionOptions = [
    { value: NATIVE_FACTION_VALUE, displayText: NATIVE_FACTION_LABEL },
    ...spawn_factions.map((value) => ({ value, displayText: toTitle(value) })),
  ];

  return (
    <Section>
      <Stack vertical>
        <Stack.Item>
          <Stack align="center">
            <Stack.Item>
              <NumberInput
                width="3.5rem"
                minValue={1}
                maxValue={10}
                step={1}
                value={spawn_count}
                onChange={(value) => {
                  act('set_spawn_count', { value });
                }}
              />
            </Stack.Item>
            <Stack.Item>
              <Button.Checkbox
                compact
                checked={spawn_ai}
                onClick={() => {
                  act('toggle_spawn_ai');
                }}
              >
                AI
              </Button.Checkbox>
            </Stack.Item>
            <Stack.Item>
              <Button.Checkbox
                compact
                checked={spawn_taints_loot}
                tooltip="Worn gear sells for 25%"
                onClick={() => {
                  act('toggle_spawn_taints_loot');
                }}
              >
                Taint loot
              </Button.Checkbox>
            </Stack.Item>
            <Stack.Item>
              <Button.Checkbox
                compact
                checked={spawn_dust}
                tooltip="Turns to dust on death"
                onClick={() => {
                  act('toggle_spawn_dust');
                }}
              >
                Dust
              </Button.Checkbox>
            </Stack.Item>
            {!!spawn_dust && (
              <>
                <Stack.Item>
                  <Button.Checkbox
                    compact
                    checked={spawn_dust_leave_head}
                    onClick={() => {
                      act('toggle_spawn_dust_leave_head');
                    }}
                  >
                    Head
                  </Button.Checkbox>
                </Stack.Item>
                <Stack.Item>
                  <Button.Checkbox
                    compact
                    checked={spawn_dust_delete_gear}
                    onClick={() => {
                      act('toggle_spawn_dust_delete_gear');
                    }}
                  >
                    Gear
                  </Button.Checkbox>
                </Stack.Item>
              </>
            )}
            <Stack.Item grow>
              <Dropdown
                width="100%"
                menuWidth="12rem"
                searchInput
                options={factionOptions}
                selected={selected_faction}
                displayText={`Faction: ${
                  selected_faction
                    ? toTitle(selected_faction)
                    : NATIVE_FACTION_LABEL
                }`}
                onSelected={(new_faction) => {
                  act('set_selected_faction', { new_faction });
                }}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Stack align="center">
            <Stack.Item grow>
              <Button
                fluid
                textAlign="center"
                icon="location-crosshairs"
                selected={spawn_click_intercept}
                tooltip="Left click to spawn, middle click to delete."
                onClick={() => {
                  act('toggle_click_spawn');
                }}
              >
                Click Spawn
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                color="bad"
                onClick={() => {
                  act('delete_spawned_all');
                }}
              >
                Delete all spawned
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                color="bad"
                onClick={() => {
                  act('delete_npcs_in_view');
                }}
              >
                Delete viewed
              </Button>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
}
