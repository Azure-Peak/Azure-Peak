/**
 * @file
 * @copyright 2023 itsmeow
 * @license MIT
 */

import {
  hexToHsva,
  type HsvaColor,
  hsvaToHex,
  hsvaToHslString,
  hsvaToRgba,
  rgbaToHsva,
  validHex,
} from 'common/colorpicker';
import React, { useCallback, useEffect, useMemo, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Pointer } from 'tgui/components';
import { type Interaction, Interactive } from 'tgui/components/Interactive';
import { Window } from 'tgui/layouts';
import {
  Autofocus,
  Box,
  Input,
  NumberInput,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import { clamp } from 'tgui-core/math';
import { classes } from 'tgui-core/react';

import { InputButtons } from './common/InputButtons';
import { Loader } from './common/Loader';

interface ColorPickerData {
  autofocus: boolean;
  buttons: string[];
  message: string;
  large_buttons: boolean;
  swapped_buttons: boolean;
  timeout: number;
  title: string;
  default_color: string;
  presets: string;
  named_presets?: Record<string, string>;
}

type ColorPickerModalProps = Record<never, never>;

export const ColorPickerModal: React.FC<ColorPickerModalProps> = () => {
  const { data } = useBackend<ColorPickerData>();
  const {
    timeout,
    message,
    autofocus,
    default_color = '#000000',
    named_presets,
  } = data;
  let { title } = data;
  const hasNamedPresets = named_presets && Object.keys(named_presets).length > 0;

  const [selectedColor, setSelectedColor] = useState<HsvaColor>(
    hexToHsva(default_color),
  );

  useEffect(() => {
    setSelectedColor(hexToHsva(default_color));
  }, [default_color]);

  if (!title) {
    title = 'Color';
  }

  // Increase height when named presets are shown
  let windowHeight = message ? 460 : 420;
  if (hasNamedPresets) {
    windowHeight += 90;
  }

  return (
    <Window
      height={windowHeight}
      title={title}
      width={600}
      theme="generic"
    >
      {!!timeout && <Loader value={timeout} />}
      <Window.Content>
        <Stack fill vertical>
          {!!autofocus && <Autofocus />}
          {message && (
            <Stack.Item m={1}>
              <Section fill>
                <Box color="label" overflow="hidden">
                  {message}
                </Box>
              </Section>
            </Stack.Item>
          )}
          {hasNamedPresets && named_presets && (
            <Stack.Item>
              <Section title="Dye Colors">
                <Box style={{ display: 'flex', flexWrap: 'wrap', gap: '2px' }}>
                  {Object.entries(named_presets).map(([name, hex]) => (
                    <Tooltip key={name} content={name} position="bottom">
                      <Box
                        style={{
                          width: '22px',
                          height: '22px',
                          backgroundColor: hex,
                          border:
                            hsvaToHex(selectedColor) === hex.toLowerCase()
                              ? '2px solid white'
                              : '1px solid rgba(255,255,255,0.3)',
                          borderRadius: '2px',
                          cursor: 'pointer',
                        }}
                        onClick={() => {
                          setSelectedColor(hexToHsva(hex));
                        }}
                      />
                    </Tooltip>
                  ))}
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
          <Stack.Item>
            <InputButtons input={hsvaToHex(selectedColor)} />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

interface ColorSelectorProps {
  color: HsvaColor;
  setColor: React.Dispatch<React.SetStateAction<HsvaColor>>;
  defaultColor: string;
}

const ColorSelector: React.FC<ColorSelectorProps> = React.memo(
  ({ color, setColor, defaultColor }) => {
    const handleChange = useCallback(
      (params: Partial<HsvaColor>) => {
        setColor((current) => ({ ...current, ...params }));
      },
      [setColor],
    );

    const hexColor = hsvaToHex(color);

    return (
      <Stack direction="row">
        <Stack.Item mr={2}>
          <Stack vertical>
            <Stack.Item>
              <div className="react-colorful">
                <SaturationValue hsva={color} onChange={handleChange} />
                <Hue
                  hue={color.h}
                  onChange={handleChange}
                  className="react-colorful__last-control"
                />
              </div>
            </Stack.Item>
            <Stack.Item>
              <Box inline width="100px" height="20px" textAlign="center">
                Current
              </Box>
              <Box inline width="100px" height="20px" textAlign="center">
                Previous
              </Box>
              <br />
              <Tooltip content={hexColor} position="bottom">
                <Box
                  inline
                  width="100px"
                  height="30px"
                  backgroundColor={hexColor}
                />
              </Tooltip>
              <Tooltip content={defaultColor} position="bottom">
                <Box
                  inline
                  width="100px"
                  height="30px"
                  backgroundColor={defaultColor}
                />
              </Tooltip>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item grow fontSize="15px" lineHeight="24px">
          <Stack vertical>
            <Stack.Item>
              <Stack>
                <Stack.Item>
                  <Box textColor="label">Hex:</Box>
                </Stack.Item>
                <Stack.Item grow height="24px">
                  <HexColorInput
                    fluid
                    color={hsvaToHex(color).substring(1)}
                    onChange={(value) => {
                      setColor(hexToHsva(value));
                    }}
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Divider />
            <HueRow color={color} handleChange={handleChange} />
            <SaturationRow color={color} handleChange={handleChange} />
            <ValueRow color={color} handleChange={handleChange} />
            <Stack.Divider />
            <RedRow color={color} handleChange={handleChange} />
            <GreenRow color={color} handleChange={handleChange} />
            <BlueRow color={color} handleChange={handleChange} />
          </Stack>
        </Stack.Item>
      </Stack>
    );
  },
);

interface RowProps {
  color: HsvaColor;
  handleChange: (c: Partial<HsvaColor>) => void;
}

const HueRow: React.FC<RowProps> = React.memo(({ color, handleChange }) => (
  <Stack.Item>
    <Stack>
      <Stack.Item width="25px">
        <Box textColor="label">H:</Box>
      </Stack.Item>
      <Stack.Item grow>
        <Hue hue={color.h} onChange={handleChange} />
      </Stack.Item>
      <Stack.Item>
        <TextSetter
          value={color.h}
          callback={(v) => handleChange({ h: v })}
          max={360}
          unit="°"
        />
      </Stack.Item>
    </Stack>
  </Stack.Item>
));

const SaturationRow: React.FC<RowProps> = React.memo(
  ({ color, handleChange }) => (
    <Stack.Item>
      <Stack>
        <Stack.Item width="25px">
          <Box textColor="label">S:</Box>
        </Stack.Item>
        <Stack.Item grow>
          <Saturation color={color} onChange={handleChange} />
        </Stack.Item>
        <Stack.Item>
          <TextSetter
            value={color.s}
            callback={(v) => handleChange({ s: v })}
            unit="%"
          />
        </Stack.Item>
      </Stack>
    </Stack.Item>
  ),
);

const ValueRow: React.FC<RowProps> = React.memo(({ color, handleChange }) => (
  <Stack.Item>
    <Stack>
      <Stack.Item width="25px">
        <Box textColor="label">V:</Box>
      </Stack.Item>
      <Stack.Item grow>
        <Value color={color} onChange={handleChange} />
      </Stack.Item>
      <Stack.Item>
        <TextSetter
          value={color.v}
          callback={(v) => handleChange({ v })}
          unit="%"
        />
      </Stack.Item>
    </Stack>
  </Stack.Item>
));

interface RGBRowProps {
  color: HsvaColor;
  handleChange: (c: HsvaColor) => void;
}

const RedRow: React.FC<RGBRowProps> = React.memo(({ color, handleChange }) => {
  const rgb = hsvaToRgba(color);
  return (
    <Stack.Item>
      <Stack>
        <Stack.Item width="25px">
          <Box textColor="label">R:</Box>
        </Stack.Item>
        <Stack.Item grow>
          <RGBSlider color={color} onChange={handleChange} target="r" />
        </Stack.Item>
        <Stack.Item>
          <TextSetter
            value={rgb.r}
            callback={(v) => {
              handleChange(rgbaToHsva({ ...rgb, r: v }));
            }}
            max={255}
          />
        </Stack.Item>
      </Stack>
    </Stack.Item>
  );
});

const GreenRow: React.FC<RGBRowProps> = React.memo(
  ({ color, handleChange }) => {
    const rgb = hsvaToRgba(color);
    return (
      <Stack.Item>
        <Stack>
          <Stack.Item width="25px">
            <Box textColor="label">G:</Box>
          </Stack.Item>
          <Stack.Item grow>
            <RGBSlider color={color} onChange={handleChange} target="g" />
          </Stack.Item>
          <Stack.Item>
            <TextSetter
              value={rgb.g}
              callback={(v) => {
                handleChange(rgbaToHsva({ ...rgb, g: v }));
              }}
              max={255}
            />
          </Stack.Item>
        </Stack>
      </Stack.Item>
    );
  },
);

const BlueRow: React.FC<RGBRowProps> = React.memo(({ color, handleChange }) => {
  const rgb = hsvaToRgba(color);
  return (
    <Stack.Item>
      <Stack>
        <Stack.Item width="25px">
          <Box textColor="label">B:</Box>
        </Stack.Item>
        <Stack.Item grow>
          <RGBSlider color={color} onChange={handleChange} target="b" />
        </Stack.Item>
        <Stack.Item>
          <TextSetter
            value={rgb.b}
            callback={(v) => {
              handleChange(rgbaToHsva({ ...rgb, b: v }));
            }}
            max={255}
          />
        </Stack.Item>
      </Stack>
    </Stack.Item>
  );
});

interface TextSetterProps {
  value: number;
  callback: (value: number) => void;
  min?: number;
  max?: number;
  unit?: string;
}

const TextSetter: React.FC<TextSetterProps> = React.memo(
  ({ value, callback, min = 0, max = 100, unit }) => {
    return (
      <NumberInput
        width="70px"
        value={Math.round(value)}
        step={1}
        minValue={min}
        maxValue={max}
        onChange={callback}
        unit={unit}
      />
    );
  },
);

interface HexColorInputProps {
  prefixed?: boolean;
  alpha?: boolean;
  color: string;
  fluid?: boolean;
  onChange: (newColor: string) => void;
}

const HexColorInput: React.FC<HexColorInputProps> = React.memo(
  ({ alpha, color, fluid, onChange, ...rest }) => {
    const initialColor = useMemo(() => {
      const stripped = color
        .replace(/[^0-9A-Fa-f]/g, '')
        .substring(0, 6)
        .toUpperCase();
      return stripped;
    }, [color]);

    const [localValue, setLocalValue] = useState(initialColor);

    useEffect(() => {
      setLocalValue(initialColor);
    }, [initialColor]);

    const isValidFullHex = useCallback(
      (val: string) => {
        return validHex(val, alpha) && val.length === 6;
      },
      [alpha],
    );

    const handleChangeEvent = (value: string) => {
      const strippedValue = value
        .replace(/[^0-9A-Fa-f]/g, '')
        .substring(0, 6)
        .toUpperCase();

      setLocalValue(strippedValue);

      if (isValidFullHex(strippedValue)) {
        onChange(strippedValue);
      }
    };

    const commitOrRevert = useCallback(() => {
      if (isValidFullHex(localValue)) {
        onChange(localValue);
      } else {
        setLocalValue(initialColor);
      }
    }, [initialColor, isValidFullHex, localValue, onChange]);

    const handleKeyDown = (value: string) => {
      commitOrRevert();
    };

    return (
      <Input
        fluid
        value={localValue}
        onChange={handleChangeEvent}
        onEnter={handleKeyDown}
        {...rest}
      />
    );
  },
);

interface SaturationValueProps {
  hsva: HsvaColor;
  onChange: (newColor: Partial<HsvaColor>) => void;
}

const SaturationValue: React.FC<SaturationValueProps> = React.memo(
  ({ hsva, onChange }) => {
    const handleMove = (interaction: Interaction) => {
      onChange({
        s: interaction.left * 100,
        v: 100 - interaction.top * 100,
      });
    };

    const handleKey = (offset: Interaction) => {
      onChange({
        s: clamp(hsva.s + offset.left * 100, 0, 100),
        v: clamp(hsva.v - offset.top * 100, 0, 100),
      });
    };

    const containerStyle = useMemo(
      () => ({
        backgroundColor: hsvaToHslString({
          h: hsva.h,
          s: 100,
          v: 100,
          a: 1,
        }),
      }),
      [hsva.h],
    );

    return (
      <div className="react-colorful__saturation_value" style={containerStyle}>
        <Interactive
          onMove={handleMove}
          onKey={handleKey}
          aria-label="Color"
          aria-valuetext={`Saturation ${Math.round(
            hsva.s,
          )}%, Brightness ${Math.round(hsva.v)}%`}
        >
          <Pointer
            className="react-colorful__saturation_value-pointer"
            top={1 - hsva.v / 100}
            left={hsva.s / 100}
            color={hsvaToHslString(hsva)}
          />
        </Interactive>
      </div>
    );
  },
);

interface HueProps {
  className?: string;
  hue: number;
  onChange: (newHue: Partial<HsvaColor>) => void;
}

const Hue: React.FC<HueProps> = React.memo(({ className, hue, onChange }) => {
  const handleMove = (interaction: Interaction) => {
    onChange({ h: 360 * interaction.left });
  };

  const handleKey = (offset: Interaction) => {
    onChange({ h: clamp(hue + offset.left * 360, 0, 360) });
  };

  const nodeClassName = classes(['react-colorful__hue', className]);

  return (
    <div className={nodeClassName}>
      <Interactive
        onMove={handleMove}
        onKey={handleKey}
        aria-label="Hue"
        aria-valuenow={Math.round(hue)}
        aria-valuemax={360}
        aria-valuemin={0}
      >
        <Pointer
          className="react-colorful__hue-pointer"
          left={hue / 360}
          color={hsvaToHslString({ h: hue, s: 100, v: 100, a: 1 })}
        />
      </Interactive>
    </div>
  );
});

interface SaturationProps {
  className?: string;
  color: HsvaColor;
  onChange: (newSaturation: Partial<HsvaColor>) => void;
}

const Saturation: React.FC<SaturationProps> = React.memo(
  ({ className, color, onChange }) => {
    const handleMove = (interaction: Interaction) => {
      onChange({ s: 100 * interaction.left });
    };

    const handleKey = (offset: Interaction) => {
      onChange({ s: clamp(color.s + offset.left * 100, 0, 100) });
    };

    const nodeClassName = classes(['react-colorful__saturation', className]);

    const background = useMemo(
      () =>
        `linear-gradient(to right, ${hsvaToHslString({
          h: color.h,
          s: 0,
          v: color.v,
          a: 1,
        })}, ${hsvaToHslString({ h: color.h, s: 100, v: color.v, a: 1 })})`,
      [color],
    );

    return (
      <div className={nodeClassName}>
        <Interactive
          style={{ background }}
          onMove={handleMove}
          onKey={handleKey}
          aria-label="Saturation"
          aria-valuenow={Math.round(color.s)}
          aria-valuemax={100}
          aria-valuemin={0}
        >
          <Pointer
            className="react-colorful__saturation-pointer"
            left={color.s / 100}
            color={hsvaToHslString({
              h: color.h,
              s: color.s,
              v: color.v,
              a: 1,
            })}
          />
        </Interactive>
      </div>
    );
  },
);

interface ValueProps {
  className?: string;
  color: HsvaColor;
  onChange: (newValue: Partial<HsvaColor>) => void;
}

const Value: React.FC<ValueProps> = React.memo(
  ({ className, color, onChange }) => {
    const handleMove = (interaction: Interaction) => {
      onChange({ v: 100 * interaction.left });
    };

    const handleKey = (offset: Interaction) => {
      onChange({
        v: clamp(color.v + offset.left * 100, 0, 100),
      });
    };

    const nodeClassName = classes(['react-colorful__value', className]);

    const background = useMemo(
      () =>
        `linear-gradient(to right, ${hsvaToHslString({
          h: color.h,
          s: color.s,
          v: 0,
          a: 1,
        })}, ${hsvaToHslString({ h: color.h, s: color.s, v: 100, a: 1 })})`,
      [color],
    );

    return (
      <div className={nodeClassName}>
        <Interactive
          style={{
            background,
          }}
          onMove={handleMove}
          onKey={handleKey}
          aria-label="Value"
          aria-valuenow={Math.round(color.v)}
          aria-valuemax={100}
          aria-valuemin={0}
        >
          <Pointer
            className="react-colorful__value-pointer"
            left={color.v / 100}
            color={hsvaToHslString(color)}
          />
        </Interactive>
      </div>
    );
  },
);

interface RGBSliderProps {
  className?: string;
  color: HsvaColor;
  onChange: (newValue: HsvaColor) => void;
  target: 'r' | 'g' | 'b';
}

const RGBSlider: React.FC<RGBSliderProps> = React.memo(
  ({ className, color, onChange, target }) => {
    const rgb = hsvaToRgba(color);

    const setNewTarget = (value: number) => {
      const newRgb = { ...rgb, [target]: value };
      onChange(rgbaToHsva(newRgb));
    };

    const handleMove = (interaction: Interaction) => {
      setNewTarget(255 * interaction.left);
    };

    const handleKey = (offset: Interaction) => {
      setNewTarget(clamp(rgb[target] + offset.left * 255, 0, 255));
    };

    const nodeClassName = classes([`react-colorful__${target}`, className]);

    const channels = {
      r: `rgb(${Math.round(rgb.r)},0,0)`,
      g: `rgb(0,${Math.round(rgb.g)},0)`,
      b: `rgb(0,0,${Math.round(rgb.b)})`,
    };

    const selected = channels[target];

    return (
      <div className={nodeClassName}>
        <Interactive
          onMove={handleMove}
          onKey={handleKey}
          aria-valuenow={rgb[target]}
          aria-valuemax={255}
          aria-valuemin={0}
        >
          <Pointer
            className={`react-colorful__${target}-pointer`}
            left={rgb[target] / 255}
            color={selected}
          />
        </Interactive>
      </div>
    );
  },
);
