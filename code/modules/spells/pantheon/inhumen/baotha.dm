/////////////////////////
// T0 - Emotional Sway //
/////////////////////////

/datum/action/cooldown/spell/baotha
	background_icon = 'icons/mob/actions/baothamiracles.dmi'
	button_icon = 'icons/mob/actions/baothamiracles.dmi'
	spell_color = GLOW_COLOR_BAOTHA
	ignore_armor_penalty = TRUE
	primary_resource_type = SPELL_COST_DEVOTION
	secondary_resource_type = SPELL_COST_STAMINA
	has_visual_effects = FALSE
	spell_impact_intensity = SPELL_IMPACT_NONE
	associated_stat = null
	associated_skill = /datum/skill/magic/holy
	spell_tier = 0
	point_cost = 0
	spell_flags = SPELL_PSYDON
	required_items = list(/obj/item/clothing/neck/roguetown/psicross)

/datum/action/cooldown/spell/baotha/emotional_sway
	name = "Laetitia / Petulantia"
	desc = "Baotha raises myne mood. Alt-mode to instead surrender my soul to heartbreak. More effective based off of holy skill."
	button_icon_state = null //i ain't got shit rn lowk chief
	sound = 'sound/magic/heal.ogg' //i ain't got SHIT rn lowk chief
	click_to_activate = TRUE
	self_cast_possible = TRUE
	primary_resource_cost = SPELLCOST_MIRACLE
	secondary_resource_cost = SPELLCOST_CANTRIP
	invocation_type = INVOCATION_NONE
	charge_required = FALSE
	cooldown_time = 60 SECONDS
	check_flags = AB_CHECK_CONSCIOUS
	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	var/embrace_heartbreak = FALSE

/datum/action/cooldown/spell/baotha/emotional_sway/toggle_alt_mode(mob/user)
	embrace_heartbreak = !embrace_heartbreak
	to_chat(user, span_notice("Baotha's blessing will now [embrace_heartbreak ? "decrease" : "increase"] my mood."))
	return TRUE

/datum/action/cooldown/spell/baotha/emotional_sway/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/user = owner
	if(!istype(user))
		return FALSE

	var/holy_skill = user.get_skill_level(associated_skill)
	var/event_type = embrace_heartbreak ? /datum/stressevent/baotha_heartbreak : /datum/stressevent/baotha_solace
	user.remove_stress(event_type)
	var/datum/stressevent/emotional_sway = user.add_stress(event_type)
	if(!emotional_sway)
		return FALSE
	emotional_sway.stressadd = (embrace_heartbreak ? 1 : -1) * 2 * holy_skill
	to_chat(user, embrace_heartbreak ? span_warning("Sickening plummet. This will all end one dae.") : span_green("Warmth and cherishment."))
	return TRUE

/datum/stressevent/baotha_solace
	timer = 1 MINUTES
	desc = span_green("May I make the most of myne pleasure.")

/datum/stressevent/baotha_heartbreak
	timer = 1 MINUTES
	desc = span_red("...nothing ever lasts forever.")

//T0 that tells the user the person's vice.
/obj/effect/proc_holder/spell/invoked/baothavice
	name = "Tell Vice"
	desc = "Tells you the targets Vice."
	action_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_state = "vice"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	range = 3
	warnie = "sydwarning"
	movement_interrupt = FALSE
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 5 SECONDS
	miracle = TRUE
	devotion_cost = 10
	var/list/fake_vices = list()

/obj/effect/proc_holder/spell/invoked/baothavice/cast(list/targets, mob/living/user)
	if(!ishuman(targets?[1]))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/H = targets[1]
	var/vice_found

	if(HAS_TRAIT(H, TRAIT_DECEIVING_MEEKNESS) && user.get_skill_level(/datum/skill/magic/holy) <= SKILL_LEVEL_NOVICE)
		if(isnull(fake_vices[H]))
			var/datum/charflaw/cf = pick_assoc(GLOB.character_flaws_singletons)
			fake_vices[H] = cf.name
		vice_found = fake_vices[H]

		if(prob(50 + ((H.STAPER - 10) * 10)))
			to_chat(H, span_warning("A pair of prying eyes were laid on me..."))

	if(!vice_found)
		if(H.charflaws)
			var/list/vices = list()
			for(var/datum/charflaw/cf in H.charflaws)
				vices.Add(cf.name)
			vice_found = english_list(vices)
		else
			to_chat(user, span_warning("Their heart is unreadable."))
			revert_cast()
			return FALSE

	to_chat(user, span_info("They are... [span_warning("a [vice_found]")]"))
	return TRUE

