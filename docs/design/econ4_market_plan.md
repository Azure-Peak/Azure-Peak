# Econ 4 - Market, Deals and Caravans

Working branch: `tiny-econ-2`, cut from `tiny-econ` at 4c2896f070e.

Canonical design: the gdoc "Economy 4 Design & Planning Doc" (id 1dzCM71a3ubjdslqEJlSgsuZ9x3UZd93OyeC_fYHO0Zc), section **Ansari Self Note Redesign Nov 14**. The older gdoc sections are stale. The user rewrites them over time, so never argue from them. Where this file and the self note differ, this file holds the newer call. Each such call is dated.

## How to work on this

- Run `git branch --show-current` before any code edit. The user works on other branches in the same checkout.
- Never stage, commit or push. The user compiles. Never run builds. DM snippets can run through `C:/tmp/dmeval/dmeval.sh`.
- Build one compilable slice at a time, then stop for review.
- Read the day through `ECONOMY_DAY`, never raw `GLOB.dayspassed`, in economy code. Setup runs at day 0 and the first dawn lands on day 1.
- Write zero code comments. Tuning numbers are `#define`s in `code/__DEFINES/economy/internal_trade_and_quests.dm`. Values that differ per subtype are vars, not getter procs. Never use the `foo:bar` operator.
- Put each slice's player text in one fake `.dm` sheet in `docs/design/` (for example `econ4_requests_text.dm`). The user rewrites it there. Apply their edits back to the code.
- Don't build interim views that won't be kept. Never justify a choice by how the game plays between slices. Only the end state matters.
- Don't invent lore. Region and faction names come from the wiki and the lore gdoc.
- Never propose rewards or profit measures for the Steward. Taking a loss on purpose, such as importing food in a shortage, is part of the role.

## What is built

On `tiny-econ` and carried into `tiny-econ-2`:

- **Decimal prices.** Prices move in tenths, balances in hundredths, and only coins are whole.
- **The Market and royal stock are split.**
  - The Market has nine price bands. Glut and Shortage only happen during events.
  - Anti-flip rule: each unit is priced at the stock it leaves behind.
  - The bid is 0.75 of the ask.
  - Keep roles sell into royal stock unpaid.
  - The Steward buys from and sells to the Market with treasury money.
- **Regions.**
  - There are 17 regions, built from region types times size. The types are in `code/modules/economy/regions/types/`.
  - There are 4 routes and 8 subroutes (`routes.dm`).
  - A region never demands a good it produces.
- **Raids.** Blockades are keyed by subroute. A raid gathers mid round and lands at the next dawn.
- **Market dae** (`market_day.dm`).
  - At dawn, stock moves toward target by the larger of half the gap or a quarter of the target.
  - The step shrinks by the share of producer regions that are raided.
  - It skips goods in a Glut or Shortage.
- **Slice 1 (3de136e139f).** Retired direct trade on the DM side: manual and auto import and export, autoexport, the Steward policy, stockpile limits and the export ledger account. Crown imports are untouched.
- **Slice 2 (41c370d9ffb).** Retired direct trade in the TGUI: the Advanced, AutoImport and TradeModal views. The Market tab now shows royal stock plus Market buy and sell. The Regions tab is read only and sits outside the sequestration overlay.
- **Slice 3 (4c2896f070e).** Cut the daily region lists, Urban rotation and capacity procs. The Regions tab lists goods without numbers. The seasonal lists and `supply_sources`/`demand_sources` stay for the deal rolls.

Elsewhere:

- **Shelved work:** branch `econ4-backup` (f4f4c938e58) holds the old caravan planner, route trade, goods groups and the old docs. It is for reference only. The new design does not reuse its screens.
- **`stash@{0}` "econ4 step 3a - market target sizing"** is the old 25 to 40 clamp from slice 3-3b, already applied. It is safe to drop, but leave that to the user.

## The design

### Market depth (decided 2026-11-16)

- The Market is no longer bottomless, for anyone.
- Past zero it keeps selling at the top band down to a depth of **half the target**, then it is sold out. The top band is Very Scarce, or Shortage during an event.
- The depth is zero when no producer region is open, so raids still cause hard stockouts.
- The Market dae and deposits refill it from below zero.
- The Crown gets no special rules. If the Crown buys out the iron, the town can take that up with the Crown.

### Deals

- Each region hosts at most **one request and one offer** at a time (decided 2026-11-16). A four region route shows 8 deals and 4 tributes.
- **Requests** replace standing orders:
  - Each request asks for one good. Package orders are removed.
  - The good comes from the region's `demands`, which already excludes goods the region produces.
  - Equipment and potion requests roll one item from the existing lists.
- **Rolling:**
  - 4 requests roll each dae across all regions, plus 0.05 per player (scales from zero, decided 2026-11-16).
  - At most 13 requests are open at once.
  - Each request lasts 2 dae. Expiries are staggered, as today.
- **Size and pay:**
  - Each request is worth about 200 to 400 at base and pays 2.5 times that.
  - Single crop requests may need more than the Market holds, so the Steward has to coordinate growing.
  - The low pop bonus is dropped. Quality pay stays.
- **Partial delivery (decided 2026-11-16):**
  - A request reads "up to N units at P each".
  - Each delivery is paid per unit at the full rate.
  - The rest stays open until the request expires. There is no haircut.
- **Extension:** 200 Pledge extends a request by 1 dae. The Nerve Master reports it as sending a zad.
- **Offers** mirror requests. Each is one good from the region's `produces`, priced at 0.9 of Steady.
- **Petitions** replace a deal in a random region.
- **Raided regions** keep today's behaviour until slice 13.
- **Urgent orders** are removed (user 2026-11-17). Shortages no longer post a request.

### Caravans

- **Fleet:** 4 caravans at round start, plus 1 a dae, up to 8.
- **Sending:**
  - A caravan goes onto a route and carries **1 request, 1 offer and 1 tribute** from regions on that route.
  - It is committed once sent: request goods leave royal stock and the offer price is paid.
  - Everything resolves at the next dawn, with one tally a dae (decided 2026-11-16).
  - A caravan can go out for tribute alone.
- **Tribute:**
  - Each region has hand set tribute goods that are unrelated to its types.
  - Each pickup is worth 100 to 200m, the same in every region.
  - It scales from 1x to 2x between 60 and 120 players.
  - It can be picked up once per region per dae.
  - **Gifts** come with tribute. They are hand set consumables with low mechanical value and no resale value.
