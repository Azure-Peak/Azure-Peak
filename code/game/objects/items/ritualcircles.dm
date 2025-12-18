/obj/effect/decal/cleanable/roguerune/god
	var/allowed_patron
	can_be_scribed = FALSE
	magictype = "divine"
	icon_state = "ritual_base"
	icon = 'icons/roguetown/misc/rituals.dmi'
	layer = BELOW_OBJ_LAYER
	density = FALSE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/effect/decal/cleanable/roguerune/god/can_invoke(mob/living/user, list/invokers)
	. = ..()

	if(!.)
		return FALSE

	if(!istype(user.patron, allowed_patron))
		to_chat(user, span_smallred("I don't know the proper rites for this..."))
		return FALSE

	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user, span_smallred("I don't know the proper rites for this..."))
		return FALSE

	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user, span_smallred("I have performed enough rituals for the day... I must rest before communing more."))
		return FALSE

	return TRUE

/obj/structure/ritualcircle
	name = "ritual circle"
	desc = ""
	icon = 'icons/roguetown/misc/rituals.dmi'
	icon_state = "ritual_base"
	layer = BELOW_OBJ_LAYER
	density = FALSE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/allow_dreamwalkers = FALSE

/obj/structure/ritualcircle/attack_hand(mob/living/user)
	if(!allow_dreamwalkers && HAS_TRAIT(user, TRAIT_DREAMWALKER))
		to_chat(user, span_danger("Only the rune of stirring calls to me now..."))
		return FALSE
	return TRUE

/obj/structure/ritualcircle/attack_right(mob/living/carbon/human/user)
	user.visible_message(span_warning("[user] begins wiping away the rune"))
	if(do_after(user, 15))
		playsound(loc, 'sound/foley/cloth_wipe (1).ogg', 100, TRUE)
		qdel(src)

// This'll be our tutorial ritual for those who want to make more later, let's go into details in comments, mm? - Onutsio 
/obj/structure/ritualcircle/astrata
	name = "Rune of the Sun" // defines name of the circle itself
	icon_state = "astrata_chalky" // the icon state, so, the sprite the runes use on the floor. As of making, we have 6, each needs an active/inactive state. 
	desc = "A Holy Rune of Astrata. Warmth irradiates from the rune." // description on examine
	var/solarrites = list("Guiding Light") // This is important - This is the var which stores every ritual option available to a ritualist - Ideally, we'd have like, 3 for each God. Right now, just 1.

/obj/structure/ritualcircle/astrata/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/divine/astrata)
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("I don't know the proper rites for this...")) // You need ritualist to use them
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("I have performed enough rituals for the day... I must rest before communing more.")) // If you have already done a ritual in the last 30 minutes, you cannot do another.
		return
	var/riteselection = input(user, "Rituals of the Sun", src) as null|anything in solarrites // When you use a open hand on a rune, It'll give you a selection of all the rites available from that rune
	switch(riteselection) // rite selection goes in this section, try to do something fluffy. Presentation is most important here, truthfully.
		if("Guiding Light") // User selects Guiding Light, begins the stuff for it
			if(do_after(user, 50)) // just flavor stuff before activation
				user.say("I beseech the guidance of the Sun!!")
				if(do_after(user, 50))
					user.say("To bring Order to a world of naught!!")
					if(do_after(user, 50))
						user.say("Place your gaze upon me, oh Radiant one!!")
						to_chat(user,span_danger("You feel the eye of Astrata turned upon you. Her warmth dances upon your cheek. You feel yourself warming up...")) // A bunch of flavor stuff, slow incanting.
						icon_state = "astrata_active"
						if(!HAS_TRAIT(user, TRAIT_CHOSEN)) //Priests don't burst into flames.
							loc.visible_message(span_warning("[user]'s bursts to flames! Embraced by Her Warmth wholly!"))
							playsound(loc, 'sound/combat/hits/burn (1).ogg', 100, FALSE, -1)
							user.adjust_fire_stacks(10)
							user.ignite_mob()
							user.flash_fullscreen("redflash3")
							user.emote("firescream")
						guidinglight(src) // Actually starts the proc for applying the buff
						user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
						spawn(120)
							icon_state = "astrata_chalky"

/obj/structure/ritualcircle/astrata/proc/guidinglight(src)
	var/ritualtargets = view(7, loc) // Range of 7 from the source, which is the rune
	for(var/mob/living/carbon/human/target in ritualtargets) // defines the target as every human in this range
		target.apply_status_effect(/datum/status_effect/buff/guidinglight) // applies the status effect
		to_chat(target,span_cultsmall("Astrata's light guides me forward, drawn to me by the Ritualist's pyre!"))
		playsound(target, 'sound/magic/holyshield.ogg', 80, FALSE, -1) // Cool sound!
// If you want to review a more complicated one, Undermaiden's Bargain is probs the most complicated of the starting set. - Have fun! - Onutsio 🏳️‍⚧️


/obj/structure/ritualcircle/noc
	name = "Rune of the Moon"
	icon_state = "noc_chalky"
	desc = "A Holy Rune of Noc. Moonlight shines upon thee."
	var/lunarrites = list("Moonlight Dance") // list for more to be added later

/obj/structure/ritualcircle/noc/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/divine/noc)
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("I have performed enough rituals for the day... I must rest before communing more."))
		return
	var/riteselection = input(user, "Rituals of the Moon", src) as null|anything in lunarrites
	switch(riteselection) // put ur rite selection here
		if("Moonlight Dance")
			if(do_after(user, 50))
				user.say("I beseech the guidance of the Moon!!")
				if(do_after(user, 50))
					user.say("To bring Wisdom to a world of naught!!")
					if(do_after(user, 50))
						user.say("Place your gaze upon me, oh wise one!!")
						to_chat(user,span_cultsmall("The waning half of the Twin-God carries but one eye. With some effort, it can be drawn upon supplicants."))
						playsound(loc, 'sound/magic/holyshield.ogg', 80, FALSE, -1)
						moonlightdance(src)
						user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)

/obj/structure/ritualcircle/noc/proc/moonlightdance(src)
	var/ritualtargets = view(7, loc)
	for(var/mob/living/carbon/human/target in ritualtargets)
		target.apply_status_effect(/datum/status_effect/buff/moonlightdance)

/obj/structure/ritualcircle/xylix
	name = "Rune of Trickery"
	icon_state = "xylix_chalky"
	desc = "A Holy Rune of Xylix. You can hear the wind, and distant bells, in the distance."

/obj/effect/decal/cleanable/roguerune/god/ravox
	name = "Rune of Justice"
	icon_state = "ravox_chalky"
	desc = "A Holy Rune of Ravox. A blade to protect the weak with."
	allowed_patron = /datum/patron/divine/ravox
	rituals = list(/datum/runeritual/ravox_vow::name = /datum/runeritual/ravox_vow)

/datum/runeritual/ravox_vow
	name = "Vow to Ravox"

/datum/runeritual/ravox_vow/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	if(!do_after(user, 5 SECONDS))
		return FALSE

	user.say("My steel is sharp, my heart is true!")

	if(!do_after(user, 5 SECONDS))
		return FALSE

	user.say("For the weak, my blade I drew!")

	if(!do_after(user, 5 SECONDS))
		return FALSE

	user.say("Let foes of justice face my might!")

	if(!do_after(user, 3 SECONDS))
		return FALSE

	user.say("Ravox, guide my hand in righteous fight!")
	playsound(loc, 'sound/magic/holyshield.ogg', 80, FALSE, -1)
	
	user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
	user.apply_status_effect(/datum/status_effect/buff/ravox_vow)

	return TRUE

/obj/structure/ritualcircle/pestra
	name = "Rune of Plague"
	desc = "A Holy Rune of Pestra. A sickle to cleanse the weeds, and bring forth life."
	icon_state = "pestra_chalky"
	var/plaguerites = list("Flylord's Triage")


