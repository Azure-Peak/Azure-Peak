/datum/status_effect/buff
	status_type = STATUS_EFFECT_REFRESH


/datum/status_effect/buff/drunk
	id = "drunk"
	alert_type = /atom/movable/screen/alert/status_effect/buff/drunk
	effectedstats = list(STATKEY_INT = -2, STATKEY_WIL = 1)
	duration = 5 MINUTES

/atom/movable/screen/alert/status_effect/buff/drunk
	name = "Drunk"
	desc = ""
	icon_state = "drunk"

/atom/movable/screen/alert/status_effect/buff/drunkmurk
	name = "Murk-Knowledge"
	desc = ""
	icon_state = "drunk"

/atom/movable/screen/alert/status_effect/buff/drunknoc
	name = "Noc-Shine Strength"
	desc = ""
	icon_state = "drunk"

/datum/status_effect/buff/murkwine
	id = "murkwine"
	alert_type = /atom/movable/screen/alert/status_effect/buff/drunkmurk
	effectedstats = list(STATKEY_INT = 5)
	duration = 2 MINUTES

/datum/status_effect/buff/nocshine
	id = "nocshine"
	alert_type = /atom/movable/screen/alert/status_effect/buff/drunknoc
	effectedstats = list(STATKEY_STR = 1, STATKEY_WIL = 1)
	duration = 2 MINUTES

/datum/status_effect/buff/snackbuff
	id = "snack"
	alert_type = /atom/movable/screen/alert/status_effect/buff/snackbuff
	effectedstats = list(STATKEY_WIL = 1)
	duration = 8 MINUTES

/atom/movable/screen/alert/status_effect/buff/snackbuff
	name = "Good snack"
	desc = "Better than plain bread. Tasty."
	icon_state = "foodbuff"

/datum/status_effect/buff/snackbuff/on_apply() //can't stack two snack buffs, it'll keep the highest one
	. = ..()
	owner.add_stress(/datum/stressevent/goodsnack)
	if(owner.has_status_effect(/datum/status_effect/buff/greatsnackbuff))
		owner.remove_status_effect(/datum/status_effect/buff/snackbuff)


/datum/status_effect/buff/greatsnackbuff
	id = "greatsnack"
	alert_type = /atom/movable/screen/alert/status_effect/buff/greatsnackbuff
	effectedstats = list(STATKEY_CON = 1,STATKEY_WIL = 1)
	duration = 10 MINUTES

/atom/movable/screen/alert/status_effect/buff/greatsnackbuff
	name = "Great Snack!"
	desc = "Nothing like a great and nutritious snack to help you on that final strech. I feel invigorated."
	icon_state = "foodbuff"

/datum/status_effect/buff/greatsnackbuff/on_apply()
	. = ..()
	owner.add_stress(/datum/stressevent/greatsnack)
	if(owner.has_status_effect(/datum/status_effect/buff/snackbuff)) //most of the time you technically shouldn't need to check this, but otherwise you get runtimes, so keep it
		owner.remove_status_effect(/datum/status_effect/buff/snackbuff)

/datum/status_effect/buff/mealbuff
	id = "meal"
	alert_type = /atom/movable/screen/alert/status_effect/buff/mealbuff
	effectedstats = list(STATKEY_CON = 1)
	duration = 30 MINUTES

/atom/movable/screen/alert/status_effect/buff/mealbuff
	name = "Good meal"
	desc = "A meal a day keeps the barber away, or at least it makes it slighly easier."
	icon_state = "foodbuff"

/datum/status_effect/buff/mealbuff/on_apply()
	. = ..()
	owner.add_stress(/datum/stressevent/goodmeal)
	if(owner.has_status_effect(/datum/status_effect/buff/greatmealbuff))
		owner.remove_status_effect(/datum/status_effect/buff/mealbuff)

/datum/status_effect/buff/greatmealbuff
	id = "greatmeal"
	alert_type = /atom/movable/screen/alert/status_effect/buff/greatmealbuff
	effectedstats = list(STATKEY_CON = 1, STATKEY_WIL = 1)
	duration = 30 MINUTES

/atom/movable/screen/alert/status_effect/buff/greatmealbuff
	name = "Great meal!"
	desc = "That meal was something akin to a noble's feast! It's bound to keep me energized for an entire day."
	icon_state = "foodbuff"

/datum/status_effect/buff/greatmealbuff/on_apply()
	. = ..()
	owner.add_stress(/datum/stressevent/greatmeal)
	if(owner.has_status_effect(/datum/status_effect/buff/mealbuff))
		owner.remove_status_effect(/datum/status_effect/buff/mealbuff) //can't stack two meal buffs, it'll keep the highest one

/datum/status_effect/buff/sweet
	id = "sugar"
	alert_type = /atom/movable/screen/alert/status_effect/buff/sweet
	effectedstats = list(STATKEY_LCK = 1)
	duration = 8 MINUTES

/atom/movable/screen/alert/status_effect/buff/sweet
	name = "Sweet embrace"
	desc = "Sweets are always a sign of good luck, everything goes well when you eat some of them."
	icon_state = "foodbuff"

/datum/status_effect/buff/sweet/on_apply()
	. = ..()
	owner.add_stress(/datum/stressevent/sweet)

/datum/status_effect/buff/druqks
	id = "druqks"
	alert_type = /atom/movable/screen/alert/status_effect/buff/druqks
	effectedstats = list(STATKEY_INT = 5,STATKEY_SPD = 3,STATKEY_LCK = -5)
	duration = 2 MINUTES

/datum/status_effect/buff/druqks/baotha

/datum/status_effect/buff/druqks/baotha/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_CRACKHEAD, TRAIT_MIRACLE)

/datum/status_effect/buff/druqks/baotha/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_CRACKHEAD, TRAIT_MIRACLE)
	owner.visible_message("[owner]'s eyes appear to return to normal.")

/datum/status_effect/buff/druqks/on_apply()
	. = ..()
	if(owner?.client)
		if(owner.client.screen && owner.client.screen.len)
			var/atom/movable/screen/plane_master/game_world/PM = locate(/atom/movable/screen/plane_master/game_world) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_fov_hidden) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_above) in owner.client.screen
			PM.backdrop(owner)
			owner.add_stress(/datum/stressevent/high)

/datum/status_effect/buff/druqks/on_remove()
	if(owner?.client)
		if(owner.client.screen && owner.client.screen.len)
			var/atom/movable/screen/plane_master/game_world/PM = locate(/atom/movable/screen/plane_master/game_world) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_fov_hidden) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_above) in owner.client.screen
			PM.backdrop(owner)
			owner.remove_stress(/datum/stressevent/high)

	. = ..()

/atom/movable/screen/alert/status_effect/buff/druqks
	name = "High"
	desc = ""
	icon_state = "acid"

/datum/status_effect/buff/ozium
	id = "ozium"
	alert_type = /atom/movable/screen/alert/status_effect/buff/druqks
	effectedstats = list(STATKEY_SPD = -5, STATKEY_PER = 2)
	duration = 30 SECONDS

/datum/status_effect/buff/ozium/on_apply()
	. = ..()
	owner.add_stress(/datum/stressevent/ozium)
	ADD_TRAIT(owner, TRAIT_NOPAIN, id)

/datum/status_effect/buff/ozium/on_remove()
	owner.remove_stress(/datum/stressevent/ozium)
	REMOVE_TRAIT(owner, TRAIT_NOPAIN, id)
	. = ..()

/datum/status_effect/buff/moondust
	id = "moondust"
	alert_type = /atom/movable/screen/alert/status_effect/buff/druqks
	effectedstats = list(STATKEY_SPD = 2, STATKEY_WIL = 2, STATKEY_INT = -2)
	duration = 30 SECONDS

/datum/status_effect/buff/moondust/nextmove_modifier()
	return 0.8

/datum/status_effect/buff/moondust/on_apply()
	. = ..()
	owner.add_stress(/datum/stressevent/moondust)

/datum/status_effect/buff/moondust_purest
	id = "purest moondust"
	alert_type = /atom/movable/screen/alert/status_effect/buff/druqks
	effectedstats = list(STATKEY_SPD = 3, STATKEY_WIL = 3, STATKEY_INT = -2)
	duration = 40 SECONDS

/datum/status_effect/buff/moondust_purest/nextmove_modifier()
	return 0.8

/datum/status_effect/buff/moondust_purest/on_apply()
	. = ..()
	owner.add_stress(/datum/stressevent/moondust_purest)

/datum/status_effect/buff/herozium
	id = "herozium"
	alert_type = /atom/movable/screen/alert/status_effect/buff/druqks
	effectedstats = list(STATKEY_SPD = -5, STATKEY_WIL = 4, STATKEY_INT = -3, STATKEY_CON = 3)
	duration = 80 SECONDS
	var/originalcmode = ""

/datum/status_effect/buff/herozium/nextmove_modifier()
	return 1.2

/datum/status_effect/buff/herozium/on_apply()
	. = ..()
	owner.add_stress(/datum/stressevent/ozium)
	ADD_TRAIT(owner, TRAIT_NOPAIN, id)
	ADD_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE, id)
	originalcmode = owner.cmode_music
	owner.cmode_music = 'sound/music/combat_ozium.ogg'

/datum/status_effect/buff/herozium/on_remove()
	owner.remove_stress(/datum/stressevent/ozium)
	REMOVE_TRAIT(owner, TRAIT_NOPAIN, id)
	REMOVE_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE, id)
	owner.cmode_music = originalcmode
	. = ..()

/datum/status_effect/buff/starsugar
	id = "starsugar"
	alert_type = /atom/movable/screen/alert/status_effect/buff/druqks
	effectedstats = list(STATKEY_SPD = 4, STATKEY_WIL = 4, STATKEY_INT = -3, STATKEY_CON = -3)
	duration = 80 SECONDS
	var/originalcmode = ""

/datum/status_effect/buff/starsugar/nextmove_modifier()
	return 0.7

/datum/status_effect/buff/starsugar/on_apply()
	. = ..()
	owner.add_stress(/datum/stressevent/starsugar)
	ADD_TRAIT(owner, TRAIT_DODGEEXPERT, id)
	ADD_TRAIT(owner, TRAIT_DARKVISION, id)
	if(owner.has_status_effect(/datum/status_effect/debuff/sleepytime))
		owner.remove_status_effect(/datum/status_effect/debuff/sleepytime)
	originalcmode = owner.cmode_music
	owner.cmode_music = 'sound/music/combat_starsugar.ogg'


/datum/status_effect/buff/starsugar/on_remove()
	REMOVE_TRAIT(owner, TRAIT_DODGEEXPERT, id)
	REMOVE_TRAIT(owner, TRAIT_DARKVISION, id)
	owner.remove_stress(/datum/stressevent/starsugar)
	owner.cmode_music = originalcmode
	. = ..()

/datum/status_effect/buff/weed
	id = "weed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/weed
	effectedstats = list(STATKEY_INT = 2,STATKEY_SPD = -2,STATKEY_LCK = 2)
	duration = 10 SECONDS

