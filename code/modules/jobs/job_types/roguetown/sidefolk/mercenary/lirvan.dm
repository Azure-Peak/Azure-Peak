/datum/advclass/mercenary/lirvanmerc
	name = "Lirvan Tithebound"
	tutorial = "Contrary to the name, you're not indebted. Far from it. Lirvas is well-known for its economically aggressive brand of Matthiosianism, and the Tithebound are no exception to this opportunistic mammon-making. With tough scales reinforced by Matthiosian rituo, and solid armor, stand 'gainst the tide, and turn thyne WEALTH to POWER. A few rare Tithebound are more aligned towards Astrata."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		/datum/species/dracon,
		/datum/species/lizardfolk,
		/datum/species/kobold,
	) //no wildkin; i'd like to allow snek/liznerd wildkin, but i don't have a way of mechnaically enforcing that
	outfit = /datum/outfit/job/roguetown/mercenary/lirvanmerc
	class_select_category = CLASS_CAT_RACIAL
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_SEEPRICES, TRAIT_MEDIUMARMOR)
	cmode_music = 'sound/music/combat_matthios.ogg'
	maximum_possible_slots = 2

	subclass_stats = list(
		STATKEY_STR = 1, //poopy adv-tier stats, the majority of it will be via selfbuff. abt 3 points of weighted stats
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_PER = 1,
		STATKEY_SPD = -2
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE, //pity. your staff is incredibly fragile
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/staves = SKILL_LEVEL_EXPERT //awww yeah
	)
	extra_context = "This subclass is race-limited to: Drakian, Zardman, and Kobold. This subclass locks you to Matthios or Astrata-worship."

/datum/outfit/job/roguetown/mercenary/lirvanmerc
	allowed_patrons = list(/datum/patron/divine/astrata, /datum/patron/inhumen/matthios)

/datum/outfit/job/roguetown/mercenary/lirvanmerc/pre_equip(mob/living/carbon/human/H)
	..()

	if(should_wear_femme_clothes(H))
		shirt = /obj/item/clothing/suit/roguetown/shirt/desertbra

	cloak = /obj/item/clothing/cloak/ordinatorcape/lirvas
	wrists = /obj/item/clothing/wrists/roguetown/bracers/lirvas
	belt = /obj/item/storage/belt/rogue/leather/plaquegold
	beltr = /obj/item/rogueweapon/sword/sabre
	beltl = /obj/item/rogueweapon/scabbard/sword/noble
	neck = /obj/item/clothing/neck/roguetown/gorget/steel/gold
	armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/lirvas
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/gold
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	gloves = /obj/item/clothing/gloves/roguetown/angle
	backr = /obj/item/storage/backpack/rogue/satchel/black
	l_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/gold
	r_hand = /obj/item/storage/belt/rogue/pouch/coins/mid
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/flashlight/flare/torch = 1,
		)

	H.merctype = 16 //literally no idea what this does
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/lirvan_tithe)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/saxtonhale)

	if(H.mind)
		var/list/patron_choices = list("The ORDER and MONARCHY of Astrata", "The WEALTH and POWER of Matthios")
		var/patron_choice = input(H, "What do you worship?", "Choose a Patron", "The WEALTH and POWER of Matthios") as anything in patron_choices
		switch(patron_choice)
			if("The ORDER and MONARCHY of Astrata")
				H.set_patron(/datum/patron/divine/astrata)
				H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_EXPERT, TRUE) //idfk what astratans do man
			if("The WEALTH and POWER of Matthios")
				H.set_patron(/datum/patron/inhumen/matthios)
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_JOURNEYMAN, TRUE)

/*                            ,---.
,--.  ,--.        ,--.  ,--.  |   |
|  '--'  | ,--,--.|  |,-'  '-.|  .'
|  .--.  |' ,-.  ||  |'-.  .-'|  |
|  |  |  |\ '-'  ||  |  |  |  `--'
`--'  `--' `--`--'`--'  `--'  .--.
                              '--'
shitcode stuff below this point; first, their regenerating skin which gives them a buff when broken, which works fine.
Second, a self-buff spell that buffs them depending on their total wealth including item sellvalue. I would have liked this to ideally been just a thing they got passively, but I can't fucking code, so...
third; SUNSET, little neat ability. it may be buggy. don't quote me on that. it looks cool though doesnt it. */


