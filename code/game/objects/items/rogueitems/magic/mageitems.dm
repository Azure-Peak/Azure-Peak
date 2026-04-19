/obj/item/storage/magebag
	name = "scholar's pouch"
	desc = "A pouch to carry handfuls of ingredients for summoning and alchemy."
	icon_state = "summoning"
	item_state = "summoning"
	icon = 'icons/roguetown/clothing/storage.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_HIP
	resistance_flags = NONE
	max_integrity = 300
	component_type = /datum/component/storage/concrete/grid/magebag

/obj/item/storage/magebag/examine(mob/user)
	. = ..()
	if(contents.len)
		. += span_notice("[contents.len] thing[contents.len > 1 ? "s" : ""] in the pouch.")

/obj/item/storage/magebag/attack_right(mob/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	var/list/things = STR.contents()
	if(things.len)
		var/obj/item/I = pick(things)
		STR.remove_from_storage(I, get_turf(user))
		user.put_in_hands(I)

/obj/item/storage/magebag/update_icon()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	var/list/things = STR.contents()
	if(things.len)
		icon_state = "summoning"
		w_class = WEIGHT_CLASS_NORMAL
	else
		icon_state = "summoning"
		w_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/magebag/associate
	populate_contents = list()

/obj/item/storage/magebag/starter
	populate_contents = list()
/obj/item/chalk
	name = "stick of chalk"
	desc = "A stark-white stick of chalk, possibly made from quicksilver. "
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "chalk"
	throw_speed = 2
	throw_range = 5
	throwforce = 5
	damtype = BRUTE
	force = 1
	w_class = WEIGHT_CLASS_TINY
	var/obj/effect/decal/cleanable/roguerune/rune_to_scribe = null
	var/chosen_keyword

/obj/item/chalk/attack_self(mob/living/carbon/human/user)
	if(!isarcyne(user))
		to_chat(user, span_cult("Nothing comes in mind to draw with the chalk."))
		return

	var/obj/effect/decal/cleanable/roguerune/pickrune
	var/runenameinput

	runenameinput = input(user, "Runes", "Runes") as null|anything in GLOB.t3rune_types

	pickrune = GLOB.rune_types[runenameinput]
	rune_to_scribe = pickrune
	if(rune_to_scribe == null)
		return
	var/turf/Turf = get_turf(user)
	if(locate(/obj/effect/decal/cleanable/roguerune) in Turf)
		to_chat(user, span_cult("There is already a rune here."))
		return
	var/structures_in_way = check_for_structures_and_closed_turfs(loc, rune_to_scribe)
	if(structures_in_way == TRUE)
		to_chat(user, span_cult("There is a structure, rune or wall in the way."))
		return
	if(initial(rune_to_scribe.requires_leyline))
		var/found_leyline = FALSE
		for(var/obj/structure/leyline/L in range(5, user))
			found_leyline = TRUE
			break
		if(!found_leyline)
			to_chat(user, span_warning("This matrix must be drawn within reach of a leyline."))
			return
	if(initial(rune_to_scribe.req_keyword))
		chosen_keyword = stripped_input(user, "Keyword for the new rune", "Runes", max_length = MAX_NAME_LEN)
		if(!chosen_keyword)
			return
	var/crafttime = (100 - ((user.get_skill_level(/datum/skill/magic/arcane))*5))

	user.visible_message(span_notice("\The [user] begins to drag [user.p_their()] [name] over \the [Turf], inscribing intricate symbols and sigils inside a circle."), span_notice("I start to drag my [name] over \the [Turf], inscribing intricate symbols and sigils on a circle."))
	playsound(loc, 'sound/magic/chalkdraw.ogg', 100, TRUE)
	if(do_after(user, crafttime, target = src))
		user.visible_message(span_warning("[user] draws an arcyne rune with [user.p_their()] [name]!"), \
		span_notice("I finish tracing ornate symbols and circles with my [name], leaving behind a ritual rune."))
		new rune_to_scribe(Turf, chosen_keyword)

/obj/item/chalk/proc/check_for_structures_and_closed_turfs(loc, var/obj/effect/decal/cleanable/roguerune/rune_to_scribe)
	for(var/turf/T in range(loc, rune_to_scribe.runesize))
		//check for /sturcture subtypes in the turf's contents
		for(var/obj/structure/S in T.contents)
			return TRUE		//Found a structure, no need to continue

		//check if turf itself is a /turf/closed subtype
		if(istype(T,/turf/closed))
			return TRUE
		//check if rune in the turfs contents
		for(var/obj/effect/decal/cleanable/roguerune/R in T.contents)
			return TRUE
		//Return false if nothing in range was found
	return FALSE


/obj/item/rogueweapon/huntingknife/idagger/silver/arcyne
	name = "arcyne silver dagger"
	desc = "This dagger glows a faint purple. Quicksilver runs across its blade."
	icon_state = "arcynedagger"
	var/is_bled = FALSE
	var/obj/effect/decal/cleanable/roguerune/rune_to_scribe = null
	var/chosen_keyword

/obj/item/rogueweapon/huntingknife/idagger/silver/arcyne/Initialize()
	. = ..()
	filter(type="drop_shadow", x=0, y=0, size=2, offset=1, color=rgb(128, 0, 128, 1))

/obj/item/rogueweapon/huntingknife/idagger/silver/arcyne/attack_self(mob/living/carbon/human/user)
	if(!isarcyne(user))
		return
	if(!is_bled)
		playsound(loc, get_sfx("genslash"), 100, TRUE)
		user.visible_message(span_warning("[user] cuts open [user.p_their()] palm!"), \
			span_cult("I slice open my palm!"))
		if(user.blood_volume)
			var/obj/effect/decal/cleanable/roguerune/rune = rune_to_scribe
			user.apply_damage(initial(rune.scribe_damage), BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		is_bled = TRUE
		return
	var/obj/effect/decal/cleanable/roguerune/pickrune
	var/runenameinput = input(user, "Runes", "All Runes") as null|anything in GLOB.t4rune_types

	pickrune = GLOB.rune_types[runenameinput]
	rune_to_scribe = pickrune
	if(rune_to_scribe == null)
		return
	var/turf/Turf = get_turf(user)
	if(locate(/obj/effect/decal/cleanable/roguerune) in Turf)
		to_chat(user, span_cult("There is already a rune here."))
		return
	var/structures_in_way = check_for_structures_and_closed_turfs(loc, rune_to_scribe)
	if(structures_in_way)
		to_chat(user, span_cult("There is a structure, rune or wall in the way."))
		return
	if(initial(rune_to_scribe.requires_leyline))
		var/found_leyline = FALSE
		for(var/obj/structure/leyline/L in range(5, user))
			found_leyline = TRUE
			break
		if(!found_leyline)
			to_chat(user, span_warning("This matrix must be drawn within reach of a leyline."))
			return
	if(initial(rune_to_scribe.req_keyword))
		chosen_keyword = stripped_input(user, "Keyword for the new rune", "T4 Runes", max_length = MAX_NAME_LEN)
		if(!chosen_keyword)
			return FALSE
	var/crafttime = (100 - ((user.get_skill_level(/datum/skill/magic/arcane))*5))

	user.visible_message(span_notice("[user] starts to carve an arcyne rune with [user.p_their()] [name]."), \
		span_notice("I start to drag the blade in the shape of symbols and sigils."))
	playsound(loc, 'sound/magic/bladescrape.ogg', 100, TRUE)
	if(do_after(user, crafttime, target = src))
		user.visible_message(
			span_warning("[user] carves an arcyne rune with [user.p_their()] [name]!"), \
			span_notice("I finish dragging the blade in symbols and circles, leaving behind an ritual rune")
		)
		new rune_to_scribe(Turf, chosen_keyword)

/obj/item/rogueweapon/huntingknife/idagger/proc/check_for_structures_and_closed_turfs(loc, var/obj/effect/decal/cleanable/roguerune/rune_to_scribe)
	for(var/turf/T in range(loc, rune_to_scribe.runesize))
		//check for /sturcture subtypes in the turf's contents
		for(var/obj/structure/S in T.contents)
			return TRUE		//Found a structure, no need to continue

		//check if turf itself is a /turf/closed subtype
		if(istype(T,/turf/closed))
			return TRUE
		//check if rune in the turfs contents
		for(var/obj/effect/decal/cleanable/roguerune/R in T.contents)
			return TRUE
		//Return false if nothing in range was found
	return FALSE


/obj/item/mimictrinket
	name = "mimic trinket"
	desc = "A small mimic, imbued with the arcane to make it docile. It can transform into most things it touchs. "
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "mimic_trinket"
	possible_item_intents = list(/datum/intent/use)
	var/duration = 10 MINUTES
	var/oldicon
	var/oldicon_state
	var/olddesc
	var/oldname
	var/ready = TRUE
	var/timing_id

/obj/item/mimictrinket/attack_self(mob/living/carbon/human/user)
	revert()

/obj/item/mimictrinket/proc/revert()
	if(oldicon == null || oldicon_state == null || oldname == null || olddesc == null)
		return
	to_chat(usr, span_notice("[src] reverts back to its original form."))
	icon = oldicon
	icon_state = oldicon_state
	name = oldname
	desc = olddesc
	ready = TRUE
	if(timing_id)
		deltimer(timing_id)
		timing_id = null

/obj/item/mimictrinket/attack_obj(obj/target, mob/living/user)
	if(ready)
		to_chat(user,span_notice("[src] takes the form of [target]!"))
		oldicon = icon
		oldicon_state = icon_state
		olddesc = desc
		oldname = name
		icon = target.icon
		icon_state = target.icon_state
		name = target.name
		desc = target.desc
		ready = FALSE
		timing_id = addtimer(CALLBACK(src, PROC_REF(revert), user), duration,TIMER_STOPPABLE) // Minus two so we play the sound and decap faster


/obj/item/hourglass/temporal
	name = "temporal hourglass"
	desc = "An arcane infused hourglass that glows with magick."
	icon = 'icons/obj/hourglass.dmi'
	icon_state = "hourglass_idle"
	var/turf/target
	var/mob/living/victim

/obj/item/hourglass/temporal/toggle(mob/user)
	if(!timing_id)
		to_chat(user,span_notice("I flip the [src]."))
		start()
		flick("hourglass_flip",src)
		target = get_turf(src)
		victim = user
	else
		to_chat(user,span_notice("I stop the [src].")) //Sand magically flows back because that's more convinient to use.
		stop()

/obj/item/hourglass/temporal/stop()
	..()
	do_teleport(victim, target, channel = TELEPORT_CHANNEL_QUANTUM)

/obj/item/natural/feather/infernal
	name = "infernal feather"
	icon_state = "hellfeather"
	possible_item_intents = list(/datum/intent/use)
	desc = "A fluffy feather."

/obj/item/flashlight/flare/torch/lantern/voidlamptern
	name = "void lamptern"
	icon_state = "voidlamp"
	item_state = "voidlamp"
	desc = "An old lamptern that seems darker and darker the longer you look at it."
	light_outer_range = 8
	light_color = "#000000"
	light_power = -3
	on = FALSE

/obj/item/clothing/ring/active/shimmeringlens
	name = "shimmering lens"
	desc = "A radiantly shimmering glass of lens that shimmers with magick. Looking through it gives you a bit of a headache."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "lens"
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FIRE_PROOF | ACID_PROOF
	cdtime = 10 MINUTES
	activetime = 30 SECONDS
	salvage_result = null

/obj/item/clothing/ring/active/shimmeringlens/attack_right(mob/user)
	if(loc != user)
		return
	if(cooldowny)
		if(world.time < cooldowny + cdtime)
			to_chat(user, span_warning("Pulses weakily-! It must still be gathering arcana."))
			return
	user.visible_message(span_warning("[user] looks through the [src]!"))
	if(activate_sound)
		playsound(user, activate_sound, 100, FALSE, -1)
	cooldowny = world.time
	addtimer(CALLBACK(src, PROC_REF(demagicify)), activetime)
	active = TRUE
	activate(user)

/obj/item/clothing/ring/active/shimmeringlens/activate(mob/user)
	ADD_TRAIT(user, TRAIT_XRAY_VISION, "[type]")

/obj/item/clothing/ring/active/shimmeringlens/demagicify()
	var/mob/living/user = usr
	REMOVE_TRAIT(user, TRAIT_XRAY_VISION, "[type]")
	active = FALSE

/obj/item/sendingstonesummoner/Initialize()
	. = ..()
	var/mob/living/user = usr
	var/obj/item/natural/stone/sending/item1 = new /obj/item/natural/stone/sending
	var/obj/item/natural/stone/sending/item2 = new /obj/item/natural/stone/sending
	item1.paired_with = item2
	item2.paired_with = item1
	item1.icon_state = "whet"
	item2.icon_state = "whet"
	item1.color = "#d8aeff"
	item2.color = "#d8aeff"
	user.put_in_hands(item1, FALSE)
	user.put_in_hands(item2, FALSE)
	qdel(src)

/obj/item/natural/stone/sending
	name = "sending stone"
	desc = "One of a pair of sending stones."
	var/obj/item/natural/stone/sending/paired_with

/obj/item/natural/stone/sending/attack_self(mob/user)
	var/input_text = input(user, "Enter your message:", "Message")
	if(input_text)
		paired_with.say(input_text)

/obj/item/clothing/neck/roguetown/collar/leather/nomagic
	name = "mana-binding collar"
	desc = "A comfortable collar made of leather. studded with red gems"
	icon_state = "manabindingcollar"
	color = null
	slot_flags = ITEM_SLOT_NECK
	salvage_result = null
	unequip_delay_self = 1200

/obj/item/clothing/neck/roguetown/collar/leather/nomagic/Initialize(mapload)
	. = ..()
	var/datum/magic_item/mundane/nomagic/effect = new
	AddComponent(/datum/component/magic_item, effect)

/obj/item/clothing/gloves/roguetown/nomagic
	icon_state = "manabindinggloves"
	bloody_icon_state = "bloodyhands"
	name = "gem encrusted mana binding gloves"
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_SMALL
	allow_self_unequip = FALSE	//Can not remove these without help
	equip_delay_self = 60
	equip_delay_other = 60
	strip_delay = 300
	salvage_result = null

/obj/item/clothing/gloves/roguetown/nomagic/Initialize(mapload)
	. = ..()
	var/datum/magic_item/mundane/nomagic/effect = new
	AddComponent(/datum/component/magic_item, effect)
