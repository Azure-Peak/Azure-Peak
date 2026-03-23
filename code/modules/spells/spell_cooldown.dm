// /datum/action/cooldown/spell - Ported from Vanderlin
// This is the new spell system built on top of /datum/action/cooldown.
// We'll gradually move spells over to this new system to complete the job of nuking proc holder from our codebase
// Adapted for AP. No Mana or Attunement system because imo, 
// Attunement causes balance issues by varying effectiveness of spell dramatically based on caster's attunement
// And Mana is not necessary because we are going to stick with using blue / green bar to balance instead of a third bar and forcing long out of combat rest time that stacks on top of sleep based rest time. Just one system to KISS.

/**
 * # The spell action
 *
 * This is the base action for how many of the game's
 * spells (and spell adjacent) abilities function.
 * These spells function off of a cooldown-based system.
 *
 * ## Pre-spell checks:
 * - [can_cast_spell][/datum/action/cooldown/spell/can_cast_spell] checks if the OWNER
 * of the spell is able to cast the spell.
 * - [is_valid_target][/datum/action/cooldown/spell/is_valid_target] checks if the TARGET
 * THE SPELL IS BEING CAST ON is a valid target for the spell. NOTE: The CAST TARGET is often THE SAME as THE OWNER OF THE SPELL,
 * but is not always - depending on how [Pre Activate][/datum/action/cooldown/spell/PreActivate] is resolved.
 * - [can_invoke][/datum/action/cooldown/spell/can_invoke] is run in can_cast_spell to check if
 * the OWNER of the spell is able to say the current invocation.
 *
 * ## The spell chain:
 * - [before_cast][/datum/action/cooldown/spell/before_cast] is the last chance for being able
 * to interrupt a spell cast. This returns a bitflag. if SPELL_CANCEL_CAST is set, the spell will not continue.
 * - [spell_feedback][/datum/action/cooldown/spell/spell_feedback] is called right before cast, and handles
 * invocation and sound effects. Overridable, if you want a special method of invocation or sound effects,
 * or you want your spell to handle invocation / sound via special means.
 * - [cast][/datum/action/cooldown/spell/cast] is where the brunt of the spell effects should be done
 * and implemented.
 * - [after_cast][/datum/action/cooldown/spell/after_cast] is the aftermath - final effects that follow
 * the main cast of the spell. By now, the spell cooldown has already started
 *
 * ## Other procs called / may be called within the chain:
 * - [invocation][/datum/action/cooldown/spell/invocation] handles saying any vocal (or emotive) invocations the spell
 * may have, and can be overriden or extended. Called by spell_feedback.
 * - [reset_spell_cooldown][/datum/action/cooldown/spell/reset_spell_cooldown] is a way to handle reverting a spell's
 * cooldown and making it ready again if it fails to go off at any point. Not called anywhere by default. If you
 * want to cancel a spell in before_cast and would like the cooldown restart, call this.
 *
 */
/datum/action/cooldown/spell
	name = "Spell"
	desc = "A wizard spell."
	background_icon = 'icons/mob/actions/roguespells.dmi'
	background_icon_state = "spell0"
	base_background_icon_state = "spell0"
	active_background_icon_state = "spell1"
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "shieldsparkles"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_PHASED
	panel = "Spells"
	click_to_activate = TRUE

	/// Primary resource type: SPELL_COST_NONE, SPELL_COST_STAMINA, SPELL_COST_ENERGY, SPELL_COST_DEVOTION
	var/primary_resource_type = SPELL_COST_STAMINA
	/// Primary resource cost to cast.
	var/primary_resource_cost = 0
	/// Secondary resource type (optional, for dual-drain spells like miracles that cost devotion + stamina).
	var/secondary_resource_type = SPELL_COST_NONE
	/// Secondary resource cost to cast.
	var/secondary_resource_cost = 0
	/// Cost to learn this spell in the tree.
	var/point_cost = 0
	/// Tier of the spell, used to determine whether you can learn it based on class.
	var/spell_tier = 1
	/// If true, the spell can be refunded. Set by learnspell when learned.
	var/refundable = FALSE
	/// If set, the spell was learned from a pool-based system and should refund to this pool name.
	var/learned_from_pool
	/// If this spell is evil and can only be learned by heretics.
	var/zizo_spell = FALSE

	/// The sound played on cast.
	var/sound = 'sound/magic/whiteflame.ogg'

	/// What is uttered when the user casts the spell. Can be a list for random selection.
	var/list/invocations
	/// What is shown in chat when the user casts the spell, only matters for INVOCATION_EMOTE.
	var/invocation_self_message
	/// What type of invocation the spell is.
	/// Can be "none", "whisper", "shout", "emote".
	var/invocation_type = INVOCATION_NONE
	/// If invocation is set, do we ignore whether the user can actually speak?
	var/ignore_can_speak = FALSE

	/// Generic spell flags that may or may not be related to casting.
	var/spell_flags = NONE
	/// Flag for certain states that the spell requires the user be in to cast.
	var/spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	/// This determines what type of antimagic is needed to block the spell.
	/// If SPELL_REQUIRES_NO_ANTIMAGIC is set in Spell requirements,
	/// The spell cannot be cast if the caster has any of the antimagic flags set.
	var/antimagic_flags = MAGIC_RESISTANCE

	/// If set to a positive number, the spell will produce sparks when casted.
	var/sparks_amt = 0
	/// The typepath of the smoke to create on cast.
	var/smoke_type
	/// The amount of smoke to create on cast. This is a range, so a value of 5 will create enough smoke to cover everything within 5 steps.
	var/smoke_amt = 0

	/// Required worn items to cast.
	var/list/required_items

	/// Skill associated with spell scaling (charge time, cost adjustments).
	var/associated_skill = /datum/skill/magic/arcane
	/// Stat associated with spell scaling (charge time, cost adjustments).
	var/associated_stat = STATKEY_INT

	// Pointed vars
	// In the TG refactor these weren't a given but almost all our spells are pointed including most spell types.
	// I don't really like this but oh well its required without creating a mess of inheritance.
	/// If this spell can be cast on yourself.
	var/self_cast_possible = TRUE
	/// The casting range of our spell.
	var/cast_range = 7
	/// Variable dictating if the spell will use turf based aim assist.
	var/aim_assist = TRUE

	// Charged vars
	/// If the spell requires time to charge.
	var/charge_required = TRUE
	/// Whether we're currently charging the spell.
	var/currently_charging = FALSE
	/**
	 * Cost to charge.
	 *
	 * Total drain is: ([charge_time] / [process_time]) * charge_drain
	 * process_time is currently 4 from SSfastprocess.
	 */
	var/charge_drain = 0
	/// Time to charge.
	var/charge_time = 0
	/// Slowdown while charging.
	var/charge_slowdown = 0
	/// Message to show when we start casting.
	var/charge_message
	// Not using looping_sound due to their tendancy to break and hard delete,
	// also all the invoke sounds are just static sounds.
	/// What sound file should we play when we start chanelling.
	var/charge_sound = 'sound/magic/charging.ogg'
	/// The actual sound we generate, don't mess with this.
	var/sound/charge_sound_instance
	// Following vars are used for mouse pointer charge only
	/// World time that the charge started.
	var/charge_started_at = 0
	/// Charge target time, from get_charge_time().
	var/charge_target_time = 0
	/// Whether the spell is currently charged, for cases where you want to keep casting after the initial charge (projectiles).
	var/charged = FALSE

	/// If the spell creates visual effects.
	var/has_visual_effects = TRUE
	/// The color used for spell visual effects (rune, particles, wave). Each spell sets its own.
	var/spell_color = "#FFFFFF"
	/// Glow intensity while casting. Uses GLOW_INTENSITY defines. 0 = no glow.
	var/glow_intensity = 0
	/// The overhead spell icon effect shown while casting (old rune system).
	var/obj/effect/mob_charge_effect
	/// Mob light reference for cleanup.
	var/obj/effect/dummy/lighting_obj/moblight/spell_glow_light

	/// Timer ID for the auto cancel, so we can cancel it
	var/auto_cancel_timer = null

