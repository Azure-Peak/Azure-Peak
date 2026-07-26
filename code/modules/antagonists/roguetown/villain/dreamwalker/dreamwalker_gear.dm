// Component for dream weapon special properties
/datum/component/dream_weapon
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/effect_type = null
	var/cooldown_time
	var/next_use = 0
	var/hit_counter = 0

/datum/component/dream_weapon/Initialize(effect_type, cooldown_time)
	. = ..()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	src.effect_type = effect_type
	src.cooldown_time = cooldown_time

	RegisterSignal(parent, COMSIG_ITEM_ATTACK_SUCCESS, .proc/on_attack)
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, .proc/on_equipped)


/datum/component/dream_weapon/proc/on_attack(obj/item/source, mob/living/target, mob/living/user)
	SIGNAL_HANDLER
	if(!effect_type)
		return

	hit_counter++
	if(hit_counter < 3)
		return

	// Check cooldown
	if(world.time < next_use)
		return

	if(!ishuman(target))
		return

	hit_counter = 0

	var/mob/living/carbon/human/H = target

	// Apply effect based on type
	switch(effect_type)
		if("fire")
			H.adjust_fire_stacks(4)
			spawn(0)
				H.ignite_mob()
			target.visible_message(span_warning("[source] ignites [target] with strange flame!"))
		if("frost")
			apply_frost_stack(H, 2)
			target.visible_message(span_warning("[source] freezes [target] with scalding ice!"))
		if("poison")
			var/datum/status_effect/black_rot/R = H.has_status_effect(/datum/status_effect/black_rot)
			if(R)
				R.add_stack(5)
			else
				H.apply_status_effect(/datum/status_effect/black_rot, 5)
			target.visible_message(span_warning("[source] seeps black rot into [target]!"))

	// Set cooldown
	next_use = world.time + cooldown_time

/datum/component/dream_weapon/proc/on_equipped(obj/item/source, mob/user, slot)
	SIGNAL_HANDLER
	if(HAS_TRAIT(user, TRAIT_DREAMWALKER))
		return

	// Non-dreamwalker trying to equip a dream weapon
	to_chat(user, span_userdanger("The weapon rejects your touch, burning with dream energy!"))
	user.dropItemToGround(source, TRUE)

	// Apply some damage or negative effect
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		spawn(0)
			H.apply_damage(10, BURN, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
			H.adjust_fire_stacks(2)
			H.ignite_mob()

/obj/item/rogueweapon/halberd/glaive/dreamscape
	name = "otherworldly spear"
	desc = "A strange spear, who knows where it came from. It seems like it is made out of ancient bone."
	icon_state = "dreamspear"
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = null
	item_flags = DREAM_ITEM
	wbalance = WBALANCE_HEAVY
	max_blade_int = 200
	wdefense = 8

/obj/item/rogueweapon/halberd/glaive/dreamscape/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD, HERESYDESC_DREAM_ITEM)

/obj/item/rogueweapon/halberd/glaive/dreamscape/active
	desc = "A strange spear, who knows where it came from. Strange harmonious sounds ring out as wind passes through the holes."
	icon_state = "dreamspearactive"
	max_blade_int = 400
	wdefense = 9
	force = 20
	force_wielded = 35

/obj/item/rogueweapon/halberd/glaive/dreamscape/active/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_DREAMWALKER_WEAPON)

/obj/item/rogueweapon/greatsword/bsword/dreamscape
	name = "otherworldly sword"
	desc = "A strange sword made out of a strange reflective metal."
	icon_state = "dreamsword"
	force = 25
	force_wielded = 30
	max_integrity = 275
	smeltresult = null
	item_flags = DREAM_ITEM
	wbalance = WBALANCE_HEAVY
	wdefense = 4
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/chop, /datum/intent/sword/thrust/long)
	gripped_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/sword/chop, /datum/intent/sword/thrust/estoc/lunge, /datum/intent/sword/thrust/estoc)
	alt_grips = list(/datum/alt_grip/mordhau/broadsword/dream_broadsword)

