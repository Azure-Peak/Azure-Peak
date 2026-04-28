# Auto-Import Feature — Implementation Handoff

## Overview

Adds a daily "auto-import" mechanic to Azure Peak's economy. The Crown's Purse automatically tops up selected goods each in-game day, reducing Steward micromanagement for tedious basics. Four goods (**coal, wood, grain, iron**) are auto-imported by default. Every other good can be opt-in subscribed through a dedicated Auto-Import tab on the Nerve Master.

Auto-import can *lose* the Crown money (unlike auto-export, which only converts surplus). Therefore visibility, purse-floor guards, and price-cap guards are all essential to the design.

## Scope

- **In scope**: defines, subsystem state on `SStreasury`, daily-tick proc, SCOM announcements, Nerve Master Auto-Import tab with per-good toggles and daily-spend readout, kill switch for the default-on goods.
- **Out of scope**: per-good tunable volume/price sliders (defaults only for v1), admin verbs, round-to-round persistence (fresh defaults each round), integration with Alderman warrant (auto-import draws from Purse only, never from warrant).

## Key files

| File | Purpose |
|---|---|
| `code/__DEFINES/economy.dm` or new `code/__DEFINES/auto_import.dm` | Define list of essentials + tunables |
| `code/controllers/subsystem/rogue/treasury.dm` | Subsystem state, daily tick proc |
| `code/modules/roguetown/roguemachine/steward/steward.dm` | Existing `handle_trade_import` / Trade Scroll patterns; use as reference |
| `code/controllers/subsystem/rogue/economy/economy.dm` | Has `compute_import_unit_price` and `manual_import` — auto-import should reuse these, not reimplement |
| `tgui/packages/tgui/interfaces/StewardTrade/` | Existing Steward trade UI. Add a new `AutoImport.tsx` view or an "Auto-Import" tab alongside. |

## Mechanics spec

### Daily tick

Fires once per daily tick (hook into the existing `SSeconomy` daily-tick handler — search for `daily_tick` in `economy.dm`).

For each good in the **auto-import check list** (essentials + Steward-subscribed opt-ins):

1. If the good is an essential and `auto_import_disabled[good_id]` is TRUE (Steward killed it), skip.
2. If the good is non-essential and `auto_import_subscriptions[good_id]` is not TRUE, skip.
3. Look up the stockpile entry for `good_id`. If `stockpile_amount >= AUTO_IMPORT_FLOOR`, skip.
4. Pick the **cheapest producing region** for that good (iterate `GLOB.economic_regions`, find the one with `produces[good_id]` set and lowest current unit price).
5. Compute unit price via `SSeconomy.compute_import_unit_price(good_id, region, unit_index)` for each of the `AUTO_IMPORT_BATCH` units, starting at the region's `produces_today` index.
6. If the highest unit price in the batch exceeds `AUTO_IMPORT_MAX_UNIT_PRICE`, skip (shortage protection).
7. Compute `total_cost`. If `SStreasury.discretionary_fund.balance - total_cost < auto_import_purse_floor`, skip.
8. Burn `total_cost` from `discretionary_fund`, deposit `AUTO_IMPORT_BATCH` into the stockpile entry. Decrement `region.produces_today[good_id]` accordingly.
9. `scom_announce("Azure Peak imports [BATCH] [tg.name] from [region.name] for [total_cost] mammon. (auto)")`.
10. The Nerve Master machine also `say()` the same line locally (match the manual-import pattern established in `steward.dm`).
11. Accumulate in `SStreasury.auto_import_daily_spent`.

### Reset

- `auto_import_daily_spent` resets to 0 at the start of the daily tick, before the per-good loop runs.
- Log the day's total to `SStreasury.auto_import_daily_history` (list, capped at 7 entries for display).

### Kill switch

"Disable All Auto-Import" button in the UI:
- Sets `auto_import_disabled[good_id] = TRUE` for each of the four essentials.
- Sets `auto_import_subscriptions` to empty list.
- Single-click reversibility: no auto-import fires for any good until re-enabled.

