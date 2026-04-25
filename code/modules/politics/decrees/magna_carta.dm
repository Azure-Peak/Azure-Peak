/datum/decree/magna_carta
	id = DECREE_MAGNA_CARTA
	name = "The Magna Carta"
	category = DECREE_CATEGORY_NEW
	mechanical_text = "Zeroes every Crown levy and poll tax. Fines remain. The Crown collects only voluntary tribute."
	active = FALSE
	flavor_text = {"%RULER_NAME%, by the grace of Astrata, %RULER% of Azuria, Count of Kingsfield, Blackholt, and Saltwick, Overlord of Rosawood, Rockhill, and Daftsmarch, Protector of Bleakcoast, Northfort, and Heartfelt, Defender of the Ten, to his archbishops, priests, templars, inquisitors, dukes, princes, consorts, hands, stewards, councillors, clerks, marshals, knights, sergeants, men-at-arms, wardens, squires, court magicians, archivists, apothecaries, head physicians, merchants, innkeepers, bathmasters, guildsmen, burghers, residents, peasants, farmers, cooks, tapsters, bathmaids, servants, soilsons, mercenaries, adventurers, pilgrims, and to all his officials and loyal subjects, Greeting.

Know ye, that for the health of our soul, for the common benefit of the Realm, to the honour of the Ten, the exaltation of the holy Church, and the better ordering of our kingdom, we have granted unto every subject of Azuria, of whatsoever rank, station, or origin, that they shall bear no tax, no levy, no tariff, no duty, nor any fiscal imposition whatsoever upon their persons, estates, goods, labours, or callings, nor upon the instruments thereof, neither in coin nor in kind.

In return, the subjects of Azuria shall remember the Crown in their private thoughts, speak well of its name when it becometh them to do so, and furnish such revenue as conscience may prompt and good weather allow, in such quantity and at such times as each subject shall deem fitting unto themselves.

Yeven under the seal of %RULER_NAME%, %RULER% of this yeer, who shall be remembered for it."}
	revoke_text = "Hear ye, hear ye. %RULER_NAME%, by the grace of Astrata, %RULER% of Azuria, Count of Kingsfield, Blackholt, and Saltwick, Overlord of Rosawood, Rockhill, and Daftsmarch, Protector of Bleakcoast, Northfort, and Heartfelt, Defender of the Ten, hath this day set aside the Magna Carta. The Realm's subjects are hereby restored to their accustomed fiscal obligations, and the Crown's revenue is restored in kind. Let the record reflect the reconsideration of %RULER_NAME%."
	// restore_text intentionally unset - broadcast_state_change is overridden below so that
	// restoring the Carta reads the full charter aloud, ruler's name and all. That's the joke.

/datum/decree/magna_carta/roll_initial_year()
	return CALENDAR_EPOCH_YEAR

/datum/decree/magna_carta/on_restore()
	. = ..()
	SStreasury.tax_rates[TAX_CATEGORY_CONTRACT_LEVY] = 0
	SStreasury.tax_rates[TAX_CATEGORY_HEADEATER_LEVY] = 0
	SStreasury.tax_rates[TAX_CATEGORY_IMPORT_TARIFF] = 0
	SStreasury.tax_rates[TAX_CATEGORY_EXPORT_DUTY] = 0
	// Fines stay at their configured rate - the Crown can still punish.
	for(var/category in SStreasury.poll_tax_rates)
		SStreasury.poll_tax_rates[category] = 0

/datum/decree/magna_carta/broadcast_state_change()
	if(!active)
		return ..()
	var/body = get_display_flavor_text()
	if(!body)
		return ..()
	priority_announce(body, "BY LORDLY MERCY", pick('sound/misc/royal_decree.ogg', 'sound/misc/royal_decree2.ogg'), "Captain", strip_html = FALSE)
