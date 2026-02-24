#define TARGET_CLOSEST 1
#define TARGET_RANDOM 2
#define MAGIC_XP_MULTIPLIER 0.3 //used to miltuply the amount of xp gained from spells
#define SPELL_SCALING_THRESHOLD 10 // The threshold at which the spell scaling starts to kick in
#define SPELL_POSITIVE_SCALING_THRESHOLD 15 // The threshold at which spell scaling stop
#define FATIGUE_REDUCTION_PER_INT 0.05 // The amount of fatigue reduction per point of intelligence above / below threshold
#define COOLDOWN_REDUCTION_PER_INT 0.05 // The amount of cooldown reduction per point of intelligence above / below threshold
#define CHARGE_REDUCTION_PER_SKILL 0.05 // The amount of charge reduction per skill level.
#define FATIGUE_REDUCTION_PER_SKILL 0.05 // The amount of fatigue reduction per skill level.

/obj/effect/proc_holder
	var/panel = "Debug"//What panel the proc holder needs to go on.
	var/active = FALSE //Used by toggle based abilities.
	var/ranged_mousepointer
	var/mob/living/ranged_ability_user
	var/ranged_clickcd_override = -1
	var/has_action = TRUE
	var/datum/action/spell_action/action = null
	var/action_icon = 'icons/mob/actions/actions_spells.dmi'
	var/action_icon_state = "spell_default"
	var/action_background_icon_state = "bg_spell"
	var/base_action = /datum/action/spell_action
	var/releasedrain = 0
	var/chargedrain = 0
	var/chargetime = 0
	var/vitaedrain = 0 //for vamp spells
	var/warnie = "mobwarning"
	var/list/charge_invocation
	var/no_early_release = FALSE //we can't shoot off early
	var/movement_interrupt = FALSE //we cancel charging when changing mob direction, for concentration spells
	var/chargedloop = null
	var/charging_slowdown = 0
	var/obj/inhand_requirement = null
	var/overlay_state = null
	var/overlay_alpha = 255
	var/ignore_los = TRUE
	var/glow_intensity = 0 // How much does the user glow when using the ability
	var/glow_color = null // The color of the glow
	var/hide_charge_effect = FALSE // If true, will not show the spell's icon when charging 
	/// This spell holder's cooldown does not scale with any stat
	var/is_cdr_exempt = FALSE
	var/obj/effect/mob_charge_effect = null

	/// This "spell" (miracle) is excluded from Priest's round-start selection.
	var/priest_excluded = FALSE

	var/skipcharge = FALSE

/obj/effect/proc_holder/Initialize()
	. = ..()
	if(has_action)
		action = new base_action(src)
	if(overlay_state && !hide_charge_effect)
		var/obj/effect/R = new /obj/effect/spell_rune
		R.icon = action_icon
		R.icon_state = overlay_state // Weird af but that's how spells work???
		action.overlay_alpha = overlay_alpha
		mob_charge_effect = R
	update_icon()

/obj/effect/proc_holder/proc/deactivate(mob/living/user)
	if(active)
		active = FALSE
	remove_ranged_ability()

/obj/effect/proc_holder/proc/on_gain(mob/living/user)
	return

/obj/effect/proc_holder/proc/on_lose(mob/living/user)
	return

/obj/effect/proc_holder/proc/fire(mob/living/user)
	return TRUE

/obj/effect/proc_holder/proc/get_panel_text()
	return ""

/obj/effect/proc_holder/proc/get_chargetime()
	return chargetime

/obj/effect/proc_holder/proc/get_fatigue_drain()
	return releasedrain

GLOBAL_LIST_INIT(spells, typesof(/obj/effect/proc_holder/spell)) //needed for the badmin verb for now

/obj/effect/proc_holder/Destroy()
	if (action)
		qdel(action)
	if(ranged_ability_user)
		remove_ranged_ability()
	return ..()

/obj/effect/proc_holder/proc/InterceptClickOn(mob/living/caller, params, atom/A)
	var/list/modifiers = params2list(params)
	if(!modifiers["middle"])
		return TRUE

	if(caller.ranged_ability != src || ranged_ability_user != caller) //I'm not actually sure how these would trigger, but, uh, safety, I guess?
		to_chat(caller, span_info("<b>[caller.ranged_ability.name]</b> has been disabled."))
		caller.ranged_ability.remove_ranged_ability()
		return TRUE //TRUE for failed, FALSE for passed.
	if(ranged_clickcd_override >= 0)
		ranged_ability_user.next_click = world.time + ranged_clickcd_override
	else
		ranged_ability_user.next_click = world.time + CLICK_CD_CLICK_ABILITY
	ranged_ability_user.face_atom(A)
	return FALSE

