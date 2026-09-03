import {
  ColorButton,
  ensureColorHash,
  LabeledGridList,
  LabeledListLikeTooltip,
} from 'pm/components';
import {
  type ConstantData,
  CulinaryAxisNames,
  getCulinaryBitflagFromName,
  getCulinaryDataForAxis,
  getCulinaryNameFromBitflag,
  useConstantPrefs,
} from 'pm/constant_data';
import {
  CLOTHESPREF_TO_ICON,
  PRONOUN_TO_ICON,
  TITLEPREF_TO_ICON,
  VOICETYPE_TO_ICON,
} from 'pm/constants';
import {
  SubtabIdentityDownstreamPaneLeft,
  SubtabIdentityDownstreamPaneRight,
} from 'pm/downstream/tabs/CharacterCreator/subtabs/Identity';
import { usePopupId } from 'pm/popups';
import { useBackendStrict } from 'tgui/backend';
import { LoadingScreen } from 'tgui/interfaces/common/LoadingScreen';
import {
  Box,
  Button,
  Dropdown,
  Section,
  Slider,
  Stack,
} from 'tgui-core/components';
import { classes } from 'tgui-core/react';
import type { AllPagesData, IdentityData, VirtueWithMetadata } from '../data';

export const SubtabIdentity = (props) => {
  return (
    <Section
      fill
      scrollable
      className="PreferencesMenu__Section__NoChildPadding "
    >
      <Box className="PreferencesMenu__Grid PreferencesMenu__TwoColumn">
        <Stack vertical>
          <Stack.Item>
            <SubtabIdentityCardInfo />
          </Stack.Item>
          <Stack.Item>
            <SubtabIdentityCardVoice />
          </Stack.Item>
          <Stack.Item>
            <SubtabIdentityCardBark />
          </Stack.Item>
          <SubtabIdentityDownstreamPaneLeft />
        </Stack>
        <Stack vertical>
          <Stack.Item>
            <SubtabIdentityCardGameplay />
          </Stack.Item>
          <Stack.Item>
            <SubtabIdentityCardVirtues />
          </Stack.Item>
          <Stack.Item>
            <SubtabIdentityCardVices />
          </Stack.Item>
          <SubtabIdentityDownstreamPaneRight />
        </Stack>
      </Box>
    </Section>
  );
};

