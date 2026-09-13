import { ColorButton, ensureColorHash, LabeledGridList } from 'pm/components';
import type {
  Customizer,
  CustomizerChoice,
} from 'pm/tabs/CharacterCreator/data';
import { useBackendStrict } from 'tgui/backend';
import { Button, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

export interface HairCustomizer extends CustomizerChoice {
  allow_hair_color: BooleanLike;
  hair_color: string;
  natural_color: string; // only display if natgrad != null && natgrad != "None"
  dye_color: string; // only display if dyegrad != null && dyegrad != "None"
  natgrad: string | null; // null indicates no gradient
  dyegrad: string | null; // null indicates no gradient
}

export const FeatureChoiceHair = (props: { customizer: Customizer }) => {
  const { customizer } = props;
  const { act } = useBackendStrict();
  const { choices } = customizer;
  const {
    allow_hair_color,
    hair_color,
    natural_color,
    dye_color,
    natgrad,
    dyegrad,
  } = choices as HairCustomizer;

  if (!allow_hair_color) {
    return null;
  }

  return (
    <>
      <Stack.Item>
        <LabeledGridList>
          <LabeledGridList.Item label="Hair Color" verticalAlign="middle">
            <ColorButton
              backgroundColor={hair_color}
              tooltip={ensureColorHash(hair_color)}
              onClick={() =>
                act('change_customizer', {
                  customizer: customizer.type,
                  customizer_task: 'hair_color',
                })
              }
            />
          </LabeledGridList.Item>
        </LabeledGridList>
      </Stack.Item>
      <Stack.Item style={{ borderBottom: '2px solid var(--color-border)' }}>
        Natural Gradient
      </Stack.Item>
      <Stack.Item>
        <Stack align="center">
          <Stack.Item grow>
            <Button
              fluid
              onClick={() =>
                act('change_customizer', {
                  customizer: customizer.type,
                  customizer_task: 'natural_gradient',
                })
              }
            >
              {natgrad}
            </Button>
          </Stack.Item>
          {natgrad !== null && natgrad !== 'None' ? (
            <Stack.Item>
              <ColorButton
                backgroundColor={natural_color}
                tooltip={ensureColorHash(natural_color)}
                onClick={() =>
                  act('change_customizer', {
                    customizer: customizer.type,
                    customizer_task: 'natural_gradient_color',
                  })
                }
              />
            </Stack.Item>
          ) : null}
        </Stack>
      </Stack.Item>
      <Stack.Item style={{ borderBottom: '2px solid var(--color-border)' }}>
        Dye Gradient
      </Stack.Item>
      <Stack.Item>
        <Stack align="center">
          <Stack.Item grow>
            <Button
              fluid
              onClick={() =>
                act('change_customizer', {
                  customizer: customizer.type,
                  customizer_task: 'dye_gradient',
                })
              }
            >
              {dyegrad}
            </Button>
          </Stack.Item>
          {dyegrad !== null && dyegrad !== 'None' ? (
            <Stack.Item>
              <ColorButton
                backgroundColor={dye_color}
                tooltip={ensureColorHash(dye_color)}
                onClick={() =>
                  act('change_customizer', {
                    customizer: customizer.type,
                    customizer_task: 'dye_gradient_color',
                  })
                }
              />
            </Stack.Item>
          ) : null}
        </Stack>
      </Stack.Item>
    </>
  );
};
