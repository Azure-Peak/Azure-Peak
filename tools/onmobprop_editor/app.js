const PROP_ORDER = [
  "shrink",
  "sx", "sy",
  "nx", "ny",
  "wx", "wy",
  "ex", "ey",
  "northabove", "southabove", "eastabove", "westabove",
  "nturn", "sturn", "wturn", "eturn",
  "nflip", "sflip", "wflip", "eflip",
];

const DIRECTION_CONFIG = [
  { key: "north", label: "North", aboveKey: "northabove", turnKey: "nturn", flipKey: "nflip", xKey: "nx", yKey: "ny" },
  { key: "south", label: "South", aboveKey: "southabove", turnKey: "sturn", flipKey: "sflip", xKey: "sx", yKey: "sy" },
  { key: "east", label: "East", aboveKey: "eastabove", turnKey: "eturn", flipKey: "eflip", xKey: "ex", yKey: "ey" },
  { key: "west", label: "West", aboveKey: "westabove", turnKey: "wturn", flipKey: "wflip", xKey: "wx", yKey: "wy" },
];

const BYOND_DIR = {
  NORTH: 1,
  SOUTH: 2,
  EAST: 4,
  WEST: 8,
};

const HELPER_MASK_SOURCES = {
  32: "./assets/inhand.dmi",
  64: "./assets/inhand_64.dmi",
};

const GENERIC_MOB_SOURCES = Object.freeze({
  south: "./assets/guide_body_south.png",
  north: "./assets/guide_body_north.png",
  east: "./assets/guide_body_east.png",
  west: "./assets/guide_body_west.png",
});
const DEFAULT_PREVIEW_HAND_OFFSET_X = 0;
const DEFAULT_PREVIEW_HAND_OFFSET_Y = 1;

const ZERO_PROP = Object.freeze({
  shrink: 0,
  sx: 0,
  sy: 0,
  nx: 0,
  ny: 0,
  wx: 0,
  wy: 0,
  ex: 0,
  ey: 0,
  northabove: 0,
  southabove: 0,
  eastabove: 0,
  westabove: 0,
  nturn: 0,
  sturn: 0,
  wturn: 0,
  eturn: 0,
  nflip: 0,
  sflip: 0,
  wflip: 0,
  eflip: 0,
});

const DEFAULT_CUSTOM_PROP = Object.freeze({
  ...ZERO_PROP,
  shrink: 1,
  northabove: 1,
  southabove: 1,
  eastabove: 1,
  westabove: 1,
});

const PROP_PRESETS = {
  custom: null,
  item: {
    gen: { shrink: 0.4, sx: -7, sy: -4, nx: 7, ny: -4, wx: -4, wy: -4, ex: 2, ey: -4, nturn: 0, sturn: 0, wturn: 0, eturn: 0, nflip: 0, sflip: 0, wflip: 0, eflip: 0, northabove: 0, southabove: 1, eastabove: 1, westabove: 0 },
  },
  sword: {
    gen: { shrink: 0.6, sx: -10, sy: -8, nx: 13, ny: -8, wx: -8, wy: -7, ex: 7, ey: -8, northabove: 0, southabove: 1, eastabove: 1, westabove: 0, nturn: 90, sturn: -90, wturn: -80, eturn: 81, nflip: 0, sflip: 8, wflip: 8, eflip: 0 },
    wielded: { shrink: 0.7, sx: 5, sy: -2, nx: -6, ny: -2, wx: -6, wy: -2, ex: 7, ey: -2, northabove: 0, southabove: 1, eastabove: 1, westabove: 0, nturn: -28, sturn: 29, wturn: -35, eturn: 32, nflip: 8, sflip: 0, wflip: 8, eflip: 0 },
  },
  longsword: {
    gen: { shrink: 0.5, sx: -14, sy: -8, nx: 15, ny: -7, wx: -10, wy: -5, ex: 7, ey: -6, northabove: 0, southabove: 1, eastabove: 1, westabove: 0, nturn: -13, sturn: 110, wturn: -60, eturn: -30, nflip: 1, sflip: 1, wflip: 8, eflip: 1 },
    wielded: { shrink: 0.6, sx: 9, sy: -4, nx: -7, ny: 1, wx: -9, wy: 2, ex: 10, ey: 2, northabove: 0, southabove: 1, eastabove: 1, westabove: 0, nturn: 5, sturn: -190, wturn: -170, eturn: -10, nflip: 8, sflip: 8, wflip: 1, eflip: 0 },
  },
  greatsword: {
    gen: { shrink: 0.6, sx: -6, sy: 6, nx: 6, ny: 7, wx: 0, wy: 5, ex: -1, ey: 7, northabove: 0, southabove: 1, eastabove: 1, westabove: 0, nturn: -50, sturn: 40, wturn: 50, eturn: -50, nflip: 0, sflip: 8, wflip: 8, eflip: 0 },
    wielded: { shrink: 0.6, sx: 9, sy: -4, nx: -7, ny: 1, wx: -9, wy: 2, ex: 10, ey: 2, northabove: 0, southabove: 1, eastabove: 1, westabove: 0, nturn: 5, sturn: -190, wturn: -170, eturn: -10, nflip: 8, sflip: 8, wflip: 1, eflip: 0 },
  },
  woodstaff: {
    gen: { shrink: 0.6, sx: -6, sy: -1, nx: 8, ny: 0, wx: -4, wy: 0, ex: 2, ey: 1, northabove: 0, southabove: 1, eastabove: 1, westabove: 0, nturn: -38, sturn: 37, wturn: 32, eturn: -23, nflip: 0, sflip: 8, wflip: 8, eflip: 0 },
    wielded: { shrink: 0.6, sx: 4, sy: -2, nx: -3, ny: -2, wx: -5, wy: -1, ex: 3, ey: -2, northabove: 0, southabove: 1, eastabove: 1, westabove: 0, nturn: 7, sturn: -7, wturn: 16, eturn: -22, nflip: 8, sflip: 0, wflip: 8, eflip: 0 },
  },
  polearm: {
    gen: { shrink: 0.6, sx: -7, sy: 2, nx: 7, ny: 3, wx: -2, wy: 1, ex: 1, ey: 1, northabove: 0, southabove: 1, eastabove: 1, westabove: 0, nturn: -38, sturn: 37, wturn: 30, eturn: -30, nflip: 0, sflip: 8, wflip: 8, eflip: 0 },
    wielded: { shrink: 0.6, sx: 5, sy: -3, nx: -5, ny: -2, wx: -5, wy: -1, ex: 3, ey: -2, northabove: 0, southabove: 1, eastabove: 1, westabove: 0, nturn: 7, sturn: -7, wturn: 16, eturn: -22, nflip: 8, sflip: 0, wflip: 8, eflip: 0 },
  },
  axe: {
    gen: { shrink: 0.6, sx: -11, sy: -8, nx: 12, ny: -8, wx: -5, wy: -8, ex: 6, ey: -8, northabove: 0, southabove: 1, eastabove: 1, westabove: 0, nturn: 90, sturn: -90, wturn: -90, eturn: 90, nflip: 0, sflip: 8, wflip: 8, eflip: 0 },
    wielded: { shrink: 0.7, sx: 5, sy: -4, nx: -5, ny: -4, wx: -5, wy: -3, ex: 7, ey: -4, northabove: 0, southabove: 1, eastabove: 1, westabove: 0, nturn: -45, sturn: 45, wturn: -45, eturn: 45, nflip: 8, sflip: 0, wflip: 8, eflip: 0 },
  },
  dagger: {
    gen: { shrink: 0.4, sx: -10, sy: 0, nx: 11, ny: 0, wx: -4, wy: 0, ex: 2, ey: 0, northabove: 0, southabove: 1, eastabove: 1, westabove: 0, nturn: 0, sturn: 0, wturn: 0, eturn: 0, nflip: 0, sflip: 8, wflip: 8, eflip: 0 },
  },
  blunt: {
    gen: { shrink: 0.5, sx: -11, sy: -8, nx: 12, ny: -8, wx: -5, wy: -8, ex: 6, ey: -8, northabove: 0, southabove: 1, eastabove: 1, westabove: 0, nturn: 90, sturn: -90, wturn: -90, eturn: 90, nflip: 0, sflip: 8, wflip: 8, eflip: 0 },
    wielded: { shrink: 0.7, sx: 5, sy: -4, nx: -5, ny: -4, wx: -5, wy: -3, ex: 7, ey: -4, northabove: 0, southabove: 1, eastabove: 1, westabove: 0, nturn: -45, sturn: 45, wturn: -45, eturn: 45, nflip: 8, sflip: 0, wflip: 8, eflip: 0 },
  },
  shield: {
    gen: { shrink: 0.6, sx: -5, sy: -1, nx: 6, ny: -1, wx: 0, wy: -2, ex: 0, ey: -2, northabove: 0, southabove: 1, eastabove: 1, westabove: 0, nturn: 0, sturn: 0, wturn: 0, eturn: 0, nflip: 0, sflip: 0, wflip: 0, eflip: 0 },
  },
};

