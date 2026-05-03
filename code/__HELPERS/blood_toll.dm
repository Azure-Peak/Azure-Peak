/proc/count_blood_toll_capita()
	var/count = 0
	for(var/datum/mind/mind in SSticker.minds)
		if(mind.assigned_role == "Adventurer" || mind.assigned_role == "Mercenary")
			count++
	return count

/proc/blood_toll_score_grade(per_capita)
	if(per_capita < 1)
		return list("grade" = "F", "copy" = "NOTHING EVER HAPPENS", "color" = "#7a7a7a")
	if(per_capita < 2)
		return list("grade" = "D", "copy" = "AZURIA HAS FALLEN", "color" = "#bd1717")
	if(per_capita < 4)
		return list("grade" = "C", "copy" = "AZURIA STUMBLES", "color" = "#c87a3a")
	if(per_capita < 6)
		return list("grade" = "B", "copy" = "AZURIA STANDS FAST", "color" = "#c4b454")
	if(per_capita < 10)
		return list("grade" = "A", "copy" = "AZURIA TRIUMPHS", "color" = "#7ec46a")
	return list("grade" = "S", "copy" = "AZURIA CAME, SAW AND CONQUERED", "color" = "#e6c060")

/proc/render_blood_toll_chronicle()
	var/list/data = list()
	var/list/stats = GLOB.azure_round_stats

	var/highwaymen = stats[STATS_KILLED_HIGHWAYMEN]
	var/bogmen = stats[STATS_KILLED_BOGMEN]
	var/orcs = stats[STATS_KILLED_ORCS]
	var/goblins = stats[STATS_KILLED_GOBLINS]
	var/gronnmen = stats[STATS_KILLED_GRONNMEN]
	var/drows = stats[STATS_KILLED_DROWS]
	var/deadites = stats[STATS_KILLED_DEADITES]
	var/infernals = stats[STATS_KILLED_INFERNALS]
	var/elementals = stats[STATS_KILLED_ELEMENTALS]
	var/fae = stats[STATS_KILLED_FAE]
	var/trollmino = stats[STATS_KILLED_TROLLMINOTAUR]
	var/drakkyn = stats[STATS_KILLED_DRAKKYN]
	var/lesser = stats[STATS_KILLED_LESSER_BEASTS]
	var/greater = stats[STATS_KILLED_GREATER_BEASTS]
	var/livestock = stats[STATS_KILLED_LIVESTOCK]

	var/total_humen = highwaymen + bogmen + gronnmen + drows
	var/total_graggarspawn = orcs + goblins
	var/total_deadite = deadites
	var/total_summons = infernals + elementals + fae
	var/grand_total = total_humen + total_graggarspawn + total_deadite + total_summons + trollmino + drakkyn + lesser + greater

	var/capita = count_blood_toll_capita()
	var/per_capita = capita > 0 ? (grand_total / capita) : 0
	var/list/grade = blood_toll_score_grade(per_capita)
	var/grade_color = grade["color"]

	data += "<div style='text-align: center; color: #e6c060; font-size: 1.5em; font-weight: bold; letter-spacing: 0.15em; margin-bottom: 15px;'>THE BLOOD TOLL</div>"
	data += "<div style='border-top: 2px solid #e6c060; margin: 0 auto 25px auto; width: 65%;'></div>"

	data += "<div style='text-align: center; margin: 0 auto 30px auto; width: 70%; padding: 25px 15px; background: rgba(20, 14, 0, 0.4); border: 2px solid [grade_color]; border-radius: 4px; box-shadow: 0 0 20px rgba(230, 192, 96, 0.15);'>"
	data += "<div style='font-size: 5em; font-weight: bold; color: [grade_color]; line-height: 1; text-shadow: 0 0 12px [grade_color]; letter-spacing: 0.1em;'>[grade["grade"]]</div>"
	data += "<div style='font-size: 1.6em; font-weight: bold; color: [grade_color]; margin-top: 12px; letter-spacing: 0.12em;'>[grade["copy"]]</div>"
	data += "<div style='color: #c4c4b4; margin-top: 18px; font-size: 0.95em;'>[grand_total] foes felled across [capita] sword\s for hire.</div>"
	var/per_capita_text = "[round(per_capita * 100) / 100]"
	data += "<div style='color: #e6c060; margin-top: 4px; font-size: 1.05em;'>[per_capita_text] per capita</div>"
	data += "</div>"

	data += "<div style='display: grid; grid-template-columns: repeat(2, 1fr); gap: 18px; margin: 0 auto 25px auto; width: 90%;'>"

	data += blood_toll_aggregate_card("HUMEN", total_humen, list("Highwaymen" = highwaymen, "Bogmen" = bogmen, "Gronnmen" = gronnmen, "Drows" = drows), "#c4a47a")
	data += blood_toll_aggregate_card("GRAGGARSPAWN", total_graggarspawn, list("Orcs" = orcs, "Goblins" = goblins), "#7aa46a")
	data += blood_toll_aggregate_card("DEADITE", total_deadite, list("Deadites" = deadites), "#9a6abc")
	data += blood_toll_aggregate_card("SUMMONS", total_summons, list("Infernals" = infernals, "Elementals" = elementals, "Fae" = fae), "#bd5a8a")

	data += "</div>"

	data += "<div style='text-align: center; color: #c4c4b4; font-size: 1.05em; font-weight: bold; letter-spacing: 0.1em; margin: 25px auto 10px auto;'>WILDS & WONDERS</div>"
	data += "<div style='border-top: 1px solid #6a6a5a; margin: 0 auto 15px auto; width: 60%;'></div>"
	data += "<div style='display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; margin: 0 auto 25px auto; width: 90%;'>"
	data += blood_toll_minor_card("Trolls & Minotaurs", trollmino)
	data += blood_toll_minor_card("Drakkyn", drakkyn)
	data += blood_toll_minor_card("Greater Beasts", greater)
	data += blood_toll_minor_card("Lesser Beasts", lesser)
	data += "</div>"

	data += "<div style='text-align: center; color: #999; font-style: italic; margin: 15px auto; font-size: 0.9em;'>Livestock slaughtered: [livestock]</div>"

	return data.Join()

