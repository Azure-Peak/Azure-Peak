/datum/book_entry/treasury
	abstract_type = /datum/book_entry/treasury
	category = "The Crown's Treasury"

/datum/book_entry/treasury/charters
	name = "01. Charters of the Realm"

/datum/book_entry/treasury/charters/inner_book_html(mob/user)
	return {"
		<div>
		<p>Charters protect classes of subject from the Crown's taxation and levies.
		The Ruler and Regent may suspend or restore a Charter, at the throne, by speaking <b>revise charter</b>. State is shown on the Charters sections of the Notice Board. Note that tax exemption only applies to direct taxation like Contract Levy and Headeater Levy, not indirect taxation like Import or Export tariffs.</p>
		</div>

		<ul>
			<li><b>The Great Writ of Azuria</b> - Nobility pays no tax and levy, and cannot be fined.</li>
			<li><b>The Zenitstadt Concordat</b> - The Church, and any declared benefactors of the Church (Whom the Bishop can grant the status to up to [PATRONAGE_CAP_PER_ROUND] of), pays no taxation and levy.</li>
			<li><b>The Otavan Accords</b> - The Inqusition pays no tax and no levy.</li>
			<li><b>The Golden Bull of Kingsfield</b> - burghers is capped at [GOLDEN_BULL_BURGHER_CAP * 100]% of balance per levy or fine, with a [GOLDEN_BULL_DAILY_FINE_CAP]-mammon ceiling on each fine.</li>
			<li><b>The Covenant of Noc and Pestra</b> - University members, Apothecary and Head Physician is limited to the lightest poll tax of [NOC_PESTRA_POLL_CAP]m, and a minimum wage from the Crown's payroll.</li>
			<li><b>The Guild Charter of Arms</b> - Guild mercenaries is capped at [GUILD_CHARTER_OF_ARMS_POLL_CAP]m of poll tax per dae, and remits a [GUILD_CHARTER_OF_ARMS_PLEDGE_BONUS]m daily amount to the Burgher's Pledge while it is in force.</li>
			<li><b>The Indenture of War</b> - The Retinue, and Garrison members is subject to a minimum salary floor while this is in effect.</li>
		</ul>

		<p>Each Charter has a [DECREE_COOLDOWN / 600]-minute cooldown after revision. No more than one suspension and one restoration may be proclaimed per day.</p>
		</div>
	"}


/datum/book_entry/treasury/levies
	name = "02. Taxation and Levies"

/datum/book_entry/treasury/levies/inner_book_html(mob/user)
	return {"
		<div>
		<p>Rates on Taxation and Levies are set by the Steward using the "Adjust Taxes" verb - this can be done even with a ruler / regent in place, and any conflicts resulting from this and locking eachother out of adjusting tax rates for the day is an IC Issue to be resolved. The ruler or regent may also adjust tax rates at the throne by saying "Set Taxes". Poll taxes / subsidy and Levies has an independent cooldown of one day, and should either person set taxes - the other person is locked out from setting it until the next day.</p>
		</div>

		<h3>Transaction Levies</h3>
		<ul>
			<li><b>Contract Levy</b> - on Grand Contract Ledger payouts.</li>
			<li><b>Headeater Levy</b> - on bounty heads fed directly to the HEADEATER.</li>
			<li><b>Import Tariff</b> - on goods bought from merchant vendors including SILVERFACE, GOLDFACE.</li>
			<li><b>Export Duty</b> - on goods dispatched by the Navigator's balloon by the Merchant</li>
		</ul>

		<h3>Poll Tax</h3>
		<p>Poll tax is the one of the most powerful - and most hated tools in the Crown's arsenal to raise revenue. It is a daily tax levied on each subject with a bank account, draining from their balance automatically every day. Rates are set by the Steward or the Throne. Charters may exempt or cap certain categories of subject while they are in force. Poll taxes are hardcapped at [POLL_TAX_MAX_RATE]m/day, but can be set as low as a subsidy of -[POLL_TAX_MAX_SUBSIDY]m/day.</p>

		<p>Unpaid poll tax accumulates arrears. After [POLL_TAX_DEBT_DAYS_TO_DEBTOR] day(s) of arrears, the subject is marked <b>destitute</b>. Poll taxes arrear does not make someone kill on sight or allow you to attack them on sight, but should be seen as a roleplay opportunities to attempt to recover the arrears. Nor does it override ERP protection rules, because Poll Taxes are unilaterally enforced by the Crown, and thus the other party has not given explicit consent to be attacked or killed over their own actions other than the sin of having started with a bank account. You are expected, if they are broke, to forgive or recover as able and treat it as an opportunity to roleplay and not kill or attack.</p>

		<h3>Subsidy</h3>
		<p>A category's rate may be set as far as <b>-[POLL_TAX_MAX_SUBSIDY]m/day</b>. A negative rate is a <b>Crown subsidy</b>: each tick, the Crown's Purse pays that mammon to every subject of the category, reaching even charter-protected classes.</p>

		<p>The tax setter shows a projected per tick income or subsidy cost, and net flow based on current heads, so the Steward can see the budget impact before committing. The projection ignores balance and advance state - it is the gross rate × eligible head count. It also ignores that some people will not in fact, pay or be able to pay.</p>

		<p>Meister deposits are not taxed.</p>
		</div>
	"}


/datum/book_entry/treasury/fines
	name = "03. Fines and Loans"

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
		<p>Since a loan must be voluntarily entered into by the subject, defaulting a loan is valid ground for arresting or legal action - though it does not automatically give you the right to round remove the subject. Do not attempt to abuse ERP protection if you are planning to default on a loan.</p>
		</div>
	"}


/datum/book_entry/treasury/outlaws
	name = "04. Outlawry"

/datum/book_entry/treasury/outlaws/inner_book_html(mob/user)
	return {"
		<div>
		<p>A subjcet declared Outlaw by the ruler at the Throne does not have any Charter or patronage protection applied to them. Their account may be drained in its entirety by fine
		</p>
		</div>
	"}


/datum/book_entry/treasury/patronage
	name = "05. Patronages"

/datum/book_entry/treasury/patronage/inner_book_html(mob/user)
	return {"
		<div>
		<p>Patronage are way certain roles in game can extend their Charter's protection to other individuals.
		</p>
		<ul>
			<li><b>Bishop</b> - The Bishop may declare up to [PATRONAGE_CAP_PER_ROUND] person as benefactor of the Church, granting them the same tax and levy exemption as the Church while the Concordat is in force. This can be revoked at will by the Bishop.</li>
			<li><b>Steward</b> - The Steward may print Letters of Citizenry at the Nerve Master. The bearer gains Golden Bull protections while the Charter is in force. One can be printed every minute.</li>
		</ul>

		<p>Protection lapses if the backing Charter is not in force, but the status persist should it be restored.
		</p>
		</div>
	"}


/datum/book_entry/treasury/budgets
	name = "06. The Crown's Budgets & Authorisation"

/datum/book_entry/treasury/budgets/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Crown's Purse</h3>
		<p>The actual amount of mammons the Crown has. It is used to pay for wages, imports, deposit, and any other expenditure the Steward or any member with access to the Nerve Master may draw from (KEEP IT LOCKED!). Replenished by taxes, fines, rural tribute, direct deposit into the Nerve Master, exports and fulfilling standing orders.</p>

		<h3>Burgher Pledge</h3>
		<p>Not actual coin, but an abstract amount of virtual mammons pledged by the Burghers of the realm (off map). It refills daily while the Golden Bull stands, scaling to a flat amount and the amount of players in game; does not refill while the Bull is suspended.</p>

		<h3>Alderman's Warrant</h3>
		<p>An Alderman, elected by the City Assembly, gain a Defense Warrant and Trade Warrant. It is not a purse or actual money, but an authorization on how many of the Crown's purse or Burgher Pledge they can spend. The Alderman holds two such ceilings:</p>
		<ul>
			<li><b>Trade Warrant</b> - a daily mammon ceiling against the Crown's Purse. The Alderman may import and export up to this amount each day - with the montary value of import / export both counting against the Warrant; coin flows to and from the Purse itself.</li>
			<li><b>Defense Warrant</b> - a daily Pledge ceiling. Defense commissions issued by the Alderman burn Pledge authority up to this cap, just as the Steward's do. The Alderman may not draw the Crown's Purse for defense, and may not issue Requests.</li>
		</ul>
		<p>Both ceilings refresh at each session's resolution. Unspent authorisation does not carry over.</p>
		</div>
	"}


/datum/book_entry/treasury/defense
	name = "07. Defense and Blockades"

/datum/book_entry/treasury/defense/inner_book_html(mob/user)
	return {"
		<div>
		<p>Commissioned from the Grand Contract Ledger:</p>

		<ul>
			<li><b>Defense Commissions</b> - drawn against the Pledge or the Crown's Purse, posted to boards or handed to a bearer.</li>
			<li><b>Blockade Writs</b> - given to a fellowship of [BLOCKADE_FELLOWSHIP_REQUIREMENT]. The Steward may recall an unanswered writ after [BLOCKADE_RECALL_WINDOW_DS / 600] minutes, recovering the draft.</li>
			<li><b>Requests</b> - daily quota of [COMMISSION_REQUESTS_PER_DAY] reward-less commissions, Steward-only.</li>
		</ul>

		<h3>Issue Authority</h3>
		<p>In addition to the Steward, the Hand, Councillor, Grand Duke / Regent, Marshal and Clerk may also put out commissions and contracts.</p>

		<h3>Direct Commission vs Board:</h3>
		<p>A commission can be posted to the Grand Contract Ledger, or given directly to a bearer. Posting to the board allows anyone to take it, and follow the Fellowship limit for any party taking it. Handing it directly to a bearer is faster and more certain, but risks it being ignored or wasted on someone who can't complete it. The Steward may not take and claim a scroll they have issued themselves.</p>

		<h3>Bonus Pay</h3>
		<p>Either a Defense Commission or a Blockade Writ may be issued with <b>Bonus Pay</b> at one of three levels: <b>None</b> (x1.0), <b>Light</b> (x[COMMISSION_BONUS_PAY_LIGHT_MULT]), or <b>Full</b> (x[COMMISSION_BONUS_PAY_MULT]). The chosen multiplier applies to both the draft cost and the bearer's reward. Not available on Requests.</p>

		<h3>Levy Exemption</h3>
		<p> When a Steward issues a contract, they may make it Levy Exempt which exempts the bearer from Contract Levy on the reward. This is a powerful incentive that theoretically, cost you nothing to offer except the opportunity cost of the levy - and is useful for sweetening the deal for mercenaries or adventurers to get rid of threat and banditry.
		</p>

		<p> In addition, the Steward starts with an infinite use signet ring, which allows them, the Grand Duke, and a Clerk / Regent to stamp (click on a contract) physically and make a contract levy exempt after the fact. This can be used wisely by a Steward to say, bribe mercenary or adventurer after the fact.
		</p>

		<h3>Region and Reward</h3>
		<p>Defense commissions pay out in proportion to the threat they spawn. Each threat region carries a <b>reward multiplier</b> (surfaced in the commission UI beside the region name): Azure Basin at x0.75, Azure Grove at x1.0, Azurean Coast at x1.2, Terrorbog / Mount Decapitation / Underdark at x1.5. A Bounty in Terrorbog costs the same draft as a Bounty in Azure Basin - but the Terrorbog commission pays the bearer roughly twice as much. The Steward can use this to steer adventurers toward regions the realm most needs cleared.</p>

		<p><b>Blockade Writs</b> draw the same flat [BLOCKADE_SCROLL_PLEDGE_COST]m draft regardless of region, but the writ's payout is multiplied by the region's reward multiplier. For example: A Mount Decapitation blockade writ costs [BLOCKADE_SCROLL_PLEDGE_COST]m and pays out [round(BLOCKADE_SCROLL_REWARD * 1.5)]m on completion. Difficulty of Blockade Writ are technically stationary - though some regions are inherently more difficult than others due to the composition within. </p>

		<p>Multiple blockades may stand at once. One writ per blockade at a time. Blockades are rolled at roundstart only; there is no mid-round scheduled spawn.</p>

		<p>Blockade writ can be recalled by the Steward after 15 minutes, and has a 30 minutes timer before it is automatically lost. Each wave by 10 minutes - and it is independent of the other one, so once you pick up a Blockade Writ, hurry and finish it. This is to prevent the Crown from waiting infinitely for a blockade writ to be cleared.</p>
		</div>
	"}


/datum/book_entry/treasury/trade
	name = "08. Regional Trade"

/datum/book_entry/treasury/trade/inner_book_html(mob/user)
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
		<p>Each stockpiled good has two prices: a <b>buy price</b> (Crown pays the depositing player) and a <b>sell price</b> (Crown charges the withdrawing player). The structural [IMPORT_EXPORT_SPREAD * 100]% spread guarantees Crown profit within the same price cycle.</p>
		<ul>
			<li>An entry on <b>Autoprice</b> mode anchors the buy price at the good's baseline (event multipliers do not move it - the Crown does not chase shortage spikes upward, or it would buy from depositors at the same rate it exports at and earn nothing). Sell price tracks the live market with a <b>downward-only</b> ratchet during a glut (Crown discounts to citizens), then snaps back to baseline once the glut ends. Shortages do not move the sell price. No matter what, the automatic pricing will avoid losses.</li>
			<li>The Steward may set either price by hand, which switches the entry to <b>Manual</b>. Manual entries do not ratchet; they hold whatever the Steward set until they are restored to Auto. Restoring Auto snaps both prices to the current market, resetting the ratchet anchors.</li>
			<li>Manual-priced entries are skipped by the Crown's autoexport sweep - manual is the Steward's territory.</li>
			<li>The Market Scroll surfaces a per-good <b>arbitrage margin</b> column (sell - buy, times current stock) and an aggregate "Crown spread on held stockpile" total at the top, so the Steward can see the realized-on-resale value of the stockpile at a glance.</li>
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


/datum/book_entry/treasury/auto_import
	name = "09. Standing (Auto) Imports"

/datum/book_entry/treasury/auto_import/inner_book_html(mob/user)
	return {"
		<div>
		<p>The Crown may set itself to top up essential goods each dawn, sparing the Steward the drudgery of manual importing the same basics day after day. Placed goods stand on the list until struck from it.</p>

		<h3>Essentials</h3>
		<p>Six goods stand on standing import by default: <b>coal, wood, grain, iron ore, hide and fat</b>. The Steward may strike any of them from the list at the Market Scroll's <b>Auto-Import</b> tab. They return on re-marking.</p>

		<h3>Adding Other Goods</h3>
		<p>Any importable good with an active producing region may be placed on standing import. The Steward marks them in the same tab, grouped by category.</p>

		<h3>Rules</h3>
		<p>Each dawn, for each good on the list:</p>
		<ul>
			<li>If the stockpile already holds [AUTO_IMPORT_FLOOR] or more units, no import is made.</li>
			<li>Otherwise, the Crown buys [AUTO_IMPORT_BATCH] units from the cheapest producing region.</li>
			<li>The import is skipped if a unit would cost more than [AUTO_IMPORT_MAX_PRICE_MULT]x the good's base price. Shortage events push prices past this cap; standing import stops rather than emptying the Purse at panic rates.</li>
			<li>The import is skipped if it would drop the Crown's Purse below the Steward's <b>purse floor</b> (default [AUTO_IMPORT_PURSE_FLOOR_DEFAULT]m, adjustable from the tab).</li>
		</ul>

		<h3>Visibility</h3>
		<p>Successful imports announce on the Nervemaster with an <i>(auto)</i> tag and are spoken aloud at the Nerve Master. Skipped days (stockpile full, price spike, purse floor breach) leave a note in the Recent Activity readout instead - the channel is not spammed with non-events. The panel retains the last [AUTO_IMPORT_HISTORY_DAYS] days of standing-import activity.</p>

		<h3>Kill Switch</h3>
		<p><b>Strike All</b> in the tab suspends every standing import at once, essentials and other goods alike. Goods return on individual re-marking.</p>

		<p>Standing imports draw from the Crown's Purse only. They are not part of any Alderman warrant.</p>
		</div>
	"}


/datum/book_entry/treasury/supply
	name = "10. Supply and Demand"

/datum/book_entry/treasury/supply/inner_book_html(mob/user)
	return {"
		<div>
		<p>Economic events last [ECON_EVENT_DURATION] day(s) and are posted on the noticeboard under <b>Economic Events</b>.</p>

		<ul>
			<li><b>Shortage</b> - affected goods spike in price. One urgent standing order is posted against the afflicted region, <b>provided fewer than [STANDING_ORDERS_MAX_URGENT] urgent orders are already standing</b>. Past that cap, the shortage's price spike still happen, but no urgent order is spawned - regular standing orders keep their pool slots.</li>
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
			<li><b>Warehouse</b> - for finished goods (equipment, potions, trophy heads). Settled from the export warehouse (Behind the Stewardry), not the stockpile.</li>
			<li><b>Petitioned</b> - spawned on demand by the Steward burning Burgher Pledge. See <b>Petitions</b> below.</li>
		</ul>

		<h3>Petitions</h3>
		<p>The Steward may burn Burgher Pledge to summon a standing order on demand, picking a category and a non-blockaded target region. Petitioned orders are tagged in the UI and pay [round(PETITION_TAX_MULT * 100)]% of a normal roll's payout. Daily quota: [PETITIONS_PER_DAY] petitions per round-day. There are multiple categories - each of which has multiple standing orders type, so Steward can direct demands but not completely dictate its composition.</p>

		<h3>Fulfillment</h3>
		<p>Stockpile orders: deposit goods, confirm at the Nerve Master, payout minted to the Crown's Purse. Warehouse orders: settled automatically on sweep. <b>The bearer is not paid by the Crown</b> - the Steward holds the coin and decides what to remit.</p>

		<h3>Limits</h3>
		<p>Max [STANDING_ORDERS_MAX_PER_REGION] orders per region. Max [STANDING_ORDERS_POOL_CAP] orders in the Realm. Blockaded regions can hold orders but cannot be delivered to.</p>
		</div>
	"}


/datum/book_entry/treasury/warehouse
	name = "12. Warehouse"

/datum/book_entry/treasury/warehouse/inner_book_html(mob/user)
	return {"
		<div>
		<p>Steward's Export Machine and the surrounding tiles can be used for finished goods to fulfill warehouse-tagged standing orders.</p>

		<h3>Equipment Orders</h3>
		<p>Swept for exact-type match. Subtypes, variants, and heirlooms are not consumed.</p>

		<h3>Potion Orders</h3>
		<p>Swept by reagent and volume. Any container holding the right reagent counts, consumed from the top until the order is met.</p>
		</div>
	"}


/datum/book_entry/treasury/assembly
	name = "13. Alderman &  City Assembly"

/datum/book_entry/treasury/assembly/inner_book_html(mob/user)
	return {"
		<div>
		<p> Town members (not including members of the keep or garrison) can elect an Alderman to represent them and replace or augment a Steward's authority.
		</p>

		<h3>Sessions</h3>
		<p>The first session opens [ASSEMBLY_FIRST_SESSION_MINUTES] minutes after the round begins; thereafter sessions resolve each dawn. Votes are cast at the Assembly noticeboard and may be changed freely until the session resolves.</p>

		<h3>Who Sits, Who Votes</h3>
		<p>All jobs but members of the Keep, the Inquisition, and the unjobbed may vote. Outlaws cannot vote. Voting weight is set by station:</p>
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
		<p>The Alderman speaks for the Commons. Their office is the two warrants - each a daily <b>authorisation ceiling</b>.</p>
		<ul>
			<li><b>Trade</b> - imports and exports spend the Crown's Purse, capped each day by the trade warrant. The Alderman may reach the Trade Scroll through the Assembly noticeboard's <i>Alderman - Trade</i> button, without standing at the Nerve Master.</li>
			<li><b>Defense</b> - commissions and blockade writs use the Burgher Pledge at the Grand Contract Ledger, capped each day by the defense warrant. The Alderman may not draw the Crown's Purse for defense, and may not issue Requests.</li>
		</ul>
		<p>Both ceilings refresh at each session's resolution. Unspent authorisation does not carry over.</p>

		<h3>Censure</h3>
		<p>A censured subject cannot stand for Alderman, cannot wield a warrant already held, and cannot be granted one. The mark lasts the round.</p>
		</div>
	"}


/datum/book_entry/treasury/insolvent
	name = "14. Insolvency, Sequestration and Loans"

/datum/book_entry/treasury/insolvent/inner_book_html(mob/user)
	return {"
		<div>
		<p>The Crown can become insolvent if they fails to meet their payroll from the Crown's Purse at dawn. Technically, they can suspend payrolls by revoking Charters - at cost  angering the garrison & retinue (The biggest mandatory outlays). 
		</p>

		<p>When the Crown become insolvent, the Burghers of the realm intervenes by intervenes by stages: first by advance backed by the <b>Azurian Trading Company</b>, then, if the Crown fails again, by sequestration of the realm's commerce until the debt is settled.</p>

		<h3>First Failure - Arrears</h3>
		<p>If the Crown's Purse cannot meet the day's wages, the Burghers advance <b>at least [TREASURY_ARREARS_LOAN]m without interest - up to the actual shortfall amount</b> - enough to cover the day's shortfall in full. Wages pay as they would on any other day. The advance is registered as <b>arrears</b>, and from that moment until the debt is settled, every coin of inflow into the Crown's Purse is skimmed against it before reaching the balance.</p>

		<p>Charters stand. The Steward's trade controls stand. The realm continues as it was - only the Crown is encumbered. If revenue catches up before the next dawn's payroll, the debt is settled silently and the Burghers paid.</p>

		<h3>The Emergency Loan</h3>
		<p>Before Day [ATC_LOAN_CLOSED_DAY], the Crown may approach the Guilds clerk and draw an outright loan from the Azurian Trading Company - between <b>[ATC_LOAN_MIN_AMOUNT]m and [ATC_LOAN_MAX_AMOUNT]m</b>. The principal is paid into the Crown's Purse at once. The Company charges its <b>customary [round(ATC_LOAN_INTEREST_RATE * 100)]% interest</b>: a draw of [ATC_LOAN_MAX_AMOUNT]m therefore registers a debt of [round(ATC_LOAN_MAX_AMOUNT * (1 + ATC_LOAN_INTEREST_RATE))]m, repaid silently from skimmed inflow as with arrears. Until the debt is settled, no second loan may be drawn.</p>

		<p>Any loan is loudly proclaimed and binds the Crown to a hard rule: <b>the arrears grace is forfeit</b>. Should the Crown miss payroll while the loan stands outstanding - even by a single mammon - the realm enters sequestration without warning. The loan is a "just one more day" instrument, not a free pass.</p>

		<p>From Day [ATC_LOAN_CLOSED_DAY] onward, the Guilds clerk is <i>conveniently out of office</i>. The window is closed; no further loans are advanced. The Burghers will not be cheated of their collection by a swift round-end.</p>

		<h3>Second Failure - Sequestration</h3>
		<p>If the Crown misses payroll a second consecutive dawn (or once with an outstanding ATC loan), the realm is declared <b>sequestered</b>. The Azurian Trading Company holds the sequestered revenues of the realm and farms the customs and salt tolls in perpetuity until the debt is repaid.</p>

		<p>When Sequestrated:</p>
		<ul>
			<li><b>The Crown's Purse is reset to [BANKRUPTCY_OPERATING_FLOOR]m</b>, the operating floor that keeps the trade-engine running. Any residual above the floor is forfeit to the Company; any deficit below is topped up by them.</li>
			<li><b>A debt of [BANKRUPTCY_DEBT_FLAT]m</b> is registered atop any arrears or loan debt already standing.</li>
			<li><b>All Crown salaries are suspended</b>. The Ruler, the Hand, the Marshal, the Garrison, the Court - all serve without pay until sequestration lifts.</li>
			<li><b>All Charters but the Golden Bull are suspended</b>. The Ruler cannot revive them while the realm is sequestered; they may only be restored by concession upon recovery (see below). The Golden Bull stands and cannot be revoked - the burghers retain their cap and ceiling regardless of the Crown's failure.</li>
			<li><b>The Steward's discretion over commerce is suspended</b>. Every importable good is placed on standing import; auto-export ratchets to [round(BANKRUPTCY_AUTOEXPORT_PERCENTAGE * 100)]% of stockpile limit. Manual import and export, stockpile pricing, and bulk price multipliers are all locked - the economy as a whole runs itself under the Company's hand. The Steward's prior settings are <b>not</b> remembered, and on recovery these settings stand as sequestration left them; they must be re-tuned by hand.</li>
		</ul>

		<p>The skim continues during sequestration with one rule: <b>the Crown's Purse may refill up to the [BANKRUPTCY_OPERATING_FLOOR]m operating floor</b> from inflow, so the import-export engine keeps running. Anything above the floor is used to repay the debt.</p>

		<h3>What the Steward Still Wields</h3>
		<p>Sequestration punishes the Crown, not the realm. The Steward retains the instruments of taxation and coercion - by which the realm is expected to crawl out of debt:</p>
		<ul>
			<li><b>Tax authority</b>: poll tax, contract levy, headeater levy, import tariff, export duty - the Crown may set them as harshly as the cap allows on every category save burghers.</li>
			<li><b>Fine authority</b>: subject to the usual one-per-day rule and the Golden Bull's cap on burghers.</li>
			<li><b>The Burgher Pledge</b>: Still refills daily, since the Bull stands. Defense commissions, blockade writs, and bounty work may all be issued.</li>
			<li><b>Petitions for standing orders</b>: The trade hall still hears the Steward's petition. Coin from fulfillment flows through the skim and pays the Company.</li>
			<li><b>Standing orders and warehouse rolls</b>: Continue as before, payouts skimmed against the debt above the operating floor.</li>
		</ul>

		<h3>Recovery and the Concession Picks</h3>
		<p>When the debt at last reaches zero, the realm is released from sequestration. Salaries resume on the morrow. The Crown's Purse is seeded with <b>[BANKRUPTCY_RECOVERY_RESET]m of working capital</b>.</p>

		<p>By ancient prerogative, the Lord may restore <b>up to [BANKRUPTCY_CONCESSION_PICKS] of the suspended Charters at once</b> - the customary span between proclamations waived as a concession to the realm's recovery. Charters not so chosen must wait the standard [DECREE_COOLDOWN / 600]-minute span between revisions, like any other.</p>

		<p>Unused picks do not carry over: a future sequestration resets the count.</p>

		<p>Trade configuration does <b>not</b> reset. The standing-import list, the auto-export ratio, the purse floor - all stand as the Company left them. The Steward must re-tune what the realm no longer needs forced. This is part of the cost of failure.</p>

		<h3>Twice-Failed Crowns</h3>
		<p>The realm may enter sequestration a second time in the same round. There is no protection against repeat failure. Each declaration adds a fresh debt; the climb out becomes commensurately steeper.</p>

		<p>Technically, there's no limit on failing a third or any amount of time. Except the shame of abject, utter failure and disappointment.</p>
		</div>
	"}


/datum/book_entry/treasury/banditry
	name = "15. Banditry"

/datum/book_entry/treasury/banditry/inner_book_html(mob/user)
	return {"
		<div>
		<p>Every region that is <b>Dangerous</b> or <b>Bleak</b> contributes to the Crown's losses each dawn. 
		</p>

		<h3>Banditry Drain</h3>
		<p>Each contributing region is reckoned per dawn:</p>
		<ul>
			<li><b>Dangerous</b>: [BANDITRY_DRAIN_DANGEROUS_FLAT]m base + [BANDITRY_DRAIN_DANGEROUS_PER_PLAYER]m per active player.</li>
			<li><b>Bleak</b>: [BANDITRY_DRAIN_BLEAK_FLAT]m base + [BANDITRY_DRAIN_BLEAK_PER_PLAYER]m per active player.</li>
		</ul>
		
		<p>The figure is surfaced on the Steward's Trade panel as <i>Projected Banditry Losses</i> with each region's share enumerated in plain coin and showing both the base and the per-head charge.</p>

		<h3>The Floor and Banditry Debt</h3>
		<p>The Crown's Purse will not be cut below <b>[BANDITRY_DEBT_FLOOR]m</b> by banditry alone to avoid stockpile depletion. Amount in excess becomes <b>banditry debt</b>, an accruing arrears that skims every coin of treasury inflow until paid. Stockpile earnings, taxes, levies fines, loan repayments, - all are eaten by debt before they reach the Purse.</p>

		<h3>What you can do?</h3>
		<p>Issue Commissions and Blockade Writs against the Dangerous and Bleak regions. Use levy exemption as leverage. If drastic, levy the power of the retinue and garrison to slay them for money or for free. As threat falls, so does the bleed. The debt does not shrink on its own - it shrinks only as new income is earned and skimmed against it.</p>

		<p><i>This system is a stand-in until proper raid and siege content ships. Expect it to grow teeth, not lose them.</i></p>
		</div>
	"}

/datum/book_entry/treasury/tax_evasion
	name = "16. Jolly Tax Evasion"	

/datum/book_entry/treasury/tax_evasion/inner_book_html(mob/user)
	return {"
		<div>
		<p>With the many taxes added, so too comes the many opportunities for subjects to evade them, legally and not so legally.
		</p>

		<p><b>Legal Evasion</b>: Subjects who don't have a bank account is inherently immune to the poll taxes. To avoid Contract Levy, one must be a member of a tax exempt class - for example, a noble or a church members - though Church - unlike adventurers are expected to NOT adventure unless they have a compelling reason to. Instead, the Church Benefactor status the Bishop can grants is likely going to be the main mean this applies. Tax immunity does not applies to indirect taxes like import tariffs or export tariffs.
		</p>

		<p><b>Illegal Evasion</b>: The Merchant themselves can avoid taxes by toggling the navigator's tax paying and also stop paying taxes on Goldface. It is up to the Merchant to assume the risk of being caught and penalized by the Crown. While the machines tally how much you have dodged - no one but the Shophand and yourself can view the exact tally. The Crown can only make a guess and make an accusation with or without proof.</p>
		</div>
	"}


/datum/book_entry/treasury/innkeeper
	name = "17. The Innkeeper and the Guild"

/datum/book_entry/treasury/innkeeper/inner_book_html(mob/user)
	return {"
		<div>
		<p>On the Grand Contract Ledger, the Innkeeper has unique access to <b>Rumor</b> - flavored as rumors that the Innkeeper have heard of and lucrative contract opportunities (Please take it ICly, seriously instead of completely mechanically)</p>

		<h3>Rumor Points</h3>
		<p><b>Rumor Points</b> is the currency the Innkeeper use to generate contracts pool. The pool starts at [RUMOR_POINTS_START] and refills each dawn by [RUMOR_POINTS_BASE_REFILL] base + [RUMOR_POINTS_PER_PLAYER] per active player, capped at [RUMOR_POINTS_CLAWBACK_MULTIPLIER]x the daily refill. Unspent points above the cap are clawed back;.</p>

		<p>Each rumor type has a fixed point cost:</p>
		<ul>
			<li><b>Retrieval, Courier, Easy Kill</b> - [GLOB.rumor_point_costs[QUEST_RETRIEVAL]] points each.</li>
			<li><b>Clear-Out, Recovery</b> - [GLOB.rumor_point_costs[QUEST_CLEAR_OUT]] points each.</li>
			<li><b>Raid, Bounty</b> - [GLOB.rumor_point_costs[QUEST_RAID]] points each.</li>
		</ul>

		<h3>Composing a Rumor</h3>
		<p>At the Grand Contract Ledger, the Innkeeper opens the Rumor tab, picks a quest type, picks a region from those the type allows, and (for Recovery rumors) picks a shipment destination. The rumor may be:</p>
		<ul>
			<li><b>Posted to the board</b> - any qualifying party may take it, like any other contract.</li>
			<li><b>Placed in hands</b> - a physical scroll the Innkeeper hands to a chosen bearer directly.</li>
			<li><b>Lucrative</b> - a [round((RUMOR_LUCRATIVE_MULT - 1) * 100)]% premium on both point cost and bearer payout. Costs [RUMOR_LUCRATIVE_MULT]x the base points but pays [RUMOR_LUCRATIVE_MULT]x the base reward. Use it to sweeten the pot for a job that needs takers or earn more profit when there is a lack of takers.</li>
		</ul>

		<p>One rumor of a given type, region, and destination may be composed per day - to avoid farming the same most optimal rumor route or breaking the in game immersion these are actual rumors and not de facto custom made quest (Even if they very much are!). Combat rumors require the target region to carry at least [round(RUMOR_THREAT_GATE_MIN * 100)]% of its threat ceiling; a tamed region has nothing worth gossiping about.</p>

		<h3>Recovery Rumors</h3>
		<p>Recovery rumors are <b>unique</b> to the Innkeeper, and roll at a very very low rate on the contract board. They are kill-and-recover contract, the bearer slay a group of bandits and then retrieve a package that contain far more goods than usual courier contracts to the destination. Through this, the Innkeeper could attempts to redirect adventurers as they wishes to supplement the town's economy and meet some shortage. Guild of Craft rumors are on average, relatively useful for the guild too.</p>

		<h3>The Guild Cut</h3>
		<p>Whenever an adventurer turns in any contract from the Grand Contract Ledger - the Guild takes <b>[round(GUILD_REFERRAL_FEE_PCT * 100)]% of the gross reward</b> and remits it to the active Innkeeper's account, payment for keeping the common room open and the gossip flowing. If no Innkeeper sits the role, the fee is taken anyway and goes to the void - lest any adventurers or mercenaries sees the Innkeeper as an enemy IC / OOC taking funds that would've gone to them.</p>

		<p>On top of the referral fee, a <b>Rumor</b> contract specifically pays the Innkeeper an additional <b>[round(RUMOR_CONTACT_FEE_PCT * 100)]% Contact Referral Fee</b> on completion - the bearer's coin is untouched, representing fees paid by the contractor for referring the contract to a bearer. Rumors are therefore the Innkeeper's most lucrative product: every taker who finishes a rumor pays the Innkeeper twice.</p>
		</div>
	"}
