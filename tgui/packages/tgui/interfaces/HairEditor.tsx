import { useEffect, useRef, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, Section, Stack } from 'tgui-core/components';

type DirButton = {
  dir: number;
  label: string;
  edited: boolean;
};

type DirGuide = {
  dir: number;
  label: string;
  icon: string | null;
  editMinX: number;
  editMaxX: number;
  editMinY: number;
  editMaxY: number;
};

type MaskLayer = {
  color: string;
  mask: string | null;
};

type PlotPoint = {
  x: number;
  y: number;
};

type PaletteEntry = {
  label: string;
  color: string;
};

type HairEditorData = {
  ready: boolean;
  activeDir: number;
  activeLabel: string;
  baseColor: string;
  palette: PaletteEntry[];
  paintColor: string;
  activeGuideIcon: string | null;
  activeColorMasks: MaskLayer[];
  directions: DirButton[];
  directionIcons: DirGuide[];
};

const CELL_COUNT = 32;
const CANVAS_SIZE = 32;
const BACKGROUND = '#241b18';

const iconSrc = (icon?: string | null) => {
  if (!icon) {
    return null;
  }
  if (/^(data:|https?:|asset\.|namespaces\/|\.\/|\/)/.test(icon)) {
    return icon;
  }
  return `data:image/png;base64,${icon}`;
};

const maskChars = (mask: string | null | undefined) =>
  (mask && mask.length === 256 ? mask : '0'.repeat(256)).split('');

const setMaskCharsBit = (
  chars: string[],
  pixelX: number,
  pixelY: number,
  state: boolean,
) => {
  const pixelIndex = (pixelY - 1) * CELL_COUNT + (pixelX - 1);
  const hexIndex = Math.floor(pixelIndex / 4);
  const bit = 1 << (pixelIndex & 3);
  const nibble = Number.parseInt(chars[hexIndex] || '0', 16) || 0;
  const nextNibble = state ? nibble | bit : nibble & ~bit;
  if (nextNibble === nibble) {
    return false;
  }
  chars[hexIndex] = nextNibble.toString(16);
  return true;
};

const maskCharsHaveBits = (chars: string[]) => {
  for (const char of chars) {
    if (char !== '0') {
      return true;
    }
  }
  return false;
};

const rgbToHex = (red: number, green: number, blue: number) =>
  `#${[red, green, blue].map((value) => value.toString(16).padStart(2, '0')).join('')}`;

const clampChannel = (value: number) =>
  Math.max(0, Math.min(255, Math.round(value)));

const mixColour = (colour: string, target: number, amount: number) => {
  const match = /^#?([\da-f]{2})([\da-f]{2})([\da-f]{2})$/i.exec(colour);
  if (!match) {
    return colour;
  }

  const channels = match
    .slice(1)
    .map((channel) => Number.parseInt(channel, 16));
  return rgbToHex(
    clampChannel(channels[0] + (target - channels[0]) * amount),
    clampChannel(channels[1] + (target - channels[1]) * amount),
    clampChannel(channels[2] + (target - channels[2]) * amount),
  );
};

const lighten = (colour: string, amount = 0.25) =>
  mixColour(colour, 255, amount);

const darken = (colour: string, amount = 0.25) => mixColour(colour, 0, amount);

const colourDistance = (left: string, right: string) => {
  const leftMatch = /^#?([\da-f]{2})([\da-f]{2})([\da-f]{2})$/i.exec(left);
  const rightMatch = /^#?([\da-f]{2})([\da-f]{2})([\da-f]{2})$/i.exec(right);
  if (!leftMatch || !rightMatch) {
    return Number.MAX_SAFE_INTEGER;
  }

  const leftChannels = leftMatch
    .slice(1)
    .map((channel) => Number.parseInt(channel, 16));
  const rightChannels = rightMatch
    .slice(1)
    .map((channel) => Number.parseInt(channel, 16));
  return leftChannels.reduce((score, channel, index) => {
    const delta = channel - rightChannels[index];
    return score + delta * delta;
  }, 0);
};

const pixelIndex = (pixelX: number, pixelY: number) =>
  (pixelY - 1) * CELL_COUNT + (pixelX - 1);