const DEFAULT_EDITOR = {
  sprite: {
    size: 64,
    iconState: "",
    frame: 1,
  },
  prop: structuredClone(DEFAULT_CUSTOM_PROP),
};

const state = {
  dmiImage: null,
  dmiMetadata: null,
  spriteSourceCanvas: null,
  helperMasks: {
    32: null,
    64: null,
  },
  genericMob: {
    images: {},
  },
  editor: {
    ...structuredClone(DEFAULT_EDITOR),
    wieldedProp: structuredClone(DEFAULT_EDITOR.prop),
  },
  propInputMode: "delta",
  behind: false,
  mirrored: false,
  wielded: false,
  propPreset: "custom",
  dmOutputFocused: false,
  dmOutputDraft: "",
  dmOutputStatus: "Paste a DM list(...) block here to import prop values.",
  focusedPropKey: null,
  propInputDrafts: {},
};

const dom = {
  dmiFile: document.querySelector("#dmi-file"),
  resetButton: document.querySelector("#reset-editor"),
  propInputMode: document.querySelector("#prop-input-mode"),
  behindToggle: document.querySelector("#behind-toggle"),
  mirroredToggle: document.querySelector("#mirrored-toggle"),
  wieldedToggle: document.querySelector("#wielded-toggle"),
  propPreset: document.querySelector("#prop-preset"),
  spriteSize: document.querySelector("#sprite-size"),
  iconStateInput: document.querySelector("#icon-state-input"),
  iconStateList: document.querySelector("#icon-state-list"),
  iconFrame: document.querySelector("#icon-frame"),
  spriteSourceStatus: document.querySelector("#sprite-source-status"),
  propControls: document.querySelector("#prop-controls"),
  previewGrid: document.querySelector("#preview-grid"),
  previewTileTemplate: document.querySelector("#preview-tile-template"),
  dmListOutput: document.querySelector("#dm-list-output"),
  dmOutputStatus: document.querySelector("#dm-output-status"),
  copyList: document.querySelector("#copy-list"),
};

initialize();

function initialize() {
  buildPreviewTiles();
  buildPropControls();
  bindEvents();
  void loadGenericMobSprite();
  void loadHelperMasks();
  render();
}

async function loadGenericMobSprite() {
  try {
    const entries = await Promise.all(
      Object.entries(GENERIC_MOB_SOURCES).map(async ([directionKey, source]) => {
        const image = await loadImage(`${source}?v=4`);
        return [directionKey, image];
      }),
    );
    state.genericMob.images = Object.fromEntries(entries);
    renderPreview();
  } catch {
    state.genericMob.images = {};
  }
}

async function loadHelperMasks() {
  try {
    const [smallMasks, largeMasks] = await Promise.all([
      loadHelperMaskSet(32),
      loadHelperMaskSet(64),
    ]);
    state.helperMasks[32] = smallMasks;
    state.helperMasks[64] = largeMasks;
    renderPreview();
  } catch {
    // The editor can still fall back to approximate masks if helper assets fail to load.
  }
}

async function loadHelperMaskSet(size) {
  const response = await fetch(HELPER_MASK_SOURCES[size], { cache: "no-store" });
  if (!response.ok) {
    throw new Error(`Failed to load helper mask set ${size}.`);
  }
  const arrayBuffer = await response.arrayBuffer();
  const metadata = await parseDmiMetadata(arrayBuffer);
  if (!metadata?.states?.length) {
    throw new Error(`Helper mask set ${size} is missing DMI metadata.`);
  }

  const objectUrl = URL.createObjectURL(new Blob([arrayBuffer], { type: "image/png" }));
  const image = await loadImage(objectUrl);
  return {
    image,
    metadata,
    size,
  };
}

