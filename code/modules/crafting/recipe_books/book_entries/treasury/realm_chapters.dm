/datum/book_entry/treasury_realm
	abstract_type = /datum/book_entry/treasury_realm
	category = "Steward"

/datum/book_entry/treasury_realm/budgets
	name = "01. Budgets, Warrants & Authority"

/datum/book_entry/treasury_realm/budgets/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Treasury</h3> <p>The Crown's actual mammon balance. Used to pay wages,
		imports, deposits, and any other expenditure drawn through the Nerve Master
		(KEEP IT LOCKED!). Replenished by taxes, fines, rural taxes, direct deposit
		into the Nerve Master, exports, and fulfilling standing orders.</p>

		<h3>Burgher Pledge</h3> <p>Not actual coin, but a virtual pool pledged by the
		Burghers of the realm (off map). It refills daily while the Golden Bull
		stands. The refill scales with a flat base and the number of active people.
		Does not refill while the Bull is suspended.</p>

		<h3>Alderman's Warrant</h3> <p>An Alderman, elected by the City Assembly,
		gains a Defense Warrant and a Trade Warrant. Neither are actual currency. They
		are spending ceilings against the Treasury and the Burgher Pledge:</p>
		<ul>
			<li><b>Trade Warrant</b> - a daily mammon ceiling against the Treasury. The
			Alderman may import and export up to this amount each day. The monetary value
			of both imports and exports counts against the Warrant. Coin flows to and
			from the Treasury itself.</li> <li><b>Defense Warrant</b> - a daily Pledge
			ceiling. Defense contracts issued by the Alderman burn Pledge authority up to
			this cap. The Steward's defense contracts work the same way. The Alderman
			can't spend the Treasury on defense and may not issue Requests.</li>
		</ul>
		<p>Both ceilings refresh at each session's resolution. Unspent authorisation does not carry over.</p>

		<h3>Crown Authority</h3> <p>The following titles share full Crown authority.
		They may petition regions, take a loan from the ATC, commission defense and
		blockade scrolls, and stamp contracts levy exempt with the signet:</p>
		<ul>
			<li>Steward, Clerk, Grand Duke, Hand, Marshal, Councillor, Prince/Princess.</li>
		</ul>
		<p>The Steward is the primary officer. The rest substitute when the Steward is
		absent, dead, or otherwise occupied. A Regent crowned at the Throne inherits
		the same authority for the duration of their regency.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/defense
	name = "02. Defense and Blockades"