/datum/action/cooldown/spell/New(Target)
	. = ..()
	// Create overhead spell icon effect (matching old proc_holder system)
	if(button_icon_state)
		var/obj/effect/R = new /obj/effect/spell_rune
		R.icon = button_icon
		R.icon_state = button_icon_state
		mob_charge_effect = R

	if(!charge_required)
		return
	if(charge_time <= 0)
		stack_trace("Charging spell [src] ([type]) has no charge time")
		charge_required = FALSE
		return
	if(charge_sound)
		charge_sound_instance = sound(charge_sound)

/datum/action/cooldown/spell/Destroy()
	QDEL_NULL(mob_charge_effect)
	QDEL_NULL(spell_glow_light)
	if(charge_required && owner)
		cancel_casting()
	charge_sound_instance = null
	return ..()

/datum/action/cooldown/spell/process()
	if(!currently_charging)
		return ..() // Parent handles cooldown icon updates

	if(!owner)
		return PROCESS_KILL

	if(!can_cast_spell(TRUE))
		cancel_casting()
		return PROCESS_KILL

	if(charge_drain)
		if(!check_resource_available(primary_resource_type, charge_drain))
			owner.balloon_alert(owner, "I cannot uphold the channeling!")
			cancel_casting()
			return PROCESS_KILL
		invoke_resource_cost(primary_resource_type, charge_drain)

	// Update mouse charge pointer based on progress
	if(owner.client && charge_started_at && charge_target_time)
		var/progress = world.time - charge_started_at
		var/percentage = clamp((progress / charge_target_time) * 100, 0, 100)
		var/new_icon = SSmousecharge.access(percentage)
		if(owner.client.mouse_pointer_icon != new_icon)
			owner.client.mouse_pointer_icon = new_icon

	// If this is true we hit our charge goal so stop invoking the cost and update the pointer
	if(world.time > (charge_started_at + charge_target_time))
		// We don't want that mouseUp to end in sadness
		if(!check_resource_available(primary_resource_type, charge_drain))
			owner.balloon_alert(owner, "I cannot uphold the channeling!")
			cancel_casting()
			return PROCESS_KILL
		// Fully charged — swap to charged icon and stop processing
		if(owner.client)
			owner.client.mouse_pointer_icon = 'icons/effects/mousemice/swang/acharged.dmi'
			playsound(owner, 'sound/magic/charged.ogg', 100, TRUE)
		return PROCESS_KILL

/datum/action/cooldown/spell/Grant(mob/grant_to)
	// Spells are hard baked to pratically only work with living owners
	if(!isliving(grant_to))
		qdel(src)
		return

	// If our spell is mind-bound, we only wanna grant it to our mind
	if(istype(target, /datum/mind))
		var/datum/mind/mind_target = target
		if(mind_target.current != grant_to)
			return

	. = ..()
	if(!owner)
		return

	// Register some signals so our button's icon stays up to date
	if(spell_requirements & SPELL_REQUIRES_STATION)
		RegisterSignal(owner, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(update_status_on_signal))
	// TODO: COMSIG_MOB_EQUIPPED_ITEM doesn't exist in AP yet — need to port for garb/antimagic updates

	// TODO: devotion/blood cost signal updates for button status

/datum/action/cooldown/spell/Remove(mob/living/remove_from)
	UnregisterSignal(remove_from, list(
		COMSIG_MOVABLE_Z_CHANGED,
	))

	return ..()

/datum/action/cooldown/spell/is_action_active(atom/movable/screen/movable/action_button/current_button)
	if(charge_required && !click_to_activate)
		return currently_charging
	return ..()

/datum/action/cooldown/spell/IsAvailable(feedback = FALSE)
	return ..() && can_cast_spell(feedback = feedback)

/datum/action/cooldown/spell/Trigger(trigger_flags, atom/target)
	// We implement this can_cast_spell check before the parent call of Trigger()
	// to allow people to click unavailable abilities to get a feedback chat message
	// about why the ability is unavailable.
	// It is otherwise redundant, however, as IsAvailable() checks can_cast_spell as well.
	if(!can_cast_spell())
		return FALSE

	return ..()

/datum/action/cooldown/spell/set_click_ability(mob/on_who)
	if(SEND_SIGNAL(on_who, COMSIG_MOB_SPELL_ACTIVATED, src) & SPELL_CANCEL_CAST)
		return FALSE

	if(currently_charging)
		return FALSE

	// Clear any existing mmb_intent (specials, kick, etc.) so they don't fire alongside the spell
	if(on_who.mmb_intent)
		qdel(on_who.mmb_intent)
		on_who.mmb_intent = null
		if(on_who.hud_used)
			on_who.hud_used.quad_intents?.switch_intent(null)

	if(click_to_activate)
		on_activation(on_who)

		if(charge_required)
			// If pointed we setup signals to override mouse down to call InterceptClickOn()
			RegisterSignal(owner.client, COMSIG_CLIENT_MOUSEDOWN, PROC_REF(start_casting))
		else
			// Non-charge spells still need to intercept middle-click MouseDown
			// to prevent the old system from starting its charging flow
			RegisterSignal(owner.client, COMSIG_CLIENT_MOUSEDOWN, PROC_REF(intercept_mousedown))

	return ..()