function bindEvents() {
  dom.dmiFile.addEventListener("change", async (event) => {
    const [file] = event.target.files;
    if (!file) {
      return;
    }
    try {
      await applyDmiFile(file);
    } catch (error) {
      window.alert(error.message || "Failed to load DMI.");
    }
  });

  dom.resetButton.addEventListener("click", () => {
    resetEditor();
  });

  dom.propInputMode.addEventListener("change", () => {
    state.propInputMode = dom.propInputMode.value === "actual" ? "actual" : "delta";
    state.focusedPropKey = null;
    state.propInputDrafts = {};
    render();
  });

  dom.behindToggle.addEventListener("change", () => {
    state.behind = dom.behindToggle.checked;
    render();
  });

  dom.mirroredToggle.addEventListener("change", () => {
    state.mirrored = dom.mirroredToggle.checked;
    render();
  });

  dom.wieldedToggle.addEventListener("change", () => {
    state.wielded = dom.wieldedToggle.checked;
    applySelectedPropPreset(false);
    updateSpriteSourceCanvas();
    render();
  });

  dom.propPreset.addEventListener("change", () => {
    state.propPreset = dom.propPreset.value;
    applySelectedPropPreset(true);
    render();
  });

  dom.iconStateInput.addEventListener("input", () => {
    state.editor.sprite.iconState = dom.iconStateInput.value.trim();
    updateSpriteSourceCanvas();
    render();
  });

  const bindings = [
    [dom.iconFrame, ["editor", "sprite", "frame"], Number],
  ];

  dom.spriteSize.addEventListener("change", () => {
    const value = Number(dom.spriteSize.value);
    state.editor.sprite.size = value === 32 ? 32 : 64;
    updateSpriteSourceCanvas();
    render();
  });

  for (const [element, path, caster] of bindings) {
    element.addEventListener("input", () => {
      const value = Math.max(1, caster(element.value) || 1);
      setByPath(state, path, value);
      if (element === dom.iconFrame) {
        updateSpriteSourceCanvas();
      }
      render();
    });
  }

  dom.copyList.addEventListener("click", () => copyText(dom.dmListOutput.value));

  dom.dmListOutput.addEventListener("focus", () => {
    state.dmOutputFocused = true;
  });

  dom.dmListOutput.addEventListener("blur", () => {
    state.dmOutputFocused = false;
    if (applyDmListText(dom.dmListOutput.value)) {
      return;
    }
    renderOutputs();
  });

  dom.dmListOutput.addEventListener("paste", async (event) => {
    event.preventDefault();
    const clipboardText = event.clipboardData?.getData("text") ?? await readClipboardText();
    if (!clipboardText) {
      return;
    }
    dom.dmListOutput.value = clipboardText;
    applyDmListText(clipboardText);
  });

  dom.dmListOutput.addEventListener("change", () => {
    applyDmListText(dom.dmListOutput.value);
  });
}

function buildPreviewTiles() {
  for (const config of DIRECTION_CONFIG) {
    const node = dom.previewTileTemplate.content.firstElementChild.cloneNode(true);
    node.dataset.direction = config.key;
    node.querySelector("figcaption").textContent = config.label;
    dom.previewGrid.append(node);
  }
}

function buildPropControls() {
  dom.propControls.innerHTML = "";
  for (const key of PROP_ORDER) {
    const label = document.createElement("label");
    const title = document.createElement("span");
    title.textContent = key;
    const input = document.createElement("input");
    input.dataset.propKey = key;
    input.type = "number";
    input.step = key === "shrink" ? "0.1" : "1";
    if (key === "shrink") {
      input.min = "0";
    }
    input.addEventListener("focus", () => {
      state.focusedPropKey = key;
      state.propInputDrafts[key] = input.value;
    });
    input.addEventListener("input", () => {
      state.propInputDrafts[key] = input.value;
      if (!isIntermediateNumericInput(input.value)) {
        commitPropInputValue(key, input.value);
      }
    });
    input.addEventListener("blur", () => {
      commitPropInputValue(key, input.value, true);
      if (state.focusedPropKey === key) {
        state.focusedPropKey = null;
      }
    });
    label.append(title, input);
    dom.propControls.append(label);
  }
}

function resetEditor() {
  state.editor = {
    ...structuredClone(DEFAULT_EDITOR),
    wieldedProp: structuredClone(DEFAULT_CUSTOM_PROP),
  };
  state.behind = false;
  state.mirrored = false;
  state.wielded = false;
  state.propPreset = "custom";
  state.dmOutputStatus = "Paste a DM list(...) block here to import prop values.";
  state.focusedPropKey = null;
  state.propInputDrafts = {};
  clearDmiState();
  render();
}

async function applyDmiFile(file) {
  const arrayBuffer = await file.arrayBuffer();
  const objectUrl = URL.createObjectURL(new Blob([arrayBuffer], { type: "image/png" }));
  clearDmiState();
  state.dmiImage = await loadImage(objectUrl);
  state.dmiMetadata = await parseDmiMetadata(arrayBuffer);

  if (state.dmiMetadata) {
    const metadataSize = Number(state.dmiMetadata.width || 0);
    if (metadataSize === 32 || metadataSize === 64) {
      state.editor.sprite.size = metadataSize;
    }
    state.editor.sprite.iconState = pickInitialIconState(state.dmiMetadata, state.editor.sprite.iconState);
    state.editor.sprite.frame = 1;
  } else {
    state.editor.sprite.iconState = "";
    state.editor.sprite.frame = 1;
  }

  updateIconStateSuggestions();
  updateSpriteSourceCanvas();
  render();
}

function clearDmiState() {
  if (state.dmiImage?.src?.startsWith("blob:")) {
    URL.revokeObjectURL(state.dmiImage.src);
  }
  state.dmiImage = null;
  state.dmiMetadata = null;
  state.spriteSourceCanvas = null;
  updateIconStateSuggestions();
}

function pickInitialIconState(metadata, currentValue) {
  if (currentValue && metadata.states.some((entry) => entry.name === currentValue)) {
    return currentValue;
  }
  return metadata.states[0]?.name ?? "";
}

function updateIconStateSuggestions() {
  dom.iconStateList.innerHTML = "";
  if (!state.dmiMetadata?.states?.length) {
    return;
  }
  for (const entry of state.dmiMetadata.states) {
    const option = document.createElement("option");
    option.value = entry.name;
    dom.iconStateList.append(option);
  }
}

function ensurePropKeys(prop) {
  for (const key of PROP_ORDER) {
    if (!(key in prop)) {
      prop[key] = 0;
    }
  }
}

function getActiveEditorProp() {
  return state.wielded ? state.editor.wieldedProp : state.editor.prop;
}

function createZeroProp() {
  return structuredClone(ZERO_PROP);
}

function createDefaultCustomProp() {
  return structuredClone(DEFAULT_CUSTOM_PROP);
}

function getPresetBaseProp() {
  const preset = PROP_PRESETS[state.propPreset];
  if (!preset) {
    return null;
  }

  return state.wielded ? (preset.wielded ?? preset.gen) : preset.gen;
}

function getEffectiveProp() {
  const baseProp = getPresetBaseProp();
  const activeAdjustmentProp = getActiveEditorProp();

  if (!baseProp) {
    return activeAdjustmentProp;
  }

  const effectiveProp = {};
  for (const key of PROP_ORDER) {
    const baseValue = Number(baseProp[key] ?? 0);
    const adjustmentValue = Number(activeAdjustmentProp[key] ?? 0);
    let combinedValue = baseValue + adjustmentValue;
    if (key === "shrink") {
      combinedValue = Math.max(0, combinedValue);
    } else if (key.endsWith("above")) {
      combinedValue = Math.max(0, Math.min(1, Math.round(combinedValue)));
    }
    effectiveProp[key] = combinedValue;
  }
  return effectiveProp;
}

function getSimulationProp() {
  const presetBaseProp = getPresetBaseProp();
  if (presetBaseProp) {
    return getEffectiveProp();
  }

  return getActiveEditorProp();
}