/obj/item/clothing/neck/roguetown/gorget/steel/gold
	name = "gold-plated gorget"
	desc = "A series of steel plates designed to protect the neck, traditionally worn atop a jacket or cuirass. It bares a mammon-sized divet along its right flank; the certification of its 'proofedness' against a longbow's strike. This one is covered in a thin layer of gold."
	color = "#f9a602"

/obj/item/clothing/under/roguetown/chainlegs/kilt/gold
	color = "#f9a602"

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/lirvas //high and good armor, but full body, so constant dmg  U N G O D L Y  high regen time. get owned when it breaks or swap to a sidearm
	name = "hardened scales"
	desc = "Scales hardened by Lirvan rituo. When broken, my body crumbles, but the lack of encumberance is wildly freeing. </br> </br> Who is more worthy to inherit the wealth of the Sun than those who fly closest?"
	repairmsg_begin = "My scales harden and begin mending."
	repairmsg_continue = "Golden light seeps 'tween myne mending scales."
	repairmsg_stop = "The onslaught stops my scales' regeneration!"
	repairmsg_end = "My scales are as strong as stone once more!"
	repair_time = 60 SECONDS
	armor = ARMOR_PLATE //scalemail equivalent and ensures it takes dmg last
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET | HANDS | FEET | COVERAGE_HEAD //all but eyes/nose, seems fair.
	max_integrity = 500 //kinda snowflakey but after the armor rework, considering that this is full-body and will always absorb a hit; bc it's scale equivalent it will actually absorb nearly ALL of the dmg, so...

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/lirvas/Destroy() //this shouldn't happen, but just in case.....though maybe it'd be more sovl if it didn't...?
	remove_broken_scales_buff()
	return ..()

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/lirvas/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir, armor_penetration)
	. = ..()
	if(obj_integrity <= (initial(obj_integrity) * (0.11))) //UNBELIEVABLY SHIT CODE
		apply_broken_scales_buff()

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/lirvas/armour_regen() //i...hope this works??
	remove_broken_scales_buff()
	return ..()

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/lirvas/proc/apply_broken_scales_buff()
	if(!ishuman(loc))
		return
	var/mob/living/carbon/human/H = loc
	if(!H.has_status_effect(/datum/status_effect/buff/lirvan_broken_scales))
		H.apply_status_effect(/datum/status_effect/buff/lirvan_broken_scales)

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/lirvas/proc/remove_broken_scales_buff()
	if(!ishuman(loc))
		return
	var/mob/living/carbon/human/H = loc
	if(H.has_status_effect(/datum/status_effect/buff/lirvan_broken_scales))
		H.remove_status_effect(/datum/status_effect/buff/lirvan_broken_scales)


#define LIRVAN_BLING_FILTER "lirvan_titheaura"

/proc/get_moni_value(atom/movable/movable)
	var/wealth = 0
	if(istype(movable, /obj/item/roguecoin))
		var/obj/item/roguecoin/coin = movable
		wealth += coin.quantity * coin.sellprice
	else if(istype(movable, /obj/item))
		var/obj/item/item = movable
		if(item.sellprice)
			wealth += item.sellprice
	for(var/atom/movable/content in movable.contents)
		wealth += get_moni_value(content)
	return wealth

/obj/effect/proc_holder/spell/self/lirvan_tithe
	name = "INVOKE"
	desc = "Draw strength from the wealth you carry. Armor, jewelry, and raw mammon counted equally. More WEALTH means more POWER. More POWER at 150, 200, 300, 400, and 700 mammon."
	antimagic_allowed = TRUE
	clothes_req = FALSE
	recharge_time = 3 MINUTES
	ignore_armor_penalty = TRUE
	invocations = list("'s scales harden and glow softly!")
	invocation_type = "emote"

/obj/effect/proc_holder/spell/self/lirvan_tithe/cast(mob/living/user)
	if(!ishuman(user))
		return FALSE
	user.apply_status_effect(/datum/status_effect/buff/lirvan_tithe)
	return TRUE

/atom/movable/screen/alert/status_effect/buff/lirvan_tithe
	name = "Mammon's Bulwark"
	desc = "The air burns with POWER."
	icon_state = "buff"

/datum/status_effect/buff/lirvan_tithe
	id = "lirvan_tithe"
	examine_text = "<font color='red'>SUBJECTPRONOUN radiates POWER.</font>"
	alert_type = /atom/movable/screen/alert/status_effect/buff/lirvan_tithe
	status_type = STATUS_EFFECT_REFRESH
	duration = 2 MINUTES
	var/wealth_value = 0
	var/outline_colour = "#f5d96c"
	var/obj/effect/dummy/lighting_obj/moblight/lirvanlight
	var/gonna_fort = FALSE //like, we're gonna use fortitude. we'll apply fortitude to...ah, nevermind.

