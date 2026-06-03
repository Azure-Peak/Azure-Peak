/datum/book_entry/treasury_underground
	abstract_type = /datum/book_entry/treasury_underground
	category = "Underground"

/datum/book_entry/treasury_underground/black_market
	name = "01. The Black Market"

/datum/book_entry/treasury_underground/black_market/inner_book_html(mob/user)
	return {"
		<div>
		<p><b>BLACK MARKET:</b> Merchant letting you down? Stolen 100 cutleries from the Keep and have nothing to do with it but sneed? The Black Market is your friend! Just walk all the way across Azuria's famously safe Grove and Coast to a little island in the northeast, and dump your goods. The Bathmatron and </p>

		<h3>Brassface & Contraband Vendor</h3>
		<ul>
			<li>The bathhouse-side contraband vendor. Roundstart-locked by the <code>nightman</code> key, which only the Bathmaster and Bathhouse Attendant carry; anyone else needs the key or a successful lockpick.</li>
			<li>The public reflavor, PURITY, is unlockable and sells only Ordinance-compliant Drugs, Smokes, and Cosmetics. Anything flagged contraband appears on BRASSFACE only, and only to the proprietor jobs.</li>
			<li>Same shared TGUI as BRASSFACE; the difference is what categories are exposed and whether contraband-flagged packs are filtered.</li>
		</ul>

		<h3>The Ordinance</h3>
		<ul>
			<p>The Church of Azuria and the Bathhouse have signed an agreement that the Bathhouse will not sell any items that violate the Ordinance, and that in exchange the Church shall not interfere with the Bathhouse's business, and take it under their protection. The Ordinance's details can be read in the 
			Meister, and can be revoked by either side for any or no reasons. While it is in force, part of the secret Bathhouse Vault's income is remitted to the Church alongside a small portion of sales. The agreement does not prohibit the Church from breaking it or interfering if the Bathhouse does not even bother to hide their violations or outright professes heresy.
			</p>
		</ul>


		<h3>The Bathhouse Tunnel</h3>
		<ul>
			<li>Underground route connecting the bathhouse to the merchant quarter, used to move contraband and wretches without crossing the public street.</li>
			<li>Bathhouse positions and merchant positions both have access. Patrol roles do not.</li>
			<li>TODO: document the tunnel's exact endpoints and any door/lock mechanics on the merchant-side entrance once mapped.</li>
		</ul>
		</div>
	"}
