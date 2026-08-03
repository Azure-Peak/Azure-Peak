//How often to refresh team objectives on members
#define INGAME_ROLE_HEAD_UPDATE_PERIOD 300

/datum/antagonist/prebel
	name = "Peasant Rebel"
	roundend_category = "peasant rebels"
	antagpanel_category = "Peasant Rebellion"
	job_rank = ROLE_PREBEL
	antag_hud_type = ANTAG_HUD_REV
	antag_hud_name = "rev"
	show_in_roundend = FALSE
	confess_lines = list(
		"VIVA!",
		"I JUST WANTED TO SURVIVE THE YIL!",
		"BUT THEY TOOK IT ALL!",
		"BLUE BLOOD FOR THE FREEFOLK!",
	)
	increase_votepwr = FALSE
	rogue_enabled = TRUE
	has_tempo = TRUE
	storyteller_antag_flags = STORYTELLER_ANTAG_VILLAIN | STORYTELLER_ANTAG_ROUNDSTART
	override_candidatereq = TRUE
	storyteller_min_players = CHARACTER_INJECTION_MIN_POP
	storyteller_slot_scaling = REBELLION_ROUNDSTART_TOTAL
	storyteller_slot_default_cap = REBELLION_ROUNDSTART_TOTAL
	var/datum/team/prebels/rev_team
	/// Hidden or not
	var/uprisen = FALSE

/datum/antagonist/prebel/examine_friendorfoe(datum/antagonist/examined_datum,mob/examiner,mob/examined)
	if(istype(examined_datum, /datum/antagonist/prebel/head))
		return span_boldnotice("A revolution leader.")
	if(istype(examined_datum, /datum/antagonist/prebel))
		return span_boldnotice("My ally in revolt against the pigs.")

/datum/antagonist/prebel/on_gain()
	. = ..()
	owner.special_role = ROLE_PREBEL
	create_objectives()
	var/mob/living/carbon/human/H = owner.current
	if(!istype(H))
		return
	H.log_message("has been converted to the revolution!", LOG_ATTACK, color="red")
	H.cmode_music = 'sound/music/cmode/antag/combat_cutpurse.ogg'
	H.add_stress(/datum/stressevent/prebel)
	// Usable only once risen; the cast gates on it.
	owner.AddSpell(new /obj/effect/proc_holder/spell/self/discard_upperclass)
	if(type == /datum/antagonist/prebel)
		owner.AddSpell(new /obj/effect/proc_holder/spell/self/declare_uprising)
		owner.AddSpell(new /obj/effect/proc_holder/spell/self/claim_leadership)
		H.apply_status_effect(/datum/status_effect/rebel_cowed)

/datum/antagonist/prebel/on_removal()
	remove_objectives()
	owner.RemoveSpell(/obj/effect/proc_holder/spell/self/declare_uprising)
	owner.RemoveSpell(/obj/effect/proc_holder/spell/self/claim_leadership)
	owner.RemoveSpell(/obj/effect/proc_holder/spell/self/rebel_kit)
	owner.RemoveSpell(/obj/effect/proc_holder/spell/self/discard_upperclass)
	var/mob/living/carbon/human/H = owner.current
	if(istype(H))
		H.remove_status_effect(/datum/status_effect/rebel_cowed)
		H.remove_status_effect(/datum/status_effect/buff/rebel_town_gated/uprising)
		H.remove_alt_appearance("rebel_loud")
	. = ..()

/datum/antagonist/prebel/greet()
	to_chat(owner, span_danger("It was coming for a while. The taxes grew tighter, and the imports grew duller. O' Lady Astrata, you've done it now, haven't you."))
	to_chat(owner, span_notice("I blend in with my daily work for now. When the time is right, I may DECLARE UPRISING to cast off my disguise, arm myself, and fight openly. Until then, the presence of nobility and their court cows me."))
	owner.current?.playsound_local(get_turf(owner.current), 'sound/music/freemen-rebellion.ogg', 60, FALSE, pressure_affected = FALSE)
	if(rev_team)
		rev_team.update_objectives()
	owner.announce_objectives()
	..()

/datum/antagonist/prebel/can_be_owned(datum/mind/new_owner)
	. = ..()
	if(.)
		if(new_owner.assigned_role in GLOB.aspirant_eligible_positions)
			return FALSE
		if(new_owner.assigned_role == "Mercenary")
			return FALSE
		if(new_owner.assigned_role == "Absolver" || new_owner.assigned_role == "Martyr") // their faith does not waver
			return FALSE
		if(new_owner.unconvertable)
			return FALSE
		if(new_owner.current && HAS_TRAIT(new_owner.current, TRAIT_MINDSHIELD))
			return FALSE
		if(new_owner.current && HAS_TRAIT(new_owner.current, TRAIT_NOBLE))
			return FALSE

/datum/antagonist/prebel/create_team(datum/team/prebels/new_team)
	if(!new_team)
		//For now only one revolution at a time
		for(var/datum/antagonist/prebel/head/H in GLOB.antagonists)
			if(!H.owner)
				continue
			if(H.rev_team)
				rev_team = H.rev_team
				return
		rev_team = new /datum/team/prebels()
		rev_team.update_objectives()
		return
	if(!istype(new_team))
		stack_trace("Wrong team type passed to [type] initialization.")
	rev_team = new_team

/datum/antagonist/prebel/get_team()
	return rev_team

/datum/antagonist/prebel/proc/create_objectives()
	if(get_team())
		objectives |= rev_team.objectives

/datum/antagonist/prebel/proc/remove_objectives()
	if(get_team())
		objectives -= rev_team.objectives

