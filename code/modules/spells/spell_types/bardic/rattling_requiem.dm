/datum/action/cooldown/spell/song/rattling_requiem
	name = "Rattling Requiem"
	desc = "Play a dirge that rattles your enemies' confidence, making their strikes and defenses imprecise."
	button_icon_state = "dirge_t3_base"
	sound = 'sound/magic/debuffroll.ogg'
	invocations = list("plays an unsettling, discordant requiem. Those nearby feel their confidence shaken.")
	song_effect = /datum/status_effect/buff/playing_dirge/rattling_requiem

/datum/status_effect/buff/playing_dirge/rattling_requiem
	effect = /obj/effect/temp_visual/songs/inspiration_dirget3
	debuff_to_apply = /datum/status_effect/debuff/song/rattling_requiem
	debuff_to_apply_full = /datum/status_effect/debuff/song/rattling_requiem/full

/atom/movable/screen/alert/status_effect/debuff/song/rattling_requiem
	name = "Rattling Requiem"
	desc = "This dreadful music shakes my confidence. My hands feel unsteady."
	icon_state = "debuff"

/datum/status_effect/debuff/song/rattling_requiem
	id = "rattling_requiem"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/song/rattling_requiem
	duration = 15 SECONDS
	var/guidance_trait = TRAIT_LESSER_REVERSE_GUIDANCE

/datum/status_effect/debuff/song/rattling_requiem/full
	guidance_trait = TRAIT_REVERSE_GUIDANCE

/datum/status_effect/debuff/song/rattling_requiem/on_apply()
	. = ..() // Base handles the outline filter
	ADD_TRAIT(owner, guidance_trait, MAGIC_TRAIT)

/datum/status_effect/debuff/song/rattling_requiem/on_remove()
	. = ..() // Base handles filter cleanup
	REMOVE_TRAIT(owner, guidance_trait, MAGIC_TRAIT)
