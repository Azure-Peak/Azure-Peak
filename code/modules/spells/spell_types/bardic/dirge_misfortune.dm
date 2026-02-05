
/obj/effect/proc_holder/spell/invoked/song/dirge_fortune
	name = "Misfortunate Melody"
	desc = "Play a dirge which inflicts misery upon thy foes. -2 LUCK to non-audience members nearby. "
	song_tier = 1
	invocations = list("plays the world's saddest song. The world around them seems to sulk.") 
	invocation_type = "emote"
	overlay_state = "dirge_t1_base"
	action_icon_state = "dirge_t1_base"
	sound = list('sound/magic/debuffroll.ogg')
	song_effect = /datum/status_effect/buff/playing_dirge/misfortune

/datum/status_effect/buff/playing_dirge/misfortune
	effect = /obj/effect/temp_visual/songs/inspiration_dirget1
	debuff_to_apply = /datum/status_effect/debuff/song/dirge_misfortune

/datum/status_effect/debuff/song/dirge_misfortune
	id = "dirge_misfortune"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/song/dirge_misfortune
	effectedstats = list(STATKEY_LCK = -2)
	duration = 15 SECONDS

/atom/movable/screen/alert/status_effect/debuff/song/dirge_misfortune
	name = "Dirge of Misfortune"
	desc = "I can feel the sky laughing at my back. This music is reminding me of my fleeting, insignificant life."
	icon_state = "restrained"
