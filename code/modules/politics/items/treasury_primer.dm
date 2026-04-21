/obj/item/book/rogue/treasury_primer
	name = "Of Laws, Taxation and the Keeping of the Treasury"
	desc = "A plain-bound ledger-book in the Azurian fashion, issued to Crown officers upon their appointment. Its pages lay out the four Charters of the Realm, the Crown's proper levies, and the binding of the purse to the law."
	icon_state = "basic_book_0"
	base_icon_state = "basic_book"
	title = "Of Laws, Taxation and the Keeping of the Treasury"

/obj/item/book/rogue/treasury_primer/attack_self(mob/user)
	user.set_machine(src)
	var/dat = {"<html><body>
<center><h2>OF LAWS, TAXATION AND THE KEEPING OF THE TREASURY</h2>
<i>A Primer for the Crown's Officers</i><br>
<i>Issued to Stewards, Grand Dukes, Councillors, and Clerks upon appointment.</i></center>
<hr>

<h3>I. The Four Charters of the Realm</h3>
<p>The realm is bound by four ancient Charters. Each grants a class of subjects protection from the Crown's levy, and each imposes upon them a corresponding duty. The Lord alone may suspend or restore a Charter, at the Titan, by speaking "<b>revise charter</b>". A Charter's public state is also posted upon the Charter Board.</p>

<p><b>The Great Writ of Azuria.</b> The nobility - both of our soil and the blue blood of foreign lands - shall bear no tax nor levy. In return they owe the Realm the duty of arms, and shall answer the Crown's call to war.</p>

<p><b>The Zenitstadt Concordat.</b> The clergy of the Church of Azuria shall bear no tax nor levy. The Church in turn prays for the Realm, keeps sacrament, tithes from amongst its own brethren, and furnishes templars for the common defense.</p>

<p><b>The Otavan Accords.</b> The Holy Otavan Inquisition, as foreign adherents sanctioned by treaty, shall bear no tax nor levy. They keep vigil against heresy and shall try only the common folk - for the crimes of any burgher or nobleman, they answer before the Church of the Ten.</p>

<p><b>The Golden Bull of Kingsfield.</b> The burghers and chartered residents of Azuria, and all the settled commons, shall bear no greater than a quarter portion in any levy or fine. They in turn furnish a common Budget for the defense of the Realm, apportioned amongst themselves by their own assembly.</p>

<p><i>Each Charter, once suspended or restored by the Lord, may not again be revised for thirty minutes. Moreover, no more than one suspension and one restoration may be proclaimed in a single day. Let the Crown rule with patience.</i></p>

<hr>
<h3>II. The Crown's Proper Levies</h3>
<p>The Crown draws income from five great sources of labour and trade, set forth as follows. The rates are set by the Steward or the Lord at the Nerve Master, revisable but once per day, and shall not exceed half measure.</p>

<ul>
<li><b>The Contract Levy</b> - taken upon the completion of contracts taken from the Grand Contract Ledger.</li>
<li><b>The Headeater Levy</b> - taken from bounty heads rendered at the Headeater machine.</li>
<li><b>The Import Tariff</b> - added to the cost of goods bought from merchant vendors.</li>
<li><b>The Export Duty</b> - taken from goods dispatched abroad by the Navigator's balloon.</li>
</ul>

<p><i>Deposits into a Meister are not taxed. Let it be known that the saving of coin is a virtue and the Crown shall not punish it.</i></p>

<hr>
<h3>III. Of Fines</h3>
<p>A fine is a punitive levy against a subject's Meister account, invoked from the Nerve Master upon cause shown.</p>

<ul>
<li>A subject protected by Charter may not be fined at all.</li>
<li>A subject under the Golden Bull (being a burgher, resident, or commoner) may be fined no more than a <b>quarter</b> of their account's balance in a single stroke.</li>
<li>All others may be fined no more than <b>three quarters</b> of their balance in a single stroke.</li>
<li>No Steward may issue more than <b>three fines</b> in a single day.</li>
<li>No subject may be fined more than <b>once</b> in a single day.</li>
</ul>

<hr>
<h3>IV. Of Outlaws</h3>
<p>When a subject is declared an Outlaw by the Lord at the Titan, they stand <i>civic dead</i>. Their standing before the Realm is struck; no Charter, no patronage, no protection avails them. Their wealth may be drained entire, and the caps above do not apply.</p>

<p><i>This is the Crown's last resort. A nobleman or cleric so declared shall surely draw the wrath of their faction; use it only for the gravest of causes, and be prepared to answer for it.</i></p>

<hr>
<h3>V. Patronage Grants</h3>
<p>Certain high offices may extend the protection of their Charter to named individuals, making them <i>declared</i> members of the protected class. Such grants require the recipient's consent and are publicly announced. They may be revoked at any time by the granter.</p>

<ul>
<li>The <b>Bishop</b> may declare up to <b>three Churchites</b> per round, under the Zenitstadt Concordat.</li>
<li>The <b>Inquisitor</b> may declare up to <b>three Psydonites</b> per round, under the Otavan Accords.</li>
<li>The <b>Steward</b> prints <b>Letters of Residency</b> at the Nerve Master (one every minute), which grant the bearer the Golden Bull's protection when claimed.</li>
</ul>

<p><i>If the backing Charter is suspended, the declared member's protection lapses while the suspension stands, and returns upon restoration.</i></p>

<hr>
<h3>VI. The Crown's Budgets</h3>
<p>The Crown's purse is kept in two vessels:</p>

<p><b>The Crown Discretionary</b> is the Realm's living treasury of coin. From it flow the daily wages of all sworn servants of the Crown, the purchase of imports, and the purse of the Steward's discretion. It is replenished by all taxes, by rural tribute, and by the margin upon exported goods.</p>

<p><b>The Burgher Bond</b> is not coin, but <i>authority</i> - a token of the Realm's standing to commission military action. It is granted daily in fixed measure, and only while the Golden Bull of Kingsfield stands in force. Should the Bull be suspended, the Burghers withdraw their contribution to the common defense, and the Bond shall not replenish until the Bull is restored.</p>

<hr>
<h3>VII. The Crown Insolvent</h3>
<p>Should the Crown Discretionary fall short at the day's dawning and the sworn servants of the Realm go unpaid, the Nerve Master shall announce it so, and the fault shall be written plain against the Steward's hand. Keep the purse prudent; a hungry garrison is a faithless one.</p>

<hr>
<center><i>Let the Crown's hand be steady, her ledger clean, and her levies few.</i></center>
</body></html>"}
	user << browse(dat, "window=treasury_primer;size=500x800")