/datum/status_effect/buff/weed/on_apply()
	. = ..()
	owner.add_stress(/datum/stressevent/weed)
	if(owner?.client)
		if(owner.client.screen && owner.client.screen.len)
			var/atom/movable/screen/plane_master/game_world/PM = locate(/atom/movable/screen/plane_master/game_world) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_fov_hidden) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_above) in owner.client.screen
			PM.backdrop(owner)

/datum/status_effect/buff/weed/on_remove()
	if(owner?.client)
		if(owner.client.screen && owner.client.screen.len)
			var/atom/movable/screen/plane_master/game_world/PM = locate(/atom/movable/screen/plane_master/game_world) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_fov_hidden) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_above) in owner.client.screen
			PM.backdrop(owner)

	. = ..()

/atom/movable/screen/alert/status_effect/buff/weed
	name = "Dazed"
	desc = ""
	icon_state = "weed"

/datum/status_effect/buff/vitae
	id = "druqks"
	alert_type = /atom/movable/screen/alert/status_effect/buff/vitae
	effectedstats = list(STATKEY_LCK = 2)
	duration = 1 MINUTES

/datum/status_effect/buff/vitae/on_apply()
	. = ..()
	owner.add_stress(/datum/stressevent/high)
	SEND_SIGNAL(owner, COMSIG_LUX_TASTED)

/datum/status_effect/buff/vitae/on_remove()
	owner.remove_stress(/datum/stressevent/high)

	. = ..()

/datum/status_effect/buff/fermented_crab
	id = "fermented_crab"
	alert_type = /atom/movable/screen/alert/status_effect/buff/fermented_crab
	effectedstats = list(STATKEY_WIL = 2, STATKEY_CON = -2)
	duration = 5 MINUTES
	/// TRUE if the user had TRAIT_LIMPDICK and we have to reapply if after the trait expires
	var/had_limpdick = FALSE
	/// TRUE if the user had disfunctional pintle and we have to make it disfunctional again on trait expiration
	var/had_disfunctional_pintle = FALSE

/datum/status_effect/buff/fermented_crab/on_apply()
	. = ..()
	if(HAS_TRAIT(owner, TRAIT_LIMPDICK))
		REMOVE_TRAIT(owner, TRAIT_LIMPDICK, TRAIT_GENERIC)
		had_limpdick = TRUE

	var/obj/item/organ/penis/pintle = owner.getorganslot(ORGAN_SLOT_PENIS)
	if(!pintle.functional)
		pintle.functional = TRUE
		had_disfunctional_pintle = TRUE

	var/datum/component/arousal/arousal_comp = owner?.GetComponent(/datum/component/arousal)
	if(arousal_comp)
		arousal_comp.set_charge(SEX_MAX_CHARGE)  // Fully restore charge

/datum/status_effect/buff/fermented_crab/on_remove()
	. = ..()
	if(had_limpdick)
		ADD_TRAIT(owner, TRAIT_LIMPDICK, TRAIT_GENERIC)
	if(had_disfunctional_pintle)
		var/obj/item/organ/penis/pintle = owner.getorganslot(ORGAN_SLOT_PENIS)
		pintle.functional = FALSE

/atom/movable/screen/alert/status_effect/buff/fermented_crab
	name = "INVIGORATED"
	desc = "Fermented crab tasted like shit. But I'm full of vigor now!"

/atom/movable/screen/alert/status_effect/buff/vitae
	name = "Invigorated"
	desc = "I have supped on the finest of delicacies: life!"

/atom/movable/screen/alert/status_effect/buff/featherfall
	name = "Featherfall"
	desc = "I am somewhat protected against falling from heights."
	icon_state = "buff"

/datum/status_effect/buff/featherfall
	id = "featherfall"
	alert_type = /atom/movable/screen/alert/status_effect/buff/featherfall
	duration = 1 MINUTES

/datum/status_effect/buff/featherfall/on_apply()
	. = ..()
	to_chat(owner, span_warning("I feel lighter."))
	ADD_TRAIT(owner, TRAIT_NOFALLDAMAGE2, MAGIC_TRAIT)

/datum/status_effect/buff/featherfall/on_remove()
	. = ..()
	to_chat(owner, span_warning("The feeling of lightness fades."))
	REMOVE_TRAIT(owner, TRAIT_NOFALLDAMAGE2, MAGIC_TRAIT)

/atom/movable/screen/alert/status_effect/buff/darkvision
	name = "Darkvision"
	desc = "I can see in the dark somewhat."
	icon_state = "buff"

/datum/status_effect/buff/darkvision
	id = "darkvision"
	alert_type = /atom/movable/screen/alert/status_effect/buff/darkvision
	duration = 15 MINUTES

/datum/status_effect/buff/darkvision/on_apply(mob/living/new_owner, assocskill)
	if(assocskill)
		duration += 5 MINUTES * assocskill
	. = ..()
	to_chat(owner, span_warning("The darkness fades somewhat."))
	ADD_TRAIT(owner, TRAIT_DARKVISION, MAGIC_TRAIT)

/datum/status_effect/buff/darkvision/on_remove()
	. = ..()
	to_chat(owner, span_warning("The darkness returns to normal."))
	REMOVE_TRAIT(owner, TRAIT_DARKVISION, MAGIC_TRAIT)

/atom/movable/screen/alert/status_effect/buff/longstrider
	name = "Longstrider"
	desc = "I can easily walk through rough terrain."
	icon_state = "buff"

/datum/status_effect/buff/longstrider
	id = "longstrider"
	alert_type = /atom/movable/screen/alert/status_effect/buff/longstrider
	duration = 15 MINUTES

/datum/status_effect/buff/longstrider/on_apply()
	. = ..()
	to_chat(owner, span_warning("I am unburdened by the terrain."))
	ADD_TRAIT(owner, TRAIT_LONGSTRIDER, MAGIC_TRAIT)

/datum/status_effect/buff/longstrider/on_remove()
	. = ..()
	to_chat(owner, span_warning("The rough floors slow my travels once again."))
	REMOVE_TRAIT(owner, TRAIT_LONGSTRIDER, MAGIC_TRAIT)

/atom/movable/screen/alert/status_effect/buff/magearmor
	name = "Weakened Barrier"
	desc = "My magical barrier is weakened."
	icon_state = "stressvg"

/datum/status_effect/buff/magearmor
	id = "magearmor"
	alert_type = /atom/movable/screen/alert/status_effect/buff/magearmor

/datum/status_effect/buff/magearmor/on_apply()
	. = ..()
	playsound(owner, 'sound/magic/magearmordown.ogg', 75, FALSE)
	duration = (7-owner.get_skill_level(/datum/skill/magic/arcane)) MINUTES

/datum/status_effect/buff/magearmor/on_remove()
	. = ..()
	to_chat(owner, span_warning("My magical barrier reforms."))
	playsound(owner, 'sound/magic/magearmorup.ogg', 75, FALSE)
	owner.magearmor = 0

/atom/movable/screen/alert/status_effect/buff/guardbuffone
	name = "Vigilant Guardsman"
	desc = "My home. I watch vigilantly and respond swiftly."
	icon_state = "guardsman"

/atom/movable/screen/alert/status_effect/buff/barkeepbuff
	name = "Vigilant Tavernkeep"
	desc = "My home. I watch vigilantly and respond swiftly."
	icon_state = "drunk"

/atom/movable/screen/alert/status_effect/buff/knightbuff
	name = "Sworn Defender"
	desc = "I've sworn an oath to defend this castle. My resolve will not waver."
	icon_state = "guardsman"

/atom/movable/screen/alert/status_effect/buff/wardenbuff
	name = "Woodsman"
	desc = "I've trekked these woods for some time now. I find traversal easier here."
	icon_state = "guardsman"

/atom/movable/screen/alert/status_effect/buff/anthraxbuff
	name = "Apex Predator"
	desc = "These are my hunting grounds. My prey won't escape me."
	icon_state = "buff"

/datum/status_effect/buff/wardenbuff
	id = "wardenbuff"
	alert_type = /atom/movable/screen/alert/status_effect/buff/wardenbuff
	effectedstats = list(STATKEY_SPD = 1, STATKEY_PER = 3)

/datum/status_effect/buff/barkeepbuff
	id = "barkeepbuff"
	alert_type = /atom/movable/screen/alert/status_effect/buff/barkeepbuff
	effectedstats = list(STATKEY_CON = 1,STATKEY_WIL = 1, STATKEY_SPD = 1, STATKEY_STR = 3)

/datum/status_effect/buff/barkeepbuff/process()

	.=..()
	var/area/rogue/our_area = get_area(owner)
	if(!(our_area.tavern_area))
		owner.remove_status_effect(/datum/status_effect/buff/barkeepbuff)

/datum/status_effect/buff/guardbuffone
	id = "guardbuffone"
	alert_type = /atom/movable/screen/alert/status_effect/buff/guardbuffone
	effectedstats = list(STATKEY_CON = 1,STATKEY_WIL = 1, STATKEY_SPD = 1)

/datum/status_effect/buff/anthraxbuff
	id = "anthraxbuff"
	alert_type = /atom/movable/screen/alert/status_effect/buff/anthraxbuff
	effectedstats = list(STATKEY_SPD = 3,STATKEY_PER = 1)

/datum/status_effect/buff/guardbuffone/process()

	.=..()
	var/area/rogue/our_area = get_area(owner)
	if(!(our_area.town_area))
		owner.remove_status_effect(/datum/status_effect/buff/guardbuffone)

/datum/status_effect/buff/anthraxbuff/process()

	.=..()
	var/area/rogue/our_area = get_area(owner)
	if(!(our_area.drow_area))
		owner.remove_status_effect(/datum/status_effect/buff/anthraxbuff)

/datum/status_effect/buff/wardenbuff/process()

	.=..()
	var/area/rogue/our_area = get_area(owner)
	if(!(our_area.warden_area))
		owner.remove_status_effect(/datum/status_effect/buff/wardenbuff)

/datum/status_effect/buff/wardenbuff/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_LONGSTRIDER, id)

/datum/status_effect/buff/wardenbuff/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_LONGSTRIDER, id)

// Lesser Miracle effect
/atom/movable/screen/alert/status_effect/buff/healing
	name = "Healing Miracle"
	desc = "Divine intervention relieves me of my ailments."
	icon_state = "lesser_heal"

#define MIRACLE_HEALING_FILTER "miracle_heal_glow"

/datum/status_effect/buff/healing
	id = "healing"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing
	duration = 10 SECONDS
	examine_text = "SUBJECTPRONOUN is bathed in a restorative aura!"
	var/healing_on_tick = 1
	var/outline_colour = "#c42424"
	var/tech_healing_modifier = 1
	var/block_combat_mode = FALSE

/datum/status_effect/buff/healing/on_creation(mob/living/new_owner, new_healing_on_tick, is_inhumen = FALSE)
	healing_on_tick = new_healing_on_tick
	tech_healing_modifier = SSchimeric_tech.get_healing_multiplier()
	if(is_inhumen)
		// The penalty/benefit of healing tech is halved for inhumen followers
		tech_healing_modifier = 1 + ((tech_healing_modifier - 1) * 0.5)
	healing_on_tick *= tech_healing_modifier
	return ..()

