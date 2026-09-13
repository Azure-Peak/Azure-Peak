import { ColorButton, ensureColorHash, LabeledGridList } from 'pm/components';
import type {
  Customizer,
  CustomizerChoice,
} from 'pm/tabs/CharacterCreator/data';
import { useBackendStrict } from 'tgui/backend';
import { Button, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

export interface EyeCustomizer extends CustomizerChoice {
  eye_color: string;
  allows_heterochromia: BooleanLike;
  heterochromia: BooleanLike; // only show if allows_heterochromia
  second_color: string; // only show if heterochromia
}
export const FeatureChoiceEyes = (props: { customizer: Customizer }) => {
  const { customizer } = props;
  const { act } = useBackendStrict();
  const { choices } = customizer;
  const { eye_color, second_color, allows_heterochromia, heterochromia } =
    choices as EyeCustomizer;

  return (
    <Stack.Item>
      <LabeledGridList>
        <LabeledGridList.Item label="Eye Color" verticalAlign="middle">
          <ColorButton
            backgroundColor={eye_color}
            tooltip={ensureColorHash(eye_color)}
            onClick={() =>
              act('change_customizer', {
                customizer: customizer.type,
                customizer_task: 'eye_color',
              })
            }
          />
        </LabeledGridList.Item>
        {allows_heterochromia ? (
          <>
            <LabeledGridList.Item label="Heterochromia">
              <Button.Checkbox
                checked={heterochromia}
                selected={heterochromia}
                onClick={() =>
                  act('change_customizer', {
                    customizer: customizer.type,
                    customizer_task: 'heterochromia',
                  })
                }
              />
            </LabeledGridList.Item>
            {heterochromia ? (
              <LabeledGridList.Item label="Second Color" verticalAlign="middle">
                <ColorButton
                  backgroundColor={second_color}
                  tooltip={ensureColorHash(second_color)}
                  onClick={() =>
                    act('change_customizer', {
                      customizer: customizer.type,
                      customizer_task: 'second_eye_color',
                    })
                  }
                />
              </LabeledGridList.Item>
            ) : null}
          </>
        ) : null}
      </LabeledGridList>
    </Stack.Item>
  );
};