/obj/effect/proc_holder/proc/add_ranged_ability(mob/living/user, msg, forced)
	if(!user || !user.client)
		return
	if(user.ranged_ability && user.ranged_ability != src)
		if(forced)
//			to_chat(user, span_info("<b>[user.ranged_ability.name]</b> has been replaced by <b>[name]</b>."))
			user.ranged_ability.deactivate(user)
		else
			return
	user.ranged_ability = src
	ranged_ability_user = user
	user.click_intercept = src
	user.update_mouse_pointer()
	user.mmb_intent_change(QINTENT_SPELL)

	if(msg)
		to_chat(ranged_ability_user, msg)
	update_icon()

/obj/effect/proc_holder/proc/remove_ranged_ability(msg)
	if(!ranged_ability_user || !ranged_ability_user.client || (ranged_ability_user.ranged_ability && ranged_ability_user.ranged_ability != src)) //To avoid removing the wrong ability
		return
	ranged_ability_user.ranged_ability = null

	ranged_ability_user.click_intercept = null
	ranged_ability_user.update_mouse_pointer()
	ranged_ability_user.mmb_intent_change(null)

	if(msg)
		to_chat(ranged_ability_user, msg)
	ranged_ability_user = null
	update_icon()

/obj/effect/proc_holder/spell
	name = "Spell"
	desc = ""
	panel = "Spells"
	var/sound = null //The sound the spell makes when it is cast
	anchored = TRUE // Crap like fireball projectiles are proc_holders, this is needed so fireballs don't get blown back into your face via atmos etc.
	pass_flags = PASSTABLE
	density = FALSE
	opacity = 0

	var/cost = 0 //how many points it costs to learn this spell
	var/xp_gain = FALSE

	var/school = "evocation" //not relevant at now, but may be important later if there are changes to how spells work. the ones I used for now will probably be changed... maybe spell presets? lacking flexibility but with some other benefit?

	var/charge_type = "recharge" //can be recharge or charges, see recharge_time and charge_counter descriptions; can also be based on the holder's vars now, use "holder_var" for that

	var/recharge_time = 50 //recharge time in deciseconds if charge_type = "recharge" or starting charges if charge_type = "charges"
	var/charge_counter = 0 //can only cast spells if it equals recharge, ++ each decisecond if charge_type = "recharge" or -- each cast if charge_type = "charges"
	var/last_process_time = 0 //tracks world.time of last process() call for delta-time cooldown
	var/still_recharging_msg = span_info("The spell is still recharging.")

	var/cast_without_targets = FALSE

	var/holder_var_type = "bruteloss" //only used if charge_type equals to "holder_var"
	var/holder_var_amount = 20 //same. The amount adjusted with the mob's var when the spell is used

	var/clothes_req = FALSE //see if it requires clothes
	var/human_req = FALSE //spell can only be cast by humans
	var/nonabstract_req = FALSE //spell can only be cast by mobs that are physical entities
	var/stat_allowed = FALSE //see if it requires being conscious/alive, need to set to 1 for ghostpells
	var/phase_allowed = FALSE // If true, the spell can be cast while phased, eg. blood crawling, ethereal jaunting
	var/antimagic_allowed = FALSE // If false, the spell cannot be cast while under the effect of antimagic
	var/list/invocations = list() //what is uttered when the wizard casts the spell
	var/invocation_emote_self = null
	var/invocation_type = "none" //can be none, whisper, emote and shout
	var/range = 7 //the range of the spell; outer radius for aoe spells
	var/message = "" //whatever it says to the guy affected by it
	var/selection_type = "view" //can be "range" or "view"
	var/cooldown_min = 0 //This defines what spell quickened four times has as a cooldown. Make sure to set this for every spell
	var/player_lock = TRUE //If it can be used by simple mobs
	var/gesture_required = FALSE // Can it be cast while cuffed? Rule of thumb: Offensive spells + Mobility cannot be cast
	var/spell_tier = 1 // Tier of the spell, used to determine whether you can learn it based on your spell. Starts at 1.
	var/refundable = FALSE // If true, the spell can be refunded. This is modified at the point it is added to the user's mind by learnspell.
	var/zizo_spell = FALSE // If this spell is fucked up & evil and can only be learned by heretics.

	var/overlay = 0
	var/overlay_icon = 'icons/obj/wizard.dmi'
	var/overlay_icon_state = "spell"
	var/overlay_lifespan = 0

	var/sparks_spread = 0
	var/sparks_amt = 0 //cropped at 10
	var/smoke_spread = 0 //1 - harmless, 2 - harmful
	var/smoke_amt = 0 //cropped at 10

	var/centcom_cancast = TRUE //Whether or not the spell should be allowed on z2

	var/list/req_items = list()		//required worn items to cast
	var/req_inhand = null			//required inhand to cast
	var/base_icon_state = "spell"
	var/associated_skill = /datum/skill/magic/arcane
	var/miracle = FALSE
	var/devotion_cost = 0
	var/ignore_cockblock = FALSE //whether or not to ignore TRAIT_SPELLCOCKBLOCK
	action_icon_state = "spell0"
	action_icon = 'icons/mob/actions/roguespells.dmi'
	action_background_icon_state = ""
	base_action = /datum/action/spell_action/spell