/datum/status_effect/buff/healing/on_apply()
	SEND_SIGNAL(owner, COMSIG_LIVING_MIRACLE_HEAL_APPLY, healing_on_tick, src)
	var/filter = owner.get_filter(MIRACLE_HEALING_FILTER)
	if (!filter)
		owner.add_filter(MIRACLE_HEALING_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))
	return TRUE

/datum/status_effect/buff/healing/tick()
	if(block_combat_mode && owner.cmode)
		return
	if(owner.construct)
		return
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = "#FF0000"
	if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
		owner.blood_volume = min(owner.blood_volume+healing_on_tick, BLOOD_VOLUME_NORMAL)
	var/list/wCount = owner.get_wounds()
	if(length(wCount))
		owner.heal_wounds(healing_on_tick)
		owner.update_damage_overlays()
	owner.adjustBruteLoss(-healing_on_tick, 0)
	owner.adjustFireLoss(-healing_on_tick, 0)
	owner.adjustOxyLoss(-healing_on_tick, 0)
	owner.adjustToxLoss(-healing_on_tick, 0)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
	owner.adjustCloneLoss(-healing_on_tick, 0)
// Lesser miracle effect end

/atom/movable/screen/alert/status_effect/buff/healing/campfire
	name = "Camp Rest"
	desc = "The warmth of a fire and a bed soothes my ails."
	icon_state = "campfire"

/atom/movable/screen/alert/status_effect/buff/campfire_stamina
	name = "Warming Respite"
	desc = "A break by the fire restores some of my energy."
	icon_state = "campfire"


#define CAMPFIRE_BASE_FILTER "campfire_stamina"

/datum/status_effect/buff/campfire_stamina
	id = "stamina_campfire"
	alert_type = /atom/movable/screen/alert/status_effect/buff/campfire_stamina
	duration = 5 SECONDS
	examine_text = "SUBJECTPRONOUN is enjoying a brief respite."
	var/healing_on_tick = 5
	var/outline_colour = "#7e6a3e"
	var/tech_healing_modifier = 1

/datum/status_effect/buff/campfire_stamina/on_apply()
	var/filter = owner.get_filter(CAMPFIRE_BASE_FILTER)
	if (!filter)
		owner.add_filter(CAMPFIRE_BASE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))
	return TRUE

/datum/status_effect/buff/campfire_stamina/tick()
	if(owner.construct)
		return
	var/stamheal = healing_on_tick
	if(!owner.cmode)
		stamheal *= 2
	owner.energy_add(stamheal)
	owner.adjust_bodytemperature(8)

/datum/status_effect/buff/campfire_stamina/on_remove()
	owner.remove_filter(CAMPFIRE_BASE_FILTER)

/datum/status_effect/buff/campfire
	id = "healing_campfire"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing/campfire
	examine_text = null
	var/healing_on_tick = 2
	duration = 6 SECONDS

/datum/status_effect/buff/campfire/tick()
	if(owner.cmode)
		return
	if(owner.construct)
		return
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue/campfire(get_turf(owner))
	H.color = "#c7aa5c"
	if(owner.blood_volume < BLOOD_VOLUME_OKAY)
		owner.blood_volume = min(owner.blood_volume+healing_on_tick, BLOOD_VOLUME_OKAY)
	var/list/wCount = owner.get_wounds()
	if(length(wCount))
		owner.heal_wounds(healing_on_tick, list(/datum/wound/slash, /datum/wound/puncture, /datum/wound/bite, /datum/wound/bruise, /datum/wound/dynamic, /datum/wound/dislocation))
		owner.update_damage_overlays()
	owner.adjustBruteLoss(-healing_on_tick, 0)
	owner.adjustFireLoss(-healing_on_tick, 0)
	owner.adjustOxyLoss(-healing_on_tick, 0)
	owner.adjustToxLoss(-healing_on_tick, 0)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
	owner.adjustCloneLoss(-healing_on_tick, 0)

#undef CAMPFIRE_BASE_FILTER


#define BLOODHEAL_DUR_SCALE_PER_LEVEL 3 SECONDS
#define BLOODHEAL_RESTORE_DEFAULT 5
#define BLOODHEAL_RESTORE_SCALE_PER_LEVEL 2
#define BLOODHEAL_DUR_DEFAULT 10 SECONDS
// Bloodheal miracle effect
/atom/movable/screen/alert/status_effect/buff/bloodheal
	name = "Blood Miracle"
	desc = "Divine intervention is infusing me with lyfe's blood."
	icon_state = "bloodheal"

#define MIRACLE_BLOODHEAL_FILTER "miracle_bloodheal_glow"

/datum/status_effect/buff/bloodheal
	id = "bloodheal"
	alert_type = /atom/movable/screen/alert/status_effect/buff/bloodheal
	duration = BLOODHEAL_DUR_DEFAULT
	examine_text = "SUBJECTPRONOUN is bathed in a thick, pungent aura of iron!"
	var/healing_on_tick = BLOODHEAL_RESTORE_DEFAULT
	var/skill_level
	var/outline_colour = "#c42424"

/datum/status_effect/buff/bloodheal/on_creation(mob/living/new_owner, associated_skill)
	healing_on_tick = BLOODHEAL_RESTORE_DEFAULT + ((associated_skill > SKILL_LEVEL_NOVICE) ? (BLOODHEAL_RESTORE_SCALE_PER_LEVEL * associated_skill) : 0)
	skill_level = associated_skill
	duration = BLOODHEAL_DUR_DEFAULT + ((associated_skill > SKILL_LEVEL_NOVICE) ? (BLOODHEAL_DUR_SCALE_PER_LEVEL * associated_skill) : 0)
	return ..()

/datum/status_effect/buff/bloodheal/on_apply()
	var/filter = owner.get_filter(MIRACLE_BLOODHEAL_FILTER)
	if (!filter)
		owner.add_filter(MIRACLE_BLOODHEAL_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))
	return TRUE

/datum/status_effect/buff/bloodheal/on_remove()
	. = ..()
	owner.remove_filter(MIRACLE_BLOODHEAL_FILTER)

/datum/status_effect/buff/bloodheal/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_blood(get_turf(owner))
	H.color = "#FF0000"
	if(!owner.construct)
		if(skill_level >= SKILL_LEVEL_JOURNEYMAN)
			if(owner.blood_volume < BLOOD_VOLUME_SURVIVE)
				owner.blood_volume = BLOOD_VOLUME_SURVIVE
		if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
			owner.blood_volume = min(owner.blood_volume + healing_on_tick, BLOOD_VOLUME_NORMAL)

#undef BLOODHEAL_DUR_SCALE_PER_LEVEL
#undef BLOODHEAL_RESTORE_DEFAULT
#undef BLOODHEAL_RESTORE_SCALE_PER_LEVEL
#undef BLOODHEAL_DUR_DEFAULT
// Bloodheal miracle effect end

// Necra's Vow healing effect
/datum/status_effect/buff/healing/necras_vow
	id = "healing"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing
	duration = -1
	healing_on_tick = 3
	outline_colour = "#bbbbbb"

/datum/status_effect/buff/healing/necras_vow/on_apply()
	healing_on_tick = max(owner.get_skill_level(/datum/skill/magic/holy), 3)
	return TRUE

/datum/status_effect/buff/healing/necras_vow/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = "#a5a5a5"
	var/list/wCount = owner.get_wounds()
	if(!owner.construct)
		if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
			owner.blood_volume = min(owner.blood_volume + (healing_on_tick + 10), BLOOD_VOLUME_NORMAL)
		if(wCount.len > 0)
			owner.heal_wounds(healing_on_tick, list(/datum/wound/slash, /datum/wound/puncture, /datum/wound/bite, /datum/wound/bruise, /datum/wound/dynamic))
			owner.update_damage_overlays()
		owner.adjustBruteLoss(-healing_on_tick, 0)
		owner.adjustFireLoss(-healing_on_tick, 0)
		owner.adjustOxyLoss(-healing_on_tick, 0)
		owner.adjustToxLoss(-healing_on_tick, 0)
		owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
		owner.adjustCloneLoss(-healing_on_tick, 0)

/atom/movable/screen/alert/status_effect/buff/psyhealing
	name = "Enduring"
	desc = "I am awash with sentimentality."
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/buff/psyvived
	name = "Absolved"
	desc = "I feel a strange sense of peace."
	icon_state = "buff"

#define PSYDON_HEALING_FILTER "psydon_heal_glow"
#define PSYDON_REVIVED_FILTER "psydon_revival_glow"

/datum/status_effect/buff/psyhealing
	id = "psyhealing"
	alert_type = /atom/movable/screen/alert/status_effect/buff/psyhealing
	duration = 15 SECONDS
	examine_text = "SUBJECTPRONOUN stirs with a sense of ENDURING!"
	var/healing_on_tick = 1
	var/outline_colour = "#d3d3d3"

/datum/status_effect/buff/psyhealing/on_creation(mob/living/new_owner, new_healing_on_tick)
	healing_on_tick = new_healing_on_tick
	return ..()

/datum/status_effect/buff/psyhealing/on_apply()
	SEND_SIGNAL(owner, COMSIG_LIVING_MIRACLE_HEAL_APPLY, healing_on_tick, src)
	var/filter = owner.get_filter(PSYDON_HEALING_FILTER)
	if (!filter)
		owner.add_filter(PSYDON_HEALING_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))
	return TRUE

/datum/status_effect/buff/psyhealing/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/psyheal_rogue(get_turf(owner))
	H.color = "#d3d3d3"
	var/list/wCount = owner.get_wounds()
	if(!owner.construct)
		if(wCount.len > 0)
			owner.heal_wounds(healing_on_tick * 1.75)
			owner.update_damage_overlays()
		owner.adjustOxyLoss(-healing_on_tick, 0)
		owner.adjustToxLoss(-healing_on_tick, 0)
		owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
		owner.adjustCloneLoss(-healing_on_tick, 0)

/datum/status_effect/buff/psyvived
	id = "psyvived"
	alert_type = /atom/movable/screen/alert/status_effect/buff/psyvived
	duration = 30 SECONDS
	examine_text = "SUBJECTPRONOUN moves with an air of ABSOLUTION!"
	var/outline_colour = "#aa1717"

/datum/status_effect/buff/psyvived/on_creation(mob/living/new_owner)
	return ..()

/datum/status_effect/buff/psyvived/on_apply()
	var/filter = owner.get_filter(PSYDON_REVIVED_FILTER)
	if (!filter)
		owner.add_filter(PSYDON_REVIVED_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))
	return TRUE

/datum/status_effect/buff/psyvived/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/psyheal_rogue(get_turf(owner))
	H.color = "#aa1717"

/datum/status_effect/buff/rockmuncher
	id = "rockmuncher"
	duration = 10 SECONDS
	var/healing_on_tick = 4

