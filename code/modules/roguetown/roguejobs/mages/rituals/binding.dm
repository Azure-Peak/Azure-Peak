#define LEYLINE_TILE_DETECTION_RANGE 7
/*
 * ========== Binding Rituals ==========
 *
 * Summon a familiar to aid you in your journey. Limit one per player, and not particularly tailored towards combat.
 * Costs planar materials in low quantity, except the drakeling, which is expensive.
 */

/datum/runeritual/binding
	name = "binding ritual parent"
	desc = "binding parent rituals."
	category = "Binding"
	abstract_type = /datum/runeritual/binding
	blacklisted = TRUE
	var/mob_to_bind
	var/invocation // some of these need unique invocations

/datum/runeritual/binding/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	if(!mob_to_bind) // it's a non-binding binding recipe. yay?
		return ..()
	if(!locate(/obj/effect/decal/cleanable/roguerune/arcyne/binding) in loc)
		to_chat(user, span_warning("The binding array has been destroyed! The ritual fizzles."))
		return FALSE
	// special case: only highly skilled mages can safely perform this act of hubris
	if(mob_to_bind == /mob/living/simple_animal/pet/familiar/void && !(user.mind.mage_aspect_config && user.mind.mage_aspect_config["major"]))
		user.visible_message(span_boldwarning("The ritual spirals out of control! The void stares back, unappreciative of your hubris!"))
		playsound(loc, 'sound/magic/cosmic_expansion.ogg', 100, TRUE, 14)
		var/list/valid_turfs = list()
		for(var/turf/open/T in range(3, loc))
			if(T.density)
				continue
			if(T == loc)
				continue
			valid_turfs += T
		shuffle_inplace(valid_turfs)
		var/list/spawn_turfs = valid_turfs.Copy(1, min(4, length(valid_turfs) + 1))
		var/spawned = 0
		for(var/i in 1 to 3)
			if(spawned >= length(spawn_turfs))
				break
			spawned++
			var/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk/obelisk = new /mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk(spawn_turfs[spawned])
			addtimer(CALLBACK(obelisk, TYPE_PROC_REF(/mob/living/simple_animal/hostile, FindTarget)), 1 SECONDS) // so you have SOME time to react. without this, they just sit there until attacked
		return TRUE
	var/mob/living/bound = bind_ritual_mob(user, loc, mob_to_bind)
	if(!bound)
		return FALSE
	to_chat(user, span_notice("The array flares with power as [bound] is pulled through [istype(src,/datum/runeritual/binding/void)?"the rift":"the veil"]!"))
	playsound(loc, 'sound/magic/cosmic_expansion.ogg', 100, TRUE, 7)
	return bound

/datum/runeritual/binding/proc/bind_ritual_mob(mob/living/user, turf/loc, mob/living/mob_to_bind)
	var/mob/living/simple_animal/pet/familiar/binded
	if(isliving(mob_to_bind))
		binded = mob_to_bind
	else
		binded = new mob_to_bind(loc)
		ADD_TRAIT(binded, TRAIT_PACIFISM, TRAIT_GENERIC)
		binded.status_flags += GODMODE
		binded.candodge = FALSE
		animate(binded, color = "#ff0000",time = 5)
		binded.move_resist = MOVE_FORCE_EXTREMELY_STRONG
		binded.binded = TRUE
		binded.SetParalyzed(900)
		return binded

// ----- Familiar Binding -----

/datum/runeritual/binding/infernal
	name = "Bind Lesser Infernal"
	desc = "Bind a lesser infernal to your service: a being of daemonic hatred, specializing in fiery destruction."
	blacklisted = FALSE
	mob_to_bind = /mob/living/simple_animal/pet/familiar/infernal
	required_atoms = list(/obj/item/magic/infernal/fang = 2)
	invocation = "Appare, spiritus infernus!"

/datum/runeritual/binding/fae
	name = "Bind Lesser Fae"
	desc =	 "Bind a lesser fae to your service: a being of natural whimsy, specializing in mobility and alchemy."
	blacklisted = FALSE
	mob_to_bind = /mob/living/simple_animal/pet/familiar/fae
	required_atoms = list(/obj/item/magic/fae/iridescentscale = 2)
	invocation = "Appare, spiritus silvae!"

/datum/runeritual/binding/elemental
	name = "Bind Lesser Elemental"
	desc = "Bind a lesser elemental to your service: a creature of earthen durability, specializing in world-manipulation and repairs."
	blacklisted = FALSE
	mob_to_bind = /mob/living/simple_animal/pet/familiar/elemental
	required_atoms = list(/obj/item/magic/elemental/shard = 2)
	invocation = "Appare, spiritus terrae!"

