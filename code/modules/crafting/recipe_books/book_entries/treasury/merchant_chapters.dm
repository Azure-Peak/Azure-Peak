/datum/book_entry/treasury_merchant
	abstract_type = /datum/book_entry/treasury_merchant
	category = "Merchant"

/datum/book_entry/treasury_merchant/navigator
	name = "01. The Navigator"

/datum/book_entry/treasury_merchant/navigator/inner_book_html(mob/user)
	return {"
		<div>
		<p><b>NAVIGATOR:</b> The heart of commerce of Azuria. This ancient machine lifts goods up by balloons to ships at the dock and the ATC's warehouse. The mechanisms are a trade secret of 
		Azurian trade company. There's three variants: Public Navigator, Navigator and Smuggler's Navigator</p>

		<h3>How it works</h3>
		<ul>
			<li>Drop sellable items on the eight tiles surrounding the machine. A balloon arrives every two minutes and lifts them into the air.</li>
			<li>Anchored items, coins, handcarts, ATC-sealed items, and items flagged unmintable (items that spawned in town at mapstart) are skipped.</li>
			<li>Each item's payout is its base price multiplied by category demand (current ship demand boost), then reduced by the navigator's handler fees - including export duty, merchant's levy,
			and any handler fees imposed by say, smugglers.</li>
			<li>Items priced below 1m of net payout are refused outright with a "the market is choked" message.</li>.</li>
			<li>Clicking on the Navigator reveals the current state of the warehouses.</li>
		</ul>

		<h3>Public Navigator</h3>
		<ul>
			<li>By default, it pays Crown's export duty AND the merchant's levy. The levy is also taxed at the same export duty rates to prevent tax base shrinking because of the Merchant's cut.</li>
			<li>Seller net drops on the navigator's tile; the Merchant's levy share and taxes remits directly to the factional fund.</li>
			<li>Merchants and Shophands can right-click and toggle two switches: Crown duty PAYING/DODGING and Merchant's levy COLLECTING/WAIVED. Dodged duty accrues to STATS_TAXES_EVADED and is shown in the panel.</li>
			<li>Per machine tallies (duty collected, duty evaded, levy collected) are visible to Merchant/Shophand only.</li>
		</ul>

		<h3>Private Navigator</h3>
		<ul>
			<li>Same as the Public Navigator, except the Merchant's levy is waived by default.</li>
			<li>Generally located in a more discreet location for the Merchant or Shophand to dodge export duty without easy exposure.</li>
		</ul>

		<h3>Smuggler Navigator (battered)</h3>
		<ul>
			<li>Pays no Crown duty and collects no Merchant levy. It uses the Black Market saturation pools. Demand is static. Saturation regenerates passively.</li>
			<li>Handler fee defaults to 50%. If a bathhouse worker is within 7 tiles when the lifting fires, the fee drops to 0% for that cycle.</li>
		</ul>

		<h3>Tax Collection</h3>
		<ul>
			<li>Crown duty remits to Crown's Purse, with a portion given unto the Church for the Concordat tithe if it is in force.</li>
			<li>Merchant's levy remits to the Merchant's Fund, held in a secure Jawbank.</li>
		</ul>
		</div>
	"}

/datum/book_entry/treasury_merchant/goldface
	name = "02. Goldface and Silverface"

/datum/book_entry/treasury_merchant/goldface/inner_book_html(mob/user)
	return {"
		<div>
		<p><b>GOLDFACE & SILVERFACE:</b> GOLDFACE is meant for the Merchant's own use, whereas Silverface is the public facing versions, split by rows and offering goods at a very high markup.</p>

		<h3>GOLDFACE</h3>
		<ul>
			<li>Locked/Unlocked by the merchant key or skeleton.</li>
			<li>Coin must be manually loaded and then used to buy goods</li>
			<li>ATC members can flip the Secrets toggle to enable the no tax upgrade, avoiding import tariffs</li>
			<li>Total tax paid and evaded are tracked per machine, and visible only to ATC members.</li>
			<li>Bought items are spawned ATC-sealed and cannot be re-exported via the navigator or the bulk fulfillment crate.</li>
		</ul>

		<h3>The Harbor tab (GOLDFACE only)</h3>
		<ul>
			<li>GOLDFACE is the command center for foreign trade. The Harbor tab shows docked ships, the wider ship pool, and discovered realms.</li>
			<li><b>Hails:</b> Merchant/Shophand may spend hails (one per ship invited to port) up to [TRADE_SHIPS_HAIL_PER_DAY] per day. First hail of the week from a given realm reveals that realm's market info. Grenzelhoft, Otava and Aavnr starts with their market conditions discovered.</li>
			<li><b>Dock spots:</b> 2, upgradable to 3. Vessels can be sent away after a [TRADE_SHIP_SEND_AWAY_GRACE / 600]-minute grace period.</li>
			<li><b>Cultural stocks:</b> Docked ships carry cultural-goods packs at a [TRADE_CULTURAL_SHIP_DISCOUNT_PERCENT]% discount off base cost. Import tariff still applies unless dodged.</li>
			<li><b>Bulk buy:</b> Docked ships offer bulk cargoes for sale, in small quantities but enough to help supplement market shortage or local shortfall.</li>
			<li><b>Bulk demands:</b> Docked ships purchase a large amount of goods at a decent markup, generally more than the town can produce reasonably.</li>
			<li><b>Victualling demands:</b> Docked ships demands delicious readied meals and preserved foods at a significant markup, providing an opportunity for profit for the Merchant and Innkeeper, 
			Soilson or Cooks that can fulfill these orders.</li>
			<li><b>Merchant's levy:</b> Merchant/Shophand can set the levy percentage (0 to [TRADE_MERCHANT_LEVY_CAP_PERCENT]%). This is the same levy collected by the Navigator on producer exports.</li>
		</ul>

		<h3>SILVERFACE (public)</h3>
		<ul>
			<li>Cannot be locked. keys are refused on the public variants. Adds a flat [50]% extra_fee Guild surcharge on every pack on top of base cost and import tariff. Designed to be unprofitable relative to Goldface.</li>
			<li>It was previously lockable, but producer can compete on price as is original intent - with at least a 65 - 90% markup over actual producer and simplification of the order workflow, plus players bad faith locking or locking and then AFKing without doing the job, the locking function has been removed.</li>
		</ul>
		</div>
	"}


/datum/book_entry/treasury_merchant/escrow
	name = "03. COMMISSIONER"

/datum/book_entry/treasury_merchant/escrow/inner_book_html(mob/user)
	return {"
		<div>
		<p><b>COMMISSIONER:</b>The COMMISSIONER lets anyone post a smithing or engineering commission with coin held in trust until a guildmember delivers the finished items. Posted orders can be partially settled or rejected.</p>

		<h3>Posting an order (commissioner side)</h3>
		<ul>
			<li>Deposit coin into the machine - the deposit is held under your name.</li>
			<li>Browse the catalogue.</li>
			<li>Each recipe has a unit price: material cost times (1 + percent_margin/100) plus flat_margin. Defaults are [20]% percent margin, [0] flat margin.</li>
			<li>You can refund your unposted deposit at any time. Posted but unclaimed orders can be cancelled (full refund).</li>
			<li>Open orders expire after [ESCROW_OPEN_EXPIRY_DAYS] days if unclaimed; deposit returns to your reservation and can be withdrawn.</li>
		</ul>

		<h3>Claiming and fulfilling (smith side)</h3>
		<ul>
			<li>Only guild keyholders may claim.</li>
			<li>Once claimed, the commissioner cannot cancel.</li>
			<li>Deliver finished items by striking the machine with them. Items must be at least [ESCROW_DURABILITY_FLOOR * 100]% integrity, the correct type (exact), and within the wanted quantity.</li>
			<li>Smith may voluntarily <code>release</code> the claim back to open status; delivered items return to the floor.</li>
			<li>Claimed orders expire after [ESCROW_CLAIM_EXPIRY_DAYS] day if not completed; the order auto-reverts to open and delivered items dump to the floor.</li>
		</ul>

		<h3>Partial fulfillment</h3>
		<ul>
			<li>If the smith has delivered some but not all of the required items, they may settle partially.</li>
			<li>Payout: (100 - [ESCROW_PARTIAL_HAIRCUT_PERCENT]) / 100. The haircut penalises partial work.</li>
			<li>The unspent escrow is returned to the commissioner's deposit reservation.</li>
		</ul>

		<h3>Guildmaster controls</h3>
		<ul>
			<li>Unlocked with a guild key. Unlocked panel exposes per-material price editing, percent margin (clamped 0-500), flat margin, and force-release of stalled claimed orders.</li>
			<li>Guildmaster may also reject any open or claimed order with a stated reason (200 char limit); delivered items dump to the floor, escrowed coin returns to the commissioner's deposit.</li>
		</ul>

		<h3>Other notes</h3>
		<ul>
			<li>Breaking the machine spills budget + all deposits to the floor and dumps every delivered item.</li>
			<li>Damaged-item rejection messages tell the smith to mend before delivering.</li>
			<li>Commissioners get notifications on claim, rejection, partial settle, completion, and expiry.</li>
		</ul>
		</div>
	"}


/datum/book_entry/treasury_merchant/avisa_market
	name = "04. The Avisa Market Tab"

/datum/book_entry/treasury_merchant/avisa_market/inner_book_html(mob/user)
	return {"
		<div>
		<p><b>AVISA:</b>The Avisa, Azuria's longest running newspaper, for the discerning and intellectual!</p>

		<h3>What it shows</h3>
		<p>
			Honestly, just click on it in the noticeboard. It will shows you multiple relevant information about the markets. Several producer places have a mini wall mounted noticeboard for this purpose.
		</p>
	"}


/datum/book_entry/treasury_merchant/rag_picker
	name = "05. The Scrapper / Rag Picker"

/datum/book_entry/treasury_merchant/rag_picker/inner_book_html(mob/user)
	return {"
		<div>
		<p><b>SCRAPPER / RAG PICKER:</b> A convenient machine that starts off with a 50m budget. To be salvager can dump in items that is demanded by the rag picker or scrapper and then receive mammons for their efforts immediately. After the initial budget is depleted, new mammons must be deposited for it to keep paying out. The associated roles can set prices, enable materials, and dump out the materials for them to salvage or resell manually.</p>
	"}

/datum/book_entry/treasury_merchant/harbor_mechanics
	name = "06. Ships, Hails, and the Warehouses"

/datum/book_entry/treasury_merchant/harbor_mechanics/inner_book_html(mob/user)
	return {"
		<div>
		<p><b>HARBOR MECHANICS:</b> The Merchant hails ship, manage sell and purchases from them, accumulate flavor and send them off.</p>

		<h3>Hailing</h3>
		<ul>
			<li>You have [TRADE_SHIPS_HAIL_PER_DAY] hails per day. A hail brings one ship from the pool to dock.</li>
			<li>The first hail from a given realm reveals that realm's market conditions for the week. Grenzelhoft, Otava and Aavnr start revealed.</li>
			<li>If a ship is sent away Honored, the spent hail is refunded - so a Merchant with stock to back it up can chain hails.</li>
			<li>A ship's tonnage determines its expected favor target and the amount of goods it can carry. It scales non-linearly from 100t to 800t.</li>
			<li>Docked ships can be sent away after [TRADE_SHIP_SEND_AWAY_GRACE / 600] minutes, or immediately if Honored.</li>
		</ul>

		<h3>Demand multipliers</h3>
		<ul>
			<li>Each realm wants specific categories. A docked ship raises demand on those categories - the Navigator pays above base for goods in them.</li>
			<li>Capped at 1.5x payout. Two ships wanting the same category stack toward the cap, not past it.</li>
			<li>Demand evaporates when the ship leaves. A category paying 1.5x while a ship is in port pays 1.0x once it's gone.</li>
		</ul>

		<h3>Saturation</h3>
		<ul>
			<li>Each category has a mammon denominated warehouse pool. Goods sold through the Navigator fill the pool. Capacity is rerolled at roundstart and pop-scaled with each player giving 0.5% additional capacity.</li>
			<li>A ship docking for a category drains 50% of that category's saturation, opening room for more sales while it's in port.</li>
			<li>A full warehouse refuses further intake. The Navigator sends the goods back with a \"market is choked\" message.</li>
			<li>The Black Market runs in parallel. Half capacity, flat prices (no demand mechanic), but regenerates 25% saturation per day automatically.</li>
		</ul>

		<h3>Send Off outcomes</h3>
		<ul>
			<li>Every ship docks with an expected favor target scaled by tonnage. Small coaster = small target, large galleon = large target.</li>
			<li><b>HONORED</b> (>=100% of target): Full delivered value banked as Favor, hail refunded.</li>
			<li><b>PARTIAL</b> (>=50%): Half delivered value banked as Favor. No hail refund.</li>
			<li><b>DISHONORED</b> (<50%): Flat Favor penalty, scaled by tonnage.</li>
		</ul>

		<h3>What the Merchant has to decide</h3>
		<ul>
			<li>Two hails a day, many ships in the pool. You can't hail them all - pick the ones you can actually fulfill.</li>
			<li>Balance between making a profit by arbitrage from their supplies, cultural stocks in demand by mercenaries and LARPer, and what the town produces.</li>
			<li>Small ships are easily Honored - low target, low reward, hail comes back. Large ships brings more goods with bigger Favor payout but it is much harder to hit the target alone.</li>
			<li>Hailing a ship you can't supply costs you both the hail and the Favor (Dishonor penalty). Better to leave them in the pool.</li>
			<li>Producers can fill the bulk demand crates. Your Favor income depends on whether they show up.</li>
		</ul>
		</div>
	"}
