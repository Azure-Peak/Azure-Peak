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
	populate_contents = list(
		/obj/item/magic/manacrystal,
		/obj/item/magic/manacrystal,
		/obj/item/magic/manacrystal,
		/obj/item/magic/obsidian,
		/obj/item/magic/obsidian,
		/obj/item/magic/obsidian,
		/obj/item/reagent_containers/food/snacks/grown/manabloom,
		/obj/item/reagent_containers/food/snacks/grown/manabloom,
		/obj/item/reagent_containers/food/snacks/grown/manabloom
	)

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
	var/rune_to_scribe = null
	var/amount = 8

/obj/item/chalk/examine(mob/user)
	. = ..()
	desc += "It has [amount] uses left."

/obj/item/chalk/attackby(obj/item/M, mob/user, params)
	if(istype(M,/obj/item/rogueore/cinnabar))
		if(amount < 8)
			amount = 8
			to_chat(user, span_notice("I press arcyne magic into the [M] and the red crystals within melt into quicksilver, quickly sinking into the [src]."))
	else
		return ..()


/obj/item/chalk/attack_self(mob/living/carbon/human/user)
	if(!isarcyne(user))
		to_chat(user, span_cult("Nothing comes in mind to draw with the chalk."))
		return

	var/obj/effect/decal/cleanable/roguerune/pickrune
	var/runenameinput

	if(HAS_TRAIT(user, TRAIT_ARCYNE_T1))
		runenameinput = input(user, "Runes", "Tier 1 Runes") as null|anything in GLOB.t1rune_types
	else
		runenameinput = input(user, "Runes", "Tier 1 & 2 Runes") as null|anything in GLOB.t2rune_types

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
	var/crafttime = (100 - ((user.get_skill_level(/datum/skill/magic/arcane))*5))

	user.visible_message(span_notice("\The [user] begins to drag [user.p_their()] [name] over \the [Turf], inscribing intricate symbols and sigils inside a circle."), span_notice("I start to drag my [name] over \the [Turf], inscribing intricate symbols and sigils on a circle."))
	playsound(loc, 'sound/magic/chalkdraw.ogg', 100, TRUE)
	if(do_after(user, crafttime, target = src))
		user.visible_message(span_warning("[user] draws an arcyne rune with [user.p_their()] [name]!"), \
		span_notice("I finish tracing ornate symbols and circles with my [name], leaving behind a ritual rune."))
		src.amount --
		new rune_to_scribe(Turf)
	if(amount == 0)
		qdel(src)

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
	var/is_bled = FALSE
	var/obj/effect/decal/cleanable/roguerune/rune_to_scribe = null
	var/chosen_keyword

/obj/item/rogueweapon/huntingknife/idagger/silver/arcyne/Initialize()
	. = ..()
	filter(type="drop_shadow", x=0, y=0, size=2, offset=1, color=rgb(128, 0, 128, 1))

/obj/item/rogueweapon/huntingknife/idagger/silver/attackby(obj/item/M, mob/user, params)
	if(istype(M,/obj/item/rogueore/cinnabar))
		var/crafttime = (6 SECONDS - ((user.get_skill_level(/datum/skill/magic/arcane))* 0.5 SECONDS))
		if(do_after(user, crafttime, target = src))
			playsound(loc, 'sound/magic/scrapeblade.ogg', 100, TRUE)
			to_chat(user, span_notice("I press arcyne magic into the blade and it throbs in a deep purple..."))
			var/obj/arcyne_knife = new /obj/item/rogueweapon/huntingknife/idagger/silver/arcyne
			qdel(M)
			qdel(src)
			user.put_in_active_hand(arcyne_knife)
	else
		return ..()

/obj/item/rogueweapon/huntingknife/idagger/silver/arcyne/attack_self(mob/living/carbon/human/user)
	if(!isarcyne(user) || HAS_TRAIT(user, TRAIT_ARCYNE_T1))
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
	var/runenameinput = input(user, "Runes", "T4 Runes") as null|anything in GLOB.t4rune_types

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

/obj/item/rope/chain/bindingshackles
	name = "planar binding shackles"
	desc = "arcane shackles imbued to bind other-planar creatures intelligence to this plane. They will not be under your thrall and a deal will need to be made."
	var/mob/living/fam
	var/tier = 1
	var/being_used = FALSE
	var/sentience_type = SENTIENCE_ORGANIC
	var/chosen_name
	var/binding = FALSE

