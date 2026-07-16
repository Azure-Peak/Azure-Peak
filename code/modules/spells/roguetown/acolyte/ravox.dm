/datum/action/cooldown/spell/ravox
	background_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	button_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	spell_color = GLOW_COLOR_RAVOX

	ignore_armor_penalty = TRUE

	attunement_school = null

	primary_resource_type = SPELL_COST_DEVOTION

	secondary_resource_type = SPELL_COST_STAMINA

	has_visual_effects = FALSE
	spell_impact_intensity = SPELL_IMPACT_NONE
	associated_stat = null
	associated_skill = /datum/skill/magic/holy
	spell_tier = 0

	point_cost = 0

	required_items = list(/obj/item/clothing/neck/roguetown/psicross/ravox, , /obj/item/clothing/neck/roguetown/psicross/undivided, /obj/item/clothing/neck/roguetown/psicross/silver/undivided)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// T0 - Tug of War- Chain a target to yourself and pull them in, prevents them from leaving your vicinity. //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/action/cooldown/spell/ravox/tug
	name = "Tug of War"
	desc = "Casts out a chain that tries to pull the target closer."
	fluff_desc = "One's worth is determined by weight of their soul in the afterlyfe, chains of sin pushing the scale downwards to inevitable pits of damnation."
	button_icon_state = "ravox_tug"
	sound = 'sound/magic/battletrance.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = FALSE

	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_cost = SPELLCOST_CANTRIP

	invocation_type = INVOCATION_SHOUT
	invocations = list("Feel the weight of your sins!")

	charge_required = TRUE
	charge_time = 1 SECONDS
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/holycharging.ogg'
	cooldown_time = 1 MINUTES

	spell_flags = SPELL_PSYDON
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/pull_distance = 1
	var/slowdown = 1

/datum/action/cooldown/spell/ravox/tug/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	var/mob/living/target = cast_on

	if(isliving(cast_on))
		if(spell_guard_check(target, TRUE))
			target.visible_message(span_warning("[target] holds firm against the pull!"))
			return TRUE
		var/chance = 0
		if(target.mob_biotypes & MOB_UNDEAD)
			pull_distance++
			chance += 20
		if(ishuman(target))
			var/strdiff = user.STASTR - target.STASTR
			var/enddiff = user.STAWIL - target.STAWIL
			var/condiff = user.STACON - target.STACON
			var/spddiff = user.STASPD - target.STASPD
			var/fordiff = user.STALUC - target.STALUC

			var/list/statdiffs = list(strdiff, enddiff, condiff, spddiff, fordiff)
			var/count = 0
			for(var/diff in statdiffs)
				if(diff > 0)
					chance += 10
					count++
				else if(diff < 0)
					chance -= 10
			var/holymod = owner.get_skill_level(/datum/skill/magic/holy) * 10
			pull_distance += floor((owner.get_skill_level(/datum/skill/magic/holy) - 1) / 2)	//+1 pull dist at Jman and Master Holy skill
			chance += holymod
			owner.visible_message(span_boldwarning("[owner] yanks on a transluscent chain sticking out of [target]!"))
			if(count > 3)	//More than half of the stats are in our favor.
				pull_distance++
				slowdown++
			if(prob(chance))
				target.throw_at(owner, pull_distance, 1, target, FALSE)
				target.visible_message(span_warning("[target]'s body moves on its own!"))
				owner.Beam(target,icon_state="chain",time=5)
			else
				target.visible_message(span_warning("[target] holds firm!"))
			target.Slowdown(slowdown)
			return TRUE
		return FALSE
	return FALSE

///////////////////////////////////////////////////////////////////////////////////
// T0 - Provocation - Taunt nearby enemies into focusing you with their attacks. //
///////////////////////////////////////////////////////////////////////////////////

