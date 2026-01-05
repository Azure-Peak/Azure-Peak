/mob/living/simple_animal/hostile/retaliate/rogue/fae/glimmerwing
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "glimmerwing"
	desc = "A middlingly-sized fae-creature, held aloft upon fluttering wings and glimmering with unearthly \
	light. Both wonderous and capricious, and the subjects of many cautionary tales."
	icon_state = "glimmerwing"
	icon_living = "glimmerwing"
	icon_dead = "vvd"
	summon_primer = "You are a glimmerwing, a moderate sized fae. You spend time wandering forests, cursing unweary travellers. Now you've been pulled from your home into a new world, that is decidedly less wild and natural. How you react to these events, only time can tell."
	summon_tier = 2
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 6
	see_in_dark = 6
	move_to_delay = 6
	base_intents = list(/datum/intent/simple/bite)
	butcher_results = list()
	faction = list("fae")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 270
	maxHealth = 270
	melee_damage_lower = 15
	melee_damage_upper = 17
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	simple_detect_bonus = 20
	ranged = FALSE
	retreat_distance = 0
	minimum_distance = 0
	food_type = list()
	movement_type = FLYING
	pooptype = null
	STACON = 7
	STASTR = 9
	STASPD = 15
	simple_detect_bonus = 20
	deaggroprob = 0
	defprob = 40
	candodge = TRUE
	// del_on_deaggro = 44 SECONDS
	retreat_health = 0.3
	food = 0
	attack_sound = 'sound/blank.ogg'
	dodgetime = 40
	aggressive = 1
	var/drug_cd

/mob/living/simple_animal/hostile/retaliate/rogue/fae/glimmerwing/Initialize()
	src.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	. = ..()

/mob/living/simple_animal/hostile/retaliate/rogue/fae/glimmerwing/death(gibbed)
	..()
	var/turf/deathspot = get_turf(src)
	new /obj/item/magic/iridescentscale(deathspot)
	new /obj/item/magic/iridescentscale(deathspot)
	new /obj/item/magic/iridescentscale(deathspot)
	new /obj/item/magic/iridescentscale(deathspot)
	new /obj/item/magic/fairydust(deathspot)
	new /obj/item/magic/fairydust(deathspot)
	new /obj/item/magic/fairydust(deathspot)
	new /obj/item/magic/fairydust(deathspot)
	update_icon()
	spill_embedded_objects()
	qdel(src)

/mob/living/simple_animal/hostile/retaliate/rogue/fae/glimmerwing/AttackingTarget()
	if(SEND_SIGNAL(src, COMSIG_HOSTILE_PRE_ATTACKINGTARGET, target) & COMPONENT_HOSTILE_NO_PREATTACK)
		return FALSE //but more importantly return before attack_animal called
	SEND_SIGNAL(src, COMSIG_HOSTILE_ATTACKINGTARGET, target)
	in_melee = TRUE
	if(!target)
		return
	if(world.time >= src.drug_cd + 25 SECONDS)
		var/mob/living/targetted = target
		targetted.apply_status_effect(/datum/status_effect/buff/seelie_drugs)
		targetted.visible_message(span_danger("[src] dusts [target] with some kind of powder!"))
		targetted.adjustToxLoss(15)
		src.drug_cd = world.time
	if(!QDELETED(target))
		return target.attack_animal(src)