function applySelectedPropPreset(resetAdjustments = false) {
  const presetProp = getPresetBaseProp();
  if (!presetProp) {
    if (resetAdjustments) {
      state.editor.prop = createDefaultCustomProp();
      state.editor.wieldedProp = createDefaultCustomProp();
      state.focusedPropKey = null;
      state.propInputDrafts = {};
    }
    state.dmOutputStatus = "No preset baseline loaded; preview shows the raw iconstate unless you add direct prop deltas.";
    return;
  }

  if (resetAdjustments) {
    state.editor.prop = createZeroProp();
    state.editor.wieldedProp = createZeroProp();
    state.focusedPropKey = null;
    state.propInputDrafts = {};
  }

  ensurePropKeys(state.editor.prop);
  ensurePropKeys(state.editor.wieldedProp);
  state.dmOutputStatus = `Loaded ${state.propPreset} ${state.wielded ? "wielded" : "unwielded"} preset baseline; edits are additive.`;
}

function syncUiFromState() {
  const displayedProp = getDisplayedProp();
  dom.iconStateInput.value = state.editor.sprite.iconState ?? "";
  dom.propPreset.value = state.propPreset;
  dom.propInputMode.value = state.propInputMode;
  dom.spriteSize.value = String(state.editor.sprite.size ?? 64);
  dom.iconFrame.value = state.editor.sprite.frame ?? 1;
  dom.behindToggle.checked = state.behind;
  dom.mirroredToggle.checked = state.mirrored;
  dom.wieldedToggle.checked = state.wielded;

  for (const input of dom.propControls.querySelectorAll("input[data-prop-key]")) {
    const key = input.dataset.propKey;
    if (state.focusedPropKey === key && key in state.propInputDrafts) {
      input.value = state.propInputDrafts[key];
      continue;
    }
    input.value = formatPropInputValue(key, displayedProp[key]);
  }
}

function getDisplayedProp() {
  if (state.propInputMode === "actual" && getPresetBaseProp()) {
    return getEffectiveProp();
  }
  return getActiveEditorProp();
}

function updateSpriteSourceCanvas() {
  state.spriteSourceCanvas = null;
  if (!state.dmiImage) {
    return;
  }

  if (!state.dmiMetadata?.states?.length) {
    state.spriteSourceCanvas = cropSpriteTileByIndex(Math.max(1, Number(state.editor.sprite.frame) || 1));
    return;
  }

  if (!state.editor.sprite.iconState) {
    return;
  }

  const resolvedIconState = resolvePreviewIconState();
  const entry = state.dmiMetadata.states.find((item) => item.name === resolvedIconState);
  if (!entry) {
    return;
  }

  const frameIndex = Math.min(entry.frames - 1, Math.max(0, Number(state.editor.sprite.frame || 1) - 1));
  const tileIndex = entry.offset + frameIndex * entry.dirs;
  state.spriteSourceCanvas = cropSpriteTileByIndex(tileIndex + 1);
}

function cropSpriteTileByIndex(oneBasedTileIndex) {
  const tileWidth = getSelectedSpriteSize();
  const tileHeight = getSelectedSpriteSize();
  const columns = Math.max(1, Math.floor(state.dmiImage.width / tileWidth));
  const tileIndex = Math.max(0, oneBasedTileIndex - 1);
  const sourceX = (tileIndex % columns) * tileWidth;
  const sourceY = Math.floor(tileIndex / columns) * tileHeight;

  const canvas = document.createElement("canvas");
  canvas.width = tileWidth;
  canvas.height = tileHeight;
  const ctx = canvas.getContext("2d");
  ctx.drawImage(state.dmiImage, sourceX, sourceY, tileWidth, tileHeight, 0, 0, tileWidth, tileHeight);
  return canvas;
}

function render() {
  syncUiFromState();
  updateSpriteStatus();
  renderPreview();
  renderOutputs();
}

function hasNonZeroProp(prop) {
  return PROP_ORDER.some((key) => Number(prop[key] ?? 0) !== 0);
}

function hasCustomOverrides(prop) {
  return PROP_ORDER.some((key) => Number(prop[key] ?? 0) !== Number(DEFAULT_CUSTOM_PROP[key] ?? 0));
}

function shouldUsePropSimulation() {
  if (getPresetBaseProp()) {
    return true;
  }
  return hasCustomOverrides(getActiveEditorProp());
}

function renderPreview() {
  for (const tile of dom.previewGrid.querySelectorAll(".preview-tile")) {
    const config = DIRECTION_CONFIG.find((entry) => entry.key === tile.dataset.direction);
    const canvas = tile.querySelector("canvas");
    const ctx = canvas.getContext("2d");
    drawPreview(ctx, config);
    tile.querySelector(".preview-meta").textContent = describeDirection(config);
  }
}

function drawPreview(ctx, config) {
  const width = ctx.canvas.width;
  const height = ctx.canvas.height;
  ctx.clearRect(0, 0, width, height);

  ctx.save();
  ctx.strokeStyle = "rgba(106, 86, 66, 0.25)";
  ctx.lineWidth = 1;
  ctx.beginPath();
  ctx.moveTo(width / 2, 0);
  ctx.lineTo(width / 2, height);
  ctx.moveTo(0, height / 2);
  ctx.lineTo(width, height / 2);
  ctx.stroke();
  ctx.restore();

  const previewScale = 3;
  const bodyCanvas = getGenericMobCanvas(config.key);
  const scaledWidth = 64 * previewScale;
  const scaledHeight = 64 * previewScale;
  const drawX = (width - scaledWidth) / 2;
  const drawY = (height - scaledHeight) / 2;

  const spriteSource = getSpriteSource();
  if (!spriteSource.image) {
    if (bodyCanvas) {
      ctx.save();
      ctx.imageSmoothingEnabled = false;
      ctx.globalAlpha = 0.7;
      ctx.drawImage(bodyCanvas, drawX, drawY, scaledWidth, scaledHeight);
      ctx.restore();
    }
    drawHint(ctx, "Load a DMI and set iconstate or tile index");
    return;
  }

  const simulatedPreview = shouldUsePropSimulation()
    ? renderSimulatedPreview(spriteSource, config.key)
    : null;
  const stageCanvas = simulatedPreview?.stageCanvas ?? renderRawPreviewStage(spriteSource.image, config);
  const renderUnderBody = simulatedPreview?.renderUnderBody ?? false;
  const overlayOffset = getPreviewOverlayOffset(spriteSource);
  const overlayX = drawX + (overlayOffset.x * previewScale);
  const overlayY = drawY - (overlayOffset.y * previewScale);

  ctx.save();
  ctx.imageSmoothingEnabled = false;
  if (renderUnderBody) {
    ctx.drawImage(stageCanvas, overlayX, overlayY, scaledWidth, scaledHeight);
    if (bodyCanvas) {
      ctx.globalAlpha = 0.7;
      ctx.drawImage(bodyCanvas, drawX, drawY, scaledWidth, scaledHeight);
      ctx.globalAlpha = 1;
    }
  } else {
    if (bodyCanvas) {
      ctx.globalAlpha = 0.7;
      ctx.drawImage(bodyCanvas, drawX, drawY, scaledWidth, scaledHeight);
      ctx.globalAlpha = 1;
    }
    ctx.drawImage(stageCanvas, overlayX, overlayY, scaledWidth, scaledHeight);
  }
  ctx.restore();
}

