/datum/action/cooldown/spell/ink_presence
	name = "Ink Presence"
	desc = "Start leaving paint trails as you move in TRAIL mode, or lob a ball of ink to coat a 3x3 area in SPLASH mode. You and those with paint affinity are sped up and regain a smidge of nutrition for walking over paint, everyone else is slowed."
	button_icon = 'icons/mob/actions/abyssormiracles.dmi'
	background_icon = 'icons/mob/actions/abyssormiracles.dmi'
	button_icon_state = "paint"
	sound = 'sound/magic/abyssor_splash.ogg'
	spell_color = "#00051f"

	primary_resource_type = SPELLCOST_CONJURE
	primary_resource_cost = SPELLCOST_STAT_BUFF

	invocations = list(
	)
	invocation_type = INVOCATION_SHOUT
	charge_required = TRUE
	charge_time = 0.1 SECONDS
	cooldown_time = 22 SECONDS
	devotion_cost = 25
	associated_skill = /datum/skill/magic/holy

	modes = list(
		list("tag" = "TRAIL", "name" = "Trail", "invocation" = list("Shogg sp'gai! Swift steps from beyond!", "Y'gathil mor, speed my step!"), "color" = PATRON_COLOR_ABYSSOR),
		list("tag" = "SPLSH", "name" = "Splash", "invocation" = list("N'gai, n'gha'ghaa, fhtagn!", "K'rnul, the painter bleeds!"), "color" = PATRON_COLOR_ABYSSOR),
	)

/datum/action/cooldown/spell/ink_presence/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!user)
		return FALSE

	if(current_mode == 1)
		user.apply_status_effect(/datum/status_effect/buff/ink_presence)
		return TRUE

	var/obj/projectile/paint_splat/myorb = new /obj/projectile/paint_splat(get_turf(user))
	myorb.firer = user
	myorb.arcshot = TRUE
	myorb.range = get_dist_euclidian(cast_on, myorb)
	myorb.fire(Get_Angle(myorb, cast_on))
	return TRUE

/obj/projectile/paint_splat
	icon_state = "pulse1"

/obj/projectile/paint_splat/on_range()
	for(var/turf/open/ground in range(1, get_turf(src)))
		var/obj/effect/ink_trail/existing_trail = locate(/obj/effect/ink_trail) in ground

		if(existing_trail)
			existing_trail.refresh_lifetime()
		else
			new /obj/effect/ink_trail(ground, firer)
	. = ..()

/obj/projectile/paint_splat/on_hit(atom/target, blocked)
	. = ..()
	on_range()

/datum/action/cooldown/spell/paint_attunement
	name = "Paint Attunement"
	desc = "Conduct a lengthy attunement miracle to bind an ally to your paint trails. Targets cannot move during the ritual. Casting without a direct target allows you to manage or revoke existing blessings."
	button_icon = 'icons/mob/actions/abyssormiracles.dmi'
	background_icon = 'icons/mob/actions/abyssormiracles.dmi'
	button_icon_state = "paint_bless"
	sound = 'sound/magic/abyssor_splash.ogg'
	spell_color = "#5c0099"

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_STAT_BUFF

	invocations = list(
		"Tha'lass-vax, maro det'us!",
		"Vrek'hen-dyll, khoro!",
		"zul-morn, dra'yne the light!"
	)
	invocation_type = INVOCATION_SHOUT
	charge_required = TRUE
	charge_time = 1.5 SECONDS
	cooldown_time = 1 SECONDS
	devotion_cost = 30
	associated_skill = /datum/skill/magic/holy

	// Soft references (weakrefs) mapping [Target Ref String] -> [Weakref to Target]
	var/list/beneficiaries = list()

