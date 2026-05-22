/datum/action/cooldown/spell/dendor
	sound = 'sound/magic/churn.ogg'
	charge_sound = 'sound/magic/holycharging.ogg'
	button_icon = 'icons/mob/actions/dendormiracles.dmi'
	spell_color = GLOW_COLOR_DENDOR
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
	required_items = list(/obj/item/clothing/neck/roguetown/psicross/dendor, /obj/item/clothing/neck/roguetown/psicross/undivided, /obj/item/clothing/neck/roguetown/psicross/silver/undivided)

///////////////////////
// T0 - Spider Speak //
///////////////////////

/datum/action/cooldown/spell/dendor/wildspeak
	name = "Wild Speak"
	desc = "Infuses a target with the mind, scent and instinct of the Wild. Beasts and primordial creatures will recognize them as kin, and they can speak the language of the beasts. If you perform aggressive actions, this will end prematurely. This will not remove aggro from animals you have already angered."
	fluff_desc = "The oldest druids spoke not with words, but scent, breath, instinct, and spirit. Through Dendor's blessing, the Wild remembers its own."
	button_icon_state = "tamebeast"
	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE
	primary_resource_cost = 25
	secondary_resource_cost = 25
	charge_required = FALSE
	cooldown_time = 15 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_SAME_Z
	var/duration = 30 MINUTES

/datum/action/cooldown/spell/dendor/wildspeak/cast(atom/cast_on)
	. = ..()

	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/mob/living/spelltarget = cast_on

	if(!isliving(spelltarget))
		to_chat(H, span_warning("The Wild cannot commune with that."))
		return FALSE

	if(spelltarget.has_status_effect(/datum/status_effect/buff/wildtongue))
		to_chat(owner, span_warning("They are already blessed with Wildtongue."))
		return FALSE

	if(spelltarget != H)
		H.visible_message(span_green("[H] invokes the ancient voice of the wild upon [spelltarget]!"))
	else	
		H.visible_message(span_green("[H] invokes the ancient voice of the wild upon themselves!"))

	if(spelltarget.anti_magic_check(TRUE, TRUE))
		return FALSE

	if(spell_guard_check(spelltarget, TRUE))
		spelltarget.visible_message(span_warning("[spelltarget] resists the voice of the Wild!"))
		return TRUE

	spelltarget.apply_status_effect(/datum/status_effect/buff/wildtongue, duration)
	to_chat(spelltarget,span_green("You feel the scent and instinct of the Wild settle into your spirit."))

	if(spelltarget == H)
		H.say(pick("Dendor, know me as thy kin.", "Treefather, let the wilds remember my spirit.",	"By fang, feather, soil, and rain! Let no beast raise tooth against me.", "Blessed Wilds, breathe thy scent upon my soul.", "From deepest burrow to eldest grove, let thy children know me in peace."), language = /datum/language/common)
	else
		H.say(pick("Dendor, know this soul as thy kin.", "Treefather, let the wilds remember this spirit kindly.", "By fang, feather, soil, and rain! May no beast raise tooth against thee.", "Blessed Wilds, breathe thy scent upon this wandering child.", "From deepest burrow to eldest grove, let thy children know peace with this one."),language = /datum/language/common)

	return TRUE

//////////////////////
// T0 - Bless Crops //
//////////////////////

/datum/action/cooldown/spell/dendor/blesscrop
	name = "Bless Crops"
	desc = "Bless crops in a small area for 45 minutes, purging weeds and preventing them from returning. Blessed soil restores dead crops to life, keeps its nutrition from falling below a healthy state, and preserves the plant's condition against decay. It does not restore hydration, and cannot be used on crops that are already blessed."	
	fluff_desc = "The Treefather's stern gaze falls upon the soil, and all lesser growth is cast out. Withered roots stir once more, the earth remembers its bounty, and the hand of decay is held at bay beneath His blessing."	
	button_icon = 'icons/mob/actions/dendormiracles.dmi'
	button_icon_state = "blesscrop"
	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	primary_resource_cost = 20
	secondary_resource_cost = 20
	charge_required = FALSE
	cooldown_time = 15 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/dendor/blesscrop/cast(atom/cast_on)
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE

	var/can_bless = FALSE

	for(var/turf/T in range(1, target_turf))
		for(var/obj/structure/soil/soil in T)
			// Skip soils still strongly blessed
			if(soil.blessed_time > 5 MINUTES)
				continue

			can_bless = TRUE
			break

		if(can_bless)
			break

	if(!can_bless)
		reset_spell_cooldown()
		return FALSE

	. = ..()

	var/blessed = FALSE
	var/amount_blessed = 0
	var/max_blessed = 9

	// 3x3 area
	for(var/turf/T in range(1, target_turf))
		if(amount_blessed >= max_blessed)
			break

		for(var/obj/structure/soil/soil in T)
			if(amount_blessed >= max_blessed)
				break

			// Cannot refresh unless near expiration
			if(soil.blessed_time > 5 MINUTES)
				continue

			soil.bless_soil()

			new /obj/effect/temp_visual/dendor_bless(T)

			blessed = TRUE
			amount_blessed++

	if(!blessed)
		reset_spell_cooldown()
		return FALSE

	owner.visible_message(span_green("[owner] calls upon Dendor's blessing, divine essence surging through the nearby soil!"), span_green("I call upon Dendor to bless the land."))
	owner.say(pick("The Treefather commands thee, be fruitful!", "In Dendor's name, be fruitful!", "May the harvest be bountiful this yil!", "May thine growth be blessed!", "Dendor's blessings and respite, o' nature's bounty!"))

	return TRUE

/obj/effect/temp_visual/dendor_bless
	name = "verdant blessing"
	icon = 'icons/effects/wizard_spell_effects.dmi'
	icon_state = "cleaning_pulse"
	duration = 8
	randomdir = 0
	color = "#00ff2a"

//T0 - Wild Hunt

#define DENDOR_AMBUSH_MIN 2
#define DENDOR_AMBUSH_MAX 9
#define WILD_HUNT_TRACK_RANGE 300

