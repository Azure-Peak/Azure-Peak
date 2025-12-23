#define CHURN_FILTER "churn_glow"

// T1: Avert End (channel on an adjacent target to slowly spend devotion to grant them NODEATH and ticks of oxyloss healing)

/obj/effect/proc_holder/spell/invoked/avert
	name = "Borrowed Time"
	desc = "Shield your fellow man from the Undermaiden's gaze, preventing them from slipping into death for as long as your faith and fatigue may muster."
	overlay_state = "borrowtime"
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy
	miracle = TRUE
	devotion_cost = 10
	var/list/near_death_lines = list(
		"A haze begins to envelop me, but then suddenly recedes, as if warded back by some great light...",
		"A terrible weight bears down upon me, as if the wyrld itself were crushing me with its heft...",
		"The sound of a placid river drifts into hearing, followed by the ominous toll of a ferryman's bell...",
		"Some vast, immeasurably distant figure looms beyond my perception - I feel it, more than I see. It waits. It watches.",
	)

/obj/effect/proc_holder/spell/invoked/avert/cast(list/targets, mob/living/carbon/human/user)
	. = ..()
	var/atom/target = targets[1]
	if (!isliving(target))
		revert_cast()
		return FALSE

	var/mob/living/living_target = target
	if (!user.Adjacent(target))
		to_chat(user, span_warning("I must be beside [living_target] to avert Her gaze from [living_target.p_them()]!"))
		revert_cast()
		return FALSE

	// add the no-death trait to them....
	user.visible_message(span_notice("Whispering motes gently bead from [user]'s fingers as [user.p_they()] place a hand near [living_target], scriptures of the Undermaiden spilling from their lips..."), span_notice("I stand beside [living_target] and utter the hallowed words of Aeon's Intercession, staying Her grasp for just a little while longer..."))
	to_chat(user, span_small("I must remain still and at [living_target]'s side..."))
	to_chat(living_target, span_warning("An odd sensation blossoms in my chest, cold and unknown..."))

	ADD_TRAIT(living_target, TRAIT_NODEATH, "avert_spell")

	var/our_holy_skill = user.get_skill_level(associated_skill)
	var/tickspeed = 30 + (5 * our_holy_skill)

	while (do_after(user, tickspeed, target = living_target))
		user.stamina_add(2.5)

		living_target.adjustOxyLoss(-10)
		living_target.blood_volume = max((BLOOD_VOLUME_SURVIVE * 1.5), living_target.blood_volume)

		if (living_target.health <= 5)
			if (prob(5))
				to_chat(living_target, span_small(pick(near_death_lines)))

		if (user.devotion?.check_devotion(src))
			user.devotion?.update_devotion(-10)
		else
			to_chat(span_warning("My devotion runs dry - the Intercession fades from my lips!"))
			break

	REMOVE_TRAIT(living_target, TRAIT_NODEATH, "avert_spell")

	user.visible_message(span_danger("[user]'s concentration breaks, the motes receding from [living_target] and into [user.p_their()] hand once more."), span_danger("My concentration breaks, and the Intercession falls silent."))

/obj/effect/proc_holder/spell/targeted/abrogation
	name = "Abrogation"
	desc = "Debuffs targeted undead as long as they remain near you, slowly getting set on fire if they stay."
	range = 8
	overlay_state = "necra"
	releasedrain = 30
	chargedloop = /datum/looping_sound/invokeholy
	chargetime = 50
	chargedrain = 0.5
	recharge_time = 30 SECONDS
	max_targets = 0
	cast_without_targets = TRUE
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/holy
	invocations = list("The Undermaiden rebukes!")
	invocation_type = "shout" //can be none, whisper, emote and shout
	miracle = TRUE
	devotion_cost = 20

