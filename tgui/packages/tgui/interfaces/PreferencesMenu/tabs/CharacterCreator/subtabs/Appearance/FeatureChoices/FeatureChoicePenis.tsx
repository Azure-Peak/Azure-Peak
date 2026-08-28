import { LabeledGridList } from 'pm/components';
import type {
  Customizer,
  CustomizerChoice,
} from 'pm/tabs/CharacterCreator/data';
import { useBackendStrict } from 'tgui/backend';
import { Button, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

export interface PenisCustomizer extends CustomizerChoice {
  penis_size: string;
  penis_functional: BooleanLike;
}
export const FeatureChoicePenis = (props: { customizer: Customizer }) => {
  const { customizer } = props;
  const { act } = useBackendStrict();
  const { choices } = customizer;
  const { penis_size, penis_functional } = choices as PenisCustomizer;

  return (
    <Stack.Item>
      <LabeledGridList>
        <LabeledGridList.Item label="Penis Size">
          <Button
            fluid
            onClick={() =>
              act('change_customizer', {
                customizer: customizer.type,
                customizer_task: 'penis_size',
              })
            }
          >
            {penis_size}
          </Button>
        </LabeledGridList.Item>
        <LabeledGridList.Item label="Functional">
          <Button
            fluid
            onClick={() =>
              act('change_customizer', {
                customizer: customizer.type,
                customizer_task: 'functional',
              })
            }
          >
            {penis_functional ? 'YES' : 'NO'}
          </Button>
        </LabeledGridList.Item>
      </LabeledGridList>
    </Stack.Item>
  );
};