/datum/action/cooldown/spell/dendor/wildhunt
	name = "Wild Hunt"
	desc = "Invoke Dendor's primal call. Scour the land for signs of danger, track prey through instinct alone, or roar to draw the hunt to you."
	button_icon_state = "wildhunt"
	sound = 'sound/magic/whiteflame.ogg'
	primary_resource_cost = 30
	secondary_resource_cost = 30
	click_to_activate = FALSE
	charge_required = TRUE
	charge_time = 6 SECONDS
	charge_slowdown = 3
	cooldown_time = 2 MINUTES
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_SAME_Z
	var/list/hunt_howl_sounds = list('sound/vo/mobs/wwolf/howl (1).ogg', 'sound/vo/mobs/wwolf/howl (2).ogg')
	var/list/hunt_howl_sounds_far = list('sound/vo/mobs/wwolf/howldist (1).ogg', 'sound/vo/mobs/wwolf/howldist (2).ogg')

/datum/action/cooldown/spell/dendor/wildhunt/cast(atom/cast_on)
	. = ..()

	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/choice = tgui_input_list(H, "Choose an aspect of the Wild Hunt.", "Wild Hunt", list(
		"Scour Area",
		"Thrill of the Hunt",
		"The Hunt is On!"
	))

	if(!choice)
		return FALSE

	switch(choice)

		if("Scour Area")
			scour_the_area(H)
			reset_spell_cooldown()
			return FALSE

		if("Thrill of the Hunt")
			if(!H.mind)
				reset_spell_cooldown()
				return FALSE

			if(!length(H.mind.known_people))
				to_chat(H, span_warning("I know no scents worth hunting."))
				reset_spell_cooldown()
				return FALSE

			var/mob/living/target = H.mind.display_known_people(H)

			if(!target)
				reset_spell_cooldown()
				return FALSE

			H.apply_status_effect(/datum/status_effect/buff/thrill_of_the_hunt, target)
			to_chat(H, span_red("My pulse quickens as I immerse in the thrill of the hunt..."))
			return TRUE

		if("The Hunt is On!")
			if(begin_wild_hunt(H))
				return TRUE

			reset_spell_cooldown()
			return FALSE

	return FALSE

/datum/action/cooldown/spell/dendor/wildhunt/proc/scour_the_area(mob/living/user)
	var/area/AR = get_area(user)
	var/datum/threat_region/TR = SSregionthreat.get_region(AR.threat_region)

	if(TR)
		to_chat(user, span_notice("This area is part of the [TR.region_name] threat region."))
	else
		to_chat(user, span_warning("This area lies beyond the Wild God's reach."))
		return FALSE

	if(TR.fixed_ambush)
		to_chat(user, span_warning("The creatures here are rooted to this place."))
		return TRUE

	if(user.get_will_block_ambush())
		to_chat(user, span_warning("This place is too well-lit for predators to gather."))
		return TRUE

	if(!user.get_possible_ambush_spawn(min_dist = DENDOR_AMBUSH_MIN, max_dist = DENDOR_AMBUSH_MAX))
		to_chat(user, span_warning("The land nearby is too sparse for lurking creatures."))
		return TRUE

	if(TR.last_induced_ambush_time && (world.time < TR.last_induced_ambush_time + 3 MINUTES))
		to_chat(user, span_warning("Something hunted here recently. The wilds are still unsettled."))
		return TRUE

	if(!TR.latent_ambush)
		to_chat(user, span_notice("The woods are calm. Nothing stirs nearby."))
		return TRUE

	switch(TR.latent_ambush)
		if(1 to 2)
			to_chat(user, span_notice("Something small prowls nearby."))
		if(3 to 4)
			to_chat(user, span_warning("Several hungry things roam these lands."))
		if(5 to 6)
			to_chat(user, span_userdanger("The wilds teem with dangerous life."))
		else
			to_chat(user, span_userdanger("A great hunt waits in the dark."))

	user.visible_message(span_boldwarning("[user] begins looking around with heightened senses..."))

	return TRUE

/datum/action/cooldown/spell/dendor/wildhunt/proc/begin_wild_hunt(mob/living/user)
	var/area/AR = get_area(user)
	var/datum/threat_region/TR = SSregionthreat.get_region(AR.threat_region)

	if(!TR || TR.fixed_ambush)
		to_chat(user, span_warning("The hunt cannot be called here."))
		return FALSE

	if(user.get_will_block_ambush())
		to_chat(user, span_warning("This place is too well-lit for the hunt to answer."))
		return FALSE

	if(!user.get_possible_ambush_spawn(min_dist = DENDOR_AMBUSH_MIN, max_dist = DENDOR_AMBUSH_MAX))
		to_chat(user, span_warning("There is nowhere for predators to emerge from here."))
		return FALSE

	if(TR.last_induced_ambush_time && (world.time < TR.last_induced_ambush_time + 3 MINUTES))
		to_chat(user, span_warning("The land has already tasted blood recently."))
		return FALSE

	if(!TR.latent_ambush)
		to_chat(user, span_notice("My howl fades into the distance. Nothing answers."))
		return FALSE

	user.visible_message(span_userdanger("[user] throws back their head and lets loose a primal hunting howl!"))

	user.apply_status_effect(/datum/status_effect/debuff/clickcd, 5 SECONDS)

	if(!do_after(user, 10 SECONDS))
		return FALSE

	user.visible_message(span_boldwarning("[user]'s howl echoes through the wilds!"))

	playsound(user, pick(hunt_howl_sounds), 100, TRUE)

	for(var/mob/living/player in GLOB.player_list)
		if(!player.mind)
			continue
		if(player.stat == DEAD)
			continue
		if(isbrain(player))
			continue
		if(player == user)
			continue
		var/turf/origin_turf = get_turf(user)
		var/player_distance = get_dist(player, origin_turf)
		// Only hear distant echo at range
		if(player_distance <= 7 || player_distance > 21)
			continue
		var/dirtext = "to the "
		var/direction = get_dir(player, origin_turf)
		switch(direction)
			if(NORTH)
				dirtext += "north"
			if(SOUTH)
				dirtext += "south"
			if(EAST)
				dirtext += "east"
			if(WEST)
				dirtext += "west"
			if(NORTHWEST)
				dirtext += "northwest"
			if(NORTHEAST)
				dirtext += "northeast"
			if(SOUTHWEST)
				dirtext += "southwest"
			if(SOUTHEAST)
				dirtext += "southeast"
			else
				dirtext = "though I cannot tell from where"

		player.playsound_local(get_turf(player), pick(hunt_howl_sounds_far), 50, FALSE, pressure_affected = FALSE)
		to_chat(player, span_warning("I hear a monstrous hunting howl somewhere [dirtext]!"))

	if(user.consider_ambush(always = TRUE, ignore_cooldown = TRUE, min_dist = DENDOR_AMBUSH_MIN, max_dist = DENDOR_AMBUSH_MAX, budget_multiplier_floor = rand(3, 6)))
		user.Immobilize(30)
		TR.last_induced_ambush_time = world.time
		return TRUE

	return FALSE

