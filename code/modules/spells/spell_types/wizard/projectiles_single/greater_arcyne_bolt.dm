/datum/action/cooldown/spell/projectile/greater_arcyne_bolt
	button_icon = 'icons/mob/actions/mage_shared.dmi'
	name = "Greater Arcyne Bolt"
	desc = "Fire a concentrated bolt of arcyne energy at a single target. \
	Deals 50% increased damage to simple-minded creechurs. \
	Toggle arc mode (Ctrl+G) while the spell is active to lob it over obstacles at reduced damage."
	fluff_desc = "Ancient attack magyck. Oft nicknamed the \"Magician's Sling\" since its inception. Likely from the same era as soulshot or even earlier. While most magos have abandoned the Arcyne Bolt in favor of the powerful, deadly Soulshot that \"cannot miss\", the Arcyne Bolt is still favored by some Magos for its ability to be arced over ally's head and lack of ability to pierce through the body of enemies. This variation of Arcyne Bolt has been refined from its original, weaker version into a reliable, powerful spell. Whether it is as good at felling demons as it used to be is still up for debate."
	button_icon_state = "greater_arcyne_bolt"
	sound = 'sound/magic/vlightning.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM

	projectile_type = /obj/projectile/magic/greater_arcyne_bolt
	projectile_type_arc = /obj/projectile/magic/greater_arcyne_bolt/arc
	cast_range = SPELL_RANGE_PROJECTILE
	point_cost = 3

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Magicae Sagitta!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 5.5 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	is_implement_scaled_spell = TRUE
	attunement_school = ASPECT_NAME_KINESIS

/obj/projectile/magic/greater_arcyne_bolt
	name = "greater arcyne bolt"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "arcyne_bolt"
	guard_deflectable = TRUE
	damage = 40
	damage_type = BRUTE
	flag = "blunt"
	woundclass = BCLASS_BLUNT
	intdamfactor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	npc_simple_damage_mult = 1.5
	nodamage = FALSE
	speed = MAGE_PROJ_FAST
	range = SPELL_RANGE_PROJECTILE
	hitsound = 'sound/combat/hits/blunt/shovel_hit2.ogg'

/obj/projectile/magic/greater_arcyne_bolt/arc
	name = "arced greater arcyne bolt"
	damage = 50
	arcshot = TRUE

/obj/projectile/magic/greater_arcyne_bolt/on_hit(target)
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		playsound(get_turf(target), hitsound, 80, TRUE)
	return ..()
