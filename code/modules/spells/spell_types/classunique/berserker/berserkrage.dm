#define RAGE_FILTER "rage_aura"
#define RAGE_NPC_REACH 2
#define RAGE_NPC_HURT_SCORE 40
#define RAGE_NPC_TIER_BONUS 15
#define RAGE_NPC_FATIGUE_RATIO 0.6
#define RAGE_NPC_FATIGUE_BONUS 20
#define RAGE_NPC_MOBBED_COUNT 2
#define RAGE_NPC_MOBBED_SCORE 35

/proc/get_buff_value(mob/living/L)
	var/brute = L.getBruteLoss()
	var/burn = L.getFireLoss()
	var/ragedmgbuff = 0
	if(!HAS_TRAIT (L, TRAIT_RAGE)) //anyone without the trait is locked to small rage
		return 0
	if(brute + burn > 10) //early trigger, basically if you take PEN attacks
		ragedmgbuff = 1
	if(brute + burn > 75) //fight's been going on for a while, probably took some hits
		ragedmgbuff = 2
	if(brute + burn > 160) //getting close to being crit
		ragedmgbuff = 3
	return ragedmgbuff

/datum/action/cooldown/spell/rage
	source_aspect = /datum/magic_aspect/pseudo/berserker
	name = "RAGE"
	desc = "GETTING HURT MAKES YOU ANGRY, MAKE THEM HURT BACK- MORE HURT IS MORE ANGRY!"
	button_icon_state = "bcry"
	sound = null
	has_visual_effects = FALSE
	associated_skill = null

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_NONE
	primary_resource_cost = 0

	charge_required = FALSE
	cooldown_time = 1 MINUTES

	invocation_type = INVOCATION_EMOTE
	invocations = list("%CASTER enters a state of furious rage!")

	check_flags = AB_CHECK_CONSCIOUS
	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_CASTABLE_WITHOUT_INVOCATION

	npc_max_range = RAGE_NPC_REACH
	npc_escape = TRUE

/datum/action/cooldown/spell/rage/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	if(!ishuman(user))
		return FALSE
	user.apply_status_effect(/datum/status_effect/buff/rage)
	var/rage_tier = get_buff_value(user)
	if(rage_tier >= 1)
		user.apply_status_effect(/datum/status_effect/buff/adrenaline_rush)
	if(rage_tier >= 2)
		user.apply_status_effect(/datum/status_effect/buff/rage_stamina)
	if(rage_tier >= 3)
		user.apply_status_effect(/datum/status_effect/buff/berserk_rush)
	return TRUE

/datum/action/cooldown/spell/rage/npc_cast_target(atom/target)
	return owner

/datum/action/cooldown/spell/rage/npc_use_chance(atom/target)
	var/mob/living/carbon/human/user = owner
	if(!istype(user) || user.has_status_effect(/datum/status_effect/buff/rage))
		return 0
	. = 0
	var/rage_tier = get_buff_value(user)
	if(rage_tier >= 1)
		. = RAGE_NPC_HURT_SCORE + RAGE_NPC_TIER_BONUS * (rage_tier - 1)
		if(user.max_stamina > 0 && user.stamina >= user.max_stamina * RAGE_NPC_FATIGUE_RATIO)
			. += RAGE_NPC_FATIGUE_BONUS
	if(npc_hostiles_in(npc_turfs_around(get_turf(user), 1)) >= RAGE_NPC_MOBBED_COUNT)
		. = max(., RAGE_NPC_MOBBED_SCORE)

/atom/movable/screen/alert/status_effect/buff/rage
	name = "RAGE"
	desc = "YOU'RE MAKING ME ANGRY!"
	icon_state = "buff"

/datum/status_effect/buff/rage
	id = "rage"
	examine_text = "<font color='red'>SUBJECTPRONOUN is frothing at the mouth!</font>"
	alert_type = /atom/movable/screen/alert/status_effect/buff/rage
	effectedstats = list(STATKEY_STR = 2) //higher base, less boring stat scaling
	duration = 45 SECONDS
	var/ragebuff = 0
	var/outline_colour = "#ca0000"

/datum/status_effect/buff/rage/on_apply()
	. = ..()
	if(.)
		var/filter = owner.get_filter(RAGE_FILTER)
		if(!filter)
			owner.add_filter(RAGE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 120, "size" = 1))
		owner.emote("rage", forced = TRUE)
		to_chat(owner, span_notice("PAIN FUELS MY RAGE, MY BODY IS READY TO FIGHT!"))
		playsound(owner, 'sound/combat/hits/burn (2).ogg', 100, TRUE)

/datum/status_effect/buff/rage/on_remove()
	. = ..()
	owner.remove_filter(RAGE_FILTER)
	to_chat(owner, span_warning("Rage subsides."))

/atom/movable/screen/alert/status_effect/buff/rage_stamina
	name = "RAAADRENALINE"
	desc = "THE ANGER DRAINS MY FATIGUE!"
	icon_state = "buff"

/datum/status_effect/buff/rage_stamina
	id = "rage stamina"
	alert_type = /atom/movable/screen/alert/status_effect/buff/rage_stamina
	duration = 15 SECONDS
	var/healing_on_tick = 5

/datum/status_effect/buff/rage_stamina/tick()
	if(HAS_TRAIT(owner, TRAIT_IRONMAN))
		return
	var/stamheal = healing_on_tick
	owner.energy_add(stamheal)

/datum/status_effect/buff/berserk_rush
	id = "berserk rush"
	alert_type = /atom/movable/screen/alert/status_effect/buff/berserk_rush
	effectedstats = list(STATKEY_CON = 2)
	duration = 45 SECONDS

/atom/movable/screen/alert/status_effect/buff/berserk_rush
	name = "THERE'S NO STOPPING ME!"
	desc = "DON'T STOP ME NOW, I AM HAVING SUCH A GOOD TIME!"
	icon_state = "buff"

/datum/status_effect/buff/berserk_rush/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_HARDDISMEMBER, INNATE_TRAIT) //limbs still get disabled by damage

/datum/status_effect/buff/berserk_rush/on_remove()
	. = ..()
	clear_berserk_rush()

/datum/status_effect/buff/berserk_rush/proc/clear_berserk_rush()
	REMOVE_TRAIT(owner, TRAIT_HARDDISMEMBER, INNATE_TRAIT)

#undef RAGE_FILTER
#undef RAGE_NPC_REACH
#undef RAGE_NPC_HURT_SCORE
#undef RAGE_NPC_TIER_BONUS
#undef RAGE_NPC_FATIGUE_RATIO
#undef RAGE_NPC_FATIGUE_BONUS
#undef RAGE_NPC_MOBBED_COUNT
#undef RAGE_NPC_MOBBED_SCORE