/obj/structure/ritualcircle/pestra/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/divine/pestra)
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("I have performed enough rituals for the day... I must rest before communing more."))
		return
	var/riteselection = input(user, "Rituals of Plague", src) as null|anything in plaguerites
	switch(riteselection) // put ur rite selection here
		if("Flylord's Triage")
			if(do_after(user, 50))
				user.say("Buboes, phlegm, blood and guts!!")
				if(do_after(user, 50))
					user.say("Boils, bogeys, rots and pus!!")
					if(do_after(user, 50))
						user.say("Blisters, fevers, weeping sores!!")
						to_chat(user,span_danger("You feel something crawling up your throat, humming and scratching..."))
						if(do_after(user, 30))
							icon_state = "pestra_active"
							user.say("From your wounds, the fester pours!!")
							to_chat(user,span_cultsmall("My devotion to the Plague Queen allowing, her servants crawl up from my throat. Come now, father fly..."))
							loc.visible_message(span_warning("[user] opens their mouth, disgorging a great swarm of flies!"))
							playsound(loc, 'sound/misc/fliesloop.ogg', 100, FALSE, -1)
							flylordstriage(src)
							user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
							spawn(120)
								icon_state = "pestra_chalky"

/obj/structure/ritualcircle/pestra/proc/flylordstriage(src)
	var/ritualtargets = view(0, loc)
	for(var/mob/living/carbon/human/target in ritualtargets)
		to_chat(target,span_userdanger("You feel them crawling into your wounds and pores. Their horrific hum rings through your ears as they do their work!"))
		target.flash_fullscreen("redflash3")
		target.emote("agony")
		target.Stun(200)
		target.Knockdown(200)
		to_chat(target, span_userdanger("UNIMAGINABLE PAIN!"))
		target.apply_status_effect(/datum/status_effect/buff/flylordstriage)

/obj/structure/ritualcircle/dendor
	name = "Rune of Beasts"
	desc = "A Holy Rune of Dendor. Becoming one with nature is to connect with ones true instinct."
	icon_state = "dendor_chalky"
	var/bestialrites = list("Rite of the Lesser Wolf")

/obj/structure/ritualcircle/dendor/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/divine/dendor)
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("I have performed enough rituals for the day... I must rest before communing more."))
		return
	var/riteselection = input(user, "Rituals of Beasts", src) as null|anything in bestialrites
	switch(riteselection) // put ur rite selection here
		if("Rite of the Lesser Wolf")
			if(do_after(user, 50))
				user.say("RRRGH GRRRHHHG GRRRRRHH!!")
				playsound(loc, 'sound/vo/mobs/vw/idle (1).ogg', 100, FALSE, -1)
				if(do_after(user, 50))
					user.say("GRRRR GRRRRHHHH!!")
					playsound(loc, 'sound/vo/mobs/vw/idle (4).ogg', 100, FALSE, -1)
					if(do_after(user, 50))
						loc.visible_message(span_warning("[user] snaps and snarls at the rune. Drool runs down their lip..."))
						playsound(loc, 'sound/vo/mobs/vw/bark (1).ogg', 100, FALSE, -1)
						if(do_after(user, 30))
							icon_state = "dendor_active"
							loc.visible_message(span_warning("[user] snaps their head upward, they let out a howl!"))
							playsound(loc, 'sound/vo/mobs/wwolf/howl (2).ogg', 100, FALSE, -1)
							lesserwolf(src)
							user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
							spawn(120)
								icon_state = "dendor_chalky"

/obj/structure/ritualcircle/dendor/proc/lesserwolf(src)
	var/ritualtargets = view(1, loc)
	for(var/mob/living/carbon/human/target in ritualtargets)
		target.apply_status_effect(/datum/status_effect/buff/lesserwolf)


/obj/structure/ritualcircle/malum
	name = "Rune of Forge"
	desc = "A Holy Rune of Malum. A hammer and heat, to fix any imperfections with."
	icon_state = "malum_chalky"
	var/forgerites = list("Ritual of Blessed Reforgance")

/obj/structure/ritualcircle/malum/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/divine/malum)
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("I have performed enough rituals for the day... I must rest before communing more."))
		return
	var/riteselection = input(user, "Rituals of Creation", src) as null|anything in forgerites
	switch(riteselection) // put ur rite selection here
		if("Ritual of Blessed Reforgance")
			if(do_after(user, 50))
				user.say("God of craft and heat of the forge!!")
				if(do_after(user, 50))
					user.say("Take forth these metals and rebirth them in your furnaces!")
					if(do_after(user, 50))
						user.say("Grant unto me the metals in which to forge great works!")
						to_chat(user,span_danger("You feel a sudden heat rising within you, burning within your chest.."))
						if(do_after(user, 30))
							icon_state = "malum_active"
							user.say("From your forge, may these creations be remade!!")
							loc.visible_message(span_warning("A wave of heat rushes out from the ritual circle before [user]. The metal is reforged in a flash of light!"))
							playsound(loc, 'sound/magic/churn.ogg', 100, FALSE, -1)
							holyreforge(src)
							user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
							spawn(120)
								icon_state = "malum_chalky"

/obj/structure/ritualcircle/malum/proc/holyreforge(src)
	var/ritualtargets = view(7, loc)
	for(var/mob/living/carbon/human/target in ritualtargets)
		target.flash_fullscreen("whiteflash") //Cool effect!
	for (var/obj/item/ingot/silver/I in loc)
		qdel(I)
		new /obj/item/ingot/silverblessed(loc)
	for (var/obj/item/ingot/steel/I in loc)
		qdel(I)
		new /obj/item/ingot/steelholy(loc)

/obj/structure/ritualcircle/abyssor
	name = "Rune of Storm"
	desc = "A Holy Rune of Abyssor. You sense your mind getting pulled into the drawn spiral."
	icon_state = "abyssor_chalky"
	var/stormrites = list("Rite of the Tides")

/obj/structure/ritualcircle/abyssor_alt
	name = "Rune of Stirring"
	desc = "A Holy Rune of Abyssor. This one seems different to the rest. Something observes."
	icon_state = "abyssoralt_active"

/obj/structure/ritualcircle/abyssor_alt_inactive
	name = "Rune of Stirring"
	desc = "A Holy Rune of Abyssor. This one seems different to the rest. Something observes."
	icon_state = "abyssoralt_chalky"
	allow_dreamwalkers = TRUE
	var/stirringrites = list("Rite of the Crystal Spire")
	var/list/dreamwalker_rites = list("Rite of Dreamcraft")