/datum/action/cooldown/spell/paint_attunement/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!user)
		return FALSE

	for(var/ref_str in beneficiaries)
		var/datum/weakref/W = beneficiaries[ref_str]
		var/mob/living/L = W?.resolve()
		if(!L || QDELETED(L) || L.stat == DEAD)
			beneficiaries -= ref_str

	var/mob/living/target = cast_on
	if(!istype(target) || target == user)
		if(!length(beneficiaries))
			to_chat(user, span_warning("You are not currently sustaining any paint affinity blessings."))
			return FALSE

		var/list/revoke_options = list()
		for(var/ref_str in beneficiaries)
			var/datum/weakref/W = beneficiaries[ref_str]
			var/mob/living/L = W.resolve()
			if(L && !(L.patron.type == /datum/patron/divine/abyssor))
				revoke_options[L.name] = ref_str
			else if(L)
				revoke_options[L.real_name] = ref_str

		var/chosen_name = tgui_input_list(user, "Select a blessing to revoke:", "Manage Paint Blessings", revoke_options)
		if(!chosen_name || !user || QDELETED(src))
			return FALSE

		var/target_ref_str = revoke_options[chosen_name]
		var/datum/weakref/target_W = beneficiaries[target_ref_str]
		var/mob/living/revoked_mob = target_W?.resolve()

		beneficiaries -= target_ref_str
		if(revoked_mob)
			REMOVE_TRAIT(revoked_mob, TRAIT_INK_AFFINITY, TRAIT_MIRACLE)
			to_chat(revoked_mob, span_userdanger("Your paint affinity has been dissolved by your patron!"))
		user.visible_message(span_warning("[user] severs the canvas binding [chosen_name]!"))
		return TRUE

	if(target.stat == DEAD)
		to_chat(user, span_warning("The dead cannot hold the pigment of Abyssor."))
		return FALSE
	if(HAS_TRAIT(target, TRAIT_INK_AFFINITY))
		to_chat(user, span_warning("[target] is already attuned to holy paints."))
		return FALSE

	var/max_beneficiaries = 1
	var/holy_skill = user.get_skill_level(/datum/skill/magic/holy)

	switch(holy_skill)
		if(3)
			max_beneficiaries = 2
		if(4, 5)
			max_beneficiaries = 3
		if(6)
			max_beneficiaries = 4
		else
			max_beneficiaries = 1

	if(length(beneficiaries) >= max_beneficiaries)
		to_chat(user, span_warning("Your current holy skill only allows you to sustain [max_beneficiaries] blessing\s at a time. Revoke an old one first."))
		return FALSE

	user.visible_message(span_notice("[user] begins painting beneath [target]'s feet!"))

	if(!do_after(user, 1 SECONDS, target = target))
		to_chat(user, span_warning("The attunement ritual was broken by movement!"))
		return FALSE

	if(QDELETED(target) || target.stat == DEAD || HAS_TRAIT(target, TRAIT_INK_AFFINITY))
		return FALSE

	var/display_name = target.name
	beneficiaries[REF(target)] = WEAKREF(target)
	ADD_TRAIT(target, TRAIT_INK_AFFINITY, TRAIT_MIRACLE)

	user.visible_message(span_nicegreen("[user] successfully completes the ritual! [display_name] is now attuned to holy paints."))
	to_chat(target, span_purple("<b>Your lux has been coated in sacred pigments. You can now walk safely through abyssal paints!</b>"))
	return TRUE

/datum/action/cooldown/spell/paint_attunement/Destroy()
	var/mob/living/user = owner
	for(var/ref_str in beneficiaries)
		var/datum/weakref/W = beneficiaries[ref_str]
		var/mob/living/L = W?.resolve()
		if(L && user)
			REMOVE_TRAIT(L, TRAIT_INK_AFFINITY, TRAIT_MIRACLE)
	beneficiaries.Cut()
	return ..()

#define ARROW_MODE_SHARD 1
#define ARROW_MODE_COAT 2
#define ARROW_MODE_GRASP 3