/obj/effect/proc_holder/spell/get_chargetime()
	if(ranged_ability_user && chargetime)
		return calculate_chargetime(ranged_ability_user)
	return chargetime

/obj/effect/proc_holder/spell/get_fatigue_drain()
	if(ranged_ability_user && releasedrain)
		return calculate_fatigue_drain(ranged_ability_user)
	return releasedrain

/obj/effect/proc_holder/spell/proc/calculate_chargetime(mob/living/user)
	if(!user || !chargetime)
		return chargetime
	var/newtime = chargetime
	//skill block
	newtime = newtime - (chargetime * (user.get_skill_level(associated_skill) * CHARGE_REDUCTION_PER_SKILL))
	//spellbook cast time reduction
	var/obj/item/book/spellbook/sbook = user.is_holding_item_of_type(/obj/item/book/spellbook)
	if(sbook && sbook?.open)
		newtime = newtime - (chargetime * (sbook.get_castred()))
	//staff cast time reduction
	var/obj/item/rogueweapon/staff = user.is_holding_item_of_type(/obj/item/rogueweapon/)
	if(staff && staff.cast_time_reduction)
		newtime = newtime - (chargetime * (staff.cast_time_reduction))
	if(newtime > 0)
		return newtime
	return 0.1

/obj/effect/proc_holder/spell/proc/calculate_fatigue_drain(mob/living/user)
	if(!user || !releasedrain)
		return releasedrain
	var/newdrain = releasedrain
	//skill block
	newdrain = newdrain - (releasedrain * (user.get_skill_level(associated_skill) * FATIGUE_REDUCTION_PER_SKILL))
	//int block
	if(user.STAINT > SPELL_SCALING_THRESHOLD)
		var/diff = min(user.STAINT, SPELL_POSITIVE_SCALING_THRESHOLD) - SPELL_SCALING_THRESHOLD
		newdrain = newdrain - (releasedrain * diff * FATIGUE_REDUCTION_PER_INT)
	else if(user.STAINT < 10)
		var/diffy = SPELL_SCALING_THRESHOLD - user.STAINT
		newdrain = newdrain + (releasedrain * (diffy * FATIGUE_REDUCTION_PER_INT))
	if(!user.check_armor_skill())
		newdrain += 80
	if(newdrain > 0)
		return newdrain
	return 0.1

/obj/effect/proc_holder/spell/proc/calculate_cooldown(mob/living/user)
	if(!user || is_cdr_exempt)
		return initial(recharge_time)
	var/base = initial(recharge_time)
	if(user.STAINT > SPELL_SCALING_THRESHOLD)
		var/diff = min(user.STAINT, SPELL_POSITIVE_SCALING_THRESHOLD) - SPELL_SCALING_THRESHOLD
		return base - (base * diff * COOLDOWN_REDUCTION_PER_INT)
	else if(user.STAINT < SPELL_SCALING_THRESHOLD)
		var/diff2 = SPELL_SCALING_THRESHOLD - user.STAINT
		return base + (base * (diff2 * COOLDOWN_REDUCTION_PER_INT))
	return base

/obj/effect/proc_holder/spell/proc/get_spell_statistics(mob/living/user)
	var/list/stats = list()
	if(range)
		stats += span_info("Range: [range] tiles")
	var/base_ct = chargetime
	if(base_ct > 0)
		var/dynamic_ct = user ? calculate_chargetime(user) : base_ct
		if(dynamic_ct != base_ct)
			stats += span_info("Charge time: [DisplayTimeText(base_ct)] (current: [DisplayTimeText(dynamic_ct)])")
		else
			stats += span_info("Charge time: [DisplayTimeText(base_ct)]")
	else
		stats += span_info("Charge time: None")
	var/base_cd = initial(recharge_time)
	if(base_cd)
		var/dynamic_cd = user ? calculate_cooldown(user) : base_cd
		if(dynamic_cd != base_cd)
			stats += span_info("Cooldown: [DisplayTimeText(base_cd)] (current: [DisplayTimeText(dynamic_cd)])")
		else
			stats += span_info("Cooldown: [DisplayTimeText(base_cd)]")
	var/base_fd = releasedrain
	if(base_fd > 0)
		var/dynamic_fd = user ? calculate_fatigue_drain(user) : base_fd
		if(dynamic_fd != base_fd)
			stats += span_info("Stamina cost: [base_fd] (current: [dynamic_fd])")
		else
			stats += span_info("Stamina cost: [base_fd]")
	return stats

