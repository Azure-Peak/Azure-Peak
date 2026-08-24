#define GNOLL_STEALTH_TIMER 60 SECONDS
#define GNOLL_ABDUCT_TIMER 20 SECONDS
#define GNOLL_ABDUCT_DAMAGE_TRESHOLD 100

/obj/effect/proc_holder/spell/self/claws/gnoll
	name = "Gnoll Claws"
	claw_type = /obj/item/rogueweapon/werewolf_claw/gnoll

/obj/effect/proc_holder/spell/self/howl/gnoll
	howl_sounds = list('sound/vo/mobs/gnoll/yeen_howl.ogg')
	howl_sounds_far = list('sound/vo/mobs/hyena/gnoll_distant.ogg')
	wolf_antag_type = /datum/antagonist/gnoll
	howl_spies_allowed = FALSE
	howl_distance_limit = 20

/obj/effect/proc_holder/spell/invoked/gnoll_sniff
	name = "Track"
	desc = "Graggar has some worthy folks for you, hunt them down! Cast on self to set target, cast to track target, cast on a person to remember their scent temporarily"
	recharge_time = 0.5 SECONDS
	chargetime = 0.1 SECONDS
	overlay_icon = 'icons/mob/actions/gnollmiracles.dmi'
	action_icon = 'icons/mob/actions/gnollmiracles.dmi'
	overlay_state = "sniff"
	invocation_type = "emote"
	action_icon_state = "sniff"
	invocation_emote_self = "<span class='notice'>I sniff the air.</span>"
	var/alist/combat_roles = list(
		"Orthodoxist" = TRUE,
		"Absolver" = TRUE,
		"Templar" = TRUE,
		"Sergeant" = TRUE,
		"Men-at-arms" = TRUE,
		"Knight" = TRUE,
		"Squire" = TRUE,
		"Mercenary" = TRUE,
		"Warden" = TRUE,
		"Acolyte" = TRUE,
		"Adventurer" = TRUE
	)
	var/mob/living/tracked_target = null
	var/shown_hunt_disclaimer = FALSE

/obj/effect/proc_holder/spell/invoked/gnoll_sniff/cast(list/targets, mob/user)
	var/mob/living/target = targets[1]

	if(!tracked_target || QDELETED(tracked_target) || tracked_target.stat == DEAD || target == user)
		select_new_target(user)
	else
		give_tracking_directions(user)

	if(is_valid_hunted(target) && target != user)
		tracked_target = target
		to_chat(user, span_notice("You catch the scent of [target.real_name]. The hunt begins!"))
		user.playsound_local(get_turf(user), 'sound/vo/mobs/wwolf/sniff.ogg', 50, TRUE)
	else if (!tracked_target)
		to_chat(user, span_warning("[target] isn't something you can hunt."))
		revert_cast()
		return FALSE

	return TRUE

/obj/effect/proc_holder/spell/invoked/gnoll_sniff/proc/select_new_target(mob/user)
	var/list/possible_targets = list()

	for(var/mob/living/L in GLOB.player_list)
		if(L == user || istype(L, /mob/living/carbon/human/dummy) || !L.mind)
			continue
		var/is_hunted = L.has_flaw(/datum/charflaw/hunted)
		// Don't uncomment for now
		// var/target_role = L.job
		var/is_valid_prey = is_hunted
		// if(!is_valid_prey)
		//	if(target_role in combat_roles)
		//		is_valid_prey = TRUE
		if(is_valid_prey)
			var/entry_name = "[L.real_name]"
			possible_targets[entry_name] = L

	if(!length(possible_targets))
		to_chat(user, span_warning("The air is stale. No hunted souls are in the region."))
		return

	var/selection = input(user, "Whose scent shall we follow?", "The Great Hunt") as null|anything in sort_list(possible_targets)
	if(!selection)
		return

	if(!shown_hunt_disclaimer)
		to_chat(user, span_boldnotice("You have chosen your first prey. Remember to judge whether or not your target is a worthy foe. Graggar does not reward spilling the blood of the meek when you have this much to prove."))
		to_chat(user, span_boldwarning("(Escalation is still required. You can always still do other gnoll things if targets are too difficult.)"))
		shown_hunt_disclaimer = TRUE

	tracked_target = possible_targets[selection]
	to_chat(user, span_notice("You focus your senses on [tracked_target.real_name]."))
	give_tracking_directions(user)

