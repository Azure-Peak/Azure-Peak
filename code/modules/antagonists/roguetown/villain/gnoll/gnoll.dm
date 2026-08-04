// Scaling: No storyteller slot caps or solo event. Gnoll slots come from:
//  - The Gnoll job's gnollslot_update() (storyteller-driven job slot scaling)
//  - Migrant waves (+2 slots, capped by storyteller maxcap)
/datum/antagonist/gnoll
	name = "Gnoll"
	roundend_category = "Gnolls"
	antagpanel_category = "Gnolls"
	job_rank = ROLE_GNOLL
	storyteller_antag_flags = STORYTELLER_ANTAG_SOFT

/datum/antagonist/gnoll/on_gain()
	greet()
	owner.special_role = "Gnoll"
	if(ishuman(owner.current))
		ADD_TRAIT(owner.current, TRAIT_OUTLAW, TRAIT_GENERIC)

	return ..()

/datum/antagonist/gnoll/on_removal()
	. = ..()
	if(owner)
		owner.special_role = null

/datum/antagonist/gnoll/greet()
	return ..()

/mob/living/carbon/human/proc/gnoll_feed(mob/living/carbon/human/target, healing_amount = 10)
	if(!istype(target))
		return
	if(has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder) || has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed))
		to_chat(src, span_notice("My power is weakened, I cannot heal!"))
		return
	if(target.mind)
		if(target.mind.has_antag_datum(/datum/antagonist/zombie))
			to_chat(src, span_warning("I should not feed on rotten flesh."))
			return
		if(target.mind.has_antag_datum(/datum/antagonist/vampire))
			to_chat(src, span_warning("I should not feed on corrupted flesh."))
			return
		if(target.mind.has_antag_datum(/datum/antagonist/gnoll))
			to_chat(src, span_warning("I should not feed on my kin's flesh."))
			return

	to_chat(src, span_warning("I feed on succulent flesh. I feel reinvigorated."))
	return src.reagents.add_reagent(/datum/reagent/medicine/healthpot, healing_amount)

/datum/intent/simple/werewolf/gnoll

/obj/item/rogueweapon/werewolf_claw/gnoll
	name = "Gnoll Claw"
	// We are smarter, we can use our solid, steel-like claws to defend ourselves.
	wdefense = 6
	force = 27
	possible_item_intents = list(/datum/intent/simple/gnoll_cut, /datum/intent/simple/werewolf/gnoll, /datum/intent/mace/smash/werewolf/gnoll, /datum/intent/mace/strike/gnoll)
	special = /datum/special_intent/shin_swipe

/obj/item/rogueweapon/werewolf_claw/gnoll/right
	icon_state = "claw_r"
	wlength = WLENGTH_SHORT

/obj/item/rogueweapon/werewolf_claw/gnoll/left
	icon_state = "claw_l"
	wlength = WLENGTH_SHORT

/datum/intent/simple/werewolf/gnoll
	name = "claw"
	icon_state = "inchop"
	blade_class = BCLASS_CHOP
	attack_verb = list("claws", "mauls", "eviscerates")
	animname = "chop"
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	hitsound = "genslash"
	penfactor = PEN_MEDIUM
	candodge = TRUE
	canparry = TRUE
	miss_text = "slashes the air!"
	miss_sound = "bluntwooshlarge"
	item_d_type = "slash"
	damfactor = 1.4
	swingdelay = 0.8 SECONDS
	swingdelay_type = SWINGDELAY_PENALTY
	clickcd = CLICK_CD_CHARGED

/datum/intent/mace/smash/werewolf/gnoll
	name = "thrash"
	desc = "A powerful, smash of lycan muscle that deals normal damage but can throw a standing opponent back and slow them down, based on your strength. Ineffective below 10 strength. Slowdown & Knockback scales to your Strength up to 15 (1 - 5 tiles). Cannot be used consecutively more than every 5 seconds on the same target. Prone targets halve the knockback distance."
	icon_state = "insmash"
	maxrange = 5
	chargetime = 1
	penfactor = PEN_NONE

/datum/intent/simple/gnoll_cut
	name = "cutting claw"
	hitsound = "genslash"
	penfactor = PEN_LIGHT
	candodge = TRUE
	canparry = TRUE
	miss_text = "slashes the air!"
	miss_sound = "bluntwooshlarge"
	icon_state = "incut"
	attack_verb = list("cuts", "slashes")
	animname = "cut"
	blade_class = BCLASS_CUT
	item_d_type = "slash"

/datum/intent/mace/strike/gnoll
	name = "armor rending strike"
	miss_text = "strikes the air!"
	miss_sound = "bluntwooshlarge"
	attack_verb = list("punches", "strikes", "tears")
