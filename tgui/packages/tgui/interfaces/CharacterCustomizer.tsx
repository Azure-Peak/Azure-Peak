import { Box, Button, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type ColorEntry = {
  index: number;
  name: string;
  color: string;
};

type ExtraControl = {
  label: string | null;
  task: string;
  kind: 'button' | 'color';
  value: string;
};

type Customizer = {
  type: string;
  name: string;
  disabled: BooleanLike;
  allows_disabling: BooleanLike;
  choice_name: string;
  multiple_choices: BooleanLike;
  accessory: { name: string; multiple: BooleanLike } | null;
  colors: ColorEntry[];
  extra: ExtraControl[];
};

type Data = {
  customizers: Customizer[];
};

const Swatch = (props: { color: string; onClick: () => void }) => (
  <Button color="transparent" tooltip="Change color" onClick={props.onClick}>
    <Box
      inline
      width="20px"
      height="10px"
      style={{ backgroundColor: props.color, border: '1px solid #000' }}
    />
  </Button>
);

const CustomizerCard = (props: { customizer: Customizer }) => {
  const { act } = useBackend<Data>();
  const c = props.customizer;
  const send = (task: string, extra = {}) =>
    act('customizer_task', {
      customizer: c.type,
      customizer_task: task,
      ...extra,
    });
  return (
    <Section
      title={c.name}
      buttons={
        !!c.allows_disabling && (
          <Button selected={!c.disabled} onClick={() => send('toggle_missing')}>
            {c.disabled ? 'Disabled' : 'Enabled'}
          </Button>
        )
      }
    >
      {!c.disabled && (
        <>
          {!!c.multiple_choices && (
            <Box mb={0.5}>
              <Button onClick={() => send('change_choice')}>
                {c.choice_name}
              </Button>
            </Box>
          )}
          {c.accessory && !!c.accessory.multiple && (
            <Box mb={0.5}>
              <Button
                icon="chevron-left"
                onClick={() => send('rotate', { rotate: 'prev' })}
              />
              <Button
                icon="chevron-right"
                onClick={() => send('rotate', { rotate: 'next' })}
              />
              <Button onClick={() => send('choose_acc')}>
                {c.accessory.name}
              </Button>
            </Box>
          )}
          {c.colors.length > 0 && (
            <Box mb={0.5}>
              {c.colors.map((color) => (
                <Box key={color.index}>
                  <Box inline color="label" mr={1}>
                    {color.name}:
                  </Box>
                  <Swatch
                    color={color.color}
                    onClick={() =>
                      send('acc_color', { color_index: color.index })
                    }
                  />
                </Box>
              ))}
              <Button
                color="transparent"
                icon="rotate-left"
                onClick={() => send('reset_colors')}
              >
                Reset colors
              </Button>
            </Box>
          )}
          {c.extra.map((control) => (
            <Box key={control.task}>
              {control.label && (
                <Box inline color="label" mr={1}>
                  {control.label}:
                </Box>
              )}
              {control.kind === 'color' ? (
                <Swatch
                  color={control.value}
                  onClick={() => send(control.task)}
                />
              ) : (
                <Button onClick={() => send(control.task)}>
                  {control.value}
                </Button>
              )}
            </Box>
          ))}
        </>
      )}
    </Section>
  );
};

export function CharacterCustomizer(props) {
  const { data } = useBackend<Data>();
  return (
    <Window width={700} height={730} theme="parchment" title="Customization">
      <Window.Content scrollable>
        <Stack wrap>
          {data.customizers.map((customizer) => (
            <Stack.Item key={customizer.type} width="220px" mr={1}>
              <CustomizerCard customizer={customizer} />
            </Stack.Item>
          ))}
        </Stack>
      </Window.Content>
    </Window>
  );
}