export const SubtabIdentityCardInfo = (props) => {
  const { act, data } = useBackendStrict<AllPagesData & IdentityData>();
  const {
    clothes_pref,
    highlight_color,
    nickname,
    pronouns,
    race_bonus,
    real_name,
    species_base_name,
    species_check,
    species_sub_name,
    titles_pref,
  } = data;
  const [, setPopupId] = usePopupId();

  return (
    <Section title="Info">
      <LabeledGridList>
        <LabeledGridList.Item
          label={
            <Box inline fontSize={1.1}>
              Race:
            </Box>
          }
          labelColor="yellow"
          tooltip="SELECT THIS FIRST! Selecting race will reset all visual features and some gameplay options."
          tooltipPosition="bottom-start"
        >
          <Button fluid icon="bars" onClick={() => setPopupId('Species')}>
            {species_base_name}
            {species_base_name !== species_sub_name
              ? ` \u21D2 ${species_sub_name}`
              : null}{' '}
            {species_check ? null : '(!)'}
          </Button>
        </LabeledGridList.Item>
        {race_bonus !== null ? (
          <LabeledGridList.Item label="Race Bonus">
            <Button fluid onClick={() => act('race_bonus_select')}>
              {race_bonus || 'None'}
            </Button>
          </LabeledGridList.Item>
        ) : null}
        <LabeledGridList.Item label="Name" verticalAlign="center">
          <Stack>
            <Stack.Item grow>
              <Button
                fluid
                style={{
                  wordBreak: 'break-word',
                  whiteSpace: 'wrap',
                }}
                onClick={() => act('real_name')}
              >
                {real_name}
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="dice"
                tooltip="Randomize Name"
                onClick={() => act('randomize_real_name')}
              />
            </Stack.Item>
          </Stack>
        </LabeledGridList.Item>
        <LabeledGridList.Item label="Nickname">
          <Stack>
            <Stack.Item grow>
              <Button
                fluid
                style={{
                  wordBreak: 'break-word',
                  whiteSpace: 'wrap',
                }}
                onClick={() => act('nickname')}
              >
                {nickname}
              </Button>
            </Stack.Item>
            <Stack.Item>
              <ColorButton
                backgroundColor={highlight_color}
                tooltip={`Highlight Color: ${ensureColorHash(highlight_color)}`}
                onClick={() => act('highlight_color')}
              />
            </Stack.Item>
          </Stack>
        </LabeledGridList.Item>
        <LabeledGridList.Item label="Pronouns">
          <Button
            fluid
            icon={PRONOUN_TO_ICON[pronouns]}
            style={{
              textTransform: 'capitalize',
            }}
            onClick={() => act('pronouns')}
          >
            {pronouns}
          </Button>
        </LabeledGridList.Item>
        <LabeledGridList.Item label="Titles">
          <Button
            fluid
            icon={TITLEPREF_TO_ICON[titles_pref]}
            onClick={() => act('titles')}
          >
            {titles_pref}
          </Button>
        </LabeledGridList.Item>
        <LabeledGridList.Item label="Clothing">
          <Button
            fluid
            icon={CLOTHESPREF_TO_ICON[clothes_pref]}
            onClick={() => act('clothespref')}
          >
            {clothes_pref}
          </Button>
        </LabeledGridList.Item>
        <LabeledGridList.Item>
          <Button.Confirm
            confirmIcon="exclamation-triangle"
            confirmContent="This will scramble all characteristics!"
            fluid
            icon="dice-d20"
            onClick={() => act('randomize_normal')}
            tooltip="Randomizes most appearance-related characteristics except species. Also randomizes name."
          >
            Randomize Characteristics
          </Button.Confirm>
        </LabeledGridList.Item>
        <LabeledGridList.Item>
          <Button.Confirm
            confirmIcon="exclamation-triangle"
            confirmContent="This will scramble EVERYTHING, including text!"
            fluid
            icon="dice"
            onClick={() => act('randomize_full')}
            tooltip="Randomizes basically everything, including resetting flavortext and similar."
          >
            Randomize EVERYTHING
          </Button.Confirm>
        </LabeledGridList.Item>
      </LabeledGridList>
    </Section>
  );
};