/datum/book_entry/treasury_realm/defense/inner_book_html(mob/user)
	var/list/region_mults = list()
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		region_mults += "[TR.region_name] at x[TR.tp_budget_multiplier][TR.payout_multiplier != 1 ? " (and x[TR.payout_multiplier] on the reward)" : ""]"
	return {"
		<div>
		<p>Issued from the Contract Ledger:</p>

		<ul>
			<li><b>Defense contracts</b> - paid from the Pledge or the Treasury. They are
			posted to the Ledger or handed to a holder.</li> <li><b>Blockade Scrolls</b> -
			given to a fellowship of at least [BLOCKADE_FELLOWSHIP_REQUIREMENT]. It may
			be withdrawn from the Issued tab like any defense contract.</li>
			<li><b>Requests</b> - the Steward alone may post up to
			[COMMISSION_REQUESTS_PER_DAY] unpaid contracts a day.</li>
		</ul>

		<h3>Issue Authority</h3> <p>See <i>Budgets, Warrants & Authority</i> for the
		full list of titles that may issue defense contracts.</p>

		<h3>Direct Contract vs Ledger:</h3> <p>A contract can be posted to the
		Contract Ledger, or given directly to a holder. Handing it directly to a
		holder is faster and more certain. It risks being ignored or wasted on someone
		who can't complete it. The Steward may not take and claim a scroll they have
		issued themselves. See <i>The Contract Ledger</i> for shared mechanics
		including expiry windows, the take cooldown, and losing the deposit on
		abandonment.</p>

		<h3>Bonus Pay</h3> <p>Either a defense contract or a Blockade Scroll may be
		issued with <b>Bonus Pay</b> at one of three levels: <b>None</b> (x1.0),
		<b>Light</b> (x[COMMISSION_BONUS_PAY_LIGHT_MULT]), or <b>Full</b>
		(x[COMMISSION_BONUS_PAY_MULT]). The chosen multiplier applies to both the
		draft cost and the holder's reward. Not available on Requests.</p>

		<h3>Levy Exemption</h3> <p>When the Steward issues a contract, they may mark
		it Levy Exempt. The holder then pays no Contract Levy on the reward. This
		costs the Crown only the foregone levy and is useful for sweetening offers to
		mercenaries or adventurers.</p>

		<p>The Steward also starts with a signet ring with unlimited uses. Any holder
		of Crown authority (see <i>Budgets, Warrants & Authority</i>) can stamp a
		contract (click it) to make it Levy Exempt after the fact. This is useful for
		bribes.</p>

		<h3>Region and Reward</h3> <p>Defense contracts pay out in proportion to the
		threat they spawn. Each threat region carries a <b>reward multiplier</b>
		(shown beside the region name when you issue one): [english_list(region_mults)].
		A Bounty in Terrorbog costs the same draft as a Bounty in Azure Basin. The
		Terrorbog contract pays the holder far more. The
		Steward can use this to steer adventurers toward regions the realm most needs
		cleared.</p>

		<p><b>Blockade Scrolls</b> draw the same flat [BLOCKADE_SCROLL_PLEDGE_COST]m
		draft regardless of region. The scroll pays a base of [BLOCKADE_SCROLL_REWARD]m
		plus a flat travel stipend based on distance. The waves are the same strength
		everywhere. The actual threat varies with regional faction composition. Each
		person in range of the blockade beyond the first
		[BLOCKADE_DEFENDER_SCALE_MIN], up to [BLOCKADE_DEFENDER_SCALE_MAX] in total,
		increases the wave's strength and the payout.</p>


		<p>Multiple blockades may exist at once. One scroll per blockade at a time.
		Blockades are rolled only at roundstart and never spawn during the round.</p>

		<p>A Blockade Scroll may be withdrawn from the Issued tab until the first wave
		begins. The waves begin when the holder arrives. Each wave must be broken
		within [BLOCKADE_WAVE_TIMER_DS / 600] minutes of spawning. There are warnings
		at [DisplayTimeText(BLOCKADE_WAVE_WARN_FIRST)], [DisplayTimeText(BLOCKADE_WAVE_WARN_SECOND)] and
		[DisplayTimeText(BLOCKADE_WAVE_WARN_THIRD)] left.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/trade
	name = "03. Regional Trade"

/datum/book_entry/treasury_realm/trade/inner_book_html(mob/user)
	return {"
		<div>
		<p>The Crown trades with ten regions: Kingsfield, Rosawood, Rockhill, Daftsmarch, Blackholt, Saltwick, Hagenwald, Bleakcoast, Northfort, Heartfelt. Trade and stockpile both work through the Nerve Master's "Trade and Stockpile" interface.</p>

		<h3>Trade Pricing</h3>
		<ul>
			<li>Each region has daily production and demand for specific goods. Volumes
			scale with the number of active people.</li> <li><b>Import</b> price rises
			sharply once purchases exceed daily production. Repeat imports of the same
			good in one day carry a further surcharge.</li> <li><b>Export</b> price falls
			sharply once sales exceed daily demand.</li> <li><b>Export</b> price is
			always [IMPORT_EXPORT_SPREAD * 100]% less than the matching import price.
			Buying and reselling on the same day is always a loss.</li>
			<li><b>Blockade</b>: Blockade does not block import or export outright. It
			multiplies cost to make trade unwise: Import Price x[BLOCKADE_IMPORT_MULT],
			Export Revenue x[BLOCKADE_EXPORT_MULT].</li> <li><b>Economic events</b> apply
			a further multiplier. See Supply and Demand.</li> <li>Each Trade action is
			capped at [TRADE_MAX_BULK_UNITS] units per click. The trade modal shows a
			live quote with base subtotal, escalation surcharge, and total before
			commit.</li>
		</ul>

		<h3>Stockpile Pricing, Autoprice and Autolimit</h3> <p>Each stockpiled good
		has two prices: a <b>buy price</b> (what the Crown pays whoever deposits) and
		a <b>sell price</b> (what the Crown charges whoever withdraws).</p> <p>On
		<b>Autoprice</b>, prices follow the good's base price times any event
		multiplier. Blockades are ignored. The Crown profits at least 1m per
		transaction:</p>
		<ul>
			<li><b>Sell</b> = <code>import_ref</code>.</li> <li><b>Buy</b> = the lower of
			<code>[1 - IMPORT_EXPORT_SPREAD] × export_ref</code> or <code>export_ref -
			1m</code>.</li>
		</ul>
		<p>Where <code>import_ref = base × event_mod</code> and <code>export_ref =
		import_ref × [(1 - IMPORT_EXPORT_SPREAD) * 100]%</code>. At small base prices
		the 1m margin sets the buy price. At larger prices the [IMPORT_EXPORT_SPREAD * 100]% cut takes over and the Crown's margin grows with the price. Regional
		shortages, blockades and route congestion only affect imports and exports.
		They do not change stockpile prices. The Steward can set prices by hand when
		needed.</p>
		<ul>
			<li>The Steward may set either price by hand, which switches the entry to
			<b>Manual</b>. Manual entries hold whatever the Steward set until they are
			set back to Autoprice, which resets both prices at once.</li> <li>Autoexport
			skips goods priced by hand.</li>
			<li>The Market Scroll shows an <b>arbitrage margin</b> column for each good (sell - buy, times current stock) and an aggregate "Arbitrage potential" total at the top.</li>
		</ul>

		<h3>Stockpile Limit - Auto and Manual</h3> <p>Each stockpile entry has a daily
		limit beyond which deposits no longer pay. Limits start in <b>Auto</b> mode at
		roundstart. The formula is <b>total daily demand across all regions x pop
		multiplier x [STOCKPILE_AUTO_LIMIT_DAYS] days of headroom</b>. Goods with no
		demand line (gems, treasures) get a floor of [STOCKPILE_LIMIT_MIN] units. The
		Steward may override by setting a limit by hand, which flips the entry to
		<b>Manual</b>. <b>Autolimit All</b> resets every entry back to the
		formula.</p>

		<h3>Bulk Operators</h3> <p>The Market Scroll has controls for each category
		and for all goods: <b>Autoprice All</b> / <b>Autolimit All</b> reset modes;
		<b>Buy ×</b> / <b>Sell ×</b> multipliers scale either side of the spread
		across a category or globally (each multiplier flips affected entries to
		Manual). <b>Open All</b> / <b>Close All</b> per category open or refuse
		deposits in bulk.</p>

		<h3>Surplus Exports</h3> <p>Each stockpile entry has a daily <b>surplus
		floor</b>: <code>floor = limit x threshold</code>. Stock above the floor is
		surplus. Each dawn, Autoexport sells it to the best paying region until that
		region's demand runs out. The threshold defaults to
		[round(AUTOEXPORT_DEFAULT_PERCENTAGE * 100)]% and is set globally. Lower it to
		make the Crown more aggressive about turning hoarded stock into mammon. Raise
		it to keep more stock on hand for citizens and standing orders.</p> <p>The
		Steward may also press <b>Export Surplus</b> on the Market Scroll (or the
		button for one category). Once a region has no demand left, nothing more can
		be exported there until the next dawn. Pressing it again does nothing.
		<b>Goods priced by hand are skipped</b>. Export them row by row from the same
		scroll.</p>

		<h3>Imports and the Stockpile</h3> <p>Regional imports enter the Crown's
		stockpile and feed standing orders and the city's economy at large. The
		Steward may set a <b>purchase floor</b>: while the Treasury is below it, the
		stockpile stops buying deposits.</p>

		<p>The Alderman <b>cannot</b> alter stockpile pricing or limits. Those belong
		to the Steward alone.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/auto_import
	name = "04. Autoimport"

/datum/book_entry/treasury_realm/auto_import/inner_book_html(mob/user)
	return {"
		<div>
		<p>Autoimport buys essential goods each dawn. The Steward doesn't have to
		import the same basics by hand every day. Goods stay on the list until
		removed.</p>

		<h3>Essentials</h3>
		<p>Seven goods are on Autoimport by default: <b>coal, wood, grain, iron ore,
		hide, fur, and fat</b>. The Steward may remove any of them from the
		<b>Autoimport</b> tab and add them back later.</p>

		<h3>Adding Other Goods</h3> <p>Any importable good with an active producing
		region may be put on Autoimport. The Steward marks them in the same tab,
		grouped by category.</p>

		<h3>Rules</h3>
		<p>Each dawn, for each good on the list:</p>
		<ul>
			<li>If the stockpile already holds [AUTO_IMPORT_FLOOR] or more units, no
			import is made.</li> <li>Otherwise, the Crown buys [AUTO_IMPORT_BATCH] units
			from the cheapest producing region.</li> <li>The import is skipped if any
			unit would cost more than [AUTO_IMPORT_MAX_PRICE_MULT]x the good's base
			price. Shortages can push prices past this. Autoimport then skips the good
			instead of draining the Treasury.</li> <li>The import is skipped if it would
			drop the Treasury below the Steward's <b>Treasury floor</b> (default
			[AUTO_IMPORT_PURSE_FLOOR_DEFAULT]m, adjustable from the tab).</li>
		</ul>

		<h3>Visibility</h3>
		<p>Successful imports announce on the Nerve Master with an <i>(auto)</i> tag.
		Skipped days (stockpile full, price spike, Treasury floor) leave a note in the
		Tally readout. The panel retains the last [AUTO_IMPORT_HISTORY_DAYS] days of
		activity.</p>

		<h3>Kill Switch</h3> <p><b>Strike All</b> in the tab takes every good off
		Autoimport at once, essentials included. Goods can be enabled again one at a
		time.</p>

		<p>Autoimport spends from the Treasury only. It is not part of any Alderman
		warrant.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/standing_orders
	name = "05. Of Standing Orders"

/datum/book_entry/treasury_realm/standing_orders/inner_book_html(mob/user)
	return {"
<div>
		<h3>Types</h3>
		<ul>
			<li><b>Regular</b> - rolled each dawn ([STANDING_ORDERS_BASE_PER_DAY] base,
			+1 per ~[round(1 / STANDING_ORDERS_PER_ACTIVE_PLAYER)] active people, capped
			at [STANDING_ORDERS_MAX_PER_DAY]/day). Lasts [STANDING_ORDER_DURATION] days.
			Payout: base x[1 + STANDING_ORDER_BASE_BONUS] per unit.</li>
			<li><b>Urgent</b> - spawned by shortage events. No more than
			[STANDING_ORDERS_MAX_URGENT] stand at a time. Lasts [URGENT_ORDER_DURATION]
			days. Payout: base x shortage price multiplier per unit
			([ECON_SHORTAGE_MINOR]-[ECON_SHORTAGE_CRISIS]x).</li> <li><b>Warehouse</b> -
			for finished goods (equipment, potions, trophy heads). Settled from the
			export warehouse (Behind the Stewardry), not the stockpile.</li>
			<li><b>Petitioned</b> - spawned on demand by the Steward burning Burgher
			Pledge. See <b>Petitions</b> below.</li>
		</ul>

		<h3>Petitions</h3>
		<p>The Steward may burn Burgher Pledge to spawn a standing order on demand,
		picking a category and a target region that is not blockaded. Petitioned
		orders are tagged in the UI and pay [round(PETITION_TAX_MULT * 100)]% of a
		normal roll's payout. Daily quota: [PETITIONS_PER_DAY] per day. Each category
		contains several order templates. The Steward picks the category. The exact
		goods come from those templates.</p>

		<h3>Fulfillment</h3>
		<p>Stockpile orders: deposit goods and confirm at the Nerve Master. The payout
		goes into the Treasury. Warehouse orders: settled automatically on sweep. The
		Treasury is paid directly. The Steward decides who gets a share of the profit
		and how much.</p>

		<p><b>Partial fulfillment:</b> if the goods on hand cover at least
		[round(STANDING_ORDER_PARTIAL_THRESHOLD * 100)]% of an order's posted value,
		the Steward may settle it anyway. The buyer pays
		[round(STANDING_ORDER_PARTIAL_PAYOUT_MULT * 100)]% of the delivered share's
		value and nothing is paid for the missing share. A failed attempt locks
		fulfillment for [DisplayTimeText(STANDING_ORDER_FULFILL_RETRY_COOLDOWN)].</p>

		<h3>Limits</h3>
		<p>Max [STANDING_ORDERS_MAX_PER_REGION] orders per region. Max [STANDING_ORDERS_POOL_CAP] orders in the realm. Blockaded regions can hold orders but cannot be delivered to.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/warehouse
	name = "06. Warehouse"

/datum/book_entry/treasury_realm/warehouse/inner_book_html(mob/user)
	return {"
		<div>
		<p>The Steward's Export Machine and the surrounding tiles accept finished
		goods that fulfill standing orders tagged for the warehouse.</p>

		<h3>Equipment Orders</h3> <p>Only an exact type match counts. Subtypes,
		variants, and heirlooms are not consumed.</p>

		<h3>Potion Orders</h3>
		<p>Swept by reagent and volume. Any container holding the right reagent counts, consumed from the top until the order is met.</p>
		</div>
	"}



/datum/book_entry/treasury_realm/insolvent
	name = "07. Insolvency, Sequestration and Loans"

/datum/book_entry/treasury_realm/insolvent/inner_book_html(mob/user)
	return {"
		<div>
		<p>The Crown becomes insolvent if it fails to meet payroll from the Treasury
		at dawn. Suspending payrolls by revoking Charters is possible. It angers the
		garrison and retinue (the largest mandatory outlays).</p>

		<p>Insolvency triggers in stages: first an advance without interest, then an
		optional ATC loan, and finally sequestration if the Crown fails again.</p>

		<h3>First Failure - Arrears</h3> <p>If the Treasury cannot meet the day's
		wages, the Burghers lend <b>[TREASURY_ARREARS_LOAN]m or the full shortfall,
		whichever is larger</b>, without interest. Wages pay normally for the day. The
		advance is registered as <b>arrears</b>. Until the debt is cleared, everything
		paid into the Treasury goes to the debt first.</p>

		<p>Charters and trade controls are unaffected. If revenue catches up before
		the next dawn's payroll, the debt is cleared and nothing else happens.</p>

		<h3>The ATC Loan</h3> <p>Before Day [ATC_LOAN_CLOSED_DAY], the Crown may take
		a loan from the ATC for <b>[ATC_LOAN_MIN_AMOUNT]m to
		[ATC_LOAN_MAX_AMOUNT]m</b>. The principal is paid into the Treasury
		immediately. Interest is a flat <b>[round(ATC_LOAN_INTEREST_RATE * 100)]%</b>
		of the principal: a [ATC_LOAN_MAX_AMOUNT]m loan becomes
		[round(ATC_LOAN_MAX_AMOUNT * (1 + ATC_LOAN_INTEREST_RATE))]m of debt. It is
		repaid from skimmed inflow. Only one loan can be taken at a time.</p>

		<p>Taking the loan is announced. <b>Until it is repaid, the Burghers will not
		cover a missed payroll.</b> Missing it by even one mammon sequesters the realm
		at once.</p>

		<p>From Day [ATC_LOAN_CLOSED_DAY] onward, no more loans can be taken.</p>

		<h3>Second Failure - Sequestration</h3>
		<p>If the Crown misses payroll on a second consecutive dawn (or once with an outstanding loan), the realm enters <b>sequestration</b>:</p>
		<ul>
			<li><b>The Treasury is reset to [BANKRUPTCY_OPERATING_FLOOR]m</b>. Anything
			above that is lost, and anything below is topped up.</li> <li><b>A debt of
			[BANKRUPTCY_DEBT_FLAT]m</b> is registered on top of any existing arrears or
			loan debt.</li> <li><b>All Crown salaries are suspended</b> until
			sequestration lifts.</li> <li><b>All Charters but the Golden Bull are
			suspended</b>. They cannot be restored until sequestration lifts (see below).
			The Golden Bull cannot be revoked.</li> <li><b>The Steward's commerce
			controls are locked</b>. Every importable good is put on Autoimport, and the
			surplus threshold is set to [round(BANKRUPTCY_AUTOEXPORT_PERCENTAGE * 100)]%
			of the limit. Manual import/export, stockpile pricing, and bulk price
			multipliers are all disabled. The Steward's earlier settings are <b>not</b>
			restored on recovery and must be retuned by hand.</li>
		</ul>

		<p>The skim continues during sequestration. The Treasury may still refill up
		to the [BANKRUPTCY_OPERATING_FLOOR]m operating floor from inflow so trade
		keeps running. Anything above the floor goes to debt.</p>

		<h3>What the Steward Still Has</h3>
		<ul>
			<li><b>Tax authority</b>: poll tax, contract levy, headeater levy, import
			tariff, export duty. All may be set up to the cap. The Golden Bull still
			limits burghers.</li> <li><b>Fine authority</b>: subject to the usual rule of
			one fine per day and the Golden Bull cap on burghers.</li> <li><b>Burgher
			Pledge</b>: still refills daily since the Bull stands. Defense contracts and
			blockade scrolls may still be issued.</li> <li><b>Petitions for standing
			orders</b>: still available. Fulfillment coin flows through the skim.</li>
			<li><b>Standing orders and warehouse rolls</b>: continue as before. Payouts
			above the operating floor are skimmed against the debt.</li>
		</ul>

		<h3>Recovery</h3> <p>When the debt reaches zero, sequestration lifts. Salaries
		resume the next day. The Treasury is topped up to at least
		<b>[BANKRUPTCY_RECOVERY_RESET]m</b>.</p>

		<p>The Grand Duke or Regent can then restore the suspended Charters at the
		throne by speaking <b>revise charter</b>, one per day.</p>


		<p>Trade configuration does <b>not</b> reset on recovery: the Autoimport list
		and the surplus threshold stay where sequestration left them. Retune them by
		hand.</p>

		<h3>Repeat Sequestrations</h3> <p>The realm may enter sequestration multiple
		times in the same round. There is no protection against repeat failure. Each
		one adds fresh debt.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/banditry
	name = "08. Banditry"

/datum/book_entry/treasury_realm/banditry/inner_book_html(mob/user)
	return {"
		<div>
		<p>Regions classified as <b>Dangerous</b> or <b>Bleak</b> drain the Treasury
		each dawn.</p>

		<h3>Banditry Drain</h3>
		<p>Per region, per dawn:</p>
		<ul>
			<li><b>Dangerous</b>: [BANDITRY_DRAIN_DANGEROUS_FLAT]m base +
			[BANDITRY_DRAIN_DANGEROUS_PER_PLAYER]m per active person.</li>
			<li><b>Bleak</b>: [BANDITRY_DRAIN_BLEAK_FLAT]m base +
			[BANDITRY_DRAIN_BLEAK_PER_PLAYER]m per active person.</li>
		</ul>

		<p>The total is shown on the Steward's Trade panel as <i>Projected Banditry
		Losses</i>, broken down by region into a base amount and an amount per
		head.</p>

		<h3>Banditry Hoard</h3> <p>Mammon that brigands steal from the Crown is kept
		in the region as a hoard. The Scouts Report and the Steward's panels show how
		much.
		</p>

		<p>A Hoard Recovery scroll recovers the hoard. The Steward can issue one. A
		fellowship can also stake one themselves. A Blockade scroll already targeting
		the region also recovers it. The Crown then taxes it. A region must reach a
		minimum of [HOARD_RECOVERY_HOARD_MINIMUM]m before a recovery scroll can be
		issued by a fellowship of [BLOCKADE_FELLOWSHIP_REQUIREMENT] or more.</p>

		<h3>The Floor and Banditry Debt</h3> <p>Banditry alone won't take the Treasury
		below <b>[BANDITRY_DEBT_FLOOR]m</b>. Anything beyond that becomes <b>banditry
		debt</b>, which skims everything paid into the Treasury (stockpile earnings,
		taxes, levies, fines, loan repayments) until paid.</p>

		<h3>What You Can Do</h3> <p>Issue defense contracts and Blockade Scrolls against
		Dangerous and Bleak regions. Use levy exemption as bait. The retinue and
		garrison can also clear regions directly. As regional threat falls, so does
		the dawn drain. Banditry debt only shrinks as new income is earned and
		skimmed. The hoards can be reclaimed by clearing a Blockade or with a Hoard
		Recovery scroll.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/books
	name = "09. The Books of the Treasury"

/datum/book_entry/treasury_realm/books/inner_book_html(mob/user)
	return {"
		<div>
		<p>Every movement of coin is written down twice: once where it came from and
		once where it went. This is called double-entry bookkeeping. Each entry has a
		<b>debit side</b> and a <b>credit side</b>, and the two must always match. If an
		entry somehow fails to balance, the entry is logged as an error; this shows up
		in the Reconciliation section in the Trial Balance sheet as <b>Drift</b>.</p>
		</div>

		<h3>Accounts</h3>
		<ul>
			<li><b>Assets</b> - what the Crown holds or is owed: the Crown Purse, Loans Receivable,
			Poll Tax Receivable, Interest Receivable and the Stockpile Inventory.</li>
			<li><b>Liabilities</b> - what the Crown owes: the ATC loan (if applicable),
			the Burghers' arrears advance, sequestration debt, brigand debt, and poll tax received
			in advance.</li>
			<li><b>Equity</b> - opening capital, and grants and adjustments (what is left when debts
			are cleared by decree rather than paid).</li>
			<li><b>Revenue</b> - each tax and levy, poll tax, export sales, standing orders, the
			rural subsidy, fines, quality premiums and interest.</li>
			<li><b>Expenses</b> - wages, imports, stockpile purchases, contracts, brigand losses, poll
			subsidy, tithe, loan losses and so on.</li>
			<li><b>Unclassified</b> - the catch-all. Coin nobody has named lands here, so a large
			balance means something is not being labeled.</li>
		</ul>

		<h3>The Journal</h3>
		<p>A numbered list of entries, newest first. Each shows who paid whom, the reason, the amount,
		and the accounts debited and credited beneath. Small identical entries in quick succession are
		merged into one with a count, such as (x3). "By" shows who set an entry in motion. "System"
		marks a bookkeeping adjustment such as an accrual, a stock count or a bankruptcy move. Where
		one side of an entry has no fund, such as a tax receipt, wages or imports, it is named after
		the account on the other side. "The Realm" is used only when there is nothing better to call
		it.</p>

		<h3>The General Ledger</h3>
		<p>The General Ledger displays accounts and every entry that affects them. This is the place to see
		where a given transaction might have originated from.</p>
	"}


/datum/book_entry/treasury_realm/statements
	name = "10. Statements and Reconciliation"

/datum/book_entry/treasury_realm/statements/inner_book_html(mob/user)
	return {"
		<div>
		<h3>Trial Balance</h3>
		<p>Every account that has seen activity, with its balance on the debit or credit side. The two
		totals match when the books are in order. Any Drift is marked on the sheet.</p>

		<h3>Income Statement</h3>
		<p>Revenue minus expenses, shown for the whole round, for today and for yesterday. The fiscal
		day begins at dawn, with "today" showing everything happening since then.</p>

		<h3>Balance Sheet</h3>
		<p>The Balance Sheet incidcates what the Crown holds, set against what it owes and what is left over.
		Assets equal liabilities, plus equity, plus the surplus. Anything left over is shown as Unclassified.</p>

		<h3>Subsidiary</h3>
		<p>The Subsidiary tab holds detailed breakdowns of given totals, including open loans, receivables,
		what the Crown owes, the stockpile inventory by good, the payroll register, and a tax ledger with rates,
		amounts collected and amounts exempted.</p>

		<h3>Reconciliation</h3>
		<p>Compares the books with the real thing:</p>
		<ul>
			<li>The Crown Purse against the coin actually in the purse.</li>
			<li>The Crown's debt accounts against the treasury debt, and Brigand Debt against
			banditry debt.</li>
			<li>Poll Tax Receivable against the arrears owed, Poll Tax Received in Advance against
			what has been prepaid, and Interest Receivable against the interest accrued on open
			loans.</li>
			<li>Total debits against total credits.</li>
		</ul>

		<p>A <b>drift</b> that is not zero means coin moved without being written down, or something
		was written down that never happened. Common causes are an admin editing a balance directly,
		an account vanishing without being closed out, or an entry refused as unbalanced. The morning
		report warns when a line is out by half a mammon or more.</p>
		</div>
	"}


/datum/book_entry/treasury_realm/accruals
	name = "11. Accruals, Receivables and Stock Counts"

/datum/book_entry/treasury_realm/accruals/inner_book_html(mob/user)
	return {"
		<div>
		<p>The books recognize some things when they are earned, not when coin changes hands.</p>
		</div>

		<h3>Poll Tax</h3>
		<ul>
			<li>Each day's tax is counted as earned whether or not the subject can pay it.</li>
			<li>What is not collected is carried as a <b>receivable</b>. When they pay later, the payment
			clears the receivable first, and only the current day's tax counts as new revenue.</li>
			<li>Arrears that are forgiven (by the Steward, by an admin, or because the subject has
			left for good) are <b>written off</b> as an expense, "Poll Tax Written Off."</li>
			<li>Tax paid in advance is held as a liability, <b>Poll Tax Received in Advance</b>, and
			released into revenue one day at a time as the days pass.</li>
		</ul>

		<h3>Loan Interest</h3>
		<ul>
			<li>Interest on loans the Crown has made is counted day by day, as a receivable and as
			income, before it is paid.</li>
			<li>Repayments go to principal first, then to interest.</li>
			<li>A forgiven or orphaned loan writes off the unpaid principal and the unpaid interest as
			Loan Losses.</li>
		</ul>

		<h3>The Stockpile</h3>
		<ul>
			<li>Coin paid for goods is an expense when it is paid: Stockpile Purchases, or Imports and
			Purchases.</li>
			<li>The goods on hand are counted as an asset, the <b>Stockpile Inventory</b>, valued at
			the Crown's current buying price per unit. The count is taken at dawn and whenever the
			Ledger is opened or refreshed.</li>
			<li>Each count moves the asset up or down to match the shelves, and the difference goes to
			<b>Stock Count Variance</b>. When goods are exported the stock falls, and the variance
			charges the cost of what left, alongside the Export Sales revenue. The charge appears at
			the next count, not at the moment of sale.</li>
			<li>This is not the same figure as the Market tab's arbitrage potential.</li>
		</ul>

		<h3>Debts</h3>
		<ul>
			<li>Brigand losses the purse can pay are an expense. What it cannot pay becomes
			<b>Brigand Debt</b>, and [round(BANDITRY_DEBT_SKIM_RATE * 100)]% of later receipts goes to
			paying it down.</li>
			<li>The ATC loan, the Burghers' arrears advance and sequestration debt are liabilities.
			They are repaid out of incoming money, in an order that depends on the Treasury's
			condition.</li>
		</ul>
	"}
