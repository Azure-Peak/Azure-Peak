import type { Customizer } from 'pm/tabs/CharacterCreator/data';
import { useBackendStrict } from 'tgui/backend';
import { Button, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { FeatureChoiceHair, type HairCustomizer } from './FeatureChoiceHair';

export interface HairHeadCustomizer extends HairCustomizer {
  has_custom_hair: BooleanLike;
}

export const FeatureChoiceHairHead = (props: { customizer: Customizer }) => {
  const { customizer } = props;
  const { act } = useBackendStrict();
  const { choices } = customizer;
  const { allow_hair_color, has_custom_hair } = choices as HairHeadCustomizer;

  if (!allow_hair_color) {
    // currently this just also renders null but we want to make sure that
    // the parent gets it's behavior
    return <FeatureChoiceHair {...props} />;
  }

  return (
    <>
      {/* a little unusual but this is valid */}
      <FeatureChoiceHair {...props} />
      <Stack.Item>
        <Stack>
          <Stack.Item grow>
            <Button
              fluid
              onClick={() =>
                act('change_customizer', {
                  customizer: customizer.type,
                  customizer_task: 'custom_hair_editor',
                })
              }
            >
              Customize Hair
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              disabled={!has_custom_hair}
              onClick={() =>
                act('change_customizer', {
                  customizer: customizer.type,
                  customizer_task: 'custom_hair_clear',
                })
              }
            >
              Clear
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </>
  );
};
