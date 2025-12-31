/mob/living/simple_animal/hostile/retaliate/rogue/fae/sylph
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "sylph"
	desc = "This creature shifts in the breeze as if it were constructed of fabric and \
	nothing more. Its face, owl-like, is flanked by near-draconic wings. If this is one of the \
	fae-folk, it must be one of their rulers."
	icon_state = "sylph"
	icon_living = "sylph"
	icon_dead = "vvd"
	summon_tier = 4
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 6
	see_in_dark = 6
	move_to_delay = 3
	base_intents = list(/datum/intent/simple/bite)
	butcher_results = list()
	faction = list("fae")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 700
	maxHealth = 700
	melee_damage_lower = 20
	melee_damage_upper = 30
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	simple_detect_bonus = 20
	retreat_distance = 4
	minimum_distance = 4
	food_type = list()
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	STACON = 13
	STASTR = 12
	STASPD = 8
	simple_detect_bonus = 20
	deaggroprob = 0
	defprob = 50
	candodge = TRUE
	// del_on_deaggro = 44 SECONDS
	retreat_health = 0.3
	food = 0
	attack_sound = null
	dodgetime = 40
	aggressive = 1
	ranged = TRUE
	rapid = 3
	projectiletype = /obj/projectile/magic/frostbolt/greater
	ranged_message = "throws icy magick"
	var/shroom_cd = 0
	var/summon_cd = 0
	inherent_spells = list(/obj/effect/proc_holder/spell/invoked/create_shrooms)

/obj/projectile/magic/frostbolt/greater
	name = "greater frostbolt"
	damage = 25
	range = 6
	speed = 6 //higher is slower

/mob/living/simple_animal/hostile/retaliate/rogue/fae/sylph/Initialize()
	src.adjust_skillrank(/datum/skill/combat/unarmed, 5, TRUE)
	. = ..()

/mob/living/simple_animal/hostile/retaliate/rogue/fae/sylph/simple_add_wound(datum/wound/wound, silent = FALSE, crit_message = FALSE)	//no wounding the fiend
	return

/mob/living/simple_animal/hostile/retaliate/rogue/fae/sylph/OpenFire(atom/A)
	if(CheckFriendlyFire(A))
		return
	visible_message(span_danger("<b>[src]</b> [ranged_message] at [A]!"))

	if(world.time >= shroom_cd + 25 SECONDS && !mind)
		var/mob/living/targetted = target
		create_shroom(targetted)
		src.shroom_cd = world.time
	if(rapid > 1)
		var/datum/callback/cb = CALLBACK(src, PROC_REF(Shoot), A)
		for(var/i in 1 to rapid)
			addtimer(cb, (i - 1)*rapid_fire_delay)
	else
		Shoot(A)
	ranged_cooldown = world.time + ranged_cooldown_time


/mob/living/simple_animal/hostile/retaliate/rogue/fae/sylph/proc/create_shroom(atom/target)
	if(!target)
		return
	var/turf/target_turf = target // need to handle it this way so player sylphs can target turfs with this spell
	if(isliving(target))
		target_turf = target.loc
	for(var/turf/turf as anything in RANGE_TURFS(3,target_turf))
		if(prob(30))
			new /obj/structure/glowshroom(turf)


/mob/living/simple_animal/hostile/retaliate/rogue/fae/sylph/death(gibbed)
	..()
	var/turf/deathspot = get_turf(src)
	new /obj/item/magic/sylvanessence(deathspot)
	new /obj/item/magic/iridescentscale(deathspot)
	new /obj/item/magic/iridescentscale(deathspot)
	new /obj/item/magic/heartwoodcore(deathspot)
	new /obj/item/magic/heartwoodcore(deathspot)
	new /obj/item/magic/fairydust(deathspot)
	new /obj/item/magic/fairydust(deathspot)
	new /obj/item/magic/fairydust(deathspot)
	new /obj/item/magic/fairydust(deathspot)
	new /obj/item/magic/melded/t2(deathspot)
	update_icon()
	spill_embedded_objects()
	qdel(src)

/obj/effect/proc_holder/spell/invoked/create_shrooms
	name = "Spread Kneestingers"
	recharge_time = 20 SECONDS
	sound = 'sound/magic/churn.ogg'
	overlay_state = "blesscrop"
	chargetime = 0
	range = 15

/obj/effect/proc_holder/spell/invoked/create_shrooms/cast(list/targets, mob/living/user = usr)
	if(istype(user, /mob/living/simple_animal/hostile/retaliate/rogue/fae/sylph))
		var/mob/living/simple_animal/hostile/retaliate/rogue/fae/sylph/treeguy = user
		if(world.time <= treeguy.shroom_cd + 200)//shouldn't ever happen cuz the spell cd is the same as summon_cd but I'd rather it check with the internal cd just in case
			to_chat(user,span_warning("Too soon!"))
			revert_cast()
			return FALSE
		treeguy.create_shroom(targets[1])
		treeguy.shroom_cd = world.time