/datum/status_effect/buff/lirvan_tithe/on_apply()
	update_effects()
	. = ..()
	if(.)
		var/filter = owner.get_filter(LIRVAN_BLING_FILTER)
		if(!filter)
			owner.add_filter(LIRVAN_BLING_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 120, "size" = 1))
		if(!lirvanlight)
			lirvanlight = owner.mob_light(7, 7, _color = outline_colour)
		if(wealth_value < 120)
			to_chat(owner, span_notice("WEALTH answers my call. Every single one of my- ONLY [src.wealth_value] MAMMON?!"))
			owner.emote("whimper", forced = TRUE)
			return
		to_chat(owner, span_notice("WEALTH answers my call. Every single one of my [src.wealth_value] pieces of it."))
		if(wealth_value > 400)
			ADD_TRAIT(owner, TRAIT_FORTITUDE, STATUS_EFFECT_TRAIT)
			gonna_fort = TRUE
			to_chat(owner, span_userdanger("FORTIFIED."))
		playsound(owner, 'sound/combat/hits/burn (2).ogg', 100, TRUE)

/datum/status_effect/buff/lirvan_tithe/on_remove()
	. = ..()
	if(gonna_fort)
		REMOVE_TRAIT(owner, TRAIT_FORTITUDE, STATUS_EFFECT_TRAIT)
		gonna_fort = FALSE
	owner.remove_filter(LIRVAN_BLING_FILTER)
	QDEL_NULL(lirvanlight)
	to_chat(owner, span_warning("POWER fades."))

/datum/status_effect/buff/lirvan_tithe/proc/update_effects()
	wealth_value = get_moni_value(owner)
	if(wealth_value < 120)
		effectedstats = list(STATKEY_CON = 1, STATKEY_LCK = 1)
	else if(wealth_value < 150)
		effectedstats = list(STATKEY_STR = 1, STATKEY_CON = 1, STATKEY_LCK = 1)
	else if(wealth_value < 200)
		effectedstats = list(STATKEY_STR = 1, STATKEY_CON = 2, STATKEY_LCK = 1)
	else if(wealth_value < 300)
		effectedstats = list(STATKEY_STR = 2, STATKEY_CON = 2, STATKEY_LCK = 1, STATKEY_SPD = 1)
	else if(wealth_value < 400)
		effectedstats = list(STATKEY_STR = 2, STATKEY_CON = 3, STATKEY_LCK = 2, STATKEY_SPD = 1)
	else if(wealth_value < 700)
		effectedstats = list(STATKEY_STR = 3, STATKEY_CON = 3, STATKEY_LCK = 2, STATKEY_SPD = 2)
	else
		effectedstats = list(STATKEY_STR = 3, STATKEY_CON = 4, STATKEY_LCK = 2, STATKEY_SPD = 2) //I'm hoping this doesn't happen often.


/obj/effect/proc_holder/spell/invoked/saxtonhale
	name = "SUNSET"
	desc = "Channel but a mote of the power of a Drakkyn. Take to the skies, before crashing into the ground with a punishing slam after a delay. All caught within are damaged. Hit can be riposted. Center tile takes double damage."
	clothes_req = FALSE
	ignore_armor_penalty = TRUE
	range = 5
	overlay_state = "thunderstrike"
	releasedrain = 30
	chargedrain = 0
	chargetime = 5
	recharge_time = 20 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	invocations = list("Drakkyr Voldta!") //draconic doesn't have any linguistic inspirations i think. 'dragon walk' if you want to be super literal abt the greek translation but like idk man im just a polyglot dont get mad at me
	invocation_type = "shout"
	gesture_required = TRUE
	var/damage = 45
	var/delay = 1 SECONDS
	var/obj/effect/temp_visual/lirvan_sunset_dragon/dragon_afterimage

