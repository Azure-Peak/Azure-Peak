import { ColorButton, ensureColorHash, LabeledGridList } from 'pm/components';
import { usePopupId } from 'pm/popups';
import { CustomizerSelectTask } from 'pm/popups/CustomizerSelect';
import type { Customizer } from 'pm/tabs/CharacterCreator/data';
import { useBackendStrict } from 'tgui/backend';
import { Button, Stack } from 'tgui-core/components';

export const FeatureChoice = (props: { customizer: Customizer }) => {
  const { customizer } = props;
  const [, setPopup] = usePopupId();

  return (
    <Stack vertical>
      {customizer.customizer_choices_enabled ? (
        <Stack.Item>
          <Button
            ellipsis
            fluid
            tooltip={customizer.choices.name}
            icon="bars"
            onClick={() =>
              setPopup('CustomizerSelect', {
                customizer: customizer.type,
                task: CustomizerSelectTask.MainChoice,
              })
            }
          >
            {customizer.choices.name}
          </Button>
        </Stack.Item>
      ) : null}
      <FeatureChoiceAccessory customizer={customizer} />
      <FeatureChoiceSpecific customizer={customizer} />
    </Stack>
  );
};

const FeatureChoiceAccessory = (props: { customizer: Customizer }) => {
  const { customizer } = props;
  const { choices } = customizer;
  const { accessory } = choices;
  const { act } = useBackendStrict();
  const [, setPopup] = usePopupId();

  if (!accessory) {
    return null;
  }

  return (
    <>
      <Stack.Item>
        <Stack align="center">
          <Stack.Item grow minWidth={0}>
            <Button
              ellipsis
              fluid
              tooltip={accessory.name}
              icon="bars"
              onClick={() =>
                setPopup('CustomizerSelect', {
                  customizer: customizer.type,
                  task: CustomizerSelectTask.AccessoryChoice,
                })
              }
            >
              {accessory.name}
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      {accessory.colors ? (
        <Stack.Item>
          <LabeledGridList>
            {accessory.colors.map((c) => (
              <LabeledGridList.Item
                key={c.index}
                label={c.name}
                verticalAlign="middle"
              >
                <ColorButton
                  backgroundColor={c.color}
                  tooltip={ensureColorHash(c.color)}
                  onClick={() =>
                    act('change_customizer', {
                      customizer: customizer.type,
                      customizer_task: 'acc_color',
                      color_index: c.index,
                    })
                  }
                />
              </LabeledGridList.Item>
            ))}
            <LabeledGridList.Item>
              <Button
                fluid
                onClick={() => {
                  act('change_customizer', {
                    customizer: customizer.type,
                    customizer_task: 'reset_colors',
                  });
                }}
              >
                Reset Colors
              </Button>
            </LabeledGridList.Item>
          </LabeledGridList>
        </Stack.Item>
      ) : null}
    </>
  );
};

// INSTRUCTIONS FOR DOWNSTREAM: You should be able to safely put new files in
// the FeatureChoices folder, just make sure their name and export match the
// template you set on your feature datum

const requireFeatureChoice = require.context('./FeatureChoices');

const FeatureChoiceSpecific = (props: { customizer: Customizer }) => {
  const { customizer } = props;
  const { choices } = customizer;

  // almost wholesale ripped from routes.tsx
  const name = choices.template;
  const interfacePathBuilders = [
    (name: string) => `./${name}.tsx`,
    (name: string) => `./${name}.jsx`,
    (name: string) => `./${name}.js`,
    (name: string) => `./${name}/index.tsx`,
    (name: string) => `./${name}/index.jsx`,
    (name: string) => `./${name}/index.js`,
  ];

  let esModule;
  while (!esModule && interfacePathBuilders.length > 0) {
    const interfacePathBuilder = interfacePathBuilders.shift()!;
    const interfacePath = interfacePathBuilder(name);
    try {
      esModule = requireFeatureChoice(interfacePath);
    } catch (err) {
      if (err.code !== 'MODULE_NOT_FOUND') {
        throw err;
      }
    }
  }

  if (!esModule) {
    return null;
  }

  const Component = esModule[name];
  if (!Component) {
    return null;
  }

  return <Component customizer={customizer} />;
};