// THRILL OF THE HUNT branch
/atom/movable/screen/alert/status_effect/buff/thrill_of_the_hunt
	name = "Thrill of the Hunt"
	desc = "The hunt is on! They'll never escape from me now."

/datum/status_effect/buff/thrill_of_the_hunt
	id = "thrill_of_the_hunt"
	alert_type = /atom/movable/screen/alert/status_effect/buff/thrill_of_the_hunt
	duration = 5 MINUTES
	tick_interval = 2 SECONDS
	var/mob/living/tracked_target

/datum/status_effect/buff/thrill_of_the_hunt/on_creation(mob/living/new_owner, mob/living/target)
	. = ..()
	tracked_target = target

/datum/status_effect/buff/thrill_of_the_hunt/on_apply()
	ADD_TRAIT(owner, TRAIT_SLEUTH, "wild_hunt")
	ADD_TRAIT(owner, TRAIT_AZURENATIVE, "wild_hunt")
	ADD_TRAIT(owner, TRAIT_NITEVISION, "wild_hunt")
	return TRUE

/datum/status_effect/buff/thrill_of_the_hunt/on_remove()
	REMOVE_TRAIT(owner, TRAIT_SLEUTH, "wild_hunt")
	REMOVE_TRAIT(owner, TRAIT_AZURENATIVE, "wild_hunt")
	REMOVE_TRAIT(owner, TRAIT_NITEVISION, "wild_hunt")
	return ..()

/datum/status_effect/buff/thrill_of_the_hunt/tick()
	. = ..()
	if(owner.cmode)
		to_chat(owner, span_warning("You are too focused in violence to hone your senses, your current thrill is replaced by another."))
		qdel(src)
		return
	if(!tracked_target || QDELETED(tracked_target))
		to_chat(owner, span_warning("The scent vanishes...?"))
		qdel(src)
		return
	if(tracked_target.stat == DEAD)
		to_chat(owner, span_notice("The prey's scent has gone cold."))
		qdel(src)
		return
	if(abs(owner.z - tracked_target.z) >= 2)
		to_chat(owner, span_warning("[tracked_target] (scent too thin)"))
		return
	var/dist = get_dist(owner, tracked_target)
	if(dist > WILD_HUNT_TRACK_RANGE)
		to_chat(owner, span_warning("[tracked_target] (scent too thin)"))
		return
	var/direction = dir2text(get_dir(owner, tracked_target))
	var/distance_text
	switch(dist)
		if(0 to 15)
			to_chat(owner, span_userdanger("They are nearby."))
			qdel(src)
			return
		if(16 to 25)
			distance_text = "very close"
		if(26 to 40)
			distance_text = "close"
		if(41 to 60)
			distance_text = "some distance away"
		if(61 to 80)
			distance_text = "far away"
		if(81 to 100)
			distance_text = "very far away"
		if(101 to 120)
			distance_text = "distant"
		if(121 to 140)
			distance_text = "very distant"
		else
			distance_text = "barely within your senses"

	to_chat(owner, span_green("I smell [tracked_target] to the [direction] — [distance_text]."))

#undef DENDOR_AMBUSH_MIN
#undef DENDOR_AMBUSH_MAX
#undef WILD_HUNT_TRACK_RANGE

/datum/action/cooldown/spell/dendor/savagery
	name = "Savagery"
	desc = "Unleash your inner beast for 45 seconds, gaining heightened senses, night vision, and the stride of a predator. Landing attacks with fists, bites, claws, daggers, or bows builds Savagery, increasing SPD and PER as momentum rises. At key thresholds, the hunt restores energy, extends its duration, and awakens deeper, primal traits. Empty bows are drawn with unnatural speed while the hunt endures, and facing a Werewolf immediately drives you into a frenzy. The hunt ends if you are stunned, knocked down, or fully exhausted. Wearing armor heavier than Light suppresses your stat growth, and Expert Pugilist lowers your chance to gain Savagery, having traded instinct for discipline."	
	fluff_desc = "For He was not called the 'God of Madmen' for little. There is clarity in savagery. There is method in this madness. His teachings ever tell you to be true to your nature, and behold, at your smallest fragment, you are no different than an animal, the same beast you hunt. He merely reminds you of so."	
	sound = 'sound/magic/barbroar.ogg'
	glow_intensity = 0
	click_to_activate = FALSE
	primary_resource_cost = 90
	secondary_resource_cost = SPELLCOST_UTILITY_BUFF
	charge_required = FALSE
	cooldown_time = 5 MINUTES
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/dendor/savagery/cast(atom/cast_on)
	. = ..()

	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!ishuman(H)) // does not work while shapeshifted, hooman only
		to_chat(H, span_userdanger("I cannot channel Dendor's madness in this form..."))
		return FALSE

	H.apply_status_effect(/datum/status_effect/buff/savagery)

	var/found_special = FALSE

	for(var/mob/living/carbon/human/nearby in view(8, H))
		if(nearby == H)
			continue

		if(istype(nearby.dna?.species, /datum/species/werewolf))
			found_special = TRUE

			var/datum/status_effect/buff/savagery/S = H.has_status_effect(/datum/status_effect/buff/savagery)
			if(S)
				S.add_savagery_stack(20)

			H.say(pick("LET THIS TRIAL BEGIN!!", "LET US DANCE, WILD MUTT!!", "I WILL BE WORTHY OF HIS SMILE!!", "ENTERTAIN ME, VOLF!!"))
			break

		else if(istype(nearby.dna?.species, /datum/species/gnoll))
			found_special = TRUE

			var/datum/status_effect/buff/savagery/S = H.has_status_effect(/datum/status_effect/buff/savagery)
			if(S)
				S.add_savagery_stack(10)

			H.say(pick("ENTERTAIN ME, CHAMPION!!", "WORTHY PREY!!", "I WILL FEAST ON YOUR FLESH, GNOLL!!"))
			break

		else if(nearby.has_status_effect(/datum/status_effect/buff/call_to_slaughter))
			found_special = TRUE
			
			var/datum/status_effect/buff/savagery/S = H.has_status_effect(/datum/status_effect/buff/savagery)
			if(S)
				S.add_savagery_stack(5)	

			if(H.has_status_effect(/datum/status_effect/debuff/call_to_slaughter))
				H.remove_status_effect(/datum/status_effect/debuff/call_to_slaughter)

			H.say(pick("I'LL SHOW 'YOU' LAMB!!", "I'LL SLAUGHTER 'YOU'!!", "VOLF IN LAMB'S CLOTHING!!"))
			break

		else if(nearby.has_status_effect(/datum/status_effect/buff/bloodrage))
			found_special = TRUE
			
			var/datum/status_effect/buff/savagery/S = H.has_status_effect(/datum/status_effect/buff/savagery)
			if(S)
				S.add_savagery_stack(5)			
			
			H.say(pick("DENDOR, SHATTER MY MIND!!",	"DENDOR, DENDOR, DENDOR!!",	"I EMBODY HIS MADNESS! YOU ARE NOTHING!!"))
			break

	if(!found_special)
		H.say(pick("COME ONNNN!!", "I'LL TEAR YOU APART!!", "RIP AND TEAR UNTIL IT IS DONE!!", "RRRAAHHHHHHHHH!!", "THE WEAK SHOULD FEAR ME!!", "I'LL RIP YOU WIDE OPEN!!", "THE HUNT BEGINS NOW!!", "STAND AND FIGHT!!", "I'M GOING TO KILL YOU!!"))
	
	H.emote("rage")

	return TRUE