const linePoints = (start: PlotPoint | null, end: PlotPoint) => {
  if (!start) {
    return [end];
  }

  const points: PlotPoint[] = [];
  let x = start.x;
  let y = start.y;
  const stepX = x < end.x ? 1 : -1;
  const stepY = y < end.y ? 1 : -1;
  const deltaX = Math.abs(end.x - x);
  const deltaY = Math.abs(end.y - y);
  let error = deltaX - deltaY;

  while (true) {
    points.push({ x, y });
    if (x === end.x && y === end.y) {
      break;
    }

    const doubled = error * 2;
    if (doubled > -deltaY) {
      error -= deltaY;
      x += stepX;
    }
    if (doubled < deltaX) {
      error += deltaX;
      y += stepY;
    }
  }

  return points;
};

const clampPlotPoint = (
  point: PlotPoint,
  minX: number,
  maxX: number,
  minY: number,
  maxY: number,
): PlotPoint => ({
  x: Math.max(minX, Math.min(maxX, point.x)),
  y: Math.max(minY, Math.min(maxY, point.y)),
});

const cloneMaskLayers = (layers: MaskLayer[]) =>
  layers.map((layer) => ({ ...layer }));

const sortMaskLayers = (layers: MaskLayer[]) =>
  [...layers].sort((left, right) => left.color.localeCompare(right.color));

const maskLayersKey = (layers: MaskLayer[]) =>
  sortMaskLayers(layers)
    .map((layer) => `${layer.color.toLowerCase()}:${layer.mask || ''}`)
    .join('|');

const forEachMaskBitInRange = (
  mask: string | null | undefined,
  editMinX: number,
  editMaxX: number,
  editMinY: number,
  editMaxY: number,
  visit: (pixelX: number, pixelY: number) => void,
) => {
  if (mask?.length !== 256) {
    return;
  }

  for (let pixelY = editMinY; pixelY <= editMaxY; pixelY++) {
    const rowHexIndex = (pixelY - 1) * 8;
    let pixelX = 1;

    for (let hexOffset = 0; hexOffset < 8; hexOffset++) {
      const nibble = Number.parseInt(mask.charAt(rowHexIndex + hexOffset), 16);
      if (!nibble) {
        pixelX += 4;
        continue;
      }

      for (let bitIndex = 0; bitIndex < 4; bitIndex++) {
        const currentX = pixelX + bitIndex;
        if (currentX < editMinX || currentX > editMaxX) {
          continue;
        }
        if (nibble & (1 << bitIndex)) {
          visit(currentX, pixelY);
        }
      }

      pixelX += 4;
    }
  }
};

const buildOccupancy = (
  layers: MaskLayer[],
  editMinX: number,
  editMaxX: number,
  editMinY: number,
  editMaxY: number,
) => {
  const occupancy = new Map<number, string>();
  for (const layer of layers) {
    if (!layer.mask) {
      continue;
    }
    const colour = layer.color.toLowerCase();
    forEachMaskBitInRange(
      layer.mask,
      editMinX,
      editMaxX,
      editMinY,
      editMaxY,
      (pixelX, pixelY) => {
        occupancy.set(pixelIndex(pixelX, pixelY), colour);
      },
    );
  }
  return occupancy;
};

const drawOverlay = (
  ctx: CanvasRenderingContext2D,
  layers: MaskLayer[],
  editMinX: number,
  editMaxX: number,
  editMaxY: number,
  cropWidth: number,
  bandHeight: number,
) => {
  ctx.clearRect(0, 0, cropWidth, bandHeight);
  for (const layer of layers) {
    if (!layer.mask) {
      continue;
    }
    ctx.fillStyle = layer.color;
    forEachMaskBitInRange(
      layer.mask,
      editMinX,
      editMaxX,
      editMaxY - bandHeight + 1,
      editMaxY,
      (pixelX, pixelY) => {
        ctx.fillRect(pixelX - editMinX, editMaxY - pixelY, 1, 1);
      },
    );
  }
};

const drawOverlayPixel = (
  ctx: CanvasRenderingContext2D,
  pixelX: number,
  pixelY: number,
  editMinX: number,
  editMaxY: number,
  color?: string,
) => {
  const drawX = pixelX - editMinX;
  const drawY = editMaxY - pixelY;
  ctx.clearRect(drawX, drawY, 1, 1);
  if (!color) {
    return;
  }
  ctx.fillStyle = color;
  ctx.fillRect(drawX, drawY, 1, 1);
};