/obj/item/rogueweapon/greatsword/bsword/dreamscape/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD, HERESYDESC_DREAM_ITEM)

/obj/item/rogueweapon/greatsword/bsword/dreamscape/active
	name = "otherworldly sword"
	desc = "A strange sword made out of a strange reflective metal. It oozes sickening sludge."
	icon_state = "dreamswordactive"
	max_integrity = 500
	force = 30
	force_wielded = 35
	wdefense = 5

/obj/item/rogueweapon/greatsword/bsword/dreamscape/active/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_DREAMWALKER_WEAPON)

/obj/item/rogueweapon/spear/dreamscape_trident
	name = "otherworldly trident"
	desc = "A strange trident. It feels like it shouldn't be an effective weapon, but the dull metal whispers tales of its power to you."
	icon_state = "dreamtri"
	smeltresult = null
	max_blade_int = 240
	minstr = 8
	wdefense = 4
	throwforce = 40
	force = 30
	force_wielded = 20
	item_flags = DREAM_ITEM
	var/shockwave_cooldown = 0
	var/shockwave_cooldown_interval = 1 MINUTES
	var/shockwave_divisor = 3
	var/shockwave_damage = FALSE

/obj/item/rogueweapon/spear/dreamscape_trident/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD, HERESYDESC_DREAM_ITEM)

/obj/item/rogueweapon/spear/dreamscape_trident/active
	name = "Iridescent trident"
	desc = "A strange trident glimmering with an oily hue. The air shimmers around it."
	icon_state = "dreamtriactive"
	max_integrity = 480
	throwforce = 50
	force = 35
	force_wielded = 25
	wdefense = 5
	shockwave_cooldown_interval = 30 SECONDS
	shockwave_divisor = 2
	shockwave_damage = TRUE

/obj/item/rogueweapon/spear/dreamscape_trident/active/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_DREAMWALKER_WEAPON)

// Update weapon initializations with specific effects
/obj/item/rogueweapon/greataxe/dreamscape/active/Initialize()
	. = ..()
	AddComponent(/datum/component/dream_weapon, "fire", 20 SECONDS)

/obj/item/rogueweapon/halberd/glaive/dreamscape/active/Initialize()
	. = ..()
	AddComponent(/datum/component/dream_weapon, "frost", 40 SECONDS)

/obj/item/rogueweapon/greatsword/bsword/dreamscape/active/Initialize()
	. = ..()
	AddComponent(/datum/component/dream_weapon, "poison", 20 SECONDS)

/obj/item/rogueweapon/spear/dreamscape_trident/active/Initialize()
	. = ..()
	AddComponent(/datum/component/dream_weapon, null, 20 SECONDS)

/datum/outfit/job/roguetown/dreamwalker_armorrite/pre_equip(mob/living/carbon/human/H)
	..()
	var/list/items = list()
	items |= H.get_equipped_items(TRUE)
	for(var/I in items)
		H.dropItemToGround(I, TRUE)
	H.drop_all_held_items()
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/dreamwalker
	wrists = /obj/item/clothing/wrists/roguetown/bracers/dreamwalker
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/dreamwalker
	pants = /obj/item/clothing/under/roguetown/platelegs/dreamwalker
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/dreamwalker
	gloves = /obj/item/clothing/gloves/roguetown/plate/dreamwalker
	head = /obj/item/clothing/head/roguetown/helmet/bascinet/dreamwalker
	neck = /obj/item/clothing/neck/roguetown/bevor/dreamwalker

/obj/item/clothing/suit/roguetown/armor/plate/full/dreamwalker
	name = "otherworldly fullplate"
	desc = "Strange iridescent full plate. It reflects light as if covered in shiny oil."
	icon_state = "dreamplate"
	max_integrity = ARMOR_INT_CHEST_PLATE_ANTAG
	item_flags = DREAM_ITEM
	unenchantable = TRUE //Please sire, it has self-repairing plus antag-durability. YOU DO NOT NEED MORE.

