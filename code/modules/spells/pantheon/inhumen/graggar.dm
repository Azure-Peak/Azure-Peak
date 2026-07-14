/datum/action/cooldown/spell/graggar
	background_icon = 'icons/mob/actions/graggarmiracles.dmi'
	button_icon = 'icons/mob/actions/graggarmiracles.dmi'
	spell_color = GLOW_COLOR_GRAGGAR

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

	spell_flags = SPELL_PSYDON //You are not immune to the propaganda.
	required_items = list(/obj/item/clothing/neck/roguetown/psicross)

/////////////////////
// T0 - Blood Rush //
/////////////////////

/datum/action/cooldown/spell/graggar/rush
	name = "Blood Rush"
	desc = "Undergo an adrenaline rush to restore stamina and become tougher to kill. With increased miracle skill (Journeyman) gain ability to snap out of any restraints and (Master) become immune to grabs and pain for 30 seconds."
	fluff_desc = "Tales of untamable wyldmen slaughtering their would-be captors are numerous, to most a mere legend - to any slaver a follower of the Sinistar is their worst nightmare."
	button_icon_state = "bloodrage"
	sound = 'sound/magic/graggar_bloodrush.ogg'

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_ADJACENT
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE + 10

	secondary_resource_cost = SPELLCOST_CANTRIP

	invocation_type = INVOCATION_SHOUT
	invocations = list("Shatter my binds!")

	charge_required = FALSE
	cooldown_time = 2 MINUTES

	check_flags = AB_CHECK_CONSCIOUS
	spell_requirements =  SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/graggar/rush/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	if(!isliving(user))
		return FALSE
	var/skill = user.get_skill_level(/datum/skill/magic/holy)
	user.apply_status_effect(/datum/status_effect/buff/adrenaline_rush/graggar)
	if(skill >= 3)
		if(user.handcuffed || user.legcuffed)
			user.visible_message(span_danger("[user]'s restraints loosen under inhumen pressure!"))
			user.uncuff()
	if(skill >= 5)
		user.apply_status_effect(/datum/status_effect/buff/unholy_rage)
	return TRUE

/datum/status_effect/buff/unholy_rage
	id = "unholy_rage"
	alert_type = /atom/movable/screen/alert/status_effect/buff/unholy_rage
	duration = 30 SECONDS

/atom/movable/screen/alert/status_effect/buff/unholy_rage
	name = "Boiling Blood"
	desc = "My blood is boiling with rage!"
	icon_state = "buff"

/datum/status_effect/buff/unholy_rage/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_GRABIMMUNE, TRAIT_MIRACLE)
	ADD_TRAIT(owner, TRAIT_NOPAIN, TRAIT_MIRACLE)

/datum/status_effect/buff/unholy_rage/on_remove()
	REMOVE_TRAIT(owner, TRAIT_GRABIMMUNE, TRAIT_MIRACLE)
	REMOVE_TRAIT(owner, TRAIT_NOPAIN, TRAIT_MIRACLE)
	. = ..()

///////////////////////////////////////////////////////////////////////////////////////////
// T1 - Hamstring - This will get reworked alongside Ravox later so more so temporary T1 //
///////////////////////////////////////////////////////////////////////////////////////////

/datum/action/cooldown/spell/graggar/hamstring
	name = "Hamstring"
	desc = "Curse your next strike to slow the target."
	fluff_desc = "Escape is a luxury in face of a beast."
	button_icon_state = "hamstring"
	sound = 'sound/magic/bloodrage.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_ADJACENT
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_cost = SPELLCOST_CANTRIP

	invocation_type = INVOCATION_SHOUT
	invocations = list("Heel, mutt!")

	charge_required = FALSE
	cooldown_time = 1 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/graggar/hamstring/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	if(!isliving(user))
		return FALSE
	user.apply_status_effect(/datum/status_effect/hamstring, user.get_active_held_item())
	return TRUE

/atom/movable/screen/alert/status_effect/buff/hamstring
	name = "Hamstring"
	desc = "Your next attack slows your target and SPD."
	icon_state = "hamstring"

/datum/status_effect/hamstring
	id = "hamstring"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 15 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/hamstring
	on_remove_on_mob_delete = TRUE
	var/datum/weakref/buffed_item

