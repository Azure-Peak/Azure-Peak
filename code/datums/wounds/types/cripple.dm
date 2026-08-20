/datum/wound/cripple
	name = "crippling wound"
	check_name = span_bone("<B>CRIPPLED</B>")
	severity = WOUND_SEVERITY_SEVERE
	whp = 70
	woundpain = 30
	mob_overlay = null
	sound_effect = "wetbreak"
	can_sew = FALSE
	can_cauterize = TRUE
	bleed_rate = 0
	sleep_healing = 0
	critical = TRUE
	var/crippled_zone
	var/break_alert
	var/mob/struck_by
	var/attack_delay_mult = 1
	var/static/list/kill_verbs = list("ENDED", "SLAIN", "SLAUGHTERED", "MURDERED", "SNUFFED", "BUTCHERED", "FELLED", "FINISHED")

/datum/wound/cripple/on_mob_gain(mob/living/affected)
	. = ..()
	if(attack_delay_mult != 1)
		affected.next_move_modifier *= attack_delay_mult
	if(break_alert)
		affected.balloon_alert_to_viewers("<font color='#ff3b3b'>[break_alert]</font>")

/datum/wound/cripple/on_mob_loss(mob/living/affected)
	. = ..()
	if(attack_delay_mult != 1)
		affected.next_move_modifier /= attack_delay_mult
	if(crippled_zone && istype(affected, /mob/living/simple_animal))
		var/mob/living/simple_animal/animal = affected
		animal.clear_part_damage(crippled_zone)

/datum/wound/cripple/limb
	name = "crippled limb"
	crit_message = list(
		"The leg gives out!",
		"The limb buckles and folds!",
		"The joint is smashed apart!",
	)
	break_alert = "leg crippled!"
	var/slowdown = CRIPPLE_MOVE_PENALTY_MINOR

/datum/wound/cripple/limb/on_mob_gain(mob/living/affected)
	. = ..()
	affected.add_movespeed_modifier("cripple_[crippled_zone]", multiplicative_slowdown = slowdown)

/datum/wound/cripple/limb/on_mob_loss(mob/living/affected)
	. = ..()
	affected.remove_movespeed_modifier("cripple_[crippled_zone]")

/datum/wound/cripple/maw
	name = "shattered maw"
	crit_message = list(
		"The jaw is smashed!",
		"The maw is torn asunder!",
		"The fangs are broken loose!",
	)
	break_alert = "jaw shattered!"
	attack_delay_mult = CRIPPLE_ATTACK_DELAY_MAJOR
	var/damage_penalty = CRIPPLE_DAMAGE_PENALTY_MAJOR
	var/removed_lower = 0
	var/removed_upper = 0

/datum/wound/cripple/maw/on_mob_gain(mob/living/affected)
	. = ..()
	if(istype(affected, /mob/living/simple_animal))
		var/mob/living/simple_animal/animal = affected
		removed_lower = round(animal.melee_damage_lower * damage_penalty, 1)
		removed_upper = round(animal.melee_damage_upper * damage_penalty, 1)
		animal.melee_damage_lower = max(0, animal.melee_damage_lower - removed_lower)
		animal.melee_damage_upper = max(0, animal.melee_damage_upper - removed_upper)
	ADD_TRAIT(affected, TRAIT_NO_BITE, "[type]")

/datum/wound/cripple/maw/on_mob_loss(mob/living/affected)
	. = ..()
	if(istype(affected, /mob/living/simple_animal))
		var/mob/living/simple_animal/animal = affected
		animal.melee_damage_lower += removed_lower
		animal.melee_damage_upper += removed_upper
	REMOVE_TRAIT(affected, TRAIT_NO_BITE, "[type]")

