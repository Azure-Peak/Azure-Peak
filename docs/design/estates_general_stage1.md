<<<<<<< Updated upstream
# Estates General — Stage 1 Implementation Brief

## Goal (verbatim from the designer)

> The Estates General was originally conceived as a way to actually have revolt
> that bites, by having people collectively vote yes / no on different chambers,
> basically a pseudo parliament.
>
> It is also an escape hatch for lowpop — you can vote to use your authority to
> import / export things, or authorize economic actions when the usual job
> holders aren't around to do it. If you have a shortage of iron / coal / ore,
> you just vote to import.

**Stage 1 is the lowpop escape hatch.** Revolt and multi-chamber politics are
Stage 2 and are *not* in scope for this implementation. The designer has stated
they already see people dynamically revolting in other ways; Stage 1 is
purely about giving the Assembly a functional economic voice.

---

## STAGE 1 SCOPE — implement this

- **One chamber**: "The Assembly." All non-outlaw players eligible to vote.
- **Three scheduled sessions per round** at the **10-minute, 30-minute, and 60-minute** marks. Each session is open for **5 minutes**.
  - The 10-minute session is the "Extraordinary Session" (roundstart).
  - The other two are regular sessions.
- **Weighted votes by job class** (see locked weights below).
- **Two proposition types**:
  - `/economic/import` — authorize a stockpile import of X units of good Y
  - `/economic/export` — authorize a stockpile export of X units of good Y
  - `/commission/defense` — authorize a defense writ (same type Steward normally commissions)
- **Speaker role**: first non-outlaw volunteer claims at the Estates machine. Must remain alive and online. Speaker's job is to *table* queued motions for vote.
- **Session authorization budget** — a **magical budget** (`/datum/fund/assembly`, custom currency `CURRENCY_ASSEMBLY`), refreshed at the start of each session. Scales with active player count. Non-rollover.
- **TGUI machine** `/obj/structure/roguemachine/estates`, placed in the throne room.
- **Round-end chronicle** entry showing all motions, votes, and outcomes.

---

## STAGE 2 SCOPE — EXPLICITLY NOT THIS ROUND, DO NOT IMPLEMENT

- Revolt mechanics (the designer already has dynamic revolts from other systems).
- Multi-chamber structure (Crown / Church / Commons split).
- Charter/decree toggling via vote.
- Vetoes (Grand Duke override, etc.).
- Outlaw declarations via vote.
- Tax-rate adjustments via vote.
- Fund-to-fund transfers via vote (opens exploits).
- Inflationary/accumulating budget variants.

If you find yourself wanting to add any of these, **stop and write a note in a
Stage 2 section** of this doc instead.

---

## Locked design decisions (do not re-decide)

### 1. Vote weights per job/class

The Assembly assigns weight based on job. Lookup in one proc:
`SSestates.get_vote_weight(mob/user)` returns an int.

**Starting weights** (tune later, not in Stage 1):

| Role | Weight |
|------|--------|
| Grand Duke | 10 |
| Consort, Prince | 8 |
| Keeper, Priest, Inquisitor | 8 |
| Hand, Steward, Councillor, Marshal | 6 |
| Nobles (other than above) | 5 |
| Sergeant, Knight, Templar | 4 |
| Merchant, Innkeeper, Bathmaster, Head Physician, Court Magician, Archivist, Apothecary, Guildmaster | 3 |
| Garrison (other), Retinue (other), Clergy (other) | 3 |
| Burghers (other), Resident | 2 |
| Peasants, Sidefolk | 2 |
| Adventurer, Mercenary | 1 |

**Rules:**
- Outlaws: weight 0, and they **cannot cast a vote at all** (civic-dead).
- Dead players: cannot vote (the session checks `stat != DEAD` at vote cast time).
- Regents do **not** get a weight bump for holding regency. Their underlying job's weight applies. (Regent grants *commission standing* per the contract ledger rules — that's separate from the Assembly.)
- A player rerolling mid-round does not get a second vote in the same session
  (vote tracked by **ckey**, not mob).

