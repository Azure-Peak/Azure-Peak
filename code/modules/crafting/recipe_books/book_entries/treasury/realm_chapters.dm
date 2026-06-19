/datum/book_entry/treasury_realm
	abstract_type = /datum/book_entry/treasury_realm
	category = "Steward"

/datum/book_entry/treasury_realm/budgets
	name = "01. Budgets, Warrants & Authority"

/datum/book_entry/treasury_realm/budgets/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Crown's Purse</h3>
		<p>The Crown's actual mammon balance. Used to pay wages, imports, deposits, and any other expenditure drawn through the Nerve Master (KEEP IT LOCKED!). Replenished by taxes, fines, rural taxes, direct deposit into the Nerve Master, exports, and fulfilling standing orders.</p>

		<h3>Burgher Pledge</h3>
		<p>Not actual coin, but a virtual pool pledged by the Burghers of the realm (off map). It refills daily while the Golden Bull stands, scaling with a flat base and the active player count. Does not refill while the Bull is suspended.</p>

		<h3>Alderman's Warrant</h3>
		<p>An Alderman, elected by the City Assembly, gains a Defense Warrant and a Trade Warrant. Neither is a purse - they are spending ceilings against the Crown's Purse or Burgher Pledge respectively:</p>
		<ul>
			<li><b>Trade Warrant</b> - a daily mammon ceiling against the Crown's Purse. The Alderman may import and export up to this amount each day; the monetary value of both imports and exports counts against the Warrant. Coin flows to and from the Purse itself.</li>
			<li><b>Defense Warrant</b> - a daily Pledge ceiling. Defense commissions issued by the Alderman burn Pledge authority up to this cap, just as the Steward's do. The Alderman may not draw the Crown's Purse for defense, and may not issue Requests.</li>
		</ul>
		<p>Both ceilings refresh at each session's resolution. Unspent authorisation does not carry over.</p>

		<h3>Crown Authority</h3>
		<p>The following titles share full Crown authority - they may petition the trade hall, draw emergency loans, commission defense and blockade writs, and stamp contracts levy-exempt with the signet:</p>
		<ul>
			<li>Steward, Clerk, Grand Duke, Hand, Marshal, Councillor, Prince/Princess.</li>
		</ul>
		<p>The Steward is the primary officer; the rest substitute when the Steward is absent, dead, or otherwise occupied. A Regent crowned at the Throne inherits the same authority for the duration of their regency.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/defense
	name = "02. Defense and Blockades"

