/obj/effect/proc_holder/spell/invoked/song/suffocating_seliloquy
	name = "Suffocating Seliloquy"
	desc = "Play a dirge inspired by Abyssor, slowly suffocating with its call."
	overlay_state = "dirge_t3_base"
	action_icon_state = "dirge_t3_base"
	song_tier = 3
	invocations = list("plays a soft, anxiety-inducing tune that seems to thicken the air around them.") 
	invocation_type = "emote"
	overlay_state = "dirge_t3_base"
	action_icon_state = "dirge_t3_base"
	sound = list('sound/magic/debuffroll.ogg')
	song_effect = /datum/status_effect/buff/playing_dirge/suffocating_seliloquy

/datum/status_effect/buff/playing_dirge/suffocating_seliloquy
	effect = /obj/effect/temp_visual/songs/inspiration_dirget3
	debuff_to_apply = /datum/status_effect/debuff/song/suffocationsong


/atom/movable/screen/alert/status_effect/debuff/song/suffocationsong
	name = "Musical Suffocation!"
	desc = "They are killing me softly with this song!"
	icon_state = "debuff"

/datum/status_effect/debuff/song/suffocationsong
	id = "suffocationsong"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/song/suffocationsong
	duration = 15 SECONDS

/datum/status_effect/debuff/song/suffocationsong/tick()
	owner.adjustOxyLoss(1.5)