function resolvePreviewIconState() {
  const iconState = state.editor.sprite.iconState?.trim();
  if (!iconState || !state.dmiMetadata?.states?.length) {
    return iconState;
  }

  let resolvedState = iconState;

  if (state.wielded) {
    const wieldedState = iconState.endsWith("1") ? iconState : `${iconState}1`;
    if (state.dmiMetadata.states.some((entry) => entry.name === wieldedState)) {
      resolvedState = wieldedState;
    }
  }

  if (state.behind) {
    const behindState = `${resolvedState}_behind`;
    if (state.dmiMetadata.states.some((entry) => entry.name === behindState)) {
      return behindState;
    }
  }

  return resolvedState;
}

function getGenericMobCanvas(directionKey) {
  const guideImage = state.genericMob.images[directionKey] ?? state.genericMob.images.south;
  if (!guideImage) {
    return null;
  }

  const targetSize = 32;
  const outputCanvas = document.createElement("canvas");
  outputCanvas.width = 64;
  outputCanvas.height = 64;
  const outputCtx = outputCanvas.getContext("2d");
  outputCtx.imageSmoothingEnabled = false;

  const drawX = Math.round((64 - targetSize) / 2);
  const drawY = Math.round((64 - targetSize) / 2);
  outputCtx.drawImage(guideImage, drawX, drawY, targetSize, targetSize);
  return outputCanvas;
}

function resolveRenderState(directionKey) {
  const prop = getSimulationProp();
  const shrink = Number(prop.shrink ?? 0);
  let aboveKey = "";
  let x = 0;
  let y = 0;
  let turn = 0;
  let flip = 0;
  let postFlip = 0;
  let usedTag = "";

  switch (directionKey) {
    case "north":
      aboveKey = "northabove";
      x = Number(prop.nx ?? 0);
      y = Number(prop.ny ?? 0);
      turn = Number(prop.nturn ?? 0);
      flip = Number(prop.nflip ?? 0);
      if (state.mirrored) {
        x = -x + getMirrorFix(shrink, spriteIsLarge());
        postFlip = BYOND_DIR.WEST;
      }
      break;
    case "south":
      aboveKey = "southabove";
      x = Number(prop.sx ?? 0);
      y = Number(prop.sy ?? 0);
      turn = Number(prop.sturn ?? 0);
      flip = Number(prop.sflip ?? 0);
      if (state.mirrored) {
        x = -x + getMirrorFix(shrink, spriteIsLarge());
        postFlip = BYOND_DIR.EAST;
      }
      break;
    case "east":
      usedTag = state.mirrored ? "w" : "e";
      aboveKey = state.mirrored ? "westabove" : "eastabove";
      x = Number(prop[`${usedTag}x`] ?? 0);
      y = Number(prop[`${usedTag}y`] ?? 0);
      turn = Number(prop[`${usedTag}turn`] ?? 0);
      flip = Number(prop[`${usedTag}flip`] ?? 0);
      if (state.mirrored) {
        x *= -1;
        postFlip = BYOND_DIR.EAST;
      }
      break;
    case "west":
      usedTag = state.mirrored ? "e" : "w";
      aboveKey = state.mirrored ? "eastabove" : "westabove";
      x = Number(prop[`${usedTag}x`] ?? 0);
      y = Number(prop[`${usedTag}y`] ?? 0);
      turn = Number(prop[`${usedTag}turn`] ?? 0);
      flip = Number(prop[`${usedTag}flip`] ?? 0);
      if (state.mirrored) {
        x *= -1;
        postFlip = BYOND_DIR.EAST;
      }
      break;
    default:
      aboveKey = config.aboveKey;
  }

  const aboveValue = Number(prop[aboveKey] ?? 0);
  const renderUnderBody = aboveValue === 0;
  const shouldRender = state.behind ? aboveValue === 0 : aboveValue === 1;

  return {
    shouldRender,
    renderUnderBody,
    aboveKey,
    x,
    y,
    turn,
    flip,
    postFlip,
    usedTag,
    shrink,
  };
}

function renderRawPreviewStage(sourceImage, config) {
  const stageCanvas = document.createElement("canvas");
  stageCanvas.width = 64;
  stageCanvas.height = 64;
  const stageCtx = stageCanvas.getContext("2d");
  stageCtx.clearRect(0, 0, 64, 64);
  stageCtx.imageSmoothingEnabled = false;

  const activeProp = getActiveEditorProp();
  const aboveValue = Number(activeProp[config.aboveKey] ?? 1);
  const shouldRender = state.behind ? aboveValue === 0 : aboveValue === 1;
  if (!shouldRender) {
    return stageCanvas;
  }

  const drawX = Math.round((64 - sourceImage.width) / 2);
  const drawY = Math.round((64 - sourceImage.height) / 2);
  stageCtx.drawImage(sourceImage, drawX, drawY);

  return stageCanvas;
}

function renderSimulatedPreview(spriteSource, directionKey) {
  const renderState = resolveRenderState(directionKey);
  if (!renderState.shouldRender) {
    const blankCanvas = document.createElement("canvas");
    blankCanvas.width = 64;
    blankCanvas.height = 64;
    return {
      stageCanvas: blankCanvas,
      renderUnderBody: renderState.renderUnderBody,
    };
  }

  return {
    stageCanvas: renderDmApproximation(spriteSource, directionKey, renderState),
    renderUnderBody: renderState.renderUnderBody,
  };
}

function renderDmApproximation(spriteSource, directionKey, renderState) {
  const outputCanvas = document.createElement("canvas");
  outputCanvas.width = 64;
  outputCanvas.height = 64;
  const outputCtx = outputCanvas.getContext("2d");
  outputCtx.clearRect(0, 0, 64, 64);

  const maskedSource = applyDirectionMask(spriteSource.image, directionKey);
  let holderCanvas = transformHolderCanvas(maskedSource, renderState.flip, renderState.turn, renderState.shrink);
  if (renderState.postFlip) {
    holderCanvas = flipCanvas(holderCanvas, renderState.postFlip);
  }

  const ax = 32 - (holderCanvas.width / 2);
  const px = renderState.x + ax;
  const py = renderState.y + ax;
  const drawX = px;
  const drawY = 64 - py - holderCanvas.height;

  outputCtx.imageSmoothingEnabled = false;
  outputCtx.drawImage(holderCanvas, drawX, drawY);
  return outputCanvas;
}

function applyDirectionMask(sourceImage, directionKey) {
  const maskCanvas = getHelperMaskCanvas(directionKey, sourceImage.width, sourceImage.height);
  if (maskCanvas) {
    return multiplyCanvasWithMask(sourceImage, maskCanvas);
  }
  return applyDirectionMaskApproximation(sourceImage, directionKey);
}

function getHelperMaskCanvas(directionKey, sourceWidth, sourceHeight) {
  const helperSet = sourceWidth > 32 || sourceHeight > 32 ? state.helperMasks[64] : state.helperMasks[32];
  if (!helperSet) {
    return null;
  }

  const entry = helperSet.metadata.states.find((stateEntry) => stateEntry.name === directionKey);
  if (!entry) {
    return null;
  }

  const tileWidth = Number(helperSet.metadata.width ?? helperSet.size);
  const tileHeight = Number(helperSet.metadata.height ?? helperSet.size);
  return cropDmiStateFrame(helperSet.image, helperSet.metadata, entry, 0, tileWidth, tileHeight);
}