- **Escort and raids:**
  - The escort fee is paid per subroute: 200m, then 100m more each dae.
  - Deals in a raided region are half size.
  - An escorted subroute counts as open for the Market dae.
- **Crown imports (user 2026-11-17):** regional imports are removed outright. They duplicated Goldface, which sells every farm animal, tools, potions, alcohol, arms and armour. The engineers craft the rotation parts. Only the Keyring Set and the zad packs stay, bought at the Nerve Master.
- **Special Commission (user 2026-11-17):** retinue kits come from the Royal Armoury, not a region. Each kit is priced like a Goldface pack: its contents' engine prices times 1.5. It arrives at the warehouse on a fixed timer, with 2 per kit a dae. It has its own Steward tab.

### Later parts

- **Estates:**
  - Nobles pick a region, defaulting to Kingsfield.
  - Each dae pays 15m plus an item worth 15 to 20m (one steel ingot is the yardstick). Councilors and heirs get double.
  - While the subroute is raided, estate income becomes a backlog that arrives once the raid is cleared. Escort doesn't bypass this.
- **Events:** regional events are scrapped (user 2026-11-19). Daily gluts and shortages are grouped by who answers them, as in 16b.
  - 2 to 3 daily events roll, and the oldest is displaced first.
  - Nothing forecasts events except Divination's noisy omens.
- **Market dae rework:** the producer share method changes, and rentals arrive.
  - Renting out a caravan earns 50m a dae, adds 10% to the correction and locks the caravan for at least a dae.
  - Past 100% correction, a second tick runs at midday.
  - Rentals only raise the 50% gap rate. The 25% floor stays.

### Food pricing (open 2026-11-21)

**Problem.** The Innkeeper and the other food trades have thin margins or none. The 1m coin can't express a cheap good. Tenths fixed that at the Market, but then raw food sells at 0.1 to 0.2m (jackberries), so anyone can just eat berries and the tavern loses its point.

**Demands (user 2026-11-21).** They pull against each other:

1. Food is worth enough to soilsons that farming makes money.
2. Food is cheap enough to the Innkeeper to sell meals cheap enough for people to eat, at a profit or at least net zero.
3. Food bought raw and cooked by a role outside the food trades, without the virtue, is worse than finding an Innkeeper when one is around. The user suggested scaling buff duration, at least.

**Ruled out (user 2026-11-21):**

- Multiplying every price by 10: too drastic, and players would react badly.
- A higher price or a purchase cap for adventurers, for example 2x, or rounding their buys up to whole zennies. It brute forces the issue but is mean spirited. It also makes the Innkeeper load bearing, and the Innkeeper is often absent. Player trade must stay beneficial, never required.
- Free food for the Innkeeper that can't be resold. The `unsellable` component only carries through smelting, so every cooking path would need it. It also removes the soilson to Innkeeper trade.

**Facts (checked 2026-11-21):**

- Engine prices: egg 2, wheat 3, cheese 3, steak 4, flour 4, cooked sausage 7. Iron ingot 10, iron sword 15, chainmail 21, plate cuirass 42.
- The engine prices a made good as its inputs times a markup over yield. Each step uses its inputs' derived prices, so the markup stacks through a dish.
- The Market buys raw and single step food only: meat, dairy, eggs, fruit, grain, vegetables, fish, cooked sausage, salami and dried fish. Meals can't be sold to it, so an Innkeeper's meals go to players or ships.
- Dishes in `modular/Neu_Food` carry their buff as `eat_effect`, and it applies only once the whole dish is eaten. There are four tiers:
  - snack, +1 WIL for 8 minutes;
  - great snack, +1 CON and +1 WIL for 10 minutes;
  - meal, +1 CON for 30 minutes;
  - great meal, +1 CON and +1 WIL for 30 minutes.
- Raw food grants no buff, apart from the sweet buff on some produce.
- Fare quality only matters to nobles, burghers and courtiers. Below their fare they take stress and lose the dish buff. Adventurers feel nothing from fare.
- A loaf is 2 flour and water. It holds 15 nutriment (a meal and a quarter) in 6 slices. The user puts a loaf at 10 to 15m, against 60 to 300m for an armor upgrade.
- A good that no region produces has no Market supply (`market_has_supply()`). Its depth is zero and the Market dae never restocks it, so its stock only comes from player sales.
- The Innkeeper and the Cunning Provisioner virtue both carry `TRAIT_HOMESTEAD_EXPERT`. So do the labor roles.

**Proposed direction (not approved).** The Innkeeper's edge is what the kitchen makes from the same inputs. It comes neither from cheaper inputs nor from dearer prices for others.

- **One price.** Food prices stay where demand 1 needs them, and everyone buys at the same price.
- **Double portion (user lean 2026-11-21).** A cook with a food trade trait gets two of each dish from the same inputs. The Innkeeper's cost per portion halves (demand 2) and the soilson's price doesn't move (demand 1). Anyone else cooks at one portion.
  - **Only buffed dishes double.** The Market's made foods (cooked sausage, salami, dried fish) have no `eat_effect`, so they never double.
  - **Ships and the Market are the Innkeeper's niche (user 2026-11-21).** Doubled meals may be sold to ships and to the Market. For anyone else, cooking for the Market loses money: one portion sold at 0.75 of the ask. So the niche stays with the trait.
  - **Meals at the Market.** Meals have no Market entries today, so this needs new ones. No region produces meals, so the Market only holds what players sold it. Adventurers can then buy the Innkeeper's meals while the Innkeeper is away: Innkeeper to Market to adventurer, the one way economy shape. Market targets cap how much the Innkeeper can sell in a dae.
  - **Rot.** Market stock is a count, and a bought meal spawns fresh. The Market then works as a larder for meals.
  - **No compounding.** A dish made from a doubled dish doesn't double again, for example a doubled loaf sliced into sandwiches. Proposed: stamp doubled results and skip any step that consumes one.
  - **Hooks.** `initialize_cooked_food` covers the oven, hearth, firebowl and campfire, plus the container craft oven, pan and pot. The cook is `lastuser` on ovens and smokers, the user at fires and the initiator in container craft. Table crafting and slicing are separate paths.
  - **Trait.** `TRAIT_HOMESTEAD_EXPERT` is too broad, because every labor role has it. Proposed: a new trait on the Innkeeper, the Cook and the Cunning Provisioner virtue, plus the Tapster if kegs are included.