/obj/effect/proc_holder/spell/targeted/abrogation/cast(list/targets, mob/living/user = usr)
	. = ..()
	var/debuff_power = 1
	if (user && user.mind)
		debuff_power = clamp((user.get_skill_level(/datum/skill/magic/holy) / 2), 1, 3)

	var/too_powerful = FALSE
	var/list/things_to_churn = list()
	var/list/things_to_stun = list()
	for (var/mob/living/L in targets)
		var/is_vampire = FALSE
		var/is_zombie = FALSE
		if(L.stat == DEAD)
			continue
		if (L.mind)
			var/datum/antagonist/vampire/V = L.mind.has_antag_datum(/datum/antagonist/vampire)
			if(V && SEND_SIGNAL(L, COMSIG_DISGUISE_STATUS))
				is_vampire = TRUE
			if (L.mind.has_antag_datum(/datum/antagonist/zombie))
				is_zombie = TRUE
				things_to_stun += L
			if (L.mind.special_role == "Vampire Lord")
				too_powerful = L
				user.visible_message(span_warning("[user] suddenly pales before an unseen presence, and gasps!"), span_warning("The sound of rushing blood fills my ears and mind, drowning out my abrogation!"))
				break
		if (L.mob_biotypes & MOB_UNDEAD || is_vampire || is_zombie)
			things_to_churn += L

	if (!too_powerful)
		if (LAZYLEN(things_to_churn))
			user.visible_message(span_warning("A frigid blue glower suddenly erupts in [user]'s eyes as a whispered prayer summons forth a winding veil of ghostly mists!"), span_notice("I perform the sacred rite of Abrogation, bringing forth Her servants to harry and weaken the unliving!"))
			for(var/mob/living/thing in things_to_churn)
				thing.apply_status_effect(/datum/status_effect/churned, user, debuff_power)
		if(LAZYLEN(things_to_stun))
			for(var/mob/living/thing in things_to_churn)
				thing.Stun(100)
				thing.Knockdown(50)
				thing.emote("scream")
		if(!LAZYLEN(things_to_churn))
			to_chat(user, span_notice("The rite of Abrogation passes from my lips in silence, having found nothing to assail."))
			return
	else
		user.Stun(25)
		user.throw_at(get_ranged_target_turf(user, get_dir(user,too_powerful), 7), 7, 1, too_powerful, spin = FALSE)
		user.visible_message(span_warning("[user] ceases their prayer, suddenly choking upon a gout of blood in their throat!"), span_boldwarning("My vision swims in red!"))

/atom/movable/screen/alert/status_effect/churned
	name = "Churning Essence"
	desc = "The magicks that bind me into being are being disrupted! I should get away from the source as soon as I can!"
	icon_state = "stressvb"

/datum/status_effect/churned
	id = "necra_churned"
	alert_type = /atom/movable/screen/alert/status_effect/churned
	duration = 30 SECONDS
	examine_text = "<b>SUBJECTPRONOUN is wreathed in a wild frenzy of ghostly motes!</b>"
	effectedstats = list(STATKEY_STR = -2, STATKEY_CON = -2, STATKEY_WIL = -2, STATKEY_SPD = -2)
	status_type = STATUS_EFFECT_REFRESH
	var/datum/weakref/debuffer
	var/outline_colour = "#33cabc"
	var/base_tick = 0.2
	var/intensity = 1
	var/range = 10

/datum/status_effect/churned/on_creation(mob/living/new_owner, mob/living/caster, potency)
	intensity = potency
	if (caster)
		debuffer = WEAKREF(caster)
	return ..()

/datum/status_effect/churned/on_apply()
	var/filter = owner.get_filter(CHURN_FILTER)
	to_chat(owner, span_warning("Wisps leap from the cloying mists to surround me, their chill disrupting my body! FLEE!"))
	if (!filter)
		owner.add_filter(CHURN_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 200, "size" = 1))
	return TRUE

/datum/status_effect/churned/refresh()
	. = ..()
	intensity += 1
	to_chat(owner, span_boldwarning("The mists intensify, the glowing wisps steadily disrupting my body..."))

/datum/status_effect/churned/process()
	. = ..()
	if (!owner)
		return
	if (prob(33))
		owner.adjustFireLoss(base_tick * intensity)
	if (prob(10))
		to_chat(owner, span_warning("A frenzy of ghostly motes assail my form!"))
		owner.emote("scream")

	var/mob/living/our_debuffer = debuffer.resolve()
	if (get_dist(our_debuffer, owner) > range)
		to_chat(owner, span_notice("I've escaped the cloying mists!"))
		qdel(src)

