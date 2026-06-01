// A Knight may take a Squire as their protégé for the round.
//
// Mechanics:
//   - While both are alive and within view of each other, each gets a presence buff: an alert icon,
//     on-apply/on-remove messages, and a recurring mood boost. Neither side gains stats.
//   - The knight gains the Empath read on their squire.
//   - When either dies, the survivor takes a mood hit. A 5-minute grace period prevents
//     a revive-die loop from re-triggering it.
/datum/action/cooldown/spell/takeprotege
	name = "Take Protégé"
	desc = "Designate a nearby Squire as your protégé. You will know how they feel, and their \
	presence at your side will lift your spirits. Should they fall, the loss will be a great burden. \
	You may only have one squire at a time; should they leave the round you may take another."
	button_icon = 'icons/mob/actions/actions_clockcult.dmi'
	button_icon_state = "eminence_rally"
	cast_range = 1
	primary_resource_cost = 0
	primary_resource_type = SPELL_COST_NONE
	cooldown_time = 30 SECONDS
	charge_required = TRUE
	charge_time = 3 SECONDS
	associated_skill = /datum/skill/misc/reading
	self_cast_possible = FALSE
	spell_requirements = SPELL_REQUIRES_SAME_Z
	antimagic_flags = NONE
	invocation_type = INVOCATION_EMOTE
	invocations = list("%CASTER takes on a protégé. May their bond be unbreakable.")
	invocation_self_message = "I take on a protégé. May our bond be unbreakable."


/datum/action/cooldown/spell/takeprotege/is_valid_target(atom/cast_on)
	if(!isliving(cast_on) || !ishuman(cast_on))
		return FALSE
	return TRUE

/datum/action/cooldown/spell/takeprotege/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/L = cast_on
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		reset_spell_cooldown()
		return FALSE
	if(H == L)
		to_chat(H, span_warning("You seriously tried to take yourself as a protégé?"))
		reset_spell_cooldown()
		return FALSE
	if(L.job != "Squire")
		to_chat(H, span_warning("I can only take a squire as my protégé."))
		reset_spell_cooldown()
		return FALSE

	// A despawned/dead/ghosted prior bond yields to a fresh cast.
	var/mob/living/carbon/human/existing_squire = H.get_squire()
	if(existing_squire)
		if(squire_bond_partner_despawned(existing_squire))
			squire_bond_break(H, existing_squire)
		else
			to_chat(H, span_warning("I already have a protégé."))
			reset_spell_cooldown()
			return FALSE

	var/mob/living/carbon/human/existing_lord = L.get_knight_lord()
	if(existing_lord)
		if(squire_bond_partner_despawned(existing_lord))
			squire_bond_break(existing_lord, L)
		else
			to_chat(H, span_warning("[L.name] already serves another knight."))
			reset_spell_cooldown()
			return FALSE

	if(alert(L, "[H.name] offers to take you as their protégé. They will have the read on you. Do you accept?", "Take Protégé", "I ACCEPT", "I REFUSE") == "I REFUSE")
		to_chat(H, span_warning("[L.name] has declined the bond."))
		reset_spell_cooldown()
		return FALSE

	H.set_squire(L)
	L.set_knight_lord(H)
	H.RegisterSignal(H, COMSIG_MOVABLE_MOVED, TYPE_PROC_REF(/mob/living/carbon/human, squire_bond_on_move), TRUE)
	L.RegisterSignal(L, COMSIG_MOVABLE_MOVED, TYPE_PROC_REF(/mob/living/carbon/human, squire_bond_on_move), TRUE)
	H.RegisterSignal(L, COMSIG_LIVING_DEATH, TYPE_PROC_REF(/mob/living/carbon/human, on_protege_death), TRUE)
	L.RegisterSignal(H, COMSIG_LIVING_DEATH, TYPE_PROC_REF(/mob/living/carbon/human, on_lord_death), TRUE)
	to_chat(H, span_nicegreen("[L.name] is now your protégé."))
	to_chat(L, span_nicegreen("[H.name] has taken you as their protégé."))
	if(squire_bond_buff_eligible(H, L))
		H.apply_status_effect(/datum/status_effect/buff/protege_ward)
		L.apply_status_effect(/datum/status_effect/buff/protege_vigilance)
	return TRUE


// Strict invalidity used by cast() — a knight whose squire has fully left the round (gibbed, dead,
// or ghosted/SSD) can take a new one. The move/death paths only QDELETED-check inline.
/proc/squire_bond_partner_despawned(mob/living/M)
	return QDELETED(M) || M.stat == DEAD || !M.client

// Both alive and squire in view of the knight.
/proc/squire_bond_buff_eligible(mob/living/carbon/human/knight, mob/living/carbon/human/squire)
	if(QDELETED(knight) || QDELETED(squire))
		return FALSE
	if(knight.stat == DEAD || squire.stat == DEAD)
		return FALSE
	if(!(knight in view(7, get_turf(squire))))
		return FALSE
	return TRUE

/proc/squire_bond_break(mob/living/knight, mob/living/squire)
	if(knight && !QDELETED(knight))
		if(squire && !QDELETED(squire))
			knight.UnregisterSignal(squire, COMSIG_LIVING_DEATH)
		knight.UnregisterSignal(knight, COMSIG_MOVABLE_MOVED)
		knight.set_squire(null)
		knight.remove_status_effect(/datum/status_effect/buff/protege_ward)
	if(squire && !QDELETED(squire))
		if(knight && !QDELETED(knight))
			squire.UnregisterSignal(knight, COMSIG_LIVING_DEATH)
		squire.UnregisterSignal(squire, COMSIG_MOVABLE_MOVED)
		squire.set_knight_lord(null)
		squire.remove_status_effect(/datum/status_effect/buff/protege_vigilance)

