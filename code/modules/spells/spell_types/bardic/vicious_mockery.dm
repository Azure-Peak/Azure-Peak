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

GLOBAL_LIST_INIT(obnoxious_insults, list(
	"You're boring me here!",
	"Stop being incompetent and fight!",
	"I've seen training dummies put up a better fight!",
	"Quit flailing like a child and fight!",
	"I'm falling asleep here, good sire!",
	"Even your shadow is embarrassed by you!",
	"Behind you!",
	"Over there!",
	"My grandmother fights better than you!",
	"I'm better than you!",
	"Idiot!",
	"Coward! Face me!",
	"How much sparring did it take to become this awful?!",
))

GLOBAL_LIST_INIT(obnoxious_insults_r, list(
	"My, how suddenly cautious!",
	"There we go. Cowardice disguised as discipline!",
	"A round of applause for your stupidity!",
	"How precious! Scared already?!",
	"Delightful. You chose poorly!",
	"The Jester's award goes to you, fool!",
	"Oh, now you remember defense?!",
	"Too late for second thoughts!",
	"There it is! Panic in proper posture!",
	"Brilliant! You've done exactly what I hoped!"
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

/datum/action/cooldown/spell/obnoxious_taunt
	name = "Obnoxious Taunt"
	desc = "Let loose some truths in the middle of combat, briefly disrupting your opponent's concentration as if you've Feinted them. If you use this on a guarding opponent, they'll be Baited instead."
	button_icon = 'icons/mob/actions/xylixmiracles.dmi'
	button_icon_state = "taunt"
	spell_color = GLOW_COLOR_BARDIC
	glow_intensity = GLOW_INTENSITY_LOW
	cast_range = 7
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = 15
	cooldown_time = 10 SECONDS
	associated_skill = /datum/skill/misc/music

/datum/action/cooldown/spell/obnoxious_taunt/cast(atom/cast_on, mob/living/user)
	. = ..()

	if(!user)
		return FALSE
	if(user.incapacitated())
		return FALSE
	if(!isliving(cast_on))
		return FALSE

	var/mob/living/L = cast_on

	if(L == user)
		return FALSE

	if(get_dist(user, L) > cast_range)
		return FALSE

	if(L.has_status_effect(/datum/status_effect/buff/notaunt))
		return FALSE

	if(HAS_TRAIT(L, TRAIT_NOMOOD) || HAS_TRAIT(L, TRAIT_DETACHED))
		return FALSE

	user.face_atom(L)

	var/is_guarding = (L.has_status_effect(/datum/status_effect/buff/clash) ||	L.has_status_effect(/datum/status_effect/buff/clash/limbguard))

	if(is_guarding && ishuman(user) && ishuman(L))
		var/mob/living/carbon/human/HU = user
		var/mob/living/carbon/human/HT = L

		if(HT.has_status_effect(/datum/status_effect/debuff/baited))
			return FALSE

		if(HU.has_status_effect(/datum/status_effect/debuff/baitcd))
			return FALSE

		user.say(pick(GLOB.obnoxious_insults_r))

		HT.apply_status_effect(/datum/status_effect/debuff/baited)
		HT.apply_status_effect(/datum/status_effect/debuff/exposed)
		HT.apply_status_effect(/datum/status_effect/debuff/clickcd, 5 SECONDS)

		HT.bait_stacks++

		if(HT.has_status_effect(/datum/status_effect/buff/clash/limbguard))
			HT.bad_guard()

		to_chat(HU, span_notice("[HT.p_they(TRUE)] took the bait!"))
		to_chat(HT, span_danger("ARGGHHH!!! THIS OBNOXIOUS PIECE OF SHITE!!!"))

		playsound(user, 'sound/combat/feint.ogg', 100, TRUE)
		playsound(user, 'sound/magic/mockery.ogg', 100, TRUE)

		HU.apply_status_effect(/datum/status_effect/debuff/baitcd, (BAIT_RCLICK_CD - HU.get_tempo_bonus(TEMPO_TAG_RCLICK_CD_BONUS)))

		return TRUE

	if(user.has_status_effect(/datum/status_effect/debuff/feintcd))
		return FALSE

	var/perc = 60
	var/ourskill = 0
	var/theirskill = 0

	var/obj/item/I = user.get_active_held_item()

	if(I?.associated_skill)
		ourskill = user.get_skill_level(I.associated_skill)

	if(L.mind)
		I = L.get_active_held_item()
		if(I?.associated_skill)
			theirskill = L.get_skill_level(I.associated_skill)

	perc += (ourskill - theirskill) * 15
	perc += (user.STAINT - L.STAINT) * 10
	perc = CLAMP(perc, 15, 95)

	user.say(pick(GLOB.obnoxious_insults))

	if(prob(perc))
		L.interrupt_spell_channel()

		var/effect = (L.mind ? /datum/status_effect/debuff/vulnerable : /datum/status_effect/debuff/exposed)

		L.apply_status_effect(effect, 7.5 SECONDS)
		L.apply_status_effect(/datum/status_effect/debuff/clickcd, 2.5 SECONDS)
		L.Immobilize(0.5 SECONDS)

		to_chat(user, span_notice("[L.p_they(TRUE)] fell for my goading!"))
		to_chat(L, span_danger("ARGGHHH!!! THIS OBNOXIOUS PIECE OF SHITE!!!"))

		playsound(user, 'sound/combat/riposte.ogg', 100, TRUE)
		playsound(user, 'sound/magic/mockery.ogg', 100, TRUE)

	user.apply_status_effect(/datum/status_effect/debuff/feintcd, (FEINT_RCLICK_CD - user.get_tempo_bonus(TEMPO_TAG_RCLICK_CD_BONUS)))

	return TRUE
	
/datum/status_effect/buff/notaunt
	id = "notaunt"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 40 SECONDS
	alert_type = null

#undef MOCKERY_STACKS_MAX
#undef MOCKERY_STACK_DURATION
#undef MOCKERY_STAT_PER_STACK
#undef MOCKERY_COOLDOWN