### 2. Session schedule

Sessions fire at **10min**, **30min**, **60min** after round start, each open for **5 minutes**.

- Session state machine: `SCHEDULED → OPEN → CLOSED → RESOLVED`
- On OPEN: announce to the world via `priority_announce`, play a fanfare sound,
  create a fresh `/datum/fund/assembly` balance for that session.
- On CLOSED: no new votes accepted. Tabled motions tally and execute.
- On RESOLVED: log to `SSestates.history`, burn unused assembly budget.

A session that is OPEN continues ticking even if the next scheduled session
start arrives; the next scheduled session is queued and opens when the current
one closes. This is an edge case but gracefully handled — don't drop sessions.

### 3. Speaker of the Estates

- **First-come-first-served**: first non-outlaw player to click the Estates machine and select "Claim Speakership" becomes Speaker.
- Speaker remains until:
  - They step down voluntarily, OR
  - They go OOC (`stat == DEAD`, disconnect ≥ 3 minutes), OR
  - They are declared outlawed.
- The seat can be re-claimed when vacated.
- Speaker's **only mechanical power** is to table queued motions to a vote. They
  have **no extra vote weight**.
- If no Speaker when a motion is queued: motion auto-tables after **60 seconds**
  on the queue. This guarantees progress; the Speaker is a convenience/RP role.

### 4. Motion queue and voting flow

- Any non-outlaw may propose a motion during an OPEN session.
- Motions enter `SSestates.current_session.pending_motions`.
- Per-proposer cooldown: **2 minutes** between motions.
- Per-session motion cap: **3 motions may come to a vote** in a single session.
  If more are queued than can vote, Speaker (or auto-table) picks order.
- A tabled motion has a **90-second vote window** (independent of session
  window). Players cast yea/nay with their weight.
- Resolution rule: **simple weighted majority of CAST votes**. Abstention = not
  present in the tally. No quorum minimum. If nobody votes, the motion fails
  (not "passes by default").
- Executed motion draws from `assembly_budget_fund`. If the fund can't cover
  the cost, the motion fails at `execute()` time even if the vote passed (log
  this as `INSUFFICIENT_AUTHORITY`).

### 5. Magical budget (Assembly Authority)

**This is a custom fund, not Crown's Purse.**

Rationale: Crown's Purse has an owner (Steward/Grand Duke). Allowing the
Assembly to draw from it is a revolt/coercion mechanic. Stage 1 is a
cooperative escape hatch, so the Assembly needs its own abstract authority
pool that no player has individual claim to.

- `CURRENCY_ASSEMBLY` added alongside `CURRENCY_MAMMON` / `CURRENCY_BURGHER_PLEDGE`.
- `/datum/fund/assembly` is created fresh at each session OPEN, seeded:
  - `BASE_REFILL` (e.g., **250**) + `PER_PLAYER_REFILL` × active player count (e.g., **5**).
  - Cap: `BASE + PER_PLAYER × N` (same as the seed — no rollover, burns out at session close).
- Propositions spend from it via `SStreasury.transfer()`-style semantics, even
  though the currency is abstract.
- **Economic propositions cost**: the *mammon value* of the authorized
  import/export at the current stockpile price. E.g., authorizing an import of
  10 grain at 5m/unit stockpile price = 50m authority cost.
- **Commission propositions cost**: matches `BURGHER_PLEDGE_COST_*` tiers
  (defense writs already have these defined). Route the cost in authority
  currency but the actual mammon payout to the contractor comes from *where
  the Steward's commission would normally come from* (Crown's Purse /
  Pledge). The Assembly authorizes the writ; the Treasury funds it.

**Edge case**: if `commission/defense` is voted through but Crown's Purse is
empty, the writ still issues as a "Request" (the existing mechanic — zero
reward, honor-only). Same fallback logic Steward already has.

### 6. UI

