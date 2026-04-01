
/obj/effect/proc_holder/spell/invoked/song/discordant_dirge
	name = "Discordant Dirge"
	desc = "Play a dissonant dirge that slows your enemies. Reduces SPD of non-audience members nearby."
	invocations = list("plays a grinding, dissonant melody. The air grows heavy and sluggish.")
	invocation_type = "emote"
	overlay_state = "dirge_t1_base"
	action_icon_state = "dirge_t1_base"
	sound = list('sound/magic/debuffroll.ogg')
	song_effect = /datum/status_effect/buff/playing_dirge/discordant_dirge

/datum/status_effect/buff/playing_dirge/discordant_dirge
	effect = /obj/effect/temp_visual/songs/inspiration_dirget1
	debuff_to_apply = /datum/status_effect/debuff/song/discordant_dirge
	debuff_to_apply_full = /datum/status_effect/debuff/song/discordant_dirge/full

/datum/status_effect/debuff/song/discordant_dirge
	id = "discordant_dirge"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/song/discordant_dirge
	effectedstats = list(STATKEY_SPD = -BARD_STAT_LESSER)
	duration = 15 SECONDS

/datum/status_effect/debuff/song/discordant_dirge/full
	effectedstats = list(STATKEY_SPD = -BARD_STAT_FULL)

/atom/movable/screen/alert/status_effect/debuff/song/discordant_dirge
	name = "Discordant Dirge"
	desc = "A terrible melody weighs on my limbs. Everything feels slower."
	icon_state = "debuff"