/datum/status_effect/buff/rockmuncher/on_creation(mob/living/new_owner, new_healing_on_tick)
	healing_on_tick = new_healing_on_tick
	return ..()

/datum/status_effect/buff/rockmuncher/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = "#FF0000"
	var/list/wCount = owner.get_wounds()
	if(owner.construct)
		if(wCount.len > 0)
			owner.heal_wounds(healing_on_tick)
			owner.update_damage_overlays()
		owner.adjustBruteLoss(0.15*-healing_on_tick, 0)
		owner.adjustFireLoss(0.15*-healing_on_tick, 0)
		owner.adjustOxyLoss(0.15*-healing_on_tick, 0)
		owner.adjustToxLoss(0.15*-healing_on_tick, 0)
		owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.15*-healing_on_tick)
		owner.adjustCloneLoss(0.15*-healing_on_tick, 0)

/datum/status_effect/buff/healing/on_remove()
	owner.remove_filter(MIRACLE_HEALING_FILTER)
	owner.update_damage_hud()

/datum/status_effect/buff/psyhealing/on_remove()
	owner.remove_filter(PSYDON_HEALING_FILTER)
	owner.update_damage_hud()

/datum/status_effect/buff/psyvived/on_remove()
	owner.remove_filter(PSYDON_REVIVED_FILTER)
	owner.update_damage_hud()

/atom/movable/screen/alert/status_effect/buff/fortify
	name = "Fortifying Miracle"
	desc = "Divine intervention bolsters me and aids my recovery."
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/buff/convergence
	name = "Convergence Miracle"
	desc = "My body converges to whence it found strength and health."
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/buff/stasis
	name = "Stasis Miracle"
	desc = "A part of me has been put in stasis."
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/buff/censerbuff
	name = "Inspired by SYON."
	desc = "The shard of the great comet had inspired me to ENDURE."
	icon_state = "censerbuff"

/datum/status_effect/buff/fortify //Increases all healing while it lasts.
	id = "fortify"
	alert_type = /atom/movable/screen/alert/status_effect/buff/fortify
	duration = 1 MINUTES

/datum/status_effect/buff/censerbuff
	id = "censer"
	alert_type = /atom/movable/screen/alert/status_effect/buff/censerbuff
	duration = 15 MINUTES
	effectedstats = list(STATKEY_WIL = 1, STATKEY_CON = 1)

/datum/status_effect/buff/convergence //Increases all healing while it lasts.
	id = "convergence"
	alert_type = /atom/movable/screen/alert/status_effect/buff/convergence
	duration = 1 MINUTES

/datum/status_effect/buff/stasis //Increases all healing while it lasts.
	id = "stasis"
	alert_type = /atom/movable/screen/alert/status_effect/buff/stasis
	duration = 10 SECONDS

#define CRANKBOX_FILTER "crankboxbuff_glow"
/atom/movable/screen/alert/status_effect/buff/churnerprotection
	name = "Magick Distorted"
	desc = "The wailing box is disrupting magicks around me!"
	icon_state = "buff"
/atom/movable/screen/alert/status_effect/buff/churnernegative
	name = "Magick Distorted"
	desc = "That infernal contraption is sapping my very arcyne essence!"
	icon_state = "buff"

/datum/status_effect/buff/churnerprotection
	var/outline_colour = "#fad55a"
	id = "soulchurnerprotection"
	alert_type = /atom/movable/screen/alert/status_effect/buff/churnerprotection
	duration = 20 SECONDS

/datum/status_effect/buff/churnerprotection/on_apply()
	. = ..()
	var/filter = owner.get_filter(CRANKBOX_FILTER)
	if (!filter)
		owner.add_filter(CRANKBOX_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 200, "size" = 1))
	to_chat(owner, span_warning("I feel the wailing box distorting magicks around me!"))
	ADD_TRAIT(owner, TRAIT_ANTIMAGIC, MAGIC_TRAIT)

/datum/status_effect/buff/churnerprotection/on_remove()
	. = ..()
	to_chat(owner, span_warning("The wailing box's protection fades..."))
	owner.remove_filter(CRANKBOX_FILTER)
	REMOVE_TRAIT(owner, TRAIT_ANTIMAGIC, MAGIC_TRAIT)

#undef CRANKBOX_FILTER
#undef MIRACLE_HEALING_FILTER

/datum/status_effect/buff/churnernegative
	id ="soulchurnernegative"
	alert_type = /atom/movable/screen/alert/status_effect/buff/churnernegative
	duration = 23 SECONDS

/datum/status_effect/buff/churnernegative/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_SPELLCOCKBLOCK, MAGIC_TRAIT)
	ADD_TRAIT(owner, TRAIT_ANTIMAGIC, MAGIC_TRAIT)
	to_chat(owner, span_warning("I feel as if my connection to the Arcyne disappears entirely. The air feels still..."))
	owner.visible_message("[owner]'s arcyne aura seems to fade.")

/datum/status_effect/buff/churnernegative/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_SPELLCOCKBLOCK, MAGIC_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_ANTIMAGIC, MAGIC_TRAIT)
	to_chat(owner, span_warning("I feel my connection to the arcyne surround me once more."))
	owner.visible_message("[owner]'s arcyne aura seems to return once more.")

#define BLESSINGOFSUN_FILTER "sun_glow"
/atom/movable/screen/alert/status_effect/buff/guidinglight
	name = "Guiding Light"
	desc = "Astrata's gaze follows me, lighting the path!"
	icon_state = "stressvg"

/datum/status_effect/buff/guidinglight // Hey did u follow us from ritualcircles? Cool, okay this stuff is pretty simple yeah? Most ritual circles use some sort of status effects to get their effects ez.
	id = "guidinglight"
	alert_type = /atom/movable/screen/alert/status_effect/buff/guidinglight
	duration = 30 MINUTES // Lasts for 30 minutes, roughly an ingame day. This should be the gold standard for rituals, unless its some particularly powerul effect or one-time effect(Flylord's triage)
	status_type = STATUS_EFFECT_REFRESH
	effectedstats = list(STATKEY_PER = 2) // This is for basic stat effects, I would consider these a 'little topping' and not what you should rlly aim for for rituals. Ideally we have cool flavor boons, rather than combat stims.
	examine_text = "SUBJECTPRONOUN walks with Her Light!"
	var/list/mobs_affected
	var/obj/effect/dummy/lighting_obj/moblight/mob_light_obj
	var/outline_colour = "#ffffff"

/datum/status_effect/buff/guidinglight/on_apply()
	. = ..()
	if (!.)
		return
	to_chat(owner, span_notice("Light blossoms into being around me!"))
	var/filter = owner.get_filter(BLESSINGOFSUN_FILTER)
	if (!filter)
		owner.add_filter(BLESSINGOFSUN_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))
	mob_light_obj = owner.mob_light("#fdfbd3", 10, 10)
	return TRUE


/datum/status_effect/buff/guidinglight/on_remove()
	. = ..()
	playsound(owner, 'sound/items/firesnuff.ogg', 75, FALSE)
	to_chat(owner, span_notice("The miraculous light surrounding me has fled..."))
	owner.remove_filter(BLESSINGOFSUN_FILTER)
	QDEL_NULL(mob_light_obj)

#undef BLESSINGOFSUN_FILTER
/datum/status_effect/buff/moonlightdance
	id = "Moonsight"
	alert_type = /atom/movable/screen/alert/status_effect/buff/moonlightdance
	effectedstats = list(STATKEY_INT = 2)
	duration = 25 MINUTES

/atom/movable/screen/alert/status_effect/buff/moonlightdance
	name = "Moonlight Dance"
	desc = "Noc's stony touch lay upon my mind, bringing me wisdom."
	icon_state = "moonlightdance"


/datum/status_effect/buff/moonlightdance/on_apply()
	. = ..()
	to_chat(owner, span_warning("I see through the Moonlight. Silvery threads dance in my vision."))
	ADD_TRAIT(owner, TRAIT_DARKVISION, MAGIC_TRAIT)


/datum/status_effect/buff/moonlightdance/on_remove()
	. = ..()
	to_chat(owner, span_warning("Noc's silver leaves my"))
	REMOVE_TRAIT(owner, TRAIT_DARKVISION, MAGIC_TRAIT)




/atom/movable/screen/alert/status_effect/buff/flylordstriage
	name = "Flylord's Triage"
	desc = "Pestra's servants crawl through my pores and wounds!"
	icon_state = "buff"

/datum/status_effect/buff/flylordstriage
	id = "healing"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing
	duration = 20 SECONDS
	var/healing_on_tick = 40

/datum/status_effect/buff/flylordstriage/tick()
	playsound(owner, 'sound/misc/fliesloop.ogg', 100, FALSE, -1)
	owner.flash_fullscreen("redflash3")
	owner.emote("agony")
	new /obj/effect/temp_visual/flies(get_turf(owner))
	var/list/wCount = owner.get_wounds()
	if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
		owner.blood_volume = min(owner.blood_volume+100, BLOOD_VOLUME_NORMAL)
	if(wCount.len > 0)
		owner.heal_wounds(healing_on_tick)
		owner.update_damage_overlays()
	owner.adjustBruteLoss(-healing_on_tick, 0)
	owner.adjustFireLoss(-healing_on_tick, 0)
	owner.adjustOxyLoss(-healing_on_tick, 0)
	owner.adjustToxLoss(-healing_on_tick, 0)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
	owner.adjustCloneLoss(-healing_on_tick, 0)

/obj/effect/temp_visual/flies
	name = "Flylord's triage"
	icon_state = "flies"
	duration = 15
	plane = GAME_PLANE_UPPER
	layer = ABOVE_ALL_MOB_LAYER
	icon = 'icons/roguetown/mob/rotten.dmi'
	icon_state = "rotten"


/datum/status_effect/buff/flylordstriage/on_remove()
	to_chat(owner,span_userdanger("It's finally over..."))



/atom/movable/screen/alert/status_effect/buff/undermaidenbargain
	name = "Undermaiden's Bargain"
	desc = "A horrible deal was struck in my name..."
	icon_state = "buff"

/datum/status_effect/buff/undermaidenbargain
	id = "undermaidenbargain"
	alert_type = /atom/movable/screen/alert/status_effect/buff/undermaidenbargain
	duration = 30 MINUTES

/datum/status_effect/buff/undermaidenbargain/on_apply()
	. = ..()
	to_chat(owner, span_danger("You feel as though some horrible deal has been prepared in your name. May you never see it fulfilled..."))
	playsound(owner, 'sound/misc/bell.ogg', 100, FALSE, -1)
	ADD_TRAIT(owner, TRAIT_DEATHBARGAIN, id)

/datum/status_effect/buff/undermaidenbargain/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_DEATHBARGAIN, id)


