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
	armor = ARMOR_WWOLF
	prevent_crits = PREVENT_CRITS_ALL
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = FALSE
	max_integrity = 550
	item_flags = DROPDEL
	repair_time = 15 SECONDS
	interrupt_damount = 35

/datum/antagonist/gnoll
	name = "Gnoll"
	roundend_category = "Gnolls"
	antagpanel_category = "Gnoll"
	job_rank = ROLE_GNOLL

/datum/antagonist/gnoll/on_gain()
	greet()
	owner.special_role = name

	return ..()

/datum/antagonist/gnoll/greet()
	to_chat(owner.current, span_userdanger("I am one of Graggar's chosen. My body sculpted as a reward for my great deeds. Now, I must find worthy challengers to continue proving my merit. Unlike Dendor's wolves, gnollhood has left some of my intellect intact."))
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
	wdefense = 4

/obj/item/rogueweapon/werewolf_claw/gnoll/right

/obj/item/rogueweapon/werewolf_claw/gnoll/left