/obj/item/clothing/suit/roguetown/armor/plate/full/dreamwalker/Initialize()
	. = ..()
	AddComponent(/datum/component/dream_weapon, null, 20 SECONDS)

/obj/item/clothing/suit/roguetown/armor/plate/full/dreamwalker/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_DREAMWALKER_ARMOR)

/obj/item/clothing/under/roguetown/platelegs/dreamwalker
	max_integrity = ARMOR_INT_LEG_ANTAG
	name = "otherworldly legplate"
	desc = "Strange iridescent leg plate. It reflects light as if covered in shiny oil."
	icon_state = "dreamlegs"
	armor = ARMOR_PLATE_BSTEEL
	item_flags = DREAM_ITEM
	unenchantable = TRUE //Please sire, it has self-repairing plus antag-durability. YOU DO NOT NEED MORE.

/obj/item/clothing/under/roguetown/platelegs/dreamwalker/Initialize()
	. = ..()
	AddComponent(/datum/component/dream_weapon, null, 20 SECONDS)

/obj/item/clothing/under/roguetown/platelegs/dreamwalker/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_DREAMWALKER_ARMOR)

/obj/item/clothing/shoes/roguetown/boots/armor/dreamwalker
	max_integrity = ARMOR_INT_SIDE_ANTAG
	name = "otherworldly boots"
	desc = "Strange iridescent plated boots. It reflects light as if covered in shiny oil."
	icon_state = "dreamboots"
	armor = ARMOR_PLATE_BSTEEL
	item_flags = DREAM_ITEM
	unenchantable = TRUE //Please sire, it has self-repairing plus antag-durability. YOU DO NOT NEED MORE.

/obj/item/clothing/shoes/roguetown/boots/armor/dreamwalker/Initialize()
	. = ..()
	AddComponent(/datum/component/dream_weapon, null, 20 SECONDS)

/obj/item/clothing/shoes/roguetown/boots/armor/dreamwalker/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_DREAMWALKER_ARMOR)

/obj/item/clothing/gloves/roguetown/plate/dreamwalker
	name = "otherworldly gauntlets"
	desc = "Strange iridescent plated gauntlets. It reflects light as if covered in shiny oil."
	icon_state = "dreamgauntlets"
	max_integrity = ARMOR_INT_SIDE_ANTAG
	item_flags = DREAM_ITEM
	unenchantable = TRUE //Please sire, it has self-repairing plus antag-durability. YOU DO NOT NEED MORE.

/obj/item/clothing/gloves/roguetown/plate/dreamwalker/Initialize()
	. = ..()
	AddComponent(/datum/component/dream_weapon, null, 20 SECONDS)

/obj/item/clothing/gloves/roguetown/plate/dreamwalker/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_DREAMWALKER_ARMOR)

/obj/item/clothing/neck/roguetown/bevor/dreamwalker
	name = "otherworldly bevor"
	desc = "Strange iridescent plated bevor. It reflects light as if covered in shiny oil."
	icon_state = "dbevor"
	max_integrity = ARMOR_INT_SIDE_ANTAG
	item_flags = DREAM_ITEM
	unenchantable = TRUE //Please sire, it has self-repairing plus antag-durability. YOU DO NOT NEED MORE.

/obj/item/clothing/neck/roguetown/bevor/dreamwalker/Initialize()
	. = ..()
	AddComponent(/datum/component/dream_weapon, null, 20 SECONDS)

/obj/item/clothing/neck/roguetown/bevor/dreamwalker/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_DREAMWALKER_ARMOR)

// Uses hauberk's int value as I don't want to make them TOO armored either!!
/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/dreamwalker
	name = "otherworldly hauberk"
	desc = "Strange iridescent hauberk. It reflects light as if covered in shiny oil."
	icon_state = "dhauberk"
	item_flags = DREAM_ITEM
	unenchantable = TRUE //Please sire, it has self-repairing plus antag-durability. YOU DO NOT NEED MORE.

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/dreamwalker/Initialize()
	. = ..()
	AddComponent(/datum/component/dream_weapon, null, 20 SECONDS)

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/dreamwalker/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_DREAMWALKER_ARMOR)