/datum/action/cooldown/spell/dreamwakers_bow
	name = "Dreamwaker's Bow"
	desc = "Imagine a short-lived bow preloaded with a single arrow; the mode determines arrow type. SHARD mode fires a dream shard, which harms and causes anyone hit to bleed paint trails. COAT mode fires a glob of shielding paint, which coats the target, absorbing the next hit they take; however, it can't affect those with skin armor or wards. GRASP mode fires an abyssal tendril which yanks the target to you; however, it can only affect those with paint affinity, such as allies you've granted Paint Attunement."
	button_icon = 'icons/mob/actions/abyssormiracles.dmi'
	background_icon = 'icons/mob/actions/abyssormiracles.dmi'
	button_icon_state = "paint_blade"
	sound = 'sound/magic/abyssor_splash.ogg'
	spell_color = "#03000a"

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CONJURE

	invocations = list(
		"Tha'lass-vax, blacken the iron!",
		"Cri'morah, let the edges weep!",
		"kra'khen, coat this steel!"
	)
	invocation_type = INVOCATION_SHOUT
	charge_required = TRUE
	charge_time = 0.5 SECONDS
	cooldown_time = 35 SECONDS
	devotion_cost = 25
	associated_skill = /datum/skill/magic/holy

	modes = list(
		list("tag" = "SHARD", "name" = "Shard", "color" = PATRON_COLOR_ABYSSOR, "bow" = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short/paint),
		list("tag" = "COAT", "name" = "Coat", "color" = PATRON_COLOR_ABYSSOR, "bow" = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short/paint/coat),
		list("tag" = "GRASP", "name" = "Coat", "color" = PATRON_COLOR_ABYSSOR, "bow" = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short/paint/grasp),
	)

/datum/action/cooldown/spell/dreamwakers_bow/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!user)
		return FALSE

	var/bow_type = modes[current_mode]["bow"]
	var/obj/item/gun/ballistic/revolver/grenadelauncher/bow/short/paint/P = new bow_type(user.loc)
	if(user.put_in_hands(P))
		user.visible_message(span_purple("Shimmering, abyssal paint coalesces in [user]'s empty hand, forming a volatile bow!"))
		return TRUE
	return FALSE

/datum/action/cooldown/spell/dreamwakers_bow/single_use
	name = "Invoke Dream Bow"
	desc = "Call upon your gifted umbral energy to form a volatile bow, with a single preloaded dream arrow. Switch mode to swap between three possible types: SHARD (harm target and make them bleed paint), COAT (coat target with shielding paint, conflicts with skin armor and wards), or GRASP (yanks the target to you, but only if they are attuned to sacred paints). This is a one-time use manifestation."
	cooldown_time = 1 HOURS

/datum/action/cooldown/spell/dreamwakers_bow/single_use/cast(atom/cast_on)
	. = ..()
	if(.)
		var/mob/living/user = owner
		addtimer(CALLBACK(src, PROC_REF(self_consume), user), 1)

/datum/action/cooldown/spell/dreamwakers_bow/single_use/proc/self_consume(mob/living/L)
	if(L?.mind)
		L.mind.RemoveSpell(src)

#undef ARROW_MODE_GRASP
#undef ARROW_MODE_COAT
#undef ARROW_MODE_SHARD

/datum/action/cooldown/spell/ink_blessing
	name = "Ink Blessing"
	desc = "In Bless mode, manage your dream fragments: brief glimpses of dream you recall upon waking. Each time you sleep, you may choose one of three fragments to remember, replacing an older fragment if you had one. These dreams contain guidance, which can be bestowed upon another by casting this miracle on them. Cast on yourself to recall your currently-held fragment.\nIn Transmute mode, purify nearby abyssal paint trails within your immediate surroundings, turning them into healing trails for the attuned. The more paint affected (up to 10), the longer the cooldown. If you pull targets, those attuned will get healed in your stead. If you use a paint brush staff, you can heal via pulling regardless."
	button_icon = 'icons/mob/actions/abyssormiracles.dmi'
	background_icon = 'icons/mob/actions/abyssormiracles.dmi'
	button_icon_state = "paint_heal"
	sound = 'sound/magic/abyssor_splash.ogg'
	spell_color = "#125a00"
	cast_range = 1 // no blessing from far away

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_STAT_BUFF

	modes = list(
		list("tag" = "TRANS", "name" = "Transmute", "invocation" = list("Prash'ik, nar'n. Heal the faithful!","Ya'shna vin'thu rasa. Fruits of the sea!","Hu'maw, A'ferta'nu. Rejuvenate!"), "invocation_type" = INVOCATION_SHOUT),
		list("tag" = "BLESS", "name" = "Fragment", "invocation" = "Had'aal, let the depths guide us.", "invocation_type" = INVOCATION_WHISPER)
	)
	// Hefty cooldown given we can heal a lot of people.
	// Up to double the cooldown with no int modifiers if a lot of puddles are made into healing stuff.
	cooldown_time = 28 SECONDS
	charge_time = 0.5 SECONDS
	associated_skill = /datum/skill/magic/holy
	var/transmute_range = 4
	var/temp_cooldown_multiplier = 1.0