- **Buff.** Dishes already grant their buff. The cook's skill would set its duration, stamped on the dish when it is cooked. A dish from an unskilled cook still feeds and buffs, just for less time (demand 3).
- **No dependence.** Cooking for yourself costs what it costs today. Nothing gets worse when the Innkeeper is absent. The tavern just gives more food and a longer buff for the money.
- **Cheap raw food is fine.** Berries at 0.2m feed but grant nothing, so they stop competing with a meal. Price can't stop foraging anyway.
- **Bounded.** Market targets and bands bound what the Innkeeper sells to the Market each dae. Ship victualling lines are capped per line.
- **Separate fix.** A flat amount per food step could replace the stacking markup, so dishes stop climbing toward gear prices. Ship victualling is where dish prices are read.

**Not enough alone (user 2026-11-21).** Doubling halves the cost of tavern food only, and the gap to gear needs more than that.

- Cost per meal is the staple price times the staples per meal, over the portions. The three terms multiply.
  - **Staple price.** Lowering it cuts the soilson's pay per unit. Only more volume (yields, Market targets) makes that up, which reaches into the agricultural overhaul.
  - **Staples per meal.** Fewer staples per dish, or more nutrition per dish. No price moves. The soilson's pay doesn't move either, because the Market buys at its bid however the food is eaten. It lowers the cost for every cook, and the trait keeps the tavern's 2x lead.
  - **Portions.** The double portion. Raising it past 2x is the only lever that leaves self cooks where they are, but it widens the Innkeeper's Market margin.
- Proposed: staples per meal plus the double portion. For example, a loaf from 1 flour costs about 5 to 7.5m cooked at home and 2.5 to 3.75m at the tavern. That is about 2 to 3m a meal, or 1:20 to 1:150 against an armor upgrade.
- Another order: pick a target cost per meal first, then set the staples per meal of each staple dish from it.

**Open:**

- Staples per meal: which dishes change, and whether by fewer inputs or more nutrition.
- Which meals get Market entries.
- Which roles and virtues carry the double portion trait.
- Whether table crafting and slicing double.
- Whether keg batches double.
- Whether buff duration by skill is still needed once portions double, and if so how much skill changes it.
- The tenths stay as built unless the direction changes.

## Slices

Status: slices 1 to 14 are committed except 7, which is parked (14 is 68618c03ccd). 14b (morning report removed) is committed as f5c0dd07058. Local Commission is committed (fddba083b6b). Slice 15 (estates) is committed as 6fe6d5fbc73. Slice 16 (daily events rework) is built; its regional part was removed 2026-11-20. 16b (events regrouped) is in review in the events Sheet, code not started. Slice 18 (Nerve Master cleanup) is queued.

### 4a - Market depth (built 2026-11-16)

- `MARKET_RATIO_OUT_OF_STOCK` -50 sits in the ratio ladder. `market_out_of_stock_level()` is minus half the target, or 0 when no producer region is open. `market_available()` is the stock left above that level.
- `buy_from_market` and `do_withdraw` clamp to `market_available()` and let stock go below zero.
- The shortage shock leaves a drained Market below zero (`min(market_stock, 0)`).
- `market_next_buy_change` returns a null price when the run ends in a sellout. `market_next_sell_change` counts from the real stock.
- Screens show the real stock, below zero included. The Detailed bar's Very Scarce section starts at the floor (`market_segments`). `sold_out` means at the floor. The Steward row carries `market_left` for the buy prompt.
- Text in `docs/design/econ4_market_text.dm`.

### 4b - Single good requests (built 2026-11-16)

What was built:

- `/datum/standing_order/request` holds one good. `SSeconomy.roll_standing_order` puts it into the region's weighted list next to the remaining templates at weight 6 (now `REQUEST_WEIGHT_GOODS`), because every region has Settlement and Settlement rolls Birthday Gift. The good comes from `request_goods(region)`: the region's `demands` with a stockpile entry, stockpile route and a price, weighted by demand volume.
- Size is `STANDING_ORDER_VALUE_MIN`/`MAX` (200/400) over `good_steady_price`. Petition tax now sits inside `compute_good_unit_payout`.
- 17 raw package templates are gone, along with tournament provisions and the pair system. Equipment, armor, potion and luxury templates still roll until slice 5.
- Petitions lost the removed templates. The Provisions category is gone until slice 7.
- `fulfill_order` delivers whatever is on hand, pays per unit, shrinks `required_items` and keeps the order open until it is empty. Urgent orders were removed on 2026-11-17, so every order counts toward the one per region limit (`region_order_count`).
- Text in `docs/design/econ4_requests_text.dm`.

Original spec:

- Remove the goods package templates in `code/modules/roguetown/roguestock/standing_order.dm`, the pair system (`pair_sibling_type`, `pair_id`, `pair_label`, `instantiate_standing_order_pair`) and `generate_item_mix` for raw goods.
- Keep the equipment, armor and alchemical templates working until slice 5 rewrites them.
- Leave the urgent path alone. If it breaks, flag it.
- New roll in `SSeconomy.daily_tick` (`economy.dm`):
  - Count = `4 + round(pop * 0.05)`, scaling from zero players as before.
  - Pick a region with no open request, then pick a good from that region's `demands`. Proposed: weight the pick by demand volume.
- Size: `units = round(rand(value min, value max) / Steady price)`. Pay per unit = Steady price times 2.5 times the quality multiplier.
- Remove from `internal_trade_and_quests.dm`:
  - the low pop scarcity bonus (`STANDING_ORDER_SCARCITY_*`);
  - `STANDING_ORDER_POP_SCALE_*` and `order_size_mult`;
  - `STANDING_ORDER_PARTIAL_*` and the partial prompt;
  - `preview_partial_fulfillment`.
- Change `STANDING_ORDERS_MAX_PER_REGION` to 1.
- `fulfill_order` pays per delivered unit and leaves the rest open.
- The Fulfill button stays until caravans carry requests in slice 11.

UI: `tgui/packages/tgui/interfaces/StewardTrade/OrdersView.tsx` and `types.ts`:

- `Order` loses `pair_*`, `can_partial`, `partial_*` and `scarcity_bonus_pct`.
- It gains units remaining and the per unit pay.

### 5 - Finished goods requests (built 2026-11-16)

