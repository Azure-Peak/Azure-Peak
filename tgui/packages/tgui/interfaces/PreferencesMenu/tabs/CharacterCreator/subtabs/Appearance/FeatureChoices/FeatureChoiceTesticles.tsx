import { LabeledGridList } from 'pm/components';
import type {
  Customizer,
  CustomizerChoice,
} from 'pm/tabs/CharacterCreator/data';
import { useBackendStrict } from 'tgui/backend';
import { Button, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

export interface TesticleCustomizer extends CustomizerChoice {
  can_customize_size: BooleanLike;
  ball_size: string;
  virile: BooleanLike;
}

export const FeatureChoiceTesticles = (props: { customizer: Customizer }) => {
  const { customizer } = props;
  const { act } = useBackendStrict();
  const { choices } = customizer;
  const { can_customize_size, ball_size, virile } =
    choices as TesticleCustomizer;

  return (
    <Stack.Item>
      <LabeledGridList>
        {can_customize_size ? (
          <LabeledGridList.Item label="Ball Size">
            <Button
              fluid
              onClick={() =>
                act('change_customizer', {
                  customizer: customizer.type,
                  customizer_task: 'ball_size',
                })
              }
            >
              {ball_size}
            </Button>
          </LabeledGridList.Item>
        ) : null}
        <LabeledGridList.Item label="Virile">
          <Button
            fluid
            onClick={() =>
              act('change_customizer', {
                customizer: customizer.type,
                customizer_task: 'virile',
              })
            }
          >
            {virile ? 'Virile' : 'Sterile'}
          </Button>
        </LabeledGridList.Item>
      </LabeledGridList>
    </Stack.Item>
  );
};