/// This is like when you put your mask on in Payday 2
/datum/antagonist/prebel/proc/uprise()
	if(uprisen)
		return FALSE
	uprisen = TRUE
	var/mob/living/carbon/human/H = owner?.current
	if(!istype(H))
		return FALSE
	owner.RemoveSpell(/obj/effect/proc_holder/spell/self/declare_uprising)
	H.remove_status_effect(/datum/status_effect/rebel_cowed)
	H.apply_status_effect(/datum/status_effect/buff/rebel_town_gated/uprising)
	if(istype(src, /datum/antagonist/prebel/head))
		H.apply_status_effect(/datum/status_effect/buff/rebel_town_gated/leader)
	owner.AddSpell(new /obj/effect/proc_holder/spell/self/rebel_kit)
	H.add_stress(/datum/stressevent/prebel)
	return TRUE

/// mark_state overrides the icon shown to the realm: a once-loud convert who quietly claims
/// leadership keeps their common "rev" mark, so the promotion is not leaked.
/datum/antagonist/prebel/proc/mark_outlaw(mark_state)
	var/mob/living/carbon/human/H = owner?.current
	if(!istype(H))
		return
	ADD_TRAIT(H, TRAIT_OUTLAW, TRAIT_GENERIC)
	if(H.real_name && !(H.real_name in GLOB.outlawed_players))
		GLOB.outlawed_players += H.real_name
	// A rebel who has gone loud is known to the whole realm: their mark shows to everyone.
	// Re-added rather than skipped so a promotion upgrades the icon to the leader's.
	H.remove_alt_appearance("rebel_loud")
	var/image/mark = image('icons/mob/hud.dmi', H, mark_state || antag_hud_name)
	mark.appearance_flags = RESET_COLOR|RESET_TRANSFORM
	H.add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/everyone, "rebel_loud", mark)


/// Counts the mammon in coin carried on a rebel and, if it covers the amount, consumes
/// coins to pay it, returning any overpayment as change. TRUE on payment, FALSE if short.
/proc/rebel_pay_coin(mob/living/carbon/human/H, amount)
	var/carried = 0
	var/list/coins = list()
	for(var/obj/item/roguecoin/coin in H.GetAllContents())
		coins += coin
		carried += coin.get_real_price()
	if(carried < amount)
		return FALSE
	var/paid = 0
	for(var/obj/item/roguecoin/coin in coins)
		if(paid >= amount)
			break
		paid += coin.get_real_price()
		qdel(coin)
	if(paid > amount)
		budget2change(paid - amount, H)
	return TRUE

/// Converts a rebel who's already done their uprising proc
/proc/rebel_make_convert(datum/mind/target_mind, datum/team/prebels/T, apply_buff = TRUE, grant_kit = FALSE)
	target_mind.add_antag_datum(/datum/antagonist/prebel, T)
	var/datum/antagonist/prebel/convert = target_mind.has_antag_datum(/datum/antagonist/prebel)
	if(!convert)
		return null
	convert.uprisen = TRUE
	target_mind.RemoveSpell(/obj/effect/proc_holder/spell/self/declare_uprising)
	var/mob/living/carbon/human/H = target_mind.current
	if(istype(H))
		H.remove_status_effect(/datum/status_effect/rebel_cowed)
		if(apply_buff)
			H.apply_status_effect(/datum/status_effect/buff/rebel_town_gated/uprising)
	if(grant_kit)
		target_mind.AddSpell(new /obj/effect/proc_holder/spell/self/rebel_kit)
	// The outlaw trait survives the datum swap, but the realm-visible mark does not: restore it.
	if(istype(H) && HAS_TRAIT(H, TRAIT_OUTLAW))
		convert.mark_outlaw()
	return convert

/datum/antagonist/prebel/head
	name = "Head Rebel"
	antag_hud_name = "rev_head"
	job_rank = ROLE_REBEL_LEADER
	increase_votepwr = TRUE

/datum/antagonist/prebel/head/on_gain()
	. = ..()
	owner.special_role = ROLE_REBEL_LEADER
	owner.AddSpell(new /obj/effect/proc_holder/spell/self/rebelconvert)
	owner.AddSpell(new /obj/effect/proc_holder/spell/self/incite_uprising)
	owner.AddSpell(new /obj/effect/proc_holder/spell/self/declare_rebellion)
	owner.AddSpell(new /obj/effect/proc_holder/spell/self/rebel_word)

/datum/antagonist/prebel/head/on_removal()
	owner.RemoveSpell(/obj/effect/proc_holder/spell/self/rebelconvert)
	owner.RemoveSpell(/obj/effect/proc_holder/spell/self/incite_uprising)
	owner.RemoveSpell(/obj/effect/proc_holder/spell/self/declare_rebellion)
	owner.RemoveSpell(/obj/effect/proc_holder/spell/self/rebel_word)
	owner.RemoveSpell(/obj/effect/proc_holder/spell/self/rebel_inspire)
	var/mob/living/carbon/human/H = owner.current
	if(istype(H))
		H.remove_status_effect(/datum/status_effect/buff/rebel_town_gated/leader)
	. = ..()

/datum/antagonist/prebel/head/greet()
	to_chat(owner, span_danger("The whispers in the taverns and the mutters at the mill have found their voice in me. The freemen are ready, and they will look to me to lead them. I know what to do."))
	to_chat(owner, span_notice("I may RECRUIT REBELS with a speech, INCITE UPRISING to quietly arm myself, or DECLARE REBELLION in the town to call every convert to arms. Once I have risen, subdued nobles can be made to DISCARD their upper-class trappings."))
	owner.current?.playsound_local(get_turf(owner.current), 'sound/music/freemen-rebellion.ogg', 60, FALSE, pressure_affected = FALSE)
	if(rev_team)
		rev_team.update_objectives()
	owner.announce_objectives()
	..()

