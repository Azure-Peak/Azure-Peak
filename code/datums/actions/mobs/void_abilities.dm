/datum/action/cooldown/spell/voiddragon
	abstract_type = /datum/action/cooldown/spell/voiddragon
	button_icon = 'icons/mob/actions/mob_actions.dmi'
	button_icon_state = "mob_ability"
	panel = null
	use_chance = 100
	shared_cooldown = "mob_special"
	lockout_time = 3 SECONDS
	npc_min_range = 0
	npc_max_range = 15
	cast_range = 15

	click_to_activate = TRUE
	retrigger_after_cooldown = FALSE
	self_cast_possible = FALSE
	invocations = list()
	invocation_type = INVOCATION_NONE
	sound = null
	primary_resource_type = SPELL_COST_NONE
	spell_requirements = SPELL_REQUIRES_SAME_Z
	associated_stat = null
	has_visual_effects = FALSE
	glow_intensity = 0
	spell_impact_intensity = SPELL_IMPACT_NONE
	blocked_by_antimagic = FALSE
	charge_required = FALSE

/datum/action/cooldown/spell/voiddragon/can_cast_spell(feedback = TRUE)
	var/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/dragon = owner
	return ..() && istype(dragon) && !dragon.swooping

/datum/action/cooldown/spell/voiddragon/sundering_lightning
	name = "Summon Sundering Lightning"
	desc = "Calls down a spiral of lightning around the target."
	cooldown_time = 25 SECONDS

/datum/action/cooldown/spell/voiddragon/sundering_lightning/cast(atom/cast_on)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/dragon = owner
	dragon.visible_message(span_danger("[dragon] calls forth lightning from the sky!"))
	INVOKE_ASYNC(dragon, TYPE_PROC_REF(/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon, create_lightning), cast_on)
	return TRUE

/datum/action/cooldown/spell/voiddragon/chain_lightning
	name = "Chain Lightning"
	desc = "Unleashes lightning from the maw that leaps between those nearby."
	cooldown_time = 50 SECONDS
	npc_max_range = 3

/datum/action/cooldown/spell/voiddragon/chain_lightning/cast(atom/cast_on)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/dragon = owner
	dragon.visible_message(span_colossus("[dragon] opens its maw, and lightning crackles beyond its teeth!"))
	return dragon.chain_lightning(cast_on)

/datum/action/cooldown/spell/voiddragon/summon_obelisks
	name = "Summon Obelisks"
	desc = "Raises two voidstone obelisks from beneath the ground."
	cooldown_time = 200 SECONDS
	click_to_activate = FALSE
	self_cast_possible = TRUE

/datum/action/cooldown/spell/voiddragon/summon_obelisks/can_use(atom/target)
	var/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/dragon = owner
	return ..() && dragon.health <= dragon.maxHealth * 0.75

/datum/action/cooldown/spell/voiddragon/summon_obelisks/cast(atom/cast_on)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/dragon = owner
	dragon.summon_obelisk()
	return TRUE

/datum/action/cooldown/spell/voiddragon/swoop
	name = "Swoop Attack"
	desc = "Takes to the sky and crashes down onto the target."
	cooldown_time = 30 SECONDS

/datum/action/cooldown/spell/voiddragon/swoop/npc_use_chance(atom/target)
	var/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/dragon = owner
	return 15 + clamp(max((dragon.maxHealth - dragon.health) / 50, dragon.enraged ? 15 : 0), 0, 20)

/datum/action/cooldown/spell/voiddragon/swoop/cast(atom/cast_on)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/dragon = owner
	if(dragon.health >= dragon.maxHealth * 0.5)
		INVOKE_ASYNC(dragon, TYPE_PROC_REF(/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon, lightning_strikes), cast_on, dragon.enraged ? 60 : 30)
	INVOKE_ASYNC(dragon, TYPE_PROC_REF(/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon, swoop_attack), cast_on)
	return TRUE

/datum/action/cooldown/spell/voiddragon/slam
	name = "Slam"
	desc = "Slams the ground, sending a shockwave that throws back everything nearby."
	cooldown_time = 15 SECONDS
	shared_cooldown = null
	npc_min_range = 0
	npc_max_range = 1
	click_to_activate = FALSE
	self_cast_possible = TRUE