export const SubtabIdentityCardGameplay = (props) => {
  const { act, data } = useBackendStrict<IdentityData>();
  const {
    age,
    combat_music,
    dnr_pref,
    domhand,
    free_language,
    loadout_cost,
    loadout_tri_cost,
    selected_faith,
    selected_patron,
    statpack_name,
    virtue_origin,
  } = data;
  const [, setPopupId] = usePopupId();

  return (
    <Section title="Gameplay">
      <Stack vertical>
        <Stack.Item>
          <LabeledGridList>
            <LabeledGridList.Item
              className={classes([
                'PreferencesMenu__PatronSelection',
                selected_faith,
              ])}
              label={'\u16C9 Patron \u16E3'}
            >
              <Button
                fluid
                icon="bars"
                onClick={() => setPopupId('PatronSelect')}
              >
                {selected_faith} - {selected_patron}
              </Button>
            </LabeledGridList.Item>
            <LabeledGridList.Item label="Origin">
              <Button fluid icon="bars" onClick={() => setPopupId('Origin')}>
                {virtue_origin}
              </Button>
            </LabeledGridList.Item>
            <LabeledGridList.Item label="Statpack">
              <Button fluid icon="bars" onClick={() => setPopupId('Statpack')}>
                {statpack_name}
              </Button>
            </LabeledGridList.Item>
            <LabeledGridList.Item label="Combat Music">
              <Button
                fluid
                icon="bars"
                onClick={() => setPopupId('CombatMusic')}
              >
                {combat_music}
              </Button>
            </LabeledGridList.Item>
            <LabeledGridList.Item label="Age">
              <Button fluid onClick={() => act('age')}>
                {age}
              </Button>
            </LabeledGridList.Item>
            <LabeledGridList.Item label="Dominance">
              <Button fluid onClick={() => act('domhand')}>
                {domhand === 2 ? 'Right-handed' : 'Left-handed'}
              </Button>
            </LabeledGridList.Item>
            <LabeledGridList.Item label="Free Language">
              <Button fluid onClick={() => act('extra_language')}>
                {free_language}
              </Button>
            </LabeledGridList.Item>
            <LabeledGridList.Item label="Unrevivable">
              <Button fluid onClick={() => act('dnr_pref')}>
                {dnr_pref ? 'Yes' : 'No'}
              </Button>
            </LabeledGridList.Item>
            <SubtabIdentityCardGameplayCardCulinary />
          </LabeledGridList>
        </Stack.Item>
        <Stack.Item>
          <Button fluid icon="paw" mt={1} onClick={() => act('familiar_prefs')}>
            Familiar Preferences
          </Button>
          <Button
            fluid
            icon="wand-sparkles"
            mt={1}
            onClick={() => act('open_loadout')}
          >
            Change Loadout ({loadout_cost || 0} points, {loadout_tri_cost || 0}{' '}
            TRI)
          </Button>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const SubtabIdentityCardGameplayCardCulinary = (props) => {
  const [constantData] = useConstantPrefs();
  const { data } = useBackendStrict<IdentityData>();
  const { favorite_cuisine, favorite_dish, favorite_drink } = data;

  if (!constantData) {
    return null;
  }

  return (
    <>
      <CulinaryPrefItem
        favorite={favorite_cuisine}
        label="Favorite Cuisine"
        axis={CulinaryAxisNames.Cuisine}
        constantData={constantData}
      />
      <CulinaryPrefItem
        favorite={favorite_dish}
        label="Favorite Dish"
        axis={CulinaryAxisNames.Dish}
        constantData={constantData}
      />
      <CulinaryPrefItem
        favorite={favorite_drink}
        label="Favorite Drink"
        axis={CulinaryAxisNames.Drink}
        constantData={constantData}
      />
    </>
  );
};

type CulinaryPrefItemProps = {
  favorite: number;
  label: string;
  axis: CulinaryAxisNames;
  constantData: ConstantData;
};

const CulinaryPrefItem = (props: CulinaryPrefItemProps) => {
  const { favorite, label, axis, constantData } = props;
  const { act } = useBackendStrict();

  return (
    <LabeledGridList.Item label={label}>
      <Box fontSize={1.2}>
        <Dropdown
          fluid
          options={['None'].concat(
            Object.keys(getCulinaryDataForAxis(constantData, axis)),
          )}
          selected={
            getCulinaryNameFromBitflag(constantData, axis, favorite) || 'None'
          }
          onSelected={(label) =>
            act('set_culinary_axis', {
              axis: axis,
              flag: getCulinaryBitflagFromName(constantData, axis, label) || 0,
            })
          }
        />
      </Box>
    </LabeledGridList.Item>
  );
};

const SubtabIdentityCardVoice = (props) => {
  const [constantData] = useConstantPrefs();
  const { act, data } = useBackendStrict<IdentityData>();
  const { voice_type, voice_color, voice_pack, voice_pitch } = data;

  if (!constantData) {
    return <LoadingScreen label="Loading Voice Data..." />;
  }

  const { MIN_VOICE_PITCH, MAX_VOICE_PITCH, voicepacks } = constantData;

  return (
    <Section
      fill
      // This just makes for perfect alignment
      style={{ marginTop: 0 }}
      title={
        <LabeledListLikeTooltip
          tooltip="These options are used to determine how your audible emotes sound!"
          tooltipPosition="bottom-start"
        >
          Voice
        </LabeledListLikeTooltip>
      }
    >
      <LabeledGridList>
        <LabeledGridList.Item label="Type" verticalAlign="middle">
          <Stack fill>
            <Stack.Item grow>
              <Button
                fluid
                icon={VOICETYPE_TO_ICON[voice_type]}
                onClick={() => act('voicetype')}
              >
                {voice_type}
              </Button>
            </Stack.Item>
            <Stack.Item>
              <ColorButton
                backgroundColor={voice_color}
                tooltip={`Voice Color: ${ensureColorHash(voice_color)}`}
                onClick={() => act('voice_color')}
              />
            </Stack.Item>
          </Stack>
        </LabeledGridList.Item>
        <LabeledGridList.Item label="Pack">
          <Stack>
            <Stack.Item grow fontSize={1.2}>
              <Dropdown
                fluid
                options={voicepacks}
                selected={voice_pack}
                onSelected={(vp) =>
                  act('set_voicepack', {
                    voicepack: vp,
                  })
                }
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                inline
                icon="volume-up"
                tooltip="Preview Voice"
                onClick={() => act('voicepack_preview')}
              />
            </Stack.Item>
          </Stack>
        </LabeledGridList.Item>
        <LabeledGridList.Item label="Pitch">
          <Stack>
            <Stack.Item grow>
              <Slider
                minValue={MIN_VOICE_PITCH}
                maxValue={MAX_VOICE_PITCH}
                value={voice_pitch}
                format={(v) => v.toFixed(1)}
                step={0.1}
                onChange={(e, pitch) => act('set_voice_pitch', { pitch })}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                inline
                icon="face-laugh"
                tooltip="Preview Emote"
                onClick={() => act('voicepack_preview_emote')}
              />
            </Stack.Item>
          </Stack>
        </LabeledGridList.Item>
      </LabeledGridList>
    </Section>
  );
};

const SubtabIdentityCardBark = (props) => {
  const [constantData] = useConstantPrefs();
  const { act, data } = useBackendStrict<IdentityData>();
  const {
    bark_name,
    bark_pitch,
    min_bark_pitch,
    max_bark_pitch,
    bark_speed,
    min_bark_speed,
    max_bark_speed,
    bark_variance,
    min_bark_variance,
    max_bark_variance,
  } = data;

  return (
    <Section
      fill
      mt={1}
      title={
        <LabeledListLikeTooltip
          tooltip="This sound will be repeated an appropriate amount of times to represent your character talking."
          tooltipPosition="bottom-start"
        >
          Vocal Bark
        </LabeledListLikeTooltip>
      }
    >
      <LabeledGridList>
        <LabeledGridList.Item label="Type">
          <Stack>
            <Stack.Item grow fontSize={1.2}>
              {constantData ? (
                <Dropdown
                  fluid
                  options={constantData.barksounds.toSorted()}
                  selected={bark_name}
                  onSelected={(bs) =>
                    act('set_barksound', {
                      barksound: bs,
                    })
                  }
                />
              ) : (
                'Loading Bark Sounds...'
              )}
            </Stack.Item>
            <Stack.Item>
              <Button
                onClick={() => act('barkpreview')}
                icon="volume-down"
                inline
                tooltip="Preview Bark (Single)"
              />
            </Stack.Item>
          </Stack>
        </LabeledGridList.Item>
        <LabeledGridList.Item
          label="Speed"
          tooltip="Higher is slower, lower is faster."
        >
          <Stack>
            <Stack.Item grow>
              <Slider
                minValue={min_bark_speed}
                maxValue={max_bark_speed}
                value={bark_speed}
                format={(v) => v.toFixed(1)}
                step={0.1}
                onChange={(e, speed) => act('set_bark_speed', { speed })}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                inline
                icon="volume-up"
                tooltip="Preview Bark (Long)"
                onClick={() => act('barkpreview_long')}
              />
            </Stack.Item>
          </Stack>
        </LabeledGridList.Item>
        <LabeledGridList.Item label="Pitch" tooltip="Lower is deeper.">
          <Slider
            minValue={min_bark_pitch}
            maxValue={max_bark_pitch}
            value={bark_pitch}
            format={(v) => v.toFixed(1)}
            step={0.1}
            onChange={(e, pitch) => act('set_bark_pitch', { pitch })}
          />
        </LabeledGridList.Item>
        <LabeledGridList.Item
          label="Vary"
          tooltip="Lower varies the bark frequency by a smaller amount."
        >
          <Slider
            minValue={min_bark_variance}
            maxValue={max_bark_variance}
            value={bark_variance}
            format={(v) => v.toFixed(1)}
            step={0.1}
            onChange={(e, variance) => act('set_bark_variance', { variance })}
          />
        </LabeledGridList.Item>
      </LabeledGridList>
    </Section>
  );
};

export const SubtabIdentityCardVirtues = (props) => {
  const { data } = useBackendStrict<IdentityData>();
  const { virtues } = data;

  return (
    <Section title="Virtues" className="PreferencesMenu__Section__Virtues">
      <Stack vertical>
        {virtues.map((virtue) => (
          <Stack.Item key={virtue.id}>
            <VirtueEntry entry={virtue} />
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};

export const VirtueEntry = (props: { entry: VirtueWithMetadata }) => {
  const { entry } = props;
  const { act } = useBackendStrict();
  const { id, slot_name, virtue, spawn_error } = entry;
  const [, setPopupId] = usePopupId();

  return (
    <Box>
      <Stack align="center">
        <Stack.Item>
          {slot_name}{' '}
          {virtue.tricost > 0 ? (
            <Box inline textColor="white">
              ({virtue.tricost} TRI)
            </Box>
          ) : null}
          :
        </Stack.Item>
        <Stack.Item grow>
          <Button
            fluid
            icon="bars"
            className={spawn_error ? 'Virtue__SpawnError' : undefined}
            tooltip={
              spawn_error
                ? `This virtue will not be applied on spawn: ${spawn_error}`
                : null
            }
            onClick={() => setPopupId('Virtue', { id })}
          >
            {virtue.name}
            {spawn_error ? ' (!)' : null}
          </Button>
        </Stack.Item>
      </Stack>
      {virtue.picked_choices.map((choice) => (
        <Button
          key={choice.choice}
          fluid
          ml={2}
          mt={1}
          tooltip={choice.tooltip}
          onClick={() =>
            act('subvirtue', {
              id,
              task: 'remove',
              index: choice.index,
            })
          }
        >
          {choice.choice}
        </Button>
      ))}
      {virtue.picked_choices.length < virtue.max_choices ? (
        <Button
          fluid
          ml={2}
          mt={1}
          onClick={() => act('subvirtue', { id, task: 'add' })}
        >
          Pick Bonus {virtue.next_cost > 0 ? `(${virtue.next_cost} TRI)` : null}
        </Button>
      ) : null}
    </Box>
  );
};

export const SubtabIdentityCardVices = (props) => {
  const { act, data } = useBackendStrict<IdentityData>();
  const { charflaws, has_averse, averse_chosen_faction } = data;
  const [, setPopupId] = usePopupId();

  return (
    <Section title="Vices" className="PreferencesMenu__Section__Vices">
      {charflaws.map((flaw) => (
        <Button
          key={flaw.type}
          fluid
          onClick={() => act('toggle_charflaw', { flaw: flaw.type })}
        >
          {flaw.name}
          {flaw.warning ? ' (Requires Extra Vice!)' : null}
        </Button>
      ))}
      <Button fluid icon="bars" ml={4} onClick={() => setPopupId('CharFlaw')}>
        Open Menu
      </Button>
      {has_averse ? (
        <LabeledGridList>
          <LabeledGridList.Item label="Loathed Group">
            <Button fluid mt={2} onClick={() => act('charflaw_averse_choice')}>
              {averse_chosen_faction}
            </Button>
          </LabeledGridList.Item>
        </LabeledGridList>
      ) : null}
    </Section>
  );
};
