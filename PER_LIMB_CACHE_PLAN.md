# Per-Limb Icon Cache System — Implementation Plan

**Related PR**: https://github.com/Azure-Peak/Azure-Peak/pull/6041

## Background

Azure-Peak currently uses a **mob-level single key** cache (`icon_render_key` string + `limb_icon_cache` static list). The key is incomplete — it's missing hair, markings, organ overlays, bodypart features, and HIDEBOOB state. This means `redraw=TRUE` must be passed everywhere to force correctness, which makes the cache effectively dead code (2% hit rate on live).

tgstation solved this in **PR #65523 ("Kapulimbs")** by moving to **per-bodypart keys**. Each limb generates its own cache key that includes everything baked into its visual output. Only limbs whose keys changed are rebuilt; unchanged limbs pull from the shared global cache.

## tgstation PR History

| PR | What It Did | Date |
|---|---|---|
| **#65523 (Kapulimbs)** | **Core change**: single `icon_render_key` → per-bodypart `icon_render_keys[body_zone]` | 2022-04 |
| #72734 | Added `/datum/bodypart_overlay` system with `generate_icon_cache()` | 2023-01 |
| #74076 | Added mob_height to key (fixed "melty humans" visual bug) | 2023-03 |
| #85137 | Consolidated external organs into `bodypart_overlay/mutant` | 2024-08 |
| #87215 | Auto-call `update_body_parts()` on overlay add/remove + `STOP_OVERLAY_UPDATE_BODY_PARTS` flag | 2024-10 |
| #89783 | Dedup cleanup, `update=FALSE` parameter to prevent cascading | 2025-03 |
| #63225 | Preference menu speedup (pre-Kapulimbs, but relevant benchmarks: 2-7x faster) | 2021-12 |

## Current Azure-Peak Cache Key Gaps

Things baked into `get_limb_icon()` output but **NOT in `icon_render_key`**:

| Component | Where Stored | Impact If Missing |
|---|---|---|
| **Markings + colors** | `bodypart.markings` dict | Different markings = same cache = wrong visual |
| **Visible organs** | `owner.visible_organs` list | Different eyes/ears = same cache = wrong visual |
| **Organ accessory types** | `organ.accessory_type` | Different eye styles = same cache = wrong visual |
| **Organ colors** | `organ.color`, `organ.accessory_colors` | Different eye colors = same cache = wrong visual |
| **Bodypart features** | `bodypart.bodypart_features` list | Different hair = same cache = **BALDING BUG** |
| **Feature accessory types + colors** | `feature.accessory_type`, `feature.accessory_colors` | Hair style/color mismatch |
| **HIDEBOOB state** | Clothing `flags_inv` check | Female chest wrong with/without covering |
| **animal_origin** | `bodypart.animal_origin` | Monkey limbs vs human = same cache |
| **prosthetic_prefix** | `bodypart.prosthetic_prefix` | Different prosthetic visuals = same cache |

## Implementation Plan

### Phase 1: Per-Limb Key Generation (Core Change)

**1.1. Replace `icon_render_key` with `icon_render_keys`**

In `carbon_defines.dm`, change:
```dm
// OLD:
var/icon_render_key = ""
var/static/list/limb_icon_cache = list()

// NEW:
var/list/icon_render_keys = list()
var/static/list/limb_icon_cache = list()
```

**1.2. Add `generate_icon_key()` to `/obj/item/bodypart`**

New proc on bodypart that generates a key for THIS limb only:
```dm
/obj/item/bodypart/proc/generate_icon_key()
    . = list()
    . += body_zone
    . += (status == BODYPART_ORGANIC) ? "organic" : "robotic"
    // digitigrade
    switch(use_digitigrade)
        if(FULL_DIGITIGRADE)
            . += "digi_full"
        if(SQUISHED_DIGITIGRADE)
            . += "digi_squash"
    if(rotted)
        . += "rotted"
    if(skeletonized)
        . += "skeletonized"
    if(animal_origin)
        . += animal_origin
    // Species + color (from owner)
    if(owner)
        var/mob/living/carbon/human/H = owner
        . += H.dna.species.limbs_id
        if(should_draw_greyscale)
            . += skin_tone || species_color || mutation_color || "uncolored"
        . += H.gender
        . += H.age
    // Markings
    if(markings)
        for(var/key in markings)
            . += "m[key][markings[key]]"
    // Bodypart features (HAIR, etc.)
    if(bodypart_features)
        for(var/datum/bodypart_feature/F as anything in bodypart_features)
            . += "f[F.accessory_type][F.accessory_colors ? jointext(F.accessory_colors, ",") : ""]"
    // Visible organs on this zone
    if(owner)
        for(var/obj/item/organ/O as anything in owner.visible_organs)
            if(check_zone(O.zone) == body_zone)
                . += "o[O.type][O.color][O.accessory_type][O.accessory_colors ? jointext(O.accessory_colors, ",") : ""]"
    // HIDEBOOB (chest only)
    if(body_zone == BODY_ZONE_CHEST && owner)
        var/mob/living/carbon/human/H = owner
        if(H.wear_armor?.flags_inv & HIDEBOOB || H.wear_shirt?.flags_inv & HIDEBOOB || H.cloak?.flags_inv & HIDEBOOB)
            . += "hideboob"
    // Husk
    if(owner && HAS_TRAIT(owner, TRAIT_HUSK))
        . += "husk"
    return jointext(., "-")
```

**1.3. Head override for hair-specific data**

```dm
/obj/item/bodypart/head/generate_icon_key()
    . = ..()
    // Add head-specific visual data
    // lip_style, facial hair, etc. if applicable
```