- New machine: `/obj/structure/roguemachine/estates`.
- TGUI interface (`EstatesAssembly.tsx`).
- Placement: throne room on the main Azure Peak map (`dun_world.dmm`).
- Panels:
  - **Session status** — time remaining, current speaker, current budget balance
  - **Queue** — pending motions (with Speaker-table button if you're Speaker)
  - **Tabled motion** — yea/nay buttons with your weight shown
  - **History** — past motions this round and their outcomes
  - **Propose** — form to submit a new motion (import/export/commission, parameters)

### 7. Commission props specifically

A `commission/defense` proposition mirrors what `commission_defense_from_tgui`
does on the Contract Ledger — but the authorizing body is the Assembly, not
the Steward. On execute:

1. Check `assembly_budget_fund` balance ≥ tier cost → if not, fail.
2. Check there is a landmark available for the region → if not, fail.
3. Call into the same landmark-and-quest issuance path the Steward uses.
4. Burn the cost from `assembly_budget_fund`.
5. Log.

The scroll is printed at the Estates machine (not the Contract Ledger). Same
quest scroll type otherwise.
=======
# City Assembly - Stage 1 Implementation Brief

## Goal

The City Assembly is the lowpop economic escape hatch. When the Steward is absent, incompetent, or deadlocked, the citizenry can elect an **Alderman** who gains bounded authority to spend the Crown's Purse on trade and Burgher Pledge on defense commissions. The Assembly doesn't mint mammon - warrants are ceilings on spending the Crown's existing funds.

Stage 2 (not in scope) splits the body into Commons / Peers / Synod chambers, adds revolt mechanics (estate-based ultimatums with mechanical lock-in), and veto powers.

## One-line summary

> A fixed slate of motions resolves at scheduled ticks; the body elects a single Alderman who, while holding office, can use the Steward's trade UI and Contract Ledger up to a voter-set daily cap.

---

## Fixed motion slate

Each session resolves these standing motions. There is no propose/queue machinery - the slate is the same every session.

### 1. Speaker Election (always present)

Any non-outlawed, non-censured mob may **declare candidacy** during the voting window, attaching a free-form "statute" pledge (text, shown to voters).

Each voter picks **one** candidate (or a special "NO SPEAKER" option). Highest weight wins. The sitting Alderman is implicitly a candidate unless they resign or are recalled.

Winner receives TRAIT_ALDERMAN. Previous Alderman loses it (if different mob).

### 2. Authorization to Trade on Behalf of the Crown (bracket vote)

Brackets: `NAE / 0 / 150 / 300 / 450 / 600 / 750 / 900` mammon per day.

Voting method: **max-acceptable**. Each voter picks the highest amount they'd accept. A vote for `600` counts as support for `0, 150, 300, 450, 600` (not 750 or 900).

Resolution: highest bracket with >= 50% cumulative weight wins. **If NAE >= 50% of cast weight, authorization is vetoed entirely for this session**, overriding any bracket outcome.

Result sets the Alderman's `trade_authority_daily_cap`. Applied at next day-tick refresh.

### 3. Authorization to Issue Defense on Behalf of the Crown (bracket vote)

Brackets: `NAE / 0 / 250 / 500 / 750 / 1000` Burgher Pledge equivalent per day.

Same max-acceptable voting method. Same NAE veto rule.

Result sets the Alderman's `defense_authority_daily_cap`.

### 4. Poll Tax Levy for the Common Defense (bracket vote)

Brackets: `NAE / 0 / 5 / 10 / 15 / 20` mammon.

Same voting method. On pass: levied against each affording citizen's bank account (skippable - those who can't pay don't pay). Collected amount is multiplied 2x on entry into the Burgher Pledge fund. **Net mammon-minting**; this is an intentional inflationary knob for commons-directed defense.

### 5. Recall (conditional - only if a Speaker holds office)

Single YAE/NAE/abstain vote. Passes if:
- YAE weight >= 50% of cast weight (of ballots that picked YAE or NAE - abstentions excluded)
- AND total cast weight >= `ASSEMBLY_REMOVAL_WEIGHT_FLOOR` (4)
- AND number of cast votes >= `ASSEMBLY_REMOVAL_MOB_FLOOR` (2)

On pass: current Alderman loses the seat immediately. Does NOT bar them from re-election.

### 6. Censure (conditional - only if a Speaker holds office)

Single YAE/NAE/abstain vote. Passes if:
- YAE weight >= 66% of cast weight
- AND total cast weight >= 4
- AND number of cast votes >= 2

On pass: target mob gains TRAIT_ALDERMAN_CENSURED for the rest of the round. They cannot hold office or be issued any warrant. Alderman seat vacates if they held it.

---

## Session schedule

Resolutions fire at:

1. **10 minutes after round start** (roundstart session - urgency because of the roundstart blockade).
2. **30 minutes after round start** (second roundstart session).
3. **Every economic day-tick thereafter** (dawn transition; `GLOB.dayspassed++` edge).

Voting window: continuous between resolutions. There is no "open/close" gating - votes can be cast at any time and are overwritten by later votes from the same mob.

At resolution:
- Tally all motions.
- Announce outcomes via `priority_announce` with title "CITY ASSEMBLY" and appropriate fanfare.
- Apply side effects (elect, recall, censure, set caps, levy tax).
- Clear vote state **except Speaker identity, warrant caps, and censure list**.
- Open the next session.

---

## Vote weights

The Assembly is Commons-only: every townie votes except Keep members, Inquisition, and the civic-dead (no job / Wretch / outlaw). Grouping is done by `assembly_department(job)` in [motions.dm](../../code/controllers/subsystem/rogue/city_assembly/motions.dm), which maps each job title to a department symbol. Weight then follows from the department.

| Department | Weight | Jobs (examples) |
|------------|--------|------|
| `KEEP` | 0 (no vote) | Crown nobility (Duke, Consort, Prince, Princess, Regent, Lord, Lady); Retinue (Hand, Clerk, Councillor, Seneschal, Steward, Suitor, Servant, Knight, Marshal, Squire); Garrison (Sergeant, Man at Arms, Warden, Watchman, Veteran) |
| `INQUISITION` | 0 (no vote) | Inquisitor, Absolutionist, Orthodoxist |
| `EXCLUDED` | 0 (no vote) | Wretch, Bandit, Assassin, Lunatic |
| `NONE` (no job or unknown) | 0 (no vote) | - |
| `TOWN_TRANSIENT` | 1 (2 with TRAIT_RESIDENT) | Adventurer, Mercenary (all mercenary-guild subjobs), Trader, Pilgrim, Villager, Sellsword |
| `TOWN_PEASANT` | 1.5 (2 with TRAIT_RESIDENT) | Peasant, Towner, Sidefolk, Serf, Vagabond |
| `TOWN_BURGHER` | 2 | Innkeeper, Guildsman, Archivist, Apothecary, Tailor, Crier, Physician, Tradesmith, Magicians Associate, Jester, Burgher, Resident, Keeper |
| `TOWN_CLERGY` | 2 | Priest, Acolyte, Druid, Sexton, Templar, Martyr |
| `TOWN_NOTABLE` | 4 | Court Magician, Merchant, Guildmaster, Bishop, Bathmaster, Head Physician, Town Elder |

Weights stored as `display * 2` internally (1.5 becomes 3). Residency uplift (TRAIT_RESIDENT) raises any sub-2 weight to a flat 2 - letters of citizenry grant full burgher voice. Outlaws always return 0 regardless of job.

## Quorum

A session must register at least **3 distinct voters** (across any motions) for its results to apply. Below that, the session resolves as **status quo** - no election change, no warrant cap change, no levy, no recall/censure. The announcement notes the quorum failure.

This blocks a single heavyweight voter from pushing motions through in a dead session.

Internally weights are stored as `int * 2` so fractional 1.5 becomes 3. All math operates on doubled integers; display divides by 2.

**Eligibility**:
- `HAS_TRAIT(user, TRAIT_OUTLAW)` -> weight 0, cannot vote or hold office.
- `stat == DEAD` -> cannot vote; cannot hold office.
- No client connection -> cannot vote (but mob still "holds" the seat if Alderman; see resignation rules).

---

## Warrant mechanics

The Alderman holds a `/datum/assembly_warrant` referenced on `SScity_assembly.current_warrant`. The warrant tracks:

```
trade_authority_daily_cap     - set by last session's Trade Auth vote
trade_authority_remaining     - decremented by manual_import/export burn
defense_authority_daily_cap   - set by last session's Defense Auth vote
defense_authority_remaining   - decremented by contract ledger burns
```

At each day-tick, `remaining = daily_cap` (full refresh; unused evaporates).

**Alderman uses existing UIs**. Trade goes through Steward trade UI at the Nerve Master. Defense commissions go through the Contract Ledger. Both gates add a branch: "authorized if Steward/Regent/etc. OR Alderman with remaining warrant."

**Zero mammon minting**. Burns still come from Crown's Purse (trade) and Burgher Pledge (defense) - the warrant is a parallel ceiling, not a new currency. Only the Poll Tax 2x multiplier mints new Pledge.

**Mob-tracked** (weakref). Mob destroy/ghost/dead -> auto-resign (seat vacates, announcement fires).

**Far-travel exploit**: intentionally unguarded. Admin logs catch alt-scumming per user directive.

---

## Steward vs Alderman coexistence

Both draw from the same Crown's Purse / Pledge fund. If Steward spends first, less is available for the Alderman. No veto, no exclusion code.

Censured mobs cannot hold office, cannot be issued warrants. Censure persists round-long.
>>>>>>> Stashed changes

---

## Hard implementation rules

<<<<<<< Updated upstream
- **Vote by ckey, not by mob.** Every vote callsite: `session.votes[user.ckey] = choice`.
- **Outlaws cannot vote, propose, or be Speaker.** `HAS_TRAIT(user, TRAIT_OUTLAW)` is the check.
- **All fund moves route through `SStreasury.mint()` / `burn()` / `transfer()`.** Never touch `fund.balance` directly except to read.
- **All stockpile actions route through existing `SSeconomy.do_import()` / `do_export()`** (or the per-stockpile equivalents in `code/modules/roguetown/roguestock/`). Do NOT reimplement stockpile mutation.
- **All quest issuance routes through the existing pool/landmark/materialize path.** Do NOT duplicate quest-spawning logic.
- **Weighted-majority check**: `yea_weight > nay_weight` → pass. `yea_weight == nay_weight` → fail (no ties pass).
- **Log every proposition, vote, and execution** to `log_game` AND append to `SSestates.history`.
- **No hardcoded chamber lists in prop logic.** Chamber membership (all non-outlaw players) is resolved once per session via `SSestates.get_eligible_voters()`.
- **Prop subtypes own their own validation.** `/datum/estates_prop/proc/validate()` returns `TRUE`/`FALSE` with a reason string. Base calls it before the vote opens; `execute()` re-checks (state may have changed).

---

## Architecture skeleton

```
/controllers/subsystem/SSestates (new)
  - schedule: list of (session_time, session_object)
  - current_session: /datum/estates_session or null
  - history: list of resolved sessions
  - assembly_budget_fund: /datum/fund/assembly
  - proc/get_vote_weight(mob)
  - proc/get_eligible_voters() → list of ckeys
  - proc/fire() — ticks session state machine

/datum/estates_session
  - state: SCHEDULED|OPEN|CLOSED|RESOLVED
  - opens_at, closes_at
  - pending_motions: list
  - tabled_motion: current motion being voted on
  - votes: ckey → choice
  - speaker_ref: weakref
  - history_entries: list

/datum/estates_prop (base)
  - proposer_ckey
  - description
  - proc/validate() → TRUE/FALSE
  - proc/execute() → TRUE/FALSE
  - proc/describe() → string for UI

/datum/estates_prop/economic/import
  - good_id, amount
/datum/estates_prop/economic/export
  - good_id, amount
/datum/estates_prop/commission/defense
  - region_id, tier

/obj/structure/roguemachine/estates
  - TGUI frontend
  - attack_hand → ui_interact
  - ui_act handlers route to SSestates.propose/vote/table/claim_speaker

tgui/interfaces/EstatesAssembly.tsx
  - Session status card
  - Motion queue
  - Active vote panel
  - History panel
  - Propose form
=======
- **Never mint mammon from Assembly votes** except the explicit Poll Tax 2x path.
- **All Crown's Purse / Pledge moves through `SStreasury.burn/mint/transfer`** - never touch `fund.balance` directly except reads.
- **All stockpile actions through `SSeconomy.manual_import/manual_export`** - do NOT reimplement.
- **Warrant decrements happen on successful burn**, not on attempt. Use the proc's return value.
- **Mob weakrefs for all Assembly state**. Hook Destroy/death/ghost to auto-resign.
- **Vote overwrites are idempotent** - same mob voting twice just replaces their ballot.
- **No propose-queue code.** The motion slate is hard-coded.

---

## Architecture

```
/code/__DEFINES/city_assembly.dm                    - constants, brackets, weights, timings
/code/controllers/subsystem/rogue/city_assembly/
  _subsystem.dm                                      - SScity_assembly singleton
  session.dm                                         - /datum/assembly_session
  warrant.dm                                         - /datum/assembly_warrant
  vote.dm                                            - tally helpers
  motions.dm                                         - motion resolution procs
/code/modules/roguetown/roguemachine/noticeboard/
  assembly_floor.dm                                  - TGUI wrapper on the noticeboard
/tgui/packages/tgui/interfaces/CityAssembly.tsx      - voting UI

// Edits
/code/__DEFINES/traits.dm                            - TRAIT_ALDERMAN, TRAIT_ALDERMAN_CENSURED
/code/modules/roguetown/roguemachine/steward/steward.dm
                                                     - trade handlers respect Alderman warrant
/code/modules/roguetown/roguemachine/questing/contract_ledger/contract_ledger.dm
                                                     - can_commission respects Alderman warrant
/code/modules/roguetown/roguemachine/questing/contract_ledger/steward.dm
                                                     - decrement Alderman warrant on commission
/code/modules/roguetown/roguemachine/noticeboard/noticeboard.dm
                                                     - Assembly category
/code/__HELPERS/time.dm                              - day-tick hook -> SScity_assembly.on_day_tick()
/code/modules/admin/verbs/economic_panel.dm          - test actions
>>>>>>> Stashed changes
```

---

<<<<<<< Updated upstream
## Files to read first (conventions to mirror)

- `code/modules/politics/decree.dm` + `decree_api.dm` + `decrees/*.dm` — datum lifecycle pattern
- `code/controllers/subsystem/rogue/treasury.dm` — fund API, Burgher Pledge refill pattern
- `code/modules/roguetown/roguemachine/questing/contract_ledger/*.dm` — TGUI-machine pattern, commission_defense_from_tgui in particular
- `tgui/packages/tgui/interfaces/ContractLedgerSteward.tsx` — TGUI frontend pattern
- `code/controllers/subsystem/rogue/economy/economy.dm` — do_import / do_export
- `code/__DEFINES/banking.dm` — CURRENCY_* defines, BURGHER_PLEDGE_* pattern

---

## Failure modes to handle

| Scenario | Solution |
|----------|----------|
| Vote spam | 2-minute per-proposer cooldown; 3-motion-per-session cap |
| Reroll exploits | Vote by ckey |
| Dead Speaker blocks queue | 60-second auto-table if no Speaker action |
| Budget insufficient at execute time | Fail with INSUFFICIENT_AUTHORITY log; motion did pass but didn't fire |
| Lowpop one-person vote | Intentional — weight scales, one voter can carry if their weight is high enough. This is a *design feature*, not a bug. |
| Stockpile full on import | Prop fails validation at vote-open; won't even be tabled |
| Blockade in target region | Import/export prop fails validation at execute time if the region went blockaded mid-vote |
| Lord suspends Golden Bull mid-session | No effect on Assembly — Assembly budget is independent currency |
| Motion queued right before session close | Motions that haven't tabled by session CLOSE are discarded (not carried to next session) |

---

## Definition of done

1. `SSestates` subsystem compiles and initializes.
2. Three sessions schedule at roundstart (10m / 30m / 60m).
3. At the 10-minute mark, Extraordinary Session opens with a priority announcement.
4. A player walks to `/obj/structure/roguemachine/estates` in the throne room and opens the TGUI panel.
5. A non-outlaw player clicks "Claim Speakership" and becomes Speaker.
6. Any player proposes `commission/defense` on a blockaded region. Motion enters queue.
7. Speaker tables the motion. 90-second vote window opens.
8. Three players vote with different weights. Weighted majority is tallied at window close.
9. If passed, the defense writ is printed at the Estates machine, budget is burned, log entry created.
10. At session CLOSE, unused budget evaporates. Session transitions to RESOLVED.
11. Round-end chronicle panel displays all sessions' motions and outcomes.
12. Economic motion (import 10 grain) works end-to-end through `SSeconomy.do_import`.
13. Outlaw attempting to vote/propose/speak is rejected at every gate.

---

## Commit strategy

Ship this as **one feature commit**, not split across many. Estates is a
tightly-coupled system and partial commits won't compile / run. Expected
touches:

- 1 new subsystem file
- 1 new datum file (prop base + subtypes)
- 1 new session datum file
- 1 new machine file
- 1 new TGUI file (.tsx + styles if needed)
- ~3 DEFINES updates (currency, constants)
- 1 treasury.dm edit to surface assembly_budget_fund balance (optional)
- 1 round-end panel edit for chronicle integration
- Map file edit to place the throne-room machine

Single commit, body has a short testing checklist.

---

## When in doubt

- **Prefer reuse over invention.** If the Contract Ledger or Treasury already
  has a proc that does 80% of what you need, use it and don't write a new one.
- **If you're adding a second subsystem, stop.** Estates is one subsystem.
- **If you're tempted to add a new currency for commissions separate from
  Assembly, stop.** Just one currency: `CURRENCY_ASSEMBLY`.
- **If scope creeps into Stage 2 (revolt, charter toggles, vetoes), stop.**
  Write a note in a `## Stage 2 Ideas` section of this doc instead.
=======
## Testing checklist

Exposed via admin Economic Panel:

1. **Advance session** - skip to next resolution without waiting.
2. **Seed test votes** - spawn N phantom ballots on each motion to verify tally math.
3. **Force elect** - bypass vote; promote a selected mob to Alderman.
4. **Drain warrant** - zero out remaining authority to test exhaustion path.
5. **Refresh warrant** - reset caps without day-tick.
6. **Censure mob** - apply TRAIT_ALDERMAN_CENSURED to a selected mob.
7. **Levy poll tax** - run the levy without a session vote.

---

## Stage 2 Ideas (DO NOT IMPLEMENT)

- Multi-chamber split: Commons / Peers / Synod.
- Revolt ultimatums: anonymous ballot listing estate demands; if Crown rejects, antag datums auto-apply to supporting estates; Crown mechanically cannot revoke acceptance mid-round.
- Veto powers: Grand Duke / Regent can veto Assembly outcomes at Pledge cost.
- Co-sponsor path for player-proposed motions (replacing fixed slate with optional extras).
- Per-chamber vote weights and chamber-specific motion types.
>>>>>>> Stashed changes