// Note: Destroy() calls Remove(), Remove() calls unset_click_ability() if our spell is active.
/datum/action/cooldown/spell/unset_click_ability(mob/on_who, refund_cooldown = TRUE)
	if(click_to_activate)
		on_deactivation(on_who, refund_cooldown = refund_cooldown)

		if(on_who.client)
			UnregisterSignal(on_who.client, COMSIG_CLIENT_MOUSEDOWN)

	return ..()

/*
 * The following three procs are only relevant to pointed spells
 */
/// Called when the spell is activated / the click ability is set to our spell
/datum/action/cooldown/spell/proc/on_activation(mob/on_who)
	SHOULD_CALL_PARENT(TRUE)

	build_all_button_icons()

	return TRUE

/// Called when the spell is deactivated / the click ability is unset from our spell
/datum/action/cooldown/spell/proc/on_deactivation(mob/on_who, refund_cooldown = TRUE)
	SHOULD_CALL_PARENT(TRUE)

	build_all_button_icons()

	return TRUE

/datum/action/cooldown/spell/InterceptClickOn(mob/living/clicker, list/modifiers, atom/click_target)
	// check_click_intercept passes raw params string, not a list — parse it
	if(istext(modifiers))
		modifiers = params2list(modifiers)
	if(!LAZYACCESS(modifiers, MIDDLE_CLICK))
		return

	if(charge_required && !charged)
		end_charging()
		return

	var/atom/aim_assist_target
	if(aim_assist && isturf(click_target))
		// Find any human in the list. We aren't picky, it's aim assist after all
		aim_assist_target = locate(/mob/living/carbon/human) in click_target
		if(!aim_assist_target)
			// If we didn't find a human, we settle for any living at all
			aim_assist_target = locate(/mob/living) in click_target

	return ..(clicker, modifiers, aim_assist_target || click_target)

// Where the cast chain starts
/datum/action/cooldown/spell/PreActivate(atom/target)
	charged = FALSE
	if(!is_valid_target(target))
		if(charge_required && click_to_activate)
			to_chat(owner, span_warning("I can't cast [src] on [target]!"))
		return FALSE

	return Activate(target)

/// Adjust the base charge time based on the user's skill level, spellbook, and staff.
/// Matches proc_holder's calculate_chargetime.
/datum/action/cooldown/spell/proc/get_adjusted_charge_time()
	if(charge_time <= 0)
		return charge_time

	var/mob/living/living_owner = owner
	if(!living_owner)
		return charge_time
	var/new_time = charge_time

	// Skill reduction
	new_time -= charge_time * living_owner.get_skill_level(associated_skill, TRUE) * CHARGE_REDUCTION_PER_SKILL

	// Spellbook cast time reduction
	var/obj/item/book/spellbook/sbook = living_owner.is_holding_item_of_type(/obj/item/book/spellbook)
	if(sbook && sbook.open)
		new_time -= charge_time * sbook.get_castred()

	// Staff cast time reduction
	var/obj/item/rogueweapon/staff = living_owner.is_holding_item_of_type(/obj/item/rogueweapon/)
	if(staff && staff.cast_time_reduction)
		new_time -= charge_time * staff.cast_time_reduction

	return max(new_time, 1 DECISECONDS)

/// Adjust the cooldown time based on INT and armor.
/// Matches proc_holder's calculate_cooldown from PR #6316.
/datum/action/cooldown/spell/proc/get_adjusted_cooldown()
	var/mob/living/living_owner = owner
	var/base = initial(cooldown_time)
	var/newcd = base

	// INT scaling
	if(living_owner.STAINT > SPELL_SCALING_THRESHOLD)
		var/diff = min(living_owner.STAINT, SPELL_POSITIVE_SCALING_THRESHOLD) - SPELL_SCALING_THRESHOLD
		newcd -= base * diff * COOLDOWN_REDUCTION_PER_INT
	else if(living_owner.STAINT < SPELL_SCALING_THRESHOLD)
		var/diff = SPELL_SCALING_THRESHOLD - living_owner.STAINT
		newcd += base * diff * COOLDOWN_REDUCTION_PER_INT

	// Armor penalties on cooldown, not stamina cost
	if(!living_owner.check_armor_skill())
		newcd += base * UNTRAINED_ARMOR_CD_PENALTY
	else if(ishuman(living_owner))
		var/mob/living/carbon/human/H = living_owner
		var/ac = H.highest_ac_worn()
		if(ac == ARMOR_CLASS_HEAVY)
			newcd += base * HEAVY_ARMOR_CD_PENALTY
		else if(ac == ARMOR_CLASS_MEDIUM)
			newcd += base * MEDIUM_ARMOR_CD_PENALTY

	return newcd

/// Adjust stamina cost based on INT only.
/// Matches proc_holder's calculate_fatigue_drain from PR #6316 — no skill, no armor.
/datum/action/cooldown/spell/proc/get_adjusted_cost(base_cost)
	if(base_cost <= 0)
		return 0

	var/mob/living/living_owner = owner
	var/new_cost = base_cost

	if(living_owner.STAINT > SPELL_SCALING_THRESHOLD)
		var/diff = min(living_owner.STAINT, SPELL_POSITIVE_SCALING_THRESHOLD) - SPELL_SCALING_THRESHOLD
		new_cost -= base_cost * diff * FATIGUE_REDUCTION_PER_INT
	else if(living_owner.STAINT < SPELL_SCALING_THRESHOLD)
		var/diff = SPELL_SCALING_THRESHOLD - living_owner.STAINT
		new_cost += base_cost * diff * FATIGUE_REDUCTION_PER_INT

	return max(new_cost, 0.1)

