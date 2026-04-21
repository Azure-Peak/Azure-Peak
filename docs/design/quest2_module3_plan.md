# Quest 2 - Module 3 Implementation Plan

Working plan for Quest 2 Module 3: the Steward, Treasury, and Innkeeper rework. Bundled with Module 2 (marker rework) into a single PR because the pieces interlock too tightly to ship separately.

Last updated: 2026-04-21

## Design thesis

Fractional reserve banking in the current system is a hidden subsidy. The crown treats every deposited mammon as de-facto crown wealth: the unified `treasury_value` pool operates on 100% of all deposits plus generated inflation, and fails only in the theoretical case of a bank run — which in a 3-hour SS13 round basically never happens. A player earning 500 mammon and stashing it in a bank account is, functionally, lending it to the crown at 0% interest with no recall mechanism. The crown silently consumes idle deposits to fund wages, shop purchases, garrison buys, and anything else, without asking permission, because the pool is abstract. The typical 4-5k in adventurer quest earnings that never get withdrawn becomes 4-5k of free crown working capital.

Module 3 removes this silent subsidy. Fully-backed accounts mean the crown can no longer claim idle deposits. A player's 500 mammon is *actually* theirs, reachable to the Steward only via voluntary flows (the player buys goods, creating a shop margin for Crown's Purse), coercive flows (fine, rate-limited to 3/day and percentage-capped), or consensual flows (loan, repaid with interest). That's it.

The emergent effect is that **the crown is nominally richer but materially poorer**. Total mammon in the system goes up (no fractional reserve lets it collapse to claims), but the Steward's *spendable* wealth is tightly constrained because every mammon has a ledger home that isn't the crown's. More coins in play, less freedom to use them.

This flips the Steward's incentive structure:

