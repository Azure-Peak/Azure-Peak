/atom/movable/screen/alert/status_effect/buff/healing/spider_cocoon
	name = "Spider loogies"
	desc = "Arachnid weave is stitching some of my wounds up slowly."
	icon_state = "buff"

#define COCOON_FILTER "cocoon_glow"

/datum/status_effect/buff/healing/spider_cocoon
	id = "healing_spider"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing/spider_cocoon
	duration = 1800 SECONDS
	examine_text = "SUBJECTPRONOUN is covered in spider silk... eww!"
	healing_on_tick = 1
	outline_colour = "#4e4c4c00"
	var/blood_healing_on_tick = 20

/datum/status_effect/buff/healing/spider_cocoon/on_apply()
	//The hardier you are, the more likely you are to recover from grievous wounds.
	var/stat_bonus = 0
	stat_bonus += ((owner.STACON - 10 ) * 0.05)
	stat_bonus += ((owner.STASTR - 10 ) * 0.05)
	stat_bonus += ((owner.STAWIL - 10 ) * 0.05)
	if(stat_bonus > 0)
		healing_on_tick += stat_bonus
		blood_healing_on_tick += (stat_bonus * 10)
	var/filter = owner.get_filter(COCOON_FILTER)
	if (!filter)
		owner.add_filter(COCOON_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))
	return TRUE

/datum/status_effect/buff/healing/spider_cocoon/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = "#4e4c4c00"
	var/list/wCount = owner.get_wounds()
	if(!owner.construct)
		if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
			//Keeps the user alive
			owner.blood_volume = min(owner.blood_volume+blood_healing_on_tick, BLOOD_VOLUME_NORMAL)
		if(wCount.len > 0)
			owner.heal_wounds(healing_on_tick)
			owner.update_damage_overlays()
		owner.adjustBruteLoss(-healing_on_tick, 0)
		owner.adjustFireLoss(-healing_on_tick, 0)
		owner.adjustOxyLoss(-healing_on_tick * 5, 0)
		owner.adjustToxLoss(-healing_on_tick, 0)
		owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
		owner.adjustCloneLoss(-healing_on_tick, 0)

#undef COCOON_FILTER