// Ritual implementation
/obj/structure/ritualcircle/abyssor_alt_inactive/attack_hand(mob/living/user)
	if(!..())
		return
	// Allow both Abyssorites and Dreamwalkers to use the rune
	if((user.patron?.type) != /datum/patron/divine/abyssor && !HAS_TRAIT(user, TRAIT_DREAMWALKER))
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("I have performed enough rituals for the day... I must rest before communing more."))
		return

	// Build available rites based on user's status
	var/list/available_rites = list()

	// Abyssorites get access to stirring rites
	if(user.patron?.type == /datum/patron/divine/abyssor)
		available_rites += stirringrites

		// Time check for Rite of the Crystal Spire
		var/time_elapsed = STATION_TIME_PASSED() / (1 MINUTES)
		if(time_elapsed < 30 && ("Rite of the Crystal Spire" in available_rites))
			var/time_left = 30 - time_elapsed
			to_chat(user, span_smallred("The veil is too thin to summon crystal spires. Wait another [round(time_left, 0.1)] minutes."))
			available_rites -= "Rite of the Crystal Spire"

	if(HAS_TRAIT(user, TRAIT_DREAMWALKER))
		available_rites += dreamwalker_rites

	if(!length(available_rites))
		to_chat(user,span_smallred("No rites are currently available."))
		return

	var/riteselection = input(user, "Rites of his dream", src) as null|anything in available_rites
	switch(riteselection)
		if("Rite of the Crystal Spire")
			if(do_after(user, 50))
				user.say("Deep Father, hear my call!")
				if(do_after(user, 50))
					user.say("From the Abyss, split the earth!")
					if(do_after(user, 50))
						icon_state = "abyssoralt_active"
						user.say("Let your tempest chase away the craven ones!")
						to_chat(user, span_cultsmall("A crystalline shard forms at the center of the rune, humming with Abyssor's power."))
						new /obj/item/abyssal_marker(loc)
						user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
						spawn(240)
							icon_state = "abyssoralt_chalky"
		if("Rite of Dreamcraft")
			if(!HAS_TRAIT(user, TRAIT_DREAMWALKER))
				return

			var/list/weapon_options = list(
				"Dreamreaver Greataxe" = image(icon = 'icons/roguetown/weapons/64.dmi', icon_state = "dreamaxe"),
				"Harmonious Spear" = image(icon = 'icons/roguetown/weapons/64.dmi', icon_state = "dreamspear"),
				"Oozing Sword" = image(icon = 'icons/roguetown/weapons/64.dmi', icon_state = "dreamsword"),
				"Thunderous Trident" = image(icon = 'icons/roguetown/weapons/64.dmi', icon_state = "dreamtri")
			)

			var/choice = show_radial_menu(user, src, weapon_options, require_near = TRUE, tooltips = TRUE)
			if(!choice)
				return
			if(!do_after(user, 5 SECONDS))
				return
			user.say("DREAM! DREAM! MANIFEST MY VISION!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("DREAM! DREAM! BEND TO MY WILL!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("DREAM! DREAM! FORGE MY WEAPON!!")
			if(!do_after(user, 5 SECONDS))
				return

			icon_state = "abyssoralt_active"
			user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
			dreamarmor(user)
			dreamcraft_weapon(user, choice)
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				if(H.mind)
					H.mind.special_role = "dreamwalker"
			spawn(240)
				icon_state = "abyssoralt_chalky"

/obj/structure/ritualcircle/abyssor_alt_inactive/proc/dreamcraft_weapon(mob/living/user, choice)
	var/obj/item/new_weapon
	var/datum/skill/skill_to_teach

	switch(choice)
		if("Harmonious Spear")
			new_weapon = new /obj/item/rogueweapon/halberd/glaive/dreamscape(user.loc)
			skill_to_teach = /datum/skill/combat/polearms
		if("Oozing Sword")
			new_weapon = new /obj/item/rogueweapon/greatsword/bsword/dreamscape(user.loc)
			skill_to_teach = /datum/skill/combat/swords
		if("Dreamreaver Greataxe")
			new_weapon = new /obj/item/rogueweapon/greataxe/dreamscape(user.loc)
			skill_to_teach = /datum/skill/combat/axes
		if("Thunderous Trident")
			new_weapon = new /obj/item/rogueweapon/spear/dreamscape_trident(user.loc)
			skill_to_teach = /datum/skill/combat/polearms

	if(new_weapon)
		user.put_in_hands(new_weapon)
		to_chat(user, span_warning("The dream solidifies into a [choice]!"))

		var/current_skill = user.get_skill_level(skill_to_teach)
		var/current_athletics = user.get_skill_level(/datum/skill/misc/athletics)
		if(current_skill < 4)
			user.adjust_skillrank_up_to(skill_to_teach, 4)
			to_chat(user, span_notice("Knowledge of [skill_to_teach.name] floods your mind!"))
		if(current_athletics < 6)
			user.adjust_skillrank_up_to(/datum/skill/misc/athletics, 6)
			to_chat(user, span_notice("Your endurance swells!"))
	else
		to_chat(user, span_warning("The dream fails to take shape."))

/obj/structure/ritualcircle/abyssor_alt_inactive/proc/dreamarmor(mob/living/carbon/human/target)
	if(!HAS_TRAIT(target, TRAIT_DREAMWALKER))
		loc.visible_message(span_cult("THE RITE REJECTS ONE WHO DOES NOT BEND THE DREAMS TO THEIR WILL."))
		return
	target.Stun(60)
	target.Knockdown(60)
	to_chat(target, span_userdanger("UNIMAGINABLE PAIN!"))
	target.emote("Agony")
	playsound(loc, 'sound/combat/newstuck.ogg', 50)
	loc.visible_message(span_cult("Ethereal tendrils emerge from the rune, wrapping around [target]'s body. Their form shifts and warps as dream-stuff solidifies into armor."))
	spawn(20)
		playsound(loc, 'sound/combat/hits/onmetal/grille (2).ogg', 50)
		target.equipOutfit(/datum/outfit/job/roguetown/dreamwalker_armorrite)
		spawn(40)
			to_chat(target, span_purple("Reality is but a fragile dream. You are the dreamer, and your will is law."))

/obj/structure/ritualcircle/abyssor/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/divine/abyssor)
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("I have performed enough rituals for the day... I must rest before communing more."))
		return
	var/riteselection = input(user, "Rite of the Tides", src) as null|anything in stormrites
	switch(riteselection)
		if("Rite of the Tides")
			if(do_after(user, 50))
				user.say("Deep Father, hear my call!")
				if(do_after(user, 50))
					user.say("I beg thee! A deluge upon your annointed!")
					if(do_after(user, 50))
						icon_state = "abyssor_active"
						user.say("Let your waters swallow the land!")
						to_chat(user, span_cultsmall("A crystalline shard forms at the center of the rune, humming with Abyssor's power."))
						new /obj/item/abyssal_marker/tidal(loc)
						user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
						spawn(240)
							icon_state = "abyssor_chalky"

/obj/item/abyssal_marker
	name = "abyssal marker"
	desc = "A pulsating crystal shard that hums with otherworldly energy."
	icon = 'icons/roguetown/misc/rituals.dmi'
	icon_state = "abyssal_marker"
	w_class = WEIGHT_CLASS_SMALL
	var/turf/marked_location
	var/effect_desc = " Use in-hand to mark a location, then activate it to break the barrier between the dream and this realm where you put a mark down earlier. You recall the teachings of your Hierophant... these things are dangerous to all."
	var/obj/rune_type = /obj/structure/active_abyssor_rune
	var/faith_locked = TRUE
	var/obj/upgraded_rune_type = /obj/structure/active_abyssor_rune/greater

/obj/item/abyssal_marker/volatile
	name = "volatile abyssal marker"
	effect_desc = " Whispers fill your head. The crystal yearns to be used, it shall bring forth a beautiful dream. The first use shall mark, the second shall unleash. Seems fragile, like it might explode violently with energies when thrown..."
	faith_locked = FALSE
	icon_state = "abyssal_marker_volatile"
	var/cooldown = 0
	var/creation_time

/obj/item/abyssal_marker/tidal
	name = "tidal abyssal marker"
	desc = "A pulsating crystal shard that hums with the power of the deep. It feels wet to the touch."
	icon_state = "abyssal_marker_tidal"
	effect_desc = " Use in-hand to mark a location, then activate it to break the barrier between the dream and this realm where you put a mark down earlier. This one calls forth the tidal waters of the abyss."
	rune_type = /obj/structure/active_abyssor_rune/tidal
	upgraded_rune_type = null

/obj/item/abyssal_marker/volatile/Initialize()
	. = ..()
	creation_time = world.time
	var/area/A = get_area(src)
	if(istype(A, /area/rogue/underworld/dream))
		cooldown = 3 MINUTES

/obj/item/abyssal_marker/volatile/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(cooldown > 0 && world.time < creation_time + cooldown)
		visible_message(span_warning("[src] bounces off the floor. It doesn't seem ready yet."))
		return ..()

	var/turf/T = get_turf(hit_atom)
	if(T)
		marked_location = T
		visible_message(span_warning("[src] shatters on impact!"))
		playsound(src, 'sound/magic/lightning.ogg', 50, TRUE)
		var/mob/thrower = throwingdatum?.thrower
		if(thrower && HAS_TRAIT(thrower, TRAIT_HERESIARCH) && upgraded_rune_type)
			rune_type = upgraded_rune_type
		new rune_type(T)
		qdel(src)
	else
		return ..()

/obj/item/abyssal_marker/examine(mob/user)
	. = ..()
	if(iscarbon(user))
		var/mob/living/carbon/c = user
		if(c.patron.type == /datum/patron/divine/abyssor || !faith_locked)
			. += span_info(effect_desc)

/obj/item/abyssal_marker/attack_self(mob/user)
	if(iscarbon(user))
		var/mob/living/carbon/c = user
		if(c.patron.type != /datum/patron/divine/abyssor && faith_locked)
			to_chat(user, span_warning("My connection to Abyssor's dream is too weak to invoke his power with this crystal."))
			return ..()
		//Heretics get FAR stronger spires!
		if(HAS_TRAIT(user, TRAIT_HERESIARCH) && upgraded_rune_type)
			rune_type = upgraded_rune_type
	if(do_after(user, 2 SECONDS) && !marked_location)
		marked_location = get_turf(user)
		to_chat(user, span_notice("You charge the crystal with the essence of this location."))
		playsound(src, 'sound/magic/vlightning.ogg', 50, TRUE)
	else if (marked_location)
		user.visible_message(span_warning("[user] crushes the [src] in their hands!"))
		playsound(src, 'sound/magic/lightning.ogg', 50, TRUE)
		new rune_type(marked_location)
		qdel(src)