/datum/antagonist/prebel/proc/convertible(mob/living/candidate)
	if(!candidate.mind)
		return FALSE
	if(!can_be_owned(candidate.mind))
		return FALSE
	if(candidate.mind.assigned_role in GLOB.aspirant_eligible_positions)
		return FALSE
	var/mob/living/carbon/C = candidate //Check to see if the potential rev is implanted
	if(!istype(C)) //Can't convert simple animals
		return FALSE
	return TRUE

/datum/antagonist/prebel/proc/add_revolutionary(datum/mind/rev_mind)
	if(!convertible(rev_mind.current))
		return FALSE
	rev_mind.add_antag_datum(/datum/antagonist/prebel,rev_team)
	return TRUE

// ------------------------- RECRUITMENT -------------------------

/obj/effect/proc_holder/spell/self/rebelconvert
	name = "RECRUIT REBELS"
	desc = "Gather my words and make a speech, and those who hear it may join the cause. Only the town and its underways hold ears worth swaying, and the battle-tense will not listen."
	antimagic_allowed = TRUE
	recharge_time = 30 SECONDS

/obj/effect/proc_holder/spell/self/rebelconvert/cast(list/targets,mob/user = usr)
	..()
	var/area/speech_area = get_area(user)
	if(!is_type_in_typecache(speech_area, GLOB.roguetown_areas_typecache))
		to_chat(user, span_warning("The cause is won in the town. There is no crowd worth swaying out here."))
		revert_cast()
		return
	var/inputty = input("Make a speech!", "ROGUETOWN") as text|null
	if(!inputty)
		revert_cast()
		return
	user.visible_message(span_warning("[user] draws a deep breath, gathering the crowd's attention..."), span_notice("I draw breath and gather my words..."))
	if(!do_after(user, 5 SECONDS, target = user))
		revert_cast()
		return
	user.say(inputty, forced = "spell")
	var/datum/antagonist/prebel/PR = user.mind.has_antag_datum(/datum/antagonist/prebel)
	for(var/mob/living/carbon/human/L in get_hearers_in_view(6, get_turf(user)))
		if(L == user)
			continue
		if(L.cmode)
			if(L.client)
				to_chat(L, span_warning("I am too tense to listen to the speech."))
				to_chat(user, span_warning("[L.real_name] is too tense to listen to reason!"))
			continue
		addtimer(CALLBACK(L,TYPE_PROC_REF(/mob/living/carbon/human, rev_ask), user,PR,inputty),1)

/mob/living/carbon/human/proc/rev_ask(mob/living/carbon/human/guy,datum/antagonist/prebel/mind_datum,offer)
	if(!guy || !mind_datum || !offer)
		return
	if(!mind)
		return
	if(!client)
		return
	if(mind.special_role)
		return
	if(mob_timers["rebeloffer"])
		return
	if(!mind_datum.convertible(src))
		return
	var/datum/team/prebels/RT = mind_datum.rev_team
	if(!RT)
		return
	var/shittime = world.time
	playsound_local(src, 'sound/misc/rebel.ogg', 100, FALSE)
	var/garbaggio = alert(src, "[offer]","Rebellion", "Yes", "No")
	if(world.time > shittime + 35 SECONDS)
		to_chat(src, span_danger("Too late."))
		return
	mob_timers["rebeloffer"] = world.time
	if(garbaggio == "Yes")
		if(mind_datum.add_revolutionary(mind))
			RT.offers2join += span_info("<B>[real_name]</B> <span class='blue'>ACCEPTED</span> [guy.real_name]: \"[offer]\"")
			to_chat(guy, span_blue("[real_name] joins the revolution."))
	else
		to_chat(src, span_danger("I reject the offer."))
		to_chat(guy, span_danger("[real_name] rejects the offer."))
		RT.offers2join += span_info("<B>[real_name]</B> <span class='red'>REJECTED</span> [guy.real_name]: \"[offer]\"")

// ------------------------- UPRISING SPELLS -------------------------

/// Convert spell: publicly cast off the disguise. One use.
/obj/effect/proc_holder/spell/self/declare_uprising
	name = "Declare Uprising"
	desc = "Cast off my disguise and take up the freemen's cause openly. I will be a branded outlaw, and I will be stronger for it.."
	antimagic_allowed = TRUE
	human_req = TRUE
	recharge_time = 10 SECONDS

/obj/effect/proc_holder/spell/self/declare_uprising/cast(list/targets, mob/user = usr)
	..()
	var/mob/living/carbon/human/H = user
	if(!istype(H) || !H.mind)
		revert_cast()
		return
	var/datum/antagonist/prebel/P = H.mind.has_antag_datum(/datum/antagonist/prebel)
	if(!P || P.uprisen)
		revert_cast()
		return
	if(alert(H, "Declare my uprising? The whole realm will know me as a rebel and outlaw.", "NO GODS, NO MASTERS", "Yes", "No") != "Yes")
		revert_cast()
		return
	if(!P.uprise())
		revert_cast()
		return
	P.mark_outlaw()
	H.emote("scream")
	priority_announce("[H.real_name] has risen against the old order of [SSticker.realm_name]! Let all know them as a REBEL and an outlaw of the realm!", "Rebellion Stirs", 'sound/misc/rebel.ogg')

/// Give armaments.
/obj/effect/proc_holder/spell/self/incite_uprising
	name = "Incite Uprising"
	desc = "Quietly steel myself for the coming rebellion. I gain my fervor, access to the freemen's arsenal, and the voice to INSPIRE my fellow rebels, without revealing myself to the realm."
	antimagic_allowed = TRUE
	human_req = TRUE
	recharge_time = 10 SECONDS