#define SAVAGERY_FILTER "savagery_outline"

/atom/movable/screen/alert/status_effect/buff/savagery
	name = "Savagery"
	desc = "DON'T STOP, DON'T STOP, KEEP GOING! MAIM, RIP, TEAR! CRUSH! KILL!!"
	icon_state = "buff"

/datum/status_effect/buff/savagery
	id = "savagery"
	alert_type = /atom/movable/screen/alert/status_effect/buff/savagery
	duration = 45 SECONDS
	var/next_bow_shot = 0
	var/stacks = 0
	var/spd_bonus = 0
	var/per_bonus = 0
	var/fortitude_active = FALSE
	var/afterimage_active = FALSE
	var/milestone_five_rewarded = FALSE
	var/milestone_ten_rewarded = FALSE
	var/milestone_fifteen_rewarded = FALSE
	var/outline_colour = "#3FA34D"

/datum/status_effect/buff/savagery/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY, PROC_REF(handle_weapon_attack))
	RegisterSignal(owner, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, PROC_REF(handle_unarmed_attack))
	RegisterSignal(owner, COMSIG_LIVING_STATUS_STUN, PROC_REF(cancel_on_incapacitation))
	RegisterSignal(owner, COMSIG_LIVING_STATUS_KNOCKDOWN, PROC_REF(cancel_on_incapacitation))
	RegisterSignal(owner, COMSIG_BOW_PRE_DRAW, PROC_REF(handle_bow_attack))
	RegisterSignal(owner, COMSIG_BOW_PRE_DRAW_ARC, PROC_REF(handle_bow_attack_2))
	ADD_TRAIT(owner, TRAIT_LONGSTRIDER, "savagery")
	ADD_TRAIT(owner, TRAIT_NITEVISION, "savagery")
	ADD_TRAIT(owner, TRAIT_NOPAINSTUN, "savagery")
	owner.add_filter(SAVAGERY_FILTER, 2, list("type" = "outline", "color" = outline_colour,	"alpha" = 60, "size" = 1))
	owner.visible_message(span_danger("[owner]'s posture hunches into a predator's stance."), span_userdanger("THE HUNT BEGINS!"))
	owner.update_sight()

/datum/status_effect/buff/savagery/on_remove()
	. = ..()
	UnregisterSignal(owner,	list(COMSIG_BOW_PRE_DRAW, COMSIG_BOW_PRE_DRAW_ARC, COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, COMSIG_LIVING_STATUS_STUN, COMSIG_LIVING_STATUS_KNOCKDOWN))
	REMOVE_TRAIT(owner, TRAIT_LONGSTRIDER, "savagery")
	REMOVE_TRAIT(owner, TRAIT_NITEVISION, "savagery")
	REMOVE_TRAIT(owner, TRAIT_NOPAINSTUN, "savagery")

	REMOVE_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, "savagery")
	REMOVE_TRAIT(owner, TRAIT_BLOOD_RESISTANCE, "savagery")
	REMOVE_TRAIT(owner, TRAIT_HARDDISMEMBER, "savagery")
	REMOVE_TRAIT(owner, TRAIT_STRONGBITE, "savagery")
	REMOVE_TRAIT(owner, TRAIT_FORTITUDE, "savagery")

	owner.change_stat(STATKEY_SPD, -spd_bonus)
	owner.change_stat(STATKEY_PER, -per_bonus)
	spd_bonus = 0
	per_bonus = 0
	stacks = 0
	fortitude_active = FALSE
	if(afterimage_active)
		var/datum/component/after_image/AI = owner.GetComponent(/datum/component/after_image)
		if(AI)
			qdel(AI)

	afterimage_active = FALSE
	milestone_five_rewarded = FALSE
	milestone_ten_rewarded = FALSE
	milestone_fifteen_rewarded = FALSE
	owner.remove_filter(SAVAGERY_FILTER)
	owner.update_sight()
	to_chat(owner, span_warning("The beast within recedes..."))

/datum/status_effect/buff/savagery/nextmove_modifier()
	return max(1 - (stacks * ((1 - 0.6) / 20)), 0.6)