/// Checks if the owner of the spell can currently cast it.
/// Does not check anything involving potential targets.
/datum/action/cooldown/spell/proc/can_cast_spell(feedback = TRUE)
	if(!owner)
		CRASH("[type] - can_cast_spell called on a spell without an owner!")

	if(!(spell_flags & SPELL_IGNORE_SPELLBLOCK) && HAS_TRAIT(owner, TRAIT_SPELLBLOCK))
		if(feedback)
			owner.balloon_alert(owner, "Can't focus on casting...")
		return FALSE

	if(HAS_TRAIT(owner, TRAIT_NOC_CURSE))
		if(feedback)
			owner.balloon_alert(owner, "My magicka has left me...")
		return FALSE

	for(var/datum/action/cooldown/spell/spell in owner.actions)
		if(spell == src)
			continue
		if(spell.currently_charging)
			if(feedback)
				owner.balloon_alert(owner, "Already channeling!")
			return FALSE

	if(!check_cost(feedback = feedback))
		return FALSE

	// Certain spells are not allowed on the centcom zlevel
	var/turf/caster_turf = get_turf(owner)
	if((spell_requirements & SPELL_REQUIRES_STATION) && is_centcom_level(caster_turf.z))
		if(feedback)
			owner.balloon_alert(owner, "Cannot cast here!")
		return FALSE

	if((spell_requirements & SPELL_REQUIRES_MIND) && !owner.mind)
		// No point in feedback here, as mindless mobs aren't players
		return FALSE

	// If the spell requires the user has no antimagic equipped, and they're holding antimagic
	// that corresponds with the spell's antimagic, then they can't actually cast the spell
	if((spell_requirements & SPELL_REQUIRES_NO_ANTIMAGIC) && owner.anti_magic_check())
		if(feedback)
			owner.balloon_alert(owner, "Antimagic is preventing casting!")
		return FALSE

	if(!can_invoke(feedback = feedback))
		return FALSE

	if(!ishuman(owner))
		if(spell_requirements & (SPELL_REQUIRES_HUMAN))
			if(feedback)
				owner.balloon_alert(owner, "Can only be cast by humans!")
			return FALSE

	if(LAZYLEN(required_items))
		var/found = FALSE
		for(var/obj/item/I in owner.contents)
			if(is_type_in_list(I, required_items))
				found = TRUE
				break
		if(!found && feedback)
			owner.balloon_alert(owner, "Missing something to cast!")
			return FALSE

	return TRUE

/**
 * Check if the target we're casting on is a valid target.
 * For self-casted spells, the target being checked (cast_on) is the caster.
 *
 * Return TRUE if cast_on is valid, FALSE otherwise
 */
/datum/action/cooldown/spell/proc/is_valid_target(atom/cast_on)
	if(click_to_activate && !self_cast_possible)
		if(cast_on == owner)
			owner.balloon_alert(owner, "Can't self cast!")
			return FALSE

	return TRUE

// The actual cast chain occurs here, in Activate().
// You should generally not be overriding or extending Activate() for spells.
// Defer to any of the cast chain procs instead.
/datum/action/cooldown/spell/Activate(atom/target)
	SHOULD_NOT_OVERRIDE(TRUE)

	// Pre-casting of the spell
	// Pre-cast is the very last chance for a spell to cancel
	// Stuff like target input can go here.
	var/precast_result = before_cast(target)
	if(precast_result & SPELL_CANCEL_CAST)
		if(charge_required)
			cancel_casting()
		return FALSE

	// Extra safety
	if(!check_cost())
		return FALSE

	// Spell is officially being cast
	if(!(precast_result & SPELL_NO_FEEDBACK))
		// We do invocation and sound effects here, before actual cast
		// That way stuff like teleports or shape-shifts can be invoked before ocurring
		spell_feedback(owner)

	// Actually cast the spell. Main effects go here
	cast(target)

	if(!(precast_result & SPELL_NO_IMMEDIATE_COOLDOWN))
		// The entire spell is done, start the actual cooldown at its adjusted duration
		StartCooldown(get_adjusted_cooldown())

	if(!(precast_result & SPELL_NO_IMMEDIATE_COST))
		// Invoke the base cost of the spell based on primary/secondary resource types
		invoke_cost()

	// And then proceed with the aftermath of the cast
	// Final effects that happen after all the casting is done can go here
	after_cast(target)
	build_all_button_icons()

	return TRUE

/**
 * Actions done before the actual cast is called.
 * This is the last chance to cancel the spell from being cast.
 *
 * Can be used for target selection or to validate checks on the caster (cast_on).
 *
 * Returns a bitflag.
 * - SPELL_CANCEL_CAST will stop the spell from being cast.
 * - SPELL_NO_FEEDBACK will prevent the spell from calling [proc/spell_feedback] on cast. (invocation, sounds)
 * - SPELL_NO_IMMEDIATE_COOLDOWN will prevent the spell from starting its cooldown between cast and before after_cast.
 * - SPELL_NO_IMMEDIATE_COST will prevent the spell from charging its cost between cast and before after_cast.
 */
