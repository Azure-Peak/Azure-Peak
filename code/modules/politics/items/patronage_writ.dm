/obj/item/patronage_writ
	name = "Patronage Writ"
	desc = "A signed writ of patronage."
	icon = 'icons/roguetown/items/paper.dmi'
	icon_state = "paper_altprep"
	w_class = WEIGHT_CLASS_TINY
	force = 0
	throwforce = 0
	var/issuer_name
	var/issuer_year
	var/granted_trait
	var/faction_label = "an unknown faction"
	var/roster_cap = PATRON_CAP_MERCHANT

/obj/item/patronage_writ/proc/get_roster()
	return null

/obj/item/patronage_writ/proc/grants_residency()
	return FALSE

/obj/item/patronage_writ/proc/redemption_announcement(mob/living/carbon/human/user)
	return "[user.real_name] is an agent of [faction_label]."

/obj/item/patronage_writ/examine(mob/user)
	. = ..()
	. += span_info("Signed by [issuer_name || "an unknown hand"], [issuer_year || CALENDAR_EPOCH_YEAR]. Use in hand to claim agency of [faction_label].")

/obj/item/patronage_writ/attack_self(mob/living/carbon/human/user)
	if(!istype(user))
		return ..()
	if(!granted_trait)
		to_chat(user, span_warning("The writ names no patronage to grant."))
		return
	if(issuer_name && issuer_name == user.real_name)
		to_chat(user, span_warning("I cannot grant patronage to myself - the writ must pass through another's hand."))
		return
	if(HAS_TRAIT(user, granted_trait))
		to_chat(user, span_warning("I'm already on this roll."))
		return
	var/list/roster = get_roster()
	if(isnull(roster))
		to_chat(user, span_warning("The roll is unreachable."))
		return
	prune_roster(roster)
	if(length(roster) >= roster_cap)
		to_chat(user, span_warning("[faction_label]'s roll is full."))
		return
	ADD_TRAIT(user, granted_trait, TRAIT_GENERIC)
	if(grants_residency())
		ADD_TRAIT(user, TRAIT_RESIDENT, "patronage_[granted_trait]")
	roster += user
	user.visible_message(span_notice("[user] signs the roll."), \
		span_notice("I'm an agent of [faction_label]."))
	playsound(get_turf(user), 'sound/misc/gold_license.ogg', 60, FALSE, -1)
	log_admin("PATRONAGE GRANTED: [key_name(user)] enrolled as [granted_trait].")
	qdel(src)

/obj/item/patronage_writ/proc/prune_roster(list/roster)
	for(var/mob/living/carbon/human/H in roster)
		if(QDELETED(H) || !HAS_TRAIT(H, granted_trait))
			roster -= H

/obj/item/patronage_writ/charter
	name = "Writ of Charter"
	desc = "A writ of the Azurian Trading Company. Claim it for chartered agency."
	granted_trait = TRAIT_AGENT_MERCHANT
	faction_label = "the Azurian Trading Company"

/obj/item/patronage_writ/charter/get_roster()
	return SStreasury?.merchant_agents

/obj/item/patronage_writ/charter/grants_residency()
	return TRUE

/obj/item/patronage_writ/token
	name = "Token of the Bathhouse"
	desc = "A sealed token of the Bathhouse. Claim it for agency."
	granted_trait = TRAIT_AGENT_BATHHOUSE
	faction_label = "the Bathhouse"

/obj/item/patronage_writ/token/get_roster()
	return SStreasury?.bathhouse_agents

/obj/item/patronage_writ/benefactor
	name = "Letter of Benefaction"
	desc = "A sealed letter of the Church of Azuria, conferring the rank of Benefactor upon its bearer."
	granted_trait = TRAIT_AGENT_CHURCH
	faction_label = "the Church of Azuria"
	roster_cap = PATRON_CAP_CHURCH

/obj/item/patronage_writ/benefactor/get_roster()
	return SStreasury?.church_agents