/datum/status_effect/buff/undermaidenbargainheal/on_apply()
	. = ..()
	owner.remove_status_effect(/datum/status_effect/buff/undermaidenbargain)
	to_chat(owner, span_warning("You feel the deal struck in your name is being fulfilled..."))
	playsound(owner, 'sound/misc/deadbell.ogg', 100, FALSE, -1)
	ADD_TRAIT(owner, TRAIT_NODEATH, id)
	var/dirgeline = rand(1,6)
	spawn(15)
		switch(dirgeline)
			if(1)
				to_chat(owner, span_cultsmall("She watches the city skyline as her crimson pours into the drain."))
			if(2)
				to_chat(owner, span_cultsmall("He only wanted more for his family. He feels comfort on the pavement, the Watchman's blade having met its mark."))
			if(3)
				to_chat(owner, span_cultsmall("A sailor's leg is caught in naval rope. Their last thoughts are of home."))
			if(4)
				to_chat(owner, span_cultsmall("She sobbed over the Venardine's corpse. The Brigand's mace stemmed her tears."))
			if(5)
				to_chat(owner, span_cultsmall("A farm son chokes up his last. At his bedside, a sister and mother weep."))
			if(6)
				to_chat(owner, span_cultsmall("A woman begs at a Headstone. It is your fault."))

/datum/status_effect/buff/undermaidenbargainheal/on_remove()
	. = ..()
	to_chat(owner, span_warning("The Bargain struck in my name has been fulfilled... I am thrown from Necra's embrace, another in my place..."))
	playsound(owner, 'sound/misc/deadbell.ogg', 100, FALSE, -1)
	REMOVE_TRAIT(owner, TRAIT_NODEATH, id)

/datum/status_effect/buff/undermaidenbargainheal
	id = "undermaidenbargainheal"
	alert_type = /atom/movable/screen/alert/status_effect/buff/undermaidenbargainheal
	duration = 10 SECONDS
	var/healing_on_tick = 20

/datum/status_effect/buff/undermaidenbargainheal/tick()
	var/list/wCount = owner.get_wounds()
	if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
		owner.blood_volume = min(owner.blood_volume+60, BLOOD_VOLUME_NORMAL)
	if(wCount.len > 0)
		owner.heal_wounds(100) // we're gonna try really hard to heal someone's arterials and also stabilize their blood, so they don't instantly bleed out again. Ideally they should be 'just' alive.
		owner.update_damage_overlays()
	owner.adjustBruteLoss(-healing_on_tick, 0)
	owner.adjustFireLoss(-healing_on_tick, 0)
	owner.adjustOxyLoss(-healing_on_tick, 0)
	owner.adjustToxLoss(-healing_on_tick, 0)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
	owner.adjustCloneLoss(-healing_on_tick, 0)

/atom/movable/screen/alert/status_effect/buff/undermaidenbargainheal
	name = "The Fulfillment"
	desc = "My bargain is being fulfilled..."
	icon_state = "buff"



/atom/movable/screen/alert/status_effect/buff/lesserwolf
	name = "Blessing of the Lesser Wolf"
	desc = "I swell with the embuement of a predator..."
	icon_state = "buff"

/datum/status_effect/buff/lesserwolf
	id = "lesserwolf"
	alert_type = /atom/movable/screen/alert/status_effect/buff/lesserwolf
	duration = 30 MINUTES

/datum/status_effect/buff/lesserwolf/on_apply()
	. = ..()
	to_chat(owner, span_warning("I feel my leg muscles grow taut, my teeth sharp, I am embued with the power of a predator. Branches and brush reach out for my soul..."))
	ADD_TRAIT(owner, TRAIT_LONGSTRIDER, id)
	ADD_TRAIT(owner, TRAIT_STRONGBITE, id)

/datum/status_effect/buff/lesserwolf/on_remove()
	. = ..()
	to_chat(owner, span_warning("I feel Dendor's blessing leave my body..."))
	REMOVE_TRAIT(owner, TRAIT_LONGSTRIDER, id)
	REMOVE_TRAIT(owner, TRAIT_STRONGBITE, id)

/atom/movable/screen/alert/status_effect/buff/pacify
	name = "Blessing of Eora"
	desc = "I feel my heart as light as feathers. All my worries have washed away."
	icon_state = "buff"

/datum/status_effect/buff/pacify
	id = "pacify"
	alert_type = /atom/movable/screen/alert/status_effect/buff/pacify
	duration = 30 MINUTES

/datum/status_effect/buff/pacify/on_apply()
	. = ..()
	to_chat(owner, span_green("Everything feels great!"))
	owner.add_stress(/datum/stressevent/pacified)
	ADD_TRAIT(owner, TRAIT_PACIFISM, id)
	playsound(owner, 'sound/misc/peacefulwake.ogg', 100, FALSE, -1)

/datum/status_effect/buff/pacify/on_remove()
	. = ..()
	to_chat(owner, span_warning("My mind is my own again, no longer awash with foggy peace!"))
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, id)

//A lesser variant of Eoran blessing meant for peacecake consumption.
/atom/movable/screen/alert/status_effect/buff/peacecake
	name = "Lesser blessing of Eora"
	desc = "I feel my heart lighten. All my worries ease away."
	icon_state = "buff"

/datum/status_effect/buff/peacecake
	id = "peacecake"
	alert_type = /atom/movable/screen/alert/status_effect/buff/peacecake
	duration = 5 MINUTES

/datum/status_effect/buff/peacecake/on_apply()
	. = ..()
	to_chat(owner, span_green("Everything feels better."))
	owner.add_stress(/datum/stressevent/pacified)
	ADD_TRAIT(owner, TRAIT_PACIFISM, id)
	playsound(owner, 'sound/misc/peacefulwake.ogg', 100, FALSE, -1)

/datum/status_effect/buff/peacecake/on_remove()
	. = ..()
	to_chat(owner, span_warning("My mind is clear again, no longer clouded with foggy peace!"))
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, id)

/datum/status_effect/buff/call_to_arms
	id = "call_to_arms"
	alert_type = /atom/movable/screen/alert/status_effect/buff/call_to_arms
	duration = 2.5 MINUTES
	effectedstats = list(STATKEY_STR = 1, STATKEY_WIL = 2, STATKEY_CON = 1)

/atom/movable/screen/alert/status_effect/buff/call_to_arms
	name = "Call to Arms"
	desc = span_bloody("FOR GLORY AND HONOR!")
	icon_state = "call_to_arms"

/datum/status_effect/buff/call_to_slaughter
	id = "call_to_slaughter"
	alert_type = /atom/movable/screen/alert/status_effect/buff/call_to_slaughter
	duration = 2.5 MINUTES
	effectedstats = list(STATKEY_STR = 1, STATKEY_WIL = 2, STATKEY_CON = 1)

/atom/movable/screen/alert/status_effect/buff/call_to_slaughter
	name = "Call to Slaughter"
	desc = span_bloody("LAMBS TO THE SLAUGHTER!")
	icon_state = "call_to_slaughter"

/atom/movable/screen/alert/status_effect/buff/xylix_joy
	name = "Trickster's Joy"
	desc = "The sound of merriment fills me with fortune."
	icon_state = "joy"

/datum/status_effect/buff/xylix_joy
	id = "xylix_joy"
	alert_type = /atom/movable/screen/alert/status_effect/buff/xylix_joy
	effectedstats = list(STATKEY_LCK = 1)
	duration = 5 MINUTES
	status_type = STATUS_EFFECT_REFRESH

/datum/status_effect/buff/xylix_joy/on_apply()
	. = ..()
	to_chat(owner, span_info("The sounds of joy fill me with fortune!"))

/datum/status_effect/buff/xylix_joy/on_remove()
	. = ..()
	to_chat(owner, span_info("My fortune returns to normal."))

/datum/status_effect/buff/vigorized
	id = "vigorized"
	alert_type = /atom/movable/screen/alert/status_effect/vigorized
	duration = 10 MINUTES
	effectedstats = list(STATKEY_SPD = 1, STATKEY_INT = 1)

/atom/movable/screen/alert/status_effect/vigorized
	name = "Vigorized"
	desc = "I feel a surge of energy inside, quickening my speed and sharpening my focus."
	icon_state = "drunk"

/datum/status_effect/buff/vigorized/on_apply()
	. = ..()
	to_chat(owner, span_warning("I feel a surge of energy inside me!"))

/datum/status_effect/buff/vigorized/on_remove()
	. = ..()
	to_chat(owner, span_warning("The surge of energy inside me fades..."))

/datum/status_effect/buff/seelie_drugs
	id = "seelie drugs"
	alert_type = /atom/movable/screen/alert/status_effect/buff/druqks
	effectedstats = list(STATKEY_INT = 2, STATKEY_WIL = 4, STATKEY_SPD = -3)
	duration = 20 SECONDS


/datum/status_effect/buff/clash
	id = "clash"
	duration = 6 SECONDS
	var/dur
	var/sfx_on_apply = 'sound/combat/clash_initiate.ogg'
	var/swingdelay_mod = 5
	alert_type = /atom/movable/screen/alert/status_effect/buff/clash

	mob_effect_icon = 'icons/mob/mob_effects.dmi'
	mob_effect_icon_state = "eff_riposte"
	mob_effect_layer = MOB_EFFECT_LAYER_GUARD

//We have a lot of signals as the ability is meant to be interrupted by or interact with a lot of mechanics.
/datum/status_effect/buff/clash/on_creation(mob/living/new_owner, ...)
	//!Danger! Zone!
	//These signals use OVERRIDES and can OVERLAP with anything else using them.
	//At the moment we have no way of prioritising one signal over the other, it's first-come first-serve. Keep this in mind.
	RegisterSignal(new_owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(process_attack))
	RegisterSignal(new_owner, COMSIG_MOB_ITEM_BEING_ATTACKED, PROC_REF(process_attack))
	RegisterSignal(new_owner, COMSIG_MOB_ITEM_POST_SWINGDELAY_ATTACKED, PROC_REF(process_attack))


	RegisterSignal(new_owner, COMSIG_MOB_ATTACKED_BY_HAND, PROC_REF(process_touch))
	RegisterSignal(new_owner, COMSIG_MOB_ON_KICK, PROC_REF(guard_on_kick))
	RegisterSignal(new_owner, COMSIG_MOB_KICKED, PROC_REF(guard_kicked))
	RegisterSignal(new_owner, COMSIG_LIVING_ONJUMP, PROC_REF(guard_disrupted))
	RegisterSignal(new_owner, COMSIG_CARBON_SWAPHANDS, PROC_REF(guard_swaphands))
	RegisterSignal(new_owner, COMSIG_ITEM_GUN_PROCESS_FIRE, PROC_REF(guard_disrupted_cheesy))
	RegisterSignal(new_owner, COMSIG_ATOM_BULLET_ACT, PROC_REF(guard_struck_by_projectile))
	RegisterSignal(new_owner, COMSIG_LIVING_IMPACT_ZONE, PROC_REF(guard_struck_by_projectile))
	RegisterSignal(new_owner, COMSIG_LIVING_SWINGDELAY_MOD, PROC_REF(guard_swingdelay_mod))	//I dunno if a signal is better here rather than theoretically cycling through _all_ status effects to apply a var'd swingdelay mod.
	. = ..()

/datum/status_effect/buff/clash/proc/guard_swingdelay_mod()
	return swingdelay_mod