/datum/action/cooldown/spell/ink_blessing/Grant(mob/grant_to)
	. = ..()
	ADD_TRAIT(grant_to, TRAIT_DREAM_FRAGMENTS, TRAIT_MIRACLE) // there's a more bespoke way to add this to "only abyssorites of t3 or above who chose painted path" but like, we can also just do this and it's simpler
	RegisterSignal(grant_to, COMSIG_MOB_SLEEP, PROC_REF(on_mob_sleep))
	RegisterSignal(grant_to, COMSIG_LIVING_STATUS_SLEEP, PROC_REF(on_mob_sleep)) // narco does this one instead for whatever reason

/datum/action/cooldown/spell/ink_blessing/Remove(mob/living/remove_from)
	. = ..()
	REMOVE_TRAIT(remove_from, TRAIT_DREAM_FRAGMENTS, TRAIT_MIRACLE)
	UnregisterSignal(remove_from, list(COMSIG_MOB_SLEEP, COMSIG_LIVING_STATUS_SLEEP))

/datum/action/cooldown/spell/ink_blessing/proc/on_mob_sleep() // we handle dream fragment gain/overwrite here
	var/datum/component/dream_fragment/current_fragment = owner.GetComponent(/datum/component/dream_fragment)
	var/list/options = list()
	var/list/frags = GLOB.dream_fragments.Copy()
	for(var/i in 1 to 3)
		var/datum/component/dream_fragment/path = pick(frags)
		frags -= path
		options["...[path::dream_blurb]..."] = path
	if(current_fragment)
		options["Keep current fragment."] = /datum/component/dream_fragment // dummy value
	var/choice = tgui_input_list(owner, "Which dream are you drawn to?", "DREDGE THE DEPTHS", options, "Keep current fragment.", 30 SECONDS)
	if(choice && choice != "Keep current fragment.")
		owner.AddComponent(options[choice])
	return

/datum/action/cooldown/spell/ink_blessing/cast(atom/cast_on)
	. = ..()
	return (current_mode == 1 ? trans() : bless(cast_on))

/datum/action/cooldown/spell/ink_blessing/proc/trans() // classic functionality: turn paint puddles around you into healing paint
	var/mob/living/user = owner
	if(!user)
		return FALSE

	var/turf/center = get_turf(user)
	if(!center)
		return FALSE

	var/affected_count = 0
	for(var/obj/effect/ink_trail/trail in range(transmute_range, center))
		trail.apply_custom_effect(
			new_buff = /datum/status_effect/buff/umbral_recovery,
			new_debuff = null,
			new_icon_state = "paint_gray",
			new_color = "#b6e6b6",
			consume = TRUE,
			deny = TRUE,
			new_duration = 15 SECONDS,
			to_pulled = TRUE
		)
		affected_count++

	if(affected_count > 0)
		to_chat(user, span_nicegreen("I have successfully converted [affected_count] puddles into healing paint!"))
		temp_cooldown_multiplier = clamp(1.0 + (affected_count * 0.08), 1.0, 2.0)
		return TRUE
	else
		to_chat(user, span_warning("There were no abyssal paint puddles nearby to transmute."))
		return FALSE

/datum/action/cooldown/spell/ink_blessing/proc/bless(atom/cast_on) // newer addition: manage dream fragments
	var/datum/component/dream_fragment/current_fragment = owner.GetComponent(/datum/component/dream_fragment)
	if(!current_fragment)
		to_chat(owner, span_warning("I don't have a remembered fragment of dream to bestow! I may find one in the depths of dream..."))
		return FALSE
	if(!ishuman(cast_on) || cast_on == owner) // cast on yourself, or an invalid target: remember your current dream fragment, but don't gain any buffs or consume it
		to_chat(owner, span_info("I slip into a brief waking dream, recalling my tightly-held fragment..."))
		to_chat(owner, span_purple(current_fragment.dream_text))
		return FALSE // no cooldown/cost for just recalling your fragment
	else // cast on a humanmob: give them the buff
		var/mob/living/carbon/human/H = cast_on
		if(H.cmode)
			to_chat(owner, span_warning("They are too tense!"))
			return FALSE
		cast_on.TakeComponent(current_fragment)
		return TRUE