/datum/status_effect/buff/savagery/proc/add_savagery_stack(amount = 1)
	if(QDELETED(src) || !owner)
		return

	if(amount <= 0)
		return

	stacks = min(stacks + amount, 20)

	if(stacks >= 5 && !milestone_five_rewarded)
		grant_milestone_boost(5)
		owner.balloon_alert_to_viewers("<font color=red>Hah.. Hah..", "<font color=red>Hah.. Hah..")
		apply_stack_bonus(1)

	if(stacks >= 10 && !milestone_ten_rewarded)
		grant_milestone_boost(10)
		owner.balloon_alert_to_viewers("<font color=red>Can't think..", "<font color=red>Can't think..")
		apply_stack_bonus(2)

	if(stacks >= 15 && !fortitude_active)
		grant_milestone_boost(15)
		owner.balloon_alert_to_viewers("<font color=red>M A D N E S S !", "<font color=red>M A D N E S S !")
		ADD_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, "savagery")
		ADD_TRAIT(owner, TRAIT_BLOOD_RESISTANCE, "savagery")
		ADD_TRAIT(owner, TRAIT_HARDDISMEMBER, "savagery")
		ADD_TRAIT(owner, TRAIT_STRONGBITE, "savagery")
		ADD_TRAIT(owner, TRAIT_FORTITUDE, "savagery")
		owner.AddComponent(/datum/component/after_image)
		afterimage_active = TRUE
		fortitude_active = TRUE
		to_chat(owner, span_userdanger("I GOT YOU NOW! BLEED FOR ME, PREY!!"))
		owner.emote("rage")
		playsound(owner, 'sound/magic/momentum_max.ogg', 100, TRUE, -1)

/datum/status_effect/buff/savagery/proc/handle_weapon_attack(mob/living/target, mob/living/user, obj/item/weapon)
	SIGNAL_HANDLER
	if(QDELETED(src) || QDELETED(target))
		return
	if(!isliving(target))
		return
	if(istype(weapon, /obj/item/rogueweapon/huntingknife) || istype(weapon, /obj/item/rogueweapon/handclaw) || istype(weapon, /obj/item/rogueweapon/werewolf_claw))
		INVOKE_ASYNC(src, PROC_REF(add_savagery_stack), 1)

	var/mob/living/L = target

	if(!L.mind && L.resting && prob(40))
		addtimer(CALLBACK(L, TYPE_PROC_REF(/mob/living, gib)), 0)
	
/datum/status_effect/buff/savagery/proc/handle_unarmed_attack(mob/living/user, atom/target, damage, atom/attacked_with)
	SIGNAL_HANDLER
	if(QDELETED(src) || QDELETED(target))
		return
	if(!isliving(target))
		return

	var/mob/living/L = target
	if(!L.mind && L.resting && prob(40))
		addtimer(CALLBACK(L, TYPE_PROC_REF(/mob/living, gib)), 0)

	var/datum/intent/current_intent = owner.used_intent

	if(istype(current_intent, /datum/intent/bite))
		INVOKE_ASYNC(src, PROC_REF(add_savagery_stack), 1)
		return

	if(!attacked_with)
		if(HAS_TRAIT(user, TRAIT_CIVILIZEDBARBARIAN)) // so monks don't go too wild with this
			if(prob(40))
				INVOKE_ASYNC(src, PROC_REF(add_savagery_stack), 1)
		else
			INVOKE_ASYNC(src, PROC_REF(add_savagery_stack), 1)

/datum/status_effect/buff/savagery/proc/apply_stack_bonus(stack_level)
	var/mob/living/carbon/human/O = owner
	if(O.highest_ac_worn() > ARMOR_CLASS_LIGHT)
		return
		
	switch(stack_level)
		if(1)
			owner.change_stat(STATKEY_PER, 1)
			owner.change_stat(STATKEY_SPD, 1)
			per_bonus += 1
			spd_bonus += 1
			to_chat(owner, span_notice("<font color='#00ff22'>Focused..."))

		if(2)
			owner.change_stat(STATKEY_PER, 1)
			owner.change_stat(STATKEY_SPD, 1)
			per_bonus += 1
			spd_bonus += 1
			to_chat(owner, span_userdanger("<font color='#ffd000'>Sharpened..."))

/datum/status_effect/buff/savagery/proc/grant_milestone_boost(milestone)
	if(!owner)
		return

	var/fatigue_restore = owner.max_energy * 0.1
	owner.energy_add(fatigue_restore)
	var/duration_extension = 0
	switch(milestone)
		if(5)
			if(milestone_five_rewarded)
				return
			milestone_five_rewarded = TRUE
			duration_extension = 15 SECONDS
		if(10)
			if(milestone_ten_rewarded)
				return
			milestone_ten_rewarded = TRUE
			duration_extension = 15 SECONDS
		if(15)
			if(milestone_fifteen_rewarded)
				return
			milestone_fifteen_rewarded = TRUE
			duration_extension = 30 SECONDS
	if(duration_extension)
		duration += duration_extension

/datum/status_effect/buff/savagery/proc/cancel_on_incapacitation(mob/living/source, amount, updating, ignore)
	SIGNAL_HANDLER
	if(!amount || ignore)
		return
	if(!owner)
		return
	if(owner.stamina >= owner.max_stamina && !owner.IsKnockdown() && !owner.IsStun())
		return
	to_chat(owner, span_warning("NO!! THE HUNT IS RUINED..."))
	qdel(src)

/datum/status_effect/buff/savagery/proc/get_arrow_from_quiver()
	var/mob/living/carbon/human/L = owner

	if(!L)
		return null

	// Priority 0: rip an embedded arrow out of your own body
	for(var/obj/item/bodypart/BP in L.bodyparts)
		if(!BP.embedded_objects?.len)
			continue

		for(var/obj/item/ammo_casing/caseless/rogue/arrow/A in BP.embedded_objects)
			L.visible_message(span_warning("[L] rips an embedded arrow from [L.p_their()] flesh and nocks it in one savage motion!"), span_userdanger("You rip an arrow from your own flesh and immediately ready it!"))
			playsound(owner, 'sound/foley/flesh_rem.ogg', 100, TRUE, -2)
			BP.remove_embedded_object(A)
			A.forceMove(L)
			INVOKE_ASYNC(src, PROC_REF(add_savagery_stack), 1) // cause this is rare and cool, deserves the style point
			playsound(owner, 'sound/foley/nockarrow.ogg', 70, TRUE)		
			return A

	// Priority 1: directly held/carried loose arrows
	for(var/obj/item/ammo_casing/caseless/rogue/arrow/A in L.get_equipped_items(FALSE))
		playsound(owner, 'sound/foley/nockarrow.ogg', 70, TRUE)
		return A

	// Priority 2: search ALL equipped quivers until one has ammo
	for(var/obj/item/quiver/Q in L.get_equipped_items(FALSE))
		var/obj/item/ammo_casing/caseless/rogue/arrow/A = Q.pick_ammo(/obj/item/ammo_casing/caseless/rogue/arrow)
		if(!A)
			continue
		Q.arrows -= A
		Q.update_icon()
		playsound(owner, 'sound/foley/nockarrow.ogg', 70, TRUE)
		return A

	// Priority 3: grab arrows on nearby ground (1 tile radius)
	for(var/obj/item/ammo_casing/caseless/rogue/arrow/A in range(1, L))
		if(A.loc == L.loc || isturf(A.loc))
			owner.visible_message(span_warning("[owner] nimbly picks an arrow from the floor!"))
			playsound(owner, 'sound/foley/nockarrow.ogg', 70, TRUE)
			return A

	return null