/obj/item/abyssal_marker/volatile/attack_self(mob/user)
	if(cooldown > 0 && world.time < creation_time + cooldown)
		to_chat(user, span_warning("The crystal is still unstable. It needs more time to attune to this realm. Try again later."))
		return
	return ..()

/obj/structure/active_abyssor_rune
	name = "awakened abyssal rune"
	desc = "A violently pulsating rune emitting storm energy."
	icon = 'icons/roguetown/misc/rituals.dmi'
	icon_state = "abyssoralt_active"
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	density = FALSE
	light_outer_range = 3
	light_color = LIGHT_COLOR_BLUE
	var/spawn_time = 10 SECONDS
	var/obj/spire_type = /obj/structure/crystal_spire

/obj/structure/active_abyssor_rune/tidal
	spire_type = /obj/structure/crystal_spire/tidal
	icon_state = "abyssor_active"

/obj/structure/active_abyssor_rune/greater
	spire_type = /obj/structure/crystal_spire/greater

/obj/structure/active_abyssor_rune/Initialize()
	. = ..()
	addtimer(CALLBACK(src, .proc/spawn_spire), spawn_time)
	src.visible_message(span_userdanger("A glowing, pulsating rune etches itself into the ground. Reality cracks visibly around it! Something is coming!"))

/obj/structure/active_abyssor_rune/proc/spawn_spire()
	new spire_type(get_turf(src))

#define ABYSSAL_GLOW_FILTER "abyssal_glow"

// Crystal Spire Structure
/obj/structure/crystal_spire
	name = "crystal spire"
	desc = "A massive crystalline structure pulsing with abyssal energy. Dark ice spreads from its base."
	icon = 'icons/roguetown/misc/rituals.dmi'
	icon_state = "crystal_spire"
	anchored = TRUE
	density = TRUE
	resistance_flags = FIRE_PROOF | ACID_PROOF
	max_integrity = 500
	var/current_radius = 1
	var/max_radius = 4
	var/fiend_count = 0
	var/max_fiends = 3
	// Holds all the turf data so it can be unconverted.
	var/list/turf_data = list()
	var/expansion_timer = 3 MINUTES
	var/next_expansion_time = 0
	var/spawn_timer = 45 SECONDS
	var/next_fiend_time = 0
	var/awakened = FALSE
	var/converting = FALSE
	var/turf_to_use = /turf/open/floor/rogue/dark_ice
	var/mob/living/initial_fiend = /mob/living/simple_animal/hostile/rogue/dreamfiend/major/unbound
	pixel_y = 8

/obj/structure/crystal_spire/greater
	name = "greater crystal spire"
	initial_fiend = /mob/living/simple_animal/hostile/rogue/dreamfiend/ancient/unbound
	max_integrity = 1000
	max_radius = 5
	max_fiends = 7

/obj/structure/crystal_spire/tidal
	name = "tidal spire"
	desc = "A massive crystalline structure pulsing with abyssal energy. Salt water spreads from its base."
	icon_state = "crystal_spire_tidal"
	max_integrity = 300
	max_fiends = 0
	turf_to_use = /turf/open/water/ocean/deep

/obj/structure/crystal_spire/Initialize()
	. = ..()
	spawn_fiends(1, initial_fiend)
	
	next_fiend_time = world.time + spawn_timer
	next_expansion_time = world.time + expansion_timer

	var/turf/T = loc
	turf_data[T] = T.type
	T.ChangeTurf(turf_to_use, flags = CHANGETURF_IGNORE_AIR)

	START_PROCESSING(SSobj, src)

/obj/structure/crystal_spire/tidal/spawn_fiends(amount, mob/living/fiend_type)
	return

/obj/structure/crystal_spire/process()
	if(world.time >= next_fiend_time)
		spawn_fiends(1)
		next_fiend_time = world.time + spawn_timer

	if(world.time >= next_expansion_time && current_radius < max_radius || !awakened)
		if(!awakened)
			awakened = TRUE
		expand_radius()
		next_expansion_time = world.time + expansion_timer

/obj/structure/crystal_spire/tidal/process()
	if(world.time >= next_expansion_time && current_radius < max_radius || !awakened)
		if(!awakened)
			awakened = TRUE
		expand_radius()
		next_expansion_time = world.time + expansion_timer

/obj/structure/crystal_spire/Destroy()
	for(var/turf/T in turf_data)
		T.ChangeTurf(turf_data[T], flags = CHANGETURF_IGNORE_AIR)
	turf_data.Cut()

	for(var/obj/structure/active_abyssor_rune/R in range(1, src))
		qdel(R)

	src.visible_message(span_danger("The spire shatters with a painful ringing. In an instant the dream recedes back to Abyssor's realm, restoring the world as it was."))
	STOP_PROCESSING(SSobj, src)
	playsound(src, 'sound/foley/glassbreak.ogg', 50, TRUE)
	new /obj/effect/particle_effect/smoke(src.loc)

	var/list/witnesses = view(7, src)
	for(var/mob/living/carbon/human/H in witnesses)
		teleport_to_dream(H, 1000, 1)

	return ..()

/obj/structure/crystal_spire/proc/start_conversion()
	converting = TRUE
	resistance_flags |= INDESTRUCTIBLE
	
	add_filter(ABYSSAL_GLOW_FILTER, 2, list("type" = "outline", "color" = "#6A0DAD", "alpha" = 0, "size" = 2))
	update_icon()

/obj/structure/crystal_spire/proc/end_conversion()
	converting = FALSE
	resistance_flags &= ~INDESTRUCTIBLE

	remove_filter(ABYSSAL_GLOW_FILTER)
	update_icon()

#undef ABYSSAL_GLOW_FILTER

/obj/structure/crystal_spire/proc/convert_surroundings()
	start_conversion()
	var/turf/center = get_turf(src)
	var/radius_sq = current_radius * current_radius

	for(var/turf/T in spiral_range_turfs(current_radius, center))
		// Skip if already converted
		if(istype(T, /turf/open/floor/rogue/dark_ice))
			continue
	
		// Calculate distance from center
		// P.S I hate math :)
		var/dx = abs(T.x - center.x)
		var/dy = abs(T.y - center.y)
		var/dist_sq = dx*dx + dy*dy

		// Skip corners with higher probability
		var/is_corner = (dx == dy) || (dx == current_radius && dy == current_radius)
		if(is_corner && prob(60))
			continue

		// Skip random tiles (10% chance)
		if(prob(10))
			continue

		// Only convert tiles within circular radius
		if(dist_sq <= radius_sq)
			turf_data[T] = T.type
			T.ChangeTurf(/turf/open/floor/rogue/dark_ice, flags = CHANGETURF_IGNORE_AIR)
			playsound(T, 'sound/magic/fleshtostone.ogg', 30, TRUE)
			sleep(10)

	end_conversion()

/obj/structure/crystal_spire/tidal/convert_surroundings()
	start_conversion()
	var/turf/center = get_turf(src)
	var/radius_sq = current_radius * current_radius

	for(var/turf/T in spiral_range_turfs(current_radius, center))
		// Skip if already converted
		// Additionally, we don't want this to be a reliable breaching tool, so ignore dense stuff and open spaces!
		if(istype(T, turf_to_use))
			continue
		if(T.density)
			continue
		if(istransparentturf(T))
			continue

		// Calculate distance from center
		var/dx = abs(T.x - center.x)
		var/dy = abs(T.y - center.y)
		var/dist_sq = dx*dx + dy*dy

		// Convert all tiles within circular radius. More circular than normal spires.
		if(dist_sq <= radius_sq)
			turf_data[T] = T.type
			T.ChangeTurf(turf_to_use, flags = CHANGETURF_IGNORE_AIR)
			playsound(T, 'sound/magic/fleshtostone.ogg', 30, TRUE)
			//Faster since it's less harmful.
			sleep(5)

	// Stop processing if fully expanded
	if(current_radius >= max_radius)
		STOP_PROCESSING(SSobj, src)
	end_conversion()

/obj/structure/crystal_spire/proc/expand_radius()
	if(current_radius >= max_radius)
		return

	current_radius++
	convert_surroundings()

/obj/structure/crystal_spire/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir, armour_penetration)
	if(converting)
		visible_message(span_warning("The spire pulses with abyssal energy, deflecting the attack!"))
		playsound(src, 'sound/magic/repulse.ogg', 50, TRUE)
		return FALSE
	return ..()