//Baotha's Blessings - T0, reverses overdose effect on a target + soothing moodlet. Useful to T0/Devotee because it allows them to stop an OD death, but puts them on the clock. (Medieval narcan..... #BanNarcan)

/obj/effect/proc_holder/spell/invoked/baothablessings
	name = "Baotha's Blessings"
	desc = "Gets the target drunk and stops them from overdosing for a time."
	action_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_state = "blessing"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 4
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/heal.ogg'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 30 SECONDS
	miracle = TRUE
	devotion_cost = 10

/obj/effect/proc_holder/spell/invoked/baothablessings/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/carbon/target = targets[1]
		if(HAS_TRAIT(target, TRAIT_PSYDONITE))
			target.visible_message(span_info("[target] stirs for a moment, the miracle dissipates."), span_blue("A dull warmth swells in your heart, only to fade as quickly as it arrived."))
			user.playsound_local(user, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			playsound(target, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			return FALSE
		if(HAS_TRAIT(target, TRAIT_UNFORGIVABLE))
			target.visible_message(span_info("[target] stirs for a moment, the miracle dissipates."), span_blue("A dull warmth swells in your hollow husk of a body, only to fade as quickly as it arrived."))
			user.playsound_local(user, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			playsound(target, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			return FALSE
		if(target.has_status_effect(/datum/status_effect/buff/baothablessing))
			to_chat(user, span_warning("They're already blessed by these effects!"))
			revert_cast()
			return FALSE
		target.apply_status_effect(/datum/status_effect/buff/baothablessing) //Gets the trait temorarily, basically will just stop any active/upcoming ODs.
		target.visible_message("<span class='info'>[target]'s eyes appear to gloss over!</span>", "<span class='notice'>I feel.. at ease.</span>")
	return TRUE

//T1, Baotha's version of Eora's Bud (now renamed True Peace Bloom). Applies the TRAIT_CRACKHEAD baothans have.
/obj/effect/proc_holder/spell/invoked/griefflower
	name = "False Serenity Bloom"
	desc = "A gift for those whom you have choosen as worthy of Her grace, to be able to imbibe in Her gifts as you do."
	clothes_req = FALSE
	range = 7
	action_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_state = "bloom"
	sound = list('sound/magic/magnet.ogg')
	releasedrain = 40
	chargetime = 10
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/holy
	recharge_time = 30 MINUTES //To avoid spamming this shit and giving all heretics florida-man crackhead superpowers. No Bro.

/obj/effect/proc_holder/spell/invoked/griefflower/cast(mob/living/user)
	var/turf/T = get_turf(user)
	if(!isclosedturf(T))
		new /obj/item/clothing/ring/griefflower(T)
		return TRUE

	to_chat(user, span_warning("The targeted location is blocked. Her gift cannot be invoked."))
	revert_cast()
	return FALSE

/obj/item/clothing/ring/griefflower
	name = "rosa ring"
	desc = "Numbing-touch rosa sickly-sweet scent trickle unto my nose, and into soul. <br><br>THOU ART EVERYTHING; RELEASE THY LOVE UNTO ME."
	icon_state = "baothaflower"
	item_state = "baothaflower"
	icon = 'icons/roguetown/items/produce.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'

/obj/item/clothing/ring/griefflower/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_RING)
		user.apply_status_effect(/datum/status_effect/buff/griefflower)
		user.remove_status_effect(/datum/status_effect/debuff/joybringer_druqks)

/obj/item/clothing/ring/griefflower/dropped(mob/living/carbon/human/user)
	. = ..()
	if(istype(user) && user?.wear_ring == src)
		user.remove_status_effect(/datum/status_effect/buff/griefflower)

/obj/item/clothing/ring/griefflower/get_examine_highlight_status()
	// The rosa ring is supposed to be 'discrete', so it doesn't look heretical to a casual observer.
	return null

// T1 - polls the caster's mood and vice satiety before giving a buff. as you can tell by the typepath i had an entiurely different idea for this ubt whatever
/obj/effect/proc_holder/spell/invoked/heart_on_sleeve
	name = "Phentis / Melancholia"
	desc = "Give myne soul to wild joy or vicious heartbreak. In a good mood, I and those around me find calm and clarity. When suffering from the world's ails, I alone benefit- with some drawbacks. A sated vice doubles the duration; every unsated vice doubles every stat change."
	action_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_state = "powder"
	clothes_req = FALSE
	releasedrain = 30
	chargedrain = 0
	chargetime = 2 SECONDS //BIG, VERY IMPORTANT spell
	recharge_time = 2 MINUTES
	invocations = list("Melancholy! Mania!") //fuck dude I don't know I'm so fried
	sound = 'sound/magic/heal.ogg'
	chargedloop = /datum/looping_sound/invokeholy
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	miracle = TRUE
	devotion_cost = 30
	var/aura_range = 1

/obj/effect/proc_holder/spell/invoked/heart_on_sleeve/cast(list/targets, mob/living/carbon/user)
	var/stress_threshold = get_stress_threshold(user.get_stress_amount())
	var/is_good_mood = stress_threshold == STRESS_THRESHOLD_NICE || stress_threshold == STRESS_THRESHOLD_GOOD
	var/is_bad_mood = stress_threshold >= STRESS_THRESHOLD_STRESSED

	if(!is_good_mood && !is_bad_mood)
		to_chat(user, span_userdanger("EMPTY."))
		revert_cast()
		return FALSE

	var/vice_sated = TRUE
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		for(var/datum/charflaw/addiction/vice in human_user.charflaws)
			if(!vice.sated)
				vice_sated = FALSE
				break

	var/stat_multiplier = vice_sated ? 1 : 2
	var/effect_duration = vice_sated ? 90 SECONDS : 45 SECONDS

	if(is_good_mood)
		for(var/mob/living/nearby_soul in view(aura_range, user))
			if(nearby_soul.stat != DEAD)
				nearby_soul.apply_status_effect(/datum/status_effect/buff/heart_on_sleeve/phentis, stat_multiplier, effect_duration)
		user.visible_message(span_notice("A warm, passionate haze gathers around [user]."), span_green("TAKE MYNE LOVE FOR BUT A MOTE."))
	else
		user.apply_status_effect(/datum/status_effect/buff/heart_on_sleeve/melancholia, stat_multiplier, effect_duration)
		user.visible_message(span_warning("[user] draws their heartbreak inward."), span_warning("MYNE SORROW IS MINE ALONE."))
	return TRUE

/datum/status_effect/buff/heart_on_sleeve
	id = "heart_on_sleeve"
	status_type = STATUS_EFFECT_REPLACE
	alert_type = /atom/movable/screen/alert/status_effect/buff/heart_on_sleeve
	duration = 45 SECONDS

/datum/status_effect/buff/heart_on_sleeve/on_creation(mob/living/new_owner, stat_multiplier = 1, effect_duration = 45 SECONDS)
	duration = effect_duration
	for(var/stat in effectedstats)
		effectedstats[stat] *= stat_multiplier
	return ..()

/datum/status_effect/buff/heart_on_sleeve/phentis
	effectedstats = list(STATKEY_SPD = 1, STATKEY_INT = 1)

/datum/status_effect/buff/heart_on_sleeve/melancholia
	effectedstats = list(STATKEY_STR = 1, STATKEY_SPD = 1, STATKEY_WIL = 1, STATKEY_CON = -1, STATKEY_INT = -1)

/atom/movable/screen/alert/status_effect/buff/heart_on_sleeve
	name = "HEART AND SOUL"
	desc = ""
	icon_state = "buff"

//Enrapturing Powder - T2, basically a crackhead blowing cocaine in your face.

/obj/effect/proc_holder/spell/invoked/projectile/blowingdust
	name = "Enrapturing Powder"
	desc = "Blows dust of a potent drug at the target, applying a variety of effects. \
	Your intent will determine the drug thrown at the target. \n\
	\
	Feint intent will throw spice at the target, giving them +5 INT, +3 SPD, and -5 FOR. \n\
	\
	Aimed intent will throw moondust at the target, giving them +3 SPD, +3 WILL, and -2 INT. \n\
	\
	Strong intent will throw herozium at the target, giving them -5 SPD, +4 WILL, -3 INT, +3 CON, pain immunity, and resistance to damage slowdown. \n\
	\
	Swift intent will throw starsugar at the target, giving them +4 SPD, +4 WILL -3 INT, -3 CON, darkvision, and dodge expert."
	action_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_state = "powder"
	clothes_req = FALSE
	range = 7	//POCKET OPIUM! 7 tiles because it's a projectile and it used to just travel across the entire screen anyway even at 3.
	associated_skill = /datum/skill/magic/holy
	projectile_type = /obj/projectile/magic/blowingdust
	chargedloop = /datum/looping_sound/invokeholy
	releasedrain = 10
	chargedrain = 0
	chargetime = 15
	recharge_time = 10 SECONDS
	invocation_type = "emote"
	invocations = list("flicks their wrist, filling the air in front of them with a fine powder.")
	devotion_cost = 30
	human_req = TRUE

/obj/effect/proc_holder/spell/invoked/projectile/blowingdust/cast(list/targets, mob/user = user)
	switch(user.rmb_intent.name)
		if("feint")
			projectile_type = /obj/projectile/magic/blowingdust/spice
		if("aimed")
			projectile_type = /obj/projectile/magic/blowingdust/moondust
		if("strong")
			projectile_type = /obj/projectile/magic/blowingdust
		if("swift")
			projectile_type = /obj/projectile/magic/blowingdust/starsugar
		else
			projectile_type = /obj/projectile/magic/blowingdust

	. = ..()

/obj/projectile/magic/blowingdust
	name = "unholy dust"
	icon_state = "spark"
	expose_caster_on_deflect = TRUE
	nodamage = FALSE
	damage = 1
	poisontype = /datum/reagent/herozium
	poisonfeel = "burning" //Insufflation delivery method.
	poisonamount = 8 //Decent bit of high, three doses would be just above the overdose threshold if applied fast enough - in practice usually 4.

/obj/projectile/magic/blowingdust/starsugar
	name = "unholy dust"
	icon_state = "spark"
	nodamage = FALSE
	damage = 1
	poisontype = /datum/reagent/starsugar
	poisonfeel = "burning" //Insufflation go brr.
	poisonamount = 8 //Decent bit of high, three doses would be just above the overdose threshold if applied fast enough - in practice usually 4.

/obj/projectile/magic/blowingdust/spice
	name = "unholy dust"
	icon_state = "spark"
	nodamage = FALSE
	damage = 1
	poisontype = /datum/reagent/druqks
	poisonfeel = "burning" //Insufflation go brr.
	poisonamount = 4 //Lower than the others as it's got an OD threshold of 16 - takes 4 hits to OD if you hit it perfectly, but more like 5.

/obj/projectile/magic/blowingdust/moondust
	name = "unholy dust"
	icon_state = "spark"
	nodamage = FALSE
	damage = 1
	poisontype = /datum/reagent/moondust_purest
	poisonfeel = "burning" //Insufflation go brr.
	poisonamount = 8 //Decent bit of high, three doses would be just above the overdose threshold if applied fast enough - in practice usually 4.


/obj/projectile/magic/blowingdust/on_hit(target, blocked = FALSE)
	. = ..()
	if(!isliving(target))
		return
	if(out_of_effective_range())
		return
	if(blocked >= 100)
		return
	var/mob/living/M = target
	to_chat(M, span_warning("Gah! Something.. got in my - eyes.."))
	M.blur_eyes(2)

// T2 - shares the caster's current mood, intensified by their holy skill.
/obj/effect/proc_holder/spell/invoked/lasthigh
	name = "Codependence"
	desc = "Shares my current stress or peace with someone, intensified by my holy skill."
	action_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_state = "last_high"
	releasedrain = 30
	chargedrain = 0
	chargetime = 2 SECONDS
	range = 7
	warnie = "sydwarning"
	chargedloop = /datum/looping_sound/invokeholy
	sound = 'sound/magic/timestop.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 2 MINUTES
	miracle = TRUE
	devotion_cost = 75
	human_req = TRUE
	invocation_type = "whisper"
	invocations = list("Release your love to me.")

/obj/effect/proc_holder/spell/invoked/lasthigh/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.mob_biotypes & MOB_UNDEAD)
			return FALSE

		target.visible_message(
			span_info("[target] is taken awash by another's emotions."),
			span_notice("The world fades around me as unfamiliar emotions flood through my body.")
		)
		target.remove_stress(/datum/stressevent/lasthigh)
		var/datum/stressevent/shared_mood = target.add_stress(/datum/stressevent/lasthigh)
		if(!shared_mood)
			return FALSE
		var/caster_stress = user.get_stress_amount()
		shared_mood.stressadd = caster_stress + SIGN(caster_stress) * user.get_skill_level(associated_skill)
		return TRUE

/datum/stressevent/lasthigh
	timer = 2 MINUTES
	desc = span_red("Foreign feelings wash myne soul. Is this truly how it feels to be another?")


// T3 - bond that lasts for 8 minutes as long as bonded are within 7 tiles, TRAIT_NOPAIN, spd = 5 end = 3
/obj/effect/proc_holder/spell/invoked/joyride
	name = "Joyride"
	desc = "A frenzy for two to partake in."
	action_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_state = "joyride"
	range = 2
	chargetime = 0.5 SECONDS
	invocation_type = "emote"
	invocations = list("exhales. A deep-purple mist dances through the air...")		//apparently you can't get targets in the invocation
	sound = 'sound/magic/magnet.ogg'
	recharge_time = 60 SECONDS
	miracle = TRUE
	devotion_cost = 75
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/joyride/cast(list/targets, mob/living/user)
	var/mob/living/target = targets[1]

	var/datum/component/baotha_joyride/existing = user.GetComponent(/datum/component/baotha_joyride)
	if(existing)
		to_chat(user, span_warning("Your fates are already intertwined!"))
		revert_cast()
		return FALSE

	if(!istype(target, /mob/living/carbon) || target == user)
		revert_cast()
		return FALSE

	if(!do_after(user, 3 SECONDS, target = target))
		to_chat(user, span_warning("There is no joy without concentration!"))
		revert_cast()
		return FALSE

	var/holy_skill = user.get_skill_level(associated_skill)
	user.AddComponent(/datum/component/baotha_joyride, target, user, holy_skill)
	target.AddComponent(/datum/component/baotha_joyride/partner, target, user, holy_skill)

	user.visible_message(
		span_notice("[user] and [target] inhale a magenta mist. A strange aching feeling pounds in your chest."),			//baotha, goddess of combat-cuckolding
	)
	return TRUE

//Numbing Pleasure - T3, halves pain from target for a period of time. (Similar to Ravox's without any blood-clotting and better pain suppression + good mood buff.)
/obj/effect/proc_holder/spell/invoked/painkiller
	name = "Numbing Pleasure"
	desc = "Numbs the targets pain and improves their mood."
	action_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_state = "pleasure"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	sound = 'sound/magic/timestop.ogg'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 90 SECONDS
	miracle = TRUE
	devotion_cost = 75

/obj/effect/proc_holder/spell/invoked/painkiller/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/mob/living/carbon/human/human_target = target
		var/datum/physiology/phy = human_target.physiology
		if(target.mob_biotypes & MOB_UNDEAD)
			return FALSE	//No, you don't get to feel good. You're a undead mob. Feel bad.
		target.visible_message(span_info("[target] twitches and shivers as a strange warmth radiates from them!"), span_notice("The pain from my wounds melts into sweet statick."))
		phy.pain_mod *= 0.5	//Literally halves your pain modifier.
		addtimer(CALLBACK(src, PROC_REF(restore_pain_mod), phy), 1 MINUTES)
		target.apply_status_effect(/datum/status_effect/buff/vitae)					//+2 Fortune and mood buff
		return TRUE

/obj/effect/proc_holder/spell/invoked/painkiller/proc/restore_pain_mod(datum/physiology/physiology)
	if(!physiology)
		return

	physiology.pain_mod /= 0.5