/obj/effect/proc_holder/spell/proc/cast_check(skipcharge, mob/user = usr) //checks if the spell can be cast based on its settings; skipcharge is used when an additional cast_check is called inside the spell
	if(player_lock)
		if(!user.mind || !(src in user.mind.spell_list) && !(src in user.mob_spell_list))
			to_chat(user, span_warning("I shouldn't have this spell! Something's wrong..."))
			return FALSE
	else
		if(!(src in user.mob_spell_list))
			return FALSE

	var/turf/T = get_turf(user)
	if(is_centcom_level(T.z) && !centcom_cancast) //Certain spells are not allowed on the centcom zlevel
		to_chat(user, span_warning("I can't cast this spell here!"))
		return FALSE

	if(!charge_check(user))
		return FALSE

	if(user.stat && !stat_allowed)
		to_chat(user, span_warning("Not when I am incapacitated!"))
		return FALSE

	if(!ignore_cockblock && HAS_TRAIT(user, TRAIT_SPELLCOCKBLOCK))
		to_chat(user, span_warning("I can't cast spells!"))
		return FALSE

	if(HAS_TRAIT(user, TRAIT_CURSE_NOC))
		to_chat(user, span_warning("My magicka has left me..."))
		return FALSE

	if(!antimagic_allowed)
		var/antimagic = user.anti_magic_check(TRUE, FALSE, FALSE, 0, TRUE)
		if(antimagic)
			if(isatom(antimagic))
				to_chat(user, span_info("[antimagic] is interfering with my magic."))
			else
				to_chat(user, span_warning("Magic seems to flee from you, you can't gather enough power to cast this spell."))
			return FALSE

	if(!phase_allowed && istype(user.loc, /obj/effect/dummy))
		to_chat(user, span_warning("[name] cannot be cast unless I am completely manifested in the material plane!"))
		return FALSE

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if((invocation_type == "whisper" || invocation_type == "shout") && (!H.can_speak_vocal() || !H.getorganslot(ORGAN_SLOT_TONGUE)))
			to_chat(user, span_warning("I can't get the words out!"))
			return FALSE

		if(HAS_TRAIT(H, TRAIT_PARALYSIS) && !stat_allowed)
			to_chat(user, span_warning("My body is paralyzed!"))
			return FALSE

		if(miracle && !H.devotion?.check_devotion(src))
			to_chat(H, span_warning("I don't have enough devotion!"))
			return FALSE
		if(gesture_required)
			if(H.handcuffed)
				to_chat(user, span_warning("[name] cannot be cast with my hands tied up!"))
				return FALSE
			if(!H.has_active_hand())
				to_chat(user, span_warning("I can't cast this without functional hands!"))
				return FALSE

	else
		if(clothes_req || human_req)
			to_chat(user, span_warning("This spell can only be cast by humans!"))
			return FALSE
		if(nonabstract_req && (isbrain(user)))
			to_chat(user, span_warning("This spell can only be cast by physical beings!"))
			return FALSE

	if(req_items.len)
		var/list/missing_names = list()
		var/met_requirement = FALSE
		for(var/I in req_items)
			met_requirement = FALSE
			for(var/obj/item/IN in user.contents)
				if(istype(IN, I))
					met_requirement = TRUE
					continue
			if(!met_requirement)
				var/obj/item/M = I
				missing_names.Add(M.name)
		if(!met_requirement)
			to_chat(user, span_warning("I'm missing [missing_names.Join(", ")] to cast this."))
			return FALSE

	if(req_inhand)
		if(!istype(user.get_active_held_item(), req_inhand))
			var/obj/item/M = req_inhand
			var/req_name = M.name
			to_chat(user, span_warning("I'm missing [req_name] in my hand to cast this."))
			return FALSE

	if(!skipcharge)
		switch(charge_type)
			if("recharge")
				charge_counter = 0 //doesn't start recharging until the targets selecting ends
				last_process_time = world.time
			if("charges")
				charge_counter-- //returns the charge if the targets selecting fails
			if("holdervar")
				adjust_var(user, holder_var_type, holder_var_amount)
	if(action)
		action.UpdateButtonIcon()
	START_PROCESSING(SSfastprocess, src)
	record_featured_stat(FEATURED_STATS_MAGES, user)
	return TRUE