/obj/effect/proc_holder/spell/self/incite_uprising/cast(list/targets, mob/user = usr)
	..()
	var/mob/living/carbon/human/H = user
	if(!istype(H) || !H.mind)
		revert_cast()
		return
	var/datum/antagonist/prebel/head/P = H.mind.has_antag_datum(/datum/antagonist/prebel/head)
	if(!P)
		revert_cast()
		return
	if(!P.uprisen)
		P.uprise()
	if(!(locate(/obj/effect/proc_holder/spell/self/rebel_inspire) in H.mind.spell_list))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/rebel_inspire)
	to_chat(H, span_boldnotice("The uprising begins with me. My fervor rises, and the freemen's arsenal is open to me."))
	H.mind.RemoveSpell(/obj/effect/proc_holder/spell/self/incite_uprising)

/// Go loud.
/obj/effect/proc_holder/spell/self/declare_rebellion
	name = "DECLARE REBELLION"
	desc = "Declare open rebellion before the people. Only possible within the town or its underways. The rebellion hears the word at once; a minute later every convert casts off their disguise and the realm learns of us."
	antimagic_allowed = TRUE
	human_req = TRUE
	recharge_time = 30 SECONDS

/obj/effect/proc_holder/spell/self/declare_rebellion/cast(list/targets, mob/user = usr)
	..()
	var/mob/living/carbon/human/H = user
	if(!istype(H) || !H.mind)
		revert_cast()
		return
	var/datum/antagonist/prebel/head/P = H.mind.has_antag_datum(/datum/antagonist/prebel/head)
	if(!P)
		revert_cast()
		return
	var/area/casting_area = get_area(H)
	if(!is_type_in_typecache(casting_area, GLOB.roguetown_areas_typecache))
		to_chat(H, span_warning("The rebellion must be declared before the people, within the town or its underways."))
		revert_cast()
		return
	var/datum/team/prebels/T = P.rev_team
	if(T?.rebellion_declared)
		to_chat(H, span_warning("The rebellion has already been declared."))
		revert_cast()
		return
	if(alert(H, "Declare open rebellion? Every convert will be forced into the open within the minute.", "VIVA", "Yes", "No") != "Yes")
		revert_cast()
		return
	P.uprise()
	if(T)
		T.rebellion_declared = TRUE
		for(var/datum/mind/member_mind in T.members)
			if(!member_mind.current)
				continue
			to_chat(member_mind.current, span_boldannounce("The word is given. [H.real_name] has declared the rebellion. In one minute, everyone casts off their disguise. Prepare!"))
			member_mind.current.playsound_local(member_mind.current, 'sound/misc/rebel.ogg', 100, FALSE)
		addtimer(CALLBACK(T, TYPE_PROC_REF(/datum/team/prebels, mass_uprise), H.real_name), REBELLION_AUTO_UPRISE_TIME)
	H.mind.RemoveSpell(/obj/effect/proc_holder/spell/self/declare_rebellion)

/// Rebel-only announcement
/obj/effect/proc_holder/spell/self/rebel_word
	name = "Word of the Rebellion"
	desc = "Pay couriers and sympathizers 300 mammon in carried coin to whisper my words to every rebel in the realm, wherever they hide."
	antimagic_allowed = TRUE
	human_req = TRUE
	recharge_time = 3 MINUTES

/obj/effect/proc_holder/spell/self/rebel_word/cast(list/targets, mob/user = usr)
	..()
	var/mob/living/carbon/human/H = user
	if(!istype(H) || !H.mind)
		revert_cast()
		return
	var/datum/antagonist/prebel/head/P = H.mind.has_antag_datum(/datum/antagonist/prebel/head)
	if(!P || !P.rev_team)
		revert_cast()
		return
	var/message = input(H, "What word shall the couriers carry?", "WORD OF THE REBELLION") as text|null
	if(!message)
		revert_cast()
		return
	if(!rebel_pay_coin(H, REBELLION_WORD_COST))
		to_chat(H, span_warning("The couriers do not run on promises. I need [REBELLION_WORD_COST] mammon on my person."))
		revert_cast()
		return
	for(var/datum/mind/member_mind in P.rev_team.members)
		if(!member_mind.current)
			continue
		to_chat(member_mind.current, span_boldannounce("Word of the rebellion, from [H.real_name]: \"[message]\""))
		member_mind.current.playsound_local(member_mind.current, 'sound/misc/rebel.ogg', 50, FALSE)

/// Leader buffs.
/obj/effect/proc_holder/spell/self/rebel_inspire
	name = "Inspire the Downtrodden"
	desc = "Rally my fellow rebels in sight with revolutionary zeal, quickening their arms for a time."
	antimagic_allowed = TRUE
	human_req = TRUE
	recharge_time = 2 MINUTES

/obj/effect/proc_holder/spell/self/rebel_inspire/cast(list/targets, mob/user = usr)
	..()
	var/mob/living/carbon/human/H = user
	if(!istype(H) || !H.mind)
		revert_cast()
		return
	var/inspired = 0
	for(var/mob/living/carbon/human/L in get_hearers_in_view(7, get_turf(H)))
		if(L == H)
			continue
		if(L.stat != CONSCIOUS)
			continue
		var/datum/antagonist/prebel/fellow = L.mind?.has_antag_datum(/datum/antagonist/prebel)
		if(!fellow || !fellow.uprisen)
			continue
		if(L.has_status_effect(/datum/status_effect/buff/rebel_inspired))
			continue
		L.apply_status_effect(/datum/status_effect/buff/rebel_inspired)
		L.add_stress(/datum/stressevent/prebel)
		inspired++
	if(inspired)
		H.visible_message(span_warning("[H] cries out with revolutionary zeal!"), span_boldnotice("My words stir [inspired] of my fellows to greater deeds!"))
	else
		to_chat(H, span_warning("No fellow rebels are near to hear my words."))
		revert_cast()