/datum/status_effect/buff/clash/proc/process_touch(mob/living/carbon/human/parent, mob/living/carbon/human/attacker, mob/living/carbon/human/defender)
	var/obj/item/I = defender.get_active_held_item()
	defender.process_clash(attacker, I, null)

/datum/status_effect/buff/clash/proc/process_attack(mob/living/parent, mob/living/target, mob/user, obj/item/I)
	var/bad_guard = FALSE
	var/mob/living/U = user
	//We have Guard / Clash active, and are hitting someone who doesn't. Cheesing a 'free' hit with a defensive buff is a no-no. You get punished.
	if(U.has_status_effect(/datum/status_effect/buff/clash) && !target.has_status_effect(/datum/status_effect/buff/clash))
		if(user == parent)
			bad_guard = TRUE
	if(ishuman(target) && target.get_active_held_item() && !bad_guard)
		var/mob/living/carbon/human/HM = target
		var/obj/item/IM = target.get_active_held_item()
		var/obj/item/IU
		if(user.used_intent.masteritem)
			IU = user.used_intent.masteritem
		HM.process_clash(user, IM, IU)
		return COMPONENT_NO_ATTACK
	if(bad_guard)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.bad_guard(span_suicide("I tried to strike while focused on defense whole! It drains me!"), cheesy = TRUE)

//Mostly here so the child (limbguard) can have special behaviour.
/datum/status_effect/buff/clash/proc/guard_struck_by_projectile()
	guard_disrupted()

/datum/status_effect/buff/clash/proc/guard_on_kick()
	guard_disrupted()

/datum/status_effect/buff/clash/proc/guard_kicked()
	guard_disrupted()

/datum/status_effect/buff/clash/proc/guard_swaphands()
	guard_disrupted()

/datum/status_effect/buff/clash/proc/apply_cooldown()
	var/newcd = BASE_RCLICK_CD - owner.get_tempo_bonus(TEMPO_TAG_RCLICK_CD_BONUS)
	owner.apply_status_effect(/datum/status_effect/debuff/clashcd, newcd)

//Our guard was disrupted by normal means.
/datum/status_effect/buff/clash/proc/guard_disrupted()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.bad_guard("My focus was disrupted!")

//We tried to cheese it. Generally reserved for egregious things, like attacking / casting while its active.
/datum/status_effect/buff/clash/proc/guard_disrupted_cheesy()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.bad_guard("My focus was <b>heavily</b> disrupted!")

/datum/status_effect/buff/clash/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	dur = world.time
	var/mob/living/carbon/human/H = owner
	if(sfx_on_apply)
		playsound(H, sfx_on_apply, 100, TRUE)

/datum/status_effect/buff/clash/tick()
	if(!owner.get_active_held_item() || !(owner.mobility_flags & MOBILITY_STAND))
		var/mob/living/carbon/human/H = owner
		H.bad_guard()

/datum/status_effect/buff/clash/on_remove()
	. = ..()
	apply_cooldown()
	// Optional balance lever -- stamina drain if we let Riposte expire without anything happening.
	/*var/newdur = world.time - dur
	var/mob/living/carbon/human/H = owner
	if(newdur > (initial(duration) - 0.2 SECONDS))	//Not checking exact duration to account for lag and any other tick / timing inconsistencies.
		H.bad_guard(span_warning("I held my focus for too long. It's left me drained."))*/
	UnregisterSignal(owner, COMSIG_ATOM_BULLET_ACT)
	UnregisterSignal(owner, COMSIG_MOB_ATTACKED_BY_HAND)
	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)
	UnregisterSignal(owner, COMSIG_MOB_ITEM_BEING_ATTACKED)
	UnregisterSignal(owner, COMSIG_MOB_ON_KICK)
	UnregisterSignal(owner, COMSIG_MOB_KICKED)
	UnregisterSignal(owner, COMSIG_ITEM_GUN_PROCESS_FIRE)
	UnregisterSignal(owner, COMSIG_CARBON_SWAPHANDS)
	UnregisterSignal(owner, COMSIG_LIVING_IMPACT_ZONE)
	UnregisterSignal(owner, COMSIG_LIVING_ONJUMP)
	UnregisterSignal(owner, COMSIG_LIVING_SWINGDELAY_MOD)

/atom/movable/screen/alert/status_effect/buff/clash
	name = "Ready to Clash"
	desc = span_notice("I am on guard, and ready to clash. If I am hit, I will successfully defend. Attacking will make me lose my focus.")
	icon_state = "clash"


/atom/movable/screen/alert/status_effect/buff/clash/limbguard
	name = "Limb Guard"
	desc = span_notice("I have focused my attention to guarding one limb. I shall deflect projectiles and blows to that limb with ease.")
	icon_state = "limbguard"

/datum/status_effect/buff/clash/limbguard
	id = "limbguard"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/buff/clash/limbguard
	sfx_on_apply = 'sound/combat/limbguard.ogg'

	var/protected_zone
	var/obj/shield_origin
	var/start_delay = 0.5 SECONDS
	var/is_active = FALSE

	mob_effect_dur = 9999 SECONDS	//It's a toggle, so we'll try to delete this manually when we can.
	mob_effect_icon = 'icons/mob/mob_effects.dmi'
	mob_effect_icon_state = "eff_guard"
	mob_effect_layer = MOB_EFFECT_LAYER_LIMBGUARD

/datum/status_effect/buff/clash/limbguard/on_creation(mob/living/new_owner, zone)
	if(!zone)
		CRASH("Guard (Defend rclick) was called with no valid zone!")
	protected_zone = zone
	set_offsets()
	. = ..()

/datum/status_effect/buff/clash/limbguard/on_apply()
	. = ..()
	if(mob_effect)
		mob_effect.alpha = 0
		animate(mob_effect, alpha = 100, time = start_delay)
		addtimer(CALLBACK(src, PROC_REF(update_status)), start_delay)

/datum/status_effect/buff/clash/limbguard/proc/update_status()
	if(mob_effect && !is_active)
		mob_effect.icon_state = initial(mob_effect_icon_state)+"_[protected_zone]"
		mob_effect.alpha = 255
		is_active = TRUE

/datum/status_effect/buff/clash/limbguard/on_creation(mob/living/new_owner, ...)
	. = ..()
	shield_origin = owner.get_active_held_item()

/datum/status_effect/buff/clash/limbguard/on_apply()
	. = ..()
	dur = 999999

/datum/status_effect/buff/clash/limbguard/on_remove()
	. = ..()
	QDEL_NULL(mob_effect)

/datum/status_effect/buff/clash/limbguard/process()
	if(owner)	//Avoids a runtime where this is called, apparently, before it has time to assign an owner via initialization (???)

		//Anti Sci main measures
		var/datum/reagents/reag = owner.reagents
		var/datum/reagent/medicine/stampot/stpot = reag.has_reagent(/datum/reagent/medicine/stampot)
		var/datum/reagent/medicine/strongstam/stpotstrong = reag.has_reagent(/datum/reagent/medicine/strongstam)
		if(stpot)
			stpot.metabolization_rate = 20 * REAGENTS_METABOLISM
		if(stpotstrong)
			stpotstrong.metabolization_rate = 20 * REAGENTS_METABOLISM

		if(!owner.cmode)
			remove_self()
		//We lost the shield we used this with from our hands.
		if((owner.get_inactive_held_item() != shield_origin) && (owner.get_active_held_item() != shield_origin))
			remove_self()
		if(!owner.stamina_add(0.2))	//It essentially halts green regen. Token price so it can't be maintained forever.
			remove_self()

/datum/status_effect/buff/clash/limbguard/proc/set_offsets()
	switch(protected_zone)
		if(BODY_ZONE_L_ARM)
			mob_effect_offset_x = 9
			mob_effect_offset_y = 0
		if(BODY_ZONE_R_ARM)
			mob_effect_offset_x = -9
			mob_effect_offset_y = 0
		if(BODY_ZONE_HEAD)
			mob_effect_offset_x = 0
			mob_effect_offset_y = 17
		if(BODY_ZONE_L_LEG)
			mob_effect_offset_x = 6
			mob_effect_offset_y = -9
		if(BODY_ZONE_R_LEG)
			mob_effect_offset_x = -6
			mob_effect_offset_y = -9

/datum/status_effect/buff/clash/limbguard/process_attack(mob/living/parent, mob/living/target, mob/user, obj/item/I)
	if(is_active)
		if(ishuman(user) && target == owner)
			var/mob/living/carbon/human/HM = user
			if(check_zone(HM.zone_selected) == protected_zone)	//User has struck the exact limb that was being protected. Bad!
				var/mob/living/carbon/human/H = owner
				H?.purge_peel(99)
				if(ishuman(user))
					apply_debuffs(HM)
					perform_disarm(HM)
				playsound(owner, 'sound/combat/limbguard_struck.ogg', 100, TRUE)
				if(HM.mind)
					owner.stamina_add(-(owner.max_stamina / 3))
					owner.energy_add((owner.max_energy / 5))
				remove_self()
				return COMPONENT_NO_ATTACK	//We cancel the attack that triggered this.
	if(user == owner && owner.get_active_held_item() == shield_origin)
		remove_self()

/datum/status_effect/buff/clash/limbguard/proc/apply_debuffs(mob/living/carbon/human/target)
	target.Immobilize(3 SECONDS)
	target.apply_status_effect(/datum/status_effect/debuff/clickcd, 5 SECONDS)
	target.apply_status_effect(/datum/status_effect/debuff/exposed, 10 SECONDS)
	target.remove_status_effect(/datum/status_effect/buff/clash/limbguard)
	target.stamina_add((target.max_stamina / 3))
	target.energy_add((-target.max_energy / 5))

#define LGUARD_SHARPNESS_LOSS     150
#define LGUARD_INTEG_LOSS		  100

/datum/status_effect/buff/clash/limbguard/proc/perform_disarm(mob/living/carbon/human/target)
	var/obj/item/I = target.get_active_held_item()
	owner.visible_message(span_boldwarning("[owner] anticipated the strike, disarming [target] in a decisive guard!"))
	owner.flash_fullscreen("whiteflash")
	target.flash_fullscreen("whiteflash")
	var/datum/effect_system/spark_spread/S = new()
	var/turf/front = get_step(owner,owner.dir)
	S.set_up(1, 1, front)
	S.start()
	if(I)
		target.disarmed(I)
		if(I.remove_bintegrity(LGUARD_SHARPNESS_LOSS))
			if(I.obj_integrity > (LGUARD_INTEG_LOSS * 0.5))
				I.take_damage((LGUARD_INTEG_LOSS * 0.5), BRUTE, "blunt")
			else
				I.take_damage((I.obj_integrity - 10), BRUTE, "blunt")
		else
			if(I.obj_integrity > LGUARD_INTEG_LOSS)
				I.take_damage((LGUARD_INTEG_LOSS), BRUTE, "blunt")
			else
				I.take_damage((I.obj_integrity - 10), BRUTE, "blunt")	//We try not to annihilate the weapon out of existence.

#undef LGUARD_SHARPNESS_LOSS
#undef LGUARD_INTEG_LOSS