/obj/structure/crystal_spire/proc/spawn_spire_fiend(turf/spawn_turf, obj/structure/crystal_spire/spire, mob/living/fiend_type = /mob/living/simple_animal/hostile/rogue/dreamfiend/unbound)
	if(!spawn_turf || !spire || !ispath(fiend_type))
		return FALSE

	var/mob/living/F = new fiend_type(spawn_turf)
	F.visible_message(span_danger("[F] manifests, countless teeth bared in hostility towards all life!"))

	var/datum/component/comp = F.AddComponent(/datum/component/spire_fiend, spire)
	return comp ? TRUE : FALSE

/obj/structure/crystal_spire/proc/spawn_fiends(amount, mob/living/fiend_type = /mob/living/simple_animal/hostile/rogue/dreamfiend/unbound)
	if(fiend_count >= max_fiends)
		return

	for(var/i in 1 to amount)
		if(fiend_count >= max_fiends)
			break

		var/turf/T = find_safe_spawn()
		if(T && spawn_spire_fiend(T, src, fiend_type))
			fiend_count++

/obj/structure/crystal_spire/proc/find_safe_spawn(outer_tele_radius = 3, inner_tele_radius = 2, include_dense = FALSE, include_teleport_restricted = FALSE)
	var/turf/target_turf = get_turf(src)
	var/list/turfs = list()

	for(var/turf/T in range(target_turf, outer_tele_radius))
		if(T in range(target_turf, inner_tele_radius))
			continue
		if(istransparentturf(T))
			continue
		if(T.density && !include_dense)
			continue
		if(T.teleport_restricted && !include_teleport_restricted)
			continue
		if(T.x>world.maxx-outer_tele_radius || T.x<outer_tele_radius)
			continue
		if(T.y>world.maxy-outer_tele_radius || T.y<outer_tele_radius)
			continue
		turfs += T

	if(!length(turfs))
		for(var/turf/T in orange(target_turf, outer_tele_radius))
			if(!(T in orange(target_turf, inner_tele_radius)))
				turfs += T

	if(!length(turfs))
		return null

	return pick(turfs)

/obj/structure/crystal_spire/proc/fiend_died()
	fiend_count = max(fiend_count - 1, 0)

/datum/component/spire_fiend
	var/obj/structure/crystal_spire/linked_spire

/datum/component/spire_fiend/Initialize(obj/structure/crystal_spire/spire)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	linked_spire = spire
	RegisterSignal(parent, COMSIG_LIVING_DEATH, .proc/on_death)

/datum/component/spire_fiend/proc/on_death()
	SIGNAL_HANDLER
	if(linked_spire)
		linked_spire.fiend_died()
	qdel(src)

/obj/structure/ritualcircle/necra
	name = "Rune of Death"
	desc = "A Holy Rune of Necra. Quiet acceptance stirs within you."
	icon_state = "necra_chalky"
	var/deathrites = list("Undermaiden's Bargain", "Vow to the Undermaiden", "The Toll")
	var/coinslot = 0


/obj/structure/ritualcircle/necra/examine(mob/user)
	. = ..()
	if(coinslot)
		. += "</br>The circle has been sprinkled with [coinslot] toll coins..."

/obj/structure/ritualcircle/necra/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(istype(I, /obj/item/thetoll))
		loc.visible_message(span_warning("[user] begins to break [I] over the ritual circle..."))
		if(do_after(user, 50))
			loc.visible_message(span_warning("[user] shatters [I] over the ritual circle..."))
			coinslot += 1
			qdel(I)

/obj/structure/ritualcircle/necra/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/divine/necra)
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("I have performed enough rituals for the day... I must rest before communing more."))
		return
	var/riteselection = input(user, "Rituals of Death", src) as null|anything in deathrites
	switch(riteselection) // put ur rite selection here
		if("Undermaiden's Bargain")
			loc.visible_message(span_warning("[user] sways before the rune, they open their mouth, though no words come out..."))
			playsound(user, 'sound/vo/mobs/ghost/whisper (3).ogg', 100, FALSE, -1)
			if(do_after(user, 60))
				loc.visible_message(span_warning("[user] silently weeps, yet their tears do not flow..."))
				playsound(user, 'sound/vo/mobs/ghost/whisper (1).ogg', 100, FALSE, -1)
				if(do_after(user, 60))
					loc.visible_message(span_warning("[user] locks up, as though someone had just grabbed them..."))
					to_chat(user,span_danger("You feel cold breath on the back of your neck..."))
					playsound(user, 'sound/vo/mobs/ghost/death.ogg', 100, FALSE, -1)
					if(do_after(user, 20))
						icon_state = "necra_active"
						user.say("Forgive me, the bargain is intoned!!")
						to_chat(user,span_cultsmall("My devotion to the Undermaiden has allowed me to strike a bargain for these souls...."))
						playsound(loc, 'sound/vo/mobs/ghost/moan (1).ogg', 100, FALSE, -1)
						undermaidenbargain(src)
						user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
						spawn(120)
							icon_state = "necra_chalky"
		if("Vow to the Undermaiden")
			loc.visible_message(span_warning("[user] sways before the rune, they open their mouth, though no words come out..."))
			playsound(user, 'sound/vo/mobs/ghost/whisper (3).ogg', 100, FALSE, -1)
			if(do_after(user, 60))
				loc.visible_message(span_warning("[user] silently weeps, yet their tears do not flow..."))
				playsound(user, 'sound/vo/mobs/ghost/whisper (1).ogg', 100, FALSE, -1)
				if(do_after(user, 60))
					loc.visible_message(span_warning("[user] locks up, as though someone had just grabbed them..."))
					to_chat(user,span_danger("You feel cold breath on the back of your neck..."))
					playsound(user, 'sound/vo/mobs/ghost/death.ogg', 100, FALSE, -1)
					if(do_after(user, 20))
						icon_state = "necra_active"
						user.say("This soul pledges themselves to thee!!")
						to_chat(user,span_cultsmall("My devotion to the Undermaiden has allowed me to anoint a vow for this soul...."))
						if(undermaidenvow(src))
							playsound(loc, 'sound/vo/mobs/ghost/moan (1).ogg', 100, FALSE, -1)
							user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
							spawn(120)
								icon_state = "necra_chalky"
						else
							loc.visible_message(span_warning("Then... nothing. The Undermaiden does not care for the vows of the damned, or those of other faiths."))
		if("The Toll")
			if(!coinslot)
				to_chat("This rite requires the toll to be prepared...")
				return
			var/onrune = view(1, loc)
			var/list/folksonrune = list()
			for(var/mob/living/carbon/human/persononrune in onrune) 
				if(persononrune.stat == DEAD)
					folksonrune += persononrune
			var/target = input(user, "Choose a supplicant") as null|anything in folksonrune
			if(target)
				loc.visible_message(span_warning("[user] draws spectral strands of Lux up through the air, tearing the veil between lyfe and death!"))
				playsound(user, 'sound/vo/mobs/ghost/whisper (3).ogg', 100, FALSE, -1)
				if(do_after(user, 60))
					playsound(user, 'sound/vo/mobs/ghost/whisper (1).ogg', 100, FALSE, -1)
					if(do_after(user, 60))
						loc.visible_message(span_warning("[user] moves their lips but no words can be heard, speaking to a massive spectral figure on the other side!"))
						playsound(user, 'sound/vo/mobs/ghost/death.ogg', 100, FALSE, -1)
						if(do_after(user, 20))
							icon_state = "necra_active"
							user.say("For this toll, a soul!!")
							to_chat(user,span_cultsmall("[user] grasps the strands of Lux and attempts to pull a soul through the rift!"))
							thetoll(target, user)
							spawn(120)
								icon_state = "necra_chalky"