/datum/status_effect/hamstring/on_creation(mob/living/new_owner, obj/item/I)
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

/datum/status_effect/hamstring/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOB_ATTACK_HAND)
	if(buffed_item)
		var/obj/item/I = buffed_item.resolve()
		if(istype(I))
			I.set_light(0)
		UnregisterSignal(I, COMSIG_ITEM_AFTERATTACK)

/datum/status_effect/hamstring/proc/item_afterattack(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(!isliving(target))
		return
	var/mob/living/living_target = target
	living_target.apply_status_effect(/datum/status_effect/debuff/hamstring)
	living_target.visible_message(span_warning("The strike from [user]'s weapon causes [living_target] to go stiff!"), vision_distance = COMBAT_MESSAGE_RANGE)
	qdel(src)

/datum/status_effect/hamstring/proc/hand_attack(datum/source, mob/living/carbon/human/M, mob/living/carbon/human/H, datum/martial_art/attacker_style)
	if(!istype(M))
		return
	if(!istype(H))
		return
	if(!istype(M.used_intent, INTENT_HARM))
		return
	H.apply_status_effect(/datum/status_effect/debuff/hamstring)
	H.visible_message(span_warning("The strike from [M]'s fist causes [H] to go stiff!"), vision_distance = COMBAT_MESSAGE_RANGE)
	qdel(src)

/atom/movable/screen/alert/status_effect/debuff/hamstring
	name = "Graggar's Burden"
	desc = "My arms and legs are restrained by unholy force!"
	icon_state = "restrained"

/datum/status_effect/debuff/hamstring
	id = "hamstring_debuff"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/hamstring
	effectedstats = list(STATKEY_SPD = -2)
	duration = 30 SECONDS

/datum/status_effect/debuff/hamstring/on_apply()
		. = ..()
		var/mob/living/carbon/C = owner
		C.add_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN, multiplicative_slowdown = 1.5)

/datum/status_effect/debuff/hamstring/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN)

///////////////////////////////
// T2 - Vicious Entanglement //
///////////////////////////////

/datum/action/cooldown/spell/projectile/graggar_net
	name = "Vicious Entanglement"
	desc = "Unleashes a snare of external blood and guts. The viscera winds around the legs of mortals... \
	Though has little effect on simple creatures. Mortals cannot remove the net, but it decays ten seconds after landing."
	background_icon = 'icons/mob/actions/graggarmiracles.dmi'
	button_icon = 'icons/mob/actions/graggarmiracles.dmi'
	sound = 'sound/magic/blood_net.ogg'
	button_icon_state = "graggarnet"
	spell_color = GLOW_COLOR_GRAGGAR
	glow_intensity = GLOW_INTENSITY_LOW

	projectile_type = /obj/projectile/magic/unholy_grasp
	cast_range = 7

	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE
	invocation_type = INVOCATION_SHOUT
	invocations = list("Be still!")

	charge_required = TRUE
	weapon_cast_penalized = FALSE
	charge_time = CHARGETIME_POKE
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/chargingold.ogg'
	cooldown_time = 1 MINUTES

	associated_stat = null
	associated_skill = /datum/skill/magic/holy
	spell_requirements = SPELL_REQUIRES_HUMAN

	ignore_armor_penalty = TRUE
	attunement_school = null

	spell_tier = 0
	point_cost = 0

	required_items = list(/obj/item/clothing/neck/roguetown/psicross)

/datum/action/cooldown/spell/projectile/graggar_net/cast(atom/cast_on)
	var/mob/living/carbon/human/H = owner
	if(!ishuman(H))
		return
	. = ..()

// ---- Projectile ----

/obj/projectile/magic/unholy_grasp
	name = "visceral organ net"
	icon_state = "tentacle_end"
	nodamage = TRUE
	range = 7
	speed = 1.6
	hitsound = 'sound/magic/slimesquish.ogg'
	guard_deflectable = TRUE

/obj/projectile/magic/unholy_grasp/on_hit(target)
	. = ..()
	if(!iscarbon(target))
		return
	if(out_of_effective_range())
		return
	if(target)
		ensnare(target)