/obj/effect/proc_holder/spell/proc/charge_check(mob/user)
	if(skipcharge)
		return TRUE
	switch(charge_type)
		if("recharge")
			if(charge_counter < recharge_time)
				to_chat(user, still_recharging_msg)
				return FALSE
		if("charges")
			if(!charge_counter)
				to_chat(user, span_warning("[name] has no charges left!"))
				return FALSE
	return TRUE

/obj/effect/proc_holder/spell/proc/invocation(mob/user = usr)
	if(!invocations || !invocations.len)
		return
	var/chosen_invocation = pick(invocations)
	switch(invocation_type)
		if("shout")
			if(prob(50))//Auto-mute? Fuck that noise
				user.say(chosen_invocation, forced = "spell")
			else
				user.say(chosen_invocation, forced = "spell")
		if("whisper")
			if(prob(50))
				user.whisper(chosen_invocation)
			else
				user.whisper(chosen_invocation)
		if("emote")
			var/emote_incantation = "<b>[usr.real_name]</b> [chosen_invocation]"
			user.visible_message(emote_incantation, emote_incantation) //this is stupid, but it works.

/obj/effect/proc_holder/spell/proc/playMagSound()
	var/ss = sound
	if(islist(sound))
		ss = pick(sound)
	playsound(get_turf(usr), ss,100,FALSE)

/obj/effect/proc_holder/spell/Initialize()
	. = ..()
	START_PROCESSING(SSfastprocess, src)

	still_recharging_msg = span_warning("[name] is still recharging!")
	charge_counter = recharge_time
	last_process_time = world.time

/obj/effect/proc_holder/spell/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	qdel(action)
	return ..()

/obj/effect/proc_holder/spell/Click()
	if(!cast_check())
		revert_cast()
		return FALSE
	choose_targets()
	return TRUE

/obj/effect/proc_holder/spell/proc/choose_targets(mob/user = usr) //depends on subtype - /targeted or /aoe_turf
	return

/obj/effect/proc_holder/spell/proc/can_target(mob/living/target)
	return TRUE

/obj/effect/proc_holder/spell/proc/start_recharge()
	var/old_recharge = recharge_time
	if(ranged_ability_user && !is_cdr_exempt)
		if(ranged_ability_user.STAINT > SPELL_SCALING_THRESHOLD)
			var/diff = min(ranged_ability_user.STAINT, SPELL_POSITIVE_SCALING_THRESHOLD) - SPELL_SCALING_THRESHOLD
			recharge_time = initial(recharge_time) - (initial(recharge_time) * diff * COOLDOWN_REDUCTION_PER_INT)
		else if(ranged_ability_user.STAINT < SPELL_SCALING_THRESHOLD)
			var/diff2 = SPELL_SCALING_THRESHOLD - ranged_ability_user.STAINT
			recharge_time = initial(recharge_time) + (initial(recharge_time) * (diff2 * COOLDOWN_REDUCTION_PER_INT))

	// If the spell was fully charged before recalculation, keep it fully charged
	if(charge_counter >= old_recharge && old_recharge > 0)
		charge_counter = recharge_time

	START_PROCESSING(SSfastprocess, src)

/obj/effect/proc_holder/spell/process()
	var/delta = world.time - last_process_time
	last_process_time = world.time
	if(charge_counter <= recharge_time) // Edge case when charge counter is set
		charge_counter += delta
		if(charge_counter >= recharge_time)
			charge_counter = recharge_time
			if(action?.button)
				action.button.update_maptext(0)
			action?.UpdateButtonIcon()
			STOP_PROCESSING(SSfastprocess, src)
			return
		if(action?.button)
			action.button.update_maptext(recharge_time - charge_counter)