/datum/action/cooldown/spell/ravox/provocation
	name = "Provocation"
	desc = "Forces hostile creatures around to target you. Grants you CON and WIL based on your holy skill."
	button_icon_state = "provocation"
	sound = 'sound/magic/battletrance.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_cost = SPELLCOST_CANTRIP

	invocation_type = INVOCATION_SHOUT
	invocations = list("By Ravox, stand and face me!")

	charge_required = TRUE
	charge_time = 1 SECONDS
	hold_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/holycharging.ogg'
	cooldown_time = 1 MINUTES

	spell_flags = SPELL_PSYDON
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/ravox/provocation/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	if(!isliving(user))
		return FALSE
	var/checkgate = FALSE
	var/skill = user.get_skill_level(/datum/skill/magic/holy)
	var/dist = (3 + skill)
	for(var/mob/living/mob in view(dist, get_turf(user)))
		if(!mob.mind && mob.ai_controller)
			mob.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, user)
			mob.ai_controller.set_blackboard_key(BB_HIGHEST_THREAT_MOB, user)
			var/datum/component/ai_aggro_system/aggro = mob.GetComponent(/datum/component/ai_aggro_system)
			if(aggro)
				aggro.add_threat_to_mob(user, 50)
			checkgate = TRUE
	if(checkgate == TRUE)
		user.apply_status_effect(/datum/status_effect/buff/ravox_provocation, skill)
	return TRUE

/atom/movable/screen/alert/status_effect/buff/ravox_provocation
	name = "Provocation"
	desc = "All hostile creatures are targeting me! For Ravox!"
	icon_state = "provocation"

/datum/status_effect/buff/ravox_provocation
	id = "ravox_provocation"
	alert_type = /atom/movable/screen/alert/status_effect/buff/ravox_provocation
	duration = 15 SECONDS

/datum/status_effect/buff/ravox_provocation/on_creation(mob/living/new_owner, assocskill)
	var/con_bonus = 0
	if(assocskill)
		if(assocskill == 1)
			duration = duration
		else
			duration *= assocskill-1
		con_bonus = assocskill-1
	if(con_bonus > 0)
		effectedstats = list(STATKEY_CON = con_bonus, STATKEY_WIL = con_bonus)
	. = ..()

/datum/status_effect/buff/ravox_prv/on_apply(assocskill)
	to_chat(owner, span_info("For Ravox!"))
	. = ..()


/////////////////////////////////
// T1 - Ravox Miracle Selector //
/////////////////////////////////

/datum/action/cooldown/spell/ravox/strikeoraegis
	name = "Tools of Justice"
	desc = "Choose between Justicar's Judgement (Divine Strike) or Justicar's Aegis (Shield)."
	fluff_desc = "The first gift to men, a sliver of Her radiance at fingertips of those devoted to Her wae of lyfe. Some sae it was Matthios who forced Astrata's hand in relinquishing such force to lowly mortals."
	button_icon_state = "judgement_aegis"

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_ADJACENT

	primary_resource_cost = SPELLCOST_MIRACLE_MINOR

	secondary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocation_type = INVOCATION_NONE //It has seperate message ON USE

	charge_required = FALSE
	cooldown_time = 10 SECONDS//Does not matter it's single use

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/chosen_spell
	var/ravox_strike = /datum/action/cooldown/spell/ravox/judgement
	var/ravox_aegis = /datum/action/cooldown/spell/ravox/aegis
	var/choosingspell = FALSE

/datum/action/cooldown/spell/ravox/strikeoraegis/cast(atom/cast_on)
	. = ..()
	if(choosingspell == TRUE)
		to_chat(owner, span_warning("I'm already choosing a spell!"))
	else
		var/choice = chosen_spell
		choosingspell = TRUE
		if(!chosen_spell)
			choice = alert(owner, "Offense or Defense", "CHOOSE YOUR TOOL", "Judgement - Strike", "Aegis - Shield")
			chosen_spell = choice
		switch(choice)
			if("Judgement - Strike")
				owner.mind?.AddSpell(new ravox_strike, owner)
				owner.mind?.RemoveSpell(src.type)
			if("Aegis - Shield")
				owner.mind?.AddSpell(new ravox_aegis, owner)
				owner.mind?.RemoveSpell(src.type)
			else
				return FALSE

/////////////////////////////////////////////////
// T1 - Judgement - Slow down an enemy on hit. //
/////////////////////////////////////////////////

/datum/action/cooldown/spell/ravox/judgement
	name = "Judgement"
	desc = "Bless your next strike to slow the target."
	button_icon_state = "judgement"
	sound = 'sound/magic/battletrance.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_ADJACENT
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_cost = SPELLCOST_CANTRIP

	invocation_type = INVOCATION_SHOUT
	invocations = list("By Ravox, face judgement!")

	charge_required = FALSE
	cooldown_time = 1 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/ravox/judgement/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	if(!isliving(user))
		return FALSE
	user.apply_status_effect(/datum/status_effect/judgement, user.get_active_held_item())
	return TRUE