/obj/structure/ritualcircle/necra/proc/thetoll(mob/living/carbon/human/target, mob/living/user)
	var/revive_pq = PQ_GAIN_REVIVE
	if(!target.mind) // run the revive, but in ritual form!
		to_chat(user, "This one is inert.")
		return
	if(!target.mind.active)
		to_chat(user, "Necra is not done with [target], yet.")
		return
	if(target.mob_biotypes & MOB_UNDEAD) //positive energy harms the undead
		target.visible_message(span_danger("[target] is unmade by divine magic! The Toll is accepted, and [target] is dragged to ever-death!"), span_userdanger("I'm unmade by divine magic!"))
		target.gib()
		return
	if(alert(target, "A Toll is being offered for your soul, BREAK FREE?", "Revival", "I need to wake up", "Don't let me go") != "I need to wake up")
		target.visible_message(span_notice("Nothing happens. They are not being let go."))
		return
	target.adjustOxyLoss(-target.getOxyLoss()) //Ye Olde CPR
	if(!target.revive(full_heal = FALSE))
		to_chat(user, span_warning("Nothing happens."))
		return
	var/mob/living/carbon/spirit/underworld_spirit = target.get_spirit()
	if(underworld_spirit)
		var/mob/dead/observer/ghost = underworld_spirit.ghostize()
		qdel(underworld_spirit)
		ghost.mind.transfer_to(target, TRUE)
	target.grab_ghost(force = TRUE)
	target.emote("breathgasp")
	target.Jitter(100)
	target.update_body()
	target.visible_message(span_notice("[target] JUMPS AWAKE! Spirits nearly break free from their shackles as they look for a exit in [target]!"), span_green("I BARELY MANAGED TO GET PAST OTHER DESPERATE SPIRITS TO MY EMPTY BODY... IT IS SO COLD"))
	if(revive_pq && !HAS_TRAIT(target, TRAIT_IWASREVIVED) && user?.ckey)
		adjust_playerquality(revive_pq, user.ckey)
		ADD_TRAIT(target, TRAIT_IWASREVIVED, "[type]")
	target.mind.remove_antag_datum(/datum/antagonist/zombie)
	target.remove_status_effect(/datum/status_effect/debuff/rotted_zombie)
	target.apply_status_effect(/datum/status_effect/debuff/revived)
	target.apply_status_effect(/datum/status_effect/buff/healing, 14)
	target.add_stress(/datum/stressevent/necrarevive)
	src.coinslot -= 1 // -1 coin, please insert more coins.
	user.apply_status_effect(/datum/status_effect/debuff/ritesexpended) // only after a succesful revive

/obj/structure/ritualcircle/necra/proc/undermaidenbargain(src)
	var/ritualtargets = view(7, loc)
	for(var/mob/living/carbon/human/target in ritualtargets)
		target.apply_status_effect(/datum/status_effect/buff/undermaidenbargain)
	
/obj/structure/ritualcircle/necra/proc/undermaidenvow(src)
	var/ritualtargets = view(1, loc)
	for(var/mob/living/carbon/human/target in ritualtargets)
		if(HAS_TRAIT(target, TRAIT_ROTMAN) || HAS_TRAIT(target, TRAIT_NOBREATH) || target.mob_biotypes & MOB_UNDEAD)	//No Undead, no Rotcured, no Deathless
			return FALSE
		if(target.patron.type != /datum/patron/divine/necra)
			return FALSE
		target.apply_status_effect(/datum/status_effect/buff/necras_vow)
		target.apply_status_effect(/datum/status_effect/buff/healing/necras_vow)
		return TRUE
	return FALSE


/obj/item/soulthread
	name = "lux-thread"
	desc = "Eerie glowing thread, cometh from the grave"
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "luxthread"
	var/strungtogether = 1
	sellprice = 3
	grid_width = 32
	grid_height = 32


/obj/item/soulthread/examine(mob/user)
	. = ..()
	. += "</br>[strungtogether] threads are gathered of 10..."

/obj/item/soulthread/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/soulthread))
		var/obj/item/soulthread/thread2combine = attacking_item
		strungtogether += thread2combine.strungtogether
		sellprice += 3
		to_chat(user, "...[strungtogether] of 10 to the toll...")
		qdel(thread2combine)
	if(strungtogether >= 10)
		to_chat(user, "The lux-stuff coalesces into a toll!")
		new /obj/item/thetoll((get_turf(user)))
		qdel(src)

/obj/item/thetoll
	grid_width = 32
	grid_height = 32
	name = "toll"
	desc = "Proof of ten souls being sent to Necra, formed of a material that is not metal, constantly weeping a minute amount of blood. Ten souls for one, the Ferryman may send one back before Necra fully has them."
	icon = 'icons/roguetown/underworld/enigma_husks.dmi'
	icon_state = "soultoken"
	sellprice = 30


/obj/structure/ritualcircle/eora
	name = "Rune of Love"
	desc = "A Holy Rune of Eora. A gentle warmth and joy spreads across your soul."
	icon_state = "eora_chalky"

	var/peacerites = list("Rite of Pacification")

/obj/structure/ritualcircle/eora/attack_hand(mob/living/user)
	if((user.patron?.type) != /datum/patron/divine/eora)
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("I have performed enough rituals for the day... I must rest before communing more."))
		return
	var/riteselection = input(user, "Rituals of Love", src) as null|anything in peacerites
	switch(riteselection) // put ur rite selection here
		if("Rite of Pacification")
			if(do_after(user, 50))
				user.say("#Blessed be your weary head...")
				if(do_after(user, 50))
					user.say("#Full of strife and pain...")
					if(do_after(user, 50))
						user.say("#Let Her ease your fear...")
						if(do_after(user, 50))
							icon_state = "eora_active"
							pacify(src)
							user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
							spawn(120)
								icon_state = "eora_chalky"

/obj/structure/ritualcircle/eora/proc/pacify(src)
	var/ritualtargets = view(0, loc)
	for(var/mob/living/carbon/human/target in ritualtargets)
		loc.visible_message(span_warning("[target] sways like windchimes in the wind..."))
		target.visible_message(span_green("I feel the burdens of my heart lifting. Something feels very wrong... I don't mind at all..."))
		target.apply_status_effect(/datum/status_effect/buff/pacify)

/obj/structure/ritualcircle/undivided
	name = "Rune of Deca Divinity"
	desc = "A Holy Rune of The Undivided Pantheon"
	//icon_state = "undivided_chalky"



// TIME FOR THE ASCENDANT. These can be stronger. As they are pretty much antag exclusive - Iconoclast for Matthios, Lich for ZIZO. ZIZO!


/obj/structure/ritualcircle/zizo
	name = "Rune of Progress"
	desc = "A Holy Rune of ZIZO. Progress at any cost."
	icon_state = "zizo_chalky"
	var/zizorites = list("Rite of Armaments")

/obj/structure/ritualcircle/zizo/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/inhumen/zizo)
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("I have performed enough rituals for the day... I must rest before communing more."))
		return
	var/riteselection = input(user, "Rituals of Progress", src) as null|anything in zizorites
	switch(riteselection)
		if("Rite of Armaments")
			var/onrune = view(1, loc)
			var/list/folksonrune = list()
			for(var/mob/living/carbon/human/persononrune in onrune)
				if(HAS_TRAIT(persononrune, TRAIT_CABAL))
					folksonrune += persononrune
			var/target = input(user, "Choose a host") as null|anything in folksonrune
			if(!target)
				return
			if(!do_after(user, 5 SECONDS))
				return
			user.say("ZIZO! ZIZO! DAME OF PROGRESS!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("ZIZO! ZIZO! HEED MY CALL!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("ZIZO! ZIZO! ARMS TO SLAY THE IGNORANT!!")
			if(!do_after(user, 5 SECONDS))
				return
			icon_state = "zizo_active"
			user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
			zizoarmaments(target)
			spawn(120)
				icon_state = "zizo_chalky"

/obj/structure/ritualcircle/zizo/proc/zizoarmaments(mob/living/carbon/human/target)
	if(!HAS_TRAIT(target, TRAIT_CABAL))
		loc.visible_message(span_cult("THE RITE REJECTS ONE NOT OF THE CABAL"))
		return
	target.Stun(60)
	target.Knockdown(60)
	to_chat(target, span_userdanger("UNIMAGINABLE PAIN!"))
	target.emote("Agony")
	playsound(loc, 'sound/combat/newstuck.ogg', 50)
	loc.visible_message(span_cult("Great hooks come from the rune, embedding into [target]'s ankles, pulling them onto the rune. Then, into their wrists. Their lux is torn from their chest, and reforms into armor. "))
	spawn(20)
		playsound(loc, 'sound/combat/hits/onmetal/grille (2).ogg', 50)
		target.equipOutfit(/datum/outfit/job/roguetown/darksteelrite)
		spawn(40)
			to_chat(target, span_purple("They are ignorant, backwards, without hope. You. You will be powerful."))

/datum/outfit/job/roguetown/darksteelrite/pre_equip(mob/living/carbon/human/H)
	..()
	var/list/items = list()
	items |= H.get_equipped_items(TRUE)
	for(var/I in items)
		H.dropItemToGround(I, TRUE)
	H.drop_all_held_items()
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/zizo
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/zizo
	pants = /obj/item/clothing/under/roguetown/platelegs/zizo
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/zizo
	wrists = /obj/item/clothing/wrists/roguetown/bracers/zizo
	gloves = /obj/item/clothing/gloves/roguetown/plate/zizo
	head = /obj/item/clothing/head/roguetown/helmet/heavy/zizo
	neck = /obj/item/clothing/neck/roguetown/bevor/zizo
	backr = /obj/item/rogueweapon/sword/long/zizo

	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mending/lesser)


