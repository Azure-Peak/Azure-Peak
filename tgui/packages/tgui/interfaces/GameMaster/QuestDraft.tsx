import {
  Box,
  Button,
  Dropdown,
  Input,
  LabeledList,
  NumberInput,
  Section,
  Stack,
  TextArea,
} from 'tgui-core/components';

import { useBackend } from '../../backend';
import { QuestEntryList } from './QuestEntryList';
import { QuestItemPicker } from './QuestItemPicker';
import type { GameMasterData } from './types';

export function QuestDraft() {
  const { act, data } = useBackend<GameMasterData>();
  const { quest, quest_static } = data;
  if (!quest) {
    return null;
  }

  const recovery = quest.kind === quest_static.recovery_kind;
  const levy = Math.round(quest.reward * quest.levy_rate);
  const guild = Math.round(quest.reward * quest_static.guild_cut_rate);
  const mobThreat = quest.mobs.reduce(
    (sum, mob) => sum + (mob.threat ?? 0) * mob.count,
    0,
  );

  function setField(field: string, value: string | number | boolean) {
    act('quest_set_field', { field, value });
  }

  const regionOptions = quest.regions.map((region) => ({
    value: region.name,
    displayText: `${region.name} (${region.free_landmarks} free)`,
  }));
  const destinationOptions = quest_static.destinations.map((destination) => ({
    value: destination.path,
    displayText: destination.name,
  }));

  return (
    <Section
      fill
      scrollable
      className="GameMaster__pane"
      title="Quest"
      buttons={
        <>
          <Button.Confirm
            compact
            color="bad"
            onClick={() => {
              act('quest_reset');
            }}
          >
            Reset
          </Button.Confirm>
          <Button
            compact
            color="good"
            icon="scroll"
            disabled={!quest.ready || !!quest.posted}
            onClick={() => {
              act('quest_post');
            }}
          >
            {quest.posted ? 'Posted' : 'Post'}
          </Button>
        </>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Type">
          <Button
            selected={!recovery}
            onClick={() => {
              setField('kind', quest_static.kill_kind);
            }}
          >
            Kill Quest
          </Button>
          <Button
            selected={recovery}
            onClick={() => {
              setField('kind', quest_static.recovery_kind);
            }}
          >
            Recovery Quest
          </Button>
        </LabeledList.Item>
        <LabeledList.Item
          label="Title"
          labelColor={quest.title ? undefined : 'bad'}
        >
          <Input
            fluid
            expensive
            maxLength={quest_static.title_len}
            value={quest.title}
            onChange={(value) => {
              setField('title', value);
            }}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Description" verticalAlign="top">
          <TextArea
            fluid
            expensive
            height="3em"
            maxLength={quest_static.description_len}
            placeholder={recovery ? undefined : quest_static.kill_objective}
            value={quest.description}
            onChange={(value) => {
              setField('description', value);
            }}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Foes">
          <Stack align="center">
            <Stack.Item basis="30%">
              <Input
                fluid
                expensive
                maxLength={quest_static.foe_len}
                placeholder={quest_static.default_group_word}
                value={quest.group_word}
                onChange={(value) => {
                  setField('group_word', value);
                }}
              />
            </Stack.Item>
            <Stack.Item color="label">of</Stack.Item>
            <Stack.Item grow>
              <Input
                fluid
                expensive
                maxLength={quest_static.foe_len}
                placeholder={quest_static.default_foe_name}
                value={quest.foe_name}
                onChange={(value) => {
                  setField('foe_name', value);
                }}
              />
            </Stack.Item>
          </Stack>
        </LabeledList.Item>
        <LabeledList.Item
          label="Region"
          labelColor={quest.region ? undefined : 'bad'}
        >
          <Dropdown
            fluid
            options={regionOptions}
            selected={quest.region}
            onSelected={(value) => {
              setField('region', value);
            }}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Reward">
          <NumberInput
            width="5rem"
            minValue={0}
            maxValue={quest_static.max_reward}
            step={1}
            value={quest.reward}
            onChange={(value) => {
              setField('reward', value);
            }}
          />
          <Box inline ml={1} color="label">
            Purse {quest.reward - levy - guild}
          </Box>
        </LabeledList.Item>
        <LabeledList.Item label="Threat bands">
          <NumberInput
            width="5rem"
            minValue={0}
            maxValue={quest_static.max_threat_bands}
            step={1}
            value={quest.threat_bands}
            onChange={(value) => {
              setField('threat_bands', value);
            }}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Posting">
          <Button
            selected={!quest.on_floor}
            onClick={() => {
              setField('on_floor', false);
            }}
          >
            Ledger
          </Button>
          <Button
            selected={!!quest.on_floor}
            onClick={() => {
              setField('on_floor', true);
            }}
          >
            Floor
          </Button>
        </LabeledList.Item>
        {!quest.on_floor && (
          <LabeledList.Item label="Fellowship">
            <NumberInput
              width="5rem"
              minValue={1}
              maxValue={quest_static.max_fellowship}
              step={1}
              value={quest.fellowship_size}
              onChange={(value) => {
                setField('fellowship_size', value);
              }}
            />
          </LabeledList.Item>
        )}
        {recovery && (
          <>
            <LabeledList.Item
              label="Shipment"
              labelColor={quest.shipment_name ? undefined : 'bad'}
            >
              <Input
                fluid
                expensive
                maxLength={quest_static.title_len}
                value={quest.shipment_name}
                onChange={(value) => {
                  setField('shipment_name', value);
                }}
              />
            </LabeledList.Item>
            <LabeledList.Item
              label="Delivery"
              labelColor={quest.destination ? undefined : 'bad'}
            >
              <Dropdown
                fluid
                options={destinationOptions}
                selected={quest.destination}
                onSelected={(value) => {
                  setField('destination', value);
                }}
              />
            </LabeledList.Item>
          </>
        )}
        <LabeledList.Item label="Crimes" verticalAlign="top">
          <TextArea
            fluid
            expensive
            height="4.5em"
            maxLength={quest_static.crimes_len}
            placeholder="Whereof they stand accused of:"
            value={quest.crimes}
            onChange={(value) => {
              setField('crimes', value);
            }}
          />
        </LabeledList.Item>
      </LabeledList>
      <QuestEntryList
        title="Mobs"
        entries={quest.mobs}
        total={quest.mob_total}
        cap={quest_static.mob_cap}
        summary={`tp ${mobThreat}`}
        onCount={(path, count) => {
          act('quest_set_mob_count', { path, count });
        }}
      />
      {recovery && <QuestItemPicker />}
    </Section>
  );
}