/datum/runeritual/binding/void
	name = "Bind Void Drakeling"
	desc = "Reach into the void and grasp a fragment of draconic power, shaping it into a familiar."
	blacklisted = FALSE
	mob_to_bind = /mob/living/simple_animal/pet/familiar/void
	// 1 shard instead of 2 means if you summon in the bog you'll still have an extra 2 shards to make something cool with as a reward
	required_atoms = list(/obj/item/magic/artifact = 1, /obj/item/magic/voidstone = 2, /obj/item/magic/leyline = 1)

/obj/effect/void_rift
	name = "Void Rift"
	desc = "A tear in the veil, reaching deeper and deeper to... what?"
	icon = 'icons/effects/effects.dmi'
	icon_state = "bluestream_fade"

// some familiar-binders get to aurafarm too. as a treat
/datum/runeritual/binding/void/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	var/list/chants = list(
		"Vacuum spectat.",
		"See me! Turn your gaze!",
		"Nihil respondet.",
		"Answer me! I know you hear!",
		"Ultra omnia voco.",
		"Beyond every plane! Past every boundary!", // up to this point is from the void dragon summoning rite
		"Draco vacui prehendo.", // 'i grasp the dragon'
		"Now! I grasp your power!",
		"Watch! The void is sundered!",
		"Manifest! Evoca et Liga!"
	)
	var/obj/structure/leyline/powerful/leyline
	for(var/obj/structure/leyline/powerful/L in range(LEYLINE_TILE_DETECTION_RANGE, loc))
		leyline = L
		break
	if(!leyline)
		to_chat(user, span_warning("There is no leyline of sufficent strength nearby. Only the most powerful of leylines will do, for this."))
		return FALSE
	user.visible_message(
		span_danger("[user] begins to chant, channeling energy into the leyline!"),
		span_danger("You begin to chant, channeling energy into the leyline!")
	)
	playsound(loc, 'sound/magic/teleport_diss.ogg', 100, TRUE, 14)
	user.visible_message(
		span_danger("A rift in the veil opens, shimmering in the center of the circle!"),
		span_danger("You tear open a rift in the veil, reaching forth into the void!"),
	)
	var/obj/effect/void_rift/rift = new /obj/effect/void_rift(loc)
	var/list/active_beams = list()
	for(var/i in 1 to length(chants))
		var/line = chants[i]
		user.say(line, language = /datum/language/common, ignore_spam = TRUE, forced = "cult invocation")
		// Beams: visually leyline → circle and circle → caster (origin.Beam draws FROM origin)
		var/turf/leyline_turf = get_turf(leyline)
		active_beams += leyline_turf.Beam(loc, icon_state = "b_beam", time = 2 SECONDS, maxdistance = 10)
		active_beams += loc.Beam(user, icon_state = "b_beam", time = 2 SECONDS, maxdistance = 10)
		// Drain energy from all chanters
		user.energy_add(-10)
		if(!do_after(user, 2 SECONDS, target = leyline))
			to_chat(user, span_warning("The ritual is interrupted!"))
			for(var/datum/beam/B in active_beams)
				B.End()
			qdel(rift)
			return FALSE
	qdel(rift)
	. = ..()

/datum/runeritual/binding/revive_familiar
	name = "Revive Familiar"
	desc = "Return a departed familiar to lyfe, so long as they have not yet fully returned to their home plane. Requires the vestige dropped upon their death."
	required_atoms = list(/obj/item/magic/melded/t1 = 1, /obj/item/magic/familiar_vestige = 1)
	blacklisted = FALSE
	invocation = "Redeo, spiritus fidus!" // "return, loyal spirit"

/datum/runeritual/binding/revive_familiar/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	. = FALSE
	for(var/obj/item/magic/familiar_vestige/vestige in selected_atoms)
		if(vestige.stored_familiar)
			if(!vestige.stored_familiar.client)
				to_chat(user, span_warning("[vestige.stored_familiar.name] has fully departed for their home plane... they cannot be revived!"))
			else if(vestige.stored_familiar.revive(full_heal = TRUE, admin_revive = TRUE))
				to_chat(user, span_notice("You channel the ritual's magic into the vestige, returning [vestige.stored_familiar.name] to this plane!"))
				vestige.stored_familiar.loc = loc
				vestige.stored_familiar.grab_ghost(force = TRUE)
				vestige.stored_familiar.familiar_summoner = user
				vestige.stored_familiar.icon_state = vestige.stored_familiar.icon_living
				vestige.stored_familiar.update_icon()
				vestige.stored_familiar.visible_message(span_notice("[vestige.stored_familiar.name] is restored to life by [user]'s magic!"))
				vestige.stored_familiar = null
				. = TRUE