- From "custodian of the common pool" to "manager of a crown business that happens to operate in an economy of individuals"
- From "authoritarian seizure" to "entrepreneurial margin generation"
- Incentivizes *lowering* stockpile prices to encourage player purchases (because account hoarding doesn't help the crown anymore — only circulating mammon does)
- Incentivizes *more* quest flow to keep adventurer activity high (mints from Defense Budget circulate through shops → margins → Crown's Purse)
- Makes loans attractive (converts static account wealth into active Crown's Purse income via interest, while giving players who need it a bootstrapping tool)
- Makes fines *politically meaningful* because they're rate-limited — the Steward has to *choose* fine targets rather than tax everyone evenly

A well-played Steward becomes a useful economic actor. A careless or greedy one drives the crown insolvent, broadcasts the failure to the round, and creates narrative consequences. Neither outcome was available under fractional reserve because the pool was too abstract to visibly fail.

## Guiding design decisions (locked in during design review)

1. **Three-tier mammon model.**
   - **Physical (coin-backed)**: individual bank accounts, Crown's Purse Budget. Withdrawable as coins at a MEISTER. Transferable.
   - **Authority (abstract)**: Defense Budget, Innkeeper Rumor Points. Not withdrawable, not robbable, not transferable. Manifests into physical coin only when a funded quest completes.
   - **Generation (spigots)**: rural tax, treasure resale, farming, noble estate income, quest-completion mints from authority budgets. These are the only sources of new physical mammon.
2. **Fractional reserve is gone.** Every physical mammon has a ledger home: account, Crown's Purse, or coin-in-world. Conservation is auditable via a debug proc.
3. **Defense Budget and Rumor Points decrement on quest issuance**, not on completion. Prevents parking quests to hoard authority across days.
4. **Innkeeper is an issuer, not a curator.** The design-review critique argued for curator-only; the author accepts the money-printer tradeoff with the mitigation that Innkeeper-issued quests supply ~40-50% of round quest volume (passive pool covers 50-60%).
5. **No loan fractional-reserve accommodations.** Fully-backed accounts make loan auto-charge well-defined.
6. **One concurrent loan per debtor.** Keeps auto-charge simple and prevents stacking.
7. **Decree system gates the strongest Steward powers.** Four decrees enacted at roundstart protect burghers (Great Charter, which also gates Defense Budget), church (Concordat), inquisition/psydonites (Edict of Tolerance), and nobles (Charter of Noble Rights). Lord controls decree state with a 30-minute cooldown per change. Political weight is the feature; revoking an immunity is a chat-broadcast, IC-visible political act. Decrees ship *first* (M3-C3) so the rest of the module is built against the assumption that factions are protected by default.
8. **In-game day = 30 real minutes. Week = 7 days = 3.5 real hours.** Loan interest ticks daily, budgets replenish daily, region events fire daily.
9. **No Steward-sabotage mitigations in MVP.** A bad-faith Steward dumping Crown's Purse into a single 5000-mammon bounty is a social problem (fire the Steward next round), not a mechanical one.
10. **Noble estate income stays as a Tier 3 mint (current behavior).** Treating nobles as crown employees would be a much larger political shift; defer.

## Numbers (placeholders, tune in playtest)

| Knob | Value |
|------|-------|
| In-game day | 30 real minutes |
| Week | 7 days (3.5 hours) |
| Starting Crown's Purse | 2000 mammon |
| Defense Budget base (daily refill) | 400 mammon authority |
| Defense Budget max carryover | 200% of base = 800 mammon authority |
| Rumor Points starting balance | 12 points (2x base) |
| Rumor Points daily refill (base) | 6 points |
| Rumor Points per-player bonus | +0.25 / active player / day |
| Rumor Points quest cost (Retrieval) | 1 point |
| Rumor Points quest cost (Kill / Courier / Clear Out) | 2 points |
| Rumor Points quest cost (Raid / Outlaw) | 3 points |
| Poll Tax default rate (all 11 categories) | 10 mammon / day |
| Poll Tax prepay grace window | 10 minutes from round start (no prepay allowed) |
| Poll Tax max prepaid grace days | 7 (roughly a full round's worth) |
| Poll Tax max rate | 50 mammon / day |
| Poll Tax debtor threshold | 2 consecutive days unpaid |
| Golden Bull burgher poll tax cap | 25 mammon / day |
| Rural tax | 50 mammon / 6 min (unchanged) |
| Rural tax route | → Crown's Purse only |
| Starting bank accounts | ECONOMIC_* (unchanged) |
| Loan minimum | 50 mammon |
| Loan interest on issuance | 25% of principal (flat) |
| Loan daily interest accrual | 25% of original principal per day |
| Loan term | 2 or 3 days |
| Max concurrent loans per debtor | 1 |
| Fine frequency cap | 3 uses / day / Steward |
| Fine max % (non-burgher) | 75% of account balance |
| Fine max % (burgher) | 25% of account balance |
| Innkeeper Guild's Cut (passive) | 10% of every quest reward |
| Innkeeper Rumor-quest bonus | 25% of quest reward (minted, paid to Innkeeper) |
| Decree cooldown (revoke or grant) | 30 minutes per decree |
| Savings Goal threshold | 200 mammon at round-end |
| Savings Goal reward | +1 triumph per eligible player who met it |

## The three budgets

### Bank accounts (physical, per-player)
Owned by individual players. `SStreasury.bank_accounts[ckey]` → integer balance. Fully withdrawable at a MEISTER, which spawns physical coins. Robbable via Coveter Crown. Fineable by Steward within category limits and decree constraints.

**Audit note**: current implementation mixes ckey-keyed and mob-keyed entries. Module 3 normalizes to ckey-only in a prerequisite commit.

### Crown's Purse Budget (physical, pooled)
Owned by the crown. `SStreasury.discretionary` → integer balance. Steward withdraws at their Nerve Master machine, spawning coins (same mechanic as personal withdrawal, just that the authorized withdrawer is the Steward role). Fineable to? No — the Crown's Purse is above taxation. Robbable via a future jawbank heist mechanic if we care (not in MVP). Replenished by rural tax, treasure resale split, taxation, import/export margin.

**Crown's Purse funds every physical crown expense**: keep salaries, import/export purchases, any bespoke Steward spending. Steward *can* voluntarily fund a quest from Crown's Purse but it competes directly with payroll — every mammon spent here is a mammon not paying next week's wages. That's an intentional political tradeoff, not a default action; most Stewards will use Defense Budget authority to fund quests instead.

### Defense Budget (authority, pooled)
Owned by the Steward. `SStreasury.defense_budget` → integer, "authority points." Not physical. Not withdrawable. Fully decoupled from Crown's Purse and rural tax — authority is not fueled by any wealth flow. Decrements on quest issuance. Replenishes daily to a cap from nothing. Surplus beyond 200% of daily refill is clawed back at each daily tick. Cannot be transferred to or from Crown's Purse.

On quest completion, the reward mints coins into the adventurer's hands (and Innkeeper's account for the Guild's Cut). Mint events are logged and tracked in `verify_mammon_conservation()` as known inflow sources.

### Rumor Points (authority, Innkeeper-only)
Realm-scoped pool owned by whoever holds the Innkeeper role this round. `SStreasury.rumor_points` → float (stored as float so the 0.25/player accrual is lossless across many days; UI rounds to integer for display). Decrements on Innkeeper quest issuance. Cannot be transferred.

**Accrual:** Starts at 12 points at round start (two days' worth of base income — lets the Innkeeper issue something interesting within the first hour without grinding). Daily refill at dawn = 6 + (0.25 × active_player_count). `active_player_count` is the existing `/proc/get_active_player_count()` helper: connected-and-minded players, excluding lobby and players who started as observers. Same call Burgher Bond refill uses, so scaling is consistent across the module. On a 15-player round this is ~9.75/day; over 5 days a full round yields ~60 points total.

**Costs:** Tiered by quest type — Retrieval 1, Kill/Courier/Clear Out 2, Raid/Outlaw 3. On a 60-point-budget round the Innkeeper can issue ~20-30 quests depending on mix, hitting the 40-50% of round quest volume target when paired with the passive pool. Retrieval is the *primary* channel because it's the type the Innkeeper is best placed to flavor ("I heard the apothecary's lost locket is at X") — see "Innkeeper — Rumor Quests" below.

**No carry cap.** Unlike Defense Budget, Rumor Points do not claw back surplus. Innkeeper hoarding is fine — a quiet first half-round becoming a busy second half is a natural pacing shape.

## Conservation invariant

`sum(all_accounts) + discretionary + coin_in_world = physical_mammon_total`

Defense Budget and Rumor Points are *not* in this sum — they're authority, not money. When a Defense-funded quest completes, the reward materializes as coin and is added to the physical total (this is a mint event, logged).

Ship a `/datum/controller/subsystem/treasury/proc/verify_mammon_conservation()` admin proc that walks this sum and warns if drift is detected. This is the testing tool for the entire module.

## Loan system

### Datum

```
/datum/loan
    var/real_name           // debtor's real_name at issuance, for display/RP
    var/debtor_ckey         // canonical key for auto-charge
    var/original_principal  // fixed at issuance, never changes
    var/principal_paid = 0  // tracks repayment progress against principal
    var/interest            // accumulates; starts at original_principal * 0.25
    var/issue_time          // world.time
    var/term_days           // 2 or 3
    var/lender_ckey         // Steward who issued (for logs only)
```

### Computed values

- `outstanding_principal = original_principal - principal_paid`
- `balance_owed = outstanding_principal + interest`
- `is_delinquent = world.time > issue_time + (term_days * 30 MINUTES)`

### Flow

1. Steward uses "Issue Loan" verb → picks debtor (must have bank account, must have no existing loan), picks amount (min 50), picks term (2 or 3 days).
2. Loan paper spawns, hands to debtor.
3. Debtor consents → `/datum/loan` created, `interest = original_principal * 0.25`, amount transferred from Crown's Purse to debtor's account.
4. Each 30-minute tick: `interest += original_principal * 0.25` for every outstanding loan.
5. Same tick: if loan is delinquent AND `debtor.account >= balance_owed`, auto-charge: full balance transferred from account to Crown's Purse, loan `qdel`'d, debtor notified in chat and in bank log.
6. Manual repayment at Steward machine: repayment amount clears `interest` first, then increments `principal_paid`. Money flows account → Crown's Purse. If `balance_owed == 0`, loan `qdel`'d.
7. If debtor permanently dies, the loan stays on `SStreasury.loans`. Steward has IC justification to recover via garrison, stripping the corpse, etc. Not auto-cleared.

### Edge cases

- **Fine-before-autocharge on same tick**: fine processes independently. If a fine drains the account below `balance_owed`, autocharge that tick does nothing; the loan stays delinquent until the account recovers or the Steward intervenes.
- **Debtor logs out with loan active**: loan persists on `SStreasury.loans`. If they come back, everything resumes.
- **Steward leaves job mid-loan**: loan is on `SStreasury`, not the Steward's mind. Next Steward inherits the book.
- **Crown's Purse empty when repayment occurs**: money flows into Crown's Purse anyway. Repayment is additive to Crown's Purse's current balance.

## Decree system

Decrees are the core political tension mechanic of Module 3. The Duchy ships every round with four decrees already enacted; most of the town's wealthiest and most organized factions sit under at least one of them and are therefore tax-and-fine immune by default. The Steward can only broaden their tax/fine reach by convincing the Lord to *publicly revoke* a decree — a cooldown-gated, chat-broadcast, politically loaded act that tells the affected faction exactly who is about to come for their wealth.

**Why decrees ship first**: the tension of the crown juggling / revoking / issuing these laws is a core driver of in-round conflict. Without decrees in place, the fiscal pressure of the budget split doesn't have a political texture — it's just "Steward taxes everyone evenly." With decrees in place, every revocation is an explicit declaration of *which faction the crown is choosing to pressure this time*. Ship decrees early so the whole rest of the module is built on the assumption that they exist.

### The four starting decrees (all enacted at roundstart)

| Decree | Default | Effect when ON | Effect when REVOKED |
|--------|---------|----------------|---------------------|
| **The Great Charter** | ON | Burgher fines capped at 25%; burgher taxation restricted. **Defense Budget is active.** | Steward loses access to the Defense Budget entirely — the burghers withdraw their voluntary contribution to common defense because the crown has stopped protecting them. |
| **The Concordat** | ON | Church-category accounts are fine/tax immune. | Steward may fine the Church at standard percentages. Chat broadcasts the act to all players — the Church *knows* the crown is about to come for its wealth. |
| **The Edict of Tolerance** | ON | Inquisition roles and up to 3 "Declared Psydonites" (flagged by the Inquisitor) are fine/tax immune. Flavored as a diplomatic accommodation to Otava/Psydonia. | Inquisitors and Declared Psydonites become fineable. Creates a diplomatic incident narratively; the Inquisition is likely to retaliate politically. |
| **Charter of Noble Rights** | ON | Nobles (Knights, Squires, etc.) cannot be fined; noble taxation is capped low. | Nobles become fineable at standard rates. Least likely to be revoked because Knight/Squire loyalty is load-bearing for the round's combat capacity — revoking this risks a military crisis. |

### Revocation mechanics

- Each decree is revoked/granted via a dedicated **Lord-only** TGUI panel (not Steward-accessible).
- **30-minute cooldown** per decree state change, in either direction. Revoking and re-granting the same decree therefore occupies a full in-game hour — the "flash fine" window is bounded.
- On revocation, a chat broadcast fires to *all players*: *"By decree of the Lord, the Concordat is suspended. The Crown may now levy against the Church."* (And symmetric broadcast on re-grant.)
- Decrees also land on a roguemachine / public display somewhere (noticeboard or similar) so they're discoverable without catching the chat line.
- **Special case: The Great Charter** — revoking it doesn't just enable burgher fines, it *disables* the Defense Budget for the remainder of the round (or until re-granted after cooldown). This is the mechanical teeth behind the "burghers withdraw common defense funding" flavor. Steward quest issuance from authority *dies*. Re-granting the Great Charter restores Defense Budget replenishment from that day's tick onward (no retroactive refill).

### The fiscal reality this produces

At roundstart, the town has 5000-7000 mammon distributed across ~130 accounts. **The crown cannot tax or fine most of it.** Nobles are Charter-protected. Church is Concordat-protected. Inquisition and their Declared are Edict-protected. Burghers are Great-Charter capped. That leaves:

- **Peasants** (unprotected by any decree): fully fineable at 75%
- **Adventurers / Mercenaries** (unprotected): fully fineable at 75%
- **Anyone without a protecting decree**

These are the groups the crown can *bully, cajole, or persuade* into providing income — and the rate-limit of 3 fines per in-game day means even this reach is narrow. The Steward must:

1. Earn Crown's Purse through **voluntary flows** — stockpile purchases, import/export margins, loans with interest, deposit taxes at creation time
2. **Persuade** individual players to contribute, pay for services, or take loans
3. **Force** the narrow unprotected population via fines, judiciously
4. **Convince the Lord to revoke a decree** when the narrow approach isn't enough, accepting the political backlash from whichever faction just lost its immunity

This matches a realistic medieval / Renaissance fiscal state: land-rich, politically complex, chronically cash-strapped because the wealthy are legally shielded, forced to negotiate rather than command. The inversion from current AP (where the crown silently seizes 40-70% of every deposit via fractional reserve) is total: **the crown must now work for its money**, and every attempt to broaden its reach has a visible political cost.

### Patronage grants — the per-faction protection layer

Decrees protect factions *by category*; patronage grants protect *individuals* by choice. Each major faction with decree protection also gets a grant mechanic letting them extend their protection to individuals (typically adventurers / mercenaries / unaffiliated players), creating political retainership.

The point: decree protection is broad and automatic, but grant protection is **patronage currency**. A faction with grant slots has something to trade for loyalty, information, or cheap mercenary service. An unprotected player who accepts a grant picks up fine/tax protection in exchange for implicit allegiance to the granting faction.

| Granter | Grant type | Slots | Revocation cooldown | Flavor |
|---------|-----------|-------|---------------------|--------|
| **Church clergy** | Declared Churchite | 3 per round | 5-10 minutes | Pastoral inclusion — "you are under the Temple's protection" |
| **Inquisitor** | Declared Psydonite | 3 per round | 5-10 minutes | Diplomatic orthodoxy — "you are a sanctioned ally of the Faith" |
| **Steward** | Burgher / Resident status | Unlimited, but per-grant cooldown | 5-10 minutes | Civic enfranchisement — "you are now chartered as a resident of Azuria" |

#### Common mechanics across all three

- **Consent required.** Every grant is a slip of paper (or equivalent prop) handed from granter to grantee. Grantee must physically accept to activate. No forced protection, no silent flagging.
- **Public chat broadcast on grant and revoke.** *"Father Valen has extended the Temple's protection to Bob."* Patronage is legible — other players can see who belongs to whom.
- **Grantor can revoke unilaterally** at any time after cooldown. This is the *teeth* of the patronage relationship: the carrot is protection, the stick is exposing the grantee to the Steward's fines. Without revocation, granting is gift-giving; with it, it's a retainer contract.
- **Stack-able across factions.** A player can be both a Declared Churchite AND a Burgher simultaneously. Each protection comes from a different granter, each revocable independently. Double-protection is possible; triple-protection (Churchite + Psydonite + Burgher) is possible if all three factions want the same person.
- **Protection ends if the decree backing it is revoked.** If the Lord revokes Concordat, Declared Churchites lose their protection for the duration of the revocation; if Concordat is re-granted, their protection returns. Same for Edict→Psydonites and Great Charter→Burghers.

#### Steward's unlimited-slot asymmetry

Church and Inquisition cap at 3 grantees. The Steward can charter as many Burghers as they want, bounded only by per-grant cooldown (~5-10 min between uses). Rationale: Burgher status is less potent than Churchite/Psydonite (25% fine cap vs. full immunity), and the Steward's whole job is expanding the fiscal body politic. But this creates **insider risk**: over-granting Burgher status means more players now under Great Charter protection, which means revoking Great Charter later (to broaden the crown's fineable population) blows up in the Steward's face by exposing their own grantees to fines AND killing the Defense Budget at the same time. Over-granting is self-hobbling.

#### Printing the slip

Each granter needs an in-game mechanism to spawn the paper prop:

- **Steward**: Nerve Master machine — existing infrastructure, add a "Issue Charter of Residency" button on the UI.
- **Church / Clergy**: needs a new device or altar mechanic. Probably a consecrated writ table near the Church's altar / sermon pulpit, or a verb on senior clergy roles. TBD in implementation — easier to code as a verb on the job than a new prop.
- **Inquisition**: similar — verb on the Inquisitor role, or a small prop at their station.

On issuance, the paper spawns in the granter's hands. It has a target name pre-filled (granter specified at the issuance dialog). Grantee clicks the paper → accept dialog → on accept, protection activates + chat broadcast.

#### Why it lands politically

This gives every protected faction a recruitment currency:
- **Church** can hire a combat-capable adventurer cheaply by offering protection + small mammon
- **Inquisition** can build an enforcement retinue by granting orthodoxy to mages / hunters willing to swear allegiance
- **Steward** can create a loyal burgher class that owes the crown civic gratitude — but whose continued protection depends on the Great Charter staying intact

The adventurer / mercenary player sits at the center of this — they have *three* potential patrons competing for their service, each offering different protection shapes and different obligations. That's real political texture, not just "pay mammon for sword swings."

### Decree interaction with the Lord's role

This design makes the Lord more politically central, not less. The Steward manages the crown's fiscal day-to-day; the Lord holds the keys to *which factions are fair game for taxation*. A cautious Lord leaves decrees in place and forces the Steward to make do. An aggressive Lord revokes decrees to fund expensive military projects, eating the political fallout. A corrupt Lord revokes Concordat specifically to fine the Church during a crisis, producing an IC conflict even if no one's playing antagonist.

The agent critique flagged this: "you've moved autocracy from Steward to Lord-via-Decree." The cooldowns mitigate the *speed* of Lord abuse (max 3 revocation windows per round per decree), but the political weight is the feature — the Lord's decree power is meant to be dramatic, visible, and contestable by in-character politics. Future work (Estates General, council consent) can add institutional checks if playtest shows the Lord's unilateral authority is too strong.

## Fine system

Steward invokes fine via `/datum/taxsetter` (existing infrastructure) or a new verb.

- **Per-Steward daily cap**: 3 fines per in-game day (30 minutes).
- **Category percentages** (applied to target's account balance), mediated by the four starting decrees:
  - **Peasants / Adventurers / Mercenaries / unprotected**: up to 75% (no decree covers them)
  - **Burghers** (Great Charter ON): up to 25% per fine | (Great Charter OFF): up to 75%, but Defense Budget also disabled
  - **Church** (Concordat ON): cannot fine | (Concordat OFF): up to 75%
  - **Inquisition / Declared Psydonites** (Edict of Tolerance ON): cannot fine | (Edict OFF): up to 75%
  - **Nobles** (Charter of Noble Rights ON): cannot fine | (Charter OFF): up to 75%
- Fine transfers directly from target account → Crown's Purse.
- Target chat-notified with reason text (free-text input by Steward).
- Logged in `SStreasury.event_log` with attribution.
- **Per-individual grants**: Declared Churchites (from Church), Declared Psydonites (from Inquisitor), and chartered Burghers (from Steward) carry their grantor's category protection. Fine system resolves protection via: *decree + role/category + active grants*, in that precedence. Grants stacked across factions (e.g. Bob is both Churchite AND Burgher) mean the strictest applicable protection wins. See Patronage grants subsection above.

## Directives (unfunded Steward quests)

In addition to Defense-Budget-funded quests (which mint mammon on completion), the Steward can issue **Directives** — unfunded civic calls-to-action with no monetary reward from the crown. The adventurers who take them are paid only by whatever loot their targets drop.

### Purpose

Directives exist for the fiscally pressed Steward who's burned through their Defense Budget for the day, or who wants to conserve authority for a bigger quest later. Instead of minting authority, they issue an appeal: *"Clear out the bandits on the Rockhill road. No crown bounty, but the loot is yours."* A Knight or Squire loyal to the crown may take it as civic duty; an adventurer short on paying work may take it hoping the bandit loot covers their effort.

Directives are the equivalent of a medieval lord "asking his knights to do their duty" — a power based on legitimacy, not wealth.

### Mechanics

- **Per-Steward daily cap**: 1-2 Directives per in-game day (30 minutes). Starts at 1/day; can be tuned up if playtest shows underuse.
- **Quest types allowed**: narrow. Only defensive / civic-benefit quest types that align with a Steward's legitimate authority to call civic duty:
  - `QUEST_CLEAR_OUT` (clearing out mob threats)
  - `QUEST_RAID` (clearing out larger hostile gatherings)
  - `QUEST_OUTLAW` (hunting down named threats)
  - Unblocking a blocked trade region route (a Directive variant of clearing a route-blockade)
  - No couriers, no retrievals, no "go fetch my mail" work — those aren't civic duty
- **No crown reward.** The quest scroll states plainly: *"Payment: none. Reward: the spoils of your labor."* The adventurer keeps all loot from slain targets.
- **No deposit required.** Directives are free to take — they're not contracts, they're civic calls.
- **Lands on the contract ledger** tagged `QUEST_SOURCE_DIRECTIVE`. Cosmetically different from paid contracts (perhaps different paper color / parchment style) so the difference is visible at a glance.
- **Stale-reroll applies**: if nobody takes a Directive within the standard stale threshold, it rerolls (same as pool quests). The Directive "slot" doesn't refund — unused Directives are just politely ignored by the populace.

### Why this lands

It gives the Steward a *rhetorical* tool to deploy when fiscal tools are exhausted. It's weak (nobody has to take it) but it's *always available* (even at insolvency). Knights and Squires who are Charter-of-Noble-Rights protected — and who were arguably the whole point of that protection — now have a specific civic reason their role exists: "I am protected, and in exchange I answer the Steward's civic calls." Makes noble loyalty a gameplay loop, not just a flavor detail.

It also creates an interesting free-rider dynamic for adventurers: if loot is valuable, a Directive is basically a "free quest" (no deposit, keep the kills). Economically rational adventurers take them. The Steward just has to issue Directives where the loot is actually worth the effort.

## The Blood Toll (Chronicle tab)

New Chronicle tab: **THE BLOOD TOLL**. Pure statistics — a tally of how many hostile NPCs of each type were slain over the round, shown at round-end alongside the existing Heroes / Villains / Outlaws tabs.

### Purpose

A deliberately understated piece of worldbuilding telemetry. No interpretation, no narrative, no "who killed most" leaderboard — just the numbers. *"142 wolves slain. 38 bandits killed. 12 bogmen cut down. 3 minotaurs felled."*

### Why this is worth shipping

- **Makes round-wide violence legible.** Players have only their own view of the round's combat. A Blood Toll shows the full shape of the round's war — was it a slow simmer or a bloodbath?
- **Adds weight to combat.** Every kill isn't just a personal stat; it's a tally mark in the duchy's chronicle. Gives kills narrative persistence.
- **Feeds future telemetry.** Combined with threat-region data (Module 3's region threat ticks, existing `SSregionthreat`), the Blood Toll becomes part of "how the round went for Azuria as a whole."
- **Low scope.** Hook into the existing mob death flow, increment a per-subtype counter, render in the Chronicle UI. Single commit, ~50-80 lines.

### Mechanics

- Hook: on `/mob/living/simple_animal/hostile/*` and `/mob/living/carbon/human/species/*` death events (anything with `ckey == null` that counts as a "hostile" kill). Increment `SSroundstats.blood_toll[subtype]`.
- Display grouped by type: wolves, bogmen, goblins, bandits, deep ones, minotaurs, etc. Sum presented as the total.
- Chronicle tab header: flavor line at top — *"So it is recorded, for the chronicler tallies every soul sent to the Halls."*
- No attribution (deliberately — no "who killed most" competition).

### Scope / commit target

Ship as a small standalone commit inside the Module 3 PR, possibly bundled with the Savings Goal commit (M3-C13) since both are roundend readout features.

## Internal trade regions

New datum: `/datum/internal_region`.

```
/datum/internal_region
    var/name                       // "Rockhill"
    var/lore                       // flavor text shown in UI
    var/list/exports               // goods this region produces (imports into AP)
    var/list/imports               // goods this region demands (exports from AP)
    var/route_blocked = FALSE
    var/price_modifier = 1.0       // multiplier on import/export prices
    var/current_event              // string key of active event, null if none
```

Starting regions (MVP):

| Region | Exports | Imports | Flavor |
|--------|---------|---------|--------|
| Rockhill | Wine, fruit | Iron, cloth | Orchard-and-vineyard hill country |
| Daftmarch fishing village | Fish, salt | Grain, timber | Coastal settlement |
| Stonevale mines | Iron ore, stone | Grain, ale | Remote mining outpost |
| Breadbasket meadows | Grain, vegetables | Tools, cloth | Agricultural heartland |
| Furthold trading post | Various | Various | Generalist outpost |

(Names are placeholders; swap in Pintlewaiver lore canon.)

### Tuning principle: prices respond to player behavior

Scripted events add variance; player-driven prices add depth. A region whose prices only move on RNG rolls becomes a mechanical script the Steward solves by round 3 of playtest. A region whose prices react to actual player behavior keeps giving the Steward something to do for the whole round.

Specific behaviors prices should respond to:
- **Stockpile fullness at AP**: if AP's stockpile of grain is near cap, new grain imports drop in value (the crown doesn't need more). Natural deflation prevents import-spamming one commodity.
- **Player purchase volume**: if players are buying wine heavily from the stockpile, the export price for wine *to* regions that import wine rises (AP can't meet both internal demand and external export at low prices). Natural inflation rewards the Steward for reading player demand.
- **Recent trade history**: regions "remember" big import/export spikes and adjust their own prices to match, creating short-term market inefficiencies the Steward can arbitrage.

This adds complexity but keeps the trade loop alive across the whole round. MVP can ship with simpler static-per-event prices and layer behavior-responsive prices in a follow-up commit if needed. Flag for playtest review.

### Region events

`SSregionevents` fires every in-game day (30 minutes). On fire, rolls a weighted event table per region:

- **No change** (most common)
- **Harvest boom**: relevant export price drops (AP imports it cheaply), stockpile bonus
- **Harvest bust**: relevant export price spikes (AP can profit by exporting replacement goods in)
- **Route blocked**: brigands / monsters block the route. Import/export to this region is suspended until a Steward-issued quest clears the route. The block auto-generates a clearable quest entry in the Defense Budget pool.
- **Route cleared**: blockade lifted (if one was active).
- **Caravan arrives**: temporary stockpile bonus.

**Roundstart**: at least 3 regions start with "Route blocked" to give the Steward an immediate to-do list.

### Import/export flow

Steward's Nerve Master UI gains a "Trade" tab listing regions, current prices, active events, blockade status. Pressing "Import" or "Export" spends Crown's Purse, routes goods to/from AP's stockpile, and credits Crown's Purse on profitable trades.

Import/export margin (profit the crown makes reselling to citizens) flows into Crown's Purse.

## Steward Defense Quests

Steward issues quests from the Defense Budget pool. Each issued quest:

- Costs authority equal to quest reward value (decrements Defense Budget on issuance).
- Lands on the Contract Ledger, same as passive pool quests. Source tagged `QUEST_SOURCE_DEFENSE`.
- Can be canceled by Steward while unclaimed; refunds authority.
- On completion, the reward is minted (spawns physical coin for the adventurer).
- If issued quest expires unclaimed (ledger stale-reroll threshold applies), authority refunds to Defense Budget.

Anti-parking: the one-to-one authority-quest coupling means parked quests tie up authority until they resolve. Steward cannot hoard authority by refusing to spend it.

## Innkeeper — Guild's Cut + Rumor Quests

### Guild's Cut (passive, 10%)

Any quest completed on the ledger credits the Innkeeper's personal account with 10% of the quest reward, **as a mint** (not deducted from the reward the adventurer receives). If no Innkeeper exists that round, the 10% is void.

### Rumor Quests (Innkeeper-issued, 25% cut + reward)

Innkeeper has their own Rumor Points pool (see "Rumor Points" above). Issuing a Rumor Quest decrements Rumor Points by a quest-type-specific cost.

**Parameters the Innkeeper picks at issuance:**
- **Type** — Retrieval / Kill / Courier / Clear Out / Raid / Outlaw. Cost scales with type.
- **Region** — which internal region the rumor points to. Drives marker selection.
- **Retrieval item** (Retrieval-only) — which specific item is "rumored to be at X." The Innkeeper's narrative flavor. Other quest types don't need this extra param.

**UI surface:** New Innkeeper-exclusive tab on the Grand Contract Ledger (the existing contract ledger that every quest-source posts through). Tab shows remaining Rumor Points, a "Compose Rumor" form with the parameters above, and a history of Innkeeper-issued quests this round.

**Retrieval-as-Innkeeper-staple:** Retrieval is priced cheapest (1 point) and the Innkeeper will issue most of them. Passive pool may still emit retrieval quests — this is not mechanically exclusive — but in practice retrieval supply shifts heavily toward the Innkeeper when the job is played, which is the intended flavor shift ("I heard..." vs. silent spawn).

- Rumor quests land on the Contract Ledger tagged `QUEST_SOURCE_RUMOR`.
- On completion: adventurer receives quest reward (minted), Innkeeper receives 25% bonus (also minted, deposited to their account).
- Rumor quests may be flavored "shadier" — narrative variance, not mechanical variance in MVP.

### Supply shape

Target: passive pool generates 50-60% of round quest volume, Rumor-issued 40-50% (when Innkeeper is played). If no Innkeeper, passive pool is 100% and threat supply drops — an intentional consequence of the job being unfilled.

## Poll Tax opt-out via Well Off virtue

Some players come to this game to RP in the tavern without interacting with Crown fiscal systems at all. The Poll Tax as currently designed is *everyone pays* (minus Charter exemptions), which is correct for the economic tension of the round but hostile to this playstyle.

The opt-out lives on the **Well Off** utility virtue (`/datum/virtue/utility/notable` in `code/modules/virtues/utility.dm`), as a fifth sub-option alongside Beauty, Stash, Residency, and Shrewd. The virtue uses `max_choices = 2`, so picking this opt-out costs the player one of their two Well Off slots — a real tradeoff, not free immunity.

### Mechanic

New sub-option `NOTABLE_TITHED` ("Paid Tithes" or similar IC name) — "I have squared my civic debts at the outset. The Crown has no claim on my purse."

Implementation: on virtue application, set `SStreasury.poll_tax_days_paid[recipient] = 999`. This re-uses the existing grace-days mechanism already built for the ATM-prepay flow — no new trait or exemption channel needed. The Steward's UI, once built, will show these players as "999 days grace" which is clear signal that they're IC-exempt via prior settlement rather than Charter-protected. Note the 7-day prepay cap (`POLL_TAX_MAX_GRACE_DAYS`, below) applies only to `poll_tax_prepay_days()` — direct assignment from the virtue bypasses it intentionally. This is why the virtue writes to the list directly rather than calling the prepay proc.

### Why this design

- **Re-uses existing plumbing.** Grace days already short-circuit `tick_poll_tax` cleanly; no new code paths to test.
- **Steward can still see them.** They appear on any future Fiscal tab as "tithed" rather than being invisible. This matters — the Steward shouldn't be surprised.
- **Costs a virtue slot.** The player forgoes Beauty / Stash / Residency / Shrewd for the peace-of-mind option. Non-trivial.
- **IC-legitimate.** Well-off burghers historically paid civic dues up-front in many medieval economies; this is period-appropriate.
- **Does not interact with debtor tracking.** Grace covers current-day obligation only; if these players somehow accrue arrears (e.g. from a period when they were briefly non-grace), debtor escalation still works as designed. But in practice they never accrue arrears because the 999-day buffer outlasts any round.

### Commit target

Lands in M3-C13 alongside Rumor Points, since both touch the Innkeeper/Towner axis of the system. Small enough to bundle without decomposing.

## Poll Tax prepay cap (7 days)

`POLL_TAX_MAX_GRACE_DAYS = 7` caps the amount of prepaid grace any single mob can hold via the `poll_tax_prepay_days()` proc. The cap is a single round's worth — typical rounds don't last longer than that, so in practice a burgher who prepays the full 7 is covered for the rest of the round at the rate that obtained at prepay time.

Why 7:
- A typical round is 3-5 in-game days. 7 days comfortably covers any round that actually happens.
- The cap exists to prevent rich players from hoarding grace across Steward rate changes ("buy 100 days at 1m/day before the Steward raises the rate") while still allowing "buy enough that I don't think about this again for the round."
- The effective rate at prepay *does* still respect in-game modifiers (Charter exemption → can't prepay at all, Golden Bull → burgher rate capped at 25m). `get_poll_tax_rate_for()` is the single source of truth for the charged rate in both the tick and the prepay paths.
- Virtue-granted grace (NOTABLE_TITHED, sets `poll_tax_days_paid[H] = 999`) bypasses the cap by writing to the list directly. The cap is a prepay-path concern, not a grace-storage concern.

ATM UI: the Meister's prepay flow clamps max days by both balance AND grace headroom, and surfaces current grace in the prompt so players can see why they're capped.

## Admin Economic Panel (test + live moderation)

A TGUI admin-only panel consolidating inspection and mutation verbs for the fiscal system. Accessible via **Debug → Economic Panel** for any admin with `R_ADMIN` or `R_DEBUG`.

**Contents:**
- Dashboard aggregates: Crown's Purse / Burgher Bond balances, total bank coin, avg balance, players under 50m, in-grace / in-arrears / debtor counts, loan count + exposure, rural tax YTD, noble income YTD
- Tick actions: Advance Day, Fire Poll Tick, Fire Loan Tick, Fire Bond Tick, Distribute Estates, Fire Payroll, Award Savings Goals
- Mint / burn into Crown's Purse
- Charter toggle (all four as full-width buttons with current state colored)
- Filter-driven player table: Category filter (11 options), Status filter (All / Arrears / Grace / Debtor / Low Balance / Exempt), substring name search. The table never renders all 150 players at once — always a filtered slice.
- Per-player detail pane: clear debt, add/remove grace, toggle TRAIT_DEBTOR, mint/burn to account
- Bulk actions operating on the current filter: clear debt / add grace to all matching

**Logging:** every write action uses the `admin_log_fiscal(detail, tally_label)` helper, which does `log_admin` + `message_admins(span_adminnotice(...))` + `SSblackbox.record_feedback("tally", "admin_verb", 1, label)`. Standard admin-action triad.

**Files:**
- `code/modules/admin/verbs/economic_panel.dm` — datum, opener verb, 20 action handlers
- `code/controllers/subsystem/rogue/treasury_snapshot.dm` — three reusable aggregator procs (`compute_fiscal_snapshot`, `compute_charter_states`, `compute_filtered_players`) — will back the Steward Fiscal tab too
- `tgui/packages/tgui/interfaces/EconomicPanel.tsx`

This ships before the Steward Fiscal tab and shares its aggregator procs. Testing infrastructure first, in-character UI on top.

## Steward Fiscal tab (consolidated treasury UI)

Right now fiscal controls are scattered:
- **TaxSetter TGUI** — Crown Levies + Poll Tax rates
- **Nerve Master HTML** — Salaries, decrees, Crown's Purse balance
- **Meister / ATM** — Personal account + loan repay + poll tax prepay
- **Loan contracts** — Issuance flow via paper

This is fine from an RP-object standpoint (each machine has its own IC identity) but it's bad information architecture for the Steward who has to keep all of it in their head. Proposed remedy: a **consolidated read-only Fiscal tab** on the Nerve Master that aggregates everything the Steward needs to see at a glance.

### Contents

- **Balances**: Crown's Purse, Burgher Bond, total in-circulation bank coin, rural tax YTD
- **Rates**: all 5 tax categories (Contract Levy, Headeater Levy, Import Tariff, Export Duty, Fine) + all 11 poll tax rates, displayed with Charter overlay (which are currently exempt/capped)
- **Loans**: outstanding loans with debtor name, principal, remaining due, days-until-default
- **Debtors**: list of TRAIT_DEBTOR holders with reason (loan default / poll tax arrears)
- **Poll Tax tracking**: per-category head count, total collected this round, who's in grace and who's in arrears
- **Decree status**: the four Charters' active/suspended state with day-counter to next revocation slot

Write-side actions stay on their current surfaces (TaxSetter for rates, Nerve Master for salaries, etc.) — the Fiscal tab is **read-only** so the Steward can see the whole picture at once without a new permission model.

### Why this matters

Poll Tax is now the Steward's primary player-facing lever (every round, every player, every day). Without a consolidated view the Steward has to clicker-drone through three separate machines to answer "is the treasury OK?". This is exactly the friction that makes players under-use the system.

### Scope / commit target

Separate commit, slotted after M3-C13 (Innkeeper) but before M3-C15 (docs+tuning). Roughly M3-C14b or similar. Read-only surface keeps the commit small — ~200-300 lines of TGUI + `ui_static_data` aggregator proc on the Nerve Master.

## PR decomposition

The full module ships in a single PR but decomposes into sequential commits. Each commit leaves the game compilable and playable.

### M3-C1 — `bank_accounts` key normalization
Pre-cursor refactor. Normalize `SStreasury.bank_accounts` keys to ckey-only. Migrate any mob-keyed lookup paths. No behavior change.

### M3-C2 — `SStreasury.transfer()` unified API
Introduce `/datum/controller/subsystem/treasury/proc/transfer(from, to, amount, reason)` routing all mammon movements. Audit the ~10 existing mutation sites (rural tax, coin insertions, payroll, interest, stockpile, fines, ATM drill, exports, noble distribution, deposit taxes) and migrate each to call `transfer()`. Still a single-pool world at this point; behavior unchanged. This is the **invariant foundation** — the audit surface for everything that follows.

### M3-C3 — Decree system + patronage grants
Ships before any budget/fine/quest work because every downstream commit assumes decrees and patronage exist. Covers both layers of the political protection system in one commit:

**Decrees**: four `/datum/decree` subtypes (Great Charter, Concordat, Edict of Tolerance, Charter of Noble Rights), all auto-enacted at roundstart. Lord-only TGUI panel for revoke/re-grant with 30-minute per-decree cooldown. Chat broadcast on every state change. Public noticeboard / roguemachine display of current decree status.

**Patronage grants**: three grant mechanics (Church → Declared Churchite, Inquisitor → Declared Psydonite, Steward → Burgher/Resident). Paper-prop consent flow (grantee must physically accept). 5-10 minute revocation cooldowns. Chat broadcasts on grant and revoke. Church and Inquisition: 3-slot cap each. Steward: unlimited issuance with per-grant cooldown. Grant infrastructure: Steward via Nerve Master UI (easy — extend existing), Church and Inquisition via verbs on the relevant job roles (TBD: decide prop vs. verb during implementation).

At this commit, decrees and grants exist but have nothing to gate yet — they compile clean and wait for subsequent commits to wire them into fines, budget, etc.

### M3-C4 — Budget split
Replace `SStreasury.treasury_value` with `.discretionary` (physical) and `.defense_budget` (authority). Route every income/expense site deliberately. Rural tax → Crown's Purse. **Great Charter wired**: Defense Budget replenishment is gated on Great Charter being ON; if revoked, the daily tick skips Defense refill. Re-granting resumes refill from next tick (no retroactive refill). Ship `verify_mammon_conservation()` debug proc.

### M3-C5 — Crown's Purse physicalization + salary routing
Steward's Nerve Master UI gains "Withdraw from Crown's Purse" flow. Coins spawn. **Salaries (`distribute_daily_payments`) now pull from Crown's Purse instead of the old unified treasury.** If Crown's Purse balance is insufficient to cover the full payroll at tick time, **no salaries pay that day** and a chat broadcast fires: *"The Crown is insolvent. No salaries have been paid this day."* Also logged in the event log. This is intentionally a visible, in-character failure so the Steward's fiscal mistakes reshape the political round. Update noble income distribution to pull from Crown's Purse (sanity check against current behavior — document whether change is needed).

### M3-C6 — Fine limits + category percentages
Per-Steward daily cap, category-based percentages, decree-gated exemption checks. Fine system reads decree state from M3-C3.

### M3-C7 — Loan datum + issuance + auto-charge
`/datum/loan`, `SStreasury.loans` list, issue verb, paper prop, consent flow, 30-minute tick hook, auto-charge logic, manual repayment UI. One-per-debtor enforcement.

### M3-C8 — Internal regions + trade UI
`/datum/internal_region` datums for 5 starting regions. Steward's trade UI. Import/export mechanics. Existing stockpile integration.

### M3-C9 — `SSregionevents` + event table
Event datums, weekly schedule, region-event interaction with trade prices and blockade state. Roundstart 3-blocked-region rule.

### M3-C10 — Defense Budget quest issuance
Steward UI to issue Defense-funded quests. Authority decrement on issue, refund on expire, mint on completion. Integration with existing Contract Ledger.

### M3-C11 — Steward Directives (unfunded civic quests)
Steward verb (via Nerve Master) to issue Directives: unfunded, no-deposit, narrow-type civic calls-to-action. Per-Steward daily cap of 1-2. Allowed types: Clear Out, Raid, Outlaw, Route-Unblock. Lands on Contract Ledger tagged `QUEST_SOURCE_DIRECTIVE` with visibly different parchment styling. Stale-reroll applies; unused Directive slots don't refund — civic calls can be ignored.

### M3-C12 — Innkeeper Guild's Cut (passive 10%)
Hook into quest completion flow. Credit Innkeeper's account. Handle "no Innkeeper exists" case.

### M3-C13 — Innkeeper Rumor Points + Rumor Quest issuance + Well Off poll-tax opt-out
`SStreasury.rumor_points` (float pool, start 12, daily 6 + 0.25/player). Tiered costs: Retrieval 1 / Kill+Courier+Clear Out 2 / Raid+Outlaw 3. Innkeeper-exclusive tab on the Grand Contract Ledger with Type / Region / (Retrieval) item parameters. `QUEST_SOURCE_RUMOR` tag; 25% mint on completion. Also in this commit: add `NOTABLE_TITHED` sub-option to `/datum/virtue/utility/notable` that sets `poll_tax_days_paid[H] = 999` on application (re-using grace-days plumbing, no new trait).

### M3-C14a — Admin Economic Panel (shipped)
Admin-only TGUI panel for inspecting and manipulating the fiscal system. Dashboard aggregates, filtered player table, per-player + bulk actions, tick triggers, charter toggles, Crown's Purse mint/burn. Every write action logged via shared `admin_log_fiscal` helper. Aggregator procs (`compute_fiscal_snapshot`, `compute_charter_states`, `compute_filtered_players`) live on `SStreasury` and are reused by M3-C14b.

### M3-C14b — Steward Fiscal tab (read-only consolidated treasury view)
Read-only aggregator tab on Nerve Master: balances (Crown's Purse, Burgher Bond, in-circulation coin, rural tax YTD), all 16 rates (5 levies + 11 poll tax) with Charter overlay, outstanding loans, TRAIT_DEBTOR roster with reason, poll tax head count + collection stats per category, Charter active/suspended state with cooldown counters. Write-side actions stay on their existing surfaces. Reuses the aggregator procs shipped in M3-C14a.

### M3-C14 — Savings Goal + Blood Toll + roundend civic stats
Two roundend readout additions bundled together since both hook into roundend reporting and the Chronicle UI:
- **Savings Goal**: Round-end proc iterates eligible players (Adventurer / Towner category flag, excluding Steward / Lord / nobles / quest-givers). For each whose bank balance ≥ 200, award +1 triumph. Emit roundend economic-report line tallying hit rate. New `SStreasury.record_savings_goal_result(ckey, met)` logs each outcome into the event log for diagnostics. No mid-round UI.
- **Blood Toll**: New Chronicle tab tallying all hostile NPC deaths over the round, grouped by subtype. Hook into mob death events for ckey-less hostiles, increment `SSroundstats.blood_toll[subtype]`. Chronicle tab renders as a simple table with flavor header. No attribution.

### M3-C15 — Docs + tuning
Roundend report additions ("Crown's Purse flows," "Defense Quest stats," "Loans issued," "Rumor Quests issued"). `get_mechanics_examine` updates on affected machines. Playtest tuning pass on the numbers table above.

## Module 2 (marker rework) — bundled into same PR

Covered in a separate commit sequence within the same PR:

- **M2-C1** — Stub `/easy`, `/medium`, `/hard` as functional aliases of `/generic`. Add `/obj/effect/landmark/quest_spawner/generic` and `/obj/effect/landmark/quest_spawner/raid` subtypes. Add `region` var auto-detected from area. Rewrite `find_quest_landmark(type, region = null)` with region filter.
- **M2-C2** — DMM pass on `dun_world.dmm`: replace all `/easy`, `/medium`, `/hard` placements with `/generic`, except underdark markers (6) → `/defense`. Delete underground markers in caves/sewers per audit recommendation.
- **M2-C3** — Remove `/easy`, `/medium`, `/hard` subtypes entirely. Drop `quest_difficulty` var on landmark class (stays on quest datum). `/generic` hosts every existing quest type (retrieval, courier, kill, clear out, raid, outlaw); `/defense` marker is reserved infrastructure for a future Grand Raid content commit and has no quest types routing to it yet.
- **M2-C4** — Fellowship-gating on raid-class quests. `/datum/quest.required_fellowship_size` var (default 0, solo-allowed). `QUEST_RAID` and `QUEST_OUTLAW` set to 2. `can_claim(user)` checks `user.current_fellowship` and its member count; returns FALSE with a descriptive chat message if under the required size. Sign flow in the ledger surfaces the error. Reward remains signer-only — fellowship members divide IC. This is the first real coupling between Fellowship and Contract Ledger.

### Fellowship-gated quest summary

| Quest type | Marker subtype | Required fellowship size |
|------------|----------------|---------------------------|
| Kill (easy) | `/generic` | 0 (solo) |
| Clear Out | `/generic` | 0 (solo) |
| Retrieval | `/generic` | 0 (solo) |
| Courier | `/generic` | 0 (solo) |
| Raid | `/generic` | **2** |
| Outlaw | `/generic` | **2** |

### Deferred: Grand Raid

A multi-stage, timed, fellowship-only defense quest is planned for a future commit. Design sketch:

- `/defense` marker hosts it exclusively
- Signer plants a scroll on a `/defense` marker turf to trigger the first wave
- 3 waves spawn sequentially with breather windows; 10-minute total timer
- Failure modes: timer expiry or fellowship wipe
- Fellowship size 2+

Deferred from this PR to scope it properly. `/defense` marker subtype exists now so the mapping work doesn't have to redo itself when Grand Raid lands.

## Savings Goal (civic counterweight)

A small round-end reward that encourages adventurers and towners to *retain* personal wealth rather than donate it to the crown or spend it to zero. Purpose: put a personal cost on the "just give your money to the Steward" social pressure so the crown's financial problems remain the crown's problems.

### Mechanic

- At round end, every player with an eligible job (Adventurer / Towner categories; excludes Steward, Lord, nobles, quest-givers) whose bank account has **≥200 mammon** receives **+1 triumph**.
- Roundend economic report includes a line: *"X of Y eligible players met their Savings Goal (Z%)."*
- Not shown as a UI counter mid-round — it's an understated reward, not a task to grind.

### Why this matters for the rest of the system

The Savings Goal is the counterweight that makes fully-backed accounts function as intended:

- **Puts a personal cost on "donate to crown" social pressure.** Without this, a Steward under bankruptcy pressure can guilt-trip players into giving up their balances; the appeal works in a collaborative community, which hollows out the fiscal tension the rest of Module 3 builds. With the Savings Goal, donating has a tangible personal cost (albeit small), and players have a legitimate, game-endorsed reason to say no.
- **Legitimizes hoarding as civic behavior.** Players were already hoarding under fractional reserve (money sat in accounts unspent), but the system silently consumed it. Module 3 makes accounts fully-backed, and the Savings Goal explicitly rewards the natural hoarding behavior. Players who retain wealth feel *responsible*, not *defecting*. Same behavior, better social valence.
- **Provides civic telemetry.** Over many rounds, the "% met goal" stat becomes a health indicator for the economy. Rounds where the Steward over-taxed or inflation got away produce low completion. Rounds with healthy flow produce high completion. It's a signal separate from "did anyone go insolvent."
- **Validates low-stakes play.** A towner who RPed in the tavern all round still has a meaningful end-of-round outcome. "I made a comfortable week, saved my 200" is a valid character arc.

### Threshold tuning

200 is a starting value. It's achievable for most roles from ordinary labor income without grinding, but bad luck (fined twice, big purchase, charitable donation) puts it at risk. If playtest shows >90% of players hit it trivially, raise to 300. If <40% hit it, the economy is too tight or the number is too high — lower before assuming the economy is broken.

## Steward gameplay loop (steady-state)

Two decoupled optimization problems with different cadences:

**Authority side (daily, 30 min)**: look at region events and threat regions, spend Defense Budget on the most relevant quests. Use-it-or-lose-it pressure means you *should* spend down to zero. Failure mode: hoarding via parking (mitigated by decrement-on-issue).

**Wealth side (continuous)**: watch Crown's Purse balance, make sure salaries are covered at the next payroll tick, invest surplus in trade, fine scofflaws if short. Failure mode: insolvency (broadcast failure, political consequence).

The two loops don't fight for attention because they operate at different cadences and have different player-facing failure modes. A competent Steward manages both. A specialized Steward can let one slide for political reasons ("I refused to pay the Duke's nephew's salary because he's been aiding brigands").

## Open items / flagged for later

- **Jawbank heist for Crown's Purse**: currently only individual-account Coveter Crown exists. If we want "rob the crown" gameplay, design it as a separate PR. Not blocking.
- **Estates General**: referenced in Quest 2 original design. Would give the Lord's decree power political counterbalance. Separate module, later.
- **Region count**: starting with 5. If playtest shows "Steward solves optimal route in 20 minutes," expand to 8-10 regions or make events more frequent.
- **Rumor Points cost scaling**: finalized as Retrieval 1 / Kill+Courier+Clear Out 2 / Raid+Outlaw 3. Retune after playtest if supply shape drifts from 40-50% target.
- **Innkeeper Guild's Cut when Innkeeper is AFK**: currently "void if no Innkeeper" — do we distinguish "job unfilled" vs. "Innkeeper SSD"? MVP treats both as unfilled.
- **Loan default garrison mechanic**: not coded in MVP. "Steward has IC justification" means players RP it with existing garrison tools.
- **Regional event visibility to non-Steward players**: should region events be visible publicly (noticeboard?) or only to the Steward? MVP: Steward-only to reduce UI scope. Flag for revisit.

## Key file map (projected)

| Path | Role |
|------|------|
| `code/__DEFINES/treasury.dm` | Budget knobs, fine caps, decree cooldown |
| `code/__DEFINES/loans.dm` | Loan constants |
| `code/controllers/subsystem/rogue/treasury.dm` | `SStreasury` with split budgets + `transfer()` + `loans` + `rumor_points` + conservation check |
| `code/controllers/subsystem/rogue/regionevents.dm` | `SSregionevents` (new) |
| `code/datums/loan.dm` | `/datum/loan` |
| `code/datums/decree.dm` | `/datum/decree` |
| `code/datums/internal_region.dm` | `/datum/internal_region`, event table |
| `code/modules/jobs/job_types/roguetown/courtier/steward.dm` | Steward UI additions |
| `code/modules/jobs/job_types/roguetown/burghers/innkeep.dm` | Innkeeper UI additions |
| `code/modules/roguetown/roguemachine/contract_ledger.dm` | Quest source tagging (defense, rumor), Guild's Cut hook |
| `code/modules/roguetown/roguemachine/steward/steward.dm` | Nerve Master trade UI, decree panel |
| `tgui/packages/tgui/interfaces/StewardPanel.tsx` | Trade, budgets, loans |
| `tgui/packages/tgui/interfaces/DecreePanel.tsx` | Lord-only decree toggles |
| `tgui/packages/tgui/interfaces/InnkeeperRumorPanel.tsx` | Rumor Points, quest issuance |

## Inspecting the live system

- `SStreasury.verify_mammon_conservation()` — sanity check that physical mammon is conserved
- `SStreasury.event_log` — attribution log for every mammon movement
- `SStreasury.loans` — outstanding loans
- `SSregionevents.active_events` — currently-running region events
- Roundend "Treasury" block (to be added) — flows, mints, defense quests issued, rumor quests issued, loans issued/repaid/defaulted