/obj/projectile/magic/unholy_grasp/proc/ensnare(mob/living/carbon/carbon)
	carbon.visible_message(span_warning("[src] ensnares [carbon] around their legs in a horrid cacophany of blood and guts!"), span_warning("I AM ENCAPTURED BY BLOOD AND GUTS! THERES A NET ON MY LEGS!"))
	carbon.apply_status_effect(/datum/status_effect/debuff/netted/vile)
	playsound(src, 'sound/combat/caught.ogg', 20, TRUE)

////////////////////////////
// T2 - Call to Slaughter //
////////////////////////////

/datum/action/cooldown/spell/graggar/graggar_battlecry
	name = "Vicious Roar"
	desc = "Grants you and all allies nearby a buff to their strength, willpower, and constitution. Debuffs followers of the Ten, but not Psydonites."
	fluff_desc = "The battlefield quakes with your roar! Shaken to their core, they will prove easy pickings for a worthy champion such as yourself; the power of the Sinistar, unleashed.\
	SLAUGHTER THE LAMBS - DRINK THEIR MARROW - FEAST UPON THEIR FLESH - LEAVE NO TRACE OF THEIR PATHETIC EXISTENCE! - THE SINISTAR HUNGERS!"
	button_icon_state = "vicious_roar"
	sound = 'sound/magic/battle_cry_graggar.ogg'
	glow_intensity = 0

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_AURA

	primary_resource_cost = SPELLCOST_MIRACLE_MAJOR

	secondary_resource_cost = SPELLCOST_UTILITY_BUFF

	invocations = list("Kneel before the might of the Sinistar!")
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 5 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/graggar/graggar_battlecry/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	for(var/mob/living/carbon/target in view(cast_range, get_turf(owner)))
		if(istype(target.patron, /datum/patron/inhumen))
			target.apply_status_effect(/datum/status_effect/buff/call_to_slaughter)	//Buffs inhumens
			continue
		if(istype(target.patron, /datum/patron/old_god))
			to_chat(target, span_danger("You feel a surge of cold wash over you; leaving your body as quick as it hit.."))	//No effect on Psydonians!
			continue
		if(!owner.faction_check_mob(target))
			continue
		if(target.mob_biotypes & MOB_UNDEAD)
			continue
		target.apply_status_effect(/datum/status_effect/debuff/call_to_slaughter)	//Debuffs non-inhumens/psydonians
	return TRUE

/atom/movable/screen/alert/status_effect/buff/call_to_slaughter
	name = "Vicious Roar"
	desc = span_bloody("LAMBS TO THE SLAUGHTER!")
	icon_state = "call_to_slaughter"

/datum/status_effect/buff/call_to_slaughter
	id = "call_to_slaughter"
	alert_type = /atom/movable/screen/alert/status_effect/buff/call_to_slaughter
	duration = 2.5 MINUTES
	effectedstats = list(STATKEY_STR = 1, STATKEY_WIL = 2, STATKEY_CON = 1)

/datum/status_effect/buff/call_to_slaughter/on_remove()
	. = ..()

/atom/movable/screen/alert/status_effect/debuff/call_to_slaughter
	name = "Vicious Roar"
	desc = "Your blood runs cold, teeth clatter with fear - this is to be your end."
	icon_state = "call_to_slaughter_negative"

/datum/status_effect/debuff/call_to_slaughter
	id = "call_to_slaughter"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/call_to_slaughter
	effectedstats = list(STATKEY_WIL = -2, STATKEY_CON = -2)
	duration = 2.5 MINUTES

//////////////////////////
// T3 - Exsanguinate	//
//////////////////////////

