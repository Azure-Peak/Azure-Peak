# Treasury Bankruptcy & Receivership

## Purpose

When the Crown fails at fiscal management, the round should not soft-lock - but the
Keep specifically should pay the price. Bankruptcy is the asymmetric punishment:
the Crown loses payroll, charters, and economic discretion, while player accounts,
noble estates, merchants, and citizens continue to function. The realm degrades, it
does not break.

## State Machine

Three states drive every fiscal behaviour: `TREASURY_NORMAL`, `TREASURY_IN_ARREARS`,
and `TREASURY_BANKRUPTCY`. Stored on `SStreasury.treasury_state`. Mutated only by
the helpers in `code/modules/banking/bankruptcy.dm` - never assigned directly elsewhere.

### NORMAL -> IN_ARREARS

Triggered by `distribute_daily_payments` when Crown's Purse balance is below the
projected wage bill. The Crown takes an interest-free advance large enough to cover
today's wages (or `TREASURY_ARREARS_LOAN` = 1000m, whichever is larger), and the
same amount is registered as `treasury_debt`.

* All inflow into Crown's Purse is now skimmed against the debt (floor = 0, mirrors
  the existing banditry-debt pattern).
* Wages still pay today.
* Charters untouched.
* Recovery to NORMAL is automatic the moment `treasury_debt` reaches zero.

### IN_ARREARS -> BANKRUPTCY

Triggered if the very next `distribute_daily_payments` is still insolvent. Receivership
is declared:

* Crown's Purse is reset to `BANKRUPTCY_OPERATING_FLOOR` = 2500m. Any residual
  balance above the floor is forfeit (logged as a burn). If below, it is topped up.
* Bankruptcy debt of `BANKRUPTCY_DEBT_FLAT + active_pop * BANKRUPTCY_DEBT_PER_PLAYER`
  (5000m flat + 25m/player) is added to any existing arrears debt.
* Salaries are universally suspended via `TRAIT_WAGES_SUSPENDED` (sourced as
  "bankruptcy" so the recovery path knows what to lift).
* All charters except Golden Bull of Kingsfield are suspended via `bankruptcy_suspended`.
  Golden Bull stays active and is locked from manual revocation - the Crown cannot
  strip burgher protection while bankrupt.
* Auto-import is forced on for every importable trade good. Auto-export percentage
  is forced to `BANKRUPTCY_AUTOEXPORT_PERCENTAGE` = 25% (down from the default 60%)
  so the surplus drains aggressively into debt repayment. The Steward's prior trade
  settings are **not** snapshotted; on recovery the receivership configuration
  stands and must be re-tuned by hand.
* Steward UI controls for trade are gated: any attempt to mutate auto-import or
  auto-export config gets a warning and is blocked.

### BANKRUPTCY recovery

The skim with floor (`skim_for_treasury_debt` in `fund_api.dm`) lets the purse refill
to `BANKRUPTCY_OPERATING_FLOOR` and diverts everything above to debt repayment.
Once `treasury_debt` reaches zero:

* `clear_treasury_debt_state` -> `exit_bankruptcy`.
* Crown's Purse tops up to `BANKRUPTCY_RECOVERY_RESET` = 1500m as working capital.
* Salaries auto-resume (the bankruptcy-sourced TRAIT_WAGES_SUSPENDED is removed).
* Auto-import / auto-export config is **not** restored. Receivership defaults
  persist (everything force-imported, auto-export at 25%); the Steward must
  re-tune them by hand. This intentional tedium is part of the cost of failure.
* `bankruptcy_concession_picks` is set to `BANKRUPTCY_CONCESSION_PICKS` = 3.
  The Lord/Hand may restore up to three bankruptcy-suspended charters without
  cooldown. Remaining suspended charters follow normal `DECREE_COOLDOWN` rules.

Concession picks operate through `restore_charter_via_concession`, which bypasses
`set_decree_active`'s daily-rate-limit and per-decree cooldown. The Economic Panel
exposes them as one-click buttons; a public charter UI exposing them to the Lord
lives outside this slice.

## Recovery Toolkit (what the Keep can do while bankrupt)

* Poll tax / contract levy / import-export tariff / fines: all unchanged. The Crown
  can hammer them as hard as the existing `GENERIC_RATE_CAP` allows. Burghers are
  still capped via Golden Bull (intentional - that's the asymmetry).
* Burgher Pledge: unchanged. Steward can still issue defense quests against it.
* Bounty quests: unchanged. The Crown can issue bounty work to retinue/garrison and
  recover real coin via completion payouts.
* Manual deposits from sympathetic nobles: route through the existing transfer path,
  so they hit the skim and pay down debt above the floor.

## Re-entry

Allowed. Each bankruptcy adds a fresh debt amount on top of any remaining. There is
no cap - if the Keep manages to bankrupt the realm twice in one round, they have
earned a much larger climb out.

## Constants

All tunables live in `code/__DEFINES/banking.dm`:

| Constant | Value | Effect |
|---|---|---|
| `TREASURY_ARREARS_LOAN` | 1000 | Minimum size of the arrears advance |
| `BANKRUPTCY_OPERATING_FLOOR` | 2500 | Crown's Purse cap during receivership |
| `BANKRUPTCY_DEBT_FLAT` | 5000 | Flat debt added on bankruptcy entry |
| `BANKRUPTCY_DEBT_PER_PLAYER` | 25 | Per-active-player surcharge |
| `BANKRUPTCY_AUTOEXPORT_PERCENTAGE` | 0.25 | Forced auto-export ratio |
| `BANKRUPTCY_CONCESSION_PICKS` | 3 | Cooldown-free charter restores on recovery |
| `BANKRUPTCY_RECOVERY_RESET` | 1500 | Working capital seeded on recovery |
| `BANKRUPTCY_SUSPENDED_DECREES` | list | Charters suspended on entry (Golden Bull deliberately absent) |

## Failure modes that are not bankruptcy

* **One missed payroll, one recovery before next tick:** stays in IN_ARREARS until
  the loan repays itself via inflow. No charter damage, no salary suspension. The
  realm just tightens its belt.
* **Existing banditry debt:** unaffected. The banditry skim runs first (no floor),
  the bankruptcy skim runs second (with floor). Both can hold simultaneously.
* **A noble player's estate:** estate income is a `mint`, not a `transfer` from the
  Crown's Purse, so noble incomes continue to flow even during bankruptcy. The
  receivership punishes the Crown specifically, not nobility broadly.

## Admin override

The Economic Panel (Debug -> Economic Panel) exposes:

* Force Arrears - simulates a missed payroll, registers a 1000m loan.
* Force Bankruptcy - jumps straight to receivership, full effects.
* Force Recovery - zeroes treasury_debt and dispatches the appropriate exit.
* Concession Restore: <Charter> - one-click cooldown-free restoration of a
  bankruptcy-suspended charter (consumes a concession pick).

## Stats / Chronicle

Tracked in `code/__HELPERS/round_statistics.dm` and surfaced in the round-end
treasury chronicle:

* `STATS_ARREARS_DECLARED` - how many times the Crown entered arrears.
* `STATS_BANKRUPTCY_DECLARED` - how many times the Crown declared bankruptcy.
* `STATS_TREASURY_DEBT_REPAID` - cumulative mammon skimmed against treasury debt.
* `STATS_TREASURY_DEBT_OUTSTANDING` - end-of-round outstanding (zero if recovered).
