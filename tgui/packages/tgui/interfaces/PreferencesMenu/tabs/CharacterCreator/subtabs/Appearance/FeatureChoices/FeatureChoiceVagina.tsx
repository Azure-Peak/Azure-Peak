import { LabeledGridList } from 'pm/components';
import type {
  Customizer,
  CustomizerChoice,
} from 'pm/tabs/CharacterCreator/data';
import { useBackendStrict } from 'tgui/backend';
import { Button, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
export interface VaginaCustomizer extends CustomizerChoice {
  fertility: BooleanLike;
}

export const FeatureChoiceVagina = (props: { customizer: Customizer }) => {
  const { customizer } = props;
  const { act } = useBackendStrict();
  const { choices } = customizer;
  const { fertility } = choices as VaginaCustomizer;

  return (
    <Stack.Item>
      <LabeledGridList>
        <LabeledGridList.Item label="Fertility">
          <Button
            fluid
            onClick={() =>
              act('change_customizer', {
                customizer: customizer.type,
                customizer_task: 'fertile',
              })
            }
          >
            {fertility ? 'Fertile' : 'Sterile'}
          </Button>
        </LabeledGridList.Item>
      </LabeledGridList>
    </Stack.Item>
  );
};
