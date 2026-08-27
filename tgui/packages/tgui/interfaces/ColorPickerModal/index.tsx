/**
 * @file
 * @copyright 2023 itsmeow
 * @license MIT
 */
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { type HsvaColor, hexToHsva } from 'tgui-core/color';
import { Autofocus, Box, Section, Stack } from 'tgui-core/components';
import { Loader } from '../common/Loader';
import { ColorSelector } from './ColorSetter';

export type ColorPickerData = {
  timeout: number | null;
  autofocus: boolean;
  large_buttons: boolean;
  swapped_buttons: boolean;
  title: string;
  default_color: string;
  message: string;
  named_presets: Record<string, string> | null;
};

export const ColorPickerModal = (props) => {
  const { data } = useBackend<ColorPickerData>();
  const {
    timeout,
    autofocus,
    title,
    default_color = '#000000',
    message,
  } = data;

  const [selectedColor, setSelectedColor] = useState<HsvaColor>(
    hexToHsva(default_color),
  );

  return (
    <Window
      height={message ? 465 : 430}
      title={title || 'Colour Editor'}
      width={700}
    >
      {!!timeout && <Loader value={timeout} />}
      <Window.Content className="ColorPicker">
        <Stack fill vertical>
          {!!autofocus && <Autofocus />}
          {message && (
            <Stack.Item>
              <Section fill>
                <Box color="label" overflow="hidden">
                  {message}
                </Box>
              </Section>
            </Stack.Item>
          )}
          <Stack.Item grow>
            <Section fill>
              <ColorSelector
                color={selectedColor}
                setColor={setSelectedColor}
                defaultColor={default_color}
              />
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