/proc/blood_toll_aggregate_card(label, total, list/buckets, color)
	var/list/out = list()
	out += "<div style='background: rgba(20, 14, 0, 0.35); border: 1px solid [color]; border-radius: 3px; padding: 14px;'>"
	out += "<div style='display: flex; justify-content: space-between; align-items: baseline; border-bottom: 1px solid [color]; padding-bottom: 6px; margin-bottom: 8px;'>"
	out += "<span style='color: [color]; font-weight: bold; letter-spacing: 0.1em; font-size: 1.05em;'>[label]</span>"
	out += "<span style='color: [color]; font-weight: bold; font-size: 1.4em;'>[total]</span>"
	out += "</div>"
	for(var/key in buckets)
		out += "<div style='display: flex; justify-content: space-between; color: #c4c4b4; font-size: 0.9em; margin: 2px 0;'>"
		out += "<span>[key]</span><span>[buckets[key]]</span>"
		out += "</div>"
	out += "</div>"
	return out.Join()

/proc/blood_toll_minor_card(label, count)
	var/list/out = list()
	out += "<div style='background: rgba(20, 14, 0, 0.25); border: 1px solid #6a6a5a; border-radius: 3px; padding: 10px; text-align: center;'>"
	out += "<div style='color: #c4c4b4; font-size: 0.85em; letter-spacing: 0.05em;'>[label]</div>"
	out += "<div style='color: #e6c060; font-weight: bold; font-size: 1.4em; margin-top: 4px;'>[count]</div>"
	out += "</div>"
	return out.Join()