- Every order is now a `/datum/standing_order/request` for one good. All package templates are gone, and urgent orders were removed on 2026-11-17.
- `/datum/request_kind` data datums in `standing_order.dm` list finished goods only. Raw goods come up as single good requests instead. There are eleven kinds:
  - Arms, Heavy Armor, Light Armor, Potions, Prosthetics;
  - Artificery, Artificed Panoply, Finery, Jewelry;
  - Enchantment Scrolls, Hunt Trophies.
- Region types list `request_kinds`. The regions' `request_kinds` hold the weights (`REQUEST_WEIGHT_*`). The single good request is the `REQUEST_KIND_GOODS` entry at `REQUEST_WEIGHT_GOODS` 6. A kind picks one good uniformly, sized by the same value band.
- Kinds by region type:
  - Garrison: arms, heavy armor, light armor, prosthetics, potions.
  - Urban: artificery, potions.
  - Noble: finery, jewelry, trophies, scrolls, panoply.
  - Toolworks: artificery.
  - Settlement: none. Birthday Tribute, Frontier Gear and Tournament Arms were dissolved into the other kinds (user 2026-11-16).
- Petition categories hold kinds. The UI payload still uses the `templates` keys until slice 7.
- The user reserved separate luxury kinds for later.

### 6 - Extensions (built 2026-11-16)

- `STANDING_ORDER_EXTEND_COST` 200 Pledge adds `STANDING_ORDER_EXTEND_DAYS` 1 to `day_expires`.
- `SSeconomy.extend_order` and `extend_blocker` live in `code/controllers/subsystem/rogue/economy/petitions.dm`, beside the other Pledge spending. The burn posts to the Pledge expense account and counts toward `STATS_PLEDGE_CONSUMED`.
- Each order card on the Nerve Master has a "Send a zad - 200p" button. Only Crown officials can use it, and it still works under sequestration, like petitions.
- There is no cap beyond Pledge. That was the open question, and this is the default until the user says otherwise.

### 7 - Petitions retarget (parked 2026-11-16)

- Parked by the user. Petitions keep the slice 5 shape until then: a category, then a kind, in a region that has that kind.
- A petition replaces the current deal in a random region instead of adding a new order.
- Keep `PETITIONS_PER_DAY` and the petition tax.
- Open: whether a petition picks a good or a category, and whether it can target offers.

### 8 - Offers (built 2026-11-16, backend only)

- `code/modules/roguetown/roguestock/region_offer.dm` holds the `/datum/region_offer` datum and pool. The procs are in `code/controllers/subsystem/rogue/economy/offers.dm`. `SSeconomy.tick_offers` runs at dawn after the request roll.
- Offers mirror requests (user 2026-11-16):
  - `OFFERS_BASE_PER_DAY` 4 plus `OFFERS_PER_ACTIVE_PLAYER` 0.05;
  - up to `OFFERS_POOL_CAP` 13, at most one per region;
  - `OFFER_DURATION` 1 dae, so they rotate daily.
- The good comes from `stockpile_goods(region.produces)`, weighted by produce volume. That proc is shared with requests.
- Size is `OFFER_VALUE_MIN`/`MAX` 200/400 over the Steady price. The price is `OFFER_PRICE_MULT` 0.9 of Steady, fixed at roll.
- `take_offer` is all or nothing (user 2026-11-16) and refused while the region is raided. It burns `total_price` to `LEDGER_CROWN_EXP_IMPORTS`, puts the units into royal stock and logs a local import.
- No desk button. Caravans wire `take_offer` in slice 11, and offers first show on the caravans screen in slice 12. The user does not care about interim access because the PR doesn't ship until it is finished.

### 9 - Market targets by category (built 2026-11-17)

- `compute_market_target` and its region volume sum are gone. Targets are tier defines, the same way trade volumes are.
- The tiers are RARE 10, LOW 15, STAPLE 20, MODEST 25, STANDARD 40, BULK 80 and MASS 120.
- `/datum/roguestock` defaults to STANDARD. Each good that differs sets `market_target` on its own datum.
- The rule: the less choice a producer has, the higher the target, so the price holds when they sell a lot of it.
- Current assignments, after the user's first tuning pass on 2026-11-17 (stone up, raw iron and raw copper down a tier, fur down):

  | Tier | Goods |
  |---|---|
  | MASS | Wood, stone |
  | BULK | Coal |
  | STANDARD | Grain, generic meat, fish filet and mince, cloth, fibers, cured leather, hide, clay, salt, glass batch, raw iron, raw tin, base metal ingots |
  | MODEST | Specific meat cuts, dairy, eggs, fat, tallow, bones, every fish species, dried fish, silk, cinnabar, viscera, sinew, raw copper, fur |
  | STAPLE | Oats, rice, maize, potato, beans, lentils. They start at 12, so Scarce (user 2026-11-17). Seasonal demand comes later. |
  | LOW | Every other crop and fruit, honey, calendula |
  | RARE | Gold and silver, ore and ingot (unchanged) |

- Fur sell price: open. `SELLPRICE_FUR` stays 10 for now (see the 2026-11-17 discussion).
- **Thin start (user 2026-11-17):** the Market no longer starts at target.
  - Each datum sets `market_stock` to its pre Econ 4 starting amount. Those amounts had moved into `royal_stock` in the step 2 split.
  - Goods that started at 0 start empty.
  - Most goods open in Scarce or Very Scarce.
  - The first dawn's Market dae is skipped (user 2026-11-17): `run_market_day` returns while `ECONOMY_DAY <= MARKET_DAY_GRACE_DAYS` (1). So the first refill is at the second dawn. The stockpile and vomitorium countdowns use `seconds_until_market_day()`, which counts past skipped dawns.
  - Royal stock now starts empty for every good (user 2026-11-17). The datums' `royal_stock` lines are removed, so the total at round start matches the old stockpile.

### 10 - Tribute goods and gifts (built 2026-11-17, backend only)