/datum/action/cooldown/spell/proc/before_cast(atom/cast_on)
	SHOULD_CALL_PARENT(TRUE)

	var/sig_return = SEND_SIGNAL(src, COMSIG_SPELL_BEFORE_CAST, cast_on)
	if(owner)
		sig_return |= SEND_SIGNAL(owner, COMSIG_MOB_BEFORE_SPELL_CAST, src, cast_on)

	if(click_to_activate)
		if(sig_return & SPELL_CANCEL_CAST)
			on_deactivation(owner, refund_cooldown = FALSE)
			return sig_return

		if(get_dist(owner, cast_on) > cast_range)
			owner.balloon_alert(owner, "Too far away!")
			return sig_return | SPELL_CANCEL_CAST

		if((primary_resource_type == SPELL_COST_DEVOTION) && HAS_TRAIT(cast_on, TRAIT_ATHEISM_CURSE))
			if(isliving(cast_on))
				var/mob/living/L = cast_on
				L.visible_message(
					span_danger("[L] recoils in disgust!"),
					span_userdanger("These fools are trying to cure me with religion!!")
				)
			return sig_return | SPELL_CANCEL_CAST

		if((primary_resource_type == SPELL_COST_DEVOTION) && HAS_TRAIT(cast_on, TRAIT_SILVER_BLESSED) && !(spell_flags & SPELL_PSYDON))
			cast_on.visible_message(span_info("[cast_on] stirs for a moment, the miracle dissipates."), span_notice("A dull warmth swells in your heart, only to fade as quickly as it arrived."))
			playsound(cast_on, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			owner.playsound_local(owner, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			return sig_return | SPELL_CANCEL_CAST

	if(charge_required && !click_to_activate)
		// Use a simple do_after for non-click charge spells
		var/require_no_move = (spell_requirements & SPELL_REQUIRES_NO_MOVE)
		on_start_charge()
		var/success = TRUE
		if(!do_after(owner, get_adjusted_charge_time(), needhand = FALSE, extra_checks = CALLBACK(src, PROC_REF(do_after_checks), owner, cast_on), no_interrupt = !require_no_move))
			success = FALSE
			sig_return |= SPELL_CANCEL_CAST

		if(currently_charging) // in case charging was interrupted elsewhere
			on_end_charge(success)

	return sig_return

/datum/action/cooldown/spell/proc/do_after_checks(mob/owner, atom/cast_on)
	if(!currently_charging)
		return FALSE
	if(!can_cast_spell(TRUE))
		return FALSE
	if(!is_valid_target(cast_on))
		return FALSE
	return TRUE

/**
 * Actions done as the main effect of the spell.
 *
 * For spells without a click intercept, [cast_on] will be the owner.
 * For click spells, [cast_on] is whatever the owner clicked on in casting the spell.
 */
/datum/action/cooldown/spell/proc/cast(atom/cast_on)
	SHOULD_CALL_PARENT(TRUE)

	SEND_SIGNAL(src, COMSIG_SPELL_CAST, cast_on)
	record_featured_object_stat(FEATURED_STATS_SPELLS, name)
	if(owner)
		SEND_SIGNAL(owner, COMSIG_MOB_CAST_SPELL, src, cast_on)
		if(owner.ckey)
			owner.log_message("cast the spell [name][cast_on != owner ? " on / at [key_name_admin(cast_on)]":""].", LOG_ATTACK)
			if(cast_on != owner)
				cast_on.log_message("affected by spell [name] by [key_name_admin(owner)].", LOG_ATTACK)

/**
 * Actions done after the main cast is finished.
 * This is called after the cooldown's already begun.
 *
 * It can be used to apply late spell effects where order matters
 * (for example, causing smoke *after* a teleport occurs in cast())
 * or to clean up variables or references post-cast.
 */
/datum/action/cooldown/spell/proc/after_cast(atom/cast_on)
	SHOULD_CALL_PARENT(TRUE)

	SEND_SIGNAL(src, COMSIG_SPELL_AFTER_CAST, cast_on)
	if(!owner)
		return

	SEND_SIGNAL(owner, COMSIG_MOB_AFTER_SPELL_CAST, src, cast_on)

	// Sparks and smoke can only occur if there's an owner to source them from.
	if(sparks_amt)
		do_sparks(sparks_amt, FALSE, get_turf(owner))

	if(ispath(smoke_type, /datum/effect_system/smoke_spread))
		var/datum/effect_system/smoke_spread/smoke = new smoke_type()
		smoke.set_up(smoke_amt, loca = get_turf(owner))
		smoke.start()

	// Clean up overhead spell icon
	if(mob_charge_effect)
		owner.vis_contents -= mob_charge_effect

	// Clean up glow
	if(spell_glow_light)
		QDEL_NULL(spell_glow_light)

	if(has_visual_effects)
		var/mob/living/living_owner = owner
		living_owner.finish_spell_visual_effects(spell_color)

	// Reset mouse pointer
	if(owner.client)
		owner.client.mouse_pointer_icon = 'icons/effects/mousemice/human.dmi'

/// Provides feedback after a spell cast occurs, in the form of a cast sound and/or invocation
/datum/action/cooldown/spell/proc/spell_feedback(mob/living/invoker)
	if(!invoker)
		return

	///even INVOCATION_NONE should go through this because the signal might change that
	invocation(invoker)

	if(sound)
		playsound(owner, sound, 50, TRUE)

/// The invocation that accompanies the spell, called from spell_feedback() before cast().
/datum/action/cooldown/spell/proc/invocation(mob/living/invoker)
	if(!invocations)
		return
	if(istext(invocations))
		invocations = list(invocations)
	if(!islist(invocations) || !length(invocations))
		return

	var/chosen_invocation = pick(invocations)
	//lists can be sent by reference, a string would be sent by value
	var/list/invocation_list = list(chosen_invocation, invocation_type)
	SEND_SIGNAL(invoker, COMSIG_MOB_PRE_INVOCATION, src, invocation_list)
	var/used_invocation_message = invocation_list[INVOCATION_MESSAGE]
	var/used_invocation_type = invocation_list[INVOCATION_TYPE]

	switch(used_invocation_type)
		if(INVOCATION_SHOUT)
			invoker.say(used_invocation_message, forced = "spell ([src])")

		if(INVOCATION_WHISPER)
			invoker.whisper(used_invocation_message, forced = "spell ([src])")

		if(INVOCATION_EMOTE)
			invoker.visible_message(
				capitalize(replacetext(used_invocation_message, "%CASTER", invoker.name)),
				capitalize(replacetext(invocation_self_message, "%CASTER", invoker.name)),
			)

/// When we start charging the spell called from set_click_ability or start_casting
/datum/action/cooldown/spell/proc/on_start_charge()
	currently_charging = TRUE
	START_PROCESSING(SSfastprocess, src)
	build_all_button_icons(UPDATE_BUTTON_STATUS|UPDATE_BUTTON_BACKGROUND)

	if(charge_slowdown)
		owner.add_movespeed_modifier(MOVESPEED_ID_SPELL_CASTING, override = TRUE, multiplicative_slowdown = charge_slowdown)

	if(charge_sound_instance)
		playsound(owner, charge_sound_instance, 50, FALSE, channel = CHANNEL_CHARGED_SPELL)

	// Overhead spell icon rune
	if(mob_charge_effect)
		owner.vis_contents += mob_charge_effect

	// Spell glow light
	if(glow_intensity && spell_color && isliving(owner))
		var/mob/living/L = owner
		spell_glow_light = L.mob_light(spell_color, glow_intensity, FLASH_LIGHT_SPELLGLOW)

	// Rune-under + particles
	if(has_visual_effects)
		var/mob/living/caster = owner
		caster.start_spell_visual_effects(spell_color)

	// Mouse charge pointer
	if(owner.client)
		owner.client.mouse_pointer_icon = 'icons/effects/mousemice/swang/acharging.dmi'

	if(charge_message)
		owner.balloon_alert(owner, charge_message)

	if(spell_requirements & SPELL_REQUIRES_NO_MOVE)
		owner.balloon_alert(owner, "Be still while channelling...")

	if(owner?.mmb_intent)
		owner.mmb_intent_change(null)

/// When finish charging the spell called from set_click_ability or try_casting
/// This does not mean we succeeded in charging the spell just that we did mouseUp/ended the do_after
/datum/action/cooldown/spell/proc/on_end_charge(success)
	end_charging()
	. = success
	if(success)
		charged = TRUE
		return
	if(owner)
		owner.balloon_alert(owner, "Channeling was interrupted!")

/// End the charging cycle
/datum/action/cooldown/spell/proc/end_charging()
	if(owner.client)
		UnregisterSignal(owner.client, list(COMSIG_CLIENT_MOUSEDOWN, COMSIG_CLIENT_MOUSEUP))
	UnregisterSignal(owner, list(COMSIG_MOB_LOGOUT, COMSIG_MOB_DEATH, COMSIG_MOVABLE_MOVED))
	currently_charging = FALSE
	charge_started_at = null
	charge_target_time = null
	STOP_PROCESSING(SSfastprocess, src)
	build_all_button_icons(UPDATE_BUTTON_STATUS|UPDATE_BUTTON_BACKGROUND)

	// When charging ends, other spells may have had their buttons stuck red
	// because can_cast_spell() returned FALSE while we were charging.
	// Rebuild their icons now so they re-evaluate IsAvailable().
	for(var/datum/action/cooldown/spell/other_spell in owner?.actions)
		if(other_spell == src)
			continue
		other_spell.build_all_button_icons(UPDATE_BUTTON_STATUS)

	if(charge_slowdown)
		owner.remove_movespeed_modifier(MOVESPEED_ID_SPELL_CASTING)

	if(charge_sound_instance)
		owner.stop_sound_channel(CHANNEL_CHARGED_SPELL)
		// Play a null sound in to cancel the sound playing, because byond
		playsound(owner, sound(null, repeat = 0), 50, FALSE, channel = CHANNEL_CHARGED_SPELL)

	// Clean up overhead spell icon
	if(mob_charge_effect)
		owner.vis_contents -= mob_charge_effect

	// Clean up glow
	if(spell_glow_light)
		QDEL_NULL(spell_glow_light)

	if(has_visual_effects)
		var/mob/living/caster = owner
		caster.cancel_spell_visual_effects()

	// Reset mouse pointer
	if(owner.client)
		owner.client.mouse_pointer_icon = 'icons/effects/mousemice/human.dmi'

/// Cancel casting and all its effects.
/datum/action/cooldown/spell/proc/cancel_casting()
	if(QDELETED(src)) // Timer
		return
	charged = FALSE
	end_charging()

/// Checks if the current OWNER of the spell is in a valid state to say the spell's invocation
/datum/action/cooldown/spell/proc/can_invoke(feedback = TRUE)
	if(spell_requirements & SPELL_CASTABLE_WITHOUT_INVOCATION)
		return TRUE

	if(invocation_type == INVOCATION_NONE)
		return TRUE

	var/mob/living/living_owner = owner
	if(invocation_type == INVOCATION_EMOTE && HAS_TRAIT(living_owner, TRAIT_EMOTEMUTE))
		if(feedback)
			owner.balloon_alert(owner, "Can't position your hands correctly to invoke!")
		return FALSE

	if((invocation_type == INVOCATION_WHISPER || invocation_type == INVOCATION_SHOUT) && !ignore_can_speak && !living_owner.can_speak_vocal())
		if(feedback)
			owner.balloon_alert(owner, "Can't get the words out to invoke!")
		return FALSE

	return TRUE

/// Resets the cooldown of the spell, sending COMSIG_SPELL_CAST_RESET
/// and allowing it to be used immediately (+ updating button icon accordingly)
/datum/action/cooldown/spell/proc/reset_spell_cooldown()
	SEND_SIGNAL(src, COMSIG_SPELL_CAST_RESET)
	next_use_time -= cooldown_time // Basically, ensures that the ability can be used now
	build_all_button_icons()

/// Check if the spell is castable by cost. Checks both primary and secondary resources.
/datum/action/cooldown/spell/proc/check_cost(feedback = TRUE)
	if(!check_resource_available(primary_resource_type, primary_resource_cost, feedback))
		return FALSE
	if(!check_resource_available(secondary_resource_type, secondary_resource_cost, feedback))
		return FALSE
	return TRUE

/// Check if a specific resource type has enough to cover the cost.
/// INT scaling applies to stamina and energy costs. Devotion passes through raw.
/datum/action/cooldown/spell/proc/check_resource_available(resource_type, base_cost, feedback = TRUE)
	var/mob/living/caster = owner
	switch(resource_type)
		if(SPELL_COST_NONE)
			return TRUE

		if(SPELL_COST_STAMINA)
			// Stamina spells always pass the check — you CAN cast into stamcrit, that's the risk.
			// The drain happens in invoke_resource_cost via stamina_add().
			return TRUE

		if(SPELL_COST_ENERGY)
			var/used_cost = get_adjusted_cost(base_cost)
			if(used_cost <= 0)
				return TRUE
			if(caster.energy < used_cost)
				if(feedback)
					owner.balloon_alert(owner, "Not enough energy to cast!")
				return FALSE
			return TRUE

		if(SPELL_COST_DEVOTION)
			// Devotion is not scaled by INT
			if(base_cost <= 0)
				return TRUE
			var/mob/living/carbon/human/H = caster
			if(!istype(H) || !H.devotion || H.devotion.devotion < base_cost)
				if(feedback)
					owner.balloon_alert(owner, "Devotion too weak!")
				return FALSE
			return TRUE

	return TRUE

/// Charge the owner with the cost of the spell. Drains both primary and secondary resources.
/datum/action/cooldown/spell/proc/invoke_cost()
	if(!owner)
		return

	var/primary_spent = invoke_resource_cost(primary_resource_type, primary_resource_cost)
	var/secondary_spent = invoke_resource_cost(secondary_resource_type, secondary_resource_cost)

	var/total = (primary_spent || 0) + (secondary_spent || 0)
	if(total <= 0)
		return
	return total

/// Drain a specific resource type by the given base cost.
/// INT scaling applies to stamina and energy. Devotion uses raw cost.
/datum/action/cooldown/spell/proc/invoke_resource_cost(resource_type, base_cost)
	if(resource_type == SPELL_COST_NONE)
		return

	switch(resource_type)
		if(SPELL_COST_STAMINA)
			var/used_cost = get_adjusted_cost(base_cost)
			if(used_cost <= 0)
				return
			var/mob/living/caster = owner
			caster.stamina_add(used_cost) // positive = add fatigue (drain green bar)
			return used_cost

		if(SPELL_COST_ENERGY)
			var/used_cost = get_adjusted_cost(base_cost)
			if(used_cost <= 0)
				return
			var/mob/living/caster = owner
			caster.energy_add(-used_cost) // negative = drain blue bar
			return used_cost

		if(SPELL_COST_DEVOTION)
			// Devotion is not scaled by INT
			if(base_cost <= 0)
				return
			var/mob/living/carbon/human/H = owner
			if(!istype(H))
				return
			H.devotion?.update_devotion(-base_cost)
			return base_cost

/// Examine the spell when shift-clicking the action button.
/datum/action/cooldown/spell/proc/examine(mob/user)
	var/list/inspec = list("<br><span class='notice'><b>[name]</b></span>")
	if(desc)
		inspec += "\n[desc]"
	var/list/stats = get_spell_statistics(user)
	if(length(stats))
		inspec += "<br>" + stats.Join("<br>")
	to_chat(user, "[inspec.Join()]")

/// Returns a list of spell statistics for examine display.
/// Mirrors proc_holder's get_spell_statistics.
/datum/action/cooldown/spell/proc/get_spell_statistics(mob/living/user)
	var/list/stats = list()

	// Activation mode
	if(!click_to_activate)
		stats += span_info("Activation: Self-cast")
	else if(charge_required)
		stats += span_info("Activation: Hold middle-click to charge, release to cast")
	else
		stats += span_info("Activation: Middle-click a target to cast")

	if(click_to_activate)
		stats += span_info("Range: [cast_range] tiles")
	else
		stats += span_info("Range: Self")

	// Charge time
	var/base_ct = charge_time
	if(base_ct > 0)
		var/dynamic_ct = user ? get_adjusted_charge_time() : base_ct
		var/ct_modified = (dynamic_ct < base_ct - 0.5)
		if(ct_modified)
			stats += span_info("Charge time: [DisplayTimeText(base_ct)] (current: [dynamic_ct < 1 ? "instant" : DisplayTimeText(dynamic_ct)])")
			if(user)
				var/list/ct_breakdown = get_chargetime_breakdown(user)
				if(length(ct_breakdown))
					stats += ct_breakdown
		else
			stats += span_info("Charge time: [DisplayTimeText(base_ct)]")
	else
		stats += span_info("Charge time: Instant")

	// Cooldown
	var/base_cd = initial(cooldown_time)
	if(base_cd)
		var/dynamic_cd = user ? get_adjusted_cooldown() : base_cd
		if(abs(dynamic_cd - base_cd) > 0.5) // Meaningful change threshold
			stats += span_info("Cooldown: [DisplayTimeText(base_cd)] (current: [DisplayTimeText(dynamic_cd)])")
			if(user)
				var/list/cd_breakdown = get_cooldown_breakdown(user)
				if(length(cd_breakdown))
					stats += cd_breakdown
		else
			stats += span_info("Cooldown: [DisplayTimeText(base_cd)]")

	// Primary resource cost
	if(primary_resource_cost > 0)
		var/cost_label = get_resource_label(primary_resource_type)
		if(primary_resource_type == SPELL_COST_STAMINA || primary_resource_type == SPELL_COST_ENERGY)
			var/dynamic_cost = user ? get_adjusted_cost(primary_resource_cost) : primary_resource_cost
			if(dynamic_cost != primary_resource_cost)
				stats += span_info("[cost_label]: [primary_resource_cost] (current: [dynamic_cost])")
				if(user)
					stats += get_fatigue_breakdown(user, primary_resource_cost)
			else
				stats += span_info("[cost_label]: [primary_resource_cost]")
		else
			stats += span_info("[cost_label]: [primary_resource_cost]")

	// Secondary resource cost
	if(secondary_resource_cost > 0)
		var/cost_label = get_resource_label(secondary_resource_type)
		if(secondary_resource_type == SPELL_COST_STAMINA || secondary_resource_type == SPELL_COST_ENERGY)
			var/dynamic_cost = user ? get_adjusted_cost(secondary_resource_cost) : secondary_resource_cost
			if(dynamic_cost != secondary_resource_cost)
				stats += span_info("[cost_label]: [secondary_resource_cost] (current: [dynamic_cost])")
				if(user)
					stats += get_fatigue_breakdown(user, secondary_resource_cost)
			else
				stats += span_info("[cost_label]: [secondary_resource_cost]")
		else
			stats += span_info("[cost_label]: [secondary_resource_cost]")

	return stats

/// Returns a human-readable label for a resource type.
/datum/action/cooldown/spell/proc/get_resource_label(resource_type)
	switch(resource_type)
		if(SPELL_COST_STAMINA)
			return "Stamina cost"
		if(SPELL_COST_ENERGY)
			return "Energy cost"
		if(SPELL_COST_DEVOTION)
			return "Devotion cost"
	return "Cost"

/// Breakdown of charge time modifiers for examine.
/datum/action/cooldown/spell/proc/get_chargetime_breakdown(mob/living/user)
	var/list/breakdown = list()
	var/skill_level = user.get_skill_level(associated_skill, TRUE)
	if(skill_level > 0)
		var/skill_mod = charge_time * skill_level * CHARGE_REDUCTION_PER_SKILL
		if(skill_mod > 0)
			breakdown += span_smallgreen("  Skill: -[DisplayTimeText(skill_mod)]")
	var/obj/item/book/spellbook/sbook = user.is_holding_item_of_type(/obj/item/book/spellbook)
	if(sbook && sbook.open)
		var/book_mod = charge_time * sbook.get_castred()
		if(book_mod > 0)
			breakdown += span_smallgreen("  Spellbook: -[DisplayTimeText(book_mod)]")
	var/obj/item/rogueweapon/staff = user.is_holding_item_of_type(/obj/item/rogueweapon/)
	if(staff && staff.cast_time_reduction)
		var/staff_mod = charge_time * staff.cast_time_reduction
		if(staff_mod > 0)
			breakdown += span_smallgreen("  Staff: -[DisplayTimeText(staff_mod)]")
	return breakdown

/// Breakdown of cooldown modifiers for examine. Matches proc_holder's get_cooldown_breakdown.
/datum/action/cooldown/spell/proc/get_cooldown_breakdown(mob/living/user)
	var/list/breakdown = list()
	var/base = initial(cooldown_time)
	if(user.STAINT > SPELL_SCALING_THRESHOLD)
		var/diff = min(user.STAINT, SPELL_POSITIVE_SCALING_THRESHOLD) - SPELL_SCALING_THRESHOLD
		var/int_mod = base * diff * COOLDOWN_REDUCTION_PER_INT
		breakdown += span_smallgreen("  Intelligence: -[DisplayTimeText(int_mod)]")
	else if(user.STAINT < SPELL_SCALING_THRESHOLD)
		var/diff = SPELL_SCALING_THRESHOLD - user.STAINT
		var/int_mod = base * diff * COOLDOWN_REDUCTION_PER_INT
		breakdown += span_smallred("  Intelligence: +[DisplayTimeText(int_mod)]")
	if(!user.check_armor_skill())
		var/armor_mod = base * UNTRAINED_ARMOR_CD_PENALTY
		breakdown += span_smallred("  Untrained armor: +[DisplayTimeText(armor_mod)]")
	else if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/ac = H.highest_ac_worn()
		if(ac == ARMOR_CLASS_HEAVY)
			var/armor_mod = base * HEAVY_ARMOR_CD_PENALTY
			breakdown += span_smallred("  Armor weight: +[DisplayTimeText(armor_mod)]")
		else if(ac == ARMOR_CLASS_MEDIUM)
			var/armor_mod = base * MEDIUM_ARMOR_CD_PENALTY
			breakdown += span_smallred("  Armor weight: +[DisplayTimeText(armor_mod)]")
	return breakdown

/// Breakdown of stamina/energy cost modifiers for examine. INT only, matching PR #6316.
/datum/action/cooldown/spell/proc/get_fatigue_breakdown(mob/living/user, base_cost)
	var/list/breakdown = list()
	if(user.STAINT > SPELL_SCALING_THRESHOLD)
		var/diff = min(user.STAINT, SPELL_POSITIVE_SCALING_THRESHOLD) - SPELL_SCALING_THRESHOLD
		var/int_mod = base_cost * diff * FATIGUE_REDUCTION_PER_INT
		breakdown += span_smallgreen("  Intelligence: -[int_mod]")
	else if(user.STAINT < SPELL_SCALING_THRESHOLD)
		var/diff = SPELL_SCALING_THRESHOLD - user.STAINT
		var/int_mod = base_cost * diff * FATIGUE_REDUCTION_PER_INT
		breakdown += span_smallred("  Intelligence: +[int_mod]")
	return breakdown

/// Intercept middle-click MouseDown for non-charge V2 spells.
/// Prevents the old system from entering its charging flow when a V2 spell is active.
/datum/action/cooldown/spell/proc/intercept_mousedown(client/source, atom/_target, turf/location, control, params)
	SIGNAL_HANDLER

	var/list/modifiers = params2list(params)
	// Only intercept middle clicks — let other buttons through to normal handling
	if(!LAZYACCESS(modifiers, MIDDLE_CLICK))
		return
	if(source)
		source.mouse_pointer_icon = 'icons/effects/mousemice/human_attack.dmi'
	return COMPONENT_CLIENT_MOUSEDOWN_INTERCEPT

/// Try to begin the casting process on mouse down.
/// Vanderlin ref: code/modules/spells/spell.dm L1041-1085
/datum/action/cooldown/spell/proc/start_casting(client/source, atom/_target, turf/location, control, params)
	SIGNAL_HANDLER

	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, SHIFT_CLICKED))
		return
	if(LAZYACCESS(modifiers, CTRL_CLICKED))
		return
	if(LAZYACCESS(modifiers, LEFT_CLICK))
		return
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		return
	if(LAZYACCESS(modifiers, ALT_CLICKED))
		return
	if(!isturf(owner.loc))
		return
	if(charge_started_at)
		return

	if(isnull(location) || istype(_target, /atom/movable/screen))
		if(_target.plane != CLICKCATCHER_PLANE)
			return

	// Register here because the mouse up can get triggered before the mouse down otherwise
	RegisterSignal(source, COMSIG_CLIENT_MOUSEUP, PROC_REF(try_casting))
	RegisterSignal(owner, list(COMSIG_MOB_DEATH, COMSIG_MOB_LOGOUT), PROC_REF(signal_cancel))
	if(spell_requirements & SPELL_REQUIRES_NO_MOVE)
		RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(signal_cancel), TRUE)

	var/spell_timeout = 3 MINUTES

	// Cancel the next click with 3 minutes timeout
	source?.click_intercept_time = world.time + spell_timeout
	// Failsafe to cancel casting in extreme circumstances
	auto_cancel_timer = addtimer(CALLBACK(src, PROC_REF(cancel_casting)), spell_timeout, TIMER_STOPPABLE)

	on_start_charge()
	charge_started_at = world.time
	charge_target_time = get_adjusted_charge_time()

	return COMPONENT_CLIENT_MOUSEDOWN_INTERCEPT