/obj/effect/proc_holder/spell/proc/perform(list/targets, recharge = TRUE, mob/user = usr) //if recharge is started is important for the trigger spells
	if(!ignore_los)
		if(length(targets))
			var/radius
			if(range > 0)	//accounts for touch / self spells that use negative range
				radius = range
			else
				radius = 1
			if(get_dist(targets[1], user) > radius)
				to_chat(user, span_warning("It's too far!"))
				revert_cast()
				return
			var/atom/A = targets[1]
			var/turf/target_turf = get_turf(A)
			var/turf/source_turf = get_turf(user)
			if(A.z > user.z)
				source_turf = get_step_multiz(source_turf, UP)
			if(A.z < user.z)
				source_turf = get_step_multiz(source_turf, DOWN)
			if(!(target_turf in view(source_turf)))
				to_chat(user, span_warning("I do not have line of sight! Casting on nearest tile."))
				var/list/possible_targets = getline(source_turf, target_turf)
				for(var/i = possible_targets.len; i > 0; i--) // Since turfs added by the getline are in ordered by distance, we need to start from the end
					var/atom/closest_tile = possible_targets[i]
					if(closest_tile in view(source_turf))
						targets[1] = closest_tile
						break; // Found furthest tile, do not self-frag

	before_cast(targets, user = user)
	if(user && user.ckey)
		user.log_message(span_danger("cast the spell [name]."), LOG_ATTACK)
	if(user.mob_timers[MT_INVISIBILITY] > world.time)
		user.mob_timers[MT_INVISIBILITY] = world.time
		user.update_sneak_invis(reset = TRUE)
	if(isliving(user))
		var/mob/living/L = user
		if(L.rogue_sneaking)
			L.mob_timers[MT_FOUNDSNEAK] = world.time
			L.update_sneak_invis(reset = TRUE)
	if(cast(targets, user = user))
		invocation(user)
		start_recharge()
		if(sound)
			playMagSound()
		after_cast(targets, user = user)
		if(isliving(user))
			var/mob/living/L = user
			if(L.has_status_effect(/datum/status_effect/buff/clash))
				var/mob/living/carbon/human/H = user
				H.bad_guard(span_warning("I can't focus while casting spells!"), cheesy = TRUE)
		if(action)
			action.UpdateButtonIcon()
		return TRUE
	return FALSE

/obj/effect/proc_holder/spell/proc/before_cast(list/targets, mob/user = usr)
	if(!overlay)
		return
	for(var/atom/target in targets)
		var/location
		if(isliving(target))
			location = target.loc
		else if(isturf(target))
			location = target
		var/obj/effect/overlay/spell = new /obj/effect/overlay(location)
		spell.icon = overlay_icon
		spell.icon_state = overlay_icon_state
		spell.anchored = TRUE
		spell.density = FALSE
		QDEL_IN(spell, overlay_lifespan)

/obj/effect/proc_holder/spell/proc/cast(list/targets, mob/user = usr)
	record_featured_object_stat(FEATURED_STATS_SPELLS, name)
	return TRUE

/obj/effect/proc_holder/spell/proc/after_cast(list/targets, mob/user = usr)
	for(var/atom/target in targets)
		var/location
		if(isliving(target))
			location = target.loc
		else if(isturf(target))
			location = target
		if(isliving(target) && message)
			to_chat(target, text("[message]"))
		if(sparks_spread)
			do_sparks(sparks_amt, FALSE, location)
		if(smoke_spread)
			if(smoke_spread == 1)
				var/datum/effect_system/smoke_spread/smoke = new
				smoke.set_up(smoke_amt, location)
				smoke.start()
			else if(smoke_spread == 2)
				var/datum/effect_system/smoke_spread/bad/smoke = new
				smoke.set_up(smoke_amt, location)
				smoke.start()
			else if(smoke_spread == 3)
				var/datum/effect_system/smoke_spread/sleeping/smoke = new
				smoke.set_up(smoke_amt, location)
				smoke.start()
	if(devotion_cost && ishuman(user))
		var/mob/living/carbon/human/devotee = user
		devotee.devotion?.update_devotion(-devotion_cost)
		to_chat(devotee, "<font color='purple'>I [devotion_cost > 0 ? "lost" : "gained"] [abs(devotion_cost)] devotion.</font>")

	if(user.mmb_intent && user.mmb_intent.mob_light)
		QDEL_NULL(user.mmb_intent.mob_light)
	if(mob_charge_effect)
		QDEL_NULL(mob_charge_effect)

	START_PROCESSING(SSfastprocess, src) // ensure we always end up reprocessing after casting

/obj/effect/proc_holder/spell/proc/view_or_range(distance = world.view, center=usr, type="view")
	switch(type)
		if("view")
			. = view(distance,center)
		if("range")
			. = range(distance,center)

/obj/effect/proc_holder/spell/proc/revert_cast(mob/user = usr) //resets recharge or readds a charge
	start_recharge()
	switch(charge_type)
		if("recharge")
			charge_counter = recharge_time
		if("charges")
			charge_counter++
		if("holdervar")
			adjust_var(user, holder_var_type, -holder_var_amount)
	START_PROCESSING(SSfastprocess, src)
	if(action?.button)
		action.button.update_maptext(0)
		action.UpdateButtonIcon()
	if(user.mmb_intent && user.mmb_intent.mob_light)
		QDEL_NULL(user.mmb_intent.mob_light)