/datum/action/cooldown/spell/ink_blessing/get_adjusted_cooldown()
	. = ..()
	. *= temp_cooldown_multiplier
	temp_cooldown_multiplier = 1.0

// better version of call dreamfiend, also /action/cooldown ified; their only actually-dangerous combat miracle. can be given basic commands via pointing, and dismissed, unlike the non-painter dreamfiends
/datum/action/cooldown/spell/wake_dreamfiend
	name = "Wake Dreamfiend"
	desc = "Summons a Dreamfiend to hound your target. Its power depends on your connection to the depths: Heretics and the Bishop will call stronger fiends than Acolytes or Missionaries. Point in combat mode to change its target; cast the spell again to banish it. The cooldown starts once it dies or is banished."
	button_icon = 'icons/mob/actions/abyssormiracles.dmi'
	background_icon = 'icons/mob/actions/abyssormiracles.dmi'
	button_icon_state = "dreamfiend"
	cast_range = 7
	charge_time = CHARGETIME_MAJOR
	sound = 'sound/foley/bubb (1).ogg'
	invocations = list("Wake the dream, consume what Is!") // differentiate from normal call dreamfiend
	invocation_type = INVOCATION_SHOUT
	cooldown_time = 10 MINUTES // twice normal call dreamfiend, plus it only starts once the fiend is gone
	spell_color = "#125a00"

	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = SPELLCOST_MIRACLE_LEGENDARY
	secondary_resource_type = SPELL_COST_ENERGY // yes, energy, not stamina. this is a decently big deal and your only real combat miracle
	secondary_resource_cost = SPELLCOST_MAJOR_SUMMON

	// Teleport parameters
	var/inner_tele_radius = 1
	var/outer_tele_radius = 2
	var/include_dense = FALSE
	var/include_teleport_restricted = FALSE

	var/mob/living/simple_animal/hostile/rogue/dreamfiend/fiend
	var/static/list/ancient_roles = list("Bishop")
	var/static/list/ancient_advjobs = list("Heretic", "Heretic Spy")

/datum/action/cooldown/spell/wake_dreamfiend/cast(atom/cast_on)
	. = ..()
	if(fiend)
		fiend.visible_message(span_notice("\The [fiend] <i>snaps</i> out of reality as it is forcibly banished!"))
		QDEL_NULL(fiend)
		UnregisterSignal(owner, COMSIG_MOB_POINTED)
		StartCooldown()
		return FALSE

	var/mob/living/carbon/human/H = owner
	if(!ishuman(owner))
		return FALSE
	var/mob/living/target = cast_on
	RegisterSignal(owner, COMSIG_MOB_POINTED, PROC_REF(handle_point))

	if(!istype(target) || target.stat == DEAD)
		to_chat(owner, span_warning("This spell only works on lyving creatures!"))
		return FALSE

	fiend = summon_dreamfiend(
		target = target,
		user = owner,
		F = ((H.job in ancient_roles) || (H.advjob in ancient_advjobs)) ? /mob/living/simple_animal/hostile/rogue/dreamfiend/ancient/summoned : /mob/living/simple_animal/hostile/rogue/dreamfiend/major,
		outer_tele_radius = outer_tele_radius,
		inner_tele_radius = inner_tele_radius,
		include_dense = FALSE,
		include_teleport_restricted = FALSE
	)
	if(!fiend)
		to_chat(owner, span_warning("No valid space to manifest the dreamfiend!"))
		return FALSE
	ADD_TRAIT(fiend, TRAIT_INK_AFFINITY, TRAIT_MIRACLE) // it's a friend!
	RegisterSignal(fiend, COMSIG_MOB_DEATH, PROC_REF(handle_death))
	RegisterSignal(fiend, COMSIG_QDELETING, PROC_REF(handle_death)) // despite the name this is a generic proc for 'the fiend is gone'; if it vanishes on its own it gets qdel'd without calling death()
	spell_feedback(owner)
	return FALSE // we only start the cooldown once the fiend dies or is dismissed; however we want the invocation to happen here

