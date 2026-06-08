/datum/book_entry/treasury_general
	abstract_type = /datum/book_entry/treasury_general
	category = "Common"

/datum/book_entry/treasury_general/charters
	name = "01. Charters of the Realm"

/datum/book_entry/treasury_general/charters/inner_book_html(mob/user)
	return {"
		<div>
		<p>Charters protect classes of subject from the Crown's taxation and levies.
		The Ruler and Regent may suspend or restore a Charter, at the throne, by speaking <b>revise charter</b>. State is shown on the Charters sections of the Notice Board. Note that tax exemption only applies to direct taxation like Contract Levy and Headeater Levy, not indirect taxation like Import or Export tariffs.</p>
		</div>

		<ul>
			<li><b>The Great Writ of Azuria</b> - Nobility pays no tax and levy, and cannot be fined.</li>
			<li><b>The Zenitstadt Concordat</b> - The Church, and any declared benefactors of the Church (Whom the Bishop can grant the status to up to [PATRONAGE_CAP_BENEFACTOR] of), pays no taxation and levy.</li>
			<li><b>The Otavan Accords</b> - The Inquisition pays no tax and no levy.</li>
			<li><b>The Golden Bull of Kingsfield</b> - burghers are capped at [GOLDEN_BULL_BURGHER_CAP * 100]% of balance per levy or fine, with a [GOLDEN_BULL_DAILY_FINE_CAP]-mammon ceiling on each fine.</li>
			<li><b>The Covenant of Noc and Pestra</b> - University members, Apothecary and Head Physician are limited to the lightest poll tax of [NOC_PESTRA_POLL_CAP]m, and a minimum wage from the Crown's payroll.</li>
			<li><b>The Guild Charter of Arms</b> - Guild mercenaries are capped at [GUILD_CHARTER_OF_ARMS_POLL_CAP]m of poll tax per day, and remit [GUILD_CHARTER_OF_ARMS_PLEDGE_BONUS]m daily to the Burgher's Pledge while in force.</li>
			<li><b>The Indenture of War</b> - The Retinue and Garrison members are subject to a minimum salary floor while this is in effect.</li>
		</ul>

		<p>Each Charter has a [DECREE_COOLDOWN / 600]-minute cooldown after revision. No more than one suspension and one restoration may be proclaimed per day.</p>
		</div>
	"}


/datum/book_entry/treasury_general/levies
	name = "02. Taxation and Levies"

/datum/book_entry/treasury_general/levies/inner_book_html(mob/user)
	return {"
		<div>
		<p>Rates on Taxation and Levies are set by the Steward using the "Adjust Taxes" verb. This can be done even with a ruler / regent in place; any conflict from both parties trying to set rates is an IC issue to resolve. The ruler or regent may also adjust tax rates at the throne by saying "Set Taxes". Poll taxes / subsidies and Levies have an independent one-day cooldown - whoever sets first locks the other out until the next day.</p>
		</div>

		<h3>Transaction Levies</h3>
		<ul>
			<li><b>Contract Levy</b> - on Grand Contract Ledger payouts.</li>
			<li><b>Headeater Levy</b> - on bounty heads fed directly to the HEADEATER.</li>
			<li><b>Import Tariff</b> - on goods bought from merchant vendors including SILVERFACE, GOLDFACE.</li>
			<li><b>Export Duty</b> - on goods dispatched by the Merchant via the Navigator's balloon.</li>
		</ul>

		<h3>Poll Tax</h3>
		<p>Poll tax is the one of the most powerful - and most hated tools in the Crown's arsenal to raise revenue. It is a daily tax levied on each subject with a bank account, draining from their balance automatically every day. Rates are set by the Steward or the Throne. Charters may exempt or cap certain categories of subject while they are in force. Poll taxes are hardcapped at [POLL_TAX_MAX_RATE]m/day, but can be set as low as a subsidy of -[POLL_TAX_MAX_SUBSIDY]m/day.</p>

		<p>Unpaid poll tax accumulates arrears. After [POLL_TAX_DEBT_DAYS_TO_DEBTOR] day(s) of arrears, the subject is marked <b>destitute</b>. Poll tax arrears do not authorise kill-on-sight or attack-on-sight, and they do not override ERP protection rules - poll tax is unilaterally imposed by the Crown, so the subject has not consented to being attacked or killed over it. Treat arrears as a roleplay opportunity to recover or forgive the debt.</p>

		<h3>Subsidy</h3>
		<p>A category's rate may be set as far as <b>-[POLL_TAX_MAX_SUBSIDY]m/day</b>. A negative rate is a <b>Crown subsidy</b>: each tick, the Crown's Purse pays that mammon to every subject of the category, reaching even charter-protected classes.</p>

		<p>The tax setter shows a projected per tick income or subsidy cost, and net flow based on current heads, so the Steward can see the budget impact before committing. The projection ignores balance and advance state - it is the gross rate × eligible head count. It also ignores that some people will not in fact, pay or be able to pay.</p>

		<p>Meister deposits are not taxed.</p>
		</div>
	"}


/datum/book_entry/treasury_general/fines
	name = "03. Fines and Loans"

/datum/book_entry/treasury_general/fines/inner_book_html(mob/user)
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
		<p>Loans are voluntarily entered into, so default is valid grounds for arrest or legal action - though it does not authorise round-removal. Do not abuse ERP protection if you intend to default on a loan.</p>
		</div>
	"}


/datum/book_entry/treasury_general/outlaws
	name = "04. Outlawry"

/datum/book_entry/treasury_general/outlaws/inner_book_html(mob/user)
	return {"
		<div>
		<p>A subject declared Outlaw by the ruler at the Throne loses all Charter and patronage protection. Their account may be drained in its entirety by fine.</p>
		</div>
	"}


/datum/book_entry/treasury_general/patronage
	name = "05. Patronages"

/datum/book_entry/treasury_general/patronage/inner_book_html(mob/user)
	return {"
		<div>
		<p>Patronages let certain roles extend their Charter's protection to other individuals.</p>
		<ul>
			<li><b>Bishop</b> - The Bishop may declare up to [PATRONAGE_CAP_BENEFACTOR] persons as benefactors of the Church, granting them the same tax and levy exemption as the Church while the Concordat is in force. The Bishop may revoke at will.</li>
			<li><b>Steward</b> - The Steward may print Letters of Citizenry at the Nerve Master. The bearer gains Golden Bull protections while the Charter is in force. One can be printed every minute.</li>
		</ul>

		<p>Protection lapses if the backing Charter is suspended, but the status persists and resumes if the Charter is restored.</p>

		<h3>Faction Patronage Writs</h3>
		<p>Three factions print their own patronage writs at their MEISTER's institutional panel. Each writ is a one use item: hand it to someone for them to claim it by using it in hand. Roster slots are limited per faction and prune when an enrolled member dies or is gone.</p>
		<ul>
			<li><b>Writ of Charter</b> (Merchant, up to [PATRON_CAP_MERCHANT]) - the bearer becomes an Agent of the Azurian Trading Company. They are recognized as a Burgher for tax purposes (Golden Bull cap) and will recognize the Company's debtors. Also confers Residency, so they are treated as a towner for round purposes including the towner contract gate.</li>
			<li><b>Token of the Bathhouse</b> (Bathmaster, up to [PATRON_CAP_BATHHOUSE]) - the bearer becomes an Agent of the Bathhouse. They may pass through the secret tunnel and the northeastern coast smugglers will offer them better prices on Black Market sales. They may also will recognize Bathhouse's debtors. Use discretion when granting to outlaws or wretches - the mark of the Bathhouse is visible, and being seen with it on a fugitive may invite Church or Crown reprisal against the Bathmaster.</li>
			<li><b>Letter of Benefaction</b> (Bishop / Martyr, up to [PATRON_CAP_CHURCH]) - the bearer becomes a Benefactor of the Church and inherits the Concordat's tax exemption (no direct taxation while the Concordat stands). They may also see the Church's debtors. This is one of the way for the Church main channel to gain lay allies say, in preparation for conflicts.</li>
		</ul>
		</div>
	"}


/datum/book_entry/treasury_general/supply
	name = "06. Supply and Demand"

/datum/book_entry/treasury_general/supply/inner_book_html(mob/user)
	return {"
		<div>
		<p>Economic events last [ECON_EVENT_DURATION] day(s) and are posted on the noticeboard under <b>Economic Events</b>.</p>

		<ul>
			<li><b>Shortage</b> - affected goods spike in price. One urgent standing order is posted against the afflicted region, <b>provided fewer than [STANDING_ORDERS_MAX_URGENT] urgent orders are already standing</b>. Past that cap, the shortage's price spike still happens, but no urgent order is spawned - regular standing orders keep their pool slots.</li>
			<li><b>Oversupply</b> - affected goods drop in price.</li>
		</ul>

		<h3>Ending a Shortage Early</h3>
		<p>A shortage does not have to run its full [ECON_EVENT_DURATION]-day course. The realm can <b>end it</b> by saturating the market. Every unit of an affected good that the Crown <b>exports</b> to a region that demands it - whether - counts toward relief.</p>

		<p>The associated urgent order is unaffected by a shortage ending</p>

		<p>Once cumulative deliveries cross <b>[round(ECON_EVENT_SATURATION_MULT * 100)]% of the average stockpile limit across the affected goods</b>, the shortage ends immediately: prices snap back to normal, the urgent order (if still standing) is recalled, and SCOM announces the relief. The target is realm-wide and aggregate - the Crown may meet it via any mix of the affected goods, through any channel.</p>

		<p>The <b>Market Scroll</b> at the Nerve Master shows live buy/sell prices for every good in every region.</p>
		</div>
	"}


/datum/book_entry/treasury_general/tax_evasion
	name = "07. Jolly Tax Evasion"

/datum/book_entry/treasury_general/tax_evasion/inner_book_html(mob/user)
	return {"
		<div>
		<p>Both legal and illegal ways to dodge taxes exist.</p>

		<p><b>Legal Evasion</b>: Subjects without a bank account are inherently immune to poll taxes. Avoiding Contract Levy requires membership in a tax-exempt class - nobles, church members, or holders of Church Benefactor status (granted by the Bishop). Note that the Church itself is not expected to adventure without IC reason, so Benefactor status is the practical channel. Tax immunity does not apply to indirect taxes like import tariffs or export duties.</p>

		<p><b>Illegal Evasion</b>: The Merchant can stop paying taxes by toggling the navigator's tax setting and refusing to pay on Goldface sales. The risk of being caught and penalised by the Crown falls on the Merchant. The machines tally dodged amounts, but only the Shophand and the Merchant themselves can view the exact tally - the Crown can only guess and accuse, with or without proof.</p>
		</div>
	"}


/datum/book_entry/treasury_general/innkeeper
	name = "08. The Innkeeper and the Guild"

/datum/book_entry/treasury_general/innkeeper/inner_book_html(mob/user)
	return {"
		<div>
		<p>On the Grand Contract Ledger, the Innkeeper and their tavern staff (Cook, Tapster) have access to <b>Rumor</b> contracts - framed IC as rumors of lucrative opportunities overheard at the tavern. Treat them ICly, not as raw mechanics.</p>

		<h3>Rumor Points</h3>
		<p><b>Rumor Points</b> are the currency the tavern uses to generate contracts. The pool starts at [RUMOR_POINTS_START] and refills each dawn by [RUMOR_POINTS_BASE_REFILL] base + [RUMOR_POINTS_PER_PLAYER] per active player, capped at [RUMOR_POINTS_CLAWBACK_MULTIPLIER]x the daily refill. Unspent points above the cap are clawed back.</p>

		<p>Each rumor type has a fixed point cost:</p>
		<ul>
			<li><b>Retrieval, Courier, Easy Kill</b> - [GLOB.rumor_point_costs[QUEST_RETRIEVAL]] points each.</li>
			<li><b>Clear-Out, Recovery</b> - [GLOB.rumor_point_costs[QUEST_CLEAR_OUT]] points each.</li>
			<li><b>Raid, Bounty</b> - [GLOB.rumor_point_costs[QUEST_RAID]] points each.</li>
		</ul>

		<h3>Composing a Rumor</h3>
		<p>At the Grand Contract Ledger, the Innkeeper or their tavern staff opens the Rumor tab, picks a quest type, picks a region from those the type allows, and (for Recovery rumors) picks a shipment destination. The rumor may be:</p>
		<ul>
			<li><b>Posted to the board</b> - any qualifying party may take it, like any other contract.</li>
			<li><b>Placed in hands</b> - a physical scroll the Innkeeper hands to a chosen bearer directly.</li>
			<li><b>Lucrative</b> - a [round((RUMOR_LUCRATIVE_MULT - 1) * 100)]% premium on both point cost and bearer payout. Costs [RUMOR_LUCRATIVE_MULT]x the base points but pays [RUMOR_LUCRATIVE_MULT]x the base reward. Use it to sweeten the pot for a job that needs takers or earn more profit when there is a lack of takers.</li>
		</ul>

		<p>One rumor of a given type, region, and destination may be composed per day, to prevent farming the most optimal route and maintain the in game fiction. Combat rumors require the target region to carry at least [round(RUMOR_THREAT_GATE_MIN * 100)]% of its threat ceiling. See <i>The Grand Contract Ledger</i> for shared mechanics including expiry windows.</p>

		<h3>Recovery Rumors</h3>
		<p>Recovery rumors are <b>unique</b> to the Innkeeper and roll only rarely on the contract board. The bearer slays a group of bandits and retrieves a package containing more goods than a normal courier contract carries. The Innkeeper can use this to redirect adventurers toward shortages or specific town needs.</p>

		<h3>The Guild Cut</h3>
		<p>Whenever an adventurer turns in any contract from the Grand Contract Ledger, the Guild takes <b>[round(GUILD_REFERRAL_FEE_PCT * 100)]% of the gross reward</b> and remits it to the active Innkeeper's account. If no Innkeeper sits the role, the fee is taken anyway and discarded - this avoids creating IC/OOC tension where the Innkeeper appears to be skimming from adventurers.</p>

		<p>On top of the referral fee, a <b>Rumor</b> contract pays the Innkeeper an additional <b>[round(RUMOR_CONTACT_FEE_PCT * 100)]% Contact Referral Fee</b> on completion. The bearer's coin is untouched - this represents fees paid by the contractor. Rumors are therefore the Innkeeper's most profitable product: every completed rumor pays the Innkeeper twice.</p>
		</div>
	"}

/datum/book_entry/treasury_general/towner_contracts
	name = "09. Towner Contracts"

/datum/book_entry/treasury_general/towner_contracts/inner_book_html(mob/user)
	return {"
		<div>
		<p>Certain towners and guildsmember can post custom contracts on the Grand Contract Ledger. All of these, by design, requires the involvement of the poster themselves and the poster must pay out of pocket to generate the contract. It is meant to be cooperative, combat oriented content that encourages you to go out of town to resolve a resource shortage together or provide additional roleplay opportunity</p>

		<p>In general, these contracts cost the towner money to post, must have the towner in the fellowship, and require the towner to be present for its full rewards to be claimed. It is up to the towner in question to negotiate how much of these additional, towner-gated rewards they wish to split or not.</p>

		<h3>Posting a Towner Contract</h3>
		<p>The eligible towner may post at the Grand Contract Ledger's "Postings" tab,
		they can choose to issue an Easy or a Hard version of their contract. Once posted, it is always posted onto the board instead of in hand. Worry not, the fellowship must includes you before someone can sign up for said contract.</p>

		<p>Towner contracts are exempt from both the Contract Levy and the Guild's referral cut.</p>

		<ul>
			<li><b>A Caravan Gone Missing</b> - a smith's wagon was ambushed on the road. The fellowship clears the bandits and the smith recover and opens the strongbox. The fellowship is paid in coins while the smith takes the recovered ingots. Restricted to Azure Grove and the Azurean Coast. Accessible by: Adventurer Blacksmith, Guild Blacksmith, Artificer, Guildmaster.</li>
			<li><b>A Miner's Lead</b> - a miner has prospected an elemental-guarded vein. The vein erupts only when the miner arrives. The fellowship is paid in coin and the ore is the miner's by agreement. Restricted to the Azurean Coast and the Underdark. Accessible by: Miner, Architect, Guildmaster.</li>
		</ul>
		"}

/datum/book_entry/treasury_general/contract_ledger
	name = "10. The Grand Contract Ledger"

/datum/book_entry/treasury_general/contract_ledger/inner_book_html(mob/user)
	return {"
		<div>
		<p>The Grand Contract Ledger is where contracts are posted and turned in. Contracts are sourced from three streams: the Guild contracft pool, the Steward's defense commissions, and Innkeeper's rumors.
		</p>

		<h3>Guild Contracts</h3>
		<p>Guild contracts regenerate every [QUEST_POOL_REGEN_INTERVAL / 600] minutes, with each tick generating up to [QUEST_KILL_REGEN_PER_TICK] new kill contracts across the regions that need them most. Evergreen contracts (Retrieval, Courier) top up independently to a flat per-region target. The pool front-loads at roundstart so there is always a healthy spread of work available.</p>

		<p>Each region has its own kill target scaled to the active player count. The pool routes new kill contracts to whichever region is furthest below its target, so blockaded or threat-heavy regions naturally accumulate more work to clear them.</p>

		<p>All guild contracts must pay the Guild referral fee and contract levy. A Steward can retroactively stamp a contract with their Signet ring, allowing it to become levy-exempt, but this will not skip the referral fee.
		</p>

		<h3>Expiry</h3>
		<p>Untaken board postings reroll on a timer:</p>
		<ul>
			<li><b>Guild contracts</b> - [QUEST_POOL_STALE_THRESHOLD / 600] minutes.</li>
			<li><b>Steward commissions and Innkeeper rumors</b> - [QUEST_PLAYER_STALE_THRESHOLD / 600] minutes. Player-paid postings get a longer window to find a taker.</li>
			<li><b>Direct-handed scrolls</b> - do not expire on the board timer. Kill writs still carry a hunt timer once active; other types stay valid until completed or abandoned.</li>
		</ul>

		<h3>Signing and Active Cap</h3>
		<p>Each player may hold up to [QUEST_MAX_ACTIVE_PER_PLAYER] active contracts at a time. Some jobs override this cap upward. A fellowship leader gains <b>+[QUEST_ACTIVE_FELLOWSHIP_BONUS_PAIR]</b> with one fellow in the band and <b>+[QUEST_ACTIVE_FELLOWSHIP_BONUS_BAND]</b> with two or more, so a led fellowship of three can run [QUEST_MAX_ACTIVE_PER_PLAYER + QUEST_ACTIVE_FELLOWSHIP_BONUS_BAND] simultaneous contracts.</p>

		<p>Beyond the active cap, a per-ckey <b>take cooldown</b> kicks in once you have signed your cap worth of contracts in a [QUEST_TAKE_COOLDOWN / 600]-minute window.</p>

		<h3>Towner Gate Gate</h3>
		<p>Town members cannot sign Guild contracts during the first [CONTRACT_TOWNIE_GATE_TIME / 600] minutes of the round. Adventuring jobs (Mercenary, Adventurer, and similar) are exempt and may sign immediately. The Ledger UI show how long the gate remains and the exempt job list. Contracts handed to you directly by Steward or Innkeeper are not affected by this, or fellowship requirement.</p>

		<h3>Deposits</h3>
		<p>Most contracts require a small deposit on signing, scaled by difficulty: <b>[QUEST_DEPOSIT_EASY]m</b> (Easy), <b>[QUEST_DEPOSIT_MEDIUM]m</b> (Medium), <b>[QUEST_DEPOSIT_HARD]m</b> (Hard). The deposit is returned on completion and forfeit on abandonment. It is not taxed.</p>

		<h3>Abandonment</h3>
		<p>A held contract may be abandoned at the Ledger. The deposit is forfeit to the void.</p>

		<h3>Turn-In and the Guild Cut</h3>
		<p>Completed contracts are turned in by clicking the Ledger while holding the quest scroll. Retrieval items must be dropped on the marked tile in front of the Ledger. On payout:</p>
		<ul>
			<li>The Crown's <b>Contract Levy</b> takes its tax cut (Levy Exempt contracts skip this).</li>
			<li>The Guild takes a <b>[round(GUILD_REFERRAL_FEE_PCT * 100)]% referral fee</b> off the gross, remitted to the active Innkeeper.</li>
			<li>The remainder is paid to the bearer's account.</li>
		</ul>

		<p>Rumor contracts pay the Innkeeper an additional Contact Referral Fee on top of the standard cut - see <i>The Innkeeper and the Guild</i>.</p>

		<h3>Hunt Timer</h3>
		<p>Active kill contracts carry a [QUEST_KILL_HUNT_TIMER / 600]-minute hunt timer, with warnings at the 2-minute and 30-second marks. If the timer runs out, the writ crumbles and any live wave mobs despawn. This starts when the mobs in question spawn at the target location. Blockade Writs use a longer per-wave timer - see <i>Defense and Blockades</i>.</p>
		</div>
	"}


/datum/book_entry/treasury_general/mercenary_statue
	name = "11. The Mercenary Statue"

/datum/book_entry/treasury_general/mercenary_statue/inner_book_html(mob/user)
	return {"
		<div>
		<p><b>TODO:</b> Rewrite in user voice. Stub draft below for fact-coverage only. The Mercenary Statue is a talkstatue that lets townfolk reach mercenaries and adventurers for hire, and lets the bathhouse reach wretches under assumed names.</p>

		<h3>Mercenary roster (public)</h3>
		<ul>
			<li>Mercenaries and adventurers cycle their status at the statue: Available, Contracted, Do not Disturb. First registration defaults to Available.</li>
			<li>Anyone may open the statue, browse the roster, and send a single mercenary a message. Recipients on Do not Disturb are hidden from the picker.</li>
			<li>Per sender-recipient pairing has its own cooldown to prevent spam.</li>
			<li>Messages are logged. Senders must stand adjacent to the statue to send.</li>
			<li>A list-numbers readout shows how many are available at a glance.</li>
		</ul>

		<h3>Wretch roster (hidden)</h3>
		<ul>
			<li>The wretch tab is visible only to wretches (to set themselves) and to bathhouse staff (to reach them). Other roles see nothing about it in the UI.</li>
			<li>Wretches may adopt a <b>nom de guerre</b> (max 60 chars) which replaces their real name on the bathhouse-side picker. Empty clears it back to real name.</li>
			<li>Wretches cycle the same Available / Contracted / Do not Disturb status as mercenaries.</li>
			<li>Bathhouse staff (Bathmaster, Bathmatron, etc) may message a single wretch via the statue. Messages have a per-pair cooldown and are logged.</li>
			<li>Wretch responses route back to the original sender through an ephemeral response ID.</li>
		</ul>

		<p><b>Note for documentation:</b> the wretch system is gated in code; do not advertise the wretch picker to non-wretch, non-bathhouse players. The system is opt-in for wretches and the bathhouse is the only paying contact channel.</p>
		</div>
	"}


/datum/book_entry/treasury_general/assembly
	name = "12. Alderman & City Assembly"

/datum/book_entry/treasury_general/assembly/inner_book_html(mob/user)
	return {"
		<div>
		<p>Town members (excluding the keep and garrison) can elect an Alderman to replace or augment the Steward's authority.</p>

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
		<p>The Alderman holds two daily authorisation ceilings:</p>
		<ul>
			<li><b>Trade</b> - imports and exports spend the Crown's Purse, capped each day by the trade warrant. The Alderman accesses the Trade Scroll through the Assembly noticeboard's <i>Alderman - Trade</i> button without standing at the Nerve Master.</li>
			<li><b>Defense</b> - commissions and blockade writs use the Burgher Pledge at the Grand Contract Ledger, capped each day by the defense warrant. The Alderman may not draw the Crown's Purse for defense, and may not issue Requests.</li>
		</ul>
		<p>Both ceilings refresh at each session's resolution. Unspent authorisation does not carry over.</p>

		<h3>Censure</h3>
		<p>A censured subject cannot stand for Alderman, cannot wield a warrant they hold, and cannot be granted one. The mark lasts the round.</p>
		</div>
	"}

/datum/book_entry/treasury_general/zadcote
	name = "13. Zadcote and Zadcage"

/datum/book_entry/treasury_general/zadcote/inner_book_html(mob/user)
	return {"
		<div>
		<p>The Zadcote is used to send messages, parcels, and for the nefarious - bottlebombs to linked zadcages. Each Zadcote is bound to a single faction - the Crown, the Azurian Trading Company, or the Bathhouse and accepts orders only from its faction.</p>

		<p>A Zadcage can ride in a pack, on a person, or be set down, and the zad will route to it reliably. Each zadcote spawns with its linked zadcages automatically..</p>

		<h3>Bonding a Zadcage</h3>
		<p>Strike a free Zadcage against a Zadcote to bond it to one of ten slots. The Zadcote operator may rename the slot in the interface. Bond persists until the operator severs it; the Zadcage holder cannot break it themselves. If you sever a slot while a zad is in flight, that zad completes its current trip before the bond goes dead.</p>

		<h3>Capacity tiers</h3>
		<p>Each dispatch chooses how many zads to send. Each of them may send a message, alongside a payload:</p>
		<ul>
			<li><b>1 zad</b> - A small item.</li>
			<li><b>2 zads</b> - A medium (normal) item or a pouch.</li>
			<li><b>3 zads</b> - A large / bulky item or container.</li>
		</ul>

		<h3>Flight time and turnback</h3>
		<p>A dispatched zad team takes about a minute to reach the Zadcage. If the Zadcage has been destroyed by then, the zads turn back with the payload intact. If the Zadcage is bonded but not on a person, delivery still completes - the Zadcote chimes to its operator so they know the cage was unattended.</p>

		<h3>Reply window</h3>
		<p>Once a zad lands, the Zadcage holder has three minutes to write a reply and place a return payload. After three minutes the zad lifts off on its own. Return capacity is equal to the dispatch capacity. <b>Auto-departure carries no message and no package.</b> The last 30 seconds tint the countdown red.</p>

		<h3>Attrition and Zadpacks</h3>
		<p>A returning zad has a small chance of being lost to exhaustion or harm. Bottlebomb flights are <b>one-way</b> - those zads are never recovered. A faction restocks its Zadcote with a Pack of Trained Zads bought through its supply machine: the ATC's at GOLDFACE, the Stewardry's via the nerve master's import, and the Bathhouse's through BRASSFACE. Strike the pack against the Zadcote to add ten fresh zads to the reserve.</p>

		<h3>Summoning</h3>
		<p>A Zadcage holder can actively summon zads from the linked zadcote, so they can send a message or package back proactively. The owner of the zadcote could turn it off if they are low on zads or think the bearer is abusing it.</p>

		<h3>Bombing!</h3>
		<p>The Zadcote can carry bottlebombs as a payload - up to three per dispatch. Bomb can only be sent once every five minutes. The Zadcage holder sees the zads arriving with bombs slung beneath, has time to drop or throw the cage, and may even weaponize it against someone they dislike. Admin logs every bomb dispatch by sender, receiver, and place of detonation.</p>

		<h3>Scrying (ATC and Bathhouse only)</h3>
		<p>The Merchant's Zadcote and the Bathmaster's Zadcote may scry through the bonded zad on a Zadcage. Scrying draws from a small <b>scrying fund</b> kept by the Zadcote itself. Feed coins of any denomination directly into the Zadcote to add to the fund, each scry deducts five mammon. The Zadcage holder feels arcane energy stir, and the cage glows blue while the scrying is active. The view lasts three minutes, long enough to confirm the holder is safe - or to make trouble. The Steward and Crown have no scrying access through Zadcotes, they must relies on the Court Mage's expertise scrying.</p>

		<h3>Spare zadcages & zads</h3>
		<p>Spare Zadcages cost ten mammon at the can be replaced by purchase from the faction's import machine. Trained zads sell as packs of ten.</p>
		</div>
	"}