/obj/effect/proc_holder/spell/proc/adjust_var(mob/living/target = usr, type, amount) //handles the adjustment of the var when the spell is used. has some hardcoded types
	if (!istype(target))
		return
	switch(type)
		if("bruteloss")
			target.adjustBruteLoss(amount)
		if("fireloss")
			target.adjustFireLoss(amount)
		if("toxloss")
			target.adjustToxLoss(amount)
		if("oxyloss")
			target.adjustOxyLoss(amount)
		if("stun")
			target.AdjustStun(amount)
		if("knockdown")
			target.AdjustKnockdown(amount)
		if("paralyze")
			target.AdjustParalyzed(amount)
		if("immobilize")
			target.AdjustImmobilized(amount)
		if("unconscious")
			target.AdjustUnconscious(amount)
		else
			target.vars[type] += amount //I bear no responsibility for the runtimes that'll happen if you try to adjust non-numeric or even non-existent vars

/obj/effect/proc_holder/spell/targeted //can mean aoe for mobs (limited/unlimited number) or one target mob
	var/max_targets = 1 //leave 0 for unlimited targets in range, 1 for one selectable target in range, more for limited number of casts (can all target one guy, depends on target_ignore_prev) in range
	var/target_ignore_prev = 1 //only important if max_targets > 1, affects if the spell can be cast multiple times at one person from one cast
	var/include_user = 0 //if it includes usr in the target list
	var/random_target = 0 // chooses random viable target instead of asking the caster
	var/random_target_priority = TARGET_CLOSEST // if random_target is enabled how it will pick the target

/obj/effect/proc_holder/spell/aoe_turf //affects all turfs in view or range (depends)
	var/inner_radius = -1 //for all your ring spell needs

/obj/effect/proc_holder/spell/targeted/choose_targets(mob/user = usr)
	var/list/targets = list()

	switch(max_targets)
		if(0) //unlimited
			for(var/mob/living/target in view_or_range(range, user, selection_type))
				if(!can_target(target))
					continue
				targets += target
		if(1) //single target can be picked
			if(range < 0)
				targets += user
			else
				var/possible_targets = list()

				for(var/mob/living/M in view_or_range(range, user, selection_type))
					if(!include_user && user == M)
						continue
					if(!can_target(M))
						continue
					possible_targets += M

				//targets += input("Choose the target for the spell.", "Targeting") as mob in possible_targets
				//Adds a safety check post-input to make sure those targets are actually in range.
				var/mob/M
				if(!random_target)
					M = input("Choose the target for the spell.", "Targeting") as null|mob in sortNames(possible_targets)
				else
					switch(random_target_priority)
						if(TARGET_RANDOM)
							M = pick(possible_targets)
						if(TARGET_CLOSEST)
							for(var/mob/living/L in possible_targets)
								if(M)
									if(get_dist(user,L) < get_dist(user,M))
										if(los_check(user,L))
											M = L
								else
									if(los_check(user,L))
										M = L
				if(M in view_or_range(range, user, selection_type))
					targets += M

		else
			var/list/possible_targets = list()
			for(var/mob/living/target in view_or_range(range, user, selection_type))
				if(!can_target(target))
					continue
				possible_targets += target
			for(var/i=1,i<=max_targets,i++)
				if(!possible_targets.len)
					break
				if(target_ignore_prev)
					var/target = pick(possible_targets)
					possible_targets -= target
					targets += target
				else
					targets += pick(possible_targets)

	if(!include_user && (user in targets))
		targets -= user

	if(!targets.len && !cast_without_targets) //doesn't waste the spell
		revert_cast(user)
		return

	perform(targets,user=user)

/obj/effect/proc_holder/spell/aoe_turf/choose_targets(mob/user = usr)
	var/list/targets = list()

	for(var/turf/target in view_or_range(range,user,selection_type))
		if(!can_target(target))
			continue
		if(!(target in view_or_range(inner_radius,user,selection_type)))
			targets += target

	if(!targets.len) //doesn't waste the spell
		revert_cast()
		return

	perform(targets,user=user)

/obj/effect/proc_holder/spell/proc/updateButtonIcon(status_only, force)
	action.UpdateButtonIcon(status_only, force)

/obj/effect/proc_holder/spell/proc/can_be_cast_by(mob/caster)
	if((human_req || clothes_req) && !ishuman(caster))
		return 0
	return 1

/obj/effect/proc_holder/spell/proc/los_check(mob/A,mob/B)
	//Checks for obstacles from A to B
	var/obj/dummy = new(A.loc)
	dummy.pass_flags |= PASSTABLE
	for(var/turf/turf in getline(A,B))
		for(var/atom/movable/AM in turf)
			if(!AM.CanPass(dummy,turf,1))
				qdel(dummy)
				return 0
	qdel(dummy)
	return 1

