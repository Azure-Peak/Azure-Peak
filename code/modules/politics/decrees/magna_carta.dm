/datum/decree/magna_carta
	id = DECREE_MAGNA_CARTA
	name = "The Magna Carta"
	active = FALSE
	flavor_text = {"The Crown of Azuria, by the grace of Astrata, Lord of Azuria, Count of Kingsfield, Blackholt, and Saltwick, Overlord of Rosawood, Rockhill, and Daftsmarch, Protector of Bleakcoast, Northfort, and Heartfelt, Defender of the Ten, to his archbishops, priests, templars, inquisitors, dukes, princes, consorts, hands, stewards, councillors, clerks, marshals, knights, sergeants, men-at-arms, wardens, squires, court magicians, archivists, apothecaries, head physicians, merchants, innkeepers, bathmasters, guildsmen, burghers, residents, peasants, farmers, cooks, tapsters, bathmaids, servants, soilsons, mercenaries, adventurers, pilgrims, and to all his officials and loyal subjects, Greeting.

Know ye, that for the health of our soul, for the common benefit of the Realm, to the honour of the Ten, the exaltation of the holy Church, and the better ordering of our kingdom, we have granted unto every subject of Azuria, of whatsoever rank, station, or origin, that they shall bear no tax, no levy, no tariff, no duty, nor any fiscal imposition whatsoever upon their persons, estates, goods, labours, or callings, nor upon the instruments thereof, neither in coin nor in kind.

In return, the subjects of Azuria shall remember the Crown in their private thoughts, speak well of its name when it becometh them to do so, and furnish such revenue as conscience may prompt and good weather allow, in such quantity and at such times as each subject shall deem fitting unto themselves.

Yeven under the seal of the Lord of this yeer, who shall be remembered for it."}
	revoke_text = "Hear ye, hear ye. %RULER_NAME%, by the grace of Astrata, %RULER% of Azuria, Count of Kingsfield, Blackholt, and Saltwick, Overlord of Rosawood, Rockhill, and Daftsmarch, Protector of Bleakcoast, Northfort, and Heartfelt, Defender of the Ten, hath this day set aside the Magna Carta. The Realm's subjects are hereby restored to their accustomed fiscal obligations, and the Crown's revenue is restored in kind. Let the record reflect the reconsideration of %RULER_NAME%."
	restore_text = "Hear ye, hear ye. %RULER_NAME%, by the grace of Astrata, %RULER% of Azuria, Count of Kingsfield, Blackholt, and Saltwick, Overlord of Rosawood, Rockhill, and Daftsmarch, Protector of Bleakcoast, Northfort, and Heartfelt, Defender of the Ten, hath this day invoked the Magna Carta. Every subject of the Realm, of whatsoever rank or station, stands released from tax, tariff, levy, and duty for the duration that this Charter shall stand. Let the record show the year and the name of %RULER_NAME%, who sealed it."

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
