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

---

## Hard implementation rules

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
```

---

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