/obj/effect/proc_holder/spell/proc/can_cast(mob/user = usr)
	if(((!user.mind) || !(src in user.mind.spell_list)) && !(src in user.mob_spell_list))
		return FALSE

	if(!charge_check(user))
		return FALSE

	if(user.stat && !stat_allowed)
		return FALSE

	if(!ignore_cockblock && HAS_TRAIT(user, TRAIT_SPELLCOCKBLOCK))
		return FALSE

	if(!antimagic_allowed && user.anti_magic_check(TRUE, FALSE, FALSE, 0, TRUE))
		return FALSE

	if(!ishuman(user))
		if(clothes_req || human_req)
			return FALSE
		if(nonabstract_req && (isbrain(user)))
			return FALSE

	if(ishuman(user)) // Make the button red out and unselectable
		var/mob/living/carbon/human/H = user
		if(gesture_required)
			if(H.handcuffed)
				return FALSE
			if(!H.has_active_hand())
				return FALSE
	
	if((invocation_type == "whisper" || invocation_type == "shout") && isliving(user))
		var/mob/living/living_user = user
		if(!living_user.can_speak_vocal())
			return FALSE
		if(ishuman(user) && !living_user.getorganslot(ORGAN_SLOT_TONGUE)) // Shapeshifter has no tongue yeah
			return FALSE

	if(HAS_TRAIT(user, TRAIT_PARALYSIS) && !stat_allowed)
		return FALSE

	return TRUE

/obj/effect/proc_holder/spell/self //Targets only the caster. Good for buffs and heals, but probably not wise for fireballs (although they usually fireball themselves anyway, honke)

/obj/effect/proc_holder/spell/self/choose_targets(mob/user = usr)
	if(!user)
		revert_cast()
		return
	perform(null,user=user)

/obj/effect/proc_holder/spell/self/basic_heal //This spell exists mainly for debugging purposes, and also to show how casting works
	name = "Lesser Heal"
	desc = ""
	human_req = TRUE
	clothes_req = FALSE
	recharge_time = 100
	invocations = list("Victus sano!")
	invocation_type = "whisper"
	school = "restoration"
	sound = 'sound/blank.ogg'

/obj/effect/proc_holder/spell/self/basic_heal/cast(mob/living/carbon/human/user) //Note the lack of "list/targets" here. Instead, use a "user" var depending on mob requirements.
	//Also, notice the lack of a "for()" statement that looks through the targets. This is, again, because the spell can only have a single target.
	user.visible_message(span_warning("A wreath of gentle light passes over [user]!"), span_info("I wreath myself in healing light!"))
	user.adjustBruteLoss(-10)
	user.adjustFireLoss(-10)

/// Helper for non-projectile spells. Call before applying effects to a target.
/// Returns TRUE if the target's Guard or parry buffer deflected the spell (skip this target).
/// Returns FALSE if the spell should proceed normally.
/// Usage in cast(): if(spell_guard_check(L)) continue
/obj/effect/proc_holder/spell/proc/spell_guard_check(mob/living/target, no_message = FALSE)
	if(!isliving(target))
		return FALSE
	// Check for active guard
	var/datum/status_effect/buff/clash/guard = target.has_status_effect(/datum/status_effect/buff/clash)
	if(guard)
		if(isarcyne(target))
			if(!no_message)
				target.visible_message(span_warning("[target] deflects [name] with a reactive ward!"))
				to_chat(target, span_notice("My ward deflects the incoming spell!"))
			playsound(get_turf(target), pick('sound/combat/parry/shield/magicshield (1).ogg', 'sound/combat/parry/shield/magicshield (2).ogg', 'sound/combat/parry/shield/magicshield (3).ogg'), 100)
		else
			if(!no_message)
				target.visible_message(span_warning("[target] deflects [name]!"))
				to_chat(target, span_notice("My guard deflects the incoming spell!"))
			var/obj/item/held = target.get_active_held_item()
			if(held?.parrysound)
				playsound(get_turf(target), pick(held.parrysound), 100)
			else
				playsound(get_turf(target), pick(target.parry_sound), 100)
		target.apply_status_effect(/datum/status_effect/buff/spell_parry_buffer)
		target.remove_status_effect(/datum/status_effect/buff/clash)
		return TRUE
	// Check for parry buffer (from a recent deflection) — silent, no chat spam for multi-hit spells
	if(target.has_status_effect(/datum/status_effect/buff/spell_parry_buffer))
		return TRUE
	return FALSE

#undef TARGET_CLOSEST
#undef TARGET_RANDOM
#undef MAGIC_XP_MULTIPLIER
#undef SPELL_SCALING_THRESHOLD
#undef SPELL_POSITIVE_SCALING_THRESHOLD
#undef FATIGUE_REDUCTION_PER_INT
#undef COOLDOWN_REDUCTION_PER_INT
#undef CHARGE_REDUCTION_PER_SKILL
#undef FATIGUE_REDUCTION_PER_SKILL