- Each region has a hand set `tribute_goods` list in `regions.dm`. The `TRIBUTE_VALUE` of 150 is split evenly across the list, times `SSeconomy.tribute_pop_mult()`. That is 1x up to `TRIBUTE_POP_SCALE_START` 60 players, rising to `TRIBUTE_POP_MAX_MULT` 2x at `TRIBUTE_POP_SCALE_FULL` 120. Units per good are that share over the Steady price.
- `region.collect_tribute(user)` works once per region per dae (`tribute_day`) and is refused while the region is raided. It adds the units to royal stock and logs a local import, then `deliver_gifts()` spawns each `gifts` entry in the warehouse area with the unsellable component.
- `gifts` lists are empty, for the user to fill with item paths.
- Caravans call `collect_tribute` in slice 11.
- First draft of tribute goods, for the user to edit:

  | Region | Tribute goods |
  |---|---|
  | Kingsfield | grain, cheese |
  | Rosawood | wood, pork |
  | Rockhill | apple, pear |
  | Daftsmarch | raw iron, coal |
  | Blackholt | silk, viscera |
  | Saltwick | salt, dried fish |
  | Bleakisles | fish filet, glass batch |
  | Northmarch | raw copper, raw tin |
  | Heartfelt | meat, hide |
  | Hagenwald | iron ingot, steel ingot |
  | Eveswood | wood, rocknut |
  | Rhu Rosha | cod, salmon |
  | South Syons | cheese, fur |
  | North Syons | lemon, cheese |
  | Dalesworth | carp, grain |
  | Avondale | grain, pork |
  | Bewmarch | cheese, apple |

- Text in `docs/design/econ4_caravans_text.dm`.

### 11 - Fleet and route sends (built 2026-11-17, backend only)

- `code/controllers/subsystem/rogue/economy/caravans.dm`, with the fleet vars in `SUBSYSTEM_DEF(economy)`:
  - `SSeconomy.caravan_fleet` starts at `CARAVAN_FLEET_START` 3 (user 2026-11-17, because sends tally daily) and grows by `CARAVAN_FLEET_PER_DAY` 1 each dawn, to `CARAVAN_FLEET_MAX` 8.
  - `caravan_trips` holds the caravans that are out.
  - `caravans_home()` is the fleet minus trips.
- `send_caravan(user, route, request, offer, tribute_region)` takes up to one of each. Each must be on `route`, from `get_region_route` in `routes.dm`, and its region must not be raided. Refusals are full sentences from `caravan_send_blocker`.
- **At send:**
  - The request loads everything on hand up to what it still wants, through `scan_order` and `load_order`, which replace `fulfill_order`. Stock leaves royal stock, and equipment leaves the dock. The payout is fixed at send.
  - The offer is paid in full and leaves the pool.
  - The tribute is reserved (`take_tribute` sets `tribute_day`).
- **At dawn:** `resolve_caravans` runs first in `daily_tick`. It mints the request payouts and announces them. It delivers the offer units (`deliver_offer`), the tribute units and the gifts (`deliver_tribute`), then grows the fleet.
- Gone: route trip times, `take_offer`, `collect_tribute`, `fulfill_order`, the Fulfill button and action, and its retry cooldown. The Orders tab is read only apart from the zad button.
- The stale guide and Avisa lines about fulfilling at the Nerve Master were rewritten in slice 12.

### 12 - Caravans screen (built 2026-11-17)

- A new Caravans tab, first in the Steward desk and the default tab: `tgui/packages/tgui/interfaces/StewardTrade/CaravansView.tsx`.
- **Layout:**
  - fleet line (home, total, on the road);
  - route sub tabs;
  - a centred manifest column showing the picked request, offer and tribute (region and goods, "None" when empty), with "Send caravan" centred below it;
  - subroute sections with a card per region. Each card has a labelled row per choice (Request per order, Offer, Tribute), and each choice is a button. Request rows carry the WAREHOUSE and PETITIONED badges and the zad button.
  - Clicking a button picks it, and there is one request, one offer and one tribute per send. Switching route clears the picks.
  - Blockaded regions and blocked tributes show disabled buttons. The tribute button shows the blocker sentence instead of goods.
  - An "On the road" list shows the caravans that are out.
- The Standing Orders tab and `OrdersView.tsx` are gone, consolidated into Caravans (user 2026-11-17). `order_pool_cap` was dropped from the static data.
- **Data:**
  - Static `caravan_routes` (route, subroutes, region ids).
  - Live `active_offers`, `region_caravan` (blockaded, tribute units, tribute blocker) and `caravans` (fleet, home, trips).
  - Requests reuse `active_orders`.
- Action `send_caravan` (route path, request ref, offer ref, tribute region id) calls `SSeconomy.send_caravan`. It isn't locked under sequestration, the same as Fulfill before it.
- The guide's Fulfillment paragraph and the Avisa help line now say orders are delivered by caravan from the Nerve Master.
- Text in `docs/design/econ4_caravans_text.dm`.

### 12b - Desk layout (built 2026-11-17)

- The user consolidated the Standing Orders tab away. The mockups are on the "Steward Desk Redesign" canvas, in the "Chosen direction" row.
- **Header:** title, Day, Treasury and the dawn line share one row. Sequestration and arrears are one line bars above the tabs. All other banners moved to the Dispatches tab.
- **Tabs:** Caravans, Dispatches, Market, Ledger, Regions, Petition. The Dispatches badge counts an open ATC loan plus shortage events that take relief.
- **Dispatches** (`DispatchesView.tsx`): events on the left; the ATC bench, blockades by route and brigands on the right. Brigand rows come from the new `rows` in `preview_banditry_drain`, with the formula in a hover. `blockaded_regions` is gone from ui_data.
- **Caravans** (`CaravansView.tsx`):
  - Every route is in one table, with region rows and Request, Offer and Tribute columns. The first pick locks its route and dims the others.
  - A dock is pinned to the bottom. It has the request panel (stock line, the "Fill partial from Market" toggle, the outcome and the projection, plus the zad button) and the offer panel (the Market bid and the resale projection). Below them are the tribute, the projected net, Clear and Send.
- **Quotes:** the client sends `caravan_select` with the picked request and offer refs. These go into `caravan_view[ckey]`, and `build_caravan_quote` quotes only those two. The request quote runs `scan_order` (dock counts and quality payout) and `SSeconomy.order_fill_plan`. The offer quote uses `market_bid(units)` and the first and last unit bids. The tribute quote sells the region's tribute at `market_bid(units, offset)`, where the offset is the offer's units when the offer carries the same good. The projected net adds the tribute resale.
- **Fill:** `send_caravan(..., fill)` buys `order_fill_plan` through `buy_from_market(..., bulk_capped = FALSE)` before the scan. It checks the market cost plus the offer price against the Treasury first. It is refused under sequestration.
- Text in `docs/design/econ4_caravans_text.dm`.

### 13 - Escort and raids (built 2026-11-17)

