#define MOCKERY_STACKS_MAX 2
#define MOCKERY_STACK_DURATION 30 SECONDS
#define MOCKERY_STAT_PER_STACK -1 // Each stack applies this to STR, SPD, INT, WIL
#define MOCKERY_COOLDOWN 20 SECONDS

GLOBAL_LIST_INIT(mockery_insults, list(
	"Is that truly the best you can do?",
	"My grandmother fights better than you!",
	"I've seen training dummies put up a better fight!",
	"Was that supposed to hurt? I've had worse from a lute string!",
	"You fight like a dairy farmer!",
	"I bite mine thumb at thee, ser!",
	"Even your shadow is embarrassed by you!",
	"You swing like a tavern drunk on his last ale!",
	"Your mother was a Rous, and your father smelled of jacksberries!",
	"What are you going to do for a face when the Archdevil wants his arse back?!",
	"You may need a smith - for you seem ill-equipped for a battle of wits!",
	"How much sparring did it take to become this awful?!",
	"Need you borrow mine spectacles? Come get them!",
))

// ---- Vicious Mockery Projectile Spell ----

/datum/action/cooldown/spell/projectile/vicious_mockery
	name = "Vicious Mockery"
	desc = "Hurl a musical insult at your target. Stacks up to 2 times, increasingly reducing their stats."
	button_icon = 'icons/mob/actions/xylixmiracles.dmi'
	button_icon_state = "mockery"
	spell_color = GLOW_COLOR_BARDIC
	glow_intensity = GLOW_INTENSITY_LOW

	projectile_type = /obj/projectile/magic/mockery_note
	cast_range = 7

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocation_type = INVOCATION_SHOUT
	charge_required = TRUE
	charge_time = CHARGETIME_POKE
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	cooldown_time = MOCKERY_COOLDOWN

	associated_skill = /datum/skill/misc/music
	spell_requirements = SPELL_REQUIRES_HUMAN

/datum/action/cooldown/spell/projectile/vicious_mockery/cast(atom/cast_on)
	var/mob/living/carbon/human/H = owner
	if(!ishuman(H))
		return
	H.say(pick(GLOB.mockery_insults), forced = "spell", language = /datum/language/common)
	. = ..()

// ---- Mockery Projectile ----

/obj/projectile/magic/mockery_note
	name = "vicious note"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "mockery_note"
	damage = 0
	nodamage = TRUE
	speed = 1
	range = 8
	hitsound = 'sound/magic/mockery.ogg'
	guard_deflectable = TRUE

/obj/projectile/magic/mockery_note/on_hit(target)
	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check(TRUE, TRUE))
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(!M.can_hear())
			visible_message(span_warning("The insult falls on deaf ears!"))
			qdel(src)
			return BULLET_ACT_BLOCK
		// Stack the debuff
		var/datum/status_effect/debuff/mockery_stack/existing = M.has_status_effect(/datum/status_effect/debuff/mockery_stack)
		if(existing)
			existing.add_stack()
		else
			M.apply_status_effect(/datum/status_effect/debuff/mockery_stack)
		if(firer)
			SEND_SIGNAL(firer, COMSIG_VICIOUSLY_MOCKED, target)
		playsound(get_turf(target), hitsound, 60, TRUE)
	return ..()

// ---- Stacking Mockery Debuff ----

/datum/status_effect/debuff/mockery_stack
	id = "mockery_stack"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/mockery_stack
	duration = MOCKERY_STACK_DURATION
	var/stacks = 1

/atom/movable/screen/alert/status_effect/debuff/mockery_stack
	name = "Vicious Mockery"
	desc = "<span class='warning'>That bard's words cut deeper than any blade!</span>\n"

/datum/status_effect/debuff/mockery_stack/on_apply()
	. = ..()
	apply_stack_effects()
	owner.balloon_alert_to_viewers("mocked (x[stacks])")
	owner.visible_message(
		span_warning("[owner] flinches from the mockery!"),
		span_userdanger("The bard's words sting - I can't focus!"))

/datum/status_effect/debuff/mockery_stack/proc/add_stack()
	if(stacks >= MOCKERY_STACKS_MAX)
		duration = MOCKERY_STACK_DURATION
		return
	remove_stack_effects()
	stacks = min(stacks + 1, MOCKERY_STACKS_MAX)
	duration = MOCKERY_STACK_DURATION
	apply_stack_effects()
	owner.balloon_alert_to_viewers("mocked (x[stacks])")
	if(stacks >= MOCKERY_STACKS_MAX)
		to_chat(owner, span_userdanger("The mockery digs deeper - I can barely think straight!"))
	update_alert()

/datum/status_effect/debuff/mockery_stack/proc/apply_stack_effects()
	if(!owner)
		return
	var/penalty = stacks * MOCKERY_STAT_PER_STACK
	effectedstats = list(STATKEY_STR = penalty, STATKEY_SPD = penalty, STATKEY_INT = penalty, STATKEY_WIL = penalty)
	for(var/statkey in effectedstats)
		owner.change_stat(statkey, effectedstats[statkey])

/datum/status_effect/debuff/mockery_stack/proc/remove_stack_effects()
	if(!owner || !effectedstats)
		return
	for(var/statkey in effectedstats)
		owner.change_stat(statkey, -effectedstats[statkey])

/datum/status_effect/debuff/mockery_stack/proc/update_alert()
	if(!linked_alert)
		return
	linked_alert.name = "Vicious Mockery ([stacks]/[MOCKERY_STACKS_MAX])"

/datum/status_effect/debuff/mockery_stack/on_remove()
	to_chat(owner, span_info("The sting of mockery fades."))
	. = ..()

#undef MOCKERY_STACKS_MAX
#undef MOCKERY_STACK_DURATION
#undef MOCKERY_STAT_PER_STACK
#undef MOCKERY_COOLDOWN