/datum/action/cooldown/spell/wake_dreamfiend/proc/handle_point(mob/living/carbon/human/source, atom/target)
	SIGNAL_HANDLER
	if(fiend && isliving(target) && source.cmode)
		fiend.visible_message(span_warning("[fiend] abruptly changes targets, lunging at [target]!"))
		fiend.stop_all_doing()
		fiend.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
		fiend.ai_controller.set_blackboard_key(BB_MAIN_TARGET, target)
		fiend.ai_controller.insert_blackboard_key_lazylist(BB_BASIC_MOB_RETALIATE_LIST, target)

/datum/action/cooldown/spell/wake_dreamfiend/proc/handle_death()
	SIGNAL_HANDLER
	UnregisterSignal(owner, COMSIG_MOB_POINTED)
	fiend = null
	StartCooldown()

/datum/action/cooldown/spell/undine_projection
	name = "Undine Projection"
	desc = "Submerge yourself in water to reach through the Dream, projecting yourself into a body of water nearby a known target as a water spirit. The projection is fragile, and cannot move outside of water; nor can it deliver dream visions directly. Resist (bound to X by default) to return to your body."
	button_icon = 'icons/mob/actions/abyssormiracles.dmi'
	background_icon = 'icons/mob/actions/abyssormiracles.dmi'
	button_icon_state = "paint_infusion"
	sound = 'sound/magic/abyssor_splash.ogg'
	spell_color = "#330066"

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP // it's a t4, but you're also... knocking yourself out to use it and leaving your body defenseless. idt the stamcost matters here

	invocations = list(
		"O'khor, will of the waves!",
		"Thal'ass, shape the sea!",
		"Kyma'tist, the abyss sees all!"
	)
	invocation_type = INVOCATION_SHOUT
	charge_required = TRUE
	charge_time = 1.5 SECONDS
	cooldown_time = 45 SECONDS
	devotion_cost = 100
	associated_skill = /datum/skill/magic/holy

/datum/action/cooldown/spell/undine_projection/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!user || !user.mind)
		return FALSE

	if(!istype(get_turf(user), /turf/open/water))
		to_chat(user, span_warning("I must stand within the waves to reach the depths!"))
		return FALSE

	if(!user.mind.known_people.len)
		to_chat(user, span_warning("I don't know anyone."))
		return FALSE

	var/list/eligible_players = list()
	for(var/people in user.mind.known_people)
		eligible_players += people
	eligible_players = sortList(eligible_players)

	var/input = tgui_input_list(user, "Who do you wish to find?", "Projection", eligible_players)
	if(isnull(input))
		to_chat(user, span_warning("No target selected."))
		return FALSE

	var/turf/open/water/target_turf
	main_loop:
		for(var/mob/living/carbon/human/HL in GLOB.human_list)
			if(HL.real_name != input)
				continue
			for(var/turf/open/water/candidate in view(7, get_turf(HL)))
				target_turf = candidate
				break main_loop
	if(!target_turf)
		to_chat(user, span_warning("[input] is not near any water, I cannot reach them..."))
		return FALSE

	unset_click_ability(user) // otherwise our click intercept sticks around and causes issues
	return !!create_undine(user, target_turf)