/// Attempt to cast the spell after the mouse up.
/// Vanderlin ref: code/modules/spells/spell.dm L1087-1115
/datum/action/cooldown/spell/proc/try_casting(client/source, atom/_target, turf/location, control, params)
	SIGNAL_HANDLER

	// Stop the failsafe timer
	if(auto_cancel_timer)
		deltimer(auto_cancel_timer)

	// This can happen
	if(!source || !charge_started_at || !can_cast_spell(TRUE))
		cancel_casting()
		return

	var/success = world.time >= (charge_started_at + charge_target_time)
	if(!on_end_charge(success)) // Give them another try if they mess up the timing
		RegisterSignal(source, COMSIG_CLIENT_MOUSEDOWN, PROC_REF(start_casting))
		return

	var/list/modifiers = params2list(params)

	// At this point we DO care about the _target value
	if(isnull(location) || istype(_target, /atom/movable/screen))
		// Clicked on screen object / clickcatcher — resolve turf under owner as fallback
		_target = get_turf(source.eye)
		if(!_target)
			cancel_casting()
			return

	// Call this directly to do all the relevant checks and aim assist
	InterceptClickOn(owner, modifiers, _target)
	source.click_intercept_time = 0

/datum/action/cooldown/spell/proc/signal_cancel()
	SIGNAL_HANDLER

	cancel_casting()