/datum/wound/cripple/arm
	name = "mangled arm"
	crit_message = list(
		"The arm is mangled!",
		"The shoulder is wrenched apart!",
		"The arm is left hanging useless!",
	)
	break_alert = "arm mangled!"
	attack_delay_mult = CRIPPLE_ATTACK_DELAY_MINOR
	var/damage_penalty = CRIPPLE_DAMAGE_PENALTY_MINOR
	var/removed_lower = 0
	var/removed_upper = 0

/datum/wound/cripple/arm/on_mob_gain(mob/living/affected)
	. = ..()
	if(istype(affected, /mob/living/simple_animal))
		var/mob/living/simple_animal/animal = affected
		removed_lower = round(animal.melee_damage_lower * damage_penalty, 1)
		removed_upper = round(animal.melee_damage_upper * damage_penalty, 1)
		animal.melee_damage_lower = max(0, animal.melee_damage_lower - removed_lower)
		animal.melee_damage_upper = max(0, animal.melee_damage_upper - removed_upper)

/datum/wound/cripple/arm/on_mob_loss(mob/living/affected)
	. = ..()
	if(istype(affected, /mob/living/simple_animal))
		var/mob/living/simple_animal/animal = affected
		animal.melee_damage_lower += removed_lower
		animal.melee_damage_upper += removed_upper

/datum/wound/cripple/arm/foreleg
	name = "mangled foreleg"
	crit_message = list(
		"The foreleg buckles!",
		"The foreleg is torn apart!",
		"The paw is crushed!",
	)
	break_alert = "foreleg maimed!"

/datum/wound/cripple/skull
	name = "caved skull"
	crit_message = list(
		"The skull cracks!",
		"The head is caved in!",
		"The skull is battered inward!",
	)
	break_alert = "skull caved!"
	whp = 85
	var/vision_penalty = 3
	var/removed_vision = 0
	var/removed_aggro = 0
	var/mortal_break = FALSE

/datum/wound/cripple/skull/on_mob_gain(mob/living/affected)
	. = ..()
	if(istype(affected, /mob/living/simple_animal/hostile))
		var/mob/living/simple_animal/hostile/hostile_affected = affected
		removed_vision = min(vision_penalty, max(0, hostile_affected.vision_range - 1))
		removed_aggro = min(vision_penalty, max(0, hostile_affected.aggro_vision_range - 1))
		hostile_affected.vision_range = max(1, hostile_affected.vision_range - removed_vision)
		hostile_affected.aggro_vision_range = max(1, hostile_affected.aggro_vision_range - removed_aggro)
	affected.Knockdown(10)
	if(mortal_break)
		ADD_TRAIT(affected, TRAIT_CRITICAL_WEAKNESS, "[type]")

/datum/wound/cripple/skull/on_mob_loss(mob/living/affected)
	. = ..()
	if(istype(affected, /mob/living/simple_animal/hostile))
		var/mob/living/simple_animal/hostile/hostile_affected = affected
		hostile_affected.vision_range += removed_vision
		hostile_affected.aggro_vision_range += removed_aggro
	if(mortal_break)
		REMOVE_TRAIT(affected, TRAIT_CRITICAL_WEAKNESS, "[type]")

/datum/wound/cripple/skull/blinded
	name = "burst eye"
	crit_message = list(
		"The eye bursts, molten liquids running out!",
		"The eye splits apart!",
	)
	break_alert = "EYE BURST!"
	vision_penalty = 5

/datum/wound/cripple/skull/silenced
	name = "shattered jaw"
	crit_message = list(
		"The jaw hangs slack!",
		"The skull caves!",
	)
	break_alert = "silenced!"

/datum/wound/cripple/fatal
	var/list/debris_types
	var/debris_effect = /obj/effect/gibspawner/generic

/datum/wound/cripple/fatal/on_mob_gain(mob/living/affected)
	. = ..()
	if(istype(affected, /mob/living/simple_animal))
		var/mob/living/simple_animal/animal = affected
		animal.no_reanimate = TRUE
	affected.visible_message(span_danger(kill_message(affected)))
	var/turf/where = affected.drop_location()
	for(var/debris in debris_types)
		new debris(where)
	if(debris_effect)
		new debris_effect(where, affected)
	affected.death()