function cropDmiStateFrame(image, metadata, entry, frameIndex, tileWidth, tileHeight) {
  const columns = Math.max(1, Math.floor(image.width / tileWidth));
  const tileIndex = entry.offset + frameIndex * entry.dirs;
  const sourceX = (tileIndex % columns) * tileWidth;
  const sourceY = Math.floor(tileIndex / columns) * tileHeight;

  const canvas = document.createElement("canvas");
  canvas.width = tileWidth;
  canvas.height = tileHeight;
  const ctx = canvas.getContext("2d");
  ctx.drawImage(image, sourceX, sourceY, tileWidth, tileHeight, 0, 0, tileWidth, tileHeight);
  return canvas;
}

function multiplyCanvasWithMask(sourceImage, maskCanvas) {
  const width = Math.max(sourceImage.width, maskCanvas.width);
  const height = Math.max(sourceImage.height, maskCanvas.height);
  const sourceCanvas = document.createElement("canvas");
  sourceCanvas.width = width;
  sourceCanvas.height = height;
  const sourceCtx = sourceCanvas.getContext("2d");
  sourceCtx.drawImage(sourceImage, 0, 0);

  const maskCtx = maskCanvas.getContext("2d");
  const sourceData = sourceCtx.getImageData(0, 0, width, height);
  const expandedMaskCanvas = document.createElement("canvas");
  expandedMaskCanvas.width = width;
  expandedMaskCanvas.height = height;
  expandedMaskCanvas.getContext("2d").drawImage(maskCanvas, 0, 0);
  const expandedMaskData = expandedMaskCanvas.getContext("2d").getImageData(0, 0, width, height);

  for (let index = 0; index < sourceData.data.length; index += 4) {
    sourceData.data[index] = Math.round((sourceData.data[index] * expandedMaskData.data[index]) / 255);
    sourceData.data[index + 1] = Math.round((sourceData.data[index + 1] * expandedMaskData.data[index + 1]) / 255);
    sourceData.data[index + 2] = Math.round((sourceData.data[index + 2] * expandedMaskData.data[index + 2]) / 255);
    sourceData.data[index + 3] = Math.round((sourceData.data[index + 3] * expandedMaskData.data[index + 3]) / 255);
  }

  sourceCtx.putImageData(sourceData, 0, 0);
  return sourceCanvas;
}

function transformHolderCanvas(sourceImage, flip, turn, shrink) {
  const workingCanvas = document.createElement("canvas");
  workingCanvas.width = sourceImage.width;
  workingCanvas.height = sourceImage.height;
  const workingCtx = workingCanvas.getContext("2d");
  const centerX = workingCanvas.width / 2;
  const centerY = workingCanvas.height / 2;

  workingCtx.save();
  workingCtx.translate(centerX, centerY);
  workingCtx.rotate((turn * Math.PI) / 180);
  workingCtx.scale(getByondFlipScaleX(flip), getByondFlipScaleY(flip));
  workingCtx.imageSmoothingEnabled = false;
  workingCtx.drawImage(sourceImage, -sourceImage.width / 2, -sourceImage.height / 2, sourceImage.width, sourceImage.height);
  workingCtx.restore();

  const scaledWidth = Math.max(1, Math.round(workingCanvas.width * shrink));
  const scaledHeight = Math.max(1, Math.round(workingCanvas.height * shrink));
  const scaledCanvas = document.createElement("canvas");
  scaledCanvas.width = scaledWidth;
  scaledCanvas.height = scaledHeight;
  const scaledCtx = scaledCanvas.getContext("2d");
  scaledCtx.imageSmoothingEnabled = false;
  scaledCtx.drawImage(workingCanvas, 0, 0, scaledWidth, scaledHeight);

  return scaledCanvas;
}

function flipCanvas(sourceCanvas, flip) {
  const canvas = document.createElement("canvas");
  canvas.width = sourceCanvas.width;
  canvas.height = sourceCanvas.height;
  const ctx = canvas.getContext("2d");
  const centerX = canvas.width / 2;
  const centerY = canvas.height / 2;

  ctx.save();
  ctx.translate(centerX, centerY);
  ctx.scale(getByondFlipScaleX(flip), getByondFlipScaleY(flip));
  ctx.drawImage(sourceCanvas, -sourceCanvas.width / 2, -sourceCanvas.height / 2);
  ctx.restore();
  return canvas;
}

function trimCanvasAlpha(sourceCanvas) {
  const ctx = sourceCanvas.getContext("2d");
  const { width, height } = sourceCanvas;
  const imageData = ctx.getImageData(0, 0, width, height).data;
  let minX = width;
  let minY = height;
  let maxX = -1;
  let maxY = -1;

  for (let y = 0; y < height; y += 1) {
    for (let x = 0; x < width; x += 1) {
      const alpha = imageData[(y * width + x) * 4 + 3];
      if (!alpha) {
        continue;
      }
      minX = Math.min(minX, x);
      minY = Math.min(minY, y);
      maxX = Math.max(maxX, x);
      maxY = Math.max(maxY, y);
    }
  }

  if (maxX < minX || maxY < minY) {
    const fallbackCanvas = document.createElement("canvas");
    fallbackCanvas.width = 1;
    fallbackCanvas.height = 1;
    return fallbackCanvas;
  }

  const trimmedCanvas = document.createElement("canvas");
  trimmedCanvas.width = maxX - minX + 1;
  trimmedCanvas.height = maxY - minY + 1;
  trimmedCanvas.getContext("2d").drawImage(
    sourceCanvas,
    minX,
    minY,
    trimmedCanvas.width,
    trimmedCanvas.height,
    0,
    0,
    trimmedCanvas.width,
    trimmedCanvas.height,
  );
  return trimmedCanvas;
}

function applyDirectionMaskApproximation(sourceImage, directionKey) {
  const canvas = document.createElement("canvas");
  canvas.width = sourceImage.width;
  canvas.height = sourceImage.height;
  const ctx = canvas.getContext("2d");
  ctx.drawImage(sourceImage, 0, 0);
  ctx.globalCompositeOperation = "destination-in";
  ctx.fillStyle = "#000";
  drawApproximationMaskPath(ctx, directionKey, canvas.width, canvas.height);
  ctx.fill();
  ctx.globalCompositeOperation = "source-over";
  return canvas;
}

