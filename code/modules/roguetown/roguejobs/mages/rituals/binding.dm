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
	blacklisted = TRUE
	var/mob_to_bind

/datum/runeritual/binding/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	if(!mob_to_bind)
		return FALSE
	if(!locate(/obj/effect/decal/cleanable/roguerune/arcyne/binding) in loc)
		to_chat(user, span_warning("The binding array has been destroyed! The ritual fizzles."))
		return FALSE
	var/mob/living/bound = bind_ritual_mob(user, loc, mob_to_bind)
	if(!bound)
		return FALSE
	to_chat(user, span_notice("The array flares with power as [bound] is pulled through the veil!"))
	playsound(loc, 'sound/magic/cosmic_expansion.ogg', 100, TRUE, 7)
	return bound

/datum/runeritual/binding/proc/bind_ritual_mob(mob/living/user, turf/loc, mob/living/mob_to_bind)
	var/mob/living/simple_animal/hostile/retaliate/rogue/binded
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
		binded.death_loot = list() // No free loot from bound creatures
		binded.SetParalyzed(900)
		return binded

// ----- Infernal Binding -----

/datum/runeritual/binding/infernal_t1
	name = "Bind Imp"
	desc = "Bind a imp to your service."
	blacklisted = FALSE
	tier = 1
	mob_to_bind = /mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp
	required_atoms = list(/obj/item/magic/infernal/ash = 4, /obj/item/magic/melded/t1 = 1, /obj/item/magic/artifact = 1)

/datum/runeritual/binding/infernal_t2
	name = "Bind Hellhound"
	desc = "Bind a hellhound to your service."
	blacklisted = FALSE
	tier = 2
	mob_to_bind = /mob/living/simple_animal/hostile/retaliate/rogue/infernal/hellhound
	required_atoms = list(/obj/item/magic/infernal/fang = 2, /obj/item/magic/melded/t2 = 1, /obj/item/magic/artifact = 2)

/datum/runeritual/binding/infernal_t3
	name = "Bind Watcher"
	desc = "Bind a watcher to your service."
	blacklisted = FALSE
	tier = 3
	mob_to_bind = /mob/living/simple_animal/hostile/retaliate/rogue/infernal/watcher
	required_atoms = list(/obj/item/magic/infernal/core = 1, /obj/item/magic/melded/t3 = 1, /obj/item/magic/artifact = 3)

/datum/runeritual/binding/infernal_t4
	name = "Bind Fiend"
	desc = "Bind an infernal fiend to your service."
	blacklisted = FALSE
	tier = 4
	mob_to_bind = /mob/living/simple_animal/hostile/retaliate/rogue/infernal/fiend
	required_atoms = list(/obj/item/magic/infernal/flame = 1, /obj/item/magic/melded/t4 = 1, /obj/item/magic/artifact = 4)

// ----- Fae Binding -----

/datum/runeritual/binding/fae_t1
	name = "Bind Sprite"
	desc = "Bind a sprite to your service."
	blacklisted = FALSE
	tier = 1
	mob_to_bind = /mob/living/simple_animal/hostile/retaliate/rogue/fae/sprite
	required_atoms = list(/obj/item/magic/fae/fairydust = 4, /obj/item/magic/melded/t1 = 1, /obj/item/magic/artifact = 1)

/datum/runeritual/binding/fae_t2
	name = "Bind Glimmerwing"
	desc =	 "Bind a glimmerwing to your service."
	blacklisted = FALSE
	tier = 2
	mob_to_bind = /mob/living/simple_animal/hostile/retaliate/rogue/fae/glimmerwing
	required_atoms = list(/obj/item/magic/fae/iridescentscale = 2, /obj/item/magic/melded/t2 = 1, /obj/item/magic/artifact = 2)

/datum/runeritual/binding/fae_t3
	name = "Bind Dryad"
	desc = "Bind a dryad to your service."
	blacklisted = FALSE
	tier = 3
	mob_to_bind = /mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad
	required_atoms = list(/obj/item/magic/fae/heartwoodcore = 1, /obj/item/magic/melded/t3 = 1, /obj/item/magic/artifact = 3)

/datum/runeritual/binding/fae_t4
	name = "Bind Sylph"
	desc = "Bind a sylph to your service."
	blacklisted = FALSE
	tier = 4
	mob_to_bind = /mob/living/simple_animal/hostile/retaliate/rogue/fae/sylph
	required_atoms = list(/obj/item/magic/fae/sylvanessence = 1, /obj/item/magic/melded/t4 = 1, /obj/item/magic/artifact = 4)

// ----- Elemental Binding -----

/datum/runeritual/binding/elemental_t1
	name = "Bind Crawler"
	desc = "Bind a crawler to your service."
	blacklisted = FALSE
	tier = 1
	mob_to_bind = /mob/living/simple_animal/hostile/retaliate/rogue/elemental/crawler
	required_atoms = list(/obj/item/magic/elemental/mote = 4, /obj/item/magic/melded/t1 = 1, /obj/item/magic/artifact = 1)

/datum/runeritual/binding/elemental_t2
	name = "Bind Warden"
	desc = "Bind a warden to your service."
	blacklisted = FALSE
	tier = 2
	mob_to_bind = /mob/living/simple_animal/hostile/retaliate/rogue/elemental/warden
	required_atoms = list(/obj/item/magic/elemental/shard = 2, /obj/item/magic/melded/t2 = 1, /obj/item/magic/artifact = 2)

/datum/runeritual/binding/elemental_t3
	name = "Bind Behemoth"
	desc = "Bind a behemoth to your service."
	blacklisted = FALSE
	tier = 3
	mob_to_bind = /mob/living/simple_animal/hostile/retaliate/rogue/elemental/behemoth
	required_atoms = list(/obj/item/magic/elemental/fragment = 1, /obj/item/magic/melded/t3 = 1, /obj/item/magic/artifact = 3)

/datum/runeritual/binding/elemental_t4
	name = "Bind Colossus"
	desc = "Bind a colossus to your service."
	blacklisted = FALSE
	tier = 4
	mob_to_bind = /mob/living/simple_animal/hostile/retaliate/rogue/elemental/colossus
	required_atoms = list(/obj/item/magic/elemental/relic = 1, /obj/item/magic/melded/t4 = 1, /obj/item/magic/artifact = 4)

// ----- Void Dragon Binding -----

/datum/runeritual/binding/void_dragon
	name = "Bind Void Dragon"
	desc = "Sacrifice the spoils of a slain void dragon to bind another to your service. Only those who have already felled one may attempt this."
	blacklisted = FALSE
	tier = 5
	mob_to_bind = /mob/living/simple_animal/hostile/retaliate/rogue/voiddragon
	required_atoms = list(/obj/item/clothing/ring/dragon_ring = 3, /obj/item/book/granter/spell_points/voiddragon = 3)
