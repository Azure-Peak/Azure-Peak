import { PrefPopupGuard, SpriteAccessoryImageButton } from 'pm/components';
import { type ConstantData, useConstantPrefs } from 'pm/constant_data';
import type { Path } from 'pm/data';
import {
  type PopupData,
  registerPopup,
  usePopupBackend,
  usePopupContext,
} from 'pm/popups';
import { Box, Button, Input, Section, Stack } from 'tgui-core/components';
import { useFuzzySearch } from 'tgui-core/fuzzysearch';

type CustomizerSelectData = {
  customizer_entries: Record<Path, CustomizerEntry>;
} & PopupData;

type CustomizerEntry = {
  customizer_choice_type: Path;
  accessory_type: Path;
  accessory_colors: string[];
};

export enum CustomizerSelectTask {
  MainChoice,
  AccessoryChoice,
}

export type PopupCustomizerSelectContext = {
  customizer: Path;
  task: CustomizerSelectTask;
};

const PopupCustomizerSelect = (props) => {
  const [constantData] = useConstantPrefs();
  const [context] = usePopupContext<PopupCustomizerSelectContext>();
  const { data } = usePopupBackend<CustomizerSelectData>();
  const { popup_data_ready } = data;

  const featureName =
    context && constantData
      ? constantData.customizers[context.customizer].name
      : 'ERROR';

  return (
    <PrefPopupGuard
      title={`Select Feature ${featureName}`}
      loadingScreenText="Features Loading..."
      width="80vw"
      height="80vh"
      dependencies={[constantData, context, popup_data_ready]}
    >
      <PopupCustomizerSelectInner
        constantData={constantData!}
        context={context!}
      />
    </PrefPopupGuard>
  );
};

// Register it
declare module 'pm/popups' {
  interface PopupRegistry {
    CustomizerSelect: 'customizer_select';
  }
  interface PopupContextRegistry {
    CustomizerSelect: PopupCustomizerSelectContext;
  }
}
registerPopup('CustomizerSelect', 'customizer_select', PopupCustomizerSelect);

// Main Content
const PopupCustomizerSelectInner = (props: {
  constantData: ConstantData;
  context: PopupCustomizerSelectContext;
}) => {
  const { constantData, context } = props;
  const { task } = context;

  switch (task) {
    case CustomizerSelectTask.MainChoice:
      return <MainChoice constantData={constantData} context={context} />;
    case CustomizerSelectTask.AccessoryChoice:
      return <AccessoryChoice constantData={constantData} context={context} />;
  }
};

const MainChoice = (props: {
  constantData: ConstantData;
  context: PopupCustomizerSelectContext;
}) => {
  const { constantData, context } = props;
  const { act, data } = usePopupBackend<CustomizerSelectData>();
  const { customizers, customizer_choices } = constantData;
  const { customizer } = context;
  const { customizer_entries } = data;

  const entry = customizer_entries[customizer];
  const customizerData = customizers[customizer];
  const allChoices = Object.keys(customizer_choices)
    .filter((path) => customizerData.choices.includes(path))
    .map((path) => ({ path, ...customizer_choices[path] }));

  return (
    <Section>
      <Stack vertical>
        {allChoices.map((choice) => (
          <Stack.Item key={choice.path}>
            <Button
              fluid
              disabled={entry.customizer_choice_type === choice.path}
              tooltip={
                entry.customizer_choice_type === choice.path
                  ? 'Already Selected'
                  : undefined
              }
              onClick={() => {
                act('change_customizer_popup', {
                  customizer: customizer,
                  task: 'change_choice',
                  choice: choice.path,
                });
              }}
            >
              {choice.name}
            </Button>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};

const AccessoryChoice = (props: {
  constantData: ConstantData;
  context: PopupCustomizerSelectContext;
}) => {
  const { constantData, context } = props;
  const { act, data } = usePopupBackend<CustomizerSelectData>();
  const { customizer_choices, sprite_accessories } = constantData;
  const { customizer } = context;
  const { customizer_entries } = data;

  const entry = customizer_entries[customizer];
  const selectedChoice = customizer_choices[entry.customizer_choice_type];
  const spriteAccessories = selectedChoice.sprite_accessories.map((path) => ({
    path,
    ...sprite_accessories[path],
  }));

  const { query, setQuery, results } = useFuzzySearch({
    getSearchString: (s) => s.name,
    searchArray: spriteAccessories,
  });

  return (
    <Section fill>
      <Stack fill vertical>
        <Stack.Item>
          <Input
            fluid
            placeholder="Search..."
            onChange={setQuery}
            value={query}
          />
        </Stack.Item>
        <Stack.Item grow>
          <Section fill scrollable>
            <Box className="PreferencesMenu__Grid PreferencesMenu__FiveColumn__ImageButton">
              {(query.length ? results : spriteAccessories).map((sa) => (
                <SpriteAccessoryImageButton
                  key={sa.path}
                  iconRef={sa.icon}
                  iconStates={sa.preview_states}
                  offsetX={sa.pixel_x}
                  imageSize={128}
                  selected={entry.accessory_type === sa.path}
                  tooltip={`${sa.name} ${entry.accessory_type === sa.path ? ' (Already Taken)' : ''}`}
                  onClick={() => {
                    act('change_customizer_popup', {
                      customizer: customizer,
                      task: 'change_accessory',
                      acc: sa.path,
                    });
                  }}
                >
                  {sa.name}
                </SpriteAccessoryImageButton>
              ))}
            </Box>
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