/datum/runeritual/binding/release_familiar
	name = "Free Familiar"
	desc = "Terminate your contract with a familiar, sending them back from whence they came unharmed."
	blacklisted = FALSE
	invocation = "Exsolvo spiritus!" // "release spirit." very creative

/datum/runeritual/binding/release_familiar/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	. = ..()
	var/mob/living/simple_animal/pet/familiar/fam
	for(var/mob/living/simple_animal/pet/familiar/existing_fam in GLOB.alive_mob_list + GLOB.dead_mob_list)
		if(existing_fam.familiar_summoner == user)
			fam = existing_fam
	if(!istype(fam))
		return FALSE
	if(QDELETED(fam))
		to_chat(user, span_warning("The familiar is already gone."))
		return
	to_chat(user, span_warning("You feel your link with [fam.name] break."))
	to_chat(fam, span_warning("You feel your link with [user.name] break, you are free."))

	fam.familiar_summoner = null

	user.mind?.RemoveSpell(/datum/action/cooldown/spell/message_familiar)
	fam.mind?.RemoveSpell(/datum/action/cooldown/spell/message_summoner)
	fam.mind?.unknow_all_people()

	var/exit_msg
	if(isdead(fam))
		exit_msg = "[fam.name]'s corpse vanishes in a puff of smoke."
	else
		exit_msg = "[fam.name] looks in the direction of [user.name] one last time, before opening a portal and vanishing into it."
	fam.visible_message(span_warning(exit_msg))
	QDEL_NULL(fam)
	return TRUE

/datum/runeritual/binding/planar_pact
	name = "Planar Pact"
	desc = "Make a lesser pact with a planar being, exchanging only a mote of essence with each other. Grants a minor stat boon and a minor stat penalty."
	required_atoms = list(/obj/item/magic/fae/iridescentscale = 1)
	blacklisted = FALSE
	invocation = "Permutatio essentiae!"
	var/list/planar_buffs = list(
		/datum/status_effect/buff/familiar/settled_weight,
		/datum/status_effect/buff/familiar/silver_glance,
		/datum/status_effect/buff/familiar/threaded_thoughts,
		/datum/status_effect/buff/familiar/quiet_resilience,
		/datum/status_effect/buff/familiar/desert_bred_tenacity,
		/datum/status_effect/buff/familiar/lightstep,
		/datum/status_effect/buff/familiar/soft_favor,
		/datum/status_effect/buff/familiar/burdened_coil,
		/datum/status_effect/buff/familiar/starseam,
		/datum/status_effect/buff/familiar/steady_spark,
		/datum/status_effect/buff/familiar/subtle_slip,
		/datum/status_effect/buff/familiar/noticed_thought,
		/datum/status_effect/buff/familiar/worn_stone
	)
	var/list/pretty_buff_names = list(
		"Settled Weight (+1 STR, -1 INT, -1 PER)",
		"Silver Glance (+1 PER, -1 WIL)",
		"Threaded Thoughts (+1 INT, -1 CON)",
		"Quiet Resilience (+1 CON, -1 INT)",
		"Desert-Bred Tenacity (+1 WIL, -1 PER)",
		"Lightstep (+1 SPD, -1 WIL, -1 INT)",
		"Soft Favor (+1 PER, -1 INT)",
		"Burdened Coil (+1 WIL, -1 CON)",
		"Starseam (+1 PER, -1 CON)",
		"Steady Spark (+1 STR, -1 PER, -1 CON)",
		"Subtle Slip (+1 LCK, -1 WIL)",
		"Noticed Thought (+1 PER, +1 INT, -1 STR)",
		"Worn Stone (+1 WIL, +1 CON, -1 SPD)"
	)

/datum/runeritual/binding/planar_pact/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	. = ..()
	for(var/buff in planar_buffs)
		if(user.has_status_effect(buff))
			to_chat(user, span_warning("You can only bear one planar pact at a time!"))
			return FALSE
	var/pretty_choice = input(user, "Choose a pact:","ACROSS THE VEIL") as anything in pretty_buff_names
	var/datum/status_effect/buff/familiar/chosen_buff = planar_buffs[pretty_buff_names.Find(pretty_choice)]
	if(!chosen_buff)
		return FALSE
	user.apply_status_effect(chosen_buff)
	return TRUE

// planar pact buff definitions

/datum/status_effect/buff/familiar
	duration = -1

