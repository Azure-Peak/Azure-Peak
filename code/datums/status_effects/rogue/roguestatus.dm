/datum/status_effect/mood
	id = "mood"

/datum/status_effect/mood/bad
	id = "mood"
	effectedstats = list(STATKEY_LCK = -1)
	alert_type = /atom/movable/screen/alert/status_effect/moodbad
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/moodbad
	name = "Stressed"
	desc = ""
	icon_state = "stressb"

/datum/status_effect/mood/vbad
	id = "mood"
	effectedstats = list(STATKEY_LCK = -2)
	alert_type = /atom/movable/screen/alert/status_effect/moodvbad
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/moodvbad
	name = "Max Stress"
	desc = ""
	icon_state = "stressvb"

/datum/status_effect/mood/good
	id = "mood"
	effectedstats = list(STATKEY_LCK = 1)
	alert_type = /atom/movable/screen/alert/status_effect/moodgood
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/moodgood
	name = "Inner Peace"
	desc = ""
	icon_state = "stressg"

/datum/status_effect/mood/vgood
	id = "mood"
	effectedstats = list(STATKEY_LCK = 2)
	alert_type = /atom/movable/screen/alert/status_effect/moodvgood
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/moodvgood
	name = "Max Peace"
	desc = ""
	icon_state = "stressvg"

/datum/status_effect/swingdelay
	id = "swingdelay"
	alert_type = /atom/movable/screen/alert/status_effect/swingdelay
	duration = 1 SECONDS
	mob_effect_icon_state = "eff_swingdelay"
	mob_effect_icon = 'icons/mob/mob_effects.dmi'
	mob_effect_layer = MOB_EFFECT_LAYER_SWINGDELAY

/datum/status_effect/swingdelay/on_creation(mob/living/new_owner, newdur)
	if(newdur)
		duration = newdur
	. = ..()
	
/datum/status_effect/swingdelay/on_apply()
	. = ..()
	owner.swing_state = TRUE

/atom/movable/screen/alert/status_effect/swingdelay
	name = "Swinging!"
	desc = "I am swinging my weapon! Why did I have the time to read this?!"
	icon = 'icons/mob/combat_debuffs.dmi'
	icon_state = "swingdelay"

/datum/status_effect/swingdelay/penalty
	alert_type = /atom/movable/screen/alert/status_effect/swingdelay/penalty
	mob_effect_icon_state = "eff_swingdelay_penalty"

/atom/movable/screen/alert/status_effect/swingdelay/penalty
	name = "Swinging with a penalty!"
	desc = "I am swinging my weapon! My guard is weaker! Pay attention to the screen, not here, you loon!"
	icon_state = "swingdelay_penalty"

/datum/status_effect/swingdelay/disrupt
	id = "swingdelay_disrupt"
	alert_type = /atom/movable/screen/alert/status_effect/swingdelay/disrupt
	mob_effect_icon_state = "eff_swingdelay_cancel"
	var/is_disrupted = FALSE

/datum/status_effect/swingdelay/disrupt/on_creation(mob/living/new_owner, newdur, apply_slow = FALSE)
	if(apply_slow)
		var/spd_mod = 10 - new_owner.get_true_stat(STATKEY_SPD)
		effectedstats = list(STATKEY_SPD = spd_mod)
	. = ..()

/datum/status_effect/swingdelay/disrupt/proc/attacked()
	owner.swing_state = FALSE
	is_disrupted = TRUE
	playsound(owner, 'sound/combat/swingdelay_disrupted.ogg', 100, TRUE)
	if(mob_effect)
		mob_effect.icon_state = "eff_swingdelay_disrupted"

/datum/status_effect/swingdelay/disrupt/proc/is_disrupted()
	return is_disrupted

/atom/movable/screen/alert/status_effect/swingdelay/disrupt
	name = "Swinging fiercely!"
	desc = "THEY WILL JAB ME AND INTERRUPT THE ATTACK YOU GOBLINBRAINED WRETCH! LOOK AT THE ENEMY!!!"
	icon_state = "swingdelay_disrupt"