/datum/status_effect/buff/savagery/proc/handle_bow_attack(datum/source, obj/item/gun/ballistic/revolver/grenadelauncher/bow/B, atom/target, params)
	SIGNAL_HANDLER
	var/mob/living/user = owner
	if(user != owner)
		return
	if(QDELETED(B) || QDELETED(target))
		return COMPONENT_CANCEL_ATTACK_CHAIN
	if(world.time < next_bow_shot)
		return COMPONENT_CANCEL_ATTACK_CHAIN
	next_bow_shot = world.time + 10   
	owner.visible_message(span_warning("[owner] looses an arrow with inhuman speed!"))
	addtimer(CALLBACK(src,PROC_REF(fire_projectile_async), B, target, target, params, FALSE), 0)
	if(prob(50))
		INVOKE_ASYNC(src, PROC_REF(add_savagery_stack), 1)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/status_effect/buff/savagery/proc/handle_bow_attack_2(datum/source, obj/item/gun/ballistic/revolver/grenadelauncher/bow/B, atom/target,params)
	SIGNAL_HANDLER
	var/mob/living/user = owner
	if(user != owner)
		return
	if(QDELETED(B) || QDELETED(target))
		return COMPONENT_CANCEL_ATTACK_CHAIN
	if(world.time < next_bow_shot)
		return COMPONENT_CANCEL_ATTACK_CHAIN
	next_bow_shot = world.time + 15
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return COMPONENT_CANCEL_ATTACK_CHAIN
	owner.visible_message(span_warning("[owner] looses an arcing arrow with inhuman speed!"))
	addtimer(CALLBACK(src, PROC_REF(fire_projectile_async), B, target_turf, target,	params,	TRUE), 0)
	if(prob(40))
		INVOKE_ASYNC(src, PROC_REF(add_savagery_stack), 1)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/status_effect/buff/savagery/proc/fire_projectile_async(obj/item/gun/ballistic/revolver/grenadelauncher/bow/B, atom/final_target, atom/original_click_target,	params,	arc)
	if(QDELETED(B))
		return
	if(QDELETED(final_target))
		return
	if(QDELETED(original_click_target))
		return
	if(QDELETED(owner))
		return
	var/obj/projectile/bullet/reusable/arrow/P = new(get_turf(B))
	if(!P)
		return
	P.embedchance = 100 // pin cushion! :D
	P.speed = 0.15
	P.firer = owner
	P.fired_from = B
	P.original = original_click_target
	if(arc)
		P.pass_flags |= PASSTABLE | PASSMOB
	P.preparePixelProjectile(original_click_target, owner, params)
	if(QDELETED(P))
		return
	if(!get_turf(P))
		qdel(P)
		return
	if(isnull(P.Angle) && (isnull(P.xo) || isnull(P.yo)))
		qdel(P)
		return
	var/obj/item/ammo_casing/caseless/rogue/arrow/A = get_arrow_from_quiver()
	if(!A)
		to_chat(owner, span_warning("No arrows left!"))
		qdel(P)
		return
	qdel(A)
	P.fire()
	playsound(owner, 'sound/combat/Ranged/flatbow-shot-01.ogg', 90, TRUE)

#undef SAVAGERY_FILTER

/////////////////////
// T? - Tame Beast //
/////////////////////
//Apparently not for this PR and not for any other PR
/obj/effect/proc_holder/spell/targeted/beasttame
	name = "Tame Beast"
	desc = "Tames a targeted saiga, chicken, cow, goat, volf or spider to be non hostile and tamed."
	range = 5
	action_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_state = "tamebeast"
	releasedrain = 30
	recharge_time = 30 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	max_targets = 0
	cast_without_targets = TRUE
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/holy
	invocations = list("Be still and calm, brotherbeast.")
	invocation_type = "whisper" //can be none, whisper, emote and shout
	miracle = TRUE
	devotion_cost = 20
	var/beast_tameable_factions = list("saiga", "chickens", "cows", "goats", "wolfs", "spiders")

/obj/effect/proc_holder/spell/targeted/beasttame/cast(list/targets,mob/user = usr)
	. = ..()
	visible_message(span_green("[usr] soothes the beastblood with Dendor's whisper."))
	var/tamed = FALSE
	for(var/mob/living/simple_animal/hostile/retaliate/animal in get_hearers_in_view(2, usr))
		if((animal.mob_biotypes & MOB_UNDEAD))
			continue
		if(faction_check(animal.faction, beast_tameable_factions))
			animal.tamed(TRUE)
			animal.aggressive = FALSE
			if(animal.ai_controller)
				animal.ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
				animal.ai_controller.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)
				animal.ai_controller.set_blackboard_key(BB_BASIC_MOB_TAMED, TRUE)
			to_chat(usr, "With Dendor's aide, you soothe [animal] of their anger.")
	return tamed

//////////////////////////////////
// T3 - Verdant Manifestation   //
//////////////////////////////////

