import { typedKeys } from 'common/type-safety';
import { useState } from 'react';
import { resolveAsset } from 'tgui/assets';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  ByondUi,
  ColorBox,
  Dropdown,
  InfinitePlane,
  Input,
  Stack,
} from 'tgui-core/components';
import { Window } from '../../layouts';
import {
  type Connection,
  Connections,
  type Coordinates,
} from '../common/Connections';
import { AppearanceBox } from './AppearanceBox';
import { AppearanceInfo } from './AppearanceInfo';
import {
  getAppearanceHeight,
  getAppearanceWidth,
  parseAppearanceData,
  textWidth,
} from './helpers';
import type { Appearance, AppearanceDebugData } from './types';
import { AppearanceParentType, HiddenState } from './types';
import { AppearanceDebugContext } from './useAppearanceDebug';

export function AppearanceDebug() {
  const { data, act } = useBackend<AppearanceDebugData>();
  const {
    mainAppearance,
    planeToText,
    layerToText,
    flagsToText,
    visToText,
    blendToText,
    mapRefHover,
    mapRefSelected,
    updateWarning,
    forcedPlane,
    backdropColor,
  } = data;
  const [planeFilter, setPlaneFilter] = useState<string | null>(null);
  const [hideEmissives, setHideEmissives] = useState(false);

  // This is a constant because we do not dynamically refresh, as appearances cannot be modified and rebuild all at once
  // So we do not need to concern ourselves with constant updates, and can just send data in ui_static_data()
  const appsProcessed = parseAppearanceData(
    mainAppearance,
    layerToText,
    planeToText,
    planeFilter ? planeToText[planeFilter] : null,
    hideEmissives,
  );
  const [zoomToX, setZoomToX] = useState<number>();
  const [zoomToY, setZoomToY] = useState<number>();
  const [selection, setSelection] = useState<number | null>(null);

  function mapPosition(
    appearance: Appearance,
    positions: Record<number, Coordinates>,
  ) {
    if (appearance.data.id in positions) return positions[appearance.data.id];
    const position: Coordinates = {
      x: appearance.relativePosition.x,
      y: appearance.relativePosition.y,
    };
    if (appearance.parent) {
      if (!(appearance.parent.data.id in positions))
        mapPosition(appearance.parent, positions);
      position.x += positions[appearance.parent.data.id].x;
      position.y += positions[appearance.parent.data.id].y;
    }
    positions[appearance.data.id] = position;
    return position;
  }

  const NODE_PADDING = 20;
  const OVERLAY_NODE_INPUT_PADDING = 60;
  const UNDERLAY_NODE_INPUT_PADDING = 40;

  const connections: Connection[] = [];
  const appearancePositions: Record<number, Coordinates> = {};
  for (let i = 0; i < Object.keys(appsProcessed).length; i++) {
    const appearance = appsProcessed[typedKeys(appsProcessed)[i]] as Appearance;
    if (!appearance.parent || appearance.hidden === HiddenState.Hidden)
      continue;
    const position = mapPosition(appearance, appearancePositions);
    const parentPosition = mapPosition(appearance.parent, appearancePositions);
    connections.push({
      from: {
        x:
          position.x +
          getAppearanceWidth(appearance, layerToText, planeToText) -
          NODE_PADDING,
        y: position.y + getAppearanceHeight(appearance) / 2,
      },
      to: {
        x: parentPosition.x + NODE_PADDING,
        y:
          appearance.parentType === AppearanceParentType.Overlay
            ? parentPosition.y + OVERLAY_NODE_INPUT_PADDING
            : parentPosition.y +
              getAppearanceHeight(appearance.parent) -
              UNDERLAY_NODE_INPUT_PADDING,
      },
      index: i,
      color: `hsl(${60 + 5 * (i % 30)}, 50%, ${50 + (i % 30)}%)`,
    });
  }

  return (
    <AppearanceDebugContext.Provider
      value={{
        act,
        mapRefHover,
        mapRefSelected,
        planeToText,
        layerToText,
        flagsToText,
        visToText,
        blendToText,
        appsProcessed,
        zoomToX,
        setZoomToX,
        zoomToY,
        setZoomToY,
      }}
    >
      <Window
        width={1600}
        height={840}
        title={`OverFlayer${mainAppearance.name || mainAppearance.icon_state ? `: ${mainAppearance.name || mainAppearance.icon_state}` : ''}${updateWarning ? ' (Out of date)' : ''}`}
        buttons={
          <Stack fill>
            <Stack.Item
              width={`${
                Math.max(
                  90,
                  textWidth(
                    Object.keys(planeToText)
                      .sort((a, b) => a.length - b.length)
                      .pop() as string,
                    'Verdana, Geneva',
                    12,
                  ),
                ) + 40
              }px`}
            >
              <Dropdown
                options={Object.keys(planeToText).sort(
                  (a, b) => planeToText[a] - planeToText[b],
                )}
                placeholder="Filter by Plane"
                selected={planeFilter || ''}
                searchInput
                onSelected={(value) => {
                  setSelection(null);
                  if (!(value in planeToText)) setPlaneFilter(null);
                  setPlaneFilter(value);
                }}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                color={hideEmissives ? 'green' : 'transparent'}
                tooltip="Hide Emissives"
                icon="ban"
                selected={hideEmissives}
                onClick={() => {
                  setSelection(null);
                  setHideEmissives(!hideEmissives);
                }}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                color="transparent"
                tooltip="Refresh Appearance"
                icon="arrows-rotate"
                onClick={() => act('refreshAppearance')}
              />
            </Stack.Item>
          </Stack>
        }
      >
        <Window.Content
          style={{
            backgroundImage: 'none',
          }}
        >
          <Box
            className="Tooltip"
            position="absolute"
            left="12px"
            top="42px"
            width="172px"
            height="227px"
            pl="6px"
            pr="6px"
            style={{ zIndex: 3 }}
          >
            <ByondUi
              width="160px"
              height="160px"
              position="absolute"
              top="6px"
              left="6px"
              params={{
                id: mapRefHover,
                type: 'map',
              }}
            />
          </Box>
          <Box
            position="absolute"
            left="18px"
            top="214px"
            style={{ zIndex: 4 }}
          >
            <Stack vertical width="160px">
              <Stack.Item style={{ display: 'flex', flexDirection: 'row' }}>
                <Dropdown
                  options={Object.keys(planeToText).sort(
                    (a, b) => planeToText[a] - planeToText[b],
                  )}
                  placeholder="Set Forced Plane"
                  selected={
                    Object.keys(planeToText).findLast(
                      (x) => planeToText[x] === forcedPlane,
                    ) || ''
                  }
                  searchInput
                  onSelected={(value) => {
                    if (!(value in planeToText)) act('resetForcedPlane');
                    act('setForcedPlane', { plane: planeToText[value] });
                  }}
                  width=""
                />
                <Button
                  tooltip="Reset forced plane"
                  icon="times"
                  color="red"
                  disabled={!forcedPlane}
                  onClick={() => act('resetForcedPlane')}
                  ml={0.5}
                  width="22px"
                  height="20px"
                />
              </Stack.Item>
              <Stack.Item>
                <ColorBox color={backdropColor} mr={0.5} />
                <Input
                  value={backdropColor}
                  onBlur={(value) => {
                    if (!value) act('setBackdropColor', { reset: true });
                    act('setBackdropColor', { backdropColor: value });
                  }}
                  onDoubleClick={() => act('pickBackdropColor')}
                />
              </Stack.Item>
            </Stack>
          </Box>
          <InfinitePlane
            width="100%"
            height="100%"
            backgroundImage={resolveAsset('grid_background.png')}
            imageWidth={900}
            initialLeft={500}
            initialTop={-1350}
            zoomPadding={selection !== null ? 400 : 0}
            zoomToX={-(zoomToX || 0) + 525}
            zoomToY={-(zoomToY || 0) + 300}
          >
            {Object.entries(appsProcessed)
              .filter((keyValue) => keyValue[1].hidden !== HiddenState.Hidden)
              .map((keyValue) => (
                <AppearanceBox
                  key={keyValue[0]}
                  appearance={keyValue[1]}
                  position={mapPosition(keyValue[1], appearancePositions)}
                  onClick={(event) => {
                    setSelection(keyValue[1].data.id);
                    act('swapMapViewSelected', { id: keyValue[1].data.id });
                  }}
                />
              ))}
            <Connections connections={connections} />
          </InfinitePlane>
          {!!(selection !== null) && (
            <AppearanceInfo
              appearance={
                Object.values(appsProcessed).find(
                  (x) => x.data.id === selection,
                ) as Appearance
              }
              onClose={() => setSelection(null)}
            />
          )}
        </Window.Content>
      </Window>
    </AppearanceDebugContext.Provider>
  );
}