/datum/status_effect/churned/on_remove()
	owner.remove_filter(CHURN_FILTER)

#undef CHURN_FILTER

/obj/effect/proc_holder/spell/targeted/locate_dead
	name = "Locate Corpse"
	desc = "Call upon the Undermaiden to guide you to a lost soul."
	overlay_state = "necraeye"
	sound = 'sound/magic/whiteflame.ogg'
	releasedrain = 30
	chargedrain = 0.5
	max_targets = 0
	cast_without_targets = TRUE
	miracle = TRUE
	associated_skill = /datum/skill/magic/holy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	invocations = list("Undermaiden, guide my hand to those who have lost their way.")
	invocation_type = "whisper"
	recharge_time = 15 SECONDS
	devotion_cost = 35

/obj/effect/proc_holder/spell/targeted/locate_dead/cast(list/targets, mob/living/user = usr)
	. = ..()
	var/list/mob/corpses = list()
	for(var/mob/living/C in GLOB.dead_mob_list)
		if(!C.mind)
			continue

		var/time_dead = 0
		if(C.timeofdeath)
			time_dead = world.time - C.timeofdeath
		var/corpse_name

		if(time_dead < 5 MINUTES)
			corpse_name = "Fresh corpse "
		else if(time_dead < 10 MINUTES)
			corpse_name = "Recently deceased "
		else if(time_dead < 30 MINUTES)
			corpse_name = "Long dead "
		else
			corpse_name = "Forgotten remains of "
		var/list/d_list = C.get_mob_descriptors()
		var/trait_desc = "[capitalize(build_coalesce_description_nofluff(d_list, C, list(MOB_DESCRIPTOR_SLOT_TRAIT), "%DESC1%"))]"
		var/stature_desc = "[capitalize(build_coalesce_description_nofluff(d_list, C, list(MOB_DESCRIPTOR_SLOT_STATURE), "%DESC1%"))]"
		var/descriptor_name = "[trait_desc] [stature_desc]"
		if(descriptor_name == " ")
			descriptor_name = "Unknown"

		corpse_name += " of \a [descriptor_name]..."
		corpses[corpse_name] = C

	if(!length(corpses))
		to_chat(user, span_warning("The Undermaiden's grasp lets slip."))
		return .

	var/mob/selected = tgui_input_list(user, "Which body shall I seek?", "Available Bodies", corpses)

	if(QDELETED(src) || QDELETED(user) || QDELETED(corpses[selected]))
		to_chat(user, span_warning("The Undermaiden's grasp lets slip."))
		return .

	var/corpse = corpses[selected]

	var/turf/turf_user = get_turf(user)
	var/turf/turf_corpse = get_turf(corpse)
	var/direction_name = "unknown"
	if(turf_user.z != turf_corpse.z)
		if(turf_corpse.z > turf_user.z)
			direction_name = "above"
		else
			direction_name = "below"
	else
		var/direction = get_dir(user, corpse)
		switch(direction)
			if(NORTH)
				direction_name = "north"
			if(SOUTH)
				direction_name = "south"
			if(EAST)
				direction_name = "east"
			if(WEST)
				direction_name = "west"
			if(NORTHEAST)
				direction_name = "northeast"
			if(NORTHWEST)
				direction_name = "northwest"
			if(SOUTHEAST)
				direction_name = "southeast"
			if(SOUTHWEST)
				direction_name = "southwest"

	to_chat(user, span_notice("The Undermaiden pulls on your hand, guiding you [direction_name]."))

/obj/effect/proc_holder/spell/invoked/necra_vow
	name = "Vow to Necra"
	desc = "Make a vow to Necra. Your chances of revival or recovery of limb will be greatly reduced. You will harm undeath and heal yourself at a slow rate."
	range = 1
	overlay_state = "necra"
	releasedrain = 30
	chargedloop = /datum/looping_sound/invokeholy
	chargetime = 50
	chargedrain = 0.5
	recharge_time = 30 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/holy
	invocations = list("The Undermaiden Protects.")
	invocation_type = "shout"
	miracle = TRUE
	devotion_cost = 100

