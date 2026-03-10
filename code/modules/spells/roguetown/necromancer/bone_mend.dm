// Copy paste of Bone Chill but healing only with a doafter
/obj/effect/proc_holder/spell/invoked/bonemend
	name = "Bone Mend"
	desc = "Mend the chosen target's bones with a burst of necrotic magick. Requires standing still for a few seconds"
	cost = 3
	overlay_state = "profane"
	releasedrain = 50
	chargetime = 5 SECONDS // Make in combat usage harder
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	chargedloop = null
	sound = 'sound/magic/whiteflame.ogg'
	spell_tier = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	gesture_required = TRUE
	antimagic_allowed = TRUE
	recharge_time = 30 SECONDS
	miracle = FALSE
	zizo_spell = TRUE

/obj/effect/proc_holder/spell/invoked/bonemend/cast(list/targets, mob/living/user)
	..()
	if(!isliving(targets[1]))
		return FALSE

	var/mob/living/target = targets[1]
	if(target.mob_biotypes & MOB_UNDEAD) //positive energy harms the undead
		var/obj/item/bodypart/affecting = target.get_bodypart(check_zone(user.zone_selected))
		if(affecting && (affecting.heal_damage(50, 50) || affecting.heal_wounds(50)))
			target.update_damage_overlays()
		target.visible_message(span_danger("[target] reforms under the vile energy!"), span_notice("I'm remade by dark magic!"))
		return TRUE
	return TRUE