/proc/create_undine(mob/living/carbon/human/user, turf/target_turf)
	if(!user.mind?.active || HAS_TRAIT(user, TRAIT_POSSESSED))
		return FALSE
	var/mob/living/simple_animal/undine/projection = new /mob/living/simple_animal/undine(target_turf)
	var/tmpdir = user.dir
	user.setDir(SOUTH)
	var/mutable_appearance/ico = new(user.appearance)
	user.setDir(tmpdir)
	user.set_resting(TRUE, TRUE)
	ico.color = "#6a9295"
	ico.alpha = 200 // watery effect without being TOO hard to see
	projection.appearance = ico
	var/datum/language_holder/lang = user.mind.get_language_holder()
	projection.name = user.get_unmasked_name()
	projection.key = user.key
	projection.original_body = user
	var/datum/mind/undine_mind = projection.mind
	if(undine_mind)
		var/datum/language_holder/proj_lang = undine_mind.get_language_holder()
		proj_lang.copy_known_languages_from(lang)
		undine_mind.AddSpell(new /datum/action/cooldown/spell/undine_teleport, projection)
		undine_mind.AddSpell(new /datum/action/cooldown/spell/projectile/waterbolt/undine, projection)
	projection.RegisterSignal(user, COMSIG_QDELETING, TYPE_PROC_REF(/mob/living/simple_animal/undine, entrap_spirit))
	projection.RegisterSignal(projection, COMSIG_MOB_DEATH, TYPE_PROC_REF(/mob/living/simple_animal/undine, come_back))
	projection.RegisterSignal(projection, COMSIG_LIVING_RESIST, TYPE_PROC_REF(/mob/living/simple_animal/undine, come_back))
	projection.RegisterSignal(user, COMSIG_MOB_DEATH, TYPE_PROC_REF(/mob/living/simple_animal/undine, alert_death))
	projection.desc = "A water spirit shaped by an Abyssorite's will. It looks fragile." // idk why this is being overridden to null if it's done any earlier
	return projection

/mob/living/simple_animal/undine
	real_name = "Undine"
	maxHealth = 1
	health = 1
	pass_flags = PASS_ALL // can't leave the water, but bars/grates won't stop you
	base_intents = list(INTENT_HELP, INTENT_GRAB)
	dextrous = TRUE
	cmode = FALSE
	var/last_tochat
	var/mob/living/carbon/human/original_body

/mob/living/simple_animal/undine/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_TRAM_MOVER, TRAIT_MIRACLE) // this prevents movement slowdown from water. that's all it does.
	RegisterSignal(src, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(handle_move))

/mob/living/simple_animal/undine/ConveyorMove() // they can only be in water, so this is a river; and as a water spirit they should not be washed away by rivers!
	return

/mob/living/simple_animal/undine/proc/handle_move(mob/source, newloc)
	SIGNAL_HANDLER
	if(!istype(newloc, /turf/open/water))
		if(world.time > (last_tochat + 10 SECONDS))
			to_chat(src, span_warning("I can't leave the water!"))
			last_tochat = world.time
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE

// if your main body gets actually deleted - like, through being gibbed - your undine can no longer die. this is to prevent someone whacking you and sending you to the no body zone
// this is at the cost of being a water spirit forever. resisting will still ghost you, if you change your mind about the whole "eternally bound river spirit" thing
/mob/living/simple_animal/undine/proc/entrap_spirit()
	status_traits |= GODMODE

/mob/living/simple_animal/undine/proc/alert_death()
	to_chat(src, span_danger("My link to my body fades, its lyfeforce vanishing. To dissolve my current form would surely kill me in truth."))

/mob/living/simple_animal/undine/proc/come_back()
	if(original_body && key)
		original_body.key = key
	visible_message(span_warning("[src] collapses, leaving naught but a splash of water in its wake..."))
	playsound(get_turf(src), 'sound/magic/abyssor_splash.ogg', 70, TRUE)
	drop_all_held_items()
	qdel(src)

/mob/living/simple_animal/undine/update_sneak_invis(reset = FALSE)
	return // don't fucking remove our translucency???

/datum/action/cooldown/spell/projectile/waterbolt/undine
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE

/datum/action/cooldown/spell/undine_teleport
	name = "Abyssal Jaunt"
	desc = "Slip beneath the waves through the Dream but for a moment, emerging in a nearby pool of water."

	button_icon = 'icons/mob/actions/abyssormiracles.dmi'
	background_icon = 'icons/mob/actions/abyssormiracles.dmi'
	button_icon_state = "paint_infusion"
	sound = 'sound/magic/abyssor_splash.ogg'
	spell_color = "#330066"

	cooldown_time = 1 SECONDS

	charge_required = TRUE
	charge_time = 1.5 SECONDS

	primary_resource_type = SPELL_COST_NONE
	spell_requirements = NONE
	spell_impact_intensity = SPELL_IMPACT_NONE