/datum/action/cooldown/spell/dendor/verdant_manifestation
	name = "Verdant Manifestation"
	desc = "Shape the wilds into being, calling forth trees, fungi, thorns, and creeping growth; or guide seeds across fertile land, raising soil and life as long as your devotion lasts."
	fluff_desc = "Where the Treefather's will falls, barren earth remembers. Soil rises where none stood, seeds take root at His command, and root, thorn, bark, fungus, and bloom answer as though the wild itself had chosen to awaken."
	button_icon_state = "blesscrop"
	charge_required = TRUE
	charge_time = 1 SECONDS
	cooldown_time = 10 SECONDS
	primary_resource_cost = 40
	secondary_resource_cost = 100
	var/devotion_per_tile = 10 // for seed spreading

/datum/status_effect/debuff/dendor_growing
	id = "dendor_growing"
	duration = 30 SECONDS

/datum/action/cooldown/spell/dendor/verdant_manifestation/is_valid_target(atom/cast_on)
	return TRUE

/proc/is_valid_dendor_growth_turf(turf/T)
	if(!T)
		return FALSE

	if(istype(T, /turf/open/floor/rogue/dirt))
		return TRUE

	return FALSE

/datum/action/cooldown/spell/dendor/verdant_manifestation/proc/get_available_seed_packet(mob/living/carbon/human/caster)
	for(var/obj/item/seeds/S in caster.held_items)
		if(S)
			return S

	for(var/obj/item/seeds/S in range(1, caster))
		if(S.loc && (isturf(S.loc) || S.loc == caster))
			return S

	return null
	
/datum/action/cooldown/spell/dendor/verdant_manifestation/proc/propagate_seeds(mob/living/carbon/human/caster, turf/start)
	if(!caster || !start)
		return

	var/list/frontier = list(start)
	var/list/visited = list(start)
	var/planted_any = FALSE

	to_chat(caster, span_notice("DEBUG: Starting propagation at [start.x],[start.y],[start.z]"))

	while(frontier.len)
		if(QDELETED(caster))
			to_chat(caster, span_warning("DEBUG: Caster deleted, stopping propagation."))
			break

		to_chat(caster, span_notice("DEBUG: Frontier size = [frontier.len]"))

		var/turf/current_turf = frontier[1]
		frontier.Cut(1, 2)

		if(!current_turf)
			to_chat(caster, span_warning("DEBUG: Current turf was null."))
			continue

		to_chat(caster, span_notice("DEBUG: Processing turf [current_turf.x],[current_turf.y],[current_turf.z]"))

		if(!is_valid_dendor_growth_turf(current_turf))
			to_chat(caster, span_warning("DEBUG: Turf invalid for growth."))
			continue

		if(isclosedturf(current_turf))
			to_chat(caster, span_warning("DEBUG: Turf is closed."))
			continue

		var/obj/item/seeds/seed_packet = get_available_seed_packet(caster)

		if(!seed_packet)
			to_chat(caster, span_warning("DEBUG: No seeds found."))
			break

		var/old_cost = src.devotion_cost
		src.devotion_cost = devotion_per_tile

		if(!caster.devotion?.check_devotion(src))
			src.devotion_cost = old_cost
			to_chat(caster, span_warning("DEBUG: Failed devotion check."))
			break

		src.devotion_cost = old_cost

		var/obj/structure/soil/S = locate(/obj/structure/soil) in current_turf

		if(!S)
			to_chat(caster, span_notice("DEBUG: No soil found, creating new soil."))
			S = new /obj/structure/soil(current_turf)
		else
			to_chat(caster, span_notice("DEBUG: Existing soil found."))

		if(S.plant)
			to_chat(caster, span_warning("DEBUG: Soil already has a plant."))
			continue

		seed_packet.try_plant_seed(caster, S)

		if(!S.plant)
			to_chat(caster, span_warning("DEBUG: try_plant_seed ran but no plant was created."))
			continue

		to_chat(caster, span_notice("DEBUG: Successfully planted at [current_turf.x],[current_turf.y],[current_turf.z]"))

		caster.devotion.update_devotion(-devotion_per_tile)
		planted_any = TRUE

		new /obj/effect/temp_visual/dendor_bless(current_turf)

		caster.visible_message(
			span_green("[caster] gestures, and new life erupts from the earth."),
			span_green("I guide life through the soil.")
		)

		playsound(current_turf, sound, 100, FALSE)

		to_chat(caster, span_notice("DEBUG: Checking adjacent cardinal tiles..."))

		for(var/dir in GLOB.cardinals)
			var/turf/T = get_step(current_turf, dir)

			if(!T)
				to_chat(caster, span_warning("DEBUG: Direction [dir] -> null turf"))
				continue

			to_chat(caster, span_notice("DEBUG: Checking [T.x],[T.y],[T.z]"))

			if(T in visited)
				to_chat(caster, span_warning("DEBUG: Already visited."))
				continue

			if(!is_valid_dendor_growth_turf(T))
				to_chat(caster, span_warning("DEBUG: Invalid growth turf. Type: [T.type]"))
				continue

			if(isclosedturf(T))
				to_chat(caster, span_warning("DEBUG: Turf is closed."))
				continue

			var/obj/structure/soil/TS = locate(/obj/structure/soil) in T

			if(TS)
				to_chat(caster, span_notice("DEBUG: Found soil on adjacent tile."))

			if(TS && TS.plant)
				to_chat(caster, span_warning("DEBUG: Adjacent soil already has plant."))
				continue

			to_chat(caster, span_green("DEBUG: Added [T.x],[T.y],[T.z] to frontier."))

			frontier += T
			visited += T

		to_chat(caster, span_notice("DEBUG: Sleeping before next growth pulse."))
		sleep(5)

	if(planted_any)
		to_chat(caster, span_green("The land flourishes under your command."))
	else
		to_chat(caster, span_warning("No life answered your call."))

	to_chat(caster, span_notice("DEBUG: Propagation finished."))

	caster.remove_status_effect(/datum/status_effect/debuff/dendor_growing)