/obj/effect/proc_holder/spell/invoked/gnoll_sniff/proc/give_tracking_directions(mob/user)
	if(!tracked_target || QDELETED(tracked_target) || tracked_target.stat == DEAD)
		to_chat(user, span_warning("The scent has gone cold... your target is no more."))
		tracked_target = null
		return

	var/turf/user_turf = get_turf(user)
	var/turf/target_turf = get_turf(tracked_target)

	if(user_turf.z != target_turf.z)
		to_chat(user, span_notice("The scent of [tracked_target.real_name] drifts from [user_turf.z > target_turf.z ? "below" : "above"] you."))
	else
		var/dist = get_dist(user, tracked_target)
		var/dir_text = dir2text(get_dir(user, tracked_target))

		if(dist <= 1)
			to_chat(user, span_boldnotice("The prey is right here! Blood and steel!"))
		else if(dist < 10)
			to_chat(user, span_notice("The scent is thick to the [dir_text]. They are very close."))
		else
			to_chat(user, span_notice("You catch a faint whiff of [tracked_target.real_name] to the [dir_text]."))

/obj/effect/proc_holder/spell/invoked/gnoll_sniff/proc/is_valid_hunted(atom/A)
	if(!isliving(A))
		return FALSE
	var/mob/living/L = A
	if(!L || QDELETED(L) || L.stat == DEAD)
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/invoked/abduct
	name = "Abduct"
	desc = "Cast on self to set a destination. Cast on an aggressively grabbed human to teleport them and nearby Gnolls to that destination. Much faster on hunted targets. There is a small blood tax for all gnolls involved, be careful. Pursuers may be able to follow. Can't be cast if damaged severely recently."
	var/turf/destination_turf
	var/blood_loss = 75
	recharge_time = 5 MINUTES
	invocation_type = "emote"
	invocation_emote_self = "<span class='notice'>I rip a tear in reality with my claw!</span>"
	overlay_icon = 'icons/mob/actions/gnollmiracles.dmi'
	action_icon = 'icons/mob/actions/gnollmiracles.dmi'
	overlay_state = "abduct"
	action_icon_state = "abduct"

/obj/effect/proc_holder/spell/invoked/abduct/cast(list/targets, mob/user)
	if(targets[1] == user)
		to_chat(user, span_notice("You begin setting your anchor for abduction."))
		if(do_after(user, 10 SECONDS, target = user))
			destination_turf = get_turf(user)
			to_chat(user, span_notice("You anchor your connection to graggar's plane here. Any abducted will be fetched here."))
		// We are reverting cast because we're only setting the destination.
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/target = targets[1]
	if(!ishuman(target))
		to_chat(user, span_warning("This spell only works on humans or yourself!"))
		revert_cast()
		return FALSE

	if(user.pulling != target || user.grab_state < GRAB_AGGRESSIVE)
		to_chat(user, span_warning("You must have an aggressive grab on [target] to begin the ritual!"))
		revert_cast()
		return FALSE

	// Shouldn't ever prop up, but sanity check!
	if(!destination_turf)
		to_chat(user, span_warning("You haven't set a destination anchor yet!"))
		revert_cast()
		return FALSE

	var/datum/component/gnoll_combat_tracker/tracker = user.GetComponent(/datum/component/gnoll_combat_tracker)
	if(!tracker)
		tracker = user.AddComponent(/datum/component/gnoll_combat_tracker)

	if(tracker.get_recent_damage() > GNOLL_ABDUCT_DAMAGE_TRESHOLD)
		to_chat(user, span_warning("You've taken too much punishment recently to focus on the abduction, you flinch!"))
		revert_cast()
		return FALSE

	// Determine Channel Time
	var/channel_time = 15 SECONDS
	if(target.has_flaw(/datum/charflaw/hunted))
		channel_time = 6 SECONDS

	to_chat(user, span_notice("You begin pulling [target] into graggar's plane"))
	to_chat(target, span_userdanger("The world around you begins to dissolve into a blood scented nightmare!"))
	user.visible_message(span_userdanger("[user] tears a blood red rift into space with a claw, and begins dragging [target] into it!"))
	tracker.channeling_abduction = TRUE

	if(!do_after(user, channel_time, target = target))
		tracker.channeling_abduction = FALSE
		revert_cast()
		return FALSE

	// Extra safety check
	if(tracker.get_recent_damage() > GNOLL_ABDUCT_DAMAGE_TRESHOLD)
		tracker.channeling_abduction = FALSE
		to_chat(user, span_warning("The pain of your wounds disrupts the abduction at the last moment!"))
		revert_cast()
		return FALSE

	// Ritual Execution
	var/turf/origin_turf = get_turf(target)
	var/gnoll_hitchhikers = 0

	do_teleport(user, destination_turf)
	do_teleport(target, destination_turf)

	if(ishuman(user))
		var/mob/living/carbon/human/userashuman = user
		userashuman.blood_volume = max(0, userashuman.blood_volume - blood_loss)
	for(var/mob/living/carbon/human/H in range(7, origin_turf))
		if(H.dna?.species?.id == "gnoll" && !user)
			gnoll_hitchhikers++
			H.blood_volume = max(0, H.blood_volume - blood_loss)
			do_teleport(H, destination_turf)
			to_chat(H, span_notice("You are swept along in the wake of the blood abduction!"))

	// Basically, if a gnoll is baddass enough to abduct his target alone, no one can follow
	if(gnoll_hitchhikers)
		var/obj/structure/portal_jaunt/portal = new(origin_turf)
		portal.linked_turf = destination_turf
		portal.safe_passage = TRUE
		portal.name = "fading blood rift"
		portal.color = "#570f04"
		portal.max_uses = 1
	new /obj/effect/gibspawner/human/bodypartless(origin_turf, target)

	to_chat(user, span_warning("The ritual is complete. You have brought them to your anchor."))
	tracker.channeling_abduction = FALSE
	return TRUE

