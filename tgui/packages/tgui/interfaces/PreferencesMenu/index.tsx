import { type ReactNode, useEffect } from 'react';
import { resolveAsset } from 'tgui/assets';
import { useBackendStrict } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { logger } from 'tgui/logging';
import { Box, Stack, Tabs } from 'tgui-core/components';
import { fetchRetry } from 'tgui-core/http';
import { PopupRouteError } from './components/PrefPopup';
import { useConstantPrefs } from './constant_data';
import { TAB_CHARACTER, TAB_GAMESETTINGS, TAB_KEYBIND } from './constants';
import type { AllPagesData } from './data';
import { getActivePopup } from './popups';
import { CharacterCreator } from './tabs/CharacterCreator';
import { GameSettings } from './tabs/GameSettings';
import { KeyBinds } from './tabs/KeyBinds';

export const PreferencesMenu = () => {
  const [, setConstantData] = useConstantPrefs();
  const { config } = useBackendStrict();

  let popup: ReactNode = null;
  try {
    const Component = getActivePopup();
    popup = Component ? <Component /> : null;
  } catch (e: any) {
    popup = <PopupRouteError e={e} />;
  }

  // deny trey liam lol
  const theme =
    config.window?.theme === 'trey_liam'
      ? 'azure_ascendant'
      : config.window.theme;

  useEffect(() => {
    fetchRetry(resolveAsset('preferences.json'))
      .then((response) => response.json())
      .then((data) => {
        setConstantData(data);
      })
      .catch((error) => {
        logger.log('Failed to fetch preferences.json', error);
      });
  }, []);

  const initialHeight =
    screen.availHeight > 900 ? 900 : screen.availHeight - 20;

  useEffect(() => {
    // for really small screens, reduce font size
    if (initialHeight < 800) {
      document.documentElement.style.setProperty('--font-size', '12px');
    }
  }, []);

  return (
    // TODO: use 900 when display allows
    <Window theme={theme} width={1000} height={initialHeight}>
      {/* used for some default changing */}
      <Window.Content className="PreferencesMenu">
        {popup}
        <PreferencesMenuContent />
      </Window.Content>
    </Window>
  );
};

export const PreferencesMenuContent = () => {
  const { act, data } = useBackendStrict<AllPagesData>();
  const { current_tab } = data;

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Tabs fluid>
          <Tabs.Tab
            icon="person"
            selected={current_tab === TAB_CHARACTER}
            onClick={() => act('change_tab', { tab: TAB_CHARACTER })}
          >
            Character Creator
          </Tabs.Tab>
          <Tabs.Tab
            icon="cog"
            selected={current_tab === TAB_GAMESETTINGS}
            onClick={() => act('change_tab', { tab: TAB_GAMESETTINGS })}
          >
            Game Settings
          </Tabs.Tab>
          <Tabs.Tab
            icon="keyboard"
            selected={current_tab === TAB_KEYBIND}
            onClick={() => act('change_tab', { tab: TAB_KEYBIND })}
          >
            Keybinds
          </Tabs.Tab>
        </Tabs>
      </Stack.Item>
      <Stack.Item grow minHeight={0}>
        <PreferencesMenuTabs />
      </Stack.Item>
    </Stack>
  );
};

export const PreferencesMenuTabs = () => {
  const { data } = useBackendStrict<AllPagesData>();
  const { current_tab } = data;

  switch (current_tab) {
    case TAB_CHARACTER:
      return <CharacterCreator />;
    case TAB_GAMESETTINGS:
      return <GameSettings />;
    case TAB_KEYBIND:
      return <KeyBinds />;
    default:
      return <Box>Invalid preferences tab, please switch...</Box>;
  }
};