/datum/action/cooldown/spell/voiddragon/slam/cast(atom/cast_on)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon/dragon = owner
	dragon.visible_message(span_colossus("[dragon] slams the ground, creating a shockwave!"))
	INVOKE_ASYNC(dragon, TYPE_PROC_REF(/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon, dragon_slam), dragon, 2, 10, 8)
	return TRUE

/datum/action/cooldown/spell/obelisk_beam
	name = "Fire Beam"
	desc = "Charges up and fires an aberrant beam in a straight line."
	button_icon = 'icons/mob/actions/mob_actions.dmi'
	button_icon_state = "mob_ability"
	panel = null
	use_chance = 100
	cooldown_time = 20 SECONDS
	npc_max_range = 9
	cast_range = 10

	click_to_activate = TRUE
	retrigger_after_cooldown = FALSE
	self_cast_possible = FALSE
	invocations = list()
	invocation_type = INVOCATION_NONE
	sound = null
	primary_resource_type = SPELL_COST_NONE
	spell_requirements = SPELL_REQUIRES_SAME_Z
	associated_stat = null
	has_visual_effects = FALSE
	glow_intensity = 0
	spell_impact_intensity = SPELL_IMPACT_NONE
	blocked_by_antimagic = FALSE
	charge_required = FALSE

	var/beam_range = 10
	var/beam_duration = 5 SECONDS
	var/charge_duration = 1 SECONDS
	var/static/image/direction_overlay = image('icons/effects/effects.dmi', "obeliak_telegraph_dir")
	var/list/beam_parts = list()

/datum/action/cooldown/spell/obelisk_beam/Destroy()
	extinguish_laser()
	return ..()

/datum/action/cooldown/spell/obelisk_beam/cast(atom/cast_on)
	. = ..()
	var/mob/living/caster = owner
	caster.face_atom(cast_on)
	caster.move_resist = MOVE_FORCE_VERY_STRONG
	caster.add_overlay(direction_overlay)
	caster.visible_message(span_notice("The air chills as [caster] takes in energy..."))
	var/fully_charged = do_after(caster, delay = charge_duration, target = caster)
	caster.cut_overlay(direction_overlay)
	if(!fully_charged)
		return FALSE

	if(!fire_laser())
		var/static/list/fail_emotes = list("tremors.", "creaks.", "emits green steam as it fails to fire.")
		caster.manual_emote(pick(fail_emotes))
		return FALSE

	do_after(caster, delay = beam_duration, target = caster)
	extinguish_laser()
	return TRUE

/datum/action/cooldown/spell/obelisk_beam/proc/fire_laser()
	owner.visible_message(span_danger("[owner] fires a aberrant beam!"))
	playsound(owner, 'sound/magic/obeliskbeam.ogg', 150, FALSE, 0, 3)
	var/turf/target_turf = get_ranged_target_turf(owner, owner.dir, beam_range)
	var/turf/origin_turf = get_turf(owner)
	var/list/affected_turfs = get_line(origin_turf, target_turf) - origin_turf
	for(var/turf/affected_turf in affected_turfs)
		if(affected_turf.opacity)
			break
		var/blocked = FALSE
		for(var/obj/potential_block in affected_turf.contents)
			if(potential_block.opacity)
				blocked = TRUE
				break
		if(blocked)
			break
		var/obj/effect/obeliskbeam/new_obeliskbeam = new(affected_turf)
		new_obeliskbeam.dir = owner.dir
		beam_parts += new_obeliskbeam
		new_obeliskbeam.assign_creator(owner)
		for(var/mob/living/hit_mob in affected_turf.contents)
			hit_mob.apply_damage(damage = 25, damagetype = BURN)
			to_chat(hit_mob, span_userdanger("You're blasted by [owner]'s aberrant beam!"))
	if(!length(beam_parts))
		return FALSE
	var/atom/last_obeliskbeam = beam_parts[length(beam_parts)]
	last_obeliskbeam.icon_state = "obeliskbeam_end"
	var/atom/first_obeliskbeam = beam_parts[1]
	first_obeliskbeam.icon_state = "obeliskbeam_start"
	return TRUE

/datum/action/cooldown/spell/obelisk_beam/proc/extinguish_laser()
	if(!length(beam_parts))
		return FALSE
	if(owner)
		owner.move_resist = initial(owner.move_resist)
	for(var/obj/effect/obeliskbeam/beam in beam_parts)
		beam.disperse()
	beam_parts = list()
