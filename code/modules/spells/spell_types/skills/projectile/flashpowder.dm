/datum/action/cooldown/spell/projectile/flashpowder
	name = "Flashpowder"
	desc = "Throw a handful of explosive powder, stunning and blinding your opponent"
	button_icon = 'icons/mob/actions/antiquarianspells.dmi'
	button_icon_state = "flashpowder"
	projectile_type = /obj/projectile/magic/flashpowder
	cast_range = 7
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE
	charge_required = FALSE
	cooldown_time = 12 SECONDS
	associated_skill = /datum/skill/misc/reading
	invocations = list("flicks their wrist, tossing a handful of crackling powder.")
	invocation_type = "emote"

/obj/projectile/magic/flashpowder
	name = "flashpowder"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "spark"
	damage = 25 //ever get hit with a cherry bomb? shit hurts a bit. this is a little less than spitfire, with no ignite
	npc_simple_damage_mult = 2 //multiple people said the spell wasn't as useful in pve
	damage_type = BURN
	woundclass = BCLASS_BURN
	nodamage = FALSE
	flag = "fire"
	speed = MAGE_PROJ_MEDIUM
	range = 7
	hitsound = list('sound/misc/explode/incendiary (1).ogg','sound/misc/explode/incendiary (2).ogg')
	accuracy = 40
	guard_deflectable = FALSE //is powder

/obj/projectile/magic/flashpowder/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		M.apply_status_effect(/datum/status_effect/debuff/flashpowder)
		M.apply_status_effect(/datum/status_effect/debuff/clickcd, 3 SECONDS)
		if(iscarbon(target))
			M.blur_eyes(5) //affects both blur duration and intensity, minor blur for about 15 seconds
			M.adjust_blurriness(5) //affects both blur duration and intensity, no idea why they both do the same thing
	visible_message(
		span_warning("[target] is blasted with a sparking cloud!"),
		span_warning("The flashpowder blinded me! I can't see!")
		)

/atom/movable/screen/alert/status_effect/debuff/flashpowder
	name = "Flashed"
	desc = "It burns!"
	icon_state = "blind"

/datum/status_effect/debuff/flashpowder
	id = "flashpowder"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/flashpowder
	effectedstats = list(STATKEY_PER = -2, STATKEY_LCK = -2)
	duration = 10 SECONDS