/datum/action/cooldown/spell/dendor/verdant_manifestation/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/caster = owner
	if(!caster)
		return FALSE
	var/turf/origin = get_turf(caster)
	var/turf/start = get_turf(cast_on) || origin

	if(!start)
		reset_spell_cooldown()
		return FALSE

	var/obj/item/seeds/seed_packet = get_available_seed_packet(caster)

	if(seed_packet)
		if(caster.has_status_effect(/datum/status_effect/debuff/dendor_growing))
			to_chat(caster, span_warning("The roots are already spreading."))
			reset_spell_cooldown()
			return FALSE

		if(!is_valid_dendor_growth_turf(start))
			to_chat(caster, span_warning("Life cannot take root there."))
			reset_spell_cooldown()
			return FALSE

		if(isclosedturf(start))
			to_chat(caster, span_warning("Something blocks the soil."))
			reset_spell_cooldown()
			return FALSE

		caster.apply_status_effect(/datum/status_effect/debuff/dendor_growing, 30 SECONDS)

		to_chat(caster, span_green("You awaken dormant life beneath the earth."))

		INVOKE_ASYNC(src, PROC_REF(propagate_seeds), caster, start)

		return TRUE

	var/list/allowed_flora = list(
		"bedraggled tree",
		"sacred tree",
		"thorn bush",
		"mushroom cluster",
		"corpse fungus",
		"marrow-cap",
		"canker stool",
		"grieving angel",
		"bunch of swampweed",
		"westleach bush",
		"reeds",
		"screaming tree",
		"great bush",
		"pine tree",
		"ancient log"
	)

	var/list/options = list(
		"Glowshrooms",
		"Vines",
		"Evil Tree"
	)

	for(var/typepath in subtypesof(/obj/structure/flora))
		if(typepath == /obj/structure/flora)
			continue

		if(typepath == /obj/structure/flora/roguetree/evil)
			continue

		var/obj/structure/flora/F = typepath
		var/flora_name = lowertext(initial(F.name))

		if(!(flora_name in allowed_flora))
			continue

		options += initial(F.name)

	var/choice = tgui_input_list(
		caster,
		"Choose what to grow.",
		"Verdant Manifestation",
		options
	)

	if(!choice)
		reset_spell_cooldown()
		return FALSE

	var/turf/target = get_turf(cast_on)

	if(!target)
		reset_spell_cooldown()
		return FALSE

	if(!is_valid_dendor_growth_turf(target))
		to_chat(caster, span_warning("Life cannot take root there."))
		reset_spell_cooldown()
		return FALSE

	if(isclosedturf(target))
		to_chat(caster, span_warning("Something blocks the soil."))
		reset_spell_cooldown()
		return FALSE

	if(choice == "Evil Tree")
		if(locate(/obj/structure/flora/roguetree/evil) in target)
			reset_spell_cooldown()
			return FALSE

		new /obj/structure/flora/roguetree/evil(target)
		caster.visible_message(span_green("[caster] calls wicked roots from the earth!"))
		playsound(origin, sound, 100, FALSE)
		new /obj/effect/temp_visual/dendor_bless(target)
		return TRUE

	if(choice == "Glowshrooms")
		var/spawned = FALSE

		for(var/dir in GLOB.cardinals)
			var/turf/T = get_step(origin, dir)

			if(!T)
				continue
			if(!is_valid_dendor_growth_turf(T))
				continue
			if(isclosedturf(T))
				continue
			if(locate(/obj/structure/glowshroom) in T)
				continue

			new /obj/structure/glowshroom(T)
			spawned = TRUE

		if(!spawned)
			reset_spell_cooldown()
			return FALSE

		caster.visible_message(span_green("[caster] calls luminous fungi from the earth!"))
		playsound(origin, sound, 100, FALSE)
		return TRUE

	if(choice == "Vines")
		var/turf/front = get_step(caster, caster.dir)

		if(!front || !is_valid_dendor_growth_turf(front))
			to_chat(caster, span_warning("The vines refuse this ground."))
			reset_spell_cooldown()
			return FALSE

		var/list/spawn_tiles = list(
			front,
			get_step(front, turn(caster.dir, 90)),
			get_step(front, turn(caster.dir, -90))
		)

		var/spawned = FALSE

		for(var/turf/T in spawn_tiles)
			if(!T)
				continue
			if(!is_valid_dendor_growth_turf(T))
				continue
			if(isclosedturf(T))
				continue
			if(locate(/obj/structure/vine) in T)
				continue

			new /obj/structure/vine/dendor(T)
			spawned = TRUE

		if(!spawned)
			reset_spell_cooldown()
			return FALSE

		caster.visible_message(span_green("[caster] calls grasping vines from the soil!"))
		playsound(origin, sound, 100, FALSE)
		return TRUE

	var/type_to_spawn = null

	for(var/typepath in subtypesof(/obj/structure/flora))
		if(typepath == /obj/structure/flora)
			continue

		var/obj/structure/flora/F = typepath

		if(initial(F.name) == choice)
			type_to_spawn = typepath
			break

	if(!type_to_spawn)
		reset_spell_cooldown()
		return FALSE

	if(locate(type_to_spawn) in target)
		to_chat(caster, span_warning("That already grows there."))
		reset_spell_cooldown()
		return FALSE

	new type_to_spawn(target)

	caster.visible_message(span_green("[caster] calls new life from the earth!"))
	playsound(origin, sound, 100, FALSE)
	new /obj/effect/temp_visual/dendor_bless(target)

	return TRUE


///////////////////////////
// T4 - Call of the Moon //
///////////////////////////

/obj/effect/proc_holder/spell/self/howl/call_of_the_moon
	name = "Call of the Moon"
	desc = "Draw upon the secrets of the hidden firmament to converse with the mooncursed."
	action_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_state = "howl"
	antimagic_allowed = FALSE
	recharge_time = 600
	ignore_cockblock = TRUE
	use_language = TRUE
	var/first_cast = FALSE

/obj/effect/proc_holder/spell/self/howl/call_of_the_moon/cast(mob/living/carbon/human/user)
	// only usable at night
	if (!GLOB.tod == "night")
		to_chat(user, span_warning("I must wait for the hidden moon to rise before I may call upon it."))
		revert_cast()
		return
	// if they don't have beast language somehow, give it to them
	if (!user.has_language(/datum/language/beast))
		user.grant_language(/datum/language/beast)
		to_chat(user, span_boldnotice("The vestige of the hidden moon high above reveals His truth: the knowledge of beast-tongue was in me all along."))
	
	if (!first_cast)
		to_chat(user, span_boldwarning("So it is murmured in the Earth and Air: the Call of the Moon is sacred, and to share knowledge gleaned from it with those not of Him is a SIN."))
		to_chat(user, span_boldwarning("Ware thee well, child of Dendor."))
		first_cast = TRUE
	. = ..()
