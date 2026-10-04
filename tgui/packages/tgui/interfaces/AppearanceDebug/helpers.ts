import type { Coordinates } from '../common/Connections';
import type { Appearance, AppearanceData, AppearanceMap } from './types';
import {
  APPEARANCE_FLAGS,
  AppearanceParentType,
  AppearanceType,
  HiddenState,
  VIS_FLAGS,
} from './types';

export function textWidth(text: string, font: string, fontsize: number) {
  font = `${fontsize}px ${font}`;
  const c = document.createElement('canvas');
  const ctx = c.getContext('2d') as CanvasRenderingContext2D;
  ctx.font = font;
  return ctx.measureText(text).width;
}

export function mapAppearance(
  appearance_data: AppearanceData,
  parent: Appearance | null = null,
  parentType: AppearanceParentType = AppearanceParentType.None,
  depth: number = 0,
  appearances: AppearanceMap = {},
  planeFilter: number | null,
  hideEmissives: boolean,
  keepTogether: boolean,
) {
  if (appearance_data.flags & APPEARANCE_FLAGS.KEEP_APART) keepTogether = false;

  const appearance: Appearance = {
    data: appearance_data,
    underlays: null,
    overlays: null,
    parent: parent,
    hidden: HiddenState.Visible,
    boundingBox: [
      { x: 0, y: 0 },
      { x: 0, y: 0 },
    ],
    parentType: parentType,
    renderTargetTo: null,
    relativePosition: { x: 0, y: 0 },
    depth: depth,
    inherited_icon: !!(
      (appearance_data.vis_flags || 0) & VIS_FLAGS.VIS_INHERIT_ICON
    ),
    inherited_icon_state: !!(
      (appearance_data.vis_flags || 0) & VIS_FLAGS.VIS_INHERIT_ICON_STATE
    ),
    inherited_layer: !!(
      (appearance_data.vis_flags || 0) & VIS_FLAGS.VIS_INHERIT_LAYER
    ),
    inherited_plane: !!(
      (appearance_data.vis_flags || 0) & VIS_FLAGS.VIS_INHERIT_PLANE
    ),
    inherited_dir:
      !!((appearance_data.vis_flags || 0) & VIS_FLAGS.VIS_INHERIT_DIR) ||
      keepTogether,
    total_alpha:
      (appearance_data.flags & APPEARANCE_FLAGS.RESET_ALPHA && !keepTogether) ||
      !parent
        ? appearance_data.alpha
        : appearance_data.alpha * (parent.total_alpha / 255),
  };
  if (
    hideEmissives &&
    (isEmissive(appearance) || isEmissiveBlocker(appearance))
  )
    appearance.hidden = HiddenState.Hidden;
  else if (planeFilter !== null && appearance.data.plane_true !== planeFilter)
    appearance.hidden = HiddenState.Hidden;
  appearances[appearance_data.id] = appearance;
  let underlays = appearance_data.underlays;
  if (appearance_data.vis_contents)
    underlays = underlays.concat(
      appearance_data.vis_contents.filter(
        (x) => x.vis_flags && x.vis_flags & VIS_FLAGS.VIS_UNDERLAY,
      ),
    );
  if (underlays.length > 0) {
    appearance.underlays = underlays
      .map((data) =>
        mapAppearance(
          data,
          appearance,
          AppearanceParentType.Underlay,
          depth + 1,
          appearances,
          planeFilter,
          hideEmissives,
          keepTogether ||
            !!(appearance.data.flags & APPEARANCE_FLAGS.KEEP_TOGETHER),
        ),
      )
      .sort((a, b) =>
        a.data.plane === b.data.plane
          ? a.data.layer - b.data.layer
          : a.data.plane - b.data.plane,
      );
    if (
      appearance.hidden === HiddenState.Hidden &&
      appearance.underlays.filter((x) => x.hidden !== HiddenState.Hidden)
        .length > 0
    )
      appearance.hidden = HiddenState.VisibleChild;
  }
  let overlays = appearance_data.overlays;
  if (appearance_data.vis_contents)
    overlays = overlays.concat(
      appearance_data.vis_contents.filter(
        (x) => !x.vis_flags || !(x.vis_flags & VIS_FLAGS.VIS_UNDERLAY),
      ),
    );
  if (overlays.length > 0) {
    appearance.overlays = overlays
      .map((data) =>
        mapAppearance(
          data,
          appearance,
          AppearanceParentType.Overlay,
          depth + 1,
          appearances,
          planeFilter,
          hideEmissives,
          keepTogether ||
            !!(appearance.data.flags & APPEARANCE_FLAGS.KEEP_TOGETHER),
        ),
      )
      // vis_contents get priority by layer over overlays, but not by plane
      .sort((a, b) =>
        a.data.plane === b.data.plane
          ? a.data.type === AppearanceType.Atom &&
            b.data.type !== AppearanceType.Atom
            ? 1
            : a.data.type !== AppearanceType.Atom &&
                b.data.type === AppearanceType.Atom
              ? -1
              : a.data.layer - b.data.layer
          : a.data.plane - b.data.plane,
      );
    if (
      appearance.hidden === HiddenState.Hidden &&
      appearance.overlays.filter((x) => x.hidden !== HiddenState.Hidden)
        .length > 0
    )
      appearance.hidden = HiddenState.VisibleChild;
  }
  return appearance;
}