/datum/action/cooldown/spell/graggar/exsanguinate
	name = "Exsanguinate"
	desc = "Increases the bleeding and pain of a target. Their blood-loss amount scales with every point of constitution over ten. \
	Those with ten or less CONSTITUTION will instead have a flat rate (x1.25)."
	button_icon_state = "bloodsteal"
	sound = 'sound/magic/bleed_out.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_AURA
	self_cast_possible = FALSE

	primary_resource_cost = SPELLCOST_MIRACLE_MAJOR + 20

	secondary_resource_cost = SPELLCOST_UTILITY_BUFF

	invocations = list("Bleed for your God!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_sound = 'sound/magic/chargingold.ogg'
	cooldown_time = 2 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/graggar/exsanguinate/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/mob/living/spelltarget = cast_on

	if(!isliving(spelltarget))
		to_chat(owner, span_warning("There is nothing to BLEED."))
		return FALSE
	else
		spelltarget.visible_message("<font color='bloody'>My lyfeblood flows away!</font>")
		if(spelltarget.anti_magic_check(TRUE, TRUE))
			return FALSE
		if(spell_guard_check(spelltarget, TRUE))
			spelltarget.visible_message(span_warning("[spelltarget] shields against the unholy power!"))
			return TRUE
		spelltarget.apply_status_effect(/datum/status_effect/debuff/bloody_mess)
		spelltarget.apply_status_effect(/datum/status_effect/debuff/sensitive_nerves)
		log_combat(owner, spelltarget, "exsanguinated", addition="with the miracle [name]")
		return TRUE

//////////////////////////
// T4 - Avatar of Rage	//
//////////////////////////

/datum/action/cooldown/spell/graggar/avatar
	name = "Avatar of Rage"
	desc = "Unleash your true rage for an entire MINUTE, making you immune to slowdown from pain, uncapping strength and granting +3 on top. Removes stun-adjacent & stun effects which is only part that works on a GNOLL"
	button_icon_state = "avatar"
	sound = 'sound/magic/graggar_rage.ogg'
	glow_intensity = GLOW_INTENSITY_MEDIUM

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_ADJACENT
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE_LEGENDARY

	secondary_resource_cost = SPELLCOST_CANTRIP

	invocation_type = INVOCATION_SHOUT
	invocations = list("I will tear you apart!")

	charge_required = TRUE
	charge_slowdown = 2
	charge_time = 2 SECONDS
	cooldown_time = 6 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/static/list/purged_effects = list(
	/datum/status_effect/incapacitating/immobilized,
	/datum/status_effect/incapacitating/paralyzed,
	/datum/status_effect/incapacitating/stun,
	/datum/status_effect/incapacitating/knockdown
	)

/datum/action/cooldown/spell/graggar/avatar/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	if(!isliving(user))
		return FALSE
	for(var/effect in purged_effects)
		user.remove_status_effect(effect)
	if(!isgnoll(user))//Gnolls don't get this
		user.apply_status_effect(/datum/status_effect/buff/bloodrage)
		user.emote("warcry")
	return TRUE

#define BLOODRAGE_FILTER "bloodrage"

/atom/movable/screen/alert/status_effect/buff/graggar_bloodrage
	name = "BLOODRAGE"
	desc = "GRAGGAR! GRAGGAR! GRAGGAR!"
	icon_state = "bloodrage"

/datum/status_effect/buff/bloodrage
	id = "bloodrage"
	alert_type = /atom/movable/screen/alert/status_effect/buff/graggar_bloodrage
	var/outline_color = GLOW_COLOR_GRAGGAR
	duration = 1 MINUTES
	effectedstats = list(STATKEY_STR = 3)

/datum/status_effect/buff/bloodrage/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, TRAIT_MIRACLE)
	ADD_TRAIT(owner, TRAIT_NOPAINSTUN, TRAIT_MIRACLE)
	shake_camera(owner, 5, 2) //Aura
	to_chat(owner, span_userdanger(pick("KILL, FUCKING KILL! SLAUGHTER THEM!", "BLOOD, FUCKING SPILL THE BLOOD!", "BLOOD AND FURY, SPLITTING MY SKULL!", "I'LL KILL ANYTHING THAT MOVES!", "I'M FUCKING UNSTOPPABLE, I'LL BREAK THEM!")))
	var/filter = owner.get_filter(BLOODRAGE_FILTER)
	if(!filter)
		owner.add_filter(BLOODRAGE_FILTER, 2, list("type" = "outline", "color" = outline_color, "alpha" = 60, "size" = 2))
	return TRUE

/datum/status_effect/buff/bloodrage/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, TRAIT_MIRACLE)
	REMOVE_TRAIT(owner, TRAIT_NOPAINSTUN, TRAIT_MIRACLE)
	owner.visible_message(span_warning("[owner] wavers, their rage simmering down."))
	owner.OffBalance(3 SECONDS)
	owner.remove_filter(BLOODRAGE_FILTER)
	owner.emote("breathgasp", forced = TRUE)
	owner.Slowdown(3)

#undef BLOODRAGE_FILTER
