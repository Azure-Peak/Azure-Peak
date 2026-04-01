
/obj/effect/proc_holder/spell/invoked/song/resolute_refrain
	name = "Resolute Refrain"
	desc = "A steadying melody that bolsters your allies' constitution."
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	overlay_state = "melody_t1_base"
	action_icon_state = "melody_t1_base"
	song_effect = /datum/status_effect/buff/playing_melody/resolute_refrain

/datum/status_effect/buff/playing_melody/resolute_refrain
	effect = /obj/effect/temp_visual/songs/inspiration_melodyt1
	buff_to_apply = /datum/status_effect/buff/song/resolute_refrain
	buff_to_apply_full = /datum/status_effect/buff/song/resolute_refrain/full

/atom/movable/screen/alert/status_effect/buff/song/resolute_refrain
	name = "Resolute Refrain"
	desc = "This steady melody hardens my resolve. I feel tougher, more resilient."
	icon_state = "buff"

/datum/status_effect/buff/song/resolute_refrain
	id = "resoluterefrain"
	alert_type = /atom/movable/screen/alert/status_effect/buff/song/resolute_refrain
	duration = 15 SECONDS
	effectedstats = list(STATKEY_CON = BARD_STAT_LESSER)

/datum/status_effect/buff/song/resolute_refrain/full
	effectedstats = list(STATKEY_CON = BARD_STAT_FULL)
