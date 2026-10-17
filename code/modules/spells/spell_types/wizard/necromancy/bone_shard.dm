/datum/action/cooldown/spell/projectile/bone_shard
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	name = "Bone Shard"
	desc = "Fire a shard of bone at a single target. \
	Toggle arc mode (Shift+G) while the spell is active to lob it over obstacles at reduced damage."
	button_icon_state = "profane"
	sound = 'sound/spellbooks/icicle.ogg'
	spell_color = GLOW_COLOR_ZIZO
	glow_intensity = GLOW_INTENSITY_MEDIUM

	projectile_type = /obj/projectile/magic/profane/bone_shard
	projectile_type_arc = /obj/projectile/magic/profane/bone_shard/arc
	cast_range = SPELL_RANGE_PROJECTILE
	point_cost = 3

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Fragmentum Ossis!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	charge_swingdelay_type = SWINGDELAY_NORMAL
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 5.5 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

/obj/projectile/magic/profane/bone_shard
	name = "bone shard"
	damage = SPELL_DMG(54)
	armor_penetration = PEN_NONE
	flag = "piercing"
	woundclass = BCLASS_STAB
	intdamfactor = SPELL_INTDAM(1)
	spell_damage_scaled = TRUE
	speed = MAGE_PROJ_FAST
	embed_chance = 0
	hitsound = 'sound/combat/fracture/fracturedry (1).ogg'

/obj/projectile/magic/profane/bone_shard/arc
	name = "arced bone shard"
	damage = SPELL_DMG(41)
	arcshot = TRUE