/mob/living/carbon/human/proc/squire_bond_on_move(atom/movable/source)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/partner
	var/mob/living/carbon/human/squire_mob
	var/mob/living/carbon/human/knight_mob
	if(get_squire())
		partner = get_squire()
		knight_mob = src
		squire_mob = partner
	else if(get_knight_lord())
		partner = get_knight_lord()
		knight_mob = partner
		squire_mob = src
	if(!partner)
		UnregisterSignal(src, COMSIG_MOVABLE_MOVED)
		return
	if(QDELETED(partner))
		squire_bond_break(knight_mob, squire_mob)
		return
	if(squire_bond_buff_eligible(knight_mob, squire_mob))
		knight_mob.apply_status_effect(/datum/status_effect/buff/protege_ward)
		squire_mob.apply_status_effect(/datum/status_effect/buff/protege_vigilance)

/mob/living/carbon/human/proc/on_protege_death(mob/living/source, gibbed)
	SIGNAL_HANDLER
	if(QDELETED(src))
		return
	// 5-minute grace period: a revive-die-revive-die loop within 5 min of the last death
	// counts as continuing trauma, not fresh trauma, so we skip the stack.
	var/datum/stressevent/existing = get_stress_event(/datum/stressevent/protege_dead)
	if(existing && (world.time - existing.time_added) < 5 MINUTES)
		return
	to_chat(src, span_userdanger("My protégé [source.name] has fallen!"))
	add_stress(/datum/stressevent/protege_dead)


/mob/living/carbon/human/proc/on_lord_death(mob/living/source, gibbed)
	SIGNAL_HANDLER
	if(QDELETED(src))
		return
	var/datum/stressevent/existing = get_stress_event(/datum/stressevent/protege_lord_dead)
	if(existing && (world.time - existing.time_added) < 5 MINUTES)
		return
	to_chat(src, span_userdanger("My knight [source.name] has fallen!"))
	add_stress(/datum/stressevent/protege_lord_dead)


/datum/stressevent/protege_dead
	stressadd = 20 //A squire is worth twice as much as a saiga
	timer = 30 MINUTES
	desc = span_boldred("My protégé has fallen. I have failed in my duty.")

/datum/stressevent/protege_lord_dead
	stressadd = 20
	timer = 30 MINUTES
	desc = span_boldred("My knight has fallen. I am abandoned and alone.")

/datum/stressevent/protege_nearby
	stressadd = -2
	timer = 5 MINUTES
	desc = span_green("My protégé hasn't met Necra yet. Great!")

/datum/stressevent/protege_lord_nearby
	stressadd = -2
	timer = 5 MINUTES
	desc = span_green("My knight walks beside me. I will not fail them.")



// Presence buff for the squire — active while in view of their bonded knight.
/datum/status_effect/buff/protege_vigilance
	id = "protege_vigilance"
	alert_type = /atom/movable/screen/alert/status_effect/buff/protege_vigilance
	duration = 2 MINUTES
	tick_interval = 30 SECONDS

/datum/status_effect/buff/protege_vigilance/tick()
	var/mob/living/carbon/human/knight = owner?.get_knight_lord()
	if(!knight || QDELETED(knight))
		qdel(src)
		return
	if(squire_bond_buff_eligible(knight, owner))
		refresh()
		owner.add_stress(/datum/stressevent/protege_lord_nearby)

/datum/status_effect/buff/protege_vigilance/on_apply()
	. = ..()
	to_chat(owner, span_blue("My knight stands with me. I will do them proud."))

/datum/status_effect/buff/protege_vigilance/on_remove()
	if(owner && !QDELETED(owner))
		to_chat(owner, span_warning("Without my knight near, my duty rings hollow."))
	. = ..()

/atom/movable/screen/alert/status_effect/buff/protege_vigilance
	name = "Dutiful Protégé"
	desc = "With hearty will, - for I will not rebel<br>\
			Against your lust, - a tale will I tell.<br>\
			Have me excused if I speak amiss;<br>\
			My will is good; and lo, my tale is this. (Mood buff while around your knight)"
	icon_state = "protege_buff"


// Presence buff for the knight — active while their bonded squire is in view.
/datum/status_effect/buff/protege_ward
	id = "protege_ward"
	alert_type = /atom/movable/screen/alert/status_effect/buff/protege_ward
	duration = 2 MINUTES
	tick_interval = 30 SECONDS

/datum/status_effect/buff/protege_ward/tick()
	var/mob/living/carbon/human/squire = owner?.get_squire()
	if(!squire || QDELETED(squire))
		qdel(src)
		return
	if(squire_bond_buff_eligible(owner, squire))
		refresh()
		owner.add_stress(/datum/stressevent/protege_nearby)

/datum/status_effect/buff/protege_ward/on_apply()
	. = ..()
	to_chat(owner, span_blue("My protégé walks at my side."))

/datum/status_effect/buff/protege_ward/on_remove()
	if(owner && !QDELETED(owner))
		to_chat(owner, span_warning("My protégé is no longer within sight."))
	. = ..()

/atom/movable/screen/alert/status_effect/buff/protege_ward
	name = "Knight's Ward"
	desc = "Listeth, lordes, in good entent,<br>\
			And I wol telle verrayment<br>\
			Of myrthe and of solas,<br>\
			In bataille and in tourneyment,<br>\
			His name was Sir Thopas. (Mood buff while around your protégé)"
	icon_state = "protege_buff"
