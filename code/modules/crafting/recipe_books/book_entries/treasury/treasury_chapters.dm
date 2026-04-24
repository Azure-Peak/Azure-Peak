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
		<p>Daily per-head tax by category: noble, clergy, inquisition, courtier, garrison, guild, merchant, burgher, adventurer, mercenary, peasant. Rates set at the Nerve Master, each capped at a daily ceiling. Charters override: Writ and Concordat exempt entirely; Golden Bull caps burghers at the lightest rate; Covenant does the same for scholars and healers.</p>

		<p>Unpaid poll tax accumulates arrears. After [POLL_TAX_DEBT_DAYS_TO_DEBTOR] day(s) of arrears, the subject is marked <b>destitute</b>. This does not give you valid permission to kill or attack them on sight - roleplay accordingly and try to recover the mammons as reasonable.</p>

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
		<p>Either a Defense Commission or a Blockade Writ may be issued with <b>Bonus Pay</b>, multiplying both the draft cost and the bearer's reward by x[COMMISSION_BONUS_PAY_MULT]. A tool to entice takers for dangerous regions, where normal pay would see the contract languish on the board. Not available on Requests.</p>

		<p>Multiple blockades may stand at once. One writ per blockade at a time.</p>
		</div>
	"}


/datum/book_entry/treasury/trade
	name = "08. Of Trade"

/datum/book_entry/treasury/trade/inner_book_html(mob/user)
	return {"
		<div>
		<p>The Crown trades with nine regions: Kingsfield, Rosawood, Rockhill, Daftsmarch, Blackholt, Saltwick, Bleakcoast, Northfort, Heartfelt. Executed through the Steward's Trade Scroll at the Nerve Master.</p>

		<h3>Pricing</h3>
		<ul>
			<li>Each region has daily production and demand for specific goods. Volumes scale with active player count.</li>
			<li><b>Import</b> price rises sharply once purchases exceed daily production. Repeat imports of the same good in one day carry a further surcharge.</li>
			<li><b>Export</b> revenue is always [IMPORT_EXPORT_SPREAD * 100]% less than the matching import price. Buying and re-selling is always a loss.</li>
			<li><b>Blockade</b>: import x[BLOCKADE_IMPORT_MULT], export x[BLOCKADE_EXPORT_MULT].</li>
			<li><b>Economic events</b> apply a further multiplier - see Supply and Demand.</li>
		</ul>

		<h3>Stockpile</h3>
		<p>Imports enter the Crown's stockpile and feed the garrison and standing orders. The Steward may set a <b>purchase floor</b>: imports are refused when they would drop the Purse below it.</p>

		<p>The Alderman's trade warrant is an authorisation, not a purse of its own: it caps how much of the Crown's Purse he may spend on trade each day. Coin flows to and from the Purse as with any Steward-led trade.</p>
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
			<li><b>Shortage</b> - affected goods spike in price. One urgent standing order is posted against the afflicted region.</li>
			<li><b>Oversupply</b> - affected goods drop in price.</li>
		</ul>

		<p>The Steward's Trade Scroll at the Nerve Master shows live buy/sell prices for every good in every region.</p>
		</div>
	"}


/datum/book_entry/treasury/standing_orders
	name = "11. Of Standing Orders"

/datum/book_entry/treasury/standing_orders/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Types</h3>
		<ul>
			<li><b>Regular</b> - posted daily. [STANDING_ORDER_DURATION]-day lifespan. Payout: base x[1 + STANDING_ORDER_BASE_BONUS] per unit.</li>
			<li><b>Urgent</b> - spawned only by shortage events. One-day lifespan. Payout: base x[1 + STANDING_ORDER_BASE_BONUS + URGENT_ORDER_EXTRA_BONUS] per unit.</li>
			<li><b>Warehouse</b> - for finished goods (equipment, potions). Settled from the export warehouse, not the stockpile. See Warehouse.</li>
		</ul>

		<h3>Fulfillment</h3>
		<p>Stockpile orders: deposit goods, confirm at the Nerve Master, payout minted to the Steward. Warehouse orders: settled automatically on sweep.</p>

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
		<p>If the Crown's Purse cannot meet daily payroll, the Nerve Master announces the shortfall publicly. There are no direct mechanical consequences, except the shame and dishonor of utter failure.</p>
		</div>
	"}
