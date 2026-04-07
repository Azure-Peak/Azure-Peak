/*
 * ========== Binding Rituals ==========
 *
 * The payoff for leyline encounters. Mages spend realm materials gathered from
 * killing summoned creatures to bind a single creature to their service.
 * Drawn on a Binding Array (T2) or Greater Binding Array (T4).
 *
 * Costs: realm materials + runed artifact (tier count) + same-tier meld.
 *   Artifacts scale with tier: T1=1, T2=2, T3=3, T4=4.
 *   Melds force realm diversity — you need materials from all 3 realms
 *   to make one, meaning you either wait 3 days for different encounters
 *   or cooperate with other mages who went to different leylines.
 *
 * Realm material costs match 1 mob's drops at that tier:
 *   T1: 4x T1 mat, T2: 2x T2 mat, T3: 1x T3 mat, T4: 1x T4 mat.
 *
 * The bound creature spawns pacified, godmoded, paralyzed, and red-tinted
 * via bind_ritual_mob — the summoning circle's "seal and release" flow
 * handles the rest (removing godmode, giving orders, etc).
 */

/datum/runeritual/binding
	name = "binding ritual parent"
	desc = "binding parent rituals."
	category = "Binding"
	abstract_type = /datum/runeritual/binding
	blacklisted = TRUE
	var/mob_to_bind

/datum/runeritual/binding/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	if(!mob_to_bind)
		return FALSE
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
	to_chat(user, span_notice("The array flares with power as [bound] is pulled through the veil!"))
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

/datum/runeritual/binding/infernal_t2
	name = "Bind Lesser Infernal"
	desc = "Bind a lesser infernal to your service: a being of daemonic hatred, specializing in fiery destruction."
	blacklisted = FALSE
	mob_to_bind = /mob/living/simple_animal/pet/familiar/infernal
	required_atoms = list()
	//required_atoms = list(/obj/item/magic/infernal/fang = 2, /obj/item/magic/leyline = 1)

/datum/runeritual/binding/fae_t2
	name = "Bind Lesser Fae"
	desc =	 "Bind a lesser fae to your service: a being of natural whimsy, specializing in mobility and alchemy."
	blacklisted = FALSE
	mob_to_bind = /mob/living/simple_animal/pet/familiar/fae
	required_atoms = list()
	//required_atoms = list(/obj/item/magic/fae/iridescentscale = 2, /obj/item/magic/leyline = 1)

/datum/runeritual/binding/elemental_t2
	name = "Bind Lesser Elemental"
	desc = "Bind a lesser elemental to your service: a creature of earthen durability, specializing in world-manipulation and repairs."
	blacklisted = FALSE
	mob_to_bind = /mob/living/simple_animal/pet/familiar/elemental
	required_atoms = list()
	// required_atoms = list(/obj/item/magic/elemental/shard = 2, /obj/item/magic/leyline = 1)

/datum/runeritual/binding/void_dragon
	name = "Bind Void Drakeling"
	desc = "Reach into the void and grasp a fragment of draconic power, shaping it into a familiar."
	blacklisted = FALSE
	mob_to_bind = /mob/living/simple_animal/pet/familiar/void
	required_atoms = list()
	// required_atoms = list(/obj/item/magic/artifact = 1, /obj/item/magic/voidstone = 2, /obj/item/magic/leyline = 2) // todo this recipe sucks


/datum/runeritual/binding/revive_familiar
	name = "Revive Familiar"
	desc = "Return a departed familiar to lyfe, so long as they have not yet fully returned to their home plane."
	required_atoms = list(/obj/item/magic/melded/t1)
	blacklisted = FALSE

/datum/runeritual/binding/revive_familiar/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	. = FALSE
	for(var/mob/living/simple_animal/pet/familiar/existing_fam in GLOB.alive_mob_list + GLOB.dead_mob_list)
		if(existing_fam.familiar_summoner == user && existing_fam.health<=0 && existing_fam.revive(full_heal = TRUE, admin_revive = TRUE))
			to_chat(user, span_notice("You channel the ritual's magic through your bond, returning [existing_fam.name] to this plane!"))
			existing_fam.grab_ghost(force = TRUE)
			existing_fam.familiar_summoner = user
			existing_fam.visible_message(span_notice("[existing_fam.name] is restored to life by [user]'s magic!"))
			. = TRUE

/datum/runeritual/binding/release_familiar
	name = "Free Familiar"
	desc = "Terminate your contract with a familiar, sending them back from whence they came unharmed."
	required_atoms = list(/mob/living/simple_animal/pet/familiar)
	blacklisted = FALSE

/datum/runeritual/binding/release_familiar/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	. = ..()
	if(!selected_atoms.len)
		return FALSE
	var/mob/living/simple_animal/pet/familiar/fam = selected_atoms[1]
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
	return TRUE

/datum/runeritual/planar_pact
	name = "Planar Pact"
	desc = "Make a lesser pact with a planar being, exchanging only a mote of essence with each other. Grants a minor stat boon and a minor stat penalty."
	required_atoms = list(/obj/item/magic/melded/t1)
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

/datum/runeritual/planar_pact/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	. = ..()
	for(var/datum/status_effect/buff/familiar/buff in planar_buffs)
		if(user.has_status_effect(buff))
			to_chat(user, span_warning("You can only bear one planar pact at a time!"))
			return FALSE
	var/pretty_choice = input(user, "Choose a pact:","ACROSS THE VEIL") as anything in pretty_buff_names
	var/datum/status_effect/buff/familiar/chosen_buff = planar_buffs[pretty_buff_names.Find(pretty_choice)]
	if(!chosen_buff)
		return FALSE
	user.apply_status_effect(chosen_buff)

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
