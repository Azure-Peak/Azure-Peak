import { HeadshotButton, SaveUndo } from 'pm/components';
import { usePopupId } from 'pm/popups';
import { useEffect } from 'react';
import { useBackendStrict, useSharedState } from 'tgui/backend';
import {
  Box,
  Button,
  ByondUi,
  Dropdown,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { useConstantPrefs } from '../constant_data';
import type { AllPagesData } from './CharacterCreator/data';
import { SubtabAppearance } from './CharacterCreator/subtabs/Appearance';
import { SubtabClass } from './CharacterCreator/subtabs/Class';
import { SubtabDescriptors } from './CharacterCreator/subtabs/Descriptors';
import { SubtabIdentity } from './CharacterCreator/subtabs/Identity';
import { SubtabVillain } from './CharacterCreator/subtabs/Villains';

enum Subtab {
  IDENTITY = 0,
  APPEARANCE = 1,
  DESCRIPTORS = 2,
  CLASS = 3,
  VILLAIN = 4,
}

export const CharacterCreator = (props) => {
  const [subtab, setSubtab] = useSharedState(
    'charactercreatorsubtab',
    Subtab.IDENTITY,
  );

  // Remove once https://github.com/tgstation/tgui-core/pull/274 lands
  useEffect(() => {
    window.dispatchEvent(new Event('resize'));
  }, []);

  return (
    <Stack fill>
      {subtab !== Subtab.CLASS ? <Sidebar /> : null}
      <Stack.Item grow>
        <Stack vertical fill>
          <Stack.Item>
            <Tabs fluid>
              <Tabs.Tab
                icon="address-card"
                selected={subtab === Subtab.IDENTITY}
                onClick={() => setSubtab(Subtab.IDENTITY)}
              >
                Identity
              </Tabs.Tab>
              <Tabs.Tab
                icon="person-rays"
                selected={subtab === Subtab.APPEARANCE}
                onClick={() => setSubtab(Subtab.APPEARANCE)}
              >
                Appearance
              </Tabs.Tab>
              <Tabs.Tab
                icon="note-sticky"
                selected={subtab === Subtab.DESCRIPTORS}
                onClick={() => setSubtab(Subtab.DESCRIPTORS)}
              >
                Descriptors
              </Tabs.Tab>
              <Tabs.Tab
                icon="dungeon"
                selected={subtab === Subtab.CLASS}
                onClick={() => setSubtab(Subtab.CLASS)}
              >
                Class
              </Tabs.Tab>
              <Tabs.Tab
                icon="skull"
                selected={subtab === Subtab.VILLAIN}
                onClick={() => setSubtab(Subtab.VILLAIN)}
              >
                Villain
              </Tabs.Tab>
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>
            <CharacterCreatorSubtab subtab={subtab} />
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

const Sidebar = (props) => {
  const [constantData] = useConstantPrefs();
  const { act, data } = useBackendStrict<AllPagesData>();
  const {
    agevet,
    character_preview_view,
    hide_pq,
    pq,
    preview_background,
    real_name,
    headshot_link,
    triumphs,
  } = data;
  const [popupId, setPopupId] = usePopupId();

  return (
    <Stack.Item mr={2} mt={1} width={15}>
      <Stack fill vertical className="PreferencesMenu__Sidebar">
        <Stack.Item>
          <Button
            fluid
            icon="bars"
            onClick={() => setPopupId('CharacterSelect')}
          >
            Change Character
          </Button>
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item fontSize={1.2} style={{ wordBreak: 'break-all' }}>
          {real_name}
        </Stack.Item>
        <Stack.Item width={15} height={15}>
          {/* This needs to be turned off when there's a popup because otherwise it'll intersect */}
          {character_preview_view && !popupId ? (
            <ByondUi
              params={{
                id: character_preview_view,
                type: 'map',
              }}
              width={15}
              height={15}
            />
          ) : (
            <Box width={15} height={15} position="relative">
              {/* Stand in for preview */}
              <Box
                backgroundColor="black"
                position="absolute"
                width={15}
                height={15}
              />
              <Box position="absolute" top={6} left={6}>
                YCH
              </Box>
            </Box>
          )}
        </Stack.Item>
        <Stack.Item>
          <Stack align="center" fill>
            <Stack.Item>
              <Button
                icon="rotate-right"
                tooltip="Rotate"
                onClick={() => act('rotate_character_preview')}
              />
            </Stack.Item>
            <Stack.Item grow fontSize={1.2} minWidth={0}>
              {constantData ? (
                <Dropdown
                  fluid
                  selected={preview_background}
                  options={constantData.preview_backgrounds}
                  onSelected={(bg) => act('set_preview_background', { bg })}
                />
              ) : (
                'Loading Backgrounds...'
              )}
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="refresh"
                tooltip="Refresh"
                onClick={() => act('refresh_character_preview')}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item grow minHeight={0}>
          <Stack fill vertical className="PreferencesMenu__Sidebar__Scrollable">
            <Stack.Item mb={2}>
              <Stack>
                <Stack.Item grow>
                  <Stack align="center" justify="center">
                    <Stack.Item>
                      <HeadshotButton
                        action="headshot"
                        subtitle="Headshot"
                        tooltip="Optional headshot image that will be shown to other players in the examine panel and chat."
                        link={headshot_link}
                      />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              </Stack>
            </Stack.Item>
            {hide_pq ? null : (
              <Stack.Item>
                <Button
                  fluid
                  icon="person-circle-check"
                  onClick={() => act('playerquality')}
                >
                  PQ: <span dangerouslySetInnerHTML={{ __html: pq }} />
                </Button>
              </Stack.Item>
            )}
            <Stack.Item>
              <Button fluid icon="trophy" onClick={() => act('triumphs')}>
                Triumphs: {triumphs}
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button fluid icon="baby" onClick={() => act('agevet')}>
                Verified:{' '}
                {agevet ? (
                  <Box inline color="#74cde0">
                    YAE!
                  </Box>
                ) : (
                  <Box inline color="#897472">
                    NAE?
                  </Box>
                )}
              </Button>
            </Stack.Item>
            <Stack.Item grow />
            <Stack.Item>
              <Button
                fluid
                icon="scroll"
                onClick={() => {
                  act('lore_primer');
                  setPopupId('LorePrimer');
                }}
              >
                Lore Primer
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                fluid
                icon="scale-unbalanced"
                onClick={() => act('changelog')}
              >
                Changelog
              </Button>
            </Stack.Item>
            <Stack.Item grow />
            <Stack.Item>
              <Button
                fluid
                icon="rectangle-list"
                onClick={() => setPopupId('VerboseLogs')}
              >
                Character Creator Logs
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button fluid icon="download" onClick={() => act('export_save')}>
                Export Savefile
              </Button>
            </Stack.Item>
            <SaveUndo />
          </Stack>
        </Stack.Item>
      </Stack>
    </Stack.Item>
  );
};

const CharacterCreatorSubtab = (props: { subtab: Subtab }) => {
  const { subtab } = props;

  switch (subtab) {
    case Subtab.IDENTITY:
      return <SubtabIdentity />;
    case Subtab.APPEARANCE:
      return <SubtabAppearance />;
    case Subtab.DESCRIPTORS:
      return <SubtabDescriptors />;
    case Subtab.CLASS:
      return <SubtabClass />;
    case Subtab.VILLAIN:
      return <SubtabVillain />;
  }
};