export const HairEditor = () => {
  const { act, data } = useBackend<HairEditorData>();
  const {
    ready,
    activeDir,
    activeLabel,
    baseColor: _baseColour,
    palette = [],
    paintColor: paintColour,
    activeGuideIcon,
    activeColorMasks = [],
    directions = [],
    directionIcons = [],
  } = data;
  const guideCanvasRef = useRef<HTMLCanvasElement | null>(null);
  const overlayCanvasRef = useRef<HTMLCanvasElement | null>(null);
  const activeGuide =
    directionIcons.find((entry) => entry.dir === activeDir) ||
    directionIcons[0];
  const editMinX = activeGuide?.editMinX ?? 6;
  const editMaxX = activeGuide?.editMaxX ?? 27;
  const editMinY = activeGuide?.editMinY ?? 17;
  const editMaxY = activeGuide?.editMaxY ?? 32;
  const cropWidth = Math.max(1, editMaxX - editMinX + 1);
  const bandHeight = Math.max(1, editMaxY - editMinY + 1);
  const displayWidth = Math.round((256 * cropWidth) / CELL_COUNT);
  const displayHeight = Math.max(
    1,
    Math.round((displayWidth * bandHeight) / cropWidth),
  );
  const [maskLayers, setMaskLayers] = useState<MaskLayer[]>(activeColorMasks);
  const maskLayersRef = useRef<MaskLayer[]>(activeColorMasks);
  const occupancyRef = useRef<Map<number, string>>(
    buildOccupancy(activeColorMasks, editMinX, editMaxX, editMinY, editMaxY),
  );
  const strokeDirtyRef = useRef<boolean>(false);
  const pendingCommitRef = useRef<string | null>(null);
  const pendingCommitDirRef = useRef<number | null>(null);
  const pendingPointRef = useRef<PlotPoint | null>(null);
  const strokeFrameRef = useRef<number | null>(null);
  const lastPointRef = useRef<PlotPoint | null>(null);
  const strokeRef = useRef<{
    active: boolean;
    remove: boolean;
    dir: number;
    colour: string;
  }>({
    active: false,
    remove: false,
    dir: activeDir,
    colour: paintColour,
  });
  const [localPaintColour, setLocalPaintColour] = useState<string>(paintColour);
  const paletteSections = [
    {
      title: 'Base Hair',
      entries: palette.filter((entry) => entry.label.includes('Base Hair')),
    },
    {
      title: 'Natural Gradient',
      entries: palette.filter((entry) =>
        entry.label.includes('Natural Gradient'),
      ),
    },
    {
      title: 'Dye Gradient',
      entries: palette.filter((entry) => entry.label.includes('Dye Gradient')),
    },
  ].filter((section) => section.entries.length);
  const snapPaletteColour = (colour: string) => {
    if (!palette.length) {
      return colour;
    }
    let bestColour = palette[0].color;
    let bestScore = colourDistance(colour, bestColour);
    for (const entry of palette) {
      const score = colourDistance(colour, entry.color);
      if (score < bestScore) {
        bestColour = entry.color;
        bestScore = score;
      }
    }
    return bestColour;
  };

  const pickColour = (colour: string) => {
    const nextColour = snapPaletteColour(colour);
    setLocalPaintColour(nextColour);
    act('set_color', { color: nextColour });
  };

  const clearPendingCommit = () => {
    pendingCommitRef.current = null;
    pendingCommitDirRef.current = null;
  };

  const clearQueuedStrokePoint = () => {
    pendingPointRef.current = null;
    if (strokeFrameRef.current !== null) {
      cancelAnimationFrame(strokeFrameRef.current);
      strokeFrameRef.current = null;
    }
  };

  useEffect(() => {
    const incomingLayers = activeColorMasks;
    const incomingKey = maskLayersKey(incomingLayers);
    const pendingCommit = pendingCommitRef.current;

    if (pendingCommitDirRef.current !== activeDir) {
      clearPendingCommit();
    }

    if (
      pendingCommit &&
      pendingCommitDirRef.current === activeDir &&
      incomingKey !== pendingCommit
    ) {
      return;
    }

    clearPendingCommit();
    maskLayersRef.current = incomingLayers;
    occupancyRef.current = buildOccupancy(
      incomingLayers,
      editMinX,
      editMaxX,
      editMinY,
      editMaxY,
    );
    strokeDirtyRef.current = false;
    setMaskLayers(incomingLayers);
  }, [activeColorMasks, activeDir, editMinX, editMaxX, editMinY, editMaxY]);

  useEffect(() => {
    maskLayersRef.current = maskLayers;
  }, [maskLayers]);

  useEffect(() => {
    setLocalPaintColour(paintColour);
  }, [paintColour]);

  useEffect(() => {
    strokeRef.current.dir = activeDir;
    strokeRef.current.colour = localPaintColour;
  }, [activeDir, localPaintColour]);

  useEffect(() => {
    const canvas = guideCanvasRef.current;
    if (!canvas) {
      return;
    }
    const ctx = canvas.getContext('2d');
    if (!ctx) {
      return;
    }

    ctx.clearRect(0, 0, CANVAS_SIZE, bandHeight);
    ctx.fillStyle = BACKGROUND;
    ctx.fillRect(0, 0, CANVAS_SIZE, bandHeight);

    const drawGuide = (image?: HTMLImageElement | null) => {
      ctx.clearRect(0, 0, cropWidth, bandHeight);
      ctx.fillStyle = BACKGROUND;
      ctx.fillRect(0, 0, cropWidth, bandHeight);

      if (!image) {
        return;
      }

      const srcTop = CANVAS_SIZE - editMaxY;
      const srcBottom = CANVAS_SIZE - editMinY + 1;
      const srcHeight = Math.max(1, srcBottom - srcTop);
      ctx.drawImage(
        image,
        editMinX - 1,
        srcTop,
        cropWidth,
        srcHeight,
        0,
        0,
        cropWidth,
        srcHeight,
      );
    };

    const src = iconSrc(activeGuideIcon || activeGuide?.icon);
    if (!src) {
      drawGuide(null);
      return;
    }

    const image = new Image();
    image.onload = () => {
      drawGuide(image);
    };
    image.src = src;
  }, [
    activeGuide,
    activeGuideIcon,
    editMinX,
    editMaxY,
    editMinY,
    cropWidth,
    bandHeight,
  ]);

  useEffect(() => {
    const canvas = overlayCanvasRef.current;
    if (!canvas) {
      return;
    }
    const ctx = canvas.getContext('2d');
    if (!ctx) {
      return;
    }
    drawOverlay(
      ctx,
      maskLayers,
      editMinX,
      editMaxX,
      editMaxY,
      cropWidth,
      bandHeight,
    );
  }, [maskLayers, editMinX, editMaxX, editMaxY, cropWidth, bandHeight]);

  const flushStroke = () => {
    clearQueuedStrokePoint();
    strokeRef.current.active = false;
    lastPointRef.current = null;
    if (!strokeDirtyRef.current) {
      return;
    }

    strokeDirtyRef.current = false;
    const nextLayers = cloneMaskLayers(maskLayersRef.current);
    pendingCommitRef.current = maskLayersKey(nextLayers);
    pendingCommitDirRef.current = strokeRef.current.dir;
    setMaskLayers(nextLayers);
    act('plot_commit', {
      dir: strokeRef.current.dir,
      colorMasks: nextLayers,
    });
  };

  const getPlotPoint = (clientX: number, clientY: number): PlotPoint | null => {
    const canvas = overlayCanvasRef.current;
    if (!canvas) {
      return null;
    }
    const rect = canvas.getBoundingClientRect();
    const relX = clientX - rect.left;
    const relY = clientY - rect.top;
    const cellX = Math.max(
      0,
      Math.min(cropWidth - 1, Math.floor((relX / rect.width) * cropWidth)),
    );
    const bandRow = Math.max(
      0,
      Math.min(bandHeight - 1, Math.floor((relY / rect.height) * bandHeight)),
    );
    const y = editMaxY - bandRow;

    if (y < editMinY || y > editMaxY) {
      return null;
    }

    return {
      x: editMinX + cellX,
      y,
    };
  };

  const applyStrokePoints = (
    points: PlotPoint[],
    remove: boolean,
    colour: string,
  ) => {
    const layerMasks = new Map<string, { color: string; chars: string[] }>();
    for (const layer of maskLayersRef.current) {
      layerMasks.set(layer.color.toLowerCase(), {
        color: layer.color,
        chars: maskChars(layer.mask),
      });
    }
    const occupancy = occupancyRef.current;
    let changed = false;
    const nextColour = colour.toLowerCase();
    const overlayCtx = overlayCanvasRef.current?.getContext('2d');

    for (const point of points) {
      const key = pixelIndex(point.x, point.y);
      const currentColour = occupancy.get(key);
      if (remove && !currentColour) {
        continue;
      }

      if (!remove && currentColour === nextColour) {
        continue;
      }

      if (currentColour) {
        const currentLayer = layerMasks.get(currentColour);
        if (currentLayer) {
          setMaskCharsBit(currentLayer.chars, point.x, point.y, false);
        }
      }
      if (!remove) {
        let nextLayer = layerMasks.get(nextColour);
        if (!nextLayer) {
          nextLayer = { color: colour, chars: maskChars(null) };
          layerMasks.set(nextColour, nextLayer);
        }
        setMaskCharsBit(nextLayer.chars, point.x, point.y, true);
        occupancy.set(key, nextColour);
      } else {
        occupancy.delete(key);
      }
      if (overlayCtx) {
        drawOverlayPixel(
          overlayCtx,
          point.x,
          point.y,
          editMinX,
          editMaxY,
          remove ? undefined : colour,
        );
      }
      changed = true;
    }

    if (!changed) {
      return;
    }

    const nextLayers: MaskLayer[] = [];
    for (const layer of layerMasks.values()) {
      if (maskCharsHaveBits(layer.chars)) {
        nextLayers.push({ color: layer.color, mask: layer.chars.join('') });
      }
    }
    maskLayersRef.current = nextLayers;
    strokeDirtyRef.current = true;
  };

  const flushPendingStrokePoint = () => {
    const point = pendingPointRef.current;
    pendingPointRef.current = null;
    strokeFrameRef.current = null;
    if (!strokeRef.current.active || !point) {
      return;
    }
    const points = linePoints(lastPointRef.current, point);
    applyStrokePoints(
      points,
      strokeRef.current.remove,
      strokeRef.current.colour,
    );
    lastPointRef.current = point;
  };

  const queueStrokePoint = (point: PlotPoint) => {
    pendingPointRef.current = point;
    if (strokeFrameRef.current !== null) {
      return;
    }
    strokeFrameRef.current = requestAnimationFrame(() => {
      flushPendingStrokePoint();
    });
  };

  useEffect(() => {
    const onMouseMove = (event: MouseEvent) => {
      if (!strokeRef.current.active) {
        return;
      }
      const point = getPlotPoint(event.clientX, event.clientY);
      if (!point) {
        return;
      }
      queueStrokePoint(point);
    };

    const onMouseUp = () => {
      if (!strokeRef.current.active) {
        return;
      }
      flushPendingStrokePoint();
      flushStroke();
    };

    window.addEventListener('mousemove', onMouseMove);
    window.addEventListener('mouseup', onMouseUp);
    return () => {
      clearQueuedStrokePoint();
      window.removeEventListener('mousemove', onMouseMove);
      window.removeEventListener('mouseup', onMouseUp);
    };
  }, [editMinX, editMaxX, editMaxY, editMinY, cropWidth, bandHeight]);

  const sendPlot = (event: React.MouseEvent<HTMLCanvasElement>) => {
    event.preventDefault();
    event.stopPropagation();

    if (event.button !== 0 && event.button !== 2) {
      return;
    }

    if (event.altKey && event.button === 0) {
      const overlayCtx = overlayCanvasRef.current?.getContext('2d');
      const guideCtx = guideCanvasRef.current?.getContext('2d');
      const point = getPlotPoint(event.clientX, event.clientY);
      if (!point) {
        return;
      }
      const cellX = point.x - editMinX;
      const bandRow = editMaxY - point.y;
      if (overlayCtx) {
        const overlayPixel = overlayCtx.getImageData(cellX, bandRow, 1, 1).data;
        if (overlayPixel[3]) {
          pickColour(
            rgbToHex(overlayPixel[0], overlayPixel[1], overlayPixel[2]),
          );
          return;
        }
      }
      if (!guideCtx) {
        return;
      }
      const pixel = guideCtx.getImageData(cellX, bandRow, 1, 1).data;
      if (!pixel[3]) {
        return;
      }
      pickColour(rgbToHex(pixel[0], pixel[1], pixel[2]));
      return;
    }

    const point = getPlotPoint(event.clientX, event.clientY);
    if (!point) {
      return;
    }
    const remove = event.button === 2;
    strokeRef.current.active = true;
    strokeRef.current.remove = remove;
    strokeRef.current.dir = activeDir;
    strokeRef.current.colour = localPaintColour;
    strokeDirtyRef.current = false;
    clearQueuedStrokePoint();
    lastPointRef.current = point;
    applyStrokePoints([point], remove, localPaintColour);
  };

  if (!ready) {
    return (
      <Window title="Custom Hair" width={420} height={180}>
        <Window.Content>
          <Section fill>
            Hair customisation is unavailable for the current selection.
          </Section>
        </Window.Content>
      </Window>
    );
  }

  return (
    <Window title="Custom Hair" width={420} height={600}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Stack justify="space-between" align="center">
              <Stack.Item>
                <Section title="Editor">
                  SELECTED COLOUR:{' '}
                  <Box inline textColor={localPaintColour}>
                    {localPaintColour}
                  </Box>
                  {'  '}
                </Section>
              </Stack.Item>
              <Stack.Item>
                <Stack>
                  <Stack.Item>
                    <Button color="average" onClick={() => act('clear')}>
                      Reset Edits
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button color="good" onClick={() => act('close')}>
                      Done
                    </Button>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          </Stack.Item>

          <Stack.Item>
            <Section title="Palette">
              <Stack align="start">
                {paletteSections.map((section) => (
                  <Stack.Item key={section.title} basis="0" grow>
                    <Box mb={0.5}>{section.title}</Box>
                    <Stack wrap="wrap">
                      {section.entries.map((entry) => (
                        <Stack.Item key={entry.label}>
                          <Button
                            compact
                            selected={
                              entry.color.toLowerCase() ===
                              localPaintColour.toLowerCase()
                            }
                            onClick={() => pickColour(entry.color)}
                            tooltip={entry.label}
                          >
                            <Box
                              style={{
                                backgroundColor: entry.color,
                                border:
                                  entry.color.toLowerCase() ===
                                  localPaintColour.toLowerCase()
                                    ? '2px solid #f4ede2'
                                    : '1px solid rgba(0, 0, 0, 0.45)',
                                borderRadius: '4px',
                                height: '18px',
                                width: '18px',
                              }}
                            />
                          </Button>
                        </Stack.Item>
                      ))}
                    </Stack>
                  </Stack.Item>
                ))}
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Section title="Directions">
              <Stack>
                {directions.map((dir) => (
                  <Stack.Item key={dir.dir} basis="0" grow>
                    <Button
                      fluid
                      selected={dir.dir === activeDir}
                      color={dir.edited ? 'average' : 'transparent'}
                      onClick={() => act('set_dir', { dir: dir.dir })}
                    >
                      {dir.label}
                    </Button>
                  </Stack.Item>
                ))}
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item grow>
            <Section fill title={`${activeLabel} View`}>
              <Box
                style={{
                  width: `${displayWidth}px`,
                  height: `${displayHeight}px`,
                  position: 'relative',
                  border: '1px solid #4f3c31',
                  background: BACKGROUND,
                  margin: '0 auto',
                }}
              >
                <canvas
                  ref={guideCanvasRef}
                  width={cropWidth}
                  height={bandHeight}
                  style={{
                    width: `${displayWidth}px`,
                    height: `${displayHeight}px`,
                    imageRendering: 'pixelated',
                    display: 'block',
                    position: 'absolute',
                    inset: 0,
                  }}
                />
                <canvas
                  ref={overlayCanvasRef}
                  width={cropWidth}
                  height={bandHeight}
                  onMouseDown={sendPlot}
                  onContextMenu={(event) => {
                    event.preventDefault();
                    event.stopPropagation();
                  }}
                  onDragStart={(event) => event.preventDefault()}
                  style={{
                    width: `${displayWidth}px`,
                    height: `${displayHeight}px`,
                    imageRendering: 'pixelated',
                    cursor: 'crosshair',
                    display: 'block',
                    position: 'absolute',
                    inset: 0,
                    userSelect: 'none',
                  }}
                />
              </Box>
              <Box mt={1} textAlign="center" fontSize={0.9} textColor="#c7b8a1">
                LMB to add pixels (You can drag-click). Alt+LMB to pick colour.
                RMB to delete added pixels.
              </Box>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