- User calls on 2026-11-17:
  - The fee counts from the raid's own day 1.
  - One fee covers the whole subroute until dawn.
  - Raided deals carry half the units at the same unit price, so pay drops in proportion.
  - No tribute from raided regions, escort or not.
- `caravans.dm`:
  - `escort_fee` is `ESCORT_FEE_BASE` 200 plus `ESCORT_FEE_PER_DAY` 100 times the days since the blockade's `day_started`.
  - `buy_escort` burns the fee to a new `LEDGER_CROWN_EXP_ESCORTS` ("Caravan Escorts") account and sets `escorted_subroutes[subroute] = ECONOMY_DAY`, a var in `SUBSYSTEM_DEF`.
  - `region_reachable` lets a caravan into a raided region whose subroute is escorted today.
  - The tribute blocker still refuses raided regions.
- **Half size:** `order_needs` and `offer_units_now` round half up (`RAID_DEAL_SIZE_PERCENT` 50) while the region is raided. They are used in:
  - the scans, which now take a needs list instead of the order;
  - the fill plan;
  - the send;
  - the quote;
  - the order and offer rows. The rows carry `halved` for the HALF tag.
- **Market dae:** `market_open_supply_share` counts a subroute escorted the previous dae as open.
- **UI:** raided subroutes show "Escort [subroute] - [fee]m" under the route name, then "escorted until dawn" once paid. Raided cells unlock while escorted.
- The guide's blockade section has an escort paragraph. Text in `docs/design/econ4_caravans_text.dm`.

### 14 - Imports removed, Special Commission (built 2026-11-17)

- First built as crown imports by caravan: each import had a source region, a daily stock and an Imports column on the Caravans screen. The user dropped it the same day because the imports were concentrated in a few regions and duplicated Goldface.
- User calls on 2026-11-17:
  - regional imports are removed outright. Goldface already sells the farm animals (Saiga, Chicken, Cow, Bull, Goat, Billy Goat), so no Merchant slice is needed for them;
  - the Keyring Set stays separate, at the Nerve Master;
  - retinue kits become a Special Commission from the Royal Armoury, with no region;
  - each kit's price is derived from Goldface prices, with 2 per kit a dae, delivered on a fixed timer, in its own tab.
- **Crown imports:**
  - `crown_imports.dm` keeps only the Keyring Set. The zad pack and zadcage imports live in `zadpack.dm`;
  - `_crown_imports.dm` has a flat `get_import_price()`, with `daily_stock` and `stock` refilled at dawn by `restock_crown_imports()`;
  - gone: `source_region_id`, `is_local()`, `is_blockaded()`, `RAID_IMPORT_PRICE_PERCENT`, all caravan import plumbing and the Imports column;
  - the Nerve Master's HTML Import tab lists every crown import, with stock.