/datum/component/gnoll_combat_tracker
	var/damage_taken = 0
	var/last_damage_time = 0
	var/death_loot_given = FALSE
	var/channeling_abduction = FALSE

/datum/component/gnoll_combat_tracker/Initialize(mapload)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_MOB_APPLY_DAMGE, PROC_REF(on_damage))
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_death))

/datum/component/gnoll_combat_tracker/proc/on_damage(datum/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	last_damage_time = world.time
	damage_taken += damage

	if(channeling_abduction && ishuman(parent) && get_recent_damage() >= GNOLL_ABDUCT_DAMAGE_TRESHOLD)
		var/mob/living/carbon/human/H = parent
		// micro stun to break any do_afters
		// asyncronous as to not mess with signal behavior!
		spawn(0)
			H.Stun(1)
		to_chat(H, span_userdanger("The pain interrupts your concentration!"))
		channeling_abduction = FALSE // Reset channel flag

/datum/component/gnoll_combat_tracker/proc/on_death()
	SIGNAL_HANDLER
	if(!death_loot_given)
		var/obj/item/loot = pick(/obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll, /obj/item/roguegem/blood_diamond)
		var/mob/living/gnoll = parent
		new loot(gnoll.loc)
		gnoll.visible_message(span_notice("A piece of [loot.name] is put down by a bloody ethereal hand, poised neatly by the gnoll's corpse."))
		death_loot_given = TRUE

/datum/component/gnoll_combat_tracker/proc/can_cast_stealth()
	// Returns TRUE if 1 minute has passed
	var/mob/living/carbon/human/H = parent
	var/datum/status_effect/vampiric_fury/F = H.has_status_effect(/datum/status_effect/vampiric_fury)
	if(F)
		to_chat(H, span_userdanger("You are too furious to concentrate on stealth!"))
		return FALSE
	return (world.time >= last_damage_time + GNOLL_STEALTH_TIMER)

/datum/component/gnoll_combat_tracker/proc/get_recent_damage()
	if(world.time >= last_damage_time + GNOLL_ABDUCT_TIMER)
		damage_taken = 0
	return damage_taken

/obj/effect/proc_holder/spell/invoked/invisibility/gnoll
	name = "Stalk"
	desc = "Fade from view. Lasts until you attack. Taking damage makes it impossible to go invisible for a minute."
	var/obj/effect/proc_holder/spell/invoked/gnoll_sniff/sniff_spell
	recharge_time = 2 MINUTES
	overlay_icon = 'icons/mob/actions/gnollmiracles.dmi'
	action_icon = 'icons/mob/actions/gnollmiracles.dmi'
	overlay_state = "stalk"
	action_icon_state = "stalk"
	ignore_combat_tag = TRUE

/obj/effect/proc_holder/spell/invoked/invisibility/gnoll/cast(list/targets, mob/living/user)
	var/mob/living/target = user
	if(!isliving(target))
		revert_cast()
		return FALSE

	// Check Damage Tracker Component
	var/datum/component/gnoll_combat_tracker/tracker = user.GetComponent(/datum/component/gnoll_combat_tracker)
	if(tracker && !tracker.can_cast_stealth())
		var/wait = (tracker.last_damage_time + 60 SECONDS - world.time) / 10
		to_chat(user, span_warning("Your blood is pumping too fast to use it to shroud yourself! Wait [round(wait)] seconds."))
		revert_cast()
		return FALSE

	if(target.anti_magic_check(TRUE, TRUE))
		revert_cast()
		return FALSE

	// Practically indefinite
	var/base_dur = 999 MINUTES

	target.visible_message(span_warning("[target] vanishes into the scent of the hunt!"), span_notice("You vanish, the hunt guides your shadows."))

	animate(target, alpha = 0, time = 1 SECONDS, easing = EASE_IN)
	target.mob_timers[MT_INVISIBILITY] = world.time + base_dur

	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living, update_sneak_invis), TRUE), base_dur)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/atom/movable, visible_message), span_warning("[target] lunges out of the shadows!"), span_notice("Your invisibility fades.")), base_dur)

	return TRUE

