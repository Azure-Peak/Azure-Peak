/mob/living/simple_animal/hostile/rogue/werewolf/regenerate_icons()
	if(gender == MALE)
		icon_state = "wwolf_m"
	else
		icon_state = "wwolf_f"
	update_inv_hands()
	update_damage_overlays()

/mob/living/simple_animal/hostile/rogue/werewolf/update_damage_overlays()
	remove_overlay(DAMAGE_LAYER)

	var/list/hands = list()
	var/mutable_appearance/inhand_overlay = mutable_appearance("[icon_state]-dam", layer=-DAMAGE_LAYER)
	var/numba = 255 * (health / maxHealth)
	inhand_overlay.alpha = 255 - numba

	hands += inhand_overlay

	overlays_standing[DAMAGE_LAYER] = hands
	apply_overlay(DAMAGE_LAYER)