// ------------------------- FREEMAN'S ARSENAL -------------------------

/// Converts are militia-tier, leaders are bandit-tier.
/obj/effect/proc_holder/spell/self/rebel_kit
	name = "Freeman's Arsenal"
	desc = "Call upon hidden caches of the rebellion to arm myself. One choice, once."
	antimagic_allowed = TRUE
	human_req = TRUE
	recharge_time = 5 SECONDS

/obj/effect/proc_holder/spell/self/rebel_kit/cast(list/targets, mob/user = usr)
	..()
	var/mob/living/carbon/human/H = user
	if(!istype(H) || !H.mind)
		revert_cast()
		return
	var/is_leader = H.mind.has_antag_datum(/datum/antagonist/prebel/head)
	var/list/options
	if(is_leader)
		options = list("Brigand (battleaxe and flail)", "Blackblade (longsword and shield)", "Poacher (longbow and dagger)")
	else
		options = list("Spear & Shield", "Billhook", "Cudgel & Shield", "Hunting Bow", "Goedendag", "Thresher", "Scythe", "Militia Pickaxe")
	var/choice = input(H, "How shall I arm myself?", "FREEMAN'S ARSENAL") as null|anything in options
	if(!choice)
		revert_cast()
		return
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_APPRENTICE, TRUE)
	var/list/hand_items = list()
	var/list/sack_items = list(
		/obj/item/rogueweapon/sword/short,
		/obj/item/clothing/suit/roguetown/armor/gambeson/heavy,
	)
	if(is_leader)
		sack_items += list(/obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle/iron, /obj/item/clothing/neck/roguetown/coif)
		H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_JOURNEYMAN, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_JOURNEYMAN, TRUE)
		switch(choice)
			if("Brigand (battleaxe and flail / banded iron plate)")
				hand_items += /obj/item/rogueweapon/stoneaxe/battle
				sack_items += list(
					/obj/item/rogueweapon/flail, 
					/obj/item/clothing/suit/roguetown/armor/plate/iron/banded
				)
				ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
			if("Blackblade (longsword and shield / iron cuirass)")
				hand_items += /obj/item/rogueweapon/sword/long
				sack_items += list(
					/obj/item/rogueweapon/shield/iron, 
					/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron
				)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Poacher (longbow and dagger)")
				hand_items += /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
				sack_items += list(
					/obj/item/quiver/arrows, 
					/obj/item/rogueweapon/huntingknife/idagger
				)
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
	else
		// The levyman's classic: haubergeon over gambeson, leathers for the limbs.
		sack_items += list(/obj/item/clothing/head/roguetown/helmet/kettle, /obj/item/clothing/suit/roguetown/armor/chainmail/iron, /obj/item/clothing/wrists/roguetown/bracers/leather, /obj/item/clothing/gloves/roguetown/leather, /obj/item/clothing/shoes/roguetown/boots)
		switch(choice)
			if("Spear & Shield")
				hand_items += /obj/item/rogueweapon/spear
				sack_items += /obj/item/rogueweapon/shield/wood
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_APPRENTICE, TRUE)
			if("Billhook")
				hand_items += /obj/item/rogueweapon/spear/billhook
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Cudgel & Shield")
				hand_items += /obj/item/rogueweapon/mace/cudgel
				sack_items += /obj/item/rogueweapon/shield/wood
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_APPRENTICE, TRUE)
			if("Hunting Bow")
				hand_items += /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				sack_items += /obj/item/quiver/arrows
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Goedendag")
				hand_items += /obj/item/rogueweapon/woodstaff/militia
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Thresher")
				hand_items += /obj/item/rogueweapon/flail/peasantwarflail
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Scythe")
				hand_items += /obj/item/rogueweapon/scythe/militia
				H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Militia Pickaxe")
				hand_items += /obj/item/rogueweapon/pick/militia/steel
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
	var/turf/T = get_turf(H)
	for(var/path in hand_items)
		var/obj/item/I = new path(T)
		H.put_in_hands(I)
	var/obj/item/storage/backpack/rogue/satchel/sack = new(T)
	for(var/path in sack_items)
		new path(sack)
	if(is_leader)
		// Seed funding for couriers, mantles, and bribes.
		new /obj/item/roguecoin/gold(sack, REBELLION_LEADER_FUNDS / 10)
	if(!H.put_in_hands(sack))
		to_chat(H, span_notice("I knew this would come to use, somedae."))
	H.mind.RemoveSpell(/obj/effect/proc_holder/spell/self/rebel_kit)

// ------------------------- DISCARD THE UPPER-CLASS -------------------------

/// Money by subduing nobles (or you can become the leader if you topple an existing leader lol)
/obj/effect/proc_holder/spell/self/discard_upperclass
	name = "Discard Upper-Class"
	desc = "Strip a subdued noble beside me of their upper-class trappings for the freemen's coffers. A subdued rebel leader may instead be made to yield their leadership to me."
	antimagic_allowed = TRUE
	human_req = TRUE
	recharge_time = 30 SECONDS

/obj/effect/proc_holder/spell/self/discard_upperclass/proc/is_subdued(mob/living/carbon/human/M)
	return (M.stat != CONSCIOUS) || M.restrained()

