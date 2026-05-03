GLOBAL_LIST_INIT(towner_caravan_postable_advclasses, list(
	/datum/advclass/blacksmith,
	/datum/advclass/guildsman/blacksmith,
	/datum/advclass/guildsman/artificer,
	/datum/advclass/guildmaster,
))

GLOBAL_LIST_INIT(towner_orevein_postable_advclasses, list(
	/datum/advclass/miner,
	/datum/advclass/guildsman/architect,
	/datum/advclass/guildmaster,
))

GLOBAL_LIST_INIT(towner_posting_tier_costs, list(
	TOWNER_POSTING_TIER_EASY = TOWNER_POSTING_COST_EASY,
	TOWNER_POSTING_TIER_HARD = TOWNER_POSTING_COST_HARD,
))

/proc/get_user_advclass_path(mob/user)
	if(!ishuman(user))
		return null
	var/datum/advclass/AC = user?.mind?.picked_advclass
	if(!AC)
		return null
	return AC.type

/proc/user_can_post_towner_caravan(mob/user)
	var/path = get_user_advclass_path(user)
	if(!path)
		return FALSE
	return (path in GLOB.towner_caravan_postable_advclasses)

/proc/user_can_post_towner_orevein(mob/user)
	var/path = get_user_advclass_path(user)
	if(!path)
		return FALSE
	return (path in GLOB.towner_orevein_postable_advclasses)

/proc/user_can_post_any_towner(mob/user)
	return user_can_post_towner_caravan(user) || user_can_post_towner_orevein(user)

/proc/towner_advclass_names(list/paths)
	var/list/out = list()
	for(var/path in paths)
		var/datum/advclass/AC = path
		var/n = initial(AC.name)
		if(n)
			out += n
	return out

/obj/structure/roguemachine/contractledger/proc/compose_towner_from_tgui(mob/user, list/params)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/poster = user
	if(!poster.Adjacent(src))
		return
	if(SSticker.current_state != GAME_STATE_PLAYING)
		to_chat(poster, span_warning("The ledger is not yet open."))
		return

	var/chosen_type = params["type"]
	if(chosen_type != QUEST_TOWNER_SMITH_CARAVAN && chosen_type != QUEST_TOWNER_MINER_OREVEIN)
		to_chat(poster, span_warning("That posting type is not one the Guild accepts."))
		return

	if(chosen_type == QUEST_TOWNER_SMITH_CARAVAN && !user_can_post_towner_caravan(poster))
		to_chat(poster, span_warning("Only smiths may post a caravan-recovery contract."))
		return
	if(chosen_type == QUEST_TOWNER_MINER_OREVEIN && !user_can_post_towner_orevein(poster))
		to_chat(poster, span_warning("Only miners and their kindred trades may post a vein-strike contract."))
		return

	var/tier = params["tier"]
	if(tier != TOWNER_POSTING_TIER_EASY && tier != TOWNER_POSTING_TIER_HARD)
		to_chat(poster, span_warning("That posting tier is not recognised."))
		return
	var/cost = GLOB.towner_posting_tier_costs[tier]
	if(!cost)
		return

	if(!SStreasury.has_account(poster))
		to_chat(poster, span_warning("You have no account on record."))
		return
	if(SStreasury.get_balance(poster) < cost)
		to_chat(poster, span_warning("Insufficient balance. This posting requires [cost] mammon."))
		return

	var/datum/fund/poster_account = SStreasury.get_account(poster)
	if(!poster_account)
		return
	if(!SStreasury.transfer(poster_account, SStreasury.discretionary_fund, cost, "towner contract posting ([chosen_type])"))
		to_chat(poster, span_warning("The treasury refused the draft."))
		return

	var/datum/quest/towner/dispatched = SSquestpool.issue_towner_quest(chosen_type, poster, tier)
	if(!dispatched)
		SStreasury.transfer(SStreasury.discretionary_fund, poster_account, cost, "towner contract posting refund (issue failure)")
		to_chat(poster, span_warning("No landmark could bear that contract. Funds refunded."))
		return

	playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	to_chat(poster, span_notice("Contract posted: <b>[dispatched.title || dispatched.quest_type]</b> ([tier], [cost]m). The bearer of the contract must bring you along in their fellowship."))