## Defines

```dm
// code/__DEFINES/auto_import.dm (or add to economy.dm)

/// Essentials that auto-import by default. Steward can disable individually via the
/// Auto-Import tab. These were chosen as pure consumables with stable prices and
/// heavy ongoing demand; auto-importing them reduces Steward busywork.
#define AUTO_IMPORT_ESSENTIALS list(\
	TRADE_GOOD_COAL,\
	TRADE_GOOD_WOOD,\
	TRADE_GOOD_GRAIN,\
	TRADE_GOOD_IRON_ORE\
)

/// Floor: if stockpile holds fewer than this many units of an auto-imported good,
/// the next daily tick tops it up by AUTO_IMPORT_BATCH.
#define AUTO_IMPORT_FLOOR 10

/// Units imported per daily tick per eligible good.
#define AUTO_IMPORT_BATCH 5

/// Per-unit price cap. If the cheapest region's import price exceeds this, skip -
/// auto-import will not buy during a shortage spike. Steward must manually import
/// if they judge the high price worth paying.
#define AUTO_IMPORT_MAX_UNIT_PRICE 15

/// Purse floor specifically for auto-import. Separate from stockpile_purchase_floor
/// so auto-import can be more conservative: auto-import will not spend if it would
/// drop the Purse below this value.
#define AUTO_IMPORT_PURSE_FLOOR_DEFAULT 1500
```

## Subsystem state (SStreasury)

```dm
// Added to /datum/controller/subsystem/treasury:

/// Per-good opt-in subscriptions for non-essentials. good_id -> TRUE.
/// Essentials bypass this - they're governed by auto_import_disabled instead.
var/list/auto_import_subscriptions = list()

/// Per-essential opt-out. good_id -> TRUE means "this essential will NOT auto-import."
/// Empty by default (all essentials active).
var/list/auto_import_disabled = list()

/// Cumulative mammon spent by auto-import today. Reset at daily tick.
var/auto_import_daily_spent = 0

/// Last 7 days' spend. Each entry: list("day" = N, "spent" = N, "lines" = list of strings).
var/list/auto_import_daily_history = list()

/// Steward-settable purse floor for auto-import. Defaults to AUTO_IMPORT_PURSE_FLOOR_DEFAULT.
/// Can be raised or lowered via the Auto-Import tab.
var/auto_import_purse_floor = AUTO_IMPORT_PURSE_FLOOR_DEFAULT
```

## Procs to add on SStreasury

```dm
/datum/controller/subsystem/treasury/proc/is_auto_import_active(good_id)
	// Returns TRUE if good_id is currently set to auto-import.
	if(good_id in AUTO_IMPORT_ESSENTIALS)
		return !auto_import_disabled[good_id]
	return !!auto_import_subscriptions[good_id]

/datum/controller/subsystem/treasury/proc/set_auto_import(good_id, active)
	// Flip the right map depending on essential vs non-essential.
	if(good_id in AUTO_IMPORT_ESSENTIALS)
		if(active)
			auto_import_disabled -= good_id
		else
			auto_import_disabled[good_id] = TRUE
	else
		if(active)
			auto_import_subscriptions[good_id] = TRUE
		else
			auto_import_subscriptions -= good_id

/datum/controller/subsystem/treasury/proc/kill_switch_auto_import()
	// Disable everything - essentials opt out, subscriptions cleared.
	for(var/good_id in AUTO_IMPORT_ESSENTIALS)
		auto_import_disabled[good_id] = TRUE
	auto_import_subscriptions.Cut()

/datum/controller/subsystem/treasury/proc/run_auto_import_tick()
	// Called from SSeconomy's daily tick handler.
	// See "Daily tick" section above for full algorithm.
	auto_import_daily_spent = 0
	var/list/today_lines = list()
	// ... iteration per Daily tick spec ...
	// On success: append to today_lines, update auto_import_daily_spent.
	auto_import_daily_history += list(list(
		"day" = GLOB.dayspassed,
		"spent" = auto_import_daily_spent,
		"lines" = today_lines,
	))
	if(length(auto_import_daily_history) > 7)
		auto_import_daily_history.Cut(1, length(auto_import_daily_history) - 7 + 1)
```