// Spell visual effects — mob-owned for safety (if spell hard-deletes, mob Destroy still cleans up).
// AP uses per-spell color instead of Vanderlin's attunement blending.

/// Start spell visual effects. Creates a rune under the caster and begins particle effects.
/mob/living/proc/start_spell_visual_effects(spell_color = "#FFFFFF")
	if(QDELETED(src))
		return

	if(spell_rune)
		QDEL_NULL(spell_rune)

	var/obj/effect/spell_rune_under/rune = new(null, src, spell_color)
	vis_contents |= rune
	spell_rune = rune

	start_spell_particles(spell_color)

/// Intermittent particle effect while charging. Requires spell_rune — self-repeats via timer.
/mob/living/proc/start_spell_particles(spell_color = "#FFFFFF")
	if(QDELETED(src) || QDELETED(spell_rune))
		return

	var/obj/effect/temp_visual/particle_up/particles = new(null, src, spell_rune)
	vis_contents |= particles
	particles.color = spell_color

	addtimer(CALLBACK(src, PROC_REF(start_spell_particles), spell_color), 3.6 SECONDS)

/// Finish spell visual effects on successful cast. Cleans up rune and creates wave_up.
/mob/living/proc/finish_spell_visual_effects(spell_color = "#FFFFFF")
	if(QDELETED(src))
		return

	if(spell_rune)
		QDEL_NULL(spell_rune)

	var/obj/effect/temp_visual/wave_up/wave = new(null, src)
	vis_contents |= wave
	wave.color = spell_color

/// Cancel spell visual effects. Cleans up rune (particles auto-clean via signal).
/mob/living/proc/cancel_spell_visual_effects()
	if(QDELETED(src))
		return

	if(spell_rune)
		QDEL_NULL(spell_rune)