// Ditto!! I don't want them TOO armored!!!
/obj/item/clothing/wrists/roguetown/bracers/dreamwalker
	name = "otherworldly bracers"
	desc = "Strange iridescent bracers. It reflects light as if covered in shiny oil."
	item_flags = DREAM_ITEM
	unenchantable = TRUE //Please sire, it has self-repairing plus antag-durability. YOU DO NOT NEED MORE.
	color = "#2ba6b2"

/obj/item/clothing/wrists/roguetown/bracers/dreamwalker/Initialize()
	. = ..()
	AddComponent(/datum/component/dream_weapon, null, 20 SECONDS)

/obj/item/clothing/wrists/roguetown/bracers/dreamwalker/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_DREAMWALKER_ARMOR)

/obj/item/clothing/head/roguetown/helmet/bascinet/dreamwalker
	name = "otherworldly squid helm"
	desc = "A otherworldly squid helm. It reflects light as if covered in shiny oil."
	adjustable = CAN_CADJUST
	icon_state = "dreamsquidhelm"
	max_integrity = ARMOR_INT_HELMET_ANTAG
	item_flags = DREAM_ITEM
	unenchantable = TRUE //Please sire, it has self-repairing plus antag-durability. YOU DO NOT NEED MORE.
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x48/head.dmi'
	block2add = null
	worn_x_dimension = 32
	worn_y_dimension = 48
	body_parts_covered = FULL_HEAD
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH

/obj/item/clothing/head/roguetown/helmet/bascinet/dreamwalker/Initialize()
	. = ..()
	AddComponent(/datum/component/dream_weapon, null, 20 SECONDS)

/obj/item/clothing/head/roguetown/helmet/bascinet/dreamwalker/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_DREAMWALKER_ARMOR)

/datum/component/dreamwalker_repair
	/// List of dream items being repaired
	var/list/repairing_items = list()
	/// How much damage our items have taken
	var/accumulated_damage = 0
	/// How much damage it takes before we spawn a repair shard
	var/shard_threshold = 100
	/// How much damage our repair shard repairs
	var/shard_repair_value = 50
	/// Type of shard to spawn
	var/obj/effect/temp_visual/dream_shard/shard_type = /obj/effect/temp_visual/dream_shard

/datum/component/dreamwalker_repair/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	to_chat(parent, span_userdanger("Your body pulses with strange restorative energies."))
	RegisterSignal(parent, COMSIG_MOB_EQUIPPED_ITEM, .proc/on_item_equipped)
	RegisterSignal(parent, COMSIG_MOB_DROPITEM, .proc/on_item_dropped)

/datum/component/dreamwalker_repair/proc/on_item_equipped(mob/user, obj/item/source, slot)
	SIGNAL_HANDLER
	if(source.item_flags & DREAM_ITEM)
		to_chat(parent, span_notice("the [source] pulses in your hands, restorative energies swirling around it."))
		add_item(source)

/datum/component/dreamwalker_repair/proc/on_item_dropped(mob/user, obj/item/source)
	SIGNAL_HANDLER
	if(source.item_flags & DREAM_ITEM)
		to_chat(parent, span_notice("the [source] stops pulsing as it leaves your person."))
		remove_item(source)

/datum/component/dreamwalker_repair/proc/add_item(obj/item/I)
	if(I in repairing_items)
		return
	repairing_items += I
	RegisterSignal(I, COMSIG_OBJ_TAKE_DAMAGE, .proc/on_gear_damaged)

/datum/component/dreamwalker_repair/proc/remove_item(obj/item/I)
	if(I in repairing_items)
		repairing_items -= I
		UnregisterSignal(I, COMSIG_OBJ_TAKE_DAMAGE)