Hook `run_auto_import_tick()` into the existing SSeconomy daily tick, **after** `produces_today` / `demands_today` are reset (so auto-import sees fresh daily pace numbers). Search for `daily_tick` in `code/controllers/subsystem/rogue/economy/economy.dm`.

## UI — Auto-Import tab

New tab alongside the existing Trade Scroll UI on the Nerve Master. Reached from the steward machine's primary menu.

### TGUI view layout

```
┌──────────────────────────────────────────────────────┐
│  AUTO-IMPORT SUBSCRIPTIONS                           │
│  Today's spend: 42m across 2 imports                 │
│  Purse floor: 1500m [Adjust]                         │
│  [Disable All Auto-Import]                           │
├──────────────────────────────────────────────────────┤
│                                                      │
│  ESSENTIALS (on by default)                          │
│  ──────────────────────────                          │
│  [X] Coal       (stock: 24, target: 10)              │
│  [X] Wood       (stock: 18, target: 10)              │
│  [X] Grain      (stock: 5,  target: 10)  ← will top up
│  [X] Iron Ore   (stock: 15, target: 10)              │
│                                                      │
│  OTHER GOODS                                         │
│  ────────────                                        │
│  [ ] Stone                                           │
│  [ ] Salt                                            │
│  [ ] Copper Ore                                      │
│  [ ] Tin Ore                                         │
│  [ ] Cloth                                           │
│  [ ] ...                                             │
│                                                      │
├──────────────────────────────────────────────────────┤
│  RECENT ACTIVITY (last 7 days)                       │
│  Day 5: 42m  (2 imports)                             │
│  Day 4: 88m  (4 imports)                             │
│  Day 3: 0m   (skipped - price spike)                 │
└──────────────────────────────────────────────────────┘
```

### Backend data for the tab

`ui_data` returns:

```dm
list(
	"today_spent" = SStreasury.auto_import_daily_spent,
	"purse_floor" = SStreasury.auto_import_purse_floor,
	"essentials" = list(
		list("good_id" = TRADE_GOOD_COAL, "name" = "Coal", "active" = SStreasury.is_auto_import_active(TRADE_GOOD_COAL), "stock" = SSeconomy.find_stockpile_by_trade_good(TRADE_GOOD_COAL)?.stockpile_amount || 0, "target" = AUTO_IMPORT_FLOOR),
		// ... wood, grain, iron_ore
	),
	"other_goods" = list(
		// For every TRADE_GOOD that is not an essential, has a trade_good entry, and has
		// at least one producing region (auto-import requires a source). Include:
		// good_id, name, active (from auto_import_subscriptions[good_id]).
	),
	"history" = SStreasury.auto_import_daily_history.Copy(),
)
```

### ui_act verbs

```
"toggle_auto_import" (params: good_id) -> SStreasury.set_auto_import(good_id, !is_auto_import_active(good_id))
"kill_switch"                          -> SStreasury.kill_switch_auto_import()
"set_purse_floor" (params: amount)    -> SStreasury.auto_import_purse_floor = CLAMP(amount, 0, 99999)
```

## SCOM output pattern

Match the existing manual-import pattern in `steward.dm`:

```
scom_announce("Azure Peak imports [BATCH] [tg.name] from [region.name] for [total_cost] mammon. (auto)")
// The Nerve Master also speaks the line locally.
if(SStreasury.steward_machine)
	SStreasury.steward_machine.say("Azure Peak imports [BATCH] [tg.name] from [region.name] for [total_cost] mammon. (auto)")
```