/datum/wound/cripple/fatal/proc/kill_message(mob/living/affected)
	return "<B>[affected] is <span class='crit'>[pick(kill_verbs)]</span>!</B>"

/datum/wound/cripple/fatal/decapitate
	name = "destroyed head"
	break_alert = "HEAD DESTROYED!"

/datum/wound/cripple/fatal/decapitate/kill_message(mob/living/affected)
	return "<B>[affected] is <span class='crit'>[pick(kill_verbs)]</span> as [affected.p_their()] ravaged neck <span class='crit'>BLOSSOMS</span> into petals of <span class='crit'>GORE and BONE!</span></B>"

/datum/wound/cripple/fatal/decapitate/small

/datum/wound/cripple/fatal/guts
	name = "spilled guts"
	break_alert = "GUTS SPILLED!"
	debris_types = list(/obj/item/alch/viscera)

/datum/wound/cripple/fatal/guts/kill_message(mob/living/affected)
	return "<B>[affected] is <span class='crit'>[pick(kill_verbs)]</span> as [affected.p_their()] split belly <span class='crit'>UNSPOOLS</span> into ropes of <span class='crit'>GORE and OFFAL!</span></B>"

/datum/wound/cripple/fatal/core
	name = "shattered core"
	break_alert = "CORE SHATTERED!"
	sound_effect = "fracturedry"
	debris_effect = null

/datum/wound/cripple/fatal/core/kill_message(mob/living/affected)
	return "<B>[affected] is <span class='crit'>[pick(kill_verbs)]</span> as [affected.p_their()] core <span class='crit'>BURSTS</span> and the whole body <span class='crit'>COLLAPSES INTO RUBBLE!</span></B>"

/datum/wound/cripple/limb/topple
	name = "shattered leg"
	crit_message = list(
		"The leg shatters - it crashes to the ground!",
		"The knee is blown out, and it falls flat!",
	)
	break_alert = "toppled!"
	slowdown = CRIPPLE_MOVE_PENALTY_MAJOR
	var/matrix/upright_transform

/datum/wound/cripple/limb/topple/can_stack_with(datum/wound/other)
	return !istype(other, /datum/wound/cripple/limb/topple)

/datum/wound/cripple/limb/topple/on_mob_gain(mob/living/affected)
	. = ..()
	affected.Stun(20, ignore_canstun = TRUE)
	var/mob/living/simple_animal/animal = affected
	if(istype(animal) && animal.sprite_drawn_prone())
		return
	upright_transform = matrix(affected.transform)
	animate(affected, transform = turn(upright_transform, 90), time = 2)

/datum/wound/cripple/limb/topple/on_mob_loss(mob/living/affected)
	. = ..()
	stand_upright(affected)

/datum/wound/cripple/limb/topple/proc/stand_upright(mob/living/affected)
	if(!upright_transform)
		return
	animate(affected, transform = upright_transform, time = 2)
	upright_transform = null

/datum/wound/cripple/limb/undead
	name = "dragging leg"
	crit_message = list(
		"The leg snaps, and starts to drag behind it!",
		"The rotten limb folds under its own weight!",
		"The joint bursts apart in a spray of foul ichor!",
	)
	break_alert = "leg broken!"
	attack_delay_mult = CRIPPLE_ATTACK_DELAY_MAJOR

/datum/wound/cripple/limb/core
	name = "ruptured core"
	crit_message = list(
		"The core is burst apart!",
		"The core is pierced!",
		"The mass is torn open!",
	)
	break_alert = "core ruptured!"

/datum/wound/cripple/maw/fangs
	name = "shattered fangs"
	crit_message = list(
		"The fangs are snapped off!",
		"The mouthparts are torn away!",
		"The fangs are sheared off!",
	)
	break_alert = "fangs broken!"