**1.4. Rewrite `update_body_parts()`**

```dm
/mob/living/carbon/human/update_body_parts()
    var/list/needs_update = list()

    // Phase 1: Check each limb's key
    for(var/obj/item/bodypart/BP as anything in bodyparts)
        BP.update_limb()
        var/old_key = icon_render_keys?[BP.body_zone]
        var/new_key = BP.generate_icon_key()
        icon_render_keys[BP.body_zone] = new_key
        if(new_key != old_key)
            needs_update += BP

    // Early return if nothing changed
    if(!length(needs_update))
        return

    // Phase 2: Build overlay list
    remove_overlay(BODYPARTS_LAYER)
    var/list/new_limbs = list()
    for(var/obj/item/bodypart/BP as anything in bodyparts)
        var/key = icon_render_keys[BP.body_zone]
        if(BP in needs_update)
            // Cache miss: full rebuild
            var/list/limb_icons = BP.get_limb_icon()
            limb_icon_cache[key] = limb_icons
            new_limbs += limb_icons
        else
            // Cache hit: pull from static cache
            var/cached = limb_icon_cache[key]
            if(cached)
                new_limbs += cached
            else
                // Safety fallback: rebuild if cache lost
                var/list/limb_icons = BP.get_limb_icon()
                limb_icon_cache[key] = limb_icons
                new_limbs += limb_icons

    if(length(new_limbs))
        overlays_standing[BODYPARTS_LAYER] = new_limbs
    apply_overlay(BODYPARTS_LAYER)
    update_damage_overlays()
```

### Phase 2: Remove `redraw=TRUE` Everywhere

Once the key is complete and correct, ALL `redraw=TRUE` calls can be converted to normal calls:
- Line 63: `update_hair()` → `update_body_parts(TRUE)` → `update_body_parts()`
- Line 901: `update_inv_wear_suit()` → same
- Line 953: `update_inv_wear_mask()` → same
- Line 1226: `update_inv_shirt()` → same
- Line 1281: Female-specific `update_body_parts(redraw = TRUE)` → remove entirely
- Line 1354: Female-specific `update_body_parts(redraw = TRUE)` → remove entirely

The `redraw` parameter can be removed from the proc signature entirely.

### Phase 3: Invalidation for Preview Dummy

The preview dummy issue is solved automatically:
- Each `copy_to()` changes species, hair, organs → keys change → cache misses → full rebuild
- No `redraw=TRUE` needed, no `icon_render_key = null` hack needed
- The per-limb keys correctly detect that the dummy's features changed

### Phase 4: Delete Dead Code

- Remove `generate_icon_render_key()` (both carbon and human overrides)
- Remove `load_limb_from_cache()` (both carbon and human overrides)
- Remove `icon_render_key` instance var from `carbon_defines.dm`

## Testing Strategy

### Visual Correctness Tests (Multi-Key Required)

1. **Preview Dummy Race Condition**
   - Connect 2+ clients simultaneously
   - Both open character creator
   - Set different species, skin tones, hair styles
   - Rapidly toggle settings on both
   - Verify: No feature mixing between players' previews

2. **Balding Bug**
   - Create male character with hair
   - Equip/unequip armor and shirt
   - Verify: Hair stays visible throughout

3. **HIDEBOOB Correctness**
   - Create female character
   - Equip shirt with HIDEBOOB → verify chest covered
   - Remove shirt → verify chest uncovered
   - Equip armor with HIDEBOOB → verify chest covered
   - Remove armor → verify chest uncovered

4. **Markings Persistence**
   - Create character with body markings
   - Equip/unequip clothing
   - Verify markings remain correct after each change

5. **Organ Overlay Correctness**
   - Change eye color/style in character creator
   - Verify eyes render correctly
   - Change species → verify organ overlays update

6. **NPC Spawn Correctness**
   - Boot Dun World
   - Walk around, inspect various NPCs
   - Verify no bald NPCs, no missing features

### Performance Tests

1. **Stress Test (300 mobs, 50/50 gender)**
   - Before: Capture profile with old system
   - After: Capture profile with per-limb cache
   - Compare: `update_body_parts` calls, `get_limb_icon` calls, total time

2. **Preview Performance**
   - Loop `copy_to` 20x with species change
   - Compare before/after

3. **Live Profile**
   - Full round profile
   - Compare cache hit rate (should be dramatically higher than 2%)

## Risk Assessment

- **Low risk**: Per-limb key generation is purely additive — it generates MORE key data, not less
- **Medium risk**: Rewriting `update_body_parts()` flow changes core rendering path
- **Low risk**: Removing `redraw=TRUE` — safe IF keys are correct (which is the whole point)
- **Mitigation**: Multi-key visual testing before any live deployment

## Files Modified

1. `code/modules/mob/living/carbon/carbon_defines.dm` — `icon_render_key` → `icon_render_keys`
2. `code/modules/mob/living/carbon/update_icons.dm` — base carbon `update_body_parts`, remove `generate_icon_render_key`, `load_limb_from_cache`
3. `code/modules/mob/living/carbon/human/update_icons.dm` — human override `update_body_parts`, remove human `generate_icon_render_key`, `load_limb_from_cache`, remove all `redraw=TRUE`
4. `code/modules/surgery/bodyparts/_bodyparts.dm` — add `generate_icon_key()` proc + head override
5. `code/modules/mob/living/carbon/human/update_icons.dm` — `regenerate_icons()` clear `icon_render_keys` instead of `icon_render_key`
