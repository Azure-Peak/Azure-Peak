/obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor
	slot_flags = null
	name = "gnoll skin"
	desc = "an impenetrable hide of graggar's fury"
	mob_overlay_icon = 'icons/roguetown/mob/monster/gnoll.dmi'
	icon = 'icons/roguetown/mob/monster/gnoll.dmi'
	icon_state = "berserker"
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	//slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	armor = ARMOR_GNOLL_STANDARD
	prevent_crits = PREVENT_CRITS_ALL
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = FALSE
	max_integrity = 475
	item_flags = DROPDEL

	auto_repair_mode = TRUE
	relative_repair_interval = 15 SECONDS
	interrupt_damount = 15

/datum/antagonist/gnoll
	name = "Gnoll"
	roundend_category = "Gnolls"
	antagpanel_category = "Gnolls"
	job_rank = ROLE_GNOLL

/datum/antagonist/gnoll/on_gain()
	greet()
	owner.special_role = "Gnoll"

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
	wdefense = 5
	force = 28
	possible_item_intents = list(/datum/intent/simple/gnoll_cut, /datum/intent/simple/werewolf/gnoll, /datum/intent/mace/smash/werewolf/gnoll, /datum/intent/mace/strike/gnoll)

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
	hitsound = "genslash"
	penfactor = 20
	candodge = TRUE
	canparry = TRUE
	miss_text = "slashes the air!"
	miss_sound = "bluntwooshlarge"
	item_d_type = "slash"
	damfactor = 1.2

/datum/intent/mace/smash/werewolf/gnoll
	name = "thrash"
	desc = "A powerful, smash of lycan muscle that deals normal damage but can throw a standing opponent back and slow them down, based on your strength. Ineffective below 10 strength. Slowdown & Knockback scales to your Strength up to 15 (1 - 5 tiles). Cannot be used consecutively more than every 5 seconds on the same target. Prone targets halve the knockback distance."
	icon_state = "insmash"
	maxrange = 5
	chargetime = 1
	penfactor = 0

/datum/intent/simple/gnoll_cut
	name = "cutting claw"
	hitsound = "genslash"
	penfactor = 70
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