/datum/status_effect/buff/clash/limbguard/proc/remove_self()
	owner.remove_status_effect(/datum/status_effect/buff/clash/limbguard)

//Projectile struck our protected limb. Unlike regular Riposte, this will deflect the projectile at no cost.
/datum/status_effect/buff/clash/limbguard/guard_struck_by_projectile(mob/living/target, obj/P, hit_zone)
	var/obj/IP = P
	if(istype(P, /obj/projectile/bullet/reusable))
		var/obj/projectile/bullet/reusable/RP = P	//This will ensure it gets dropped as an item first. Otherwise a non-reusable projectile will get poofed in a cloud of sparks.
		IP = RP.handle_drop()
	if(check_zone(hit_zone) == protected_zone)
		do_sparks(2, TRUE, get_turf(IP))
		target.visible_message(span_warning("[target] deflects \the [IP]!"))
		if(istype(IP, /obj/item))
			var/obj/item/I = IP
			I.get_deflected(target)
		return COMPONENT_CANCEL_THROW //Also returns COMPONENT_ATOM_BLOCK_BULLET

/datum/status_effect/buff/clash/limbguard/process_touch(mob/living/carbon/human/parent, mob/living/carbon/human/attacker, mob/living/carbon/human/defender)
	if(attacker && check_zone(attacker.zone_selected) == protected_zone)
		var/obj/item/I = defender.get_active_held_item()
		defender.process_clash(attacker, I, null)	//This will strike at their hand, but not clear away the effect. They tried to grab the protected limb.

/datum/status_effect/buff/clash/limbguard/apply_cooldown()
	owner.apply_status_effect(/datum/status_effect/debuff/specialcd, 60 SECONDS)
	owner.apply_status_effect(/datum/status_effect/debuff/clashcd)

//We don't have a cost to cancelling limbguard, so most of these are overridden.
//No green regen at all + the initial cost is steep already.
/datum/status_effect/buff/clash/limbguard/guard_kicked()
	return

/datum/status_effect/buff/clash/limbguard/guard_swaphands()
	return

/datum/status_effect/buff/clash/limbguard/guard_on_kick()
	return

#define BLOODRAGE_FILTER "bloodrage"

/atom/movable/screen/alert/status_effect/buff/graggar_bloodrage
	name = "BLOODRAGE"
	desc = "GRAGGAR! GRAGGAR! GRAGGAR!"
	icon_state = "bloodrage"

/datum/status_effect/buff/bloodrage
	id = "bloodrage"
	alert_type = /atom/movable/screen/alert/status_effect/buff/graggar_bloodrage
	var/outline_color = "#ad0202"
	duration = 15 SECONDS

/datum/status_effect/buff/bloodrage/on_apply()
	ADD_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, TRAIT_MIRACLE)
	var/holyskill = owner.get_skill_level(/datum/skill/magic/holy)
	duration = ((15 SECONDS) * holyskill)
	var/filter = owner.get_filter(BLOODRAGE_FILTER)
	if(!filter)
		owner.add_filter(BLOODRAGE_FILTER, 2, list("type" = "outline", "color" = outline_color, "alpha" = 60, "size" = 2))
	if(!HAS_TRAIT(owner, TRAIT_DODGEEXPERT))
		if(owner.STASTR < STRENGTH_SOFTCAP)
			effectedstats = list(STATKEY_STR = (STRENGTH_SOFTCAP - owner.STASTR))
			. = ..()
			return TRUE
	if(holyskill >= SKILL_LEVEL_APPRENTICE)
		effectedstats = list(STATKEY_STR = 2)
	else
		effectedstats = list(STATKEY_STR = 1)
	. = ..()
	return TRUE

/datum/status_effect/buff/bloodrage/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, TRAIT_MIRACLE)
	owner.visible_message(span_warning("[owner] wavers, their rage simmering down."))
	owner.OffBalance(3 SECONDS)
	owner.remove_filter(BLOODRAGE_FILTER)
	owner.emote("breathgasp", forced = TRUE)
	owner.Slowdown(3)

/datum/status_effect/buff/psydonic_endurance
	id = "psydonic_endurance"
	alert_type = /atom/movable/screen/alert/status_effect/buff/psydonic_endurance
	effectedstats = list(STATKEY_CON = 1,STATKEY_WIL = 1)

/datum/status_effect/buff/psydonic_endurance/on_apply()
	. = ..()
	if(HAS_TRAIT(owner, TRAIT_MEDIUMARMOR) && !HAS_TRAIT(owner, TRAIT_HEAVYARMOR))
		ADD_TRAIT(owner, TRAIT_HEAVYARMOR, src)

/datum/status_effect/buff/psydonic_endurance/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_HEAVYARMOR, src)

/atom/movable/screen/alert/status_effect/buff/psydonic_endurance
	name = "Psydonic Endurance"
	desc = "I am protected by blessed Psydonian plate armor."
	icon_state = "buff"

#undef BLOODRAGE_FILTER

/datum/status_effect/buff/sermon
	id = "sermon"
	alert_type = /atom/movable/screen/alert/status_effect/buff/sermon
	effectedstats = list(STATKEY_LCK = 1, STATKEY_CON = 1, STATKEY_WIL = 1, STATKEY_INT = 2)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/sermon
	name = "sermon"
	desc = "I feel inspired by the sermon!"
	icon_state = "buff"

/datum/status_effect/buff/griefflower
	id = "griefflower"
	alert_type = /atom/movable/screen/alert/status_effect/buff/griefflower
	effectedstats = list(STATKEY_CON = 1,STATKEY_WIL = 1)

/datum/status_effect/buff/griefflower/on_apply()
	. = ..()
	to_chat(owner, span_notice("The Rosa’s ring draws blood, but it’s the memories that truly wound. Failure after failure surging through you like thorns blooming inward."))
	ADD_TRAIT(owner, TRAIT_CRACKHEAD, src)

/datum/status_effect/buff/griefflower/on_remove()
	. = ..()
	to_chat(owner, span_notice("You part from the Rosa’s touch. The ache retreats..."))
	REMOVE_TRAIT(owner, TRAIT_CRACKHEAD, src)

/atom/movable/screen/alert/status_effect/buff/griefflower
	name = "Rosa Ring"
	desc = "The Rosa's ring draws blood, but it's the memories that truly wound. Failure after failure surging through you like thorns blooming inward."
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/buff/adrenaline_rush
	name = "Adrenaline Rush"
	desc = "The gambit worked! I can do anything! My heart races, the throb of my wounds wavers."
	icon_state = "adrrush"

/datum/status_effect/buff/adrenaline_rush
	id = "adrrush"
	alert_type = /atom/movable/screen/alert/status_effect/buff/adrenaline_rush
	duration = 18 SECONDS
	examine_text = "SUBJECTPRONOUN is amped up!"
	effectedstats = list(STATKEY_WIL = 1)
	var/blood_restore = 30

/datum/status_effect/buff/adrenaline_rush/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_ADRENALINE_RUSH, INNATE_TRAIT)
	var/mob/living/carbon/human/human = owner
	if(istype(human))
		human.playsound_local(get_turf(human), 'sound/misc/adrenaline_rush.ogg', 100, TRUE)
		human.blood_volume = min((human.blood_volume + blood_restore), BLOOD_VOLUME_NORMAL)
		human.stamina -= max((human.stamina - (human.max_stamina / 2)), 0)
		human.pain_threshold += 50

/datum/status_effect/buff/adrenaline_rush/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_ADRENALINE_RUSH, INNATE_TRAIT)
	var/mob/living/carbon/human/human = owner
	if(istype(human))
		human.pain_threshold -= 50

/datum/status_effect/buff/magic/knowledge
	id = "intelligence"
	alert_type = /atom/movable/screen/alert/status_effect/buff/magic/knowledge
	effectedstats = list("intelligence" = 2)
	duration = 10 MINUTES

/atom/movable/screen/alert/status_effect/buff/magic/knowledge
	name = "runic cunning"
	desc = "I am magically astute."
	icon_state = "buff"

/datum/status_effect/buff/magic/strength
	id = "strength"
	alert_type = /atom/movable/screen/alert/status_effect/buff/magic/strength
	effectedstats = list("strength" = 3)
	duration = 20 MINUTES

/datum/status_effect/buff/magic/strength/on_apply()
	if(owner.has_status_effect(/datum/status_effect/buff/magic/strength_lesser))
		owner.remove_status_effect(/datum/status_effect/buff/magic/strength_lesser)
	return ..()

/atom/movable/screen/alert/status_effect/buff/magic/strength
	name = "arcane reinforced strength"
	desc = "I am magically strengthened."
	icon_state = "buff"

/datum/status_effect/buff/magic/strength_lesser
	id = "lesser strength"
	alert_type = /atom/movable/screen/alert/status_effect/buff/magic/strength/lesser
	effectedstats = list("strength" = 1)
	duration = 20 MINUTES

/datum/status_effect/buff/magic/strength_lesser/on_apply()
	if(owner.has_status_effect(/datum/status_effect/buff/magic/strength))
		return FALSE
	return ..()

/atom/movable/screen/alert/status_effect/buff/magic/strength/lesser
	name = "lesser arcane strength"
	desc = "I am magically strengthened."
	icon_state = "buff"


/datum/status_effect/buff/magic/speed
	id = "speed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/magic/speed
	effectedstats = list("speed" = 3)
	duration = 20 MINUTES

/datum/status_effect/buff/magic/speed/on_apply()
	if(owner.has_status_effect(/datum/status_effect/buff/magic/speed_lesser))
		owner.remove_status_effect(/datum/status_effect/buff/magic/speed_lesser)
	return ..()

/atom/movable/screen/alert/status_effect/buff/magic/speed
	name = "arcane swiftness"
	desc = "I am magically swift."
	icon_state = "buff"

/datum/status_effect/buff/magic/speed_lesser
	id = "lesser speed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/magic/speed/lesser
	effectedstats = list("speed" = 1)
	duration = 20 MINUTES

/datum/status_effect/buff/magic/speed_lesser/on_apply()
	if(owner.has_status_effect(/datum/status_effect/buff/magic/speed))
		return FALSE
	return ..()

/atom/movable/screen/alert/status_effect/buff/magic/speed/lesser
	name = "arcane swiftness"
	desc = "I am magically swift."
	icon_state = "buff"

/datum/status_effect/buff/magic/willpower
	id = "willpower"
	alert_type = /atom/movable/screen/alert/status_effect/buff/magic/willpower
	effectedstats = list("willpower" = 3)
	duration = 20 MINUTES

/datum/status_effect/buff/magic/willpower/on_apply()
	if(owner.has_status_effect(/datum/status_effect/buff/magic/willpower_lesser))
		owner.remove_status_effect(/datum/status_effect/buff/magic/willpower_lesser)
	return ..()

/atom/movable/screen/alert/status_effect/buff/magic/willpower
	name = "arcane willpower"
	desc = "I am magically resilient."
	icon_state = "buff"

