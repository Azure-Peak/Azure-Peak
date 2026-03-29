#define CATACLYSM_RADIUS 4 // 9x9 area
#define CATACLYSM_TELEGRAPH_TIME (3 SECONDS)
#define CATACLYSM_GORE_FRAGS 6

/datum/action/cooldown/spell/cat_aclysm
	button_icon = 'icons/mob/actions/mage_kittenomancy.dmi'
	name = "CATaclysm"
	desc = "Rain a devastating barrage of spectral cats from the sky onto a massive area. \
	Each impact explodes into gore, dealing heavy damage and painting the battlefield in blood. \
	9x9 area. Can and WILL hurt the caster."
	button_icon_state = "cataclysm"
	sound = 'sound/vo/mobs/cat/roar4.ogg'
	spell_color = GLOW_COLOR_HEX
	glow_intensity = GLOW_INTENSITY_VERY_HIGH
	attunement_school = ASPECT_NAME_KITTENOMANCY

	click_to_activate = TRUE
	cast_range = 14 // EXCEPTIONAL range for EXCEPTIONAL crimes

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_ULTIMATE

	invocations = list("Caelum Felis Ruimeow!!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_HEAVY
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/vo/mobs/cat/roar2.ogg'
	cooldown_time = 60 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_HIGH

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/direct_damage = 80
	var/splash_damage = 30
	var/fragment_damage = 20
	var/npc_simple_damage_mult = 2
	var/impact_count = 20

/datum/action/cooldown/spell/cat_aclysm/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/centerpoint = get_turf(cast_on)
	if(!centerpoint)
		return FALSE

	var/turf/source_turf = get_turf(H)
	if(centerpoint.z > H.z)
		source_turf = get_step_multiz(source_turf, UP)
	if(centerpoint.z < H.z)
		source_turf = get_step_multiz(source_turf, DOWN)
	if(!(centerpoint in get_hear(cast_range, source_turf)))
		to_chat(H, span_warning("I can't cast where I can't see!"))
		return FALSE

	var/list/valid_turfs = list()
	for(var/turf/T in range(CATACLYSM_RADIUS, centerpoint))
		if(T.density)
			continue
		valid_turfs += T

	if(!length(valid_turfs))
		return FALSE

	var/list/impact_turfs = list()
	for(var/i in 1 to impact_count)
		impact_turfs += pick(valid_turfs)

	centerpoint.visible_message(span_boldwarning("The sky darkens... and you hear meowing. A LOT of meowing."))

	for(var/turf/T in valid_turfs)
		new /obj/effect/temp_visual/trap/cataclysm(T)

	var/delay_offset = CATACLYSM_TELEGRAPH_TIME
	for(var/turf/impact_turf in impact_turfs)
		addtimer(CALLBACK(src, PROC_REF(drop_cat), impact_turf), delay_offset)
		delay_offset += rand(3, 5)

	return TRUE

/datum/action/cooldown/spell/cat_aclysm/proc/drop_cat(turf/T)
	if(QDELETED(src) || QDELETED(owner))
		return
	new /obj/effect/temp_visual/falling_cat(T, CALLBACK(src, PROC_REF(cat_impact), T))

/datum/action/cooldown/spell/cat_aclysm/proc/cat_impact(turf/T)
	if(QDELETED(src) || QDELETED(owner))
		return
	playsound(T, pick('sound/vo/mobs/cat/cat_meow1.ogg', 'sound/vo/mobs/cat/cat_meow2.ogg', 'sound/vo/mobs/cat/cat_meow3.ogg', 'sound/vo/mobs/cat/cat_meow4.ogg'), 80, TRUE, 6)
	playsound(T, 'sound/combat/gib (1).ogg', 100, TRUE, 4)
	new /obj/effect/gibspawner/generic(T)
	for(var/obj/structure/S in T.contents)
		S.take_damage(direct_damage, BRUTE, "blunt", object_damage_multiplier = 2)
	T.take_damage(direct_damage, BRUTE, "blunt", object_damage_multiplier = 2)
	var/mob/living/carbon/human/caster = owner
	var/static/list/random_zones = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
	for(var/mob/living/L in T.contents)
		if(L.anti_magic_check())
			L.visible_message(span_warning("The falling cat fades away around [L]!"))
			playsound(get_turf(L), 'sound/magic/magic_nulled.ogg', 100)
			continue
		if(spell_guard_check(L, TRUE))
			L.visible_message(span_warning("[L] endures the cat strike!"))
			continue
		var/actual_damage = direct_damage
		if(!L.mind && !ishuman(L))
			actual_damage *= npc_simple_damage_mult
		if(istype(caster) && ishuman(L))
			arcyne_strike(caster, L, null, actual_damage, pick(random_zones), \
				BCLASS_BLUNT, spell_name = "CATaclysm", \
				damage_type = BRUTE, npc_simple_damage_mult = 1, \
				skip_animation = TRUE)
		else
			L.adjustBruteLoss(actual_damage)
		L.Knockdown(3)
		L.add_mob_blood(L)
		new /obj/effect/temp_visual/spell_impact(get_turf(L), spell_color, spell_impact_intensity)
	for(var/turf/aoe_turf in range(1, T))
		if(aoe_turf == T)
			continue
		for(var/mob/living/L in aoe_turf.contents)
			if(L.anti_magic_check())
				continue
			if(spell_guard_check(L, TRUE))
				continue
			var/actual_damage = splash_damage
			if(!L.mind && !ishuman(L))
				actual_damage *= npc_simple_damage_mult
			if(istype(caster) && ishuman(L))
				arcyne_strike(caster, L, null, actual_damage, pick(random_zones), \
					BCLASS_BLUNT, spell_name = "CATaclysm", \
					damage_type = BRUTE, npc_simple_damage_mult = 1, \
					skip_animation = TRUE)
			else
				L.adjustBruteLoss(actual_damage)
			L.add_mob_blood(L)
	// Gore fragments
	var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
	for(var/i in 1 to CATACLYSM_GORE_FRAGS)
		var/dir = pick_n_take(dirs)
		var/turf/target = get_ranged_target_turf(T, dir, 3)
		var/obj/projectile/magic/gore_fragment/frag = new(T)
		frag.damage = fragment_damage
		frag.firer = owner
		frag.preparePixelProjectile(target, T)
		frag.fire()

// Falling cat visual
/obj/effect/temp_visual/falling_cat
	icon = 'icons/mob/pets.dmi'
	icon_state = "cat2"
	name = "falling cat"
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER
	randomdir = FALSE
	duration = 9
	pixel_z = 270
	var/datum/callback/on_impact

/obj/effect/temp_visual/falling_cat/Initialize(mapload, datum/callback/impact_cb)
	. = ..()
	on_impact = impact_cb
	icon_state = pick("cat", "cat2", "kitten")
	animate(src, pixel_z = 0, time = duration)
	addtimer(CALLBACK(src, PROC_REF(do_impact)), duration)

/obj/effect/temp_visual/falling_cat/proc/do_impact()
	on_impact?.Invoke()

/obj/effect/temp_visual/trap/cataclysm
	color = GLOW_COLOR_HEX
	light_color = GLOW_COLOR_HEX
	duration = CATACLYSM_TELEGRAPH_TIME

#undef CATACLYSM_RADIUS
#undef CATACLYSM_TELEGRAPH_TIME
#undef CATACLYSM_GORE_FRAGS
