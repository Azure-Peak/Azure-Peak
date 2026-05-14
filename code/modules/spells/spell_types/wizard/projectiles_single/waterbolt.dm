/datum/action/cooldown/spell/projectile/waterbolt
	name = "Water Bolt"
	desc = "Shoot out a magical bolt of water that extinguishes fires from a distance."
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "frost_bolt"
	sound = 'sound/foley/water_land1.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = 15

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Vel Aquarus")
	invocation_type = INVOCATION_WHISPER

	charge_required = FALSE
	cooldown_time = 8 SECONDS

	projectile_type = /obj/projectile/energy/waterbolt

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_LOW
	point_cost = 1

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

// Harmless water bolt
/obj/projectile/energy/waterbolt
	name = "water bolt"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "arcyne_bolt"
	guard_deflectable = TRUE
	damage = 0
	nodamage = TRUE
	alpha = 127
	color = "#5599FF"
	speed = MAGE_PROJ_FAST
	hitsound = null
	var/zone_aimed = null

/obj/projectile/energy/waterbolt/on_hit(target)
	// Extinguish lit light sources (braziers, hearths, fireplaces, wall candles, etc.)
	if(istype(target, /obj/machinery/light/rogue))
		var/obj/machinery/light/rogue/L = target
		if(L.on)
			L.extinguish()
		return BULLET_ACT_HIT
	// Extinguish burning items and structures; any obj that reaches this point is not a carbon, so always return
	if(isobj(target))
		var/obj/O = target
		if((O.resistance_flags & ON_FIRE) && O.extinguishable)
			O.extinguish()
		return BULLET_ACT_HIT
	if(!iscarbon(target))
		return BULLET_ACT_HIT
	var/mob/living/carbon/C = target
	// Douse fire stacks — 10 per hit, so max stacks (20) requires two bolts
	if(C.fire_stacks > 0)
		C.adjust_fire_stacks(-10)
		if(C.fire_stacks <= 0)
			C.extinguish_mob() // also extinguishes any burning clothing/items
	// Head-aim and mood debuff logic is human-only
	if(!ishuman(C))
		return BULLET_ACT_HIT
	var/mob/living/carbon/human/H = C
	// Head-aim check for mood debuff
	if(!(zone_aimed in list(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_SKULL, BODY_ZONE_PRECISE_EARS, BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH)))
		return BULLET_ACT_HIT
	var/is_noble = H.is_noble()
	if(is_noble)
		H.add_stress(/datum/stressevent/water_splashed_noble)
	return BULLET_ACT_HIT