#undef GNOLL_STEALTH_TIMER
#undef GNOLL_ABDUCT_TIMER
#undef GNOLL_ABDUCT_DAMAGE_TRESHOLD

/datum/action/cooldown/spell/gnoll/consume
	name = "Consume"
	desc = "Feast on flesh, bones, or bodies to recover from battle. Cast on yourself to consume items in hand, or on a corpse to begin to consume it. More effective on animal corpses. Can heal others when targeting them."
	fluff_desc = "The hunger for flesh is eternal in Gnolls. They hunt to sate this desire, endlessly, for they are Graggar's chosen."
	button_icon = 'icons/mob/actions/gnollmiracles.dmi'
	button_icon_state = "consume"
	glow_intensity = 0

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_ADJACENT
	// I like showing icons ok?
	charge_time = 0.1 SECONDS
	charge_required = TRUE
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	spell_color = "#6d0000"

	primary_resource_cost = NONE

	invocation_type = INVOCATION_NONE
	charge_required = FALSE
	cooldown_time = 10 SECONDS

	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	/// Internal counter for meat consumption loops
	var/consume_counter = 0

/datum/action/cooldown/spell/gnoll/consume/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner

	// corpse eating
	if(isliving(cast_on) && !(cast_on == owner))
		var/mob/living/corpse = cast_on
		var/was_player = null
		if(ishuman(corpse))
			var/mob/living/carbon/human/C = cast_on
			was_player = C.mind || C.last_mind || C.ckey

		// If it's a corpse and was not a player
		if(corpse.stat == DEAD && !was_player)
			var/is_animal = istype(corpse, /mob/living/simple_animal)
			if(is_animal)
				var/mob/living/simple_animal/animal = corpse
				if(animal.initial_butcher_count > 0 && length(animal.butcher_results) < animal.initial_butcher_count)
					to_chat(owner, span_warning("This creature has already been partially butchered! There's not enough left to consume."))
					return FALSE

			to_chat(owner, span_notice("You begin to consume [corpse.name]."))
			if(do_after(owner, 20 SECONDS, corpse))
				corpse.gib()
				to_chat(owner, span_notice("You finish consuming [corpse.name], restoring your physical form."))
				H.apply_status_effect(/datum/status_effect/buff/healing, 20)
				if(is_animal)
					heal_gnoll(H, 100)
					restore_armor_integrity(H, 80)
				else
					restore_armor_integrity(H, 35)
			return TRUE

	// Healing others and self.
	var/obj/item/reagent_containers/food/snacks/rogue/meat_to_eat = null
	var/meat_base_armor_heal = 3
	var/meat_base_heal = 7
	var/obj/item/held_item = owner.get_active_held_item()
	if(istype(held_item, /obj/item/reagent_containers/food/snacks/rogue/meat) || istype(held_item, /obj/item/reagent_containers/food/snacks/rogue/meat_rotten))
		meat_to_eat = held_item

	if(istype(meat_to_eat, /obj/item/reagent_containers/food/snacks/rogue/meat_rotten))
		meat_base_armor_heal = 1.5
		meat_base_heal = 3.5

	if(!meat_to_eat)
		to_chat(H, span_warning("You need to target corpses, yourself, or an ally while holding meat to eat or feed!"))
		return FALSE

	var/mob/living/carbon/human/receiver = owner
	if(ishuman(cast_on) && cast_on != owner)
		receiver = cast_on

	var/holy_level = owner.get_skill_level(/datum/skill/magic/holy)
	var/heal_multiplier = 1

	if(receiver != owner)
		if(holy_level > 4)
			heal_multiplier = 1.3
		else if(holy_level > 2)
			heal_multiplier = 1.0
		else
			heal_multiplier = 0.6
	var/receiver_is_gnoll = (receiver.dna?.species?.type == /datum/species/gnoll)

	if(consume_counter == 0)
		if(receiver == owner)
			to_chat(owner, span_notice("You begin to consume the [meat_to_eat.name], savoring the taste of fresh meat."))
		else
			to_chat(owner, span_notice("You begin feeding the [meat_to_eat.name] to [receiver.name]."))
			to_chat(receiver, span_notice("[owner.name] begins feeding you [meat_to_eat.name]."))
	else
		to_chat(owner, span_notice("You continue consuming the [meat_to_eat.name]... ([consume_counter]/10)"))

	while(consume_counter < 10)
		if(QDELETED(meat_to_eat) || (meat_to_eat.loc != owner && meat_to_eat != cast_on))
			to_chat(owner, span_warning("You stop consuming - the meat is gone!"))
			return FALSE
		if(!do_after(owner, 2 SECONDS, receiver))
			to_chat(owner, span_warning("The feeding process was interrupted."))
			return FALSE

		consume_counter++
		if(prob(40))
			playsound(receiver.loc, 'sound/misc/eat.ogg', rand(30,60), TRUE)

		heal_gnoll(receiver, meat_base_heal * heal_multiplier)
		if(receiver_is_gnoll)
			restore_armor_integrity(receiver, meat_base_armor_heal * heal_multiplier)

		var/obj/effect/temp_visual/heal/heal_effect = new /obj/effect/temp_visual/heal_rogue(get_turf(receiver))
		heal_effect.color = "#FF0000"

		if(consume_counter < 10 && prob(25))
			if(receiver == owner)
				to_chat(owner, span_notice("You continue consuming the [meat_to_eat.name]..."))
			else
				to_chat(owner, span_notice("You continue feeding [receiver.name]..."))

	var/meat_name = meat_to_eat ? meat_to_eat.name : "meat"
	if(!QDELETED(meat_to_eat))
		qdel(meat_to_eat)

	if(receiver == owner)
		to_chat(owner, span_notice("You gluttonously gobble down the [meat_name], feeling reinvigorated."))
	else
		to_chat(owner, span_notice("You finish feeding the [meat_name] to [receiver.name]."))
		to_chat(receiver, span_notice("[owner.name] finishes feeding you the [meat_name], leaving you reinvigorated."))

	consume_counter = 0
	return TRUE

