import {
  ColorButton,
  ensureColorHash,
  LabeledGridList,
  SaveUndo,
} from 'pm/components';
import type { Antag, GameSettingsData } from 'pm/data';
import { useBackendStrict } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';

export const GameSettings = (props) => {
  return (
    <Section
      fill
      scrollable
      className="PreferencesMenu__Section__NoChildPadding"
    >
      <Stack vertical>
        <Stack.Item grow>
          <Box className="PreferencesMenu__Grid PreferencesMenu__TwoColumn">
            <Box>
              <Settings />
            </Box>
            <Box>
              <SpecialRoles />
            </Box>
          </Box>
        </Stack.Item>
        <Stack.Item grow>
          <AdminPreferences />
        </Stack.Item>
        <Stack.Item>
          <SaveUndo />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const Settings = (props) => {
  const { act, data } = useBackendStrict<GameSettingsData>();
  const {
    tgui_theme,
    parchment_skin,
    statbrowser_theme,
    tgui_lock,
    ambientocclusion,
    windowflashing,
    clientfps,
    auto_fit_viewport,
    schizo_voice,
    verbose_character_creator,
  } = data;

  return (
    <Section fill title="Game Settings">
      <LabeledGridList>
        <LabeledGridList.Item
          label="Verbose Character Creator"
          tooltip="Controls whether or not the character creator logs everything it does to your chat."
        >
          <Button onClick={() => act('verbose_character_creator')}>
            {verbose_character_creator ? 'On' : 'Off'}
          </Button>
        </LabeledGridList.Item>
        <LabeledGridList.Item
          label="TGUI Theme"
          tooltip="UI Theme to use by default for generic UI windows"
        >
          <Button onClick={() => act('tgui_theme')}>{tgui_theme}</Button>
        </LabeledGridList.Item>
        <LabeledGridList.Item
          label="Parchment Theme"
          tooltip="UI Theme to use for paper-themed UI windows"
        >
          <Button onClick={() => act('parchment_skin')}>
            {parchment_skin}
          </Button>
        </LabeledGridList.Item>
        <LabeledGridList.Item
          label="Panel Theme"
          tooltip="UI Theme for Side Panel"
        >
          <Button onClick={() => act('statbrowser_theme')}>
            {statbrowser_theme}
          </Button>
        </LabeledGridList.Item>
        <LabeledGridList.Item
          label="TGUI Monitors"
          tooltip="Lock TGUI windows to primary monitor or not"
        >
          <Button onClick={() => act('tgui_lock')}>
            {tgui_lock ? 'Primary' : 'All'}
          </Button>
        </LabeledGridList.Item>
        <LabeledGridList.Item
          label="Ambient Occlusion"
          tooltip="Fake ambient occlusion effect"
        >
          <Button onClick={() => act('ambientocclusion')}>
            {ambientocclusion ? 'Enabled' : 'Disabled'}
          </Button>
        </LabeledGridList.Item>
        <LabeledGridList.Item
          label="Flash Taskbar"
          tooltip="Flash the windows taskbar when polls or ghost notifications happen."
        >
          <Button onClick={() => act('windowflashing')}>
            {windowflashing ? 'Yes' : 'No'}
          </Button>
        </LabeledGridList.Item>
        <LabeledGridList.Item
          label="FPS"
          tooltip="Target FPS for the client to run on, higher values mean smoother animations"
        >
          <Button onClick={() => act('clientfps')}>{clientfps}</Button>
        </LabeledGridList.Item>
        <LabeledGridList.Item
          label="Fit Viewport"
          tooltip="Automatically resize the right panel to maximize vertical space of the map window"
        >
          <Button onClick={() => act('auto_fit_viewport')}>
            {auto_fit_viewport ? 'Yes' : 'No'}
          </Button>
        </LabeledGridList.Item>
        <LabeledGridList.Item
          label="Be Voice"
          tooltip="Voices receive meditations from players asking about game mechanics."
        >
          <Button onClick={() => act('schizo_voice')}>
            {schizo_voice ? 'Yes' : 'No'}
          </Button>
        </LabeledGridList.Item>
      </LabeledGridList>
    </Section>
  );
};

const SpecialRoles = (props) => {
  const { act, data } = useBackendStrict<GameSettingsData>();
  const { antags, no_storyteller_events } = data;

  return (
    <Section fill title="Special Roles">
      <LabeledGridList>
        {antags.map((antag) => (
          <AntagListItem key={antag.key} antag={antag} />
        ))}
        <LabeledGridList.Item
          label="Storyteller Events"
          tooltip="Opt out of being picked for God's Chosen and similar events."
        >
          <Button onClick={() => act('no_storyteller_events')}>
            {no_storyteller_events
              ? 'You will never be chosen for storyteller events.'
              : 'You may be chosen for storyteller events.'}
          </Button>
        </LabeledGridList.Item>
      </LabeledGridList>
    </Section>
  );
};

const AntagListItem = (props: { antag: Antag }) => {
  const { act } = useBackendStrict();
  const { antag } = props;

  let innerContent: React.ReactNode;

  if (antag.banned) {
    innerContent = (
      <NoticeBox danger p={0.5} pr={1} m={0} textAlign="center">
        BANNED
        <Button
          color="bad"
          ml={1}
          onClick={() => act('bancheck', { bancheck: antag.key })}
        >
          Why?
        </Button>
      </NoticeBox>
    );
  } else if (antag.days_remaining) {
    innerContent = (
      <NoticeBox p={0.5} pr={1} m={0} textAlign="center">
        [IN {antag.days_remaining} DAYS]
      </NoticeBox>
    );
  } else {
    innerContent = (
      <Button.Checkbox
        checked={antag.enabled}
        selected={antag.enabled}
        onClick={() => act('be_special', { be_special_type: antag.key })}
      >
        {antag.enabled ? 'Enabled' : 'Disabled'}
      </Button.Checkbox>
    );
  }

  return (
    <LabeledGridList.Item key={antag.key} label={antag.key}>
      {innerContent}
    </LabeledGridList.Item>
  );
};

const AdminPreferences = (props) => {
  const { act, data } = useBackendStrict<GameSettingsData>();

  if (!data.admin_prefs) {
    return null;
  }

  const {
    sound_adminhelp,
    sound_prayers,
    announce_login,
    combohud_lighting,
    show_dsay,
    show_prayer,
    allow_asaycolor,
    asaycolor,
    auto_deadmin_players,
    deadmin_player,
    auto_deadmin_antagonists,
    deadmin_antagonist,
    auto_deadmin_heads,
    deadmin_head,
  } = data.admin_prefs;

  return (
    <Section title="Admin">
      <LabeledGridList>
        <LabeledGridList.Item label="Adminhelp Sounds">
          <Button onClick={() => act('hear_adminhelps')}>
            {sound_adminhelp ? 'Enabled' : 'Disabled'}
          </Button>
        </LabeledGridList.Item>
        <LabeledGridList.Item label="Prayer Sounds">
          <Button onClick={() => act('hear_prayers')}>
            {sound_prayers ? 'Enabled' : 'Disabled'}
          </Button>
        </LabeledGridList.Item>
        <LabeledGridList.Item label="Announce Login">
          <Button onClick={() => act('announce_login')}>
            {announce_login ? 'Enabled' : 'Disabled'}
          </Button>
        </LabeledGridList.Item>
        <LabeledGridList.Item label="Combo HUD Lighting">
          <Button onClick={() => act('combohud_lighting')}>
            {combohud_lighting ? 'Full-Bright' : 'No Change'}
          </Button>
        </LabeledGridList.Item>
        <LabeledGridList.Item label="Hide Dead Chat">
          <Button onClick={() => act('toggle_dead_chat')}>
            {show_dsay ? 'Shown' : 'Hidden'}
          </Button>
        </LabeledGridList.Item>
        <LabeledGridList.Item label="Hide Prayers">
          <Button onClick={() => act('toggle_prayers')}>
            {show_prayer ? 'Shown' : 'Hidden'}
          </Button>
        </LabeledGridList.Item>
        {allow_asaycolor ? (
          <LabeledGridList.Item label="ASAY Color" verticalAlign="middle">
            <ColorButton
              backgroundColor={asaycolor}
              tooltip={ensureColorHash(asaycolor)}
              onClick={() => act('asaycolor')}
            />
          </LabeledGridList.Item>
        ) : null}
      </LabeledGridList>
      <Divider />
      <h2>Deadmin While Playing Settings</h2>
      <LabeledGridList>
        <LabeledGridList.Item label="Always Deadmin">
          {auto_deadmin_players ? (
            'FORCED'
          ) : (
            <Button onClick={() => act('toggle_deadmin_always')}>
              {deadmin_player ? 'Enabled' : 'Disabled'}
            </Button>
          )}
        </LabeledGridList.Item>
        {auto_deadmin_players ? null : (
          <>
            <LabeledGridList.Item label="As Antag">
              {auto_deadmin_antagonists ? (
                'FORCED'
              ) : (
                <Button onClick={() => act('toggle_deadmin_antag')}>
                  {deadmin_antagonist ? 'Enabled' : 'Disabled'}
                </Button>
              )}
            </LabeledGridList.Item>
            <LabeledGridList.Item label="As Command">
              {auto_deadmin_heads ? (
                'FORCED'
              ) : (
                <Button onClick={() => act('toggle_deadmin_head')}>
                  {deadmin_head ? 'Enabled' : 'Disabled'}
                </Button>
              )}
            </LabeledGridList.Item>
          </>
        )}
      </LabeledGridList>
    </Section>
  );
};