- **Special Commission:**
  - `royal_commissions.dm` holds `/datum/royal_commission`, with `contains` as path to count and five kits: Crossbow, Warden, Man-at-Arms, Knight and a Royal Caparison (user 2026-11-17; the azurean caparison that used to come with the Crown's saigabuck). The crate subtypes are gone, and the delivery fills a plain Steward chest.
  - `get_price()` sums each content's `initial(sellprice)`, else its engine price (`GLOB.derived_sellprices`, then the parent lookup). It multiplies the total by `COMMISSION_PRICE_MARKUP` 1.5, which mirrors `SUPPLY_PACK_DERIVED_MARKUP` on main. Main's `derive_pack_cost` isn't on this branch, and it refuses any pack holding a hardset price or a bespoke retinue piece, so the kits price each item instead.
  - `commissions.dm` (SSeconomy) has `commission_blocker`, `place_commission` and `deliver_commission`, plus `restock_commissions()` at dawn. `commission_orders` is a `SUBSYSTEM_DEF` var.
  - A commission burns its price to `LEDGER_CROWN_EXP_COMMISSIONS` ("Royal Commissions"). The crate lands in the warehouse after `COMMISSION_LEAD_TIME` (20 minutes). Stock is `COMMISSION_DAILY_STOCK` 2.
  - The UI is a Commission tab (`CommissionsView.tsx`) with the kits (price, stock left today, Commission button) and an On Order list with minutes left. Clicking a kit's name expands its contents (user 2026-11-17), fed by `content_rows()`.
  - Text is in `econ4_commissions_text.dm`.
  - Flag: the Warden kit still holds a warden keyring.
- **Local Commission (user 2026-11-17, after the commit):**
  - The Nerve Master's HTML Import tab is gone: `TAB_IMPORT`, the `import` Topic and `do_import`.
  - The Keyring Set and zad packs sit in a Local Commission section of the Commission tab, through `local_commission_blocker` and `place_local_commission` in `commissions.dm`.
  - They are delivered to the warehouse at once, with the old import stats and the `LEDGER_CROWN_EXP_IMPORTS` burn.
  - `warehouse_drop_turf()` is shared with commission delivery.
- **Caravans screen (same day):**
  - Region row cells wrap instead of cutting names off (user 2026-11-17). Goods in a list break between goods, and the price and days drop to a second line.
  - A selected cell is no longer bold, so selecting never rewraps a row.
- **Day reads (user 2026-11-17):** economy code reads the day through `ECONOMY_DAY`, which is `max(1, GLOB.dayspassed)`. The round starts on the dawn line, so the first dawn fires at round start and lifts `dayspassed` from 0 to 1. Anything stamped during setup (roundstart raids, events, orders) used to hold day 0 and counted an extra day, for example an escort fee of 300m on the first dae. Only the `daily_tick` guard and `last_processed_day` read `GLOB.dayspassed` raw.

### 14b - Morning report removed (built 2026-11-17)

- The printed Steward's morning report is gone (user 2026-11-17): `steward_report.dm`, `print_steward_report` and the SStreasury `last_report_ledger` and `last_report_balance` baselines. The Steward screen's Dispatches and Ledger tabs cover it.
- `daily_report_diff` is renamed `dawn_digest`. It now holds only what the dawn announcements read:
  - `regular_orders_by_region`, for the new standing order count;
  - `events_relieved`, for the batched RELIEF line.
- Report-only writes are gone:
  - events fired and expired, with the shortage and glut name buckets;
  - blockades fired, cleared and gathering;
  - banditry drain lines and totals, including the preview's `lines`;
  - orders and offers rolled.

### 15 - Estates (committed 2026-11-19, 6fe6d5fbc73)

- **User calls on 2026-11-17:**
  - the region is a character preference;
  - two tiers: normal nobles get 15m plus one parcel a dae, higher nobles 30m plus two;
  - a third, Lord tier added the same day: 50m plus three parcels, for the Heartfelt Lord. The Heartfelt Hand is higher tier;
  - the Lord (the Duke) is left out of estates for now (user 2026-11-17), so the Duke isn't balanced through them. They keep the flat 275m with no region and no parcel, delivered even through raids;
  - higher means court and heir (Hand, Consort, Councillor, Steward, Marshal, Prince);
  - political factions come later, in their own slice.
- **Source:** the gdoc's Module 10 (undated, after the Nov 14 note) holds the details. The Nov 14 note only says "Region picking, preferences, escort no bypass".
- **Data:**
  - `estate_tier` (`ESTATE_TIER_NONE`, `NORMAL`, `HIGH`, `LORD`) on `/datum/job` and `/datum/advclass`. It replaces the per-job `noble_income` numbers.
  - `noble_income` remains a coin override for only two roles: the Lord (275) and the Merchant (100, the ATC stipend). Neither has a tier, so neither has a region or parcel, and raids never hold their coin back.
  - Defines: `ESTATE_COIN_NORMAL` 15, `ESTATE_COIN_HIGH` 30, `ESTATE_COIN_LORD` 50, `ESTATE_PARCELS_NORMAL` 1, `ESTATE_PARCELS_HIGH` 2, `ESTATE_PARCELS_LORD` 3, `ESTATE_PARCEL_VALUE` 15 (a steel ingot is 14), `ESTATE_GIFT_INTERVAL` 3.
- **Code:** `estates.dm` (SSeconomy) holds `/datum/noble_estate` (region, tier, coin override, undelivered days and gifts) and `SSeconomy.estates`.
  - `register_estate()` takes the higher tier when called twice and pays the spawn coin with the starter bonus once. It is called from the job, the advclass, the noble virtue and the Meister account path (which pays nothing).
  - `pay_estates()` runs at dawn in place of `SStreasury.distribute_estate_incomes`, which is gone along with `noble_incomes`.
  - While the estate's region is raided, the coin and parcels are not delivered, and the Meister says "[Region] is raided. Your estate income will not be delivered." Escort doesn't help.
  - `release_estate_backlogs()` runs from `clear_blockade` and pays the whole backlog at once.
  - Outlaws get nothing and build no backlog.
- **Parcel:**
  - Each parcel rolls one of the region's or realm's `estate_goods` by weight, worth `ESTATE_PARCEL_VALUE` at the Steady price. Weights are `ESTATE_GOOD_REGULAR` 3 and `ESTATE_GOOD_OCCASIONAL` 1. Estate lists are separate from tribute (built 2026-11-24). Regions draw on their types plus lore picks. Realms draw on their Merchant export lists plus lore picks.
  - Goods worth more than a parcel (gems, gold, Dendor essence) are left out until a rule for them is decided. Lirvas has only rosestone and cinnabar for now.
  - Every third dae (3, 6), the parcel also carries one of the region's `gifts`, which can't be sold. The lists are still empty for the user to fill.
  - It goes by HERMES to the noble by name as an "estate parcel" from "[Region] Estate", or drops at their feet if there is no HERMES.
- **Preference:** `estate_region` is a per-character savefile var, defaulting to Kingsfield. Chargen shows it as an Estate row in Identity > Gameplay with a region list. At spawn it is read from the joining client, because the new mob has no client yet.
- **Text:** `econ4_estates_text.dm`.
- **Flags:**
  - The noble virtue no longer adds 15m on top of a noble job. It only makes a commoner a normal noble.

### 16 - Daily events rework (built 2026-11-19, regional part removed 2026-11-20)

- **Done early (2026-11-17):** shortage relief counts by value, as gdoc 3.7 says.
  - `saturation_target` is anchored on the Market (user 2026-11-17): the summed `market_target` times Steady price of the affected goods, times `ECON_EVENT_RELIEF_PERCENT` 50, with no floor. The old regional demand formula and `ECON_EVENT_SATURATION_*` and `REGION_POP_SCALE_*` are gone.
  - `credit_economic_event_saturation` adds units times the Steady price.
  - Only goods that reach the Market count:
    - player sales at the stockpile;
    - the Steward's `sell_to_market`.
  - Keep role deposits into royal stock and caravan request loads don't count.
  - The badge and the Dispatches line show mammon.
- **Rolls:**
  - Each dawn the wanted count is `ECON_EVENT_DAILY_MIN` 2 to `MAX` 3.
  - While the active count is at or above the wanted count, the oldest event from an earlier dae is pushed out, so something new rolls every dae. At round start nothing is pushed out.
  - An event can't roll if it shares a good with an active event (`economic_event_clashes`). The pick is flat.
  - `end_economic_event()` is shared by expiry and the push out.
  - `ECON_EVENT_TARGET_COUNT` and `ECON_EVENT_ROUNDSTART_COUNT` are gone.
- **Removed 2026-11-20:** the regional events built here (17 events moving the Market target all round), `market_base_target`, the linked weighting and the regional rows in Dispatches and the noticeboard. The 17 events left the code and wait in the events sheet (16b). Until 16b is built, 10 daily events are in code.

### 16b - Events regrouped (decided 2026-11-19, sheet in review)

- **User calls on 2026-11-19:**
  - Regional events are scrapped. Requests and offers already give regions their deals.
  - The stockpile machine is the Market. Towners, the guild and adventurers all buy and sell there, so every event moves everyone's prices.
  - More gluts and shortages are fine for the Steward and the Merchant: they drive day to day management and tribute picks.
  - Towners are overspecialized. Only fishers and soilsons can switch what they produce.
  - Iron and steel feed every combat role's gear, so an iron shortage is the one everyone feels. It must never last the round.
  - Ingot gluts are fine: blacksmiths smelt for themselves and there is no dedicated smelter.
  - Salt, silk and glass batch have no dedicated maker.
- **Groups.** Each event belongs to one:
  - **Fish and crops:** fishers and soilsons switch to answer. Both ways. One rolls every dae.
  - **Gathered goods:** adventurers, miners and hunters go out to answer. Mostly shortages.
  - **Worked goods:** a glut is a gear dae and a shortage is the crafter's chance.
  - **Cosmetic and trade goods:** both ways. The Steward and Merchant answer through tribute and offers.
- **Rules:**
  - Each dae one fish or crop event rolls, then the other groups fill 1 or 2 slots.
  - At most one metal event (ores or ingots) is active at a time.
  - Mixed events are shortages on some goods and gluts on others (Saltwick Storm, Wet Season).
  - Fish group by water (sea, fresh water, swamp). Crops group as grains, roots, greens, beans, orchard, citrus, berries and cash crops.
  - An event never spans two stages of one chain in the same direction.
- **Scrapped 2026-11-20:** the regional event files, `market_base_target`, `refresh_regional_targets`, the `REGIONAL_*` defines, `ECON_EVENT_LINKED_WEIGHT` and the regional rows in Dispatches and the noticeboard. `price_mod`, `global_price_mod` and the `ECON_SHORTAGE_*` and `ECON_OVERSUPPLY_*` severities went too, because they no longer reached any price. Also removed: the unused `get_event_tag` and `ECON_EVENT_NARRATIVE`.
- **Pool:** 42 events, 15 of them new. The list lives in the Sheet "Econ 4 Market Events" (https://claude.ai/artifact/F8oJuuNMAcUPgXqLU8AUpq): name, description, rationale, effect, goods, group and a New box, plus a Goods groups tab. It replaces `econ4_events_text.dm`. Announcements are not in it.

### 17 - Producer share and rentals

### 18 - Nerve Master legacy UI cleanup (queued 2026-11-17)

The Nerve Master's HTML window (`steward.dm`, `attack_hand` and `Topic`) still holds the pre Econ 4 screens. Move what is still needed into the Steward screen and delete the rest. When done, the HTML window and `current_tab`, `compact` and the `TAB_*` defines go.

| HTML piece | What it does | Already in the Steward screen | Proposed home |
|---|---|---|---|
| Main menu | Links to every tab, plus Print Letter of Citizenry and Purchase Floor | The Trade & Stockpile link opens it | Delete once everything below has a home |
| Bank | Every account's balance, with Give Money, Fine and Suspend Wages, plus Pay by Class | Subsidiary shows the payroll register, read only | A Treasury tab with the account list and its actions |
| Import | Done 2026-11-17: moved to the Commission tab as Local Commission | | |
| Daily Payments | Set or remove a daily wage per job | Payroll register, read only | The Treasury tab |
| Fiscal Ledger | Balances, revenue and expenses this week, forgone revenue, trade, tax rates, charters, debt and loans, contracts | Income, Balance Sheet, Subsidiary (loans, poll levy, tax ledger) | Delete. Check first that tax rates, charters, forgone revenue and contracts appear somewhere |
| Debts & Arrears | Loan list, poll levy arrears, Clear Defaulter Mark, Clear Poll Levy Obligation | Subsidiary lists loans and poll levy, read only | The Treasury tab, with both clear actions |
| Print Letter of Citizenry | Prints a residency letter | None | The Treasury tab |
| Purchase Floor | Sets the purse floor below which the Crown stops buying (the stockpile and withdraw machines read it) | Not editable | The Market tab, next to the royal stock controls |

- Decide: one Treasury tab or two (accounts and payroll, then debts).
- Keep the `has_fiscal_authority` gate on Fine, Suspend Wages and both clear actions.
- Player text goes in a new `econ4_nerve_master_text.dm` sheet.

## Open decisions

- The producer share method (slice 17).
- Food pricing for the food trades (see Food pricing under The design).
- Seasons and Divination: later. Urgent orders were removed on 2026-11-17.
- Political factions (gdoc Module 10) get their own slice after estates (user 2026-11-17). The faction list is still needed.
- Module A (adventurer loot turn in) is outside this PR.
- The smaller open calls listed under slices 4 to 8.

## Self note lines now stale

These lines in the gdoc's Nov 14 self note are overridden by the user's 2026-11-16 calls:

- "Each region no matter what can rolls 3 per place" and "4 deals per region, lasting 2 daes": now one request and one offer per region.
- "Drop partial delivery": partial delivery is allowed, with no haircut.
- "we may or may not want to actually make the market not infinitely elastic": decided, with depth at half the target.
- Open decision "One tally / two tally": one tally.

## Code map

- **SSeconomy:** every subsystem var and proc lives in `code/controllers/subsystem/rogue/economy/`. Vars go in `SUBSYSTEM_DEF(economy)` in `economy.dm`.
  - `economy.dm`: `daily_tick`, request rolls, `scan_order`/`load_order`, the `scan_*` procs, `sell_to_market` and `buy_from_market`;
  - `market_day.dm`: the Market dae;
  - `offers.dm`: the offer roll and `deliver_offer`;
  - `caravans.dm`: the `/datum/caravan_trip` datum, plus sends and the dawn tally;
  - `petitions.dm`: petitions and zad extensions.
- **Market pricing:** `code/modules/roguetown/roguestock/_roguestock.dm`. This has `market_has_supply`, `market_step`, and `market_ask`/`market_bid`.
- **Events:** `code/modules/roguetown/roguestock/economic_events.dm`.
- **Request data:** `code/modules/roguetown/roguestock/standing_order.dm` holds the order datums and request kinds. `region_offer.dm` holds the offer datum. `steward_petition.dm` holds the petition categories.
- **Defines:**
  - `code/__DEFINES/economy/internal_trade_and_quests.dm`;
  - `code/__DEFINES/trade_volumes.dm`, which holds region sizes, seasons and the `TG_VOLUME_*` tiers.
- **Regions:** `code/modules/economy/regions/`. This has `economic_region.dm`, `regions.dm`, `routes.dm` and `types/`.
- **Steward desk:**
  - `code/modules/roguetown/roguemachine/steward/steward_trade_tgui.dm`;
  - `tgui/packages/tgui/interfaces/StewardTrade/`.
- **Crown imports:** `code/modules/roguetown/roguemachine/steward/steward.dm` (`do_import`).
- **Special Commission:** `code/modules/roguetown/roguestock/royal_commissions.dm`, `code/controllers/subsystem/rogue/economy/commissions.dm`, `tgui/packages/tgui/interfaces/StewardTrade/CommissionsView.tsx`.
- **Player buys:**
  - `code/modules/roguetown/roguemachine/stockpile/withdraw_tab.dm`;
  - `withdraw.dm`;
  - `stockpile/stockpile.dm`.