/atom/movable/screen/alert/status_effect/buff/judgement
	name = "Judgement"
	desc = "Your next attack slows your target and SPD."
	icon_state = "judgement"

/datum/status_effect/judgement
	id = "judgement"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 15 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/judgement
	on_remove_on_mob_delete = TRUE
	var/datum/weakref/buffed_item

/datum/status_effect/judgement/on_creation(mob/living/new_owner, obj/item/I)
	. = ..()
	if(!.)
		return
	if(istype(I) && !(I.item_flags & ABSTRACT))
		buffed_item = WEAKREF(I)
		if(!I.light_outer_range && I.light_system == STATIC_LIGHT)
			I.set_light(1)
		RegisterSignal(I, COMSIG_ITEM_AFTERATTACK, PROC_REF(item_afterattack))
	else
		RegisterSignal(owner, COMSIG_MOB_ATTACK_HAND, PROC_REF(hand_attack))

/datum/status_effect/judgement/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOB_ATTACK_HAND)
	if(buffed_item)
		var/obj/item/I = buffed_item.resolve()
		if(istype(I))
			I.set_light(0)
		UnregisterSignal(I, COMSIG_ITEM_AFTERATTACK)

/datum/status_effect/judgement/proc/item_afterattack(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(!isliving(target))
		return
	var/mob/living/living_target = target
	living_target.apply_status_effect(/datum/status_effect/debuff/judgement)
	living_target.visible_message(span_warning("The strike from [user]'s weapon causes [living_target] to go stiff!"), vision_distance = COMBAT_MESSAGE_RANGE)
	qdel(src)

/datum/status_effect/judgement/proc/hand_attack(datum/source, mob/living/carbon/human/M, mob/living/carbon/human/H, datum/martial_art/attacker_style)
	if(!istype(M))
		return
	if(!istype(H))
		return
	if(!istype(M.used_intent, INTENT_HARM))
		return
	H.apply_status_effect(/datum/status_effect/debuff/judgement)
	H.visible_message(span_warning("The strike from [M]'s fist causes [H] to go stiff!"), vision_distance = COMBAT_MESSAGE_RANGE)
	qdel(src)

/atom/movable/screen/alert/status_effect/debuff/judgement
	name = "Ravox's Burden"
	desc = "My arms and legs are restrained by divine chains!"
	icon_state = "restrained"

/datum/status_effect/debuff/judgement
	id = "judgement_debuff"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/judgement
	effectedstats = list(STATKEY_SPD = -2)
	duration = 30 SECONDS

/datum/status_effect/debuff/judgement/on_apply()
		. = ..()
		var/mob/living/carbon/C = owner
		C.add_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN, multiplicative_slowdown = 1.5)

/datum/status_effect/debuff/judgement/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN)

///////////////////////////////////////////////////////////
// T1 - Justicar's Aegis - Summon a shield for yourself. //
///////////////////////////////////////////////////////////