/datum/component/dreamwalker_repair/proc/on_gear_damaged(obj/item/source, damage_amount)
	SIGNAL_HANDLER
	accumulated_damage += damage_amount

	if(accumulated_damage >= shard_threshold)
		spawn_shard()
		accumulated_damage -= shard_threshold

/datum/component/dreamwalker_repair/proc/spawn_shard(shard_duration = 10 SECONDS, shard_amount = shard_repair_value)
	var/mob/living/L = parent
	var/turf/center = get_turf(L)
	if(!center)
		return

	var/back_dir = REVERSE_DIR(L.dir)
	var/side_dir = turn(L.dir, 90)
	var/list/potential_tiles = list()

	var/turf/T_back = get_step(center, back_dir)
	if(T_back)
		potential_tiles += T_back
		var/turf/TR = get_step(T_back, side_dir)
		potential_tiles += TR
		potential_tiles += get_step(TR, side_dir)
		var/turf/TL = get_step(T_back, -side_dir)
		potential_tiles += TL
		potential_tiles += get_step(TL, -side_dir)
		var/turf/T_far_back = get_step(T_back, back_dir)
		if(T_far_back)
			potential_tiles += T_far_back
			potential_tiles += get_step(T_far_back, side_dir)
			potential_tiles += get_step(T_far_back, -side_dir)

	var/list/valid_tiles = list()
	for(var/turf/T in potential_tiles)
		if(is_tile_valid(T))
			valid_tiles += T

	// Fallback - just drop it at our feet
	var/turf/chosen_spawn = length(valid_tiles) ? pick(valid_tiles) : center

	// Create shard at Player's turf, tell it where to slide to
	playsound(L, 'sound/combat/sharpness_loss1.ogg', 75, TRUE)
	new shard_type(center, shard_duration, shard_amount, chosen_spawn)

	if(prob(40))
		L.visible_message(span_boldnotice("[L.name] sheds a fragile looking shard of their armor. It seems to yearn to return to the whole."))

/datum/component/dreamwalker_repair/proc/is_tile_valid(turf/T)
	if(!T || istransparentturf(T) || T.density)
		return FALSE

	for(var/obj/O in T)
		if(O.density)
			return FALSE
	return TRUE

/datum/component/dreamwalker_repair/proc/repair_from_shard(amount)
	var/remaining_repair = amount

	// Continue repairing as long as we have juice and items to fix
	while(remaining_repair > 0)
		var/obj/item/most_broken = null
		var/lowest_percent = 1

		for(var/obj/item/I in repairing_items)
			var/integrity_ratio = I.obj_integrity / I.max_integrity
			if(integrity_ratio < lowest_percent)
				lowest_percent = integrity_ratio
				most_broken = I

		if(!most_broken)
			break // All items fully repaired

		var/needed = most_broken.max_integrity - most_broken.obj_integrity
		var/applied = min(remaining_repair, needed)
		most_broken.obj_integrity += applied
		// If this happens to repair a weapon, fix the blade completely.
		if(most_broken.max_blade_int && most_broken.blade_int < most_broken.max_blade_int)
			most_broken.blade_int = most_broken.max_blade_int
		remaining_repair -= applied

		// Handle broken state restoration
		if(most_broken.obj_broken && most_broken.obj_integrity > 0)
			most_broken.obj_fix(null, FALSE)

		most_broken.update_icon()

		if(needed > applied)
			break // This item took all remaining repair but isn't full yet

/datum/component/dreamwalker_repair/Destroy()
	for(var/obj/item/I in repairing_items)
		UnregisterSignal(I, COMSIG_OBJ_TAKE_DAMAGE)
	repairing_items = null
	return ..()

