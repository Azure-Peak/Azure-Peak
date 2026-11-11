//Sprites contributed by VelSlime

/datum/language_holder/pure_ooze
	languages = list(/datum/language/undercommon)
	only_speaks_language = /datum/language/undercommon
	selected_default_language = /datum/language/undercommon

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob
	threat_point = THREAT_LOW
	anatomy_type = /datum/anatomy/amorphous
	attack_aim = MOB_AIM_GROUND
	name = "ooze"
	desc = "A strange, amorphous animated blob of ooze."
	icon_state = "ooze"
	icon_living = "ooze"
	icon_dead = "ooze_dead"
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	see_in_dark = 6
	base_intents = list(/datum/intent/simple/bite/volf)
	botched_butcher_results = list(/obj/item/alch/viscera = 1)
	butcher_results = list(/obj/item/alch/waterdust = 2,
							/obj/item/alch/viscera = 2)
	perfect_butcher_results = list(/obj/item/reagent_containers/lux_impure = 1,
									/obj/item/alch/waterdust = 3,
									/obj/item/alch/viscera = 3)
	head_butcher = null
	faction = list(FACTION_OOZE)
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = OOZE_BLOB_HEALTH
	maxHealth = OOZE_BLOB_HEALTH
	melee_damage_lower = 19
	melee_damage_upper = 29
	environment_smash = ENVIRONMENT_SMASH_NONE
	milkies = FALSE
	food_type = list(/obj/item/reagent_containers/food/snacks,
					//obj/item/bodypart,
					//obj/item/organ,
					/obj/item/natural/bone,
					/obj/item/natural/hide)
	footstep_type = FOOTSTEP_MOB_SLIME
	pooptype = null
	STACON = 13
	STASTR = 7
	STASPD = 9
	simple_detect_bonus = 20
	deaggroprob = 0
	food = 0
	attack_sound = list('sound/gore/flesh_eat_01.ogg','sound/gore/flesh_eat_02.ogg','sound/gore/flesh_eat_03.ogg')
	dodgetime = 30
	aggressive = 1
	remains_type = null
	eat_forever = TRUE
	var/chomp_cd = 0
	var/chomp_roll = 0
	ai_controller = /datum/ai_controller/volf
	move_base_delay = MOVEMENT_DELAY_SPD_3
	color = "#88ff7d"

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/AttackingTarget() //7+1d6 vs con to knock ppl down
	. = ..()
	if(. && prob(8) && iscarbon(target))
		var/mob/living/carbon/C = target
		if(world.time >= chomp_cd + 120 SECONDS) //they can do it Once basically
			chomp_roll = STASTR + (rand(0,6))
			if(chomp_roll > C.STACON)
				C.Knockdown(20)
				C.visible_message(
					span_danger("\The [src] chomps \the [C]'s legs, knocking them down!"),
					span_danger("\The [src] tugs me to the ground! I'm winded!")
				)
				C.adjustOxyLoss(10) //less punishing than zfall bc simplemob
				C.emote("gasp")
				playsound(C, 'sound/foley/zfall.ogg', 100, FALSE)
			else
				C.visible_message(span_danger("\The [src] fails to drag \the [C] down!"))
			chomp_cd = world.time

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/Initialize(mapload)
	. = ..()
	if(ai_controller)
		AddElement(/datum/element/ai_retaliate)
		AddElement(/datum/element/ai_flee_while_injured, 0.75, 0.4)
	gender = MALE
	if(prob(33))
		gender = FEMALE
	update_icon()
	if(ai_controller)
		ai_controller.set_blackboard_key(BB_BASIC_FOODS, food_type)

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/death(gibbed)
	..()
	update_icon()
	if(!QDELETED(src))
		AddComponent(/datum/component/deadite_animal_reanimation)

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/foley/gross.ogg')
		if("pain")
			return pick('sound/foley/butcher.ogg')
		if("death")
			return pick('sound/foley/bubb (1).ogg')
		if("idle")
			return pick('sound/foley/water_land2.ogg','sound/foley/water_land3.ogg')
		if("cidle")
			return pick('sound/foley/water_land2.ogg','sound/foley/water_land3.ogg')

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/taunted(mob/user)
	emote("aggro")
	ai_controller?.force_aggro(user)
	return

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/Life()
	..()
	if(pulledby)
		ai_controller?.force_aggro(pulledby)

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/pure_form
	name = "pure ooze"
	desc = "An amorphous remnant of a Murkling, formed from a lifeless body. Splash it with blessed water or red and watch as the body reforms."
	initial_language_holder = /datum/language_holder/pure_ooze
	icon = 'icons/roguetown/mob/ooze_blob.dmi'
	hud_type = /datum/hud/dextrous/oozeling
	rot_type = null
	botched_butcher_results = null
	butcher_results = null
	perfect_butcher_results = null
	guaranteed_butcher_results = null
	head_butcher = null
	melee_damage_lower = 0
	melee_damage_upper = 0
	aggressive = FALSE
	ai_controller = null
	dextrous = FALSE
	mobility_flags = MOBILITY_MOVE
	move_base_delay = 8
	speak_chance = 0
	emote_see = null
	emote_hear = null

	var/mob/living/carbon/human/origin_body
	var/flavortext_cached
	var/ooc_notes_cached
	var/headshot_artist_credit
	var/headshot_artist_link
	var/list/previous_languages
	var/previous_only_speaks_language
	var/previous_default_language

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/pure_form/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_PACIFISM, "[type]")
	ADD_TRAIT(src, TRAIT_SPELLCOCKBLOCK, "[type]")

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/pure_form/proc/enable_undercommon_only()
	var/datum/language_holder/language_holder = get_language_holder()
	previous_languages = language_holder.languages.Copy()
	previous_only_speaks_language = language_holder.only_speaks_language
	previous_default_language = language_holder.selected_default_language
	language_holder.grant_language(/datum/language/undercommon)
	language_holder.only_speaks_language = /datum/language/undercommon
	language_holder.selected_default_language = /datum/language/undercommon

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/pure_form/proc/restore_language_holder()
	var/datum/language_holder/language_holder = get_language_holder()
	language_holder.languages = previous_languages.Copy()
	language_holder.only_speaks_language = previous_only_speaks_language
	language_holder.selected_default_language = previous_default_language

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/pure_form/Destroy()
	REMOVE_TRAIT(src, TRAIT_PACIFISM, "[type]")
	REMOVE_TRAIT(src, TRAIT_SPELLCOCKBLOCK, "[type]")
	. = ..()

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/pure_form/death(gibbed)
	icon_state = icon_dead
	if(client)
		update_cone()
	. = ..()
	update_icon()
	playsound(src, 'sound/magic/splat.ogg', 50, TRUE)
	qdel(GetComponent(/datum/component/deadite_animal_reanimation))

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/pure_form/butcher(mob/living/user, on_meathook = FALSE)
	return FALSE

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/pure_form/gib(no_brain = FALSE, no_organs = FALSE, no_bodyparts = FALSE, drop_items = FALSE, leave_gibs = TRUE)
	return FALSE

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/pure_form/ClickOn(atom/A, params)
	var/list/modifiers = params2list(params)
	if(modifiers["shift"] && modifiers["left"] && !modifiers["right"] && !modifiers["middle"] && !modifiers["alt"] && !modifiers["ctrl"])
		ShiftClickOn(A)
	return TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/pure_form/attackby(obj/item/item, mob/user, params)
	if(istype(item, /obj/item/reagent_containers/glass/bottle))
		var/obj/item/reagent_containers/glass/bottle/bottle = item
		if(bottle.closed || !bottle.spillable)
			to_chat(user, span_warning("[bottle] is corked."))
			return
		user.visible_message(span_notice("[user] begins carefully splashing [bottle] onto [src]..."), span_notice("I begin carefully splashing [bottle] onto [src]..."))
		if(!do_after(user, 3 SECONDS, target = src))
			return
		if(QDELETED(bottle) || bottle.closed || !bottle.spillable)
			to_chat(user, span_warning("The bottle must remain uncorked."))
			return
		user.visible_message(span_danger("[user] splashes [bottle] onto [src]!"), span_danger("[user] splashes [bottle] onto you!"))
		if(!reconstitute_from_bottle(bottle))
			to_chat(user, span_warning("The ooze needs at least 30 units of health potion, strong health potion, holy water, or blessed water to reform."))
			return
		bottle.reagents.clear_reagents()
		return
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/pure_form/examine(mob/user)
	var/list/examine_text = ..()
	if(familiar_headshot_link && user.client?.prefs.chatheadshot && valid_headshot_link(src, familiar_headshot_link, TRUE))
		examine_text.Insert(2, "<img src=[familiar_headshot_link] width=100 height=100/>")
	if(flavortext_cached || ooc_notes_cached || familiar_headshot_link)
		examine_text.Insert(examine_text.len - 1, "<a href='?src=[REF(src)];task=view_pure_ooze'>Examine closer</a>")
	return examine_text

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/pure_form/Topic(href, href_list)
	if(href_list["task"] == "view_pure_ooze")
		if(!ismob(usr))
			return
		var/datum/examine_panel/examine_panel = new(src)
		examine_panel.holder = src
		examine_panel.viewing = usr
		examine_panel.ui_interact(usr)
		return
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob/pure_form/proc/reconstitute_from_bottle(obj/item/reagent_containers/glass/bottle/bottle)
	if(!bottle?.reagents || !origin_body)
		return FALSE

	var/has_enough_reagent = FALSE
	for(var/datum/reagent/reagent as anything in bottle.reagents.reagent_list)
		if(reagent.volume < 30)
			continue
		if(istype(reagent, /datum/reagent/medicine/healthpot) \
			|| istype(reagent, /datum/reagent/medicine/stronghealth) \
			|| istype(reagent, /datum/reagent/water/blessed))
			has_enough_reagent = TRUE
			break
	if(!has_enough_reagent)
		return FALSE

	var/datum/component/murkling_afterlife/afterlife = origin_body.GetComponent(/datum/component/murkling_afterlife)
	return afterlife?.reconstitute_body(src)
