/**
 * @file
 * @copyright 2023 itsmeow
 * @license MIT
 */
import React, { useCallback, useEffect, useMemo, useState } from 'react';
import { validHex } from 'tgui-core/color';
import { Box, Input, NumberInput } from 'tgui-core/components';

type TextSetterProps = {
  value: number;
  callback: (value: number) => void;
  min?: number;
  max?: number;
  unit?: string;
};

export const TextSetter = React.memo(
  ({ value, callback, min = 0, max = 100, unit }: TextSetterProps) => {
    return (
      // Pterra does some WEIRD shit to our text so opt out
      <Box fontFamily="Verdana, Geneva, sans-serif">
        <NumberInput
          width="70px"
          value={Math.round(value)}
          step={1}
          minValue={min}
          maxValue={max}
          onChange={callback}
          unit={unit}
        />
      </Box>
    );
  },
);

type HexColorInputProps = {
  prefixed?: boolean;
  alpha?: boolean;
  color: string;
  fluid?: boolean;
  onChange: (newColor: string) => void;
};

export const HexColorInput = React.memo(
  ({ alpha, color, fluid, onChange, ...rest }: HexColorInputProps) => {
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

    const handleBlur = () => {
      commitOrRevert();
    };

    const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
      if (e.key === 'Enter') {
        commitOrRevert();
        (e.currentTarget as HTMLInputElement).blur();
      }
    };

    return (
      <Input
        fluid
        value={localValue}
        onChange={handleChangeEvent}
        onBlur={handleBlur}
        onKeyDown={handleKeyDown}
        {...rest}
      />
    );
  },
);