/datum/book_entry/treasury_realm/defense/inner_book_html(mob/user)
	return {"
		<div>
		<p>Commissioned from the Grand Contract Ledger:</p>

		<ul>
			<li><b>Defense Commissions</b> - drawn against the Pledge or the Crown's Purse, posted to boards or handed to a bearer.</li>
			<li><b>Blockade Writs</b> - given to a fellowship of [BLOCKADE_FELLOWSHIP_REQUIREMENT]. The Steward may recall an unanswered writ after [BLOCKADE_RECALL_WINDOW_DS / 600] minutes, recovering the draft.</li>
			<li><b>Requests</b> - daily quota of [COMMISSION_REQUESTS_PER_DAY] reward-less commissions, Steward-only.</li>
		</ul>

		<h3>Issue Authority</h3>
		<p>See <i>Budgets, Warrants & Authority</i> for the full list of titles that may issue commissions.</p>

		<h3>Direct Commission vs Board:</h3>
		<p>A commission can be posted to the Grand Contract Ledger, or given directly to a bearer. Handing it directly to a bearer is faster and more certain, but risks it being ignored or wasted on someone who can't complete it. The Steward may not take and claim a scroll they have issued themselves. See <i>The Grand Contract Ledger</i> for shared mechanics including expiry windows, the take cooldown, and abandonment forfeit.</p>

		<h3>Bonus Pay</h3>
		<p>Either a Defense Commission or a Blockade Writ may be issued with <b>Bonus Pay</b> at one of three levels: <b>None</b> (x1.0), <b>Light</b> (x[COMMISSION_BONUS_PAY_LIGHT_MULT]), or <b>Full</b> (x[COMMISSION_BONUS_PAY_MULT]). The chosen multiplier applies to both the draft cost and the bearer's reward. Not available on Requests.</p>

		<h3>Levy Exemption</h3>
		<p>When the Steward issues a contract, they may mark it Levy Exempt - the bearer pays no Contract Levy on the reward. This costs the Crown only the foregone levy and is useful for sweetening offers to mercenaries or adventurers.</p>

		<p>The Steward also starts with an infinite-use signet ring. Any holder of Crown authority (see <i>Budgets, Warrants & Authority</i>) can stamp a contract (click it) to make it Levy Exempt after the fact - useful for retroactive bribes.</p>

		<h3>Region and Reward</h3>
		<p>Defense commissions pay out in proportion to the threat they spawn. Each threat region carries a <b>reward multiplier</b> (surfaced in the commission UI beside the region name): Azure Basin at x0.75, Azure Grove at x1.0, Azurean Coast at x1.2, Terrorbog / Mount Decapitation / Underdark at x1.5. A Bounty in Terrorbog costs the same draft as a Bounty in Azure Basin - but the Terrorbog commission pays the bearer roughly twice as much. The Steward can use this to steer adventurers toward regions the realm most needs cleared.</p>

		<p><b>Blockade Writs</b> draw the same flat [BLOCKADE_SCROLL_PLEDGE_COST]m draft regardless of region, but the writ's payout is multiplied by the region's reward multiplier. For example: A Mount Decapitation blockade writ costs [BLOCKADE_SCROLL_PLEDGE_COST]m and pays out [round(BLOCKADE_SCROLL_REWARD * 1.5)]m on completion. Difficulty of Blockade Writ are technically stationary - though some regions are inherently more difficult than others due to the composition within. </p>

		<p>Multiple blockades may stand at once. One writ per blockade at a time. Blockades are rolled at roundstart only; there is no mid-round scheduled spawn.</p>

		<p>The Steward may recall an unanswered Blockade Writ after 15 minutes. An accepted writ has a 30-minute completion timer before it is automatically forfeit. Each wave adds 10 minutes. Wave timers are independent of the recall timer - once a Writ is taken, the bearer must finish it promptly.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/trade
	name = "03. Regional Trade"

/datum/book_entry/treasury_realm/trade/inner_book_html(mob/user)
	return {"
		<div>
		<p>The Crown trades with ten regions: Kingsfield, Rosawood, Rockhill, Daftsmarch, Blackholt, Saltwick, Hagenwald, Bleakcoast, Northfort, Heartfelt. Trade and Stockpile interface are accessed through the Nerve Master's "Trade and Stockpile" interface.

		<h3>Trade Pricing</h3>
		<ul>
			<li>Each region has daily production and demand for specific goods. Volumes scale with active player count.</li>
			<li><b>Import</b> price rises sharply once purchases exceed daily production. Repeat imports of the same good in one day carry a further surcharge.</li>
			<li><b>Export</b> price falls sharply once sales exceed daily demand.</li>
			<li><b>Export</b> price is always [IMPORT_EXPORT_SPREAD * 100]% less than the matching import price. Buying and re-selling on the same day is always a loss.</li>
			<li><b>Blockade</b>: Blockade does not hardblock import or export, but multiplies cost to make it unwise: Import Price x[BLOCKADE_IMPORT_MULT], Export Revenue x[BLOCKADE_EXPORT_MULT].</li>
			<li><b>Economic events</b> apply a further multiplier - see Supply and Demand.</li>
			<li>Each Trade action is capped at [TRADE_MAX_BULK_UNITS] units per click. The trade modal shows a live quote with base subtotal, escalation surcharge, and total before commit.</li>
		</ul>

		<h3>Stockpile Pricing, Autoprice and Autolimit</h3>
		<p>Each stockpiled good has two prices: a <b>buy price</b> (Crown pays the depositing player) and a <b>sell price</b> (Crown charges the withdrawing player).</p>
		<p>On <b>Autoprice</b>, prices peg to the good's global pre-blockade reference (base × event multiplier), guaranteeing the Crown profits at least 1m per transaction:</p>
		<ul>
			<li><b>Sell</b> = the higher of <code>1.25 × import_ref</code> or <code>import_ref + 1m</code>.</li>
			<li><b>Buy</b> = the lower of <code>0.75 × export_ref</code> or <code>export_ref - 1m</code>.</li>
		</ul>
		<p>Where <code>import_ref = base × event_mod</code> and <code>export_ref = import_ref × [(1 - IMPORT_EXPORT_SPREAD) * 100]%</code>. At small base prices the +/-1m bound dominates; at larger prices the [IMPORT_EXPORT_SPREAD * 100]% bound takes over so the Crown's skim scales with the price. No regional lookup - regional shortages, blockades, and route congestion only affect imports/exports, not stockpile prices. The Steward intervenes manually if the situation calls for it.</p>
		<ul>
			<li>The Steward may set either price by hand, which switches the entry to <b>Manual</b>. Manual entries hold whatever the Steward set until they are restored to Auto. Restoring Auto snaps both prices to the current reference.</li>
			<li>Manual-priced entries are skipped by the Crown's autoexport sweep.</li>
			<li>The Market Scroll surfaces a per-good <b>arbitrage margin</b> column (sell - buy, times current stock) and an aggregate "Crown spread on held stockpile" total at the top.</li>
		</ul>

		<h3>Stockpile Limit - Auto and Manual</h3>
		<p>Each stockpile entry has a per-day limit beyond which deposits no longer pay. Limits start in <b>Auto</b> mode at roundstart, computed as <b>total daily demand across all regions x pop multiplier x [STOCKPILE_AUTO_LIMIT_DAYS] days of headroom</b>, with a [STOCKPILE_LIMIT_MIN]-unit floor for goods that have no demand line (gems, treasures). The Steward may override by setting a limit by hand, which flips the entry to <b>Manual</b>; <b>Auto-Limit All</b> resets every entry back to the formula.</p>

		<h3>Bulk Operators</h3>
		<p>The Market Scroll exposes per-category and global controls: <b>Auto-Price All</b> / <b>Auto-Limit All</b> reset modes; <b>Buy x</b> / <b>Sell x</b> multipliers scale either side of the spread across a category or globally (each multiplier flips affected entries to Manual). <b>Open All</b> / <b>Close All</b> per category open or refuse player deposits in bulk.</p>

		<h3>Surplus Exports</h3>
		<p>Each stockpile entry has a per-day <b>surplus floor</b>: <code>floor = limit x threshold</code>. Stock above the floor is surplus, and the Crown's daily auto-export sweep clears that surplus to the highest-paying region, capped at that region's remaining daily demand. The threshold defaults to 60% and is set globally - lower it to make the Crown more aggressive about turning hoarded stock into mammon, raise it to keep more stock on hand for citizens and standing orders.</p>
		<p>The Steward may also fire the sweep on demand from the Market Scroll's <b>Export Surplus</b> button (or the per-category equivalent). Once a region's daily demand is saturated, no further units can be exported there until the day rolls over - so spamming the button has no effect beyond the first useful click. <b>Manual-priced entries are skipped</b>: those are the Steward's territory, and the Crown will not auto-route stock the Steward has hand-priced. Hand-export them per-row from the same scroll.</p>

		<h3>Imports and the Stockpile</h3>
		<p>Regional imports enter the Crown's stockpile and feed standing orders and the city's economy at large. The Steward may set a <b>purchase floor</b>: imports are refused when they would drop the Purse below it.</p>

		<p>The Alderman <b>cannot</b> alter stockpile pricing or limits - those remain Steward-only authority.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/auto_import
	name = "04. Standing (Auto) Imports"

/datum/book_entry/treasury_realm/auto_import/inner_book_html(mob/user)
	return {"
		<div>
		<p>The Crown may auto-import essential goods each dawn, sparing the Steward from manually re-importing the same basics every day. Goods stay on the list until removed.</p>

		<h3>Essentials</h3>
		<p>Six goods are on standing import by default: <b>coal, wood, grain, iron ore, hide, and fat</b>. The Steward may remove any of them from the Market Scroll's <b>Auto-Import</b> tab and re-add them later.</p>

		<h3>Adding Other Goods</h3>
		<p>Any importable good with an active producing region may be placed on standing import. The Steward marks them in the same tab, grouped by category.</p>

		<h3>Rules</h3>
		<p>Each dawn, for each good on the list:</p>
		<ul>
			<li>If the stockpile already holds [AUTO_IMPORT_FLOOR] or more units, no import is made.</li>
			<li>Otherwise, the Crown buys [AUTO_IMPORT_BATCH] units from the cheapest producing region.</li>
			<li>The import is skipped if any unit would cost more than [AUTO_IMPORT_MAX_PRICE_MULT]x the good's base price. Shortages can push prices past this cap; standing import stops rather than draining the Purse.</li>
			<li>The import is skipped if it would drop the Crown's Purse below the Steward's <b>purse floor</b> (default [AUTO_IMPORT_PURSE_FLOOR_DEFAULT]m, adjustable from the tab).</li>
		</ul>

		<h3>Visibility</h3>
		<p>Successful imports announce on the Nerve Master with an <i>(auto)</i> tag. Skipped days (stockpile full, price spike, purse floor breach) leave a note in the Tally readout. The panel retains the last [AUTO_IMPORT_HISTORY_DAYS] days of activity.</p>

		<h3>Kill Switch</h3>
		<p><b>Strike All</b> in the tab disables every standing import at once, essentials included. Goods can be re-enabled individually.</p>

		<p>Standing imports draw from the Crown's Purse only. They are not part of any Alderman warrant.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/standing_orders
	name = "05. Of Standing Orders"

/datum/book_entry/treasury_realm/standing_orders/inner_book_html(mob/user)
	return {"
<div>
		<h3>Types</h3>
		<ul>
			<li><b>Regular</b> - rolled each dawn ([STANDING_ORDERS_BASE_PER_DAY] base, +1 per ~20 active players, capped at [STANDING_ORDERS_MAX_PER_DAY]/day). [STANDING_ORDER_DURATION]-day lifespan. Payout: base x[1 + STANDING_ORDER_BASE_BONUS] per unit.</li>
			<li><b>Urgent</b> - spawned by shortage events, capped at [STANDING_ORDERS_MAX_URGENT] standing at a time. One-day lifespan. Payout: base x shortage price multiplier per unit (typically 3-4x).</li>
			<li><b>Warehouse</b> - for finished goods (equipment, potions, trophy heads). Settled from the export warehouse (Behind the Stewardry), not the stockpile.</li>
			<li><b>Petitioned</b> - spawned on demand by the Steward burning Burgher Pledge. See <b>Petitions</b> below.</li>
		</ul>

		<h3>Petitions</h3>
		<p>The Steward may burn Burgher Pledge to spawn a standing order on demand, picking a category and a non-blockaded target region. Petitioned orders are tagged in the UI and pay [round(PETITION_TAX_MULT * 100)]% of a normal roll's payout. Daily quota: [PETITIONS_PER_DAY] per round-day. Each category contains multiple order templates, so the Steward can direct demand but not fully dictate composition.</p>

		<h3>Fulfillment</h3>
		<p>Stockpile orders: deposit goods, confirm at the Nerve Master, payout minted to the Crown's Purse. Warehouse orders: settled automatically on sweep. The Crown's purse is paid directly and it is up to the Steward to decides who and how much to remit from their profit.</p>

		<p><b>Partial fulfillment:</b> if the on-hand goods cover at least [round(STANDING_ORDER_PARTIAL_THRESHOLD * 100)]% of an order's posted value, the Steward may settle it anyway. The buyer pays [round(STANDING_ORDER_PARTIAL_PAYOUT_MULT * 100)]% of the delivered share's value and the missing share is forfeit. Failed attempt locks fulfillment for [DisplayTimeText(STANDING_ORDER_FULFILL_RETRY_COOLDOWN)] to prevent spam and performance issue.</p>

		<h3>Limits</h3>
		<p>Max [STANDING_ORDERS_MAX_PER_REGION] orders per region. Max [STANDING_ORDERS_POOL_CAP] orders in the realm. Blockaded regions can hold orders but cannot be delivered to.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/warehouse
	name = "06. Warehouse"

/datum/book_entry/treasury_realm/warehouse/inner_book_html(mob/user)
	return {"
		<div>
		<p>The Steward's Export Machine and the surrounding tiles accept finished goods that fulfill warehouse-tagged standing orders.</p>

		<h3>Equipment Orders</h3>
		<p>Swept for exact-type match. Subtypes, variants, and heirlooms are not consumed.</p>

		<h3>Potion Orders</h3>
		<p>Swept by reagent and volume. Any container holding the right reagent counts, consumed from the top until the order is met.</p>
		</div>
	"}



/datum/book_entry/treasury_realm/insolvent
	name = "07. Insolvency, Sequestration and Loans"

/datum/book_entry/treasury_realm/insolvent/inner_book_html(mob/user)
	return {"
		<div>
		<p>The Crown becomes insolvent if it fails to meet payroll from the Crown's Purse at dawn. Suspending payrolls by revoking Charters is possible but angers the garrison and retinue (the largest mandatory outlays).</p>

		<p>Insolvency triggers in stages: first an interest-free advance, then an optional emergency loan, and finally sequestration if the Crown fails again.</p>

		<h3>First Failure - Arrears</h3>
		<p>If the Crown's Purse cannot meet the day's wages, an advance of <b>at least [TREASURY_ARREARS_LOAN]m, up to the actual shortfall</b>, is issued without interest. Wages pay normally for the day. The advance is registered as <b>arrears</b>; until the debt is settled, every coin of inflow into the Crown's Purse is skimmed against it before reaching the balance.</p>

		<p>Charters and trade controls are unaffected. If revenue catches up before the next dawn's payroll, the debt is settled silently.</p>

		<h3>The Emergency Loan</h3>
		<p>Before Day [ATC_LOAN_CLOSED_DAY], the Crown may draw a one-time loan at the Guilds clerk for <b>[ATC_LOAN_MIN_AMOUNT]m to [ATC_LOAN_MAX_AMOUNT]m</b>. The principal is paid into the Crown's Purse immediately. Interest is <b>[round(ATC_LOAN_INTEREST_RATE * 100)]%</b>: a [ATC_LOAN_MAX_AMOUNT]m draw registers as [round(ATC_LOAN_MAX_AMOUNT * (1 + ATC_LOAN_INTEREST_RATE))]m of debt, repaid silently from skimmed inflow. No second loan may be drawn until the first is settled.</p>

		<p>Drawing the loan is announced and <b>forfeits the arrears grace</b>: missing payroll while the loan is outstanding - by even one mammon - sends the Crown directly to sequestration without the arrears step.</p>

		<p>From Day [ATC_LOAN_CLOSED_DAY] onward, no further loans may be drawn.</p>

		<h3>Second Failure - Sequestration</h3>
		<p>If the Crown misses payroll on a second consecutive dawn (or once with an outstanding loan), the realm enters <b>sequestration</b>:</p>
		<ul>
			<li><b>Crown's Purse is reset to [BANKRUPTCY_OPERATING_FLOOR]m</b>. Anything above the floor is forfeit; anything below is topped up.</li>
			<li><b>A debt of [BANKRUPTCY_DEBT_FLAT]m</b> is registered on top of any existing arrears or loan debt.</li>
			<li><b>All Crown salaries are suspended</b> until sequestration lifts.</li>
			<li><b>All Charters but the Golden Bull are suspended</b>. They cannot be restored during sequestration; on recovery, up to [BANKRUPTCY_CONCESSION_PICKS] may be reinstated immediately (see below). The Golden Bull cannot be revoked.</li>
			<li><b>The Steward's commerce controls are locked</b>. Every importable good is placed on standing import; auto-export ratchets to [round(BANKRUPTCY_AUTOEXPORT_PERCENTAGE * 100)]% of stockpile limit. Manual import/export, stockpile pricing, and bulk price multipliers are all disabled. The Steward's prior settings are <b>not</b> remembered - on recovery they remain as sequestration left them and must be re-tuned by hand.</li>
		</ul>

		<p>The skim continues during sequestration, but the Crown's Purse may refill up to the [BANKRUPTCY_OPERATING_FLOOR]m operating floor from inflow so trade keeps running. Anything above the floor goes to debt.</p>

		<h3>What the Steward Still Has</h3>
		<ul>
			<li><b>Tax authority</b>: poll tax, contract levy, headeater levy, import tariff, export duty - all may be set up to the cap, except on burghers.</li>
			<li><b>Fine authority</b>: subject to the usual one-per-day rule and the Golden Bull cap on burghers.</li>
			<li><b>Burgher Pledge</b>: still refills daily since the Bull stands. Defense commissions, blockade writs, and bounty work may all be issued.</li>
			<li><b>Petitions for standing orders</b>: still available. Fulfillment coin flows through the skim.</li>
			<li><b>Standing orders and warehouse rolls</b>: continue as before, payouts skimmed against the debt above the operating floor.</li>
		</ul>

		<h3>Recovery and Concession Picks</h3>
		<p>When the debt reaches zero, sequestration lifts. Salaries resume the next day. The Crown's Purse is seeded with <b>[BANKRUPTCY_RECOVERY_RESET]m</b>.</p>

		<p>The Lord may restore <b>up to [BANKRUPTCY_CONCESSION_PICKS] of the suspended Charters immediately</b>, ignoring the cooldown. Charters not picked must wait the standard [DECREE_COOLDOWN / 600]-minute revision cooldown.</p>

		<p>Unused picks do not carry over - a future sequestration resets the count.</p>

		<p>Trade configuration does <b>not</b> reset on recovery: standing-import list, auto-export ratio, purse floor all stay where sequestration left them. Re-tune by hand.</p>

		<h3>Repeat Sequestrations</h3>
		<p>The realm may enter sequestration multiple times in the same round. There is no protection against repeat failure - each declaration adds fresh debt.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/banditry
	name = "08. Banditry"

/datum/book_entry/treasury_realm/banditry/inner_book_html(mob/user)
	return {"
		<div>
		<p>Regions classified as <b>Dangerous</b> or <b>Bleak</b> drain the Crown's Purse each dawn.</p>

		<h3>Banditry Drain</h3>
		<p>Per region, per dawn:</p>
		<ul>
			<li><b>Dangerous</b>: [BANDITRY_DRAIN_DANGEROUS_FLAT]m base + [BANDITRY_DRAIN_DANGEROUS_PER_PLAYER]m per active player.</li>
			<li><b>Bleak</b>: [BANDITRY_DRAIN_BLEAK_FLAT]m base + [BANDITRY_DRAIN_BLEAK_PER_PLAYER]m per active player.</li>
		</ul>

		<p>The total is shown on the Steward's Trade panel as <i>Projected Banditry Losses</i>, broken down per region with base and per-head amounts.</p>

		<h3>The Floor and Banditry Debt</h3>
		<p>Banditry alone will not reduce the Crown's Purse below <b>[BANDITRY_DEBT_FLOOR]m</b>. Anything beyond that becomes <b>banditry debt</b> - an accruing arrears that skims every coin of treasury inflow (stockpile earnings, taxes, levies, fines, loan repayments) until paid.</p>

		<h3>What You Can Do</h3>
		<p>Issue Commissions and Blockade Writs against Dangerous and Bleak regions. Use levy exemption as bait. The retinue and garrison can also clear regions directly. As regional threat falls, so does the dawn drain. Banditry debt only shrinks as new income is earned and skimmed.</p>

		<p>This system is a placeholder until raid and siege content ships.</p>
		</div>
	"}
