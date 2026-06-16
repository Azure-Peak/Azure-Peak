#define STATUS_EFFECT_BURN /datum/status_effect/stacking/burn
/datum/status_effect/stacking/burn
	id = "burn"
	alert_type = /atom/movable/screen/alert/status_effect/burn
	max_stacks = 50
	tick_interval = 5 SECONDS
	consumed_on_threshold = FALSE
	var/new_stack = FALSE
	var/safety = TRUE

/atom/movable/screen/alert/status_effect/burn
	name = "Burning"
	desc = "There's embers eating away at your body. You'll take burn damage equal to the current stack, before the stack subtracts 1/3 of itself."
	icon = 'icons/mob/screen_alert.dmi'
	icon_state = "burn"


/datum/status_effect/stacking/burn/can_have_status()
	return (owner.stat != DEAD || !(owner.status_flags & GODMODE))

/datum/status_effect/stacking/burn/add_stacks(stacks_added)
	..()
	Update_Burn_Overlay(owner)
	new_stack = TRUE

/datum/status_effect/stacking/burn/tick()
	if(!can_have_status())
		qdel(src)
	to_chat(owner, "<span class='warning'>The flame consumes you!</span>")
	playsound(owner, 'sound/magic/firemonk/burn.ogg', 50, TRUE)
	DealDamage()

	//Deletes itself after 2 tick if no new burn stack was given
	if(safety)
		if(new_stack)
			stacks = round(stacks/2)
			new_stack = FALSE
			Update_Burn_Overlay(owner)
		else
			qdel(src)

	stacks = round(stacks/3)

/datum/status_effect/stacking/burn/proc/DealDamage()
	owner.apply_damage(stacks, damagetype = BURN, def_zone = null, blocked = 0, forced = TRUE)

//Update burn appearance
/datum/status_effect/stacking/burn/proc/Update_Burn_Overlay(mob/living/owner)
	if(stacks && !(owner.on_fire) && ishuman(owner))
		if(stacks >= 15)
			owner.cut_overlay(mutable_appearance('icons/mob/OnFire.dmi', "Generic_mob_burning", -FIRE_LAYER))
			owner.cut_overlay(mutable_appearance('icons/mob/OnFire.dmi', "Standing", -FIRE_LAYER))
			owner.add_overlay(mutable_appearance('icons/mob/OnFire.dmi', "Standing", -FIRE_LAYER))
		else
			owner.cut_overlay(mutable_appearance('icons/mob/OnFire.dmi', "Standing", -FIRE_LAYER))
			owner.cut_overlay(mutable_appearance('icons/mob/OnFire.dmi', "Generic_mob_burning", -FIRE_LAYER))
			owner.add_overlay(mutable_appearance('icons/mob/OnFire.dmi', "Generic_mob_burning", -FIRE_LAYER))

/datum/status_effect/stacking/burn/on_remove()
	if(!(owner.on_fire) && ishuman(owner))
		owner.cut_overlay(mutable_appearance('icons/mob/OnFire.dmi', "Generic_mob_burning", -FIRE_LAYER))
		owner.cut_overlay(mutable_appearance('icons/mob/OnFire.dmi', "Standing", -FIRE_LAYER))
	..()

//Mob Proc
/mob/living/proc/apply_burn(stacks)
	var/datum/status_effect/stacking/burn/B = src.has_status_effect(/datum/status_effect/stacking/burn)
	if(!B)
		src.apply_status_effect(/datum/status_effect/stacking/burn, stacks)
	else
		B.add_stacks(stacks)