/obj/effect/proc_holder/spell/invoked/saxtonhale/cast(list/targets, mob/living/user = usr)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		revert_cast()
		return FALSE

	var/obj/item/held_weapon = H.get_active_held_item()
	if(!held_weapon)
		to_chat(H, span_warning("...with WHAT WEAPON?"))
		revert_cast()
		return FALSE

	var/atom/target = targets[1]
	var/turf/target_turf = get_turf(target)
	var/turf/start_turf = get_turf(H)
	if(!target_turf || !start_turf)
		revert_cast()
		return FALSE

	if(target_turf.z != start_turf.z)
		to_chat(H, span_warning("I cannot reach that level!"))
		revert_cast()
		return FALSE

	if(target_turf.density)
		to_chat(H, span_warning("I need open ground for my landing!"))
		revert_cast()
		return FALSE

	var/def_zone = H.zone_selected || BODY_ZONE_CHEST

	for(var/turf/affected_turf in range(1, target_turf))
		new /obj/effect/temp_visual/trap/thunderstrike(affected_turf, delay)

	H.visible_message(span_warning("[H] vaults skywards in a half-crescent of gold...!"), span_notice("CRUSH."))
	playsound(start_turf, 'sound/combat/wooshes/bladed/wooshsmall (1).ogg', 60, TRUE)
	playsound(start_turf, 'sound/vo/mobs/wwolf/idle (1).ogg', 60, TRUE)
	dragon_afterimage = new /obj/effect/temp_visual/lirvan_sunset_dragon(start_turf)

	if(H.buckled)
		H.buckled.unbuckle_mob(H, TRUE)

	var/old_pass = H.pass_flags
	var/prev_pixel_z = H.pixel_z
	H.pass_flags |= PASSMOB
	animate(H, pixel_z = prev_pixel_z + 24, time = 2, easing = EASE_OUT) //i literally copy/pasted this i rly hope it works tee hee :3

	sleep(delay)

	if(QDELETED(H) || H.stat == DEAD)
		return FALSE

	var/max_leap_steps = max(1, get_dist(start_turf, target_turf) + 1)
	var/landing_turf = target_turf
	while(get_turf(H) != target_turf && max_leap_steps-- > 0)
		var/turf/current_turf = get_turf(H)
		if(dragon_afterimage)
			dragon_afterimage.forceMove(current_turf)
		var/dir_to_target = get_dir(current_turf, target_turf)
		var/turf/next = get_step(current_turf, dir_to_target)
		if(!next || next.density)
			landing_turf = current_turf
			break
		if(!step(H, dir_to_target))
			landing_turf = current_turf
			break

	animate(H, pixel_z = prev_pixel_z, time = 1, easing = EASE_IN)
	H.pass_flags = old_pass
	if(dragon_afterimage)
		dragon_afterimage.fade_out()
		dragon_afterimage = null

	if(get_turf(H) != target_turf)
		landing_turf = get_turf(H)

	playsound(landing_turf, pick('sound/combat/ground_smash1.ogg', 'sound/combat/ground_smash2.ogg', 'sound/combat/ground_smash3.ogg'), 80, TRUE)
	for(var/turf/affected_turf in range(1, landing_turf))
		new /obj/effect/temp_visual/kinetic_blast(affected_turf)
		var/impact_damage = (affected_turf == landing_turf) ? damage * 3 : damage
		for(var/mob/living/L in affected_turf)
			if(L == H || L.stat == DEAD)
				continue
			if(L.anti_magic_check())
				L.visible_message(span_warning("POWER shatters 'pon [L]!"))
				playsound(affected_turf, 'sound/magic/magic_nulled.ogg', 100)
				continue
			if(spell_guard_check(L, TRUE))
				L.visible_message(span_warning("[L] braces and survives the impact!"))
				continue
			arcyne_strike(H, L, held_weapon, impact_damage, def_zone, BCLASS_BLUNT, spell_name = "SUNSET")

	return TRUE


/obj/effect/temp_visual/lirvan_sunset_dragon //SPECIAL EFFECTS DONE DIRT CHEAP
	name = "sunfall dragon"
	icon = 'modular/icons/mob/96x96/ratwood_dragon.dmi'
	icon_state = "dragon_shadow"
	randomdir = FALSE
	duration = 2 SECONDS
	fade_time = 10
	layer = MOB_LAYER - 0.1
	plane = GAME_PLANE
	pixel_x = -32
	pixel_y = -32
	alpha = 30

/obj/effect/temp_visual/lirvan_sunset_dragon/Initialize(mapload)
	. = ..()
	add_filter("sunset_gold_outline", 1, list("type" = "outline", "color" = "#f5d96c", "size" = 1))
	add_atom_colour("#f5d96c", FIXED_COLOUR_PRIORITY)

/obj/effect/temp_visual/lirvan_sunset_dragon/proc/fade_out()
	if(QDELETED(src))
		return
	animate(src, alpha = 0, time = 6)
	QDEL_IN(src, 6)

#undef LIRVAN_BLING_FILTER