/obj/structure/ritualcircle/matthios
	name = "Rune of Transaction"
	desc = "A Holy Rune of Matthios. All has a price."
	icon_state = "matthios_chalky"
	var/matthiosrites = list("Rite of Armaments", "Defenestration")


/obj/structure/ritualcircle/matthios/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/inhumen/matthios)
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("I have performed enough rituals for the day... I must rest before communing more."))
		return
	var/riteselection = input(user, "Rituals of Transaction", src) as null|anything in matthiosrites
	switch(riteselection) // put ur rite selection here
		if("Rite of Armaments")
			var/onrune = view(1, loc)
			var/list/folksonrune = list()
			for(var/mob/living/carbon/human/persononrune in onrune)
				if(HAS_TRAIT(persononrune, TRAIT_COMMIE))
					folksonrune += persononrune
			var/target = input(user, "Choose a host") as null|anything in folksonrune
			if(!target)
				return
			if(!do_after(user, 5 SECONDS))
				return
			user.say("Gold and Silver, he feeds!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("Pieces Tens, Hundreds, Thousands. The transactor feeds 'pon them all!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("Arms to claim, Arms to take!!")
			if(!do_after(user, 5 SECONDS))
				return
			icon_state = "matthios_active"
			user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
			matthiosarmaments(target)
			spawn(120)
				icon_state = "matthios_chalky"
		if("Defenestration")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("The window is open, the transaction is made!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("Pieces Tens, Hundreds, Thousands. The transactor feeds 'pon them all!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("The Transactor, feast upon this gluttonous pig!!")
			if(!do_after(user, 5 SECONDS))
				return
			icon_state = "matthios_active"
			if(defenestration())
				to_chat(user, span_cultsmall("The ritual is complete, the noble gift of Astrata has been taken!"))
				user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
			else
				to_chat(user, span_cultsmall("The ritual fails. A noble must be in the center of the circle!"))
			spawn(120)
				icon_state = "matthios_chalky"

/obj/structure/ritualcircle/matthios/proc/matthiosarmaments(mob/living/carbon/human/target)
	if(!HAS_TRAIT(target, TRAIT_COMMIE))
		loc.visible_message(span_cult("THE RITE REJECTS ONE WITHOUT GREED IN THEIR HEART!!"))
		return
	target.Stun(60)
	target.Knockdown(60)
	to_chat(target, span_userdanger("UNIMAGINABLE PAIN!"))
	target.emote("Agony")
	playsound(loc, 'sound/misc/smelter_fin.ogg', 50)
	loc.visible_message(span_cult("[target]'s lux pours from their nose, into the rune, gleaming golds sizzles. Molten gold and metals swirl into armor, seered to their skin."))
	spawn(20)
		playsound(loc, 'sound/combat/hits/onmetal/grille (2).ogg', 50)
		target.equipOutfit(/datum/outfit/job/roguetown/gildedrite)
		spawn(40)
			to_chat(target, span_cult("More to the maw, this shall help feed our greed."))

/// Performs the de-noblification ritual, which requires a noble character in the center of the circle. TRUE on success, FALSE on failure.
/obj/structure/ritualcircle/matthios/proc/defenestration()
	var/mob/living/carbon/human/victim = null
	for(var/mob/living/carbon/human/H in get_turf(src))
		if(HAS_TRAIT(H, TRAIT_OUTLAW))
			continue

		if(!H.is_noble() || H.has_status_effect(/datum/status_effect/debuff/ritualdefiled))
			continue

		victim = H
		break

	if(!victim)
		return FALSE

	playsound(loc, 'sound/combat/gib (1).ogg', 100, FALSE, -1)
	loc.visible_message(span_cult("[victim]'s lux pours from their nose, into the rune... Transforming into freshly mint zennies!"))
	new /obj/item/roguecoin/gold/virtuepile(get_turf(src))
	new /obj/item/roguecoin/silver/pile(get_turf(src))
	new /obj/item/roguecoin/silver/pile(get_turf(src))
	if(victim.mind?.assigned_role in GLOB.noble_positions) // Intentionally stacked with rulermob/regent/prince to get extra payout for royals
		new /obj/item/roguecoin/gold/virtuepile(get_turf(src))
		new /obj/item/roguecoin/gold/virtuepile(get_turf(src))
	// Draining nobility from the duke or the heirs increases payout and causes CHAOS. Astrata weeps!
	if((victim == SSticker.rulermob) || (victim == SSticker.regentmob) || (victim.mind?.assigned_role in list ("Prince", "Princess")))
		new /obj/item/roguecoin/gold/virtuepile(get_turf(src))
		new /obj/item/roguecoin/gold/virtuepile(get_turf(src))
		new /obj/item/roguecoin/gold/virtuepile(get_turf(src))
		new /obj/item/roguecoin/gold/virtuepile(get_turf(src))
		// Astrata loses her bearing due to this vile ritual
		priority_announce("The Noble Gift of Astrata was tainted! The Sun, she is weeping!", "Bad Omen", 'sound/misc/evilevent.ogg')
		var/datum/round_event_control/lightsout/E = new()
		E.req_omen = FALSE
		E.earliest_start = 0
		E.min_players = 0
		E.runEvent()

		var/datum/round_event_control/haunts/H = new()
		H.req_omen = FALSE
		H.earliest_start = 0
		H.min_players = 0
		if(LAZYLEN(GLOB.hauntstart))
			H.runEvent()

	victim.Stun(60)
	victim.Knockdown(60)
	to_chat(victim, span_userdanger("UNIMAGINABLE PAIN!"))
	victim.apply_status_effect(/datum/status_effect/debuff/ritualdefiled)

	to_chat(victim, span_userdanger("ASTRATA WEEPS!"))
	victim.emote("Agony")
	REMOVE_TRAIT(victim, TRAIT_NOBLE, TRAIT_GENERIC)
	REMOVE_TRAIT(victim, TRAIT_NOBLE, TRAIT_VIRTUE)
	ADD_TRAIT(victim, TRAIT_DEFILED_NOBLE, TRAIT_GENERIC)
	playsound(loc, 'sound/misc/evilevent.ogg', 100, FALSE, -1)
	to_chat(victim, span_cult("You feel your Astrata's gift of nobility stripped from you, the inhumen feasting upon it!"))
	return TRUE

/datum/outfit/job/roguetown/gildedrite/pre_equip(mob/living/carbon/human/H)
	..()
	var/list/items = list()
	items |= H.get_equipped_items(TRUE)
	for(var/I in items)
		H.dropItemToGround(I, TRUE)
	H.drop_all_held_items()
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/matthios
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/matthios
	pants = /obj/item/clothing/under/roguetown/platelegs/matthios
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/matthios
	wrists = /obj/item/clothing/wrists/roguetown/bracers/matthios
	gloves = /obj/item/clothing/gloves/roguetown/plate/matthios
	head = /obj/item/clothing/head/roguetown/helmet/heavy/matthios
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle/matthios
	backr = /obj/item/rogueweapon/flail/peasantwarflail/matthios

	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mending/lesser)

/obj/structure/ritualcircle/graggar
	name = "Rune of Violence"
	desc = "A Holy Rune of Graggar. Fate broken once, His gift is true freedom for all."
	icon_state = "graggar_chalky"
	var/graggarrites = list("Rite of Armaments", "War Ritual")

/obj/structure/ritualcircle/graggar/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/inhumen/graggar)
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("I have performed enough rituals for the day... I must rest before communing more."))
		return
	var/riteselection = input(user, "Rituals of Violence", src) as null|anything in graggarrites
	switch(riteselection) // put ur rite selection here
		if("Rite of Armaments")
			var/onrune = view(1, loc)
			var/list/folksonrune = list()
			for(var/mob/living/carbon/human/persononrune in onrune)
				if(HAS_TRAIT(persononrune, TRAIT_HORDE))
					folksonrune += persononrune
			var/target = input(user, "Choose a host") as null|anything in folksonrune
			if(!target)
				return
			if(!do_after(user, 5 SECONDS))
				return
			user.say("MOTIVE FORCE, OH VIOLENCE!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("A GORGEOUS FEAST OF VIOLENCE, FOR YOU, FOR YOU!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("A SLAUGHTER AWAITS!!") // see the numbers taste the violence
			if(!do_after(user, 5 SECONDS))
				return
			icon_state = "graggar_active"
			user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
			graggararmor(target)
			spawn(120)
				icon_state = "graggar_chalky" 
		if("War Ritual")
			to_chat(user, span_userdanger("This rite will get me more tired than usual... I wonder, should I proceed?"))
			if(!do_after(user, 5 SECONDS))
				return
			user.say("Blood for the war god, the circle is drawn!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("Let noble flesh be the price for the horde!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("Let portals open, let the goblins swarm!")
			if(!do_after(user, 5 SECONDS))
				return
			icon_state = "graggar_active"
			if(perform_warritual())
				user.apply_status_effect(/datum/status_effect/debuff/ritesexpended_heavy)
			else
				to_chat(user, span_smallred("The ritual fails. A noble, member of the inquisition or a tennite churchling body must be in the center of the circle!"))
			spawn(120)
				icon_state = "graggar_chalky" 
/obj/structure/ritualcircle/graggar/proc/graggararmor(mob/living/carbon/human/target)
	if(!HAS_TRAIT(target, TRAIT_HORDE))
		loc.visible_message(span_cult("THE RITE REJECTS ONE WITHOUT SLAUGHTER IN THEIR HEART!!"))
		return
	target.Stun(60)
	target.Knockdown(60)
	to_chat(target, span_userdanger("UNIMAGINABLE PAIN!"))
	target.emote("Agony")
	playsound(loc, 'sound/misc/smelter_fin.ogg', 50)
	loc.visible_message(span_cult("[target]'s lux pours from their nose, into the rune, motive and metals swirl into armor, snug around their form!"))
	spawn(20)
		playsound(loc, 'sound/combat/hits/onmetal/grille (2).ogg', 50)
		target.equipOutfit(/datum/outfit/job/roguetown/viciousrite)
		spawn(40)
			to_chat(target, span_cult("Break them."))

/// Performs the war ritual, which requires a noble or inquisition member in the center of the circle. TRUE on success, FALSE on failure.
/obj/structure/ritualcircle/graggar/proc/perform_warritual()
	var/mob/living/carbon/human/victim = null
	for(var/mob/living/carbon/human/H in get_turf(src))
		if(H.has_status_effect(/datum/status_effect/debuff/ritualdefiled))
			continue

		if(H.is_noble() || HAS_TRAIT(H, TRAIT_INQUISITION) || (H.mind?.assigned_role in list("Priest", "Templar", "Martyr")))
			victim = H
			break

	if(!victim)
		return FALSE

	playsound(loc, 'sound/combat/gib (1).ogg', 100, FALSE, -1)
	loc.visible_message(span_cult("[victim]'s lux pours from their nose, into the rune!"))
	victim.Stun(60)
	victim.Knockdown(60)
	to_chat(victim, span_userdanger("UNIMAGINABLE PAIN!"))
	victim.apply_status_effect(/datum/status_effect/debuff/ritualdefiled)
	victim.emote("Agony")
	victim.visible_message(
		span_danger("[victim] writhes in unimaginable pain!"),
		span_userdanger("IT HURTS! IT BURNS!")
	)

	to_chat(world, span_danger("A war ritual has been completed! Goblin portals begin to tear open across the land!"))
	playsound(loc, 'sound/magic/bloodrage.ogg', 100, FALSE, -1)
	var/datum/round_event_control/gobinvade/E = new()
	E.req_omen = FALSE
	E.earliest_start = 0
	E.min_players = 0
	if(LAZYLEN(GLOB.hauntstart))
		E.runEvent()

	sleep(2 SECONDS)
	victim.emote("painscream", forced = TRUE)
	return TRUE

/datum/outfit/job/roguetown/viciousrite/pre_equip(mob/living/carbon/human/H)
	..()
	var/list/items = list()
	items |= H.get_equipped_items(TRUE)
	for(var/I in items)
		H.dropItemToGround(I, TRUE)
	H.drop_all_held_items()
	armor = /obj/item/clothing/suit/roguetown/armor/plate/fluted/graggar
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/graggar
	pants = /obj/item/clothing/under/roguetown/platelegs/graggar
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/graggar
	wrists = /obj/item/clothing/wrists/roguetown/bracers/graggar
	gloves = /obj/item/clothing/gloves/roguetown/plate/graggar
	head = /obj/item/clothing/head/roguetown/helmet/heavy/graggar
	neck = /obj/item/clothing/neck/roguetown/gorget/steel/graggar
	cloak = /obj/item/clothing/cloak/graggar
	r_hand = /obj/item/rogueweapon/greataxe/steel/doublehead/graggar

/obj/effect/decal/cleanable/roguerune/god/baotha
	name = "Rune of Hedonism"
	desc = "A Holy Rune of Baotha. Relief for the broken hearted."
	icon_state = "baotha_chalky"
	rituals = list(/datum/runeritual/joybringer::name = /datum/runeritual/joybringer)
	allowed_patron = /datum/patron/inhumen/baotha

/datum/runeritual/joybringer
	name = "Rite of Joy"

/datum/runeritual/joybringer/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	if(!do_after(user, 5 SECONDS))
		return FALSE

	user.say("Let the wine flow, let the music crash!")

	if(!do_after(user, 5 SECONDS))
		return FALSE
	
	user.say("Away with tears, away with shame!")
	to_chat(user, span_notice("The memory of sorrow fades into a haze of bliss."))

	if(!do_after(user, 5 SECONDS))
		return FALSE

	user.say("Grant me the bliss, grant me the rush!")

	if(!do_after(user, 3 SECONDS))
		return FALSE
	
	user.say("Baotha, fill my cup with endless mirth!")
	playsound(loc, 'sound/misc/evilevent.ogg', 100, FALSE, -1)
    
	user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
	user.apply_status_effect(/datum/status_effect/joybringer)

	return TRUE

/obj/effect/decal/cleanable/roguerune/god/psydon
	name = "Rune of Enduring"
	desc = "A Holy Rune of Psydon. It depicts His holy symbol, yet nothing stirs within you."
	icon_state = "psydon_chalky"
	allowed_patron = /datum/patron/old_god
	rituals = list(/datum/runeritual/silver_blessing::name = /datum/runeritual/silver_blessing)

/datum/runeritual/silver_blessing
	name = "Rite of Silver-Blessing"
	required_atoms = list(/obj/item/rogueweapon = 1)

/datum/runeritual/silver_blessing/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	var/obj/item/rogueweapon/weapon = selected_atoms[1]
	var/datum/component/silverbless/CP = weapon.GetComponent(/datum/component/silverbless)

	if(!CP || CP.is_blessed)
		loc.visible_message(span_warning("HIS rune pulses with a small flash of light, then falls dark. This weapon is not pure enough to be anointed."))
		return FALSE

	if(!do_after(user, 3 SECONDS))
		return FALSE

	loc.visible_message(span_warning("[user] firmly places a hand on [weapon] and straightens, adopting a posture of absolute discipline."))
	user.say("The Architect is silent, but His Blueprint shall not be forgotten!")
	to_chat(user, span_notice("You focus your WILL upon the tool, feeling a chilling depletion in your core."))
	
	if(!do_after(user, 4 SECONDS))
		return FALSE

	loc.visible_message(span_userdanger("A ghostly, icy silver light visibly drains from [user]'s hand, surging into [weapon]—the very essence of their Steadfastness!"))
    
	if(!do_after(user, 4 SECONDS))
		return FALSE
	
	loc.visible_message(span_cultsmall("[weapon] flares with a cold glimmer, having absorbed the sacrifice! [user] appears visibly drained and cold."))
	playsound(loc, 'sound/magic/churn.ogg', 100, FALSE, -1)

	CP.try_bless(BLESSING_PSYDONIAN)
	new /obj/effect/temp_visual/censer_dust(get_turf(loc))

	user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
	user.apply_status_effect(/datum/status_effect/debuff/devitalised/lesser)

	return TRUE