/obj/item/rope/chain/bindingshackles/Initialize()
	. = ..()
	src.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))

/obj/item/rope/chain/bindingshackles/t2
	name = "greater planar binding shackles"
	tier = 2

/obj/item/rope/chain/bindingshackles/t3
	name = "woven planar binding shackles"
	tier = 3

/obj/item/rope/chain/bindingshackles/t4
	name = "confluent planar binding shackles"
	tier = 4

/obj/item/rope/chain/bindingshackles/t5
	name = "abberant planar binding shackles"
	tier = 5

/obj/item/rope/chain/bindingshackles/attack(mob/living/simple_animal/hostile/retaliate/rogue/captive, mob/living/user)
	var/list/summon_types = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp,
		/mob/living/simple_animal/hostile/retaliate/rogue/infernal/hellhound,
		/mob/living/simple_animal/hostile/retaliate/rogue/infernal/watcher,
		/mob/living/simple_animal/hostile/retaliate/rogue/infernal/fiend,
		/mob/living/simple_animal/hostile/retaliate/rogue/elemental/crawler,
		/mob/living/simple_animal/hostile/retaliate/rogue/elemental/warden,
		/mob/living/simple_animal/hostile/retaliate/rogue/elemental/behemoth,
		/mob/living/simple_animal/hostile/retaliate/rogue/elemental/colossus,
		/mob/living/simple_animal/hostile/retaliate/rogue/fae/sprite,
		/mob/living/simple_animal/hostile/retaliate/rogue/fae/glimmerwing,
		/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad,
		/mob/living/simple_animal/hostile/retaliate/rogue/fae/sylph,
		/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk,
		/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon)

	if(!(captive.type in summon_types))
		to_chat(user, span_warning("[captive] cannot be bound by these shackles!"))
		return
	if(captive.summon_tier > tier)
		to_chat(user, span_warning("[src] is not strong enough to bind [captive]!"))
		return

	var/mob/living/simple_animal/hostile/retaliate/rogue/target = captive
	target.visible_message(span_warning("[src] is trying to bind [target.real_name]"))
	if(do_after(user, 50, target = src) && binding == FALSE)
		if(!target.ckey) //player is not inside body or has refused, poll for candidates
			to_chat(user, span_notice("You attempt to bind the targetted summon to this plane."))
			binding = TRUE
			target.visible_message(span_warning("[target.real_name]'s body is entangled by glowing chains..."), runechat_message = TRUE)
			var/list/candidates = pollCandidatesForMob("Do you want to play as a Mage's summon?", null, null, null, 100, target, POLL_IGNORE_MAGE_SUMMON)

			// theres at least one candidate
			if(LAZYLEN(candidates))
				var/mob/C = pick(candidates)
				target.awaken_summon(user, C.ckey)
				target.visible_message(span_warning("[target.real_name]'s eyes light up with an intelligence as it awakens fully on this plane."), runechat_message = TRUE)
				custom_name(user,target)
				target.name = chosen_name
				binding = FALSE
			//no candidates, raise as npc
			else
				to_chat(user, span_notice("The [captive] stares at you with mindless hate. The binding attempt failed to draw out it's intelligence!"))
				binding = FALSE
		else
			target.visible_message(span_notice("This summon is already bound to this plane."))
			return FALSE
		return FALSE
	return FALSE

/mob/living/simple_animal/hostile/retaliate/rogue/proc/awaken_summon(mob/living/carbon/human/master, ckey)
	if(!master)
		return FALSE
	if(ckey) //player
		src.ckey = ckey

	to_chat(src, span_userdanger("My summoner is [master.real_name]. They will need to convince me to obey them."))
	to_chat(src, span_notice("[summon_primer]"))

	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE//easiest way to give mage summons proper darksight, although I'm wracking my brain for other angles since admin-spawned guys might happen

/obj/item/rope/chain/bindingshackles/proc/custom_name(mob/awakener, var/mob/chosen_one, iteration = 1)
	if(iteration > 5)
		return  // The spirit of indecision
	chosen_name = sanitize_name(stripped_input(chosen_one, "What are you named?"))
	if(!chosen_name) // with the way that sanitize_name works, it'll actually send the error message to the awakener as well.
		to_chat(awakener, span_warning("Your summon did not select a valid name! Please wait as they try again.")) // more verbose than what sanitize_name might pass in it's error message
		return custom_name(awakener, iteration++)
	return chosen_name
