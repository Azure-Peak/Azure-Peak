import {
  ColorButton,
  ensureColorHash,
  HeadshotButton,
  LabeledGridList,
} from 'pm/components';
import { SubtabVillainDownstream } from 'pm/downstream/tabs/CharacterCreator/subtabs/Villains';
import { useBackendStrict } from 'tgui/backend';
import { Button, NoticeBox, Section, Stack } from 'tgui-core/components';
import type { VillainData } from '../data';

export const SubtabVillain = () => {
  const { data } = useBackendStrict<VillainData>();
  const { antag_banned } = data;

  return (
    <Section
      fill
      scrollable
      className="PreferencesMenu__Section__NoChildPadding"
    >
      {antag_banned ? (
        <NoticeBox danger>I am banned from antagonist roles.</NoticeBox>
      ) : null}
      <Stack vertical>
        <Stack.Item grow>
          <VillainSettings />
        </Stack.Item>
        <Stack.Item grow>
          <BountySettings />
        </Stack.Item>
        <SubtabVillainDownstream />
      </Stack>
    </Section>
  );
};

const VillainSettings = () => {
  const { act, data } = useBackendStrict<VillainData>();
  const {
    lich_headshot_link,
    vampire_headshot_link,
    vampire_skin,
    vampire_eyes,
    vampire_hair,
    vampire_ears,
    qsr_pref,
  } = data;

  return (
    <Section title="Villain Settings">
      <Stack vertical>
        <Stack.Item>
          <Stack justify="space-around">
            <Stack.Item>
              <HeadshotButton
                action="lich_headshot"
                link={lich_headshot_link}
                subtitle="Lich Headshot"
                tooltipPosition="bottom-start"
                tooltip="Overrides your default headshot when you are a lich."
              />
            </Stack.Item>
            <Stack.Item>
              <HeadshotButton
                action="vampire_headshot"
                link={vampire_headshot_link}
                subtitle="Vampire Headshot"
                tooltip="Overrides your default headshot when you are a vampire with your disguise turned off."
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <LabeledGridList>
            <LabeledGridList.Item
              label="Vampire Skin Color"
              verticalAlign="middle"
            >
              <Stack align="center">
                <Stack.Item grow>
                  <ColorButton
                    backgroundColor={vampire_skin || '#FFFFFF'}
                    tooltip={
                      vampire_skin ? ensureColorHash(vampire_skin) : 'Unset'
                    }
                    onClick={() => act('vampire_skin')}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => act('vampire_skin_clear')}>C</Button>
                </Stack.Item>
              </Stack>
            </LabeledGridList.Item>
            <LabeledGridList.Item
              label="Vampire Eye Color"
              verticalAlign="middle"
            >
              <Stack align="center">
                <Stack.Item grow>
                  <ColorButton
                    backgroundColor={vampire_eyes || '#FFFFFF'}
                    tooltip={
                      vampire_eyes ? ensureColorHash(vampire_eyes) : 'Unset'
                    }
                    onClick={() => act('vampire_eyes')}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => act('vampire_eyes_clear')}>C</Button>
                </Stack.Item>
              </Stack>
            </LabeledGridList.Item>
            <LabeledGridList.Item
              label="Vampire Hair Color"
              verticalAlign="middle"
            >
              <Stack align="center">
                <Stack.Item grow>
                  <ColorButton
                    backgroundColor={vampire_hair || '#FFFFFF'}
                    tooltip={
                      vampire_hair ? ensureColorHash(vampire_hair) : 'Unset'
                    }
                    onClick={() => act('vampire_hair')}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => act('vampire_hair_clear')}>C</Button>
                </Stack.Item>
              </Stack>
            </LabeledGridList.Item>
            <LabeledGridList.Item
              label="Vampire Ear Color"
              verticalAlign="middle"
            >
              <Stack align="center">
                <Stack.Item grow>
                  <ColorButton
                    backgroundColor={vampire_ears || '#FFFFFF'}
                    tooltip={
                      vampire_ears ? ensureColorHash(vampire_ears) : 'Unset'
                    }
                    onClick={() => act('vampire_ears')}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => act('vampire_ears_clear')}>C</Button>
                </Stack.Item>
              </Stack>
            </LabeledGridList.Item>
            <LabeledGridList.Item
              label="Quicksilver Resistant"
              verticalAlign="middle"
            >
              <Button.Checkbox
                checked={qsr_pref}
                selected={qsr_pref}
                onClick={() => act('qsr_pref')}
              >
                {qsr_pref ? 'Yes' : 'No'}
              </Button.Checkbox>
            </LabeledGridList.Item>
          </LabeledGridList>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const BountySettings = () => {
  const { act, data } = useBackendStrict<VillainData>();
  const {
    preset_bounty_enabled,
    bounty_posters,
    wretch_severities,
    bandit_severities,
    vagabond_severities,
    preset_bounty_crime,
  } = data;

  return (
    <Section title="Bounty Settings">
      <LabeledGridList>
        <LabeledGridList.Item label="Use Preset Bounty">
          <Button.Checkbox
            fluid
            selected={preset_bounty_enabled}
            checked={preset_bounty_enabled}
            onClick={() => act('preset_bounty_toggle')}
          >
            {preset_bounty_enabled ? 'Enabled' : 'Disabled'}
          </Button.Checkbox>
        </LabeledGridList.Item>
        {preset_bounty_enabled ? (
          <>
            <LabeledGridList.Item label="Bounty Poster">
              <Button
                ellipsis
                fluid
                tooltip={bounty_posters || 'None'}
                onClick={() => act('preset_bounty_poster_key')}
              >
                {bounty_posters || 'None'}
              </Button>
            </LabeledGridList.Item>
            <LabeledGridList.Item label="Crime Severity">
              <Button
                ellipsis
                fluid
                tooltip={wretch_severities || 'None'}
                onClick={() => act('preset_bounty_severity_key')}
              >
                {wretch_severities || 'None'}
              </Button>
            </LabeledGridList.Item>
            <LabeledGridList.Item label="Crime Severity (Bandit)">
              <Button
                ellipsis
                fluid
                tooltip={bandit_severities || 'None'}
                onClick={() => act('preset_bounty_severity_b_key')}
              >
                {bandit_severities || 'None'}
              </Button>
            </LabeledGridList.Item>
            <LabeledGridList.Item label="Crime Severity (Vagabond)">
              <Button
                ellipsis
                fluid
                tooltip={vagabond_severities || 'None'}
                onClick={() => act('preset_bounty_severity_v_key')}
              >
                {vagabond_severities || 'None'}
              </Button>
            </LabeledGridList.Item>
            <LabeledGridList.Item label="Crime">
              <Button
                ellipsis
                fluid
                tooltip={preset_bounty_crime || 'None'}
                onClick={() => act('preset_bounty_crime')}
              >
                {preset_bounty_crime || 'None'}
              </Button>
            </LabeledGridList.Item>
          </>
        ) : null}
      </LabeledGridList>
    </Section>
  );
};