export function getAppearanceHeight(appearance: Appearance) {
  const TITLEBAR = 27;
  const COLUMN_BREAK = 20;
  let rows = 0;
  if (appearance.data.icon) rows++;
  if (appearance.data.icon_state) rows++;
  if (appearance.data.layer) rows++;
  if (appearance.data.plane) rows++;
  let height = COLUMN_BREAK + TITLEBAR + rows * 15 + (rows - 1) * 6 - 8;
  if (appearance.data.embed_icon) height += 64 + 6;
  return height;
}

export function isEmissive(appearance: Appearance) {
  const EMISSIVE_PLANE = 13;
  // Emissives are always constant color matrixes
  if (
    appearance.data.plane_true !== EMISSIVE_PLANE ||
    !Array.isArray(appearance.data.color)
  )
    return false;
  const colorMatrix = appearance.data.color as number[];
  for (let i = 0; i < colorMatrix.length; i++) {
    if (i === 15 && colorMatrix[i] !== 1) return false;
    else if (colorMatrix[i] !== 0 && (i < 15 || i > 18)) return false;
  }
  return true;
}

export function isEmissiveBlocker(appearance: Appearance) {
  const EMISSIVE_PLANE = 13;
  // Emissive blockers can be a constant matrix or pure black
  if (appearance.data.plane_true !== EMISSIVE_PLANE || !appearance.data.color)
    return false;
  if (appearance.data.color === '#000000') return true;
  if (!Array.isArray(appearance.data.color)) return false;
  const colorMatrix = appearance.data.color as number[];
  for (let i = 0; i < colorMatrix.length; i++) {
    if (colorMatrix[i] !== 0 && i !== 15) return false;
  }
  return true;
}

export function getAppearanceWidth(
  appearance: Appearance,
  layerToText: Record<string, number>,
  planeToText: Record<string, number>,
) {
  return Math.max(
    textWidth(
      (appearance.data.name || appearance.data.icon_state) +
        (isEmissive(appearance)
          ? ' (Emissive)'
          : isEmissiveBlocker(appearance)
            ? ' (Emissive Blocker)'
            : ''),
      'Verdana, Geneva',
      12,
    ) + 18,
    textWidth(`icon: ${appearance.data.icon}`, 'Verdana, Geneva', 12) + 12,
    textWidth(
      `icon_state: ${appearance.data.icon_state}`,
      'Verdana, Geneva',
      12,
    ) + 12,
    layerToText &&
      textWidth(
        `layer: ${getReadableLayer(appearance, layerToText)}`,
        'Verdana, Geneva',
        12,
      ) + 12,
    planeToText &&
      textWidth(
        `plane: ${getReadablePlane(appearance, planeToText)}`,
        'Verdana, Geneva',
        12,
      ) + 12,
    150,
  );
}

