/datum/action/cooldown/spell/vheslyn
	background_icon = 'icons/mob/actions/vheslynspells.dmi'
	button_icon = 'icons/mob/actions/vheslynspells.dmi'
	spell_color = GLOW_COLOR_GRAGGAR

	ignore_armor_penalty = TRUE
	attunement_school = null

	primary_resource_type = SPELL_COST_STAMINA

	has_visual_effects = FALSE
	spell_impact_intensity = SPELL_IMPACT_NONE
	associated_stat = null
	associated_skill = /datum/skill/magic/arcane

// Phase Roll - brief phasing roll inspired by the dagger special, albeit with some tweaks to make it super obvious.
/obj/effect/proc_holder/spell/self/vheslyn/vheslyn_phase_roll
	name = "Phase Roll"
	desc = "Invoke corrupted magicka with dodging techniques to enhance yourself to effortlessly phase through flesh and steel alyke."
//Until I can get it working	//fluff_desc = "When the SYON, was sent down by Psydon to topple Vheslyn, the world was met with a blinding light and then silence... Just like that, a great evil slain. However the surviving cultists, fragments of the Earth Mover's lingering corruption were not detered, for yills, centuries they waited until Her ascension shattered the world and with one of the Leylines permanently severed, she unknowingly brought forth long forgotten and corrupted arts of Magicka, once filtered out yet now freely drawn to create but a pale imitation of their long lost divine spark once granted by Vheslyn, one without restraint of the conventional laws of magic. Although lethal to most in the long-term, the cultists of the Earth Mover are oft unphased by this drawback."
	action_icon = 'icons/mob/actions/vheslynspells.dmi'
	overlay_icon = 'icons/mob/actions/vheslynspells.dmi'
	overlay_state = "phaseroll"
	recharge_time = 30 SECONDS
	clothes_req = FALSE
	invocations = list("UN'MAKAR'SAR'IN!", "LE'SELIA WRL'LD!", "I'RISIA TAK'ATI' HELL!") //Unmake my flesh, let me slip the world, I'll take you to hell - gibberish-ified
	invocation_type = "shout"
	sound = 'sound/magic/diminish1.ogg'
	releasedrain = 10 //Light cost but its falloff opens you to a free hit through parries.
	range = 0

/obj/effect/proc_holder/spell/self/vheslyn/vheslyn_phase_roll/cast(list/targets, mob/user)
	. = ..()
	if(!isliving(user))
		revert_cast()
		return FALSE

	var/mob/living/living_user = user
	living_user.apply_status_effect(/datum/status_effect/buff/vheslyn_phase_roll)
	return TRUE

//Vheslyn phase roll effects are below here.
#define VHESLYN_PHASE_FILTER "vheslyn_phase_roll"

/atom/movable/screen/alert/status_effect/buff/vheslyn_phase_roll
	name = "Phase Roll"
	desc = span_cult("Nothing can hold me for this moment.")
	icon_state = "daggerdash"

/datum/status_effect/buff/vheslyn_phase_roll
	id = "vheslyn_phase_roll"
	alert_type = /atom/movable/screen/alert/status_effect/buff/vheslyn_phase_roll
	status_type = STATUS_EFFECT_UNIQUE
	duration = 3 SECONDS
	mob_effect_icon_state = "eff_daggerboost"
	mob_effect_layer = MOB_EFFECT_LAYER_DBOOST
	examine_text = "SUBJECTPRONOUN phases through reality with unnatural grace!"
	var/outline_color = "#9aff9f"
	effectedstats = list(STATKEY_SPD = 4) //Fucked up, bare in mind I don't intend dodge experts to ever get this. DO not fucking give them this if you're not a sadistic coder.

/datum/status_effect/buff/vheslyn_phase_roll/on_apply()
	owner.visible_message(span_warning("[owner] phases through reality itself, with profane power."))
	shake_camera(owner, 5, 3)
	var/filter = owner.get_filter(VHESLYN_PHASE_FILTER)
	if(!filter)
		owner.add_filter(VHESLYN_PHASE_FILTER, 2, list("type" = "outline", "color" = outline_color, "alpha" = 160, "size" = 1))
	owner.pass_flags |= PASSMOB
	ADD_TRAIT(owner, TRAIT_GRABIMMUNE, TRAIT_STATUS_EFFECT)
	. = ..()

/datum/status_effect/buff/vheslyn_phase_roll/on_remove()
	owner.visible_message(span_warning("[owner] stumbles as they slip back into reality."))
	playsound(owner, 'sound/misc/portalactivate.ogg', 100, TRUE)
	owner.apply_status_effect(/datum/status_effect/debuff/exposed, 3 SECONDS) //Small window to hit them
	owner.remove_filter(VHESLYN_PHASE_FILTER)
	owner.pass_flags &= ~PASSMOB
	REMOVE_TRAIT(owner, TRAIT_GRABIMMUNE, TRAIT_STATUS_EFFECT)
	. = ..()

#undef VHESLYN_PHASE_FILTER

//	owner.adjust_fire_stacks(7, /datum/status_effect/fire_handler/fire_stacks/vheslyn)
