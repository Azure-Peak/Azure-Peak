/**
 * @file
 * @copyright 2023 itsmeow
 * @license MIT
 */
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { type HsvaColor, hexToHsva, hsvaToHex } from 'tgui-core/color';
import {
  Box,
  Button,
  Section,
  Stack,
  Tabs,
  Tooltip,
} from 'tgui-core/components';
import { classes } from 'tgui-core/react';
import type { ColorPickerData } from '.';
import {
  BYOND_HEXGRID_COLORS,
  BYOND_OTHER_COLORS,
  LARGEST_HEXGRID_ROW,
} from './byond_colors';

type ColorPresetsProps = {
  color: HsvaColor;
  setColor: (color: HsvaColor) => void;
  setShowPresets: (show: boolean) => void;
};

enum PresetTab {
  Named,
  BYOND,
}

export const ColorPresets = ({
  color,
  setColor,
  setShowPresets,
}: ColorPresetsProps) => {
  const { data } = useBackend<ColorPickerData>();
  const { named_presets } = data;

  const showNamedPresets = !!(
    named_presets && Object.keys(named_presets).length
  );

  const [tab, setTab] = useState(
    showNamedPresets ? PresetTab.Named : PresetTab.BYOND,
  );

  return (
    <Section
      fill
      title={tab === PresetTab.Named ? 'Dye Colors' : 'BYOND Presets'}
      buttons={
        <Stack align="center">
          {showNamedPresets ? (
            <Stack.Item>
              <Tabs style={{ margin: 0 }}>
                <Tabs.Tab
                  selected={tab === PresetTab.BYOND}
                  onClick={() => setTab(PresetTab.BYOND)}
                >
                  BYOND
                </Tabs.Tab>
                <Tabs.Tab
                  selected={tab === PresetTab.Named}
                  onClick={() => setTab(PresetTab.Named)}
                >
                  Dye Colors
                </Tabs.Tab>
              </Tabs>
            </Stack.Item>
          ) : null}
          <Stack.Item>
            <Button onClick={() => setShowPresets(false)} icon="chevron-up">
              Hide
            </Button>
          </Stack.Item>
        </Stack>
      }
      style={{
        boxShadow: 'none',
        background: 'none',
      }}
    >
      {tab === PresetTab.Named ? (
        <ColorPresetsNamed color={color} setColor={setColor} />
      ) : null}
      {tab === PresetTab.BYOND ? (
        <ColorPresetsBYOND color={color} setColor={setColor} />
      ) : null}
    </Section>
  );
};

const ColorPresetsNamed = ({
  color,
  setColor,
}: Pick<ColorPresetsProps, 'color' | 'setColor'>) => {
  const { data } = useBackend<ColorPickerData>();
  const { named_presets } = data;

  return (
    <Stack
      // can't use g= because it'll get converted to rem and rem will not
      // make a nice pretty grid
      // wrap also doesn't work when style is specified so lolll
      style={{
        gap: '2px',
        flexWrap: 'wrap',
      }}
    >
      {Object.entries(named_presets!).map(([name, hex]) => (
        <Tooltip key={name} content={name} position="bottom">
          <Stack.Item
            width={1.5}
            height={1.5}
            style={{
              backgroundColor: hex,
              border:
                hsvaToHex(color) === hex.toLowerCase()
                  ? '2px solid white'
                  : '1px solid rgba(255,255,255,0.3)',
              borderRadius: '0px',
              cursor: 'pointer',
            }}
            onClick={() => {
              setColor(hexToHsva(hex));
            }}
          />
        </Tooltip>
      ))}
    </Stack>
  );
};

const ColorPresetsBYOND = ({
  color,
  setColor,
}: Pick<ColorPresetsProps, 'color' | 'setColor'>) => {
  const colorAsHex = hsvaToHex(color);

  return (
    <Stack fill align="center" justify="space-around" vertical>
      <Stack.Item>
        <Box className="ColorPicker__HexGrid">
          {BYOND_HEXGRID_COLORS.map((row, i) => {
            const largest_offset = LARGEST_HEXGRID_ROW - row.length;
            return (
              <Box
                key={i}
                className="HexRow"
                style={
                  {
                    '--largest-offset': largest_offset,
                  } as any
                }
              >
                {row.map((cellColor) => (
                  <Box
                    key={cellColor}
                    backgroundColor={cellColor}
                    className={classes([
                      'HexCell',
                      cellColor === colorAsHex ? 'selected' : undefined,
                    ])}
                    onClick={() => {
                      setColor(hexToHsva(cellColor));
                    }}
                  />
                ))}
              </Box>
            );
          })}
        </Box>
      </Stack.Item>
      <Stack.Item>
        <Stack>
          <Stack.Item>
            <Box
              backgroundColor={'#ffffff'}
              className={classes([
                'HexCell big',
                '#ffffff' === colorAsHex ? 'selected' : undefined,
              ])}
              style={{}}
              onClick={() => {
                setColor(hexToHsva('#ffffff'));
              }}
            />
          </Stack.Item>
          <Stack.Item>
            <Box className="ColorPicker__HexGrid">
              {BYOND_OTHER_COLORS.map((row, i) => {
                return (
                  <Box key={i} className="HexRow HexRowAuto">
                    {row.map((cellColor) => (
                      <Box
                        key={cellColor}
                        backgroundColor={cellColor}
                        className={classes([
                          'HexCell',
                          cellColor === colorAsHex ? 'selected' : undefined,
                        ])}
                        onClick={() => {
                          setColor(hexToHsva(cellColor));
                        }}
                      />
                    ))}
                  </Box>
                );
              })}
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Box
              backgroundColor={'#000000'}
              className={classes([
                'HexCell big',
                '#000000' === colorAsHex ? 'selected' : undefined,
              ])}
              style={{}}
              onClick={() => {
                setColor(hexToHsva('#000000'));
              }}
            />
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