/obj/effect/proc_holder/spell/self/discard_upperclass/cast(list/targets, mob/user = usr)
	..()
	var/mob/living/carbon/human/H = user
	if(!istype(H) || !H.mind)
		revert_cast()
		return
	var/datum/antagonist/prebel/P = H.mind.has_antag_datum(/datum/antagonist/prebel)
	if(!P)
		revert_cast()
		return
	if(!P.uprisen)
		to_chat(H, span_warning("Only once I have risen against the old order may I cast down its finery."))
		revert_cast()
		return
	var/datum/team/prebels/T = P.rev_team
	var/list/victims = list()
	for(var/mob/living/carbon/human/M in orange(1, H))
		if(M == H)
			continue
		if(M.stat == DEAD)
			continue
		if(!is_subdued(M))
			continue
		if(T && (M.mind in T.discarded))
			continue
		if(M.mind?.has_antag_datum(/datum/antagonist/prebel/head))
			victims[M.real_name] = M
			continue
		if((M == SSticker.rulermob) || HAS_TRAIT(M, TRAIT_NOBLE) || (M.job in GLOB.noble_positions) || (M.job in GLOB.courtier_positions))
			victims[M.real_name] = M
	if(!length(victims))
		to_chat(H, span_warning("No subdued member of the upper-class, nor rebel leader, is within my reach."))
		revert_cast()
		return
	var/choice = input(H, "Who shall be discarded?", "DISCARD UPPER-CLASS") as null|anything in victims
	if(!choice)
		revert_cast()
		return
	var/mob/living/carbon/human/M = victims[choice]
	// The dead cannot be discarded, even if they died while the choice was being made.
	if(QDELETED(M) || M.stat == DEAD || !H.Adjacent(M) || !is_subdued(M))
		revert_cast()
		return
	if(M.mind?.has_antag_datum(/datum/antagonist/prebel/head))
		usurp_leadership(H, M, T)
		return
	var/payout = 0
	if(M == SSticker.rulermob)
		payout = REBELLION_PAYOUT_RULER
	else if(HAS_TRAIT(M, TRAIT_NOBLE) || (M.job in GLOB.noble_positions))
		payout = rand(REBELLION_PAYOUT_NOBLE_LOW, REBELLION_PAYOUT_NOBLE_HIGH)
	else
		payout = rand(REBELLION_PAYOUT_COURTIER_LOW, REBELLION_PAYOUT_COURTIER_HIGH)
	REMOVE_TRAIT(M, TRAIT_NOBLE, list(TRAIT_GENERIC, TRAIT_VIRTUE, JOB_TRAIT, ROUNDSTART_TRAIT))
	if(T)
		T.discarded |= M.mind
	budget2change(payout, H)
	H.visible_message(span_danger("[H] strips [M] of their upper-class trappings!"), span_boldnotice("I strip [M.real_name] of their pretensions. [payout] mammon for the freemen's coffers!"))
	to_chat(M, span_userdanger("My lady Astrata - save me!"))
	H.add_stress(/datum/stressevent/rebel_discard)
	M.add_stress(/datum/stressevent/rebel_discarded)

/obj/effect/proc_holder/spell/self/discard_upperclass/proc/usurp_leadership(mob/living/carbon/human/H, mob/living/carbon/human/M, datum/team/prebels/T)
	var/datum/antagonist/prebel/head/old_head = M.mind.has_antag_datum(/datum/antagonist/prebel/head)
	var/target_risen = old_head ? old_head.uprisen : FALSE
	var/target_kit = (locate(/obj/effect/proc_holder/spell/self/rebel_kit) in M.mind.spell_list)
	M.mind.remove_antag_datum(/datum/antagonist/prebel/head)
	var/datum/antagonist/prebel/demoted = rebel_make_convert(M.mind, T, target_risen, target_risen && target_kit)
	demoted?.mark_outlaw()

	if(!H.mind.has_antag_datum(/datum/antagonist/prebel/head))
		var/caster_kit = (locate(/obj/effect/proc_holder/spell/self/rebel_kit) in H.mind.spell_list)
		H.mind.remove_antag_datum(/datum/antagonist/prebel)
		H.mind.add_antag_datum(/datum/antagonist/prebel/head, T)
		var/datum/antagonist/prebel/head/new_head = H.mind.has_antag_datum(/datum/antagonist/prebel/head)
		if(!new_head)
			rebel_make_convert(H.mind, T, TRUE, caster_kit)
			to_chat(H, span_warning("The mantle slips from my grasp."))
			return
		new_head.uprisen = TRUE
		H.apply_status_effect(/datum/status_effect/buff/rebel_town_gated/uprising)
		H.apply_status_effect(/datum/status_effect/buff/rebel_town_gated/leader)
		if(caster_kit)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/rebel_kit)
	var/datum/antagonist/prebel/head/usurper = H.mind.has_antag_datum(/datum/antagonist/prebel/head)
	if(usurper)
		usurper.mark_outlaw()
	budget2change(REBELLION_PAYOUT_USURP, H)
	priority_announce("Word spreads through [SSticker.realm_name]'s gutters: [M.real_name] has been cast down, and [H.real_name] now leads the rebellion!", "The Rebellion Turns", 'sound/misc/rebel.ogg')
	to_chat(M, span_userdanger("I was supposed to be the one on the throne!"))
	H.add_stress(/datum/stressevent/rebel_discard)
	M.add_stress(/datum/stressevent/rebel_usurped)

// ------------------------- CLAIM LEADERSHIP -------------------------

/// In case your leader's valided
/obj/effect/proc_holder/spell/self/claim_leadership
	name = "Claim Leadership"
	desc = "Kneel by the corpse of a fallen leader of the rebellion and take up their mantle. The cause demands 200 mammon in carried coin. The rebellion will know. The realm will not."
	antimagic_allowed = TRUE
	human_req = TRUE
	recharge_time = 10 SECONDS