/obj/effect/proc_holder/spell/invoked/necra_vow/cast(list/targets, mob/living/user = usr)
	if(ishuman(targets[1]))
		var/mob/living/carbon/human/H = targets[1]
		if(HAS_TRAIT(H, TRAIT_ROTMAN) || HAS_TRAIT(H, TRAIT_NOBREATH) || H.mob_biotypes & MOB_UNDEAD)	//No Undead, no Rotcured, no Deathless
			to_chat(user, span_warning("Necra cares not for the vows of the corrupted."))
			revert_cast()
			return FALSE
		if(H.has_status_effect(/datum/status_effect/buff/necras_vow) || H.patron?.type != /datum/patron/divine/necra)
			to_chat(user, span_notice("They have already pledged a vow."))
			revert_cast()
			return FALSE
		var/choice = alert(H, "You are being asked to pledge a vow. Your chances of revival or recovery of limb will be greatly reduced. You will harm undeath and heal yourself at a slow rate. Do you agree?", "VOW", "Yes", "No")
		if(choice != "Yes")
			to_chat(user, span_notice("They declined."))
			return TRUE
		user.visible_message(span_warning("[user] grants [H] the blessing of their promise."))
		to_chat(H, span_warning("I have committed. There is no going back."))
		H.apply_status_effect(/datum/status_effect/buff/necras_vow)
		H.apply_status_effect(/datum/status_effect/buff/healing/necras_vow)

/atom/movable/screen/alert/status_effect/buff/necras_vow
	name = "Vow to Necra"
	desc = "I have pledged a promise to Necra. Undeath shall be harmed or lit aflame if they strike me. Rot will not claim me. Lost limbs can only be restored if they are myne."
	icon_state = "necravow"

#define NECRAVOW_FILTER "necravow_glow"

/datum/status_effect/buff/necras_vow
	var/outline_colour ="#929186" // A dull grey.
	id = "necravow"
	alert_type = /atom/movable/screen/alert/status_effect/buff/necras_vow
	effectedstats = list(STATKEY_CON = 2)
	duration = -1

/datum/status_effect/buff/necras_vow/on_apply()
	. = ..()
	var/filter = owner.get_filter(NECRAVOW_FILTER)
	if (!filter)
		owner.add_filter(NECRAVOW_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 200, "size" = 1))
	ADD_TRAIT(owner, TRAIT_NECRAS_VOW, TRAIT_MIRACLE)
	owner.rot_type = null
	to_chat(owner, span_warning("My limbs feel more alive than ever... I feel whole..."))

/datum/status_effect/buff/necras_vow/on_remove()
	. = ..()
	owner.remove_filter(NECRAVOW_FILTER)
	to_chat(owner, span_warning("My body feels strange... hollow..."))

#undef NECRAVOW_FILTER

/obj/effect/proc_holder/spell/invoked/necras_sight
	name = "Necra's Sight"
	desc = "Mark a psycross or a grave marker, and peer through them."
	releasedrain = 30
	chargetime = 0 SECONDS
	recharge_time = 10 SECONDS
	warnie = "spellwarning"
	invocation_type = "whisper"
	invocations = list("Undermaiden guide my gaze...")
	associated_skill = /datum/skill/magic/holy
	overlay_state = "necraeye"
	miracle = TRUE
	devotion_cost = 30
	range = 1
	var/static/list/whitelisted_objects = list(/obj/structure/gravemarker, /obj/structure/fluff/psycross, /obj/structure/fluff/psycross/copper, /obj/structure/fluff/psycross/crafted)
	var/list/marked_objects = list()
	var/outline_color = "#4ea1e6"
	var/last_index = 1

/obj/effect/proc_holder/spell/invoked/necras_sight/cast(list/targets, mob/user)
	var/success
	if(isobj(targets[1]))
		var/obj/O = targets[1]
		if((O.type in whitelisted_objects))
			add_to_scry(O, user)
			return TRUE
	if(isturf(targets[1]))
		var/turf/T = targets[1]
		for(var/obj/O in T)
			if((O.type in whitelisted_objects))
				add_to_scry(O, user)
				return TRUE
		if(length(marked_objects))
			success = try_scry(user)
	if(ismob(targets[1]))
		if(length(marked_objects))
			success = try_scry(user)
	if(success)
		return TRUE
	revert_cast()
	return FALSE