function drawApproximationMaskPath(ctx, directionKey, width, height) {
  ctx.beginPath();
  switch (directionKey) {
    case "north":
      ctx.moveTo(width * 0.08, height * 0.3);
      ctx.lineTo(width * 0.28, height * 0.04);
      ctx.lineTo(width * 0.82, height * 0.04);
      ctx.lineTo(width * 0.96, height * 0.32);
      ctx.lineTo(width * 0.88, height * 0.96);
      ctx.lineTo(width * 0.18, height * 0.96);
      ctx.closePath();
      break;
    case "south":
      ctx.moveTo(width * 0.12, height * 0.04);
      ctx.lineTo(width * 0.82, height * 0.04);
      ctx.lineTo(width * 0.94, height * 0.7);
      ctx.lineTo(width * 0.72, height * 0.96);
      ctx.lineTo(width * 0.18, height * 0.96);
      ctx.lineTo(width * 0.04, height * 0.68);
      ctx.closePath();
      break;
    case "east":
      ctx.moveTo(width * 0.06, height * 0.18);
      ctx.lineTo(width * 0.62, height * 0.04);
      ctx.lineTo(width * 0.96, height * 0.24);
      ctx.lineTo(width * 0.96, height * 0.84);
      ctx.lineTo(width * 0.52, height * 0.96);
      ctx.lineTo(width * 0.08, height * 0.78);
      ctx.closePath();
      break;
    case "west":
      ctx.moveTo(width * 0.04, height * 0.24);
      ctx.lineTo(width * 0.38, height * 0.04);
      ctx.lineTo(width * 0.94, height * 0.18);
      ctx.lineTo(width * 0.92, height * 0.78);
      ctx.lineTo(width * 0.48, height * 0.96);
      ctx.lineTo(width * 0.04, height * 0.84);
      ctx.closePath();
      break;
    default:
      ctx.rect(0, 0, width, height);
  }
}

function getMirrorFix(shrink, big) {
  if (!shrink) {
    return 0;
  }
  if (shrink === 0.5) {
    return 1;
  }
  if (shrink === 0.6) {
    return big ? 1 : 2;
  }
  if (shrink === 0.7) {
    return 1;
  }
  return 0;
}

function spriteIsLarge() {
  return getSelectedSpriteSize() > 32;
}

function getSelectedSpriteSize() {
  return state.editor.sprite.size === 32 ? 32 : 64;
}

function getByondFlipScaleX(flip) {
  return flip & (BYOND_DIR.EAST | BYOND_DIR.WEST) ? -1 : 1;
}

function getByondFlipScaleY(flip) {
  return flip & (BYOND_DIR.NORTH | BYOND_DIR.SOUTH) ? -1 : 1;
}

function drawHint(ctx, text) {
  ctx.save();
  ctx.fillStyle = "rgba(106, 86, 66, 0.8)";
  ctx.font = "16px Georgia";
  ctx.textAlign = "center";
  ctx.fillText(text, ctx.canvas.width / 2, ctx.canvas.height / 2);
  ctx.restore();
}

function getSpriteSource() {
  if (!state.spriteSourceCanvas) {
    return { image: null, width: 0, height: 0 };
  }
  return {
    image: state.spriteSourceCanvas,
    width: state.spriteSourceCanvas.width || 0,
    height: state.spriteSourceCanvas.height || 0,
  };
}

function getPreviewOverlayOffset(spriteSource) {
  return {
    x: DEFAULT_PREVIEW_HAND_OFFSET_X,
    y: DEFAULT_PREVIEW_HAND_OFFSET_Y,
  };
}

function describeDirection(config) {
  if (!shouldUsePropSimulation()) {
    return [
      `mode=${state.mirrored ? "mirrored" : "normal"}`,
      "baseline=raw iconstate",
      `render=${resolvePreviewIconState() || "none"}`,
    ].join(" | ");
  }

  const prop = getEffectiveProp();
  return [
    `mode=${state.mirrored ? "mirrored" : "normal"}`,
    `${config.turnKey}=${prop[config.turnKey]}`,
    `${config.flipKey}=${prop[config.flipKey]}`,
    `${config.aboveKey}=${prop[config.aboveKey]}`,
  ].join(" | ");
}

function renderOutputs() {
  const output = buildDmList(getEffectiveProp());
  state.dmOutputDraft = output;
  if (!state.dmOutputFocused) {
    dom.dmListOutput.value = output;
  }
  dom.dmOutputStatus.textContent = state.dmOutputStatus;
}

function buildDmList(prop) {
  const lines = ["list("];
  for (const key of PROP_ORDER) {
    lines.push(`\t\t\t"${key}" = ${formatDmValue(prop[key])},`);
  }
  lines.push(")");
  return lines.join("\n");
}

function formatDmValue(value) {
  if (typeof value === "number" && Number.isInteger(value)) {
    return String(value);
  }
  if (typeof value === "number") {
    return Number(value.toFixed(3)).toString();
  }
  return JSON.stringify(value);
}

function commitPropInputValue(key, rawValue, forceRender = false) {
  const parsedValue = normalizePropInputValue(key, rawValue);
  if (parsedValue === null) {
    if (forceRender) {
      delete state.propInputDrafts[key];
      render();
    }
    return;
  }

  let storedValue = parsedValue;
  if (state.propInputMode === "actual") {
    const presetBaseProp = getPresetBaseProp();
    if (presetBaseProp) {
      storedValue = parsedValue - Number(presetBaseProp[key] ?? 0);
    }
  }

  getActiveEditorProp()[key] = storedValue;
  state.propInputDrafts[key] = formatPropInputValue(key, parsedValue);
  render();
}

function normalizePropInputValue(key, rawValue) {
  const trimmed = String(rawValue ?? "").trim();
  if (!trimmed) {
    return key === "shrink" ? 0 : 0;
  }

  if (!isCompleteNumericInput(trimmed)) {
    return null;
  }

  const numericValue = Number(trimmed);
  if (!Number.isFinite(numericValue)) {
    return null;
  }

  if (key === "shrink") {
    return Math.max(0, numericValue);
  }

  return numericValue;
}

function formatPropInputValue(key, value) {
  if (value === undefined || value === null) {
    return "";
  }
  if (key === "shrink") {
    return Number(value).toString();
  }
  if (Number.isInteger(value)) {
    return String(value);
  }
  return Number(value).toString();
}

function isIntermediateNumericInput(value) {
  return value === "" || value === "-" || value === "." || value === "-." || /^-?\d+\.$/.test(value);
}

function isCompleteNumericInput(value) {
  return /^-?(?:\d+\.\d+|\d+|\.\d+)$/.test(value);
}

function applyDmListText(text) {
  const parsedProp = parseDmList(text);
  if (!parsedProp) {
    state.dmOutputStatus = "Could not parse a valid DM list from the pasted text.";
    dom.dmOutputStatus.textContent = state.dmOutputStatus;
    return false;
  }

  const activeProp = getActiveEditorProp();
  for (const key of Object.keys(parsedProp)) {
    activeProp[key] = parsedProp[key];
  }
  state.propPreset = "custom";
  ensurePropKeys(activeProp);
  state.dmOutputStatus = "Imported prop values from pasted DM output.";
  render();
  return true;
}

function parseDmList(text) {
  if (!text) {
    return null;
  }

  const parsed = {};
  const entryPattern = /"([^"]+)"\s*=\s*([^,\n\r\)]+)/g;
  for (const match of text.matchAll(entryPattern)) {
    const key = match[1];
    if (!PROP_ORDER.includes(key)) {
      continue;
    }
    const value = parseDmNumericValue(match[2]);
    if (value === null) {
      continue;
    }
    parsed[key] = value;
  }

  return Object.keys(parsed).length ? parsed : null;
}