/datum/action/cooldown/spell/gnoll/consume/proc/heal_gnoll(mob/living/carbon/human/H, heal_amt = 7)
	if(!H)
		return

	if(H.blood_volume < BLOOD_VOLUME_NORMAL)
		H.blood_volume = min(H.blood_volume + heal_amt, BLOOD_VOLUME_NORMAL)
	var/list/wCount = H.get_wounds()
	if(length(wCount))
		H.heal_wounds(heal_amt)
		H.update_damage_overlays()
	H.adjustBruteLoss(-heal_amt, 0)
	H.adjustFireLoss(-heal_amt, 0)
	H.adjustOxyLoss(-heal_amt, 0)
	H.adjustToxLoss(-heal_amt, 0)
	H.adjustOrganLoss(ORGAN_SLOT_BRAIN, -heal_amt)
	H.adjustCloneLoss(-heal_amt, 0)
	// 280 for a full piece of meat.
	// 400 for a corpse.
	H.energy_add(heal_amt * 4)

/datum/action/cooldown/spell/gnoll/consume/proc/restore_armor_integrity(mob/living/carbon/human/H, percent)
	if(!H)
		return

	if(!H.skin_armor)
		return

	var/obj/item/clothing/suit/roguetown/armor/skin_armor = H.skin_armor
	if(!istype(skin_armor))
		return

	var/heal_amount = round(skin_armor.max_integrity * (percent / 100))

	skin_armor.obj_integrity = min(skin_armor.obj_integrity + heal_amount, skin_armor.max_integrity)

	if(skin_armor.obj_broken && skin_armor.obj_integrity > 0)
		skin_armor.obj_fix(null, FALSE)