/obj/effect/proc_holder/spell/self/claim_leadership/cast(list/targets, mob/user = usr)
	..()
	var/mob/living/carbon/human/H = user
	if(!istype(H) || !H.mind)
		revert_cast()
		return
	var/datum/antagonist/prebel/P = H.mind.has_antag_datum(/datum/antagonist/prebel)
	if(!P)
		revert_cast()
		return
	if(H.mind.has_antag_datum(/datum/antagonist/prebel/head))
		to_chat(H, span_warning("I already lead the rebellion."))
		revert_cast()
		return
	var/datum/team/prebels/T = P.rev_team
	var/mob/living/carbon/human/fallen
	for(var/mob/living/carbon/human/M in orange(1, H))
		if(M.stat != DEAD)
			continue
		if(!M.mind?.has_antag_datum(/datum/antagonist/prebel/head))
			continue
		if(T && (M.mind in T.leadership_claimed))
			continue
		fallen = M
		break
	if(!fallen)
		to_chat(H, span_warning("No fallen leader of the rebellion lies within my reach."))
		revert_cast()
		return

	if(!rebel_pay_coin(H, REBELLION_CLAIM_COST))
		to_chat(H, span_warning("Leading the cause takes coin. I need [REBELLION_CLAIM_COST] mammon on my person to seize the mantle."))
		revert_cast()
		return
	if(T)
		T.leadership_claimed += fallen.mind
	var/was_uprisen = P.uprisen
	var/had_kit = (locate(/obj/effect/proc_holder/spell/self/rebel_kit) in H.mind.spell_list)
	H.mind.remove_antag_datum(/datum/antagonist/prebel)
	H.mind.add_antag_datum(/datum/antagonist/prebel/head, T)
	var/datum/antagonist/prebel/head/new_head = H.mind.has_antag_datum(/datum/antagonist/prebel/head)
	if(!new_head)
		if(was_uprisen)
			rebel_make_convert(H.mind, T, TRUE, had_kit)
		else
			H.mind.add_antag_datum(/datum/antagonist/prebel, T)
		if(T)
			T.leadership_claimed -= fallen.mind
		budget2change(REBELLION_CLAIM_COST, H)
		to_chat(H, span_warning("The mantle slips from my grasp."))
		return
	new_head.uprisen = was_uprisen
	if(was_uprisen)
		H.apply_status_effect(/datum/status_effect/buff/rebel_town_gated/uprising)
		H.apply_status_effect(/datum/status_effect/buff/rebel_town_gated/leader)
		if(had_kit)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/rebel_kit)
	if(HAS_TRAIT(H, TRAIT_OUTLAW))
		new_head.mark_outlaw("rev")
	to_chat(H, span_boldnotice("In the absence of a leader, I've decided to take matters into my own hands. [fallen.real_name]'s mantle is mine."))
	if(T)
		for(var/datum/mind/member_mind in T.members)
			if(member_mind == H.mind || !member_mind.current)
				continue
			to_chat(member_mind.current, span_notice("Word passes among the rebellion in whispers: [H.real_name] has taken up the fallen [fallen.real_name]'s mantle."))

// ------------------------- STATUS EFFECTS -------------------------

// These work only in town
/datum/status_effect/buff/rebel_town_gated
	duration = -1
	/// Optional flavor on gaining the buff and on losing it to distance.
	var/active_msg
	var/deactive_msg

/datum/status_effect/buff/rebel_town_gated/on_apply()
	. = ..()
	if(. && active_msg)
		to_chat(owner, span_boldnotice(active_msg))

/datum/status_effect/buff/rebel_town_gated/process()
	. = ..()
	if(QDELETED(owner))
		return
	var/area/owner_area = get_area(owner)
	if(!owner_area || !GLOB.roguetown_areas_typecache[owner_area.type])
		if(deactive_msg)
			to_chat(owner, span_warning(deactive_msg))
		owner.remove_status_effect(type)

/datum/status_effect/buff/rebel_town_gated/uprising
	id = "rebel_uprising"
	alert_type = /atom/movable/screen/alert/status_effect/buff/rebel_uprising
	effectedstats = list(STATKEY_LCK = 2, STATKEY_STR = 1, STATKEY_WIL = 1, STATKEY_CON = 1, STATKEY_INT = 2)
	active_msg = "Azure Peak is where I make my stand. We'll make it."
	deactive_msg = "I'm straying too far from the city's bounds.."

/atom/movable/screen/alert/status_effect/buff/rebel_uprising
	name = "Revolutionary Fervor"
	desc = "The freemen's cause burns within me, so long as I stand within the town."
	icon_state = "guardsman"

/datum/status_effect/buff/rebel_town_gated/leader
	id = "rebel_leader"
	alert_type = /atom/movable/screen/alert/status_effect/buff/rebel_leader
	effectedstats = list(STATKEY_STR = 1, STATKEY_CON = 1, STATKEY_WIL = 1)

/atom/movable/screen/alert/status_effect/buff/rebel_leader
	name = "Voice of the Rebellion"
	desc = "The people look to me while I walk the town. Best not to let them down."
	icon_state = "guardsman"

/datum/status_effect/rebel_cowed
	id = "rebel_cowed"
	alert_type = /atom/movable/screen/alert/status_effect/rebel_cowed
	duration = -1
	tick_interval = 3 SECONDS
	effectedstats = list()
	var/list/cowed_stats = list(STATKEY_WIL = -1)
	var/stats_active = FALSE

/atom/movable/screen/alert/status_effect/rebel_cowed
	name = "Cowed"
	desc = "Yuck! A noble!"
	icon_state = "sleepy"

/datum/status_effect/rebel_cowed/proc/noble_nearby()
	for(var/mob/living/carbon/human/M in view(5, owner))
		if(M == owner)
			continue
		if(M.stat == DEAD)
			continue
		if(HAS_TRAIT(M, TRAIT_NOBLE) || (M.job in GLOB.noble_positions) || (M.job in GLOB.courtier_positions))
			return TRUE
	return FALSE