Suppressed-skip cases should NOT announce (would spam SCOM daily with "skipped due to price spike" noise). The UI history readout carries that information instead: entries can include `"lines"` like `"Grain: skipped (price 22m exceeds cap 15m)"` for display-only, not broadcast.

## Existing conventions to follow

- **Pop-scaled quantities** — `AUTO_IMPORT_BATCH = 5` is a raw value. Production/demand are pop-scaled but stockpile import quantities are not. Keep it as raw 5 units for predictability.
- **Mammon trade logging** — append auto-import spends to `SStreasury.defense_log` or a new `SStreasury.auto_import_log` if useful for round-end statistics. Not required for v1.
- **Dendor essence, gems, luxuries** — should NOT appear in the "other goods" list. Filter the trade_goods catalog by the existing economic_region `produces` entries; if no region produces a good, it can't be auto-imported.
- **Blockade interaction** — if the only producing region for a good is blockaded, auto-import should skip for that good (price doubles due to `BLOCKADE_IMPORT_MULT`). The max-price cap already handles this implicitly, but a comment in the loop is worth adding.

## Testing

Manual test plan:

1. Start a round, open Nerve Master → Auto-Import tab. Verify all four essentials show `[X]` active.
2. Wait for daily tick. Confirm SCOM announces: "Azure Peak imports 5 Coal from Daftsmarch for Nm. (auto)" plus similar for wood, grain, iron.
3. Confirm `today_spent` total matches the sum.
4. Disable Coal via toggle. Wait for next daily tick. Confirm only 3 of 4 imports fire.
5. Set purse floor to an arbitrary high value (say 99999) and confirm auto-import skips next tick due to purse-floor guard.
6. Simulate shortage event (admin fire) on Iron. Confirm iron auto-import skips due to price cap.
7. Click "Disable All Auto-Import". Confirm no tick fires anything.
8. Re-enable Coal from a fresh disabled state. Confirm it re-activates for the next tick.
9. Manually subscribe to Stone (not an essential). Confirm it joins the daily import rotation.

## Non-goals / v1 skip list

- Per-good adjustable batch size or price cap (ship with defaults; add v2 if Stewards demand it).
- Round-to-round persistence of subscriptions (always fresh each round).
- Alderman warrant interaction (out of scope; auto-import is Purse-only).
- Admin panel hooks for auto-import (Steward-only feature in v1).
- Auto-import triggering on map-start (first tick should fire normally, not at roundstart initialize).

## Rollback plan

If the feature is unpopular:

1. Set `AUTO_IMPORT_ESSENTIALS` to an empty list. Four essentials become opt-in only.
2. If still unpopular: comment out the hook call in SSeconomy's daily tick. Feature goes dormant.
3. If removing entirely: the subsystem state vars are additive; deleting them is clean.

Default-on for essentials is the main reversibility risk. The "Disable All Auto-Import" button in the UI is the in-round mitigation (players hate a feature: one click, done). The rollback plan above handles the "remove the feature forever" case.

## Estimated effort

- Defines: 5 minutes.
- Subsystem state + procs: 30 minutes.
- Daily tick integration: 20 minutes (must identify the existing hook and slot in cleanly).
- TGUI tab: 60 minutes (new view, wiring, styling to match existing trade UI).
- Testing + SCOM pattern matching: 30 minutes.

Total: ~2.5 hours for one agent to do end-to-end.

## Handoff notes to the agent

- Read `steward.dm`'s `handle_trade_import` before coding the auto-import proc — it's the reference for how burning, depositing, and announcing work. Do not re-implement trade logic; call `SSeconomy.manual_import` if its shape supports system-user (no human mob). If it requires a human mob, extract the guts into a shared proc.
- The stockpile datum list is iterated via `SSeconomy.find_stockpile_by_trade_good(good_id)` — see existing usage.
- Fresh Steward per round — subsystem state is per-round, not persistent. No migration code needed.
- TGUI: steward_trade has a pattern with BlockadeBanner and RegionsView. The Auto-Import view can live as a peer alongside these.