/datum/action/cooldown/spell/ravox/aegis
	name = "Justicar's Aegis"
	desc = "Conjure a Holy Aegis - a projected shield of divine energy designed to counter projectiles.\n\
	Less effective against deliberate melee strikes, but excellent against ranged attacks.\n\
	The shield vanishes when broken or when a new one is conjured."
	button_icon_state = "aegis"
	sound = 'sound/magic/whiteflame.ogg'
	glow_intensity = GLOW_INTENSITY_MEDIUM

	click_to_activate = TRUE
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_cost = SPELLCOST_CONJURE

	invocations = list("Ravox, grant me your bulwark!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 3 SECONDS
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 90 SECONDS

	ignore_armor_penalty = TRUE
	associated_stat = null
	associated_skill = /datum/skill/magic/holy
	spell_tier = 0
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/obj/item/rogueweapon/shield/ravox_aegis/conjured_shield

/datum/action/cooldown/spell/ravox/aegis/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(H.get_num_arms() <= 0)
		to_chat(H, span_warning("I don't have any usable hands!"))
		return FALSE

	// Destroy previous conjured shield
	if(conjured_shield && !QDELETED(conjured_shield))
		conjured_shield.visible_message(span_warning("[conjured_shield] flickers and fades away!"))
		qdel(conjured_shield)

	var/obj/item/rogueweapon/shield/ravox_aegis/S = new(H.drop_location())
	S.linked_spell = src
	S.AddComponent(/datum/component/conjured_item, null, TRUE, H, src)
	H.put_in_hands(S)
	conjured_shield = S
	H.visible_message("[H] conjures a shimmering shield of arcyne energy!")
	return TRUE

// The conjured shield item
/obj/item/rogueweapon/shield/ravox_aegis
	name = "justicar's aegis"
	desc = "A rare hunk of arcyne energy projected in front of the caster. Slower and more deliberate movement by blades and melee weapons easily pierce through to the squishy Magi behind."
	icon_state = "ravox_aegis"
	wdefense = 7
	coverage = 70
	max_integrity = 200
	force = 5
	unenchantable = TRUE
	anvilrepair = /datum/skill/magic/holy
	parrysound = list('sound/combat/parry/shield/magicshield (1).ogg', 'sound/combat/parry/shield/magicshield (2).ogg', 'sound/combat/parry/shield/magicshield (3).ogg')
	associated_skill = /datum/skill/magic/holy
	var/datum/action/cooldown/spell/ravox/aegis/linked_spell

/obj/item/rogueweapon/shield/ravox_aegis/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/shield/ravox_aegis/Destroy()
	if(linked_spell && linked_spell.conjured_shield == src)
		linked_spell.conjured_shield = null
	linked_spell = null
	return ..()

//////////////////////////////////////////////////////////////////////////////////////////////////
// T2 - Withstand - Based on skill provides varying degrees of stun immunity and force push up. //
//////////////////////////////////////////////////////////////////////////////////////////////////

/datum/action/cooldown/spell/ravox/withstand
	name = "Withstand"
	desc = "Regain balance and become immune to any form of stun for the next 10 seconds."
	button_icon_state = "withstand"
	sound = 'sound/magic/ravox_withstand.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_ADJACENT
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_cost = SPELLCOST_CANTRIP

	invocation_type = INVOCATION_SHOUT
	invocations = list("I stand, by Ravox!")

	charge_required = FALSE
	cooldown_time = 1 MINUTES

	check_flags = AB_CHECK_CONSCIOUS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/ravox/withstand/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	if(!isliving(user))
		return FALSE
	var/skill = user.get_skill_level(/datum/skill/magic/holy)
	user.apply_status_effect(/datum/status_effect/withstand)
	if(user.has_status_effect(/datum/status_effect/incapacitating/off_balanced))
		user.remove_status_effect(/datum/status_effect/incapacitating/off_balanced)
	if(skill >= 2)
		if(!(user.mobility_flags & MOBILITY_STAND))
			user.SetUnconscious(0)
			user.SetSleeping(0)
			user.SetParalyzed(0)
			user.SetImmobilized(0)
			user.SetStun(0)
			user.SetKnockdown(0)
			user.set_resting(FALSE)
	if(skill >= 3)
		user.apply_status_effect(/datum/status_effect/buff/order/onfeet)
	return TRUE

/atom/movable/screen/alert/status_effect/buff/withstand
	name = "Withstand"
	desc = "I hold fast for Ravox."
	icon_state = "withstand"

/datum/status_effect/withstand
	id = "withstand"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 10 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/withstand

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// T2 - Challenge - Teleport yourself and target into an ARENA for 3 minutes or until one of you dies. //
/////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/action/cooldown/spell/ravox/challenge
	name = "Challenge"
	desc = "Bring an opponent with you to Ravoxian Trial. Engage in 3 minute combat."
	button_icon_state = "ravoxchallenge"
	sound = 'sound/magic/battletrance.ogg'

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_AURA
	self_cast_possible = FALSE

	primary_resource_cost = SPELLCOST_MIRACLE_LEGENDARY

	secondary_resource_cost = SPELLCOST_UTILITY_BUFF

	invocation_type = INVOCATION_SHOUT
	invocations = list("By Ravox, I challenge you!!")

	charge_required = TRUE
	charge_time = 3 SECONDS
	hold_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/holycharging.ogg'
	cooldown_time = 10 MINUTES

	spell_flags = SPELL_PSYDON
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

GLOBAL_LIST_EMPTY(arenafolks) // we're just going to use a list and add to it. Since /entered doesnt work on teleported mobs.

/datum/action/cooldown/spell/ravox/challenge/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	if(!istype(user))
		return FALSE

	var/area/rogue/indoors/ravoxarena/thearena = GLOB.areas_by_type[/area/rogue/indoors/ravoxarena]
	var/turf/challengerspawnpoint
	var/turf/challengedspawnpoint
	var/arenacount = GLOB.arenafolks.len
	if(arenacount >= 2)
		to_chat(user, span_italics("The arena is not yet ready for the next trial! Wait your turn!"))
		return FALSE

	if(!isliving(cast_on))
		return FALSE

	var/mob/living/carbon/target = cast_on
	var/originalcmodeuser = user.cmode_music
	var/originalcmodetarget = target.cmode_music
	var/turf/storedchallengerturf = get_turf(user)
	var/turf/storedchallengedturf = get_turf(target)

	if(user.z != target.z)
		return FALSE
	if(target == user)
		return FALSE
	if(!target.mind)//We can't use it on mindless mobs
		to_chat(user, span_warning("[target] is not worthy of a duel!"))
		return FALSE
	if(
		(target.stat > CONSCIOUS) || \
		!(target.mobility_flags & MOBILITY_STAND) || \
		!(target.mobility_flags & MOBILITY_MOVE) || \
		(HAS_TRAIT(target, TRAIT_PACIFISM)) || \
		(target.handcuffed) || \
		(target.legcuffed)
	)
		to_chat(user, span_warning("[target] is in no shape to accept the duel!"))
		return FALSE

	if(spell_guard_check(target, TRUE))
		target.visible_message(span_warning("[target] stands firm, refusing the trial!"))
		return TRUE

	for(var/obj/structure/fluff/ravox/challenger/aflag in thearena)
		challengerspawnpoint = get_turf(aflag)
	for(var/obj/structure/fluff/ravox/challenged/bflag in thearena)
		challengedspawnpoint = get_turf(bflag)

	do_teleport(user, challengerspawnpoint)
	do_teleport(target, challengedspawnpoint)
	GLOB.arenafolks += user
	GLOB.arenafolks += target
	storedchallengerturf.visible_message((span_cult("[user] calls upon the Ravoxian rite of Trial! [target] and [user] are brought to Trial!")))

	new /obj/structure/fluff/ravox/challenger/recall(storedchallengerturf)
	new /obj/structure/fluff/ravox/challenged/recall(storedchallengedturf)

	to_chat(user, span_userdanger("THE TRIAL IS CALLED, IMPRESS US, PROSECUTOR!!"))
	to_chat(target, span_userdanger("A TRIAL OF RAVOX BEGINS. IMPRESS US, DEFENDANT!!"))

	user.cmode_change('sound/music/ravoxarena.ogg')
	target.cmode_change('sound/music/ravoxarena.ogg')

	addtimer(CALLBACK(user, GLOBAL_PROC_REF(do_teleport), user, storedchallengerturf), 3 MINUTES)
	addtimer(CALLBACK(target, GLOBAL_PROC_REF(do_teleport), target, storedchallengedturf), 3 MINUTES)
	addtimer(CALLBACK(user, TYPE_PROC_REF(/mob, cmode_change), originalcmodeuser), 3 MINUTES)
	addtimer(CALLBACK(target,TYPE_PROC_REF(/mob, cmode_change), originalcmodetarget), 3 MINUTES)
	addtimer(CALLBACK(thearena,TYPE_PROC_REF(/area/rogue/indoors/ravoxarena, cleanthearena), storedchallengedturf), 3 MINUTES) // shunt all items from the arena out onto the challenged spot.

	if(iscarbon(target))
		var/mob/living/carbon/human/spawnprotectiontarget = target
		addtimer(CALLBACK(spawnprotectiontarget,TYPE_PROC_REF(/mob/living/carbon/human, do_invisibility), 10 SECONDS), 3 MINUTES)

	return TRUE


/obj/structure/fluff/ravox
	icon = 'icons/roguetown/rav/obj/flags.dmi'
	density = FALSE
	anchored = TRUE
	blade_dulling = DULLING_BASHCHOP
	layer = BELOW_MOB_LAYER
	max_integrity = 0

/obj/structure/fluff/ravox/proc/spawnprotection()
	var/list/thrownatoms = list()
	var/atom/throwtarget
	var/distfromflag
	var/maxthrow = 6
	var/sparkle_path = /obj/effect/temp_visual/gravpush
	var/repulse_force = MOVE_FORCE_EXTREMELY_STRONG
	var/push_range = 3

	playsound(src, 'sound/magic/repulse.ogg', 80, TRUE)
	for(var/turf/T in view(push_range, src))
		new /obj/effect/temp_visual/kinetic_blast(T)
		for(var/atom/movable/AM in T)
			thrownatoms += AM

	for(var/am in thrownatoms)
		var/atom/movable/AM = am
		if(AM == src || AM.anchored)
			continue

		if(ismob(AM))
			var/mob/M = AM
			if(M.anti_magic_check())
				continue

		throwtarget = get_edge_target_turf(src, get_dir(src, get_step_away(AM, src)))
		distfromflag = get_dist(src, AM)
		if(distfromflag == 0)
			if(isliving(AM))
				var/mob/living/M = AM
				M.Paralyze(10)
				M.adjustBruteLoss(20)
				to_chat(M, "<span class='danger'>You're slammed into the floor by Ravox's strength!!</span>")
		else
			new sparkle_path(get_turf(AM), get_dir(src, AM)) //created sparkles will disappear on their own
			if(isliving(AM))
				var/mob/living/M = AM
				M.Paralyze(5)
				to_chat(M, "<span class='danger'>You're thrown back by Ravox's strength!!</span>")
			AM.safe_throw_at(throwtarget, ((CLAMP((maxthrow - (CLAMP(distfromflag - 2, 0, distfromflag))), 3, maxthrow))), 1,null, force = repulse_force)


/obj/structure/fluff/ravox/challenger
	name = "Flag of the challenger"
	desc = "Where the challenger will return after the trial is decided."
	icon_state = "ravoxchallenger"

/obj/structure/fluff/ravox/challenged
	name = "Flag of the challenged"
	desc = "Where the challenged will return after the trial is decided."
	icon_state = "ravoxchallenged"


/obj/structure/fluff/ravox/challenger/recall/Initialize()
	. = ..()
	addtimer(CALLBACK(src, GLOBAL_PROC_REF(qdel), src), 3 MINUTES)
	addtimer(CALLBACK(src,TYPE_PROC_REF(/obj/structure/fluff/ravox, spawnprotection)), 179 SECONDS)

/obj/structure/fluff/ravox/challenged/recall/Initialize()
	. = ..()
	addtimer(CALLBACK(src, GLOBAL_PROC_REF(qdel), src), 3 MINUTES)
	addtimer(CALLBACK(src,TYPE_PROC_REF(/obj/structure/fluff/ravox, spawnprotection)), 179 SECONDS)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// T3 - Persistence - Harms an undead mob/player while causing bleeding/pain wounds to clot at higher rate for living ones. //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/action/cooldown/spell/ravox/persistence
	name = "Persistence"
	desc = "Harms Undead and encourages the livings wounds to close faster."
	button_icon_state = "persistence"
	sound = 'sound/magic/persistence.ogg'

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_cost = SPELLCOST_UTILITY_BUFF

	invocation_type = INVOCATION_SHOUT
	invocations = list("Ravox deems your persistence worthy!")

	charge_required = FALSE
	cooldown_time = 30 SECONDS

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/ravox/persistence/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		return FALSE
	if(isliving(cast_on))
		var/mob/living/target = cast_on
		if(target.mob_biotypes & MOB_UNDEAD)
			if(spell_guard_check(target, TRUE))
				target.visible_message(span_warning("[target] resists Ravox's judgment!"))
				return TRUE
			if(ishuman(target)) //BLEED AND PAIN
				var/mob/living/carbon/human/human_target = target
				var/datum/physiology/phy = human_target.physiology
				phy.bleed_mod *= 1.5
				phy.pain_mod *= 1.5
				addtimer(CALLBACK(src, PROC_REF(restore_modifiers), phy), 19 SECONDS)
				human_target.visible_message(span_danger("[target]'s wounds become inflamed as their vitality is sapped away!"), span_userdanger("Ravox inflames my wounds and weakens my body!"))
				return TRUE
			return FALSE

		target.visible_message(span_info("Warmth radiates from [target] as their wounds seal over!"), span_notice("The pain from my wounds fade as warmth radiates from my soul!"))
		var/situational_bonus = 0.25
		for(var/obj/effect/decal/cleanable/blood/O in oview(5, target))
			situational_bonus = min(situational_bonus + 0.015, 1)
		if(situational_bonus > 0.25)
			to_chat(owner, "Channeling Ravox's power is easier in these conditions!")

		if(iscarbon(target))
			var/mob/living/carbon/C = target
			var/obj/item/bodypart/affecting = C.get_bodypart(check_zone(owner.zone_selected))
			if(affecting)
				for(var/datum/wound/bleeder in affecting.wounds)
					bleeder.woundpain = max(bleeder.sewn_woundpain, bleeder.woundpain * 0.25)
					if(!isnull(bleeder.clotting_threshold) && bleeder.bleed_rate > bleeder.clotting_threshold)
						var/difference = bleeder.bleed_rate - bleeder.clotting_threshold
						bleeder.set_bleed_rate(max(bleeder.clotting_threshold, bleeder.bleed_rate - difference * situational_bonus))
		else if(HAS_TRAIT(target, TRAIT_SIMPLE_WOUNDS))
			for(var/datum/wound/bleeder in target.simple_wounds)
				bleeder.woundpain = max(bleeder.sewn_woundpain, bleeder.woundpain * 0.25)
				if(!isnull(bleeder.clotting_threshold) && bleeder.bleed_rate > bleeder.clotting_threshold)
					var/difference = bleeder.bleed_rate - bleeder.clotting_threshold
					bleeder.set_bleed_rate(max(bleeder.clotting_threshold, bleeder.bleed_rate - difference * situational_bonus))
		return TRUE
	return FALSE

/datum/action/cooldown/spell/ravox/persistence/proc/restore_modifiers(datum/physiology/physiology)
	if(!physiology)
		return

	physiology.bleed_mod /= 1.5
	physiology.pain_mod /= 1.5

///////////////////////////////////////////////////////////////////////////////////////////////////
// T3 - Call to Arms - Warcry that provides buff to DIVINE worshippers and debuff to ASCENDANTS. //
///////////////////////////////////////////////////////////////////////////////////////////////////

/datum/action/cooldown/spell/ravox/battlecry
	name = "Call to Arms"
	desc = "Grants you and all allies nearby a buff to their strength, willpower, and constitution while taking away willpower and constitution from ascendant worshippers."
	fluff_desc = "A yell rings out across the battlefield! Your sergeant bellows a final order before they're claimed by Necra's grasp - leave none standing before the might of Ravox! So long as you draw breath, there shall be no defeat."
	button_icon_state = "call_to_arms"
	sound = 'sound/magic/battle_cry.ogg'

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_AURA

	primary_resource_cost = SPELLCOST_MIRACLE_MAJOR - 10

	secondary_resource_cost = SPELLCOST_UTILITY_BUFF

	invocation_type = INVOCATION_SHOUT
	invocations = list("By Ravox, stand and fight!")

	charge_required = FALSE
	cooldown_time = 5 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/ravox/battlecry/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	for(var/mob/living/carbon/target in view(cast_range, get_turf(owner)))
		if(istype(target.patron, /datum/patron/inhumen))
			target.apply_status_effect(/datum/status_effect/debuff/call_to_arms)	//Debuffs inhumen worshipers.
			continue
		if(istype(target.patron, /datum/patron/old_god))
			to_chat(target, span_danger("You feel a hot-wave wash over you, leaving as quickly as it came.."))	//No effect on Psydonians!
			continue
		if(!owner.faction_check_mob(target))
			continue
		if(target.mob_biotypes & MOB_UNDEAD)
			continue
		target.apply_status_effect(/datum/status_effect/buff/call_to_arms)
	return TRUE

/datum/status_effect/buff/call_to_arms
	id = "call_to_arms"
	alert_type = /atom/movable/screen/alert/status_effect/buff/call_to_arms
	duration = 3 MINUTES
	effectedstats = list(STATKEY_STR = 1, STATKEY_WIL = 2, STATKEY_CON = 2)

/atom/movable/screen/alert/status_effect/buff/call_to_arms
	name = "Call to Arms"
	desc = span_bloody("FOR GLORY AND HONOR!")
	icon_state = "call_to_arms"

/datum/status_effect/debuff/call_to_arms
	id = "call_to_arms"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/call_to_arms
	effectedstats = list(STATKEY_WIL = -2, STATKEY_CON = -2)
	duration = 3 MINUTES

/atom/movable/screen/alert/status_effect/debuff/call_to_arms
	name = "Ravox's Call to Arms"
	desc = "His voice keeps ringing in your ears, rocking your soul.."
	icon_state = "call_to_arms_negative"