/datum/status_effect/buff/magic/willpower_lesser
	id = "lesser willpower"
	alert_type = /atom/movable/screen/alert/status_effect/buff/magic/willpower/lesser
	effectedstats = list("willpower" = 1)
	duration = 20 MINUTES

/datum/status_effect/buff/magic/willpower_lesser/on_apply()
	if(owner.has_status_effect(/datum/status_effect/buff/magic/willpower))
		return FALSE
	return ..()

/atom/movable/screen/alert/status_effect/buff/magic/willpower/lesser
	name = "lesser arcane willpower"
	desc = "I am magically resilient."
	icon_state = "buff"

/datum/status_effect/buff/magic/constitution
	id = "constitution"
	alert_type = /atom/movable/screen/alert/status_effect/buff/magic/constitution
	effectedstats = list("constitution" = 3)
	duration = 20 MINUTES

/datum/status_effect/buff/magic/constitution/on_apply()
	if(owner.has_status_effect(/datum/status_effect/buff/magic/constitution_lesser))
		owner.remove_status_effect(/datum/status_effect/buff/magic/constitution_lesser)
	return ..()

/atom/movable/screen/alert/status_effect/buff/magic/constitution
	name = "arcane constitution"
	desc = "I feel reinforced by magick."
	icon_state = "buff"

/datum/status_effect/buff/magic/constitution_lesser
	id = "lesser constitution"
	alert_type = /atom/movable/screen/alert/status_effect/buff/magic/constitution/lesser
	effectedstats = list("constitution" = 1)
	duration = 20 MINUTES

/datum/status_effect/buff/magic/constitution_lesser/on_apply()
	if(owner.has_status_effect(/datum/status_effect/buff/magic/constitution))
		return FALSE
	return ..()

/atom/movable/screen/alert/status_effect/buff/magic/constitution/lesser
	name = "lesser arcane constitution"
	desc = "I feel reinforced by magick."
	icon_state = "buff"

/datum/status_effect/buff/magic/perception
	id = "perception"
	alert_type = /atom/movable/screen/alert/status_effect/buff/magic/perception
	effectedstats = list("perception" = 3)
	duration = 20 MINUTES

/datum/status_effect/buff/magic/perception/on_apply()
	if(owner.has_status_effect(/datum/status_effect/buff/magic/perception_lesser))
		owner.remove_status_effect(/datum/status_effect/buff/magic/perception_lesser)
	return ..()

/atom/movable/screen/alert/status_effect/buff/magic/perception
	name = "arcane perception"
	desc = "I can see everything."
	icon_state = "buff"

/datum/status_effect/buff/magic/perception_lesser
	id = "lesser perception"
	alert_type = /atom/movable/screen/alert/status_effect/buff/magic/perception/lesser
	effectedstats = list("perception" = 1)
	duration = 20 MINUTES

/datum/status_effect/buff/magic/perception_lesser/on_apply()
	if(owner.has_status_effect(/datum/status_effect/buff/magic/perception))
		return FALSE
	return ..()

/atom/movable/screen/alert/status_effect/buff/magic/perception/lesser
	name = "lesser arcane perception"
	desc = "I can see somethings."
	icon_state = "buff"

/datum/status_effect/buff/nocblessing
	id = "nocblessing"
	alert_type = /atom/movable/screen/alert/status_effect/buff/nocblessing
	effectedstats = list("intelligence" = 1)
	duration = 30 MINUTES

/atom/movable/screen/alert/status_effect/buff/nocblessing
	name = "Noc's blessing"
	desc = "Gazing Noc helps me think."
	icon_state = "buff"

/datum/status_effect/buff/massage
	id = "massage"
	alert_type = /atom/movable/screen/alert/status_effect/buff/massage
	effectedstats = list(STATKEY_CON = 1)
	duration = 30 MINUTES

/atom/movable/screen/alert/status_effect/buff/massage
	name = "Massage"
	desc = "My muscles feel relaxed"
	icon_state = "buff"

/datum/status_effect/buff/goodmassage
	id = "goodmassage"
	alert_type = /atom/movable/screen/alert/status_effect/buff/goodmassage
	effectedstats = list(STATKEY_CON = 1, STATKEY_SPD = 1, STATKEY_STR = 1)
	duration = 30 MINUTES

/atom/movable/screen/alert/status_effect/buff/goodmassage
	name = "Good Massage"
	desc = "My muscles feel relaxed and better than before"
	icon_state = "buff"

/datum/status_effect/buff/greatmassage
	id = "greatmassage"
	alert_type = /atom/movable/screen/alert/status_effect/buff/greatmassage
	effectedstats = list(STATKEY_CON = 2, STATKEY_SPD = 1, STATKEY_STR = 1, STATKEY_LCK =1)
	duration = 30 MINUTES

/atom/movable/screen/alert/status_effect/buff/greatmassage
	name = "Great Massage"
	desc = "My body feels better than ever!"
	icon_state = "buff"


/datum/status_effect/buff/refocus
	id = "refocus"
	alert_type = /atom/movable/screen/alert/status_effect/buff/refocus
	effectedstats = list(STATKEY_INT = 2, STATKEY_WIL = -1)
	duration = 15 MINUTES

/atom/movable/screen/alert/status_effect/buff/refocus
	name = "Refocus"
	desc = "I've sacrificed some of my learning to help me learn something new"
	icon_state = "buff"


/datum/status_effect/buff/celerity
	id = "celerity"
	alert_type = /atom/movable/screen/alert/status_effect/buff
	effectedstats = list(STATKEY_SPD = 1)
	status_type = STATUS_EFFECT_REPLACE

/datum/status_effect/buff/celerity/New(list/arguments)
	effectedstats[STATKEY_SPD] = arguments[2]
	. = ..()

/datum/status_effect/buff/fotv
	id = "fotv"
	alert_type = /atom/movable/screen/alert/status_effect/buff
	effectedstats = list(STATKEY_SPD = 3, STATKEY_WIL = 1, STATKEY_CON = 1)
	status_type = STATUS_EFFECT_REPLACE

/atom/movable/screen/alert/status_effect/buff/vampire_float
	name = "Float"
	desc = "My body is floating off the ground."
	icon_state = "vampire_float"

/datum/status_effect/buff/vampire_float
	id = "vampire_float"
	alert_type = /atom/movable/screen/alert/status_effect/buff/vampire_float
	duration = 2 MINUTES

/datum/status_effect/buff/vampire_float/on_apply()
	. = ..()
	to_chat(owner, span_warning("I am hovering off the ground."))
	owner.movement_type = FLYING



/datum/status_effect/buff/vampire_float/on_remove()
	. = ..()
	to_chat(owner, span_warning("I fall back to the ground."))
	owner.movement_type = GROUND

/datum/status_effect/buff/ravox_vow
	id = "ravox_vow"
	alert_type = /atom/movable/screen/alert/status_effect/buff/ravox_vow
	effectedstats = list(STATKEY_STR = 1, STATKEY_WIL = 1)
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	tick_interval = -1

/datum/status_effect/buff/ravox_vow/proc/on_life()
	SIGNAL_HANDLER

	owner.heal_wounds(1)

/datum/status_effect/buff/ravox_vow/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, PROC_REF(on_unarmed_attack))
	RegisterSignal(owner, COMSIG_MOB_ITEM_AFTERATTACK, PROC_REF(on_item_attack))
	RegisterSignal(owner, COMSIG_LIVING_LIFE, PROC_REF(on_life))

/datum/status_effect/buff/ravox_vow/proc/on_unarmed_attack(mob/living/user, mob/living/carbon/human/target)
	SIGNAL_HANDLER

	if(!istype(target))
		return

	if(!HAS_TRAIT(target, TRAIT_OUTLAW) || (!(target.name in user.mind.known_people)))
		return

	var/armor_block = target.run_armor_check(user.zone_selected, "blunt")
	if(prob(armor_block))
		return

	apply_effects(target)

/datum/status_effect/buff/ravox_vow/proc/on_item_attack(mob/living/user, mob/living/carbon/human/target, obj/item/item)
	SIGNAL_HANDLER

	if(!istype(target))
		return

	if(!HAS_TRAIT(target, TRAIT_OUTLAW) || (!(target.name in user.mind.known_people)))
		return

	var/armor_block = target.run_armor_check(user.zone_selected, item.d_type)
	if(prob(armor_block))
		return

	apply_effects(target)

/datum/status_effect/buff/ravox_vow/proc/apply_effects(mob/living/carbon/human/target)
	if(target.fire_stacks >= 3)
		return

	target.adjust_fire_stacks(1, /datum/status_effect/fire_handler/fire_stacks/divine)
	INVOKE_ASYNC(target, TYPE_PROC_REF(/mob/living, ignite_mob))

/datum/status_effect/buff/ravox_vow/on_remove()
	. = ..()
	UnregisterSignal(owner, list(COMSIG_MOB_ITEM_AFTERATTACK, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, COMSIG_LIVING_LIFE))

/atom/movable/screen/alert/status_effect/buff/ravox_vow
	name = "Ravox vow"
	desc = "I vowed to Ravox. I shall bring justice to Psydonia."

#define JOYBRINGER_FILTER "joybringer"

/datum/status_effect/joybringer
	id = "joybringer"
	var/outline_colour = "#a529e8"
	duration = -1
	tick_interval = -1
	examine_text = span_love("SUBJECTPRONOUN is bathed in Baotha's blessings!")
	alert_type = null

/datum/status_effect/joybringer/on_apply()
	. = ..()

	owner.visible_message(span_userdanger("A tide of vibrant purple mist surges from [owner], carrying the heavy scent of sweet intoxication!"))

	var/filter = owner.get_filter(JOYBRINGER_FILTER)
	if(!filter)
		owner.add_filter(JOYBRINGER_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 2))

	var/mutable_appearance/effect = mutable_appearance('icons/effects/effects.dmi', "mist", -JOYBRINGER_LAYER, alpha = 128)
	effect.appearance_flags = RESET_COLOR
	effect.blend_mode = BLEND_ADD
	effect.color = "#a529e8"

	owner.overlays_standing[JOYBRINGER_LAYER] = effect
	owner.apply_overlay(JOYBRINGER_LAYER)

	RegisterSignal(owner, COMSIG_LIVING_LIFE, PROC_REF(on_life))

/datum/status_effect/joybringer/on_remove()
	. = ..()

	owner.remove_filter(JOYBRINGER_FILTER)
	owner.remove_overlay(JOYBRINGER_LAYER)

	UnregisterSignal(owner, COMSIG_LIVING_LIFE)

/datum/status_effect/joybringer/proc/on_life()
	SIGNAL_HANDLER

	for(var/mob/living/mob in get_hearers_in_view(2, owner))
		if(HAS_TRAIT(mob, TRAIT_CRACKHEAD) || HAS_TRAIT(mob, TRAIT_PSYDONITE))
			continue

		mob.apply_status_effect(/datum/status_effect/debuff/joybringer_druqks)

#undef JOYBRINGER_FILTER

#undef MIRACLE_BLOODHEAL_FILTER
#undef PSYDON_HEALING_FILTER
#undef PSYDON_REVIVED_FILTER
