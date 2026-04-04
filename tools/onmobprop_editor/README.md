# Onmobprop Editor

Standalone browser tool for inspecting a DMI iconstate, simulating the in-game on-mob transform path, and producing DM `list(...)` output for `getonmobprop()` sprite transformations. By Ryan180602 (with the use of AI assistance in `app.js`, `README.md` and mostly in `styles.css`)

## Run It

Open [index.html](index.html) in a browser.

If your browser blocks local file features, serve the folder with a simple static server:

```powershell
cd tools/onmobprop_editor
python -m http.server 8000 --bind 127.0.0.1
```

Then open `http://localhost:8000`.

## What The Tool Does

The editor has two main jobs:

1. Show the raw source sprite exactly as it exists in the DMI.
2. Show the simulated on-mob result after preset logic and prop values are applied.

This makes it useful both for checking how a sprite looks by itself and for tuning the transform values that make it line up in a mob's hands.

## Process

1. Click `Load DMI` and choose a `.dmi` from your filesystem.
2. Enter the iconstate you want to work on.
3. Leave `Type Preset` on `Custom` if you want to inspect the raw icon first.
4. Pick a preset when you want the preview to simulate the matching in-game pickup and in-hand transform path.
5. Toggle `Wielded` if you want to simulate the wielded version. When possible, the tool resolves this to the `iconstate1` sprite automatically.
6. Use the prop controls to adjust the sprite.
7. Switch `Input Mode` between `Delta` and `Actual` depending on whether you want to edit stored offsets or resolved final values.
8. Copy the generated DM `list(...)` output, or paste an existing list into the output box to import it.

The preview refreshes immediately after each prop change.

## Tool Sections

### Sprite Source

This section defines which sprite tile the editor is using.

- `Load DMI`: loads a local `.dmi` or `.png` file.
- `Iconstate`: selects the source state to preview. If DMI metadata exists, autocomplete suggestions are shown.
- `Sprite Size`: selects 32x32 or 64x64 cropping when metadata is missing or when manual sheet cropping is needed.
- `Frame / Tile`: chooses the frame index for metadata-backed states, or a raw 1-based tile index when metadata is missing.
- `Type Preset`: selects the in-code baseline used to simulate the in-hand transform chain for a broad item family.
- `Wielded`: simulates the wielded path and, where appropriate, swaps from `iconstate` to `iconstate1`.

### Prop Controls

This section edits the actual onmobprop values.

- `Input Mode: Delta`: the controls show additive adjustments on top of the selected preset baseline.
- `Input Mode: Actual`: the controls show the resolved final values that would be written into DM output.
- In `Custom`, `Delta` and `Actual` are effectively the same because there is no preset baseline underneath.
- Numeric fields correspond directly to the keys used in DM `list(...)` onmobprop data.

### Preview

This section renders the current sprite for all four facing directions.

- `Behind Layer`: previews the behind-hand render path instead of the front-hand path.
- `Mirrored Side`: previews the mirrored hand/path logic used for the opposite side.
- The preview uses bundled directional guide body PNGs so the overlay guide does not depend on browser-side DMI support.
- Each preview tile shows one facing direction and some lightweight metadata about the current render state.

### DM Output

This section is the copy/paste bridge back to the codebase.

- The textarea always shows the current resolved DM `list(...)` output.
- Pasting a valid DM `list(...)` block imports those values back into the active prop editor state.
- `Copy list(...)` copies the current output for use in DM source.

## Preview Behavior

The editor works in two different preview modes.

### Raw Icon Preview

When `Type Preset` is `Custom` and the values are still at their custom defaults, the preview shows the raw icon centered on the preview stage with no onmob transform math applied.

### Simulated On-Mob Preview

When a preset is selected, or when custom values differ from the default raw state, the preview simulates the in-game on-mob transform path.

At a high level, the simulated preview does this:

1. Resolve the source iconstate.
2. Use `iconstate1` for wielded mode when that state exists.
3. Apply the directional helper mask.
4. Apply BYOND-style flip and turn values.
5. Apply shrink scaling.
6. Apply directional x/y offsets and layering.
7. Render the result onto the 64x64 in-hand preview stage.

The goal is to approximate the real pickup and in-hand rendering path closely enough for tuning `onmobprop` values before copying them into DM.

## Notes

- If the DMI has metadata, the iconstate field gets autocomplete suggestions.
- Pasting a DM `list(...)` block into the output field updates the prop controls and preview.
- The preview currently uses the selected iconstate's chosen frame and applies the facing transforms inside the editor.
- If the DMI has no metadata, `Frame / Tile` is treated as a 1-based tile index into the sheet.
- This tool is designed around in-hand `onmobprop` tuning, not every possible BYOND icon pipeline edge case.
- If the tool says the DMI has no Description metadata, iconstate lookup is unavailable for that file, but manual cropping still works with the selected 32x32 or 64x64 size.
