/obj/effect/proc_holder/spell/invoked/song/rejuvenation_song
	name = "Healing Hymn"
	desc = "Recuperate your allies bodies with your song! Refills health slowly over time!"
	song_tier = 3
	invocations = list("Broken bones mend, flesh knits, to the hymn!") 
	invocation_type = "shout"
	overlay_state = "melody_t3_base"
	action_icon_state = "melody_t3_base"
	song_effect = /datum/status_effect/buff/playing_melody/rejuvenation

/datum/status_effect/buff/playing_melody/rejuvenation
	effect = /obj/effect/temp_visual/songs/inspiration_melodyt3
	buff_to_apply = /datum/status_effect/buff/healing/rejuvenationsong
	
/datum/status_effect/buff/healing/rejuvenationsong
	id = "healingrejuvesong"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing
	duration = 15 SECONDS
	healing_on_tick = 0.2
	outline_colour = "#c92f2f"

/datum/status_effect/buff/healing/rejuvenationsong/on_apply()
	healing_on_tick = max(owner.get_skill_level(/datum/skill/misc/music)*0.1, 0.6)
	return TRUE

/datum/status_effect/buff/healing/rejuvenationsong/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = "#660759"
	var/list/wCount = owner.get_wounds()
	if(!owner.construct)
		if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
			owner.blood_volume = min(owner.blood_volume + (healing_on_tick + 1), BLOOD_VOLUME_NORMAL)
		if(wCount.len > 0)
			owner.heal_wounds(healing_on_tick, list(/datum/wound/slash, /datum/wound/puncture, /datum/wound/bite, /datum/wound/bruise))
			owner.update_damage_overlays()
		owner.adjustBruteLoss(-healing_on_tick, 0)
		owner.adjustFireLoss(-healing_on_tick, 0)
		owner.adjustOxyLoss(-healing_on_tick, 0)
		owner.adjustToxLoss(-healing_on_tick, 0)
		owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
		owner.adjustCloneLoss(-healing_on_tick, 0)