/datum/status_effect/buff/familiar/settled_weight
	id = "settled_weight"
	effectedstats = list(STATKEY_STR = 1, STATKEY_INT = -1, STATKEY_PER = -1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/settled_weight

/atom/movable/screen/alert/status_effect/buff/familiar/settled_weight
	name = "Settled Weight"
	desc = "You feel just a touch more grounded. Pushing back has become a little easier."

/datum/status_effect/buff/familiar/silver_glance
	id = "silver_glance"
	effectedstats = list(STATKEY_PER = 1, STATKEY_WIL = -1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/silver_glance

/atom/movable/screen/alert/status_effect/buff/familiar/silver_glance
	name = "Silver Glance"
	desc = "There's a flicker at the edge of your vision. You notice what others pass by."

/datum/status_effect/buff/familiar/threaded_thoughts
	id = "threaded_thoughts"
	effectedstats = list(STATKEY_INT = 1, STATKEY_CON = -1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/threaded_thoughts

/atom/movable/screen/alert/status_effect/buff/familiar/threaded_thoughts
	name = "Threaded Thoughts"
	desc = "Your thoughts gather more easily, like threads pulled into a tidy weave."

/datum/status_effect/buff/familiar/quiet_resilience
	id = "quiet_resilience"
	effectedstats = list(STATKEY_CON = 1, STATKEY_INT = -1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/quiet_resilience

/atom/movable/screen/alert/status_effect/buff/familiar/quiet_resilience
	name = "Quiet Resilience"
	desc = "A calm strength hums beneath your skin. You breathe a little deeper."

/datum/status_effect/buff/familiar/desert_bred_tenacity
	id = "desert_bred_tenacity"
	effectedstats = list(STATKEY_WIL = 1, STATKEY_PER = -1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/desert_bred_tenacity

/atom/movable/screen/alert/status_effect/buff/familiar/desert_bred_tenacity
	name = "Desert-Bred Tenacity"
	desc = "You feel steady and patient, like something that has survived years without rain."

/datum/status_effect/buff/familiar/lightstep
	id = "lightstep"
	effectedstats = list(STATKEY_SPD = 1, STATKEY_WIL = -1, STATKEY_INT = -1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/lightstep

/atom/movable/screen/alert/status_effect/buff/familiar/lightstep
	name = "Lightstep"
	desc = "You move with just a touch more ease."

/datum/status_effect/buff/familiar/soft_favor
	id = "soft_favor"
	effectedstats = list(STATKEY_PER = 1, STATKEY_INT = -1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/soft_favor

/atom/movable/screen/alert/status_effect/buff/familiar/soft_favor
	name = "Soft Favor"
	desc = "Fortune seems to tilt in your direction."

/datum/status_effect/buff/familiar/burdened_coil
	id = "burdened_coil"
	effectedstats = list(STATKEY_CON = -1, STATKEY_WIL = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/burdened_coil

/atom/movable/screen/alert/status_effect/buff/familiar/burdened_coil
	name = "Burdened Coil"
	desc = "You feel grounded and steady, as if strength coils beneath your skin."

/datum/status_effect/buff/familiar/starseam
	id = "starseam"
	effectedstats = list(STATKEY_PER = 1, STATKEY_CON = -1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/starseam

/atom/movable/screen/alert/status_effect/buff/familiar/starseam
	name = "Starseam"
	desc = "You feel nudged by distant patterns. The world flows more legibly."

/datum/status_effect/buff/familiar/steady_spark
	id = "steady_spark"
	effectedstats = list(STATKEY_STR = 1, STATKEY_PER = -1, STATKEY_CON = -1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/steady_spark

/atom/movable/screen/alert/status_effect/buff/familiar/steady_spark
	name = "Steady Spark"
	desc = "Your thoughts don't burn, they smolder. Clear, slow, and lasting."

/datum/status_effect/buff/familiar/subtle_slip
	id = "subtle_slip"
	effectedstats = list(STATKEY_LCK = 1, STATKEY_WIL = -1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/subtle_slip

/atom/movable/screen/alert/status_effect/buff/familiar/subtle_slip
	name = "Subtle Slip"
	desc = "Things seem a bit looser around you, a gap, a chance, a beat ahead."

/datum/status_effect/buff/familiar/noticed_thought
	id = "noticed_thought"
	effectedstats = list(STATKEY_PER = 1, STATKEY_INT = 1, STATKEY_STR = -1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/noticed_thought

/atom/movable/screen/alert/status_effect/buff/familiar/noticed_thought
	name = "Noticed Thought"
	desc = "Everything makes just a bit more sense. You catch patterns more quickly."

/datum/status_effect/buff/familiar/worn_stone
	id = "worn_stone"
	effectedstats = list(STATKEY_WIL = 1, STATKEY_CON = 1, STATKEY_SPD = -1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/worn_stone

/atom/movable/screen/alert/status_effect/buff/familiar/worn_stone
	name = "Worn Stone"
	desc = "Nothing feels urgent. You can take your time... and take a hit."

#undef LEYLINE_TILE_DETECTION_RANGE
