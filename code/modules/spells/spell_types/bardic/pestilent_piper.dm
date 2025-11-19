/obj/effect/proc_holder/spell/invoked/song/pestilent_piedpiper
	name = "Pestilent Pied Piper"
	desc = "Play a dirge inspired by Pestra. Leaving the droning of insects in their ears! (-1 WIL -2 CON non-audience members)"
	overlay_state = "dirge_t2_base"
	action_icon_state = "dirge_t2_base"
	song_tier = 2
	warnie = "spellwarning"
	invocations = list("A festering performance!") 
	invocation_type = "shout"
	sound = list('sound/magic/debuffroll.ogg')
	song_effect = /datum/status_effect/buff/playing_dirge/pestilent_piedpiper

/datum/status_effect/buff/playing_dirge/pestilent_piedpiper
	effect = /obj/effect/temp_visual/songs/inspiration_dirget2
	debuff_to_apply = /datum/status_effect/debuff/song/pestilentpiper


/atom/movable/screen/alert/status_effect/debuff/song/pestilentpiper
	name = "Musical Droning!"
	desc = "I am weakened by the song!"
	icon_state = "debuff"

/datum/status_effect/debuff/song/pestilentpiper
	id = "pestilentpiper"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/song/pestilentpiper
	duration = 15 SECONDS
	effectedstats = list(STATKEY_WIL = -1, STATKEY_CON = -2)