export function getReadableLayer(
  appearance: Appearance,
  layerToText: Record<string, number>,
) {
  return (
    (appearance.data.layer_text_override ||
      Object.keys(layerToText).find(
        (x) => layerToText[x] === appearance.data.layer,
      ) ||
      '') + (appearance.data.layer !== -1 ? ` (${appearance.data.layer})` : '')
  );
}

export function getReadablePlane(
  appearance: Appearance,
  planeToText: Record<string, number>,
) {
  return (
    (Object.keys(planeToText).find(
      (x) => planeToText[x] === appearance.data.plane_true,
    ) || appearance.data.plane_true.toString()) +
    (appearance.data.plane !== -32767 ? ` (${appearance.data.plane})` : '')
  );
}

export function parseAppearanceData(
  mainAppearance: AppearanceData,
  layerToText: Record<string, number>,
  planeToText: Record<string, number>,
  planeFilter: number | null,
  hideEmissives: boolean,
) {
  const appearances: AppearanceMap = {};
  // Recursively map all appearances
  const primary: Appearance = mapAppearance(
    mainAppearance,
    null,
    AppearanceParentType.None,
    0,
    appearances,
    planeFilter,
    hideEmissives,
    !!(mainAppearance.flags & APPEARANCE_FLAGS.KEEP_TOGETHER),
  );

  const sourceMap: Record<string, Appearance> = {};
  Object.values(appearances).forEach((element) => {
    if (element.data.render_target)
      sourceMap[element.data.render_target] = element;
  });

  Object.values(appearances).forEach((element) => {
    if (element.data.render_source && element.data.render_source in sourceMap) {
      if (sourceMap[element.data.render_source].renderTargetTo === null)
        sourceMap[element.data.render_source].renderTargetTo = [];
      sourceMap[element.data.render_source].renderTargetTo?.push(element);
    }
  });

  const STACK_COLUMN_GAP = 60;
  const KEEP_APART_TOGETHER_GAP = 18;
  const KEEP_APART_TOGETHER_GAP_TOP = 30;

  // Returns a *relative* bounding box, includes KEEP_TOGETHER/APART borders!
  function getBoundingBox(appearance: Appearance): [Coordinates, Coordinates] {
    let minX = 0;
    let minY = 0;
    let maxX = getAppearanceWidth(appearance, layerToText, planeToText);
    let maxY = getAppearanceHeight(appearance);

    if (appearance.underlays) {
      for (let i = 0; i < appearance.underlays.length; i++) {
        const underlay = appearance.underlays[i];
        if (underlay.hidden === HiddenState.Hidden) continue;
        const underlayBox = getBoundingBox(underlay);
        minX = Math.min(minX, underlayBox[0].x + underlay.relativePosition.x);
        minY = Math.min(minY, underlayBox[0].y + underlay.relativePosition.y);
        // Shouldn't happen with maxX but just in case
        maxX = Math.max(maxX, underlayBox[1].x + underlay.relativePosition.x);
        maxY = Math.max(maxY, underlayBox[1].y + underlay.relativePosition.y);
      }
    }

    if (appearance.overlays) {
      for (let i = 0; i < appearance.overlays.length; i++) {
        const overlay = appearance.overlays[i];
        if (overlay.hidden === HiddenState.Hidden) continue;
        const overlayBox = getBoundingBox(overlay);
        minX = Math.min(minX, overlayBox[0].x + overlay.relativePosition.x);
        minY = Math.min(minY, overlayBox[0].y + overlay.relativePosition.y);
        // Shouldn't happen with maxX but just in case
        maxX = Math.max(maxX, overlayBox[1].x + overlay.relativePosition.x);
        maxY = Math.max(maxY, overlayBox[1].y + overlay.relativePosition.y);
      }
    }

    if (
      appearance.data.flags &
      (APPEARANCE_FLAGS.KEEP_TOGETHER | APPEARANCE_FLAGS.KEEP_APART)
    ) {
      minX -= KEEP_APART_TOGETHER_GAP;
      minY -= KEEP_APART_TOGETHER_GAP_TOP;
      maxX += KEEP_APART_TOGETHER_GAP;
      maxY += KEEP_APART_TOGETHER_GAP;
    }

    return [
      { x: minX, y: minY },
      { x: maxX, y: maxY },
    ];
  }

  // By recursing through our children we can have them position their
  // children's relative positions, and then position them based on said
  // children's positions and bounding boxes when going back
  function positionChildren(appearance: Appearance) {
    const VERTICAL_APPEARANCE_GAP = 15;
    const CENTRAL_APPEARANCE_GAP = 30;

    if (appearance.overlays) {
      let minHeight =
        -getAppearanceHeight(appearance) / 2 + CENTRAL_APPEARANCE_GAP / 2;
      let totalOverlayHeight = 0;
      for (let i = 0; i < appearance.overlays.length; i++) {
        const overlay = appearance.overlays[i];
        if (overlay.hidden === HiddenState.Hidden) continue;
        positionChildren(overlay);
        const overlayBounds = getBoundingBox(overlay);
        overlay.boundingBox = overlayBounds;
        overlay.relativePosition.x =
          -STACK_COLUMN_GAP -
          getAppearanceWidth(overlay, layerToText, planeToText);
        overlay.relativePosition.y = -minHeight - overlayBounds[1].y;
        const totalHeight =
          overlayBounds[1].y - overlayBounds[0].y + VERTICAL_APPEARANCE_GAP;
        minHeight += totalHeight;
        totalOverlayHeight += totalHeight;
      }
      // If we don't have any underlays, shift all overlays down
      if (
        !appearance.underlays?.filter((x) => x.hidden !== HiddenState.Hidden)
          .length
      ) {
        const staticShift =
          CENTRAL_APPEARANCE_GAP / 2 +
          (totalOverlayHeight - VERTICAL_APPEARANCE_GAP) / 2;
        for (let i = 0; i < appearance.overlays.length; i++) {
          appearance.overlays[i].relativePosition.y += staticShift;
        }
      }
    }

    if (appearance.underlays) {
      let minHeight =
        getAppearanceHeight(appearance) / 2 - CENTRAL_APPEARANCE_GAP / 2;
      let totalUnderlayHeight = 0;
      for (let i = 0; i < appearance.underlays.length; i++) {
        const underlay = appearance.underlays[i];
        if (underlay.hidden === HiddenState.Hidden) continue;
        positionChildren(underlay);
        const underlayBounds = getBoundingBox(underlay);
        underlay.boundingBox = underlayBounds;
        underlay.relativePosition.x =
          -STACK_COLUMN_GAP -
          getAppearanceWidth(underlay, layerToText, planeToText);
        underlay.relativePosition.y = minHeight + getAppearanceHeight(underlay);
        const totalHeight =
          underlayBounds[1].y - underlayBounds[0].y + VERTICAL_APPEARANCE_GAP;
        minHeight += totalHeight;
        totalUnderlayHeight += totalHeight;
      }
      // If we don't have any overlays, shift all underlays up
      if (
        !appearance.overlays?.filter((x) => x.hidden !== HiddenState.Hidden)
          .length
      ) {
        const staticShift =
          CENTRAL_APPEARANCE_GAP / 2 +
          (totalUnderlayHeight - VERTICAL_APPEARANCE_GAP) / 2;
        for (let i = 0; i < appearance.underlays.length; i++) {
          appearance.underlays[i].relativePosition.y -= staticShift;
        }
      }
    }
  }

  positionChildren(primary);
  primary.boundingBox = getBoundingBox(primary);
  return appearances;
}