/datum/wound/cripple/spinneret
	name = "burst spinnerets"
	crit_message = list(
		"The spinnerets are torn open!",
		"The abdomen is split!",
		"The silk glands are burst!",
	)
	break_alert = "spinnerets burst!"
	var/removed_ranged = FALSE

/datum/wound/cripple/spinneret/on_mob_gain(mob/living/affected)
	. = ..()
	var/mob/living/simple_animal/hostile/beast = affected
	if(istype(beast) && beast.ranged)
		beast.ranged = FALSE
		removed_ranged = TRUE

/datum/wound/cripple/spinneret/on_mob_loss(mob/living/affected)
	. = ..()
	var/mob/living/simple_animal/hostile/beast = affected
	if(removed_ranged && istype(beast))
		beast.ranged = TRUE
	removed_ranged = FALSE

/datum/wound/cripple/arm/tentacle
	name = "severed tentacle"
	crit_message = list(
		"The tentacle is severed!",
		"The tentacle is cut!",
		"The tentacle flies off in an arc!",
	)
	break_alert = "tentacle severed!"

/datum/wound/cripple/maw/tongue
	name = "severed tongue"
	crit_message = list(
		"The tongue is cut!",
		"The tongue is severed!",
		"The tongue flies off in an arc!",
	)
	break_alert = "tongue severed!"

/datum/wound/cripple/limb/topple/root
	name = "severed roots"
	crit_message = list(
		"The roots split and the dryad topples!!",
	)
	break_alert = "roots severed!"
	sound_effect = "plantcross"

/datum/wound/cripple/limb/wing
	name = "torn wing"
	crit_message = list(
		"The wing tears through!",
		"The wing is torn apart!",
		"The wing is shorn away!",
	)
	break_alert = "wing torn!"
	slowdown = CRIPPLE_MOVE_PENALTY_MAJOR
	attack_delay_mult = CRIPPLE_ATTACK_DELAY_MINOR
	var/removed_flight = FALSE
	var/removed_dodge = FALSE

/datum/wound/cripple/limb/wing/on_mob_gain(mob/living/affected)
	. = ..()
	if(affected.movement_type & FLYING)
		affected.setMovetype(affected.movement_type & ~FLYING)
		removed_flight = TRUE
	if(affected.candodge)
		affected.candodge = FALSE
		removed_dodge = TRUE

/datum/wound/cripple/limb/wing/on_mob_loss(mob/living/affected)
	. = ..()
	for(var/datum/wound/cripple/limb/wing/other in affected.simple_wounds)
		if(other != src)
			return
	if(removed_flight)
		affected.setMovetype(affected.movement_type | FLYING)
		removed_flight = FALSE
	if(removed_dodge)
		affected.candodge = TRUE
		removed_dodge = FALSE

/datum/wound/cripple/limb/fracture
	name = "fractured leg"
	crit_message = list(
		"The leg cracks through!",
		"The limb crumbles at the joint!",
		"A slab shears off the leg!",
	)
	break_alert = "leg fractured!"
	sound_effect = "fracturedry"

/datum/wound/cripple/limb/topple/fracture
	name = "shattered leg"
	crit_message = list(
		"The leg bursts apart!",
		"The knee shatters!",
	)
	break_alert = "toppled!"
	sound_effect = "fracturedry"

/datum/wound/cripple/limb/core/fracture
	name = "cracked core"
	crit_message = list(
		"The core splits open!",
		"A crack runs clean through the core!",
		"The core grinds and shatter!",
	)
	break_alert = "core cracked!"
	sound_effect = "fracturedry"

/datum/wound/cripple/arm/fracture
	name = "fractured arm"
	crit_message = list(
		"The arm cracks through!",
		"The shoulder crumbles away!",
		"The arm breaks off in slabs!",
	)
	break_alert = "arm fractured!"
	sound_effect = "fracturedry"