/obj/effect/temp_visual/dream_shard
	name = "dream shard"
	desc = "Looks fragile, smashable even. A grouping of jagged fragments of iridescence. They pulse with restorative energy."
	icon_state = "dream_shards"
	layer = ABOVE_OBJ_LAYER
	plane = GAME_PLANE
	anchored = TRUE
	// Gotta be able to attack it!
	mouse_opacity = 1
	duration = 5 SECONDS
	var/repair_value = 40
	var/health = 15
	var/pickuppable = TRUE
	var/dream_check = TRUE
	var/effect_color = "#005180"

/obj/effect/temp_visual/dream_shard/Initialize(mapload, set_dur, amount, turf/target_turf)
	if(amount)
		repair_value = amount
		health = amount * 0.5
	if(set_dur)
		duration = set_dur
	if(target_turf)
		pickuppable = FALSE
		animate_shard(target_turf)
	. = ..()

/obj/effect/temp_visual/dream_shard/proc/animate_shard(turf/target_turf)
	if(!istype(target_turf))
		return

	var/turf/current_turf = get_turf(src)
	if(!current_turf || current_turf == target_turf)
		return

	var/target_x = (target_turf.x - current_turf.x) * 32
	var/target_y = (target_turf.y - current_turf.y) * 32
	animate(src, pixel_x = target_x, pixel_y = target_y, time = 5, easing = ELASTIC_EASING)
	addtimer(CALLBACK(src, .proc/move_to_dest, target_turf), 5)

/obj/effect/temp_visual/dream_shard/attackby(obj/item/I, mob/user, params)
	if(HAS_TRAIT(user, TRAIT_DREAMWALKER) && dream_check)
		consume_shard(user)
		return
	else if (!dream_check)
		if(consume_shard(user))
			return

	health -= I.force
	user.visible_message(span_danger("[user] smashes the [src]!"))
	playsound(get_turf(src), 'sound/foley/breaksound.ogg', 80, TRUE)
	if(health <= 0)
		qdel(src)
	return ..()

/obj/effect/temp_visual/dream_shard/Crossed(atom/movable/AM)
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(HAS_TRAIT(H, TRAIT_DREAMWALKER) && dream_check)
			if(!consume_shard(H))
				crush_shard(AM)
		else if (!dream_check)
			if(!consume_shard(H))
				crush_shard(AM)
		else
			crush_shard(AM)

/obj/effect/temp_visual/dream_shard/proc/consume_shard(mob/living/carbon/human/H)
	if(!pickuppable || QDELETED(src))
		return FALSE
	var/datum/component/dreamwalker_repair/DR = H.GetComponent(/datum/component/dreamwalker_repair)
	if(DR)
		DR.repair_from_shard(repair_value)
		var/obj/effect/temp_visual/heal/E = new /obj/effect/temp_visual/heal_rogue/campfire(get_turf(H))
		E.color = effect_color
		playsound(H, 'sound/magic/magic_nulled.ogg', 70, TRUE)
		qdel(src)
		return TRUE
	else
		return FALSE

/obj/effect/temp_visual/dream_shard/proc/move_to_dest(turf/target_turf)
	if(src && target_turf)
		forceMove(target_turf)
		pixel_x = 0
		pixel_y = 0
		pickuppable = TRUE

/obj/effect/temp_visual/dream_shard/attack_hand(mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(.)
		return

	if(HAS_TRAIT(user, TRAIT_DREAMWALKER) && dream_check)
		consume_shard(user)
		return TRUE
	else if (!dream_check)
		if(consume_shard(user))
			return TRUE

	var/unarmed_damage = user.get_punch_dmg() || 5
	health -= unarmed_damage
	user.visible_message(span_danger("[user] smashes the [src] with their bare hands!"))
	playsound(get_turf(src), 'sound/foley/breaksound.ogg', 80, TRUE)

	if(health <= 0)
		qdel(src)
	return TRUE

/obj/effect/temp_visual/dream_shard/proc/crush_shard(atom/movable/AM)
	AM.visible_message(span_notice("[AM] crushes the [src] underfoot!"))
	playsound(get_turf(src), 'sound/foley/breaksound.ogg', 80, TRUE)
	qdel(src)