/datum/status_effect/rebel_cowed/tick()
	..()
	var/cowed = noble_nearby()
	if(cowed && !stats_active)
		stats_active = TRUE
		for(var/S in cowed_stats)
			owner.change_stat(S, cowed_stats[S])
	else if(!cowed && stats_active)
		stats_active = FALSE
		for(var/S in cowed_stats)
			owner.change_stat(S, -(cowed_stats[S]))

/datum/status_effect/rebel_cowed/on_remove()
	if(stats_active)
		stats_active = FALSE
		for(var/S in cowed_stats)
			owner.change_stat(S, -(cowed_stats[S]))
	return ..()

/datum/status_effect/buff/rebel_inspired
	id = "rebel_inspired"
	alert_type = /atom/movable/screen/alert/status_effect/buff/rebel_inspired
	duration = 1 MINUTES
	status_type = STATUS_EFFECT_UNIQUE
	effectedstats = list(STATKEY_STR = 1, STATKEY_SPD = 1)

/atom/movable/screen/alert/status_effect/buff/rebel_inspired
	name = "Inspired"
	desc = "A leader of the rebellion has stirred my blood!"
	icon_state = "guardsman"

// ------------------------- STRESS EVENTS -------------------------

/datum/stressevent/rebel_discard
	timer = 10 MINUTES
	stressadd = -6
	desc = span_boldgreen("One by one, we'll get rid of them all.")

/datum/stressevent/rebel_discarded
	timer = 10 MINUTES
	stressadd = 6
	desc = span_boldred("Stripped of my standing by common filth!")

/datum/stressevent/rebel_usurped
	timer = 15 MINUTES
	stressadd = 12
	desc = span_boldred("I was his chosen! This wasn't meant to be!")

// ------------------------- TEAM AND OBJECTIVE -------------------------

/datum/team/prebels
	name = "Peasant Rebels"
	var/list/offers2join = list()
	/// Set once a rebel completes the Rite of Popular Acclaim
	var/rite_won = FALSE
	/// Set once a leader declares open rebellion
	var/rebellion_declared = FALSE
	/// Stores minds who've already been stripped
	var/list/discarded = list()
	/// Stores mobs who've already had their leadership taken
	var/list/leadership_claimed = list()

/// Force uprising for all hidden rebels
/datum/team/prebels/proc/mass_uprise(leader_name)
	var/list/risen_names = list()
	for(var/datum/mind/M in members)
		var/datum/antagonist/prebel/P = M.has_antag_datum(/datum/antagonist/prebel)
		if(!P)
			continue
		if(!P.uprisen)
			if(!P.uprise())
				continue
			if(M.current)
				risen_names += M.current.real_name
				to_chat(M.current, span_userdanger("The rebellion is declared. There is no more hiding. I rise with my fellows!"))
		P.mark_outlaw()
	var/led_by = leader_name ? ", led by [leader_name]" : ""
	var/shed = length(risen_names) ? " [english_list(risen_names)] cast off their disguises to join the fight." : ""
	priority_announce("The commonfolk of [SSticker.realm_name] rise in OPEN REBELLION[led_by], challenging Astrata's dominion![shed] All rebels are outlaws of the realm!", "REBELLION", 'sound/misc/rebel.ogg')

/datum/objective/prebel
	name = "Rebellion"
	explanation_text = "Rebellion has come to Azure Peak. It's our tyme now, Lady Tyrant."
	team_explanation_text = "Claim the throne through the Rite of Popular Acclaim. Nothing else matters."

/datum/objective/prebel/check_completion()
	var/datum/team/prebels/T = team
	if(T?.rite_won)
		return TRUE
	var/mob/living/ruler = SSticker.rulermob
	if(ruler && ruler.mind?.has_antag_datum(/datum/antagonist/prebel))
		return TRUE
	return FALSE

/datum/team/prebels/proc/update_objectives()
	if(!(locate(/datum/objective/prebel) in objectives))
		var/datum/objective/prebel/preb = new
		preb.team = src
		objectives += preb
	for(var/datum/mind/M in members)
		var/datum/antagonist/prebel/R = M.has_antag_datum(/datum/antagonist/prebel)
		if(!R)
			R = M.has_antag_datum(/datum/antagonist/prebel/head)
		R.objectives |= objectives

	addtimer(CALLBACK(src,PROC_REF(update_objectives)),INGAME_ROLE_HEAD_UPDATE_PERIOD,TIMER_UNIQUE)


/datum/team/prebels/roundend_report()
	to_chat(world, span_header(" * [name] * "))
	to_chat(world, "[printplayerlist(members)]")

	if(objectives.len)
		var/win = TRUE
		var/objective_count = 1
		for(var/datum/objective/objective in objectives)
			if(objective.check_completion())
				to_chat(world, "<B>Goal #[objective_count]</B>: [objective.explanation_text] <span class='greentext'>TRIUMPH!</span>")
			else
				to_chat(world, "<B>Goal #[objective_count]</B>: [objective.explanation_text] <span class='redtext'>FAIL.</span>")
				win = FALSE
			objective_count++
		if(win)
			for(var/datum/mind/M in members)
				var/is_leader = M.has_antag_datum(/datum/antagonist/prebel/head)
				M.adjust_triumphs(is_leader ? REBELLION_TRIUMPH_LEADER : REBELLION_TRIUMPH_CONVERT)
			to_chat(world, span_greentext("The Peasant Rebellion has TRIUMPHED!"))
		else
			to_chat(world, span_redtext("The Peasant Rebellion has FAILED!"))
		for(var/X in offers2join)
			to_chat(world,"[X]")

#undef INGAME_ROLE_HEAD_UPDATE_PERIOD
