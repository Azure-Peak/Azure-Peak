						//////////////////////////////////////////////
						// Dyrevolf (or Direwolf if you are normal) //
						//////////////////////////////////////////////

/mob/living/simple_animal/hostile/retaliate/rogue/dyrevolf/Initialize(mapload, mob/user)
	if(user)
		if(user.mind && user.mind.current)
			summoner = user.mind.current.real_name
		else
			summoner = user.name
	// adds the name of the summoner to the faction, to avoid the hooded "Unknown" bug with Skeleton IDs
	if(user && user.mind && user.mind.current)
		faction = list("[user.mind.current.real_name]_faction")
	apply_fellowship_faction(user, src)
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOFIRE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NIGHT_VISION, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BASHDOORS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOSTINK, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_STRONGBITE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOFALLDAMAGE1, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	src.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)

/datum/intent/simple/claw/dyrevolf
	name = "claw"
	icon_state = "instrike"
	attack_verb = list("claws", "rends")
	animname = "blank22"
	blade_class = BCLASS_CUT
	hitsound = "smallslash"
	chargetime = 0
	penfactor = PEN_MEDIUM
	candodge = TRUE
	canparry = TRUE
	miss_text = "slash the air"
	item_d_type = "slash"
	clickcd = 12

/mob/living/simple_animal/hostile/retaliate/rogue/dyrevolf
	icon = 'icons/roguetown/mob/monster/direvolf.dmi'
	AIStatus = AI_OFF
	can_have_ai = FALSE
	faction = list(FACTION_NEUTRAL)
	var/next_ability_use
	var/ability_cooldown = 30 SECONDS

/mob/living/simple_animal/hostile/retaliate/rogue/dyrevolf/death()
	..()
	spill_embedded_objects()
	qdel(src)

/mob/living/simple_animal/hostile/retaliate/rogue/dyrevolf/proc/ability(turf/target_location, mob/living/user)
	return

/mob/living/simple_animal/hostile/retaliate/rogue/dyrevolf/get_pilot_ability()
	return /datum/action/cooldown/spell/dyrevolf_special

/datum/action/cooldown/spell/dyrevolf_special
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	button_icon_state = "primordial_mark"
	name = "Primal Savagery"
	desc = "Unleash true potential of your raised volf - Ancient swipes in front of him, rooting enemies."
	sound = null
	spell_color = GLOW_COLOR_DENDOR
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = null

	click_to_activate = TRUE
	cast_range = 6
	self_cast_possible = FALSE

	charge_required = FALSE
	primary_resource_type = SPELL_COST_NONE
	cooldown_time = 30 SECONDS
	spell_tier = 0
	point_cost = 0
	spell_impact_intensity = SPELL_IMPACT_NONE
	invocation_type = INVOCATION_NONE
	spell_requirements = SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/dyrevolf_special/cast(atom/cast_on)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/rogue/dyrevolf/P = owner
	if(!istype(P))
		return FALSE
	var/turf/T = get_turf(cast_on)
	if(!T)
		return FALSE
	if(world.time < P.next_ability_use)
		P.balloon_alert(P, "not ready yet!")
		return FALSE
	P.ability(T, P)
	return TRUE

/mob/living/simple_animal/hostile/retaliate/rogue/dyrevolf/ancient
	name = "ancient dyrevolf"
	desc = "A humble defender of the Grove brought back with divine powers."
	icon_state = "direvolf_brown"
	icon_living = "direvolf_brown"
	icon_dead = "direvolf_brown_dead"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	emote_hear = null
	emote_see = null
	turns_per_move = 6
	see_in_dark = 10
	move_to_delay = 3

	attack_sound = list('sound/vo/mobs/vw/attack (1).ogg','sound/vo/mobs/vw/attack (2).ogg','sound/vo/mobs/vw/attack (3).ogg','sound/vo/mobs/vw/attack (4).ogg')

	base_intents = list(/datum/intent/simple/claw/dyrevolf)
	health = 300
	maxHealth = 300
	melee_damage_lower = 30
	melee_damage_upper = 40
	vision_range = 10
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0
	next_ability_use
	STACON = 12
	STASTR = 12
	STASPD = 13
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	defprob = 30
	retreat_health = 0
	food = 0
	next_ability_use
	ai_controller = /datum/ai_controller/flame_primordial //Prob replace these later but for the time being it serves its purpose.

/mob/living/simple_animal/hostile/retaliate/rogue/dyrevolf/ancient/ability(turf/target_location, mob/living/user)
	if(world.time < src.next_ability_use)
		to_chat(user, "[src] is not yet ready to use its special ability.")
		return FALSE
	if(!do_after(src,1 SECONDS, src))
		return
	var/range = 3
	var/angle = 60 // cone angle in degrees

	// Get facing vector from mob → target
	var/dx = target_location.x - src.x
	var/dy = target_location.y - src.y

	var/dir_angle = ATAN2(dy, dx) // radians

	visible_message(span_danger("[src] exhales a cone of searing fire!"))

	for(var/turf/T in view(range, src))
		var/tx = T.x - src.x
		var/ty = T.y - src.y
		var/mag = sqrt(tx*tx + ty*ty)
		if(mag == 0)
			continue

		tx /= mag
		ty /= mag

		var/angle_to_turf = ATAN2(ty, tx)
		var/delta = abs(dir_angle - angle_to_turf)
		if(delta > 180)
			delta = 360 - delta // handle wrap-around

		if(delta <= angle/2) // inside cone
			new /obj/effect/hotspot(T)
			// Damage mobs on this turf
			for(var/mob/living/M in T)
				if(M == src)
					continue
				M.Immobilize(3 SECONDS)

	src.next_ability_use = world.time + src.ability_cooldown
	return TRUE