function parseDmNumericValue(valueText) {
  const normalized = valueText.trim();
  if (!normalized) {
    return null;
  }
  if (!/^-?\d+(?:\.\d+)?$/.test(normalized)) {
    return null;
  }
  return Number(normalized);
}

function setByPath(target, path, value) {
  let cursor = target;
  for (let index = 0; index < path.length - 1; index += 1) {
    cursor = cursor[path[index]];
  }
  cursor[path[path.length - 1]] = value;
}

function loadImage(source) {
  return new Promise((resolve, reject) => {
    const image = new Image();
    image.onload = () => resolve(image);
    image.onerror = reject;
    image.src = source;
  });
}

async function copyText(text) {
  try {
    await navigator.clipboard.writeText(text);
  } catch {
    window.prompt("Copy text", text);
  }
}

async function readClipboardText() {
  try {
    return await navigator.clipboard.readText();
  } catch {
    return "";
  }
}

async function parseDmiMetadata(arrayBuffer) {
  const description = await readPngDescription(new Uint8Array(arrayBuffer));
  if (!description) {
    return null;
  }
  return parseDmiDescription(description);
}

async function readPngDescription(bytes) {
  let offset = 8;
  while (offset + 8 <= bytes.length) {
    const length = readUint32(bytes, offset);
    offset += 4;
    const type = readAscii(bytes, offset, 4);
    offset += 4;
    const data = bytes.slice(offset, offset + length);
    offset += length + 4;

    if (type === "tEXt") {
      const textEntry = parseTextChunk(data);
      if (textEntry.keyword === "Description") {
        return textEntry.text;
      }
    }
    if (type === "zTXt") {
      const textEntry = await parseCompressedTextChunk(data);
      if (textEntry.keyword === "Description") {
        return textEntry.text;
      }
    }
    if (type === "iTXt") {
      const textEntry = await parseInternationalTextChunk(data);
      if (textEntry.keyword === "Description") {
        return textEntry.text;
      }
    }
  }
  return "";
}

function parseTextChunk(data) {
  const separator = data.indexOf(0);
  return {
    keyword: decodeLatin1(data.slice(0, separator)),
    text: decodeLatin1(data.slice(separator + 1)),
  };
}

async function parseCompressedTextChunk(data) {
  const separator = data.indexOf(0);
  const keyword = decodeLatin1(data.slice(0, separator));
  if (data[separator + 1] !== 0) {
    return { keyword, text: "" };
  }
  const text = decodeLatin1(await decompressBytes(data.slice(separator + 2)));
  return { keyword, text };
}

async function parseInternationalTextChunk(data) {
  let offset = 0;
  const keywordEnd = data.indexOf(0, offset);
  const keyword = decodeLatin1(data.slice(offset, keywordEnd));
  offset = keywordEnd + 1;
  const compressed = data[offset] === 1;
  offset += 2;
  const languageEnd = data.indexOf(0, offset);
  offset = languageEnd + 1;
  const translatedEnd = data.indexOf(0, offset);
  offset = translatedEnd + 1;
  const textBytes = data.slice(offset);
  if (!compressed) {
    return { keyword, text: new TextDecoder("utf-8").decode(textBytes) };
  }
  return { keyword, text: new TextDecoder("utf-8").decode(await decompressBytes(textBytes)) };
}

function parseDmiDescription(description) {
  const lines = description.split(/\r?\n/);
  const metadata = { width: 32, height: 32, states: [] };
  let currentState = null;
  let offset = 0;

  for (const rawLine of lines) {
    const line = rawLine.trim();
    if (!line || line.startsWith("#")) {
      continue;
    }
    const separator = line.indexOf("=");
    if (separator === -1) {
      continue;
    }
    const key = line.slice(0, separator).trim();
    const value = line.slice(separator + 1).trim();

    if (key === "width") {
      metadata.width = Number(value) || metadata.width;
      continue;
    }
    if (key === "height") {
      metadata.height = Number(value) || metadata.height;
      continue;
    }
    if (key === "state") {
      if (currentState) {
        currentState.offset = offset;
        offset += currentState.dirs * currentState.frames;
        metadata.states.push(currentState);
      }
      currentState = { name: stripQuotes(value), dirs: 1, frames: 1, offset: 0 };
      continue;
    }
    if (!currentState) {
      continue;
    }
    if (key === "dirs") {
      currentState.dirs = Number(value) || 1;
      continue;
    }
    if (key === "frames") {
      currentState.frames = Number(value) || 1;
    }
  }

  if (currentState) {
    currentState.offset = offset;
    metadata.states.push(currentState);
  }

  return metadata;
}

function stripQuotes(text) {
  return text.startsWith("\"") && text.endsWith("\"") ? text.slice(1, -1) : text;
}

function readUint32(bytes, offset) {
  return ((bytes[offset] << 24) | (bytes[offset + 1] << 16) | (bytes[offset + 2] << 8) | bytes[offset + 3]) >>> 0;
}

function readAscii(bytes, offset, length) {
  return String.fromCharCode(...bytes.slice(offset, offset + length));
}

function decodeLatin1(bytes) {
  return new TextDecoder("latin1").decode(bytes);
}

async function decompressBytes(bytes) {
  if (typeof DecompressionStream === "undefined") {
    throw new Error("This browser does not support compressed PNG metadata chunks.");
  }
  const stream = new Blob([bytes]).stream().pipeThrough(new DecompressionStream("deflate"));
  return new Uint8Array(await new Response(stream).arrayBuffer());
}

function updateSpriteStatus() {
  if (!state.dmiImage) {
    dom.spriteSourceStatus.textContent = "No DMI loaded yet.";
    return;
  }

  if (!state.dmiMetadata) {
    dom.spriteSourceStatus.textContent = `DMI loaded without Description metadata. Use Sprite Size and Frame / Tile to crop manually. Tile ${state.editor.sprite.frame} is selected.`;
    return;
  }

  const selected = state.dmiMetadata.states.find((entry) => entry.name === state.editor.sprite.iconState);
  if (!selected) {
    dom.spriteSourceStatus.textContent = `DMI loaded. Type an iconstate (${state.dmiMetadata.states.length} metadata states available).`;
    return;
  }

  const resolvedIconState = resolvePreviewIconState();
  const resolvedStateText = resolvedIconState !== selected.name ? ` | render=${resolvedIconState}` : "";
  const wieldedText = state.wielded ? " | wielded=on" : "";
  const baselineText = shouldUsePropSimulation()
    ? ` | baseline=${state.propPreset === "custom" ? "direct prop" : state.propPreset}`
    : " | baseline=raw iconstate";
  dom.spriteSourceStatus.textContent = `DMI loaded: ${selected.name}${resolvedStateText} | frames=${selected.frames} | dirs=${selected.dirs} | using frame ${state.editor.sprite.frame} | side=${state.mirrored ? "mirrored" : "normal"}${wieldedText}${baselineText}`;
}
