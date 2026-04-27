/datum/book_entry/treasury
	abstract_type = /datum/book_entry/treasury
	category = "The Crown's Treasury"


/datum/book_entry/treasury/charters
	name = "01. Charters of the Realm"

/datum/book_entry/treasury/charters/inner_book_html(mob/user)
	return {"
		<div>
		<p>Charters protect classes of subject from the Crown's levy. The Lord alone may suspend or restore a Charter, at the Titan, by speaking <b>revise charter</b>. State is shown on the Charter Board.</p>

		<ul>
			<li><b>The Great Writ of Azuria</b> - nobility: no tax, no levy.</li>
			<li><b>The Zenitstadt Concordat</b> - Church clergy: no tax, no levy.</li>
			<li><b>The Otavan Accords</b> - Holy Otavan Inquisition: no tax, no levy.</li>
			<li><b>The Golden Bull of Kingsfield</b> - burghers, residents, commoners: capped at [GOLDEN_BULL_BURGHER_CAP * 100]% of balance per levy or fine, with a [GOLDEN_BULL_DAILY_FINE_CAP]-mammon ceiling on each fine.</li>
			<li><b>The Covenant of Noc and Pestra</b> - University scholars and Apothecary healers: lightest poll tax, and a minimum wage from the Crown's payroll.</li>
			<li><b>The Guild Charter of Arms</b> - Guild mercenaries: light poll tax only. Guild remits a daily tribute to the Pledge.</li>
			<li><b>The Indenture of War</b> - Crown's armed men: wage floor while in force.</li>
		</ul>

		<p>Each Charter has a [DECREE_COOLDOWN / 600]-minute cooldown after revision. No more than one suspension and one restoration may be proclaimed per day.</p>
		</div>
	"}


/datum/book_entry/treasury/levies
	name = "02. The Crown's Proper Levies"

/datum/book_entry/treasury/levies/inner_book_html(mob/user)
	return {"
		<div>
		<p>Rates are set by the Steward with "Adjust Taxes" or the Lord at the throne, revisable once per day, capped at half measure.</p>

		<h3>Transaction Levies</h3>
		<ul>
			<li><b>Contract Levy</b> - on Grand Contract Ledger payouts.</li>
			<li><b>Headeater Levy</b> - on bounty heads rendered.</li>
			<li><b>Import Tariff</b> - on goods bought from merchant vendors.</li>
			<li><b>Export Duty</b> - on goods dispatched by the Navigator's balloon.</li>
		</ul>

		<h3>Poll Tax</h3>
		<p>Daily per-head tax by category: noble, clergy, inquisition, courtier, garrison, guild, merchant, burgher, adventurer, mercenary, peasant. Rates set at the Nerve Master, each capped at [POLL_TAX_MAX_RATE]m/day. Charters override: Writ and Concordat exempt entirely; Golden Bull caps burghers at the lightest rate; Covenant does the same for scholars and healers.</p>

		<p>Unpaid poll tax accumulates arrears. After [POLL_TAX_DEBT_DAYS_TO_DEBTOR] day(s) of arrears, the subject is marked <b>destitute</b>. This does not give you valid permission to kill or attack them on sight - roleplay accordingly and try to recover the mammons as reasonable.</p>

		<h3>Subsidy</h3>
		<p>A category's rate may be set as far as <b>-[POLL_TAX_MAX_SUBSIDY]m/day</b>. A negative rate is a <b>Crown subsidy</b>: each tick, the Crown's Purse pays that mammon to every subject of the category, reaching even charter-protected classes. If the Purse is insolvent for the tick, that head's subsidy silently skips. No advance, no arrears - subsidies are live per-tick generosity only.</p>

		<p>The Nerve Master's tax setter shows a projected per-tick income, subsidy cost, and net flow based on current heads, so the Steward can see the budget impact before committing. The projection ignores balance and advance state - it is the gross rate × eligible head count.</p>

		<p>Meister deposits are not taxed.</p>
		</div>
	"}


/datum/book_entry/treasury/fines
	name = "03. Of Fines and Debt"

/datum/book_entry/treasury/fines/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Fines</h3>
		<ul>
			<li>Charter-protected subjects cannot be fined.</li>
			<li>Golden Bull subjects: maximum [GOLDEN_BULL_BURGHER_CAP * 100]% of balance per stroke, with a [GOLDEN_BULL_DAILY_FINE_CAP]-mammon ceiling.</li>
			<li>All others: maximum [GENERIC_RATE_CAP * 100]% of balance per stroke.</li>
			<li><b>One fine per subject per day.</b></li>
		</ul>

		<h3>Loans</h3>
		<p>Crown loans carry fixed simple interest and a stated term. Default marks the subject <b>Debtor</b> until the loan is repaid or forgiven.</p>
		</div>
	"}


/datum/book_entry/treasury/outlaws
	name = "04. Of Outlaws"

/datum/book_entry/treasury/outlaws/inner_book_html(mob/user)
	return {"
		<div>
		<p>A subject declared Outlaw by the Lord at the Titan stands civic dead. No Charter, patronage, or protection applies. Their account may be drained entire; fine caps do not apply.</p>
		</div>
	"}


/datum/book_entry/treasury/patronage
	name = "05. Patronage Grants"

/datum/book_entry/treasury/patronage/inner_book_html(mob/user)
	return {"
		<div>
		<p>High offices may extend their Charter's protection to named individuals. Grants require consent, are publicly announced, and may be revoked by the granter.</p>

		<ul>
			<li><b>Bishop</b> - declares benefactors under the Zenitstadt Concordat. Up to [PATRONAGE_CAP_PER_ROUND] standing benefactors at a time, with a [PATRONAGE_GRANT_COOLDOWN / 600]-minute cooldown between grants.</li>
			<li><b>Steward</b> - prints Letters of Citizenry at the Nerve Master. The bearer gains Golden Bull protection by reading the letter aloud.</li>
		</ul>

		<p>Protection lapses if the backing Charter is suspended and returns on restoration.</p>
		</div>
	"}


/datum/book_entry/treasury/budgets
	name = "06. The Crown's Budgets"

/datum/book_entry/treasury/budgets/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Crown's Purse</h3>
		<p>Coin treasury. Pays wages, imports, and the Steward's discretion. Replenished by taxes, rural tribute, margin on exports and fulfilling standing orders.</p>

		<h3>Burgher Pledge</h3>
		<p>Authority, not coin. Used to commission military action. Refills daily while the Golden Bull stands; does not refill while the Bull is suspended.</p>

		<h3>Alderman's Warrant</h3>
		<p>A warrant is not a purse of its own. It is an <b>authorisation</b>: a daily ceiling on what the Alderman may spend of the Crown's monies in the Commons' name. When the City Assembly sits, the Alderman holds two such ceilings:</p>
		<ul>
			<li><b>Trade warrant</b> - a daily mammon ceiling against the Crown's Purse. The Alderman may import and export up to this amount each day; coin flows to and from the Purse itself.</li>
			<li><b>Defense warrant</b> - a daily Pledge ceiling. Defense commissions issued by the Alderman burn Pledge authority up to this cap, just as the Steward's do. The Alderman may not draw the Crown's Purse for defense, and may not issue Requests.</li>
		</ul>
		<p>Both ceilings refresh at each session's resolution. Unspent authorisation does not carry over.</p>
		</div>
	"}


/datum/book_entry/treasury/defense
	name = "07. Of Defense and Blockades"

/datum/book_entry/treasury/defense/inner_book_html(mob/user)
	return {"
		<div>
		<p>Commissioned from the Grand Contract Ledger:</p>

		<ul>
			<li><b>Defense Commissions</b> - drawn against the Pledge or the Crown's Purse, posted to boards or handed to a bearer.</li>
			<li><b>Blockade Writs</b> - given to a fellowship of [BLOCKADE_FELLOWSHIP_REQUIREMENT]. The Steward may recall an unanswered writ after [BLOCKADE_RECALL_WINDOW_DS / 600] minutes, recovering the draft.</li>
			<li><b>Requests</b> - daily quota of [COMMISSION_REQUESTS_PER_DAY] reward-less commissions, Steward-only.</li>
		</ul>

		<h3>Bonus Pay</h3>
		<p>Either a Defense Commission or a Blockade Writ may be issued with <b>Bonus Pay</b> at one of three levels: <b>None</b> (x1.0), <b>Light</b> (x[COMMISSION_BONUS_PAY_LIGHT_MULT]), or <b>Full</b> (x[COMMISSION_BONUS_PAY_MULT]). The chosen multiplier applies to both the draft cost and the bearer's reward. Light is the budget-conscious nudge; Full is the full-throated entreaty for takers in dangerous regions. Not available on Requests.</p>

		<h3>Region and Reward</h3>
		<p>Defense commissions pay out in proportion to the threat they spawn. Each threat region carries a <b>reward multiplier</b> (surfaced in the commission UI beside the region name): Azure Basin at x0.75, Azure Grove at x1.0, Azurean Coast at x1.2, Terrorbog / Mount Decapitation / Underdark at x1.5. A Bounty in Terrorbog costs the same draft as a Bounty in Azure Basin - but the Terrorbog commission pays the bearer roughly twice as much. The Steward can use this to steer adventurers toward regions the realm most needs cleared.</p>

		<p><b>Blockade Writs</b> draw the same flat [BLOCKADE_SCROLL_PLEDGE_COST]m draft regardless of region, but the writ's payout is multiplied by the region's reward multiplier. A Mount Decapitation blockade writ costs [BLOCKADE_SCROLL_PLEDGE_COST]m and pays out [round(BLOCKADE_SCROLL_REWARD * 1.5)]m on completion - profitable for the Crown to commission against far-and-dangerous regions. Closer regions are loss-leaders.</p>

		<p>Multiple blockades may stand at once. One writ per blockade at a time. Blockades are rolled at roundstart only; there is no mid-round scheduled spawn.</p>
		</div>
	"}


/datum/book_entry/treasury/trade
	name = "08. Of Trade"

/datum/book_entry/treasury/trade/inner_book_html(mob/user)
	return {"
		<div>
		<p>The Crown trades with nine regions: Kingsfield, Rosawood, Rockhill, Daftsmarch, Blackholt, Saltwick, Bleakcoast, Northfort, Heartfelt. Executed through the <b>Market Scroll</b> at the Nerve Master, which combines the Trade and Stockpile interfaces into a single panel.</p>

		<h3>Inter-Regional Trade Pricing</h3>
		<ul>
			<li>Each region has daily production and demand for specific goods. Volumes scale with active player count.</li>
			<li><b>Import</b> price rises sharply once purchases exceed daily production. Repeat imports of the same good in one day carry a further surcharge.</li>
			<li><b>Export</b> revenue is always [IMPORT_EXPORT_SPREAD * 100]% less than the matching import price. Buying and re-selling is always a loss.</li>
			<li><b>Blockade</b>: import x[BLOCKADE_IMPORT_MULT], export x[BLOCKADE_EXPORT_MULT].</li>
			<li><b>Economic events</b> apply a further multiplier - see Supply and Demand.</li>
			<li>Each Trade action is capped at [TRADE_MAX_BULK_UNITS] units per click. The trade modal shows a live quote with base subtotal, escalation surcharge, and total before commit.</li>
		</ul>

		<h3>Stockpile Pricing - Asymmetric and Self-Ratcheting</h3>
		<p>Each stockpiled good has two prices: a <b>buy price</b> (Crown pays the depositing player) and a <b>sell price</b> (Crown charges the withdrawing player). The structural [IMPORT_EXPORT_SPREAD * 100]% spread guarantees Crown profit on every cycle.</p>
		<ul>
			<li>An entry on <b>Auto</b> mode anchors the buy price at the good's baseline (event multipliers do not move it - the Crown does not chase shortage spikes upward, or it would buy from depositors at the same rate it exports at and earn nothing). Sell price tracks the live market with a <b>downward-only</b> ratchet during a glut (Crown discounts to citizens), then snaps back to baseline once the glut ends. Shortages do not move the sell price - the Crown holds the line for citizens.</li>
			<li>The Steward may set either price by hand, which switches the entry to <b>Manual</b>. Manual entries do not ratchet; they hold whatever the Steward set until they are restored to Auto. Restoring Auto snaps both prices to the current market, resetting the ratchet anchors.</li>
			<li>Manual-priced entries are skipped by the Crown's autoexport sweep - manual is the Steward's territory.</li>
			<li>The Market Scroll surfaces a per-good <b>arbitrage margin</b> column (sell - buy, times current stock) and an aggregate "Crown spread on held stockpile" total at the top, so the Steward can see the realized-on-resale value of the warehouse at a glance.</li>
		</ul>

		<h3>Stockpile Limit - Auto and Manual</h3>
		<p>Each stockpile entry has a per-day limit beyond which deposits no longer pay. Limits start in <b>Auto</b> mode at roundstart, computed as <b>total daily demand across all regions x pop multiplier x [STOCKPILE_AUTO_LIMIT_DAYS] days of headroom</b>, with a [STOCKPILE_LIMIT_MIN]-unit floor for goods that have no demand line (gems, treasures). The Steward may override by setting a limit by hand, which flips the entry to <b>Manual</b>; <b>Auto-Limit All</b> resets every entry back to the formula.</p>

		<h3>Bulk Operators</h3>
		<p>The Market Scroll exposes per-category and global controls: <b>Auto-Price All</b> / <b>Auto-Limit All</b> reset modes; <b>Buy x</b> / <b>Sell x</b> multipliers scale either side of the spread across a category or globally (each multiplier flips affected entries to Manual). <b>Open All</b> / <b>Close All</b> per category open or refuse player deposits in bulk.</p>

		<h3>Surplus Exports</h3>
		<p>Each stockpile entry has a per-day <b>surplus floor</b>: <code>floor = limit x threshold</code>. Stock above the floor is surplus, and the Crown's daily auto-export sweep clears that surplus to the highest-paying region, capped at that region's remaining daily demand. The threshold defaults to 60% and is set globally - lower it to make the Crown more aggressive about turning hoarded stock into mammon, raise it to keep more stock on hand for citizens and standing orders.</p>
		<p>The Steward may also fire the sweep on demand from the Market Scroll's <b>Export Surplus</b> button (or the per-category equivalent). Once a region's daily demand is saturated, no further units can be exported there until the day rolls over - so spamming the button has no effect beyond the first useful click. <b>Manual-priced entries are skipped</b>: those are the Steward's territory, and the Crown will not auto-route stock the Steward has hand-priced. Hand-export them per-row from the same scroll.</p>

		<h3>Imports and the Stockpile</h3>
		<p>Inter-regional imports enter the Crown's stockpile and feed standing orders and the city's economy at large. The Steward may set a <b>purchase floor</b>: imports are refused when they would drop the Purse below it.</p>

		<p>The Alderman's trade warrant is an authorisation, not a purse of its own: it caps how much of the Crown's Purse he may spend on trade each day. Coin flows to and from the Purse as with any Steward-led trade. The Alderman <b>cannot</b> alter stockpile pricing or limits - those remain Steward-only authority.</p>
		</div>
	"}


/datum/book_entry/treasury/auto_import
	name = "09. Of Standing Imports"

/datum/book_entry/treasury/auto_import/inner_book_html(mob/user)
	return {"
		<div>
		<p>The Crown may set itself to top up essential goods each dawn, sparing the Steward the drudgery of hand-importing the same basics day after day. Placed goods stand on the list until struck from it.</p>

		<h3>Essentials</h3>
		<p>Four goods stand on standing import by default: <b>coal, wood, grain, and iron ore</b>. The Steward may strike any of them from the list at the Nerve Master's <b>Auto-Import</b> tab. They return on re-marking.</p>

		<h3>Adding Other Goods</h3>
		<p>Any importable good with an active producing region may be placed on standing import. The Steward marks them in the same tab, grouped by category.</p>

		<h3>Rules of the Tick</h3>
		<p>Each dawn, for each good on the list:</p>
		<ul>
			<li>If the stockpile already holds [AUTO_IMPORT_FLOOR] or more units, no import is made.</li>
			<li>Otherwise, the Crown buys [AUTO_IMPORT_BATCH] units from the cheapest producing region.</li>
			<li>The import is skipped if a unit would cost more than [AUTO_IMPORT_MAX_PRICE_MULT]x the good's base price. Shortage events push prices past this cap; standing import yields rather than emptying the Purse at panic rates.</li>
			<li>The import is skipped if it would drop the Crown's Purse below the Steward's <b>purse floor</b> (default [AUTO_IMPORT_PURSE_FLOOR_DEFAULT]m, adjustable from the tab).</li>
		</ul>

		<h3>Visibility</h3>
		<p>Successful imports announce on the Steward Comm channel with an <i>(auto)</i> tag and are spoken aloud at the Nerve Master. Skipped days (stockpile full, price spike, purse floor breach) leave a note in the Recent Activity readout instead - the channel is not spammed with non-events. The panel retains the last [AUTO_IMPORT_HISTORY_DAYS] days of standing-import activity.</p>

		<h3>Kill Switch</h3>
		<p><b>Strike All</b> in the tab suspends every standing import at once, essentials and other goods alike. Goods return on individual re-marking.</p>

		<p>Standing imports draw from the Crown's Purse only. They are not part of any Alderman warrant.</p>
		</div>
	"}


/datum/book_entry/treasury/supply
	name = "10. Of Supply and Demand"

/datum/book_entry/treasury/supply/inner_book_html(mob/user)
	return {"
		<div>
		<p>Economic events last [ECON_EVENT_DURATION] day(s) and are posted on the noticeboard under <b>Economic Events</b>.</p>

		<ul>
			<li><b>Shortage</b> - affected goods spike in price. One urgent standing order is posted against the afflicted region, <b>provided fewer than [STANDING_ORDERS_MAX_URGENT] urgent orders are already standing</b>. Past that cap, the shortage's price spike still bites, but no urgent quest is spawned - regular standing orders keep their pool slots.</li>
			<li><b>Oversupply</b> - affected goods drop in price.</li>
		</ul>

		<p>The <b>Market Scroll</b> at the Nerve Master shows live buy/sell prices for every good in every region.</p>
		</div>
	"}


/datum/book_entry/treasury/standing_orders
	name = "11. Of Standing Orders"

/datum/book_entry/treasury/standing_orders/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Types</h3>
		<ul>
			<li><b>Regular</b> - rolled each dawn ([STANDING_ORDERS_BASE_PER_DAY] base, +1 per ~20 active players, capped at [STANDING_ORDERS_MAX_PER_DAY]/day). [STANDING_ORDER_DURATION]-day lifespan. Payout: base x[1 + STANDING_ORDER_BASE_BONUS] per unit.</li>
			<li><b>Urgent</b> - spawned by shortage events, capped at [STANDING_ORDERS_MAX_URGENT] standing at a time. One-day lifespan. Payout: base x[1 + STANDING_ORDER_BASE_BONUS + URGENT_ORDER_EXTRA_BONUS] per unit.</li>
			<li><b>Warehouse</b> - for finished goods (equipment, potions, trophy heads). Settled from the export warehouse, not the stockpile. See Warehouse.</li>
			<li><b>Petitioned</b> - spawned on demand by the Steward burning Burgher Pledge. See <b>Petitions</b> below.</li>
		</ul>

		<h3>Petitions</h3>
		<p>The Steward may burn Burgher Pledge to summon a standing order on demand, picking a category and a non-blockaded target region. Petitioned orders are tagged in the UI and pay [round(PETITION_TAX_MULT * 100)]% of a normal roll's payout - the cost of skipping the dawn dice. Daily quota: [PETITIONS_PER_DAY] petitions per round-day. Categories include Provisions, Materials, Arms &amp; Harness, Luxuries, Alchemy &amp; Care, and Masterwork (artificed panoply, tournament provision, hunt trophies).</p>

		<h3>Fulfillment</h3>
		<p>Stockpile orders: deposit goods, confirm at the Nerve Master, payout minted to the Crown's Purse. Warehouse orders: settled automatically on sweep. <b>The bearer is not paid by the Crown</b> - the Steward holds the coin and decides what to remit.</p>

		<h3>Limits</h3>
		<p>Max [STANDING_ORDERS_MAX_PER_REGION] orders per region. Max [STANDING_ORDERS_POOL_CAP] orders in the Realm. Blockaded regions can hold orders but cannot be delivered to.</p>
		</div>
	"}


/datum/book_entry/treasury/warehouse
	name = "12. Of the Crown's Warehouse"

/datum/book_entry/treasury/warehouse/inner_book_html(mob/user)
	return {"
		<div>
		<p>Marked warehouse tiles adjoin the Nerve Master. Finished goods placed on these tiles fulfill warehouse-tagged standing orders on the next sweep.</p>

		<h3>Equipment Orders</h3>
		<p>Swept for exact-type match. Subtypes, variants, and heirlooms are not consumed.</p>

		<h3>Potion Orders</h3>
		<p>Swept by reagent and volume. Any container holding the right reagent counts, consumed from the top until the order is met.</p>
		</div>
	"}


/datum/book_entry/treasury/assembly
	name = "13. The City Assembly"

/datum/book_entry/treasury/assembly/inner_book_html(mob/user)
	return {"
		<div>
		<p>The Commons sit in open Assembly. Each session they elect an Alderman, set daily caps on their authority, and may recall or censure them. Sessions resolve in public announcement.</p>

		<h3>Sessions</h3>
		<p>The first session opens [ASSEMBLY_FIRST_SESSION_MINUTES] minutes after the round begins; thereafter sessions resolve each dawn. Votes are cast at the Assembly noticeboard and may be changed freely until the session resolves.</p>

		<h3>Who Sits, Who Votes</h3>
		<p>All jobs but members of the Keep, the Holy Otavan Inquisition, and the unjobbed may vote. Outlaws cannot vote. Voting weight is set by station:</p>
		<ul>
			<li><b>Transients</b> (Adventurer, Mercenary) - weight 1.</li>
			<li><b>Peasantry and sidefolk</b> - weight 1.5.</li>
			<li><b>Burghers and clergy</b> - weight 2.</li>
			<li><b>Notables</b> (Merchant, Guildmasters, Bishop, and the like) - weight 4.</li>
		</ul>
		<p>A Letter of Citizenry or Residency raises sub-Burgher weights to 2.</p>

		<h3>Motions</h3>
		<p>Six motions stand before every session. All are optional; a silent voter is not counted toward that motion's weight.</p>
		<ul>
			<li><b>Election</b> - any subject who can hold office may stand. The highest-weighted eligible candidate takes the seat.</li>
			<li><b>Trade Authority</b> - a bracket vote setting the Alderman's daily trade warrant. Brackets: [jointext(ASSEMBLY_TRADE_BRACKETS, "m, ")]m.</li>
			<li><b>Defense Authority</b> - a bracket vote setting the Alderman's daily defense warrant, denominated in Pledge. Brackets: [jointext(ASSEMBLY_DEFENSE_BRACKETS, "p, ")]p.</li>
			<li><b>Recall</b> - removes a sitting Alderman. Passes on [ASSEMBLY_RECALL_THRESHOLD_PCT]% YAE of cast weight.</li>
			<li><b>Censure</b> - bars a subject from holding office or wielding warrants for the rest of the round. Passes on [ASSEMBLY_CENSURE_THRESHOLD_PCT]% YAE of cast weight.</li>
			<li><b>Poll Tax</b> - suspended pending reform.</li>
		</ul>
		<p>Recall and censure require at least [ASSEMBLY_REMOVAL_MOB_FLOOR] distinct YAE voters casting a combined [ASSEMBLY_REMOVAL_WEIGHT_FLOOR / 2] weight. Bracket motions are vetoed if NAE reaches [ASSEMBLY_NAE_VETO_PCT]% of cast weight - the authorization falls to zero for that session.</p>

		<h3>Quorum</h3>
		<p>A session is valid only if at least [ASSEMBLY_QUORUM_VOTERS] distinct voters have cast a ballot across any of its motions. Below that, the session dissolves and all caps and officers hold as they were.</p>

		<h3>The Alderman</h3>
		<p>The Alderman speaks for the Commons. Their office is the two warrants - each a daily <b>authorisation ceiling</b>, not a pot of coin.</p>
		<ul>
			<li><b>Trade</b> - imports and exports spend the Crown's Purse, capped each day by the trade warrant. The Alderman may reach the Trade Scroll through the Assembly noticeboard's <i>Alderman - Trade</i> button, without standing at the Nerve Master.</li>
			<li><b>Defense</b> - commissions and blockade writs use the Burgher Pledge, capped each day by the defense warrant. The Alderman may not draw the Crown's Purse for defense, and may not issue Requests.</li>
		</ul>
		<p>Both ceilings refresh at each session's resolution. Unspent authorisation does not carry over.</p>

		<h3>Censure</h3>
		<p>A censured subject cannot stand for Alderman, cannot wield a warrant already held, and cannot be granted one. The mark lasts the round.</p>
		</div>
	"}


/datum/book_entry/treasury/insolvent
	name = "14. The Crown Insolvent"

/datum/book_entry/treasury/insolvent/inner_book_html(mob/user)
	return {"
		<div>
		<p>The Crown's failure to meet payroll is no longer a matter of mere shame. The <b>Azurian Trading Company</b> - the chartered house by which the Burghers of Azuria sit collectively as the Crown's principal creditor - intervenes by stages: first by advance, then, if the Crown fails again, by sequestration of the realm's commerce until the debt is settled.</p>

		<h3>First Failure - Arrears</h3>
		<p>If the Crown's Purse cannot meet the day's wages, the Burghers advance <b>at least [TREASURY_ARREARS_LOAN]m without interest</b> - enough to cover the day's shortfall in full. Wages pay as they would on any other day. The advance is registered as <b>arrears</b>, and from that moment until the debt is settled, every coin of inflow into the Crown's Purse is skimmed against it before reaching the balance.</p>

		<p>Charters stand. The Steward's trade controls stand. The realm continues as it was - only the Crown is encumbered. If revenue catches up before the next dawn's payroll, the debt is settled silently and the Burghers paid.</p>

		<h3>The Emergency Loan</h3>
		<p>Before Day [ATC_LOAN_CLOSED_DAY], the Crown may approach the Guilds clerk and draw an outright loan from the Azurian Trading Company - between <b>[ATC_LOAN_MIN_AMOUNT]m and [ATC_LOAN_MAX_AMOUNT]m</b>. The principal is paid into the Crown's Purse at once. The Company charges its <b>customary [round(ATC_LOAN_INTEREST_RATE * 100)]% interest</b>: a draw of [ATC_LOAN_MAX_AMOUNT]m therefore registers a debt of [round(ATC_LOAN_MAX_AMOUNT * (1 + ATC_LOAN_INTEREST_RATE))]m, repaid silently from skimmed inflow as with arrears. Until the debt is settled, no second loan may be drawn.</p>

		<p>Any draw is loudly proclaimed and binds the Crown to a hard rule: <b>the arrears grace is forfeit</b>. Should the Crown miss payroll while the loan stands outstanding - even by a single mammon - the realm enters sequestration without warning. The loan is a "just one more day" instrument, not a free pass.</p>

		<p>From Day [ATC_LOAN_CLOSED_DAY] onward, the Guilds clerk is <i>conveniently out of office</i>. The window is closed; no further loans are advanced. The Burghers will not be cheated of their collection by a swift round-end.</p>

		<h3>Second Failure - Sequestration</h3>
		<p>If the Crown misses payroll a second consecutive dawn (or once with an outstanding ATC loan), the realm is declared <b>sequestered</b>. The Azurian Trading Company holds the sequestered revenues of the realm and farms the customs and salt tolls in perpetuity until the debt is repaid.</p>

		<p>By the act of declaration:</p>
		<ul>
			<li><b>The Crown's Purse is reset to [BANKRUPTCY_OPERATING_FLOOR]m</b>, the operating floor that keeps the trade-engine running. Any residual above the floor is forfeit to the Company; any deficit below is topped up by them.</li>
			<li><b>A debt of [BANKRUPTCY_DEBT_FLAT]m + [BANKRUPTCY_DEBT_PER_PLAYER]m per active subject</b> is registered atop any arrears or loan debt already standing.</li>
			<li><b>All Crown salaries are suspended</b>. The Lord, the Hand, the Marshal, the Garrison, the Court - all serve without pay until sequestration lifts.</li>
			<li><b>All Charters but the Golden Bull are suspended</b>. The Lord cannot revive them while the realm is sequestered; they may only be restored by concession upon recovery (see below). The Golden Bull stands and cannot be revoked - the burghers retain their cap and ceiling regardless of the Crown's failure.</li>
			<li><b>The Steward's discretion over commerce is suspended</b>. Every importable good is placed on standing import; auto-export ratchets to [round(BANKRUPTCY_AUTOEXPORT_PERCENTAGE * 100)]% of stockpile limit. Manual import and export, stockpile pricing, and bulk price multipliers are all locked - the macro-economy runs itself under the Company's hand. The Steward's prior settings are <b>not</b> remembered, and on recovery these settings stand as sequestration left them; they must be re-tuned by hand.</li>
		</ul>

		<p>The skim continues during sequestration with one rule: <b>the Crown's Purse may refill up to the [BANKRUPTCY_OPERATING_FLOOR]m operating floor</b> from inflow, so the import-export engine keeps running. Anything above the floor is taken to debt.</p>

		<h3>What the Steward Still Wields</h3>
		<p>Sequestration punishes the Crown, not the realm. The Steward retains the instruments of taxation and coercion - by which the realm is expected to crawl out of debt:</p>
		<ul>
			<li><b>Tax authority</b>: poll tax, contract levy, headeater levy, import tariff, export duty - the Crown may set them as harshly as the cap allows on every category save burghers.</li>
			<li><b>Fine authority</b>: subject to the usual one-per-day rule and the Golden Bull's cap on burghers.</li>
			<li><b>The Burgher Pledge</b>: still refills daily, since the Bull stands. Defense commissions, blockade writs, and bounty work may all be issued.</li>
			<li><b>Petitions for standing orders</b>: the trade hall still hears the Steward's petition. Pledge-funded, the daily quota holds. Coin from fulfillment flows through the skim and pays the Company.</li>
			<li><b>Standing orders and warehouse rolls</b>: continue as before, payouts skimmed against the debt above the operating floor.</li>
		</ul>

		<p>What the Steward does <b>not</b> wield is the trade engine - manual imports, exports, stockpile pricing, bulk multipliers, and auto-trade controls are all locked while the Company administers commerce. Taxation and the lash of fines become the only honest paths to recovery.</p>

		<h3>Recovery and the Concession Picks</h3>
		<p>When the debt at last reaches zero, the realm is released from sequestration. Salaries resume on the morrow. The Crown's Purse is seeded with <b>[BANKRUPTCY_RECOVERY_RESET]m of working capital</b>.</p>

		<p>By ancient prerogative, the Lord may restore <b>up to [BANKRUPTCY_CONCESSION_PICKS] of the suspended Charters at once</b> - the customary span between proclamations waived as a concession to the realm's recovery. Charters not so chosen must wait the standard [DECREE_COOLDOWN / 600]-minute span between revisions, like any other.</p>

		<p>Unused picks do not carry over: a future sequestration resets the count.</p>

		<p>Trade configuration does <b>not</b> reset. The standing-import list, the auto-export ratio, the purse floor - all stand as the Company left them. The Steward must walk the Market Scroll and re-tune what the realm no longer needs forced. This is part of the cost of failure.</p>

		<h3>Twice-Failed Crowns</h3>
		<p>The realm may enter sequestration a second time in the same round. There is no protection against repeat failure. Each declaration adds a fresh debt; the climb out becomes commensurately steeper.</p>
		</div>
	"}


/datum/book_entry/treasury/banditry
	name = "15. Of Banditry and the Roads"

/datum/book_entry/treasury/banditry/inner_book_html(mob/user)
	return {"
		<div>
		<p>Each region untended slips by stages from <b>Quiet</b> to <b>Restive</b>, then to <b>Dangerous</b>, and at last to <b>Bleak</b>. From <b>Dangerous</b> onward, the Crown bleeds coin each dawn for the trade and toll its bandits have stolen on the road.</p>

		<h3>The Bleed</h3>
		<p>Each contributing region is reckoned per dawn:</p>
		<ul>
			<li><b>Dangerous</b>: [BANDITRY_DRAIN_DANGEROUS_FLAT]m base + [BANDITRY_DRAIN_DANGEROUS_PER_PLAYER]m per active subject of the realm.</li>
			<li><b>Bleak</b>: [BANDITRY_DRAIN_BLEAK_FLAT]m base + [BANDITRY_DRAIN_BLEAK_PER_PLAYER]m per active subject.</li>
		</ul>
		<p>The figure is surfaced on the Steward's Trade panel as <i>Projected Banditry Losses</i> with each region's share enumerated in plain coin and showing both the base and the per-head charge.</p>

		<h3>The Floor and the Debt</h3>
		<p>The Crown's Purse will not be cut below <b>[BANDITRY_DEBT_FLOOR]m</b> by banditry alone. What the dawn cannot take from the Purse becomes <b>banditry debt</b>, an accruing arrears that skims every coin of treasury inflow until paid. Stockpile earnings, taxes, fines, fees, loan repayments, even the gold from sold writs - all are eaten by debt before they reach the Purse.</p>

		<p>The skim runs silently and at full bite: a healthy treasury with mounting debt looks healthy on its face, while in truth no new coin enters until the debt is settled. The outstanding figure stands beside the projection on the Steward's panel.</p>

		<h3>What the Steward Cannot Escape</h3>
		<p>Embezzling the Purse to a personal account does not blunt the bleed. Banditry damage accrues regardless; what the Crown cannot pay becomes debt, and the debt eats whatever coin you might mint back. Hoarding outside the Crown's keeping is mechanically pointless. Personal accounts and stockpile balances are not directly touched - only inflow into the Crown's Purse is skimmed.</p>

		<h3>What the Steward Can Do</h3>
		<p>Engage the threat. Issue Defense Commissions and Blockade Writs against the Dangerous and Bleak regions. As threat falls, so does the bleed. The debt does not shrink on its own - it shrinks only as new income is earned and skimmed against it.</p>

		<p><i>This system is a stand-in until proper raid and siege content ships. Expect it to grow teeth, not lose them.</i></p>
		</div>
	"}