#define GRAVE_SPY "grave_spy"

/obj/effect/proc_holder/spell/invoked/necras_sight/proc/try_scry(mob/living/carbon/human/user)
	listclearnulls(marked_objects)
	var/selected_grave = input(user, "Which Grave shall we peer through?", "") as null|anything in marked_objects
	if(selected_grave)
		var/obj/structure/gravemarker/spygrave = selected_grave
		var/filter = spygrave.get_filter(GRAVE_SPY)
		if(!filter)
			spygrave.add_filter(GRAVE_SPY, 2, list("type" = "outline", "color" = outline_color, "alpha" = 200, "size" = 1))
		var/mob/dead/observer/screye/S = user.scry_ghost()
		spygrave.visible_message(span_warning("[spygrave] shimmers with an eerie glow."))
		if(!S)
			return FALSE
		S.ManualFollow(spygrave)
		user.visible_message(span_danger("[user] blinks, [user.p_their()] eyes rolling back into [user.p_their()] head."))
		user.playsound_local(get_turf(user), 'sound/magic/necra_sight.ogg', 80)
		addtimer(CALLBACK(S, TYPE_PROC_REF(/mob/dead/observer, reenter_corpse)), (8 SECONDS))
		addtimer(CALLBACK(spygrave, TYPE_PROC_REF(/atom/movable, remove_filter), GRAVE_SPY), (8 SECONDS))
		return TRUE
	else
		return FALSE

#undef GRAVE_SPY

/obj/effect/proc_holder/spell/invoked/necras_sight/proc/add_to_scry(obj/O, mob/living/carbon/human/user)
	if(O in marked_objects)
		revert_cast()
		return
	var/holyskill = user.get_skill_level(/datum/skill/magic/holy)
	if(length(marked_objects) >= holyskill)
		to_chat(user, span_warning("I'm focusing on too many gravestones already! I will replace this one with the first I recall."))
		marked_objects[last_index] = O
		last_index++
		if(last_index >= holyskill)
			last_index = 1
		return
	to_chat(user, span_info("I incant a whisper and touch the gravestone, marking it for later use..."))
	for(var/i in 1 to holyskill)
		if(!LAZYACCESS(marked_objects, i))
			LAZYADD(marked_objects, O)
			break
		else
			continue

/obj/effect/proc_holder/spell/invoked/raise_spirits_vengeance
	name = "Avenging Spirits"
	desc = "Summon rancorous spirits to tear at an opponent!"
	range = 7
	sound = list('sound/magic/magnet.ogg')
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	releasedrain = 40
	chargetime = 30
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokeholy
	gesture_required = TRUE 
	associated_skill = /datum/skill/magic/holy
	recharge_time = 90 SECONDS
	hide_charge_effect = TRUE
	miracle = TRUE
	devotion_cost = 50
	overlay_icon = 'icons/mob/actions/necramiracles.dmi'
	overlay_state = "vengeful_spirit"
	action_icon_state = "vengeful_spirit"
	action_icon = 'icons/mob/actions/necramiracles.dmi'
	invocations = list("Awaken, rancor!!")
	invocation_type = "shout"



/obj/effect/proc_holder/spell/invoked/raise_spirits_vengeance/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(user.dir == SOUTH || user.dir == NORTH)
			new /mob/living/simple_animal/hostile/rogue/spirit_vengeance(get_turf(user),user)
			new /mob/living/simple_animal/hostile/rogue/spirit_vengeance(get_step(user, EAST),user)
			new /mob/living/simple_animal/hostile/rogue/spirit_vengeance(get_step(user, WEST),user)
		else
			new /mob/living/simple_animal/hostile/rogue/spirit_vengeance(get_turf(user),user)
			new /mob/living/simple_animal/hostile/rogue/spirit_vengeance(get_step(user, NORTH),user)
			new /mob/living/simple_animal/hostile/rogue/spirit_vengeance(get_step(user, SOUTH),user)
		for(var/mob/living/simple_animal/hostile/rogue/spirit_vengeance/swarm in view(2, user))
			swarm.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target) 
		return TRUE
	revert_cast()
	return FALSE