/datum/action/cooldown/spell/undine_teleport/cast(atom/cast_on)
	. = ..()
	var/turf/open/water/target_turf = get_turf(cast_on)
	if(!istype(target_turf))
		to_chat(owner, span_warning("I can only jaunt to water!"))
		return FALSE
	var/mob/living/simple_animal/undine/projection = owner
	projection.visible_message(span_warning("[projection] dives beneath the waves!"), span_info("I dive beneath the waves..."))
	projection.forceMove(target_turf)
	projection.visible_message(span_warning("[projection] emerges from beneath the waves!"), span_info("...and emerge somewhere else!"))
	return TRUE

// DREAM RITUAL ONLY SPELLS
/datum/action/cooldown/spell/oneiric_sanctuary
	name = "Oneiric Sanctuary"
	desc = "Invoke the right of sanctuary, bargained for with a great Leviathan. Draws both you and a grabbed, consenting target into a reasonably safe portion of the the Divine Dream for a private meeting."

	invocations = list(",qO Leviathan, I invoke the right of sanctuary!") // this technically breaks the 'no invocations in other languages' rule but it is very obvious what's happened. nothing else in the game looks like someone getting abyssordreamed; also it's not a combat miracle
	invocation_type = INVOCATION_SHOUT

	button_icon = 'icons/mob/actions/abyssormiracles.dmi'
	background_icon = 'icons/mob/actions/abyssormiracles.dmi'
	button_icon_state = "deepheal"
	sound = 'sound/magic/abyssor_splash.ogg'
	spell_color = "#330066"

	click_to_activate = FALSE
	self_cast_possible = TRUE
	charge_required = FALSE
	cooldown_time = 1 SECONDS

	primary_resource_type = SPELL_COST_NONE
	spell_requirements = SPELL_REQUIRES_HUMAN
	spell_impact_intensity = SPELL_IMPACT_NONE

/datum/action/cooldown/spell/oneiric_sanctuary/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	var/obj/item/grabbing/grab = locate() in H.held_items
	if(!grab || !grab.grabbed || !ishuman(grab.grabbed))
		to_chat(H, span_warning("I must be grabbing someone to pull into the Dream!"))
		return FALSE
	var/mob/living/carbon/human/target = grab.grabbed
	if(H.cmode || target.cmode)
		to_chat(H, span_warning("[H.cmode ? "I am" : "they are"] too tense!"))
		return FALSE
	if(alert(target, "You feel a tug from [H]... do you wish to enter the Divine Dream?", "THE ABYSS YAWNS", "Yes", "No") != "Yes")
		to_chat(H, span_warning("[target] resists!"))
		return FALSE
	teleport_to_dream(H, force = TRUE, silent = TRUE, weapons = FALSE)
	teleport_to_dream(target, force = TRUE, silent = TRUE, weapons = FALSE)

	addtimer(CALLBACK(src, PROC_REF(self_consume), H), 1)
	return TRUE

/datum/action/cooldown/spell/oneiric_sanctuary/proc/self_consume(mob/living/L)
	if(L?.mind)
		L.mind.RemoveSpell(src)

/obj/item/abyssal_talisman
	name = "Abyssal Talisman"
	desc = "A strange trinket crafted by an Abyssorite. It is perpetually damp, and yearns to return to the sea."
	w_class = WEIGHT_CLASS_TINY
	icon = 'icons/mob/actions/abyssormiracles.dmi'
	icon_state = "bends"
	var/mob/living/carbon/human/creator
	var/turf/valid_turf_type = /turf/open/water/ocean

/obj/item/abyssal_talisman/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Throw this into [valid_turf_type::name] to summon [creator || "its creator"]'s spirit.")

/obj/item/abyssal_talisman/greater
	name = "Greater Abyssal Talisman"
	desc = "A strange trinket crafted by an Abyssorite. It is perpetually damp, and is inexorably drawn towards water."
	valid_turf_type = /turf/open/water

/obj/item/abyssal_talisman/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(!creator || !istype(get_turf(src), valid_turf_type))
		return
	var/turf/origin = get_turf(creator)
	if(alert(creator, "You feel a your spirit tugged towards the waves - will you answer the call of your talisman?", "THE WAVES SWELL", "Yes", "No") != "No" && create_undine(creator, get_turf(src)))
		origin.visible_message(span_warning("[creator] vanishes into the scent of the sea!"))
		qdel(src)
	else
		visible_message(span_info("The talisman remains silent, its call unanswered."))
