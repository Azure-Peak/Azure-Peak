/obj/item/natural/fibers
	name = "fibers"
	icon_state = "fibers"
	possible_item_intents = list(/datum/intent/use)
	desc = "Plant fibers. Peasants make their living turning these into clothing."
	force = 0
	throwforce = 0
	obj_flags = null
	color = "#575e4a"
	bundling_time = 1 SECONDS
	firefuel = 5 MINUTES
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20
	muteinmouth = TRUE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	experimental_inhand = FALSE
	sellprice = 2
	bundletype = /obj/item/natural/bundle/fibers

/obj/item/natural/fibers/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/stonehoe,
		/datum/crafting_recipe/roguetown/survival/woodhammer,
		/datum/crafting_recipe/roguetown/survival/tneedle,
		/datum/crafting_recipe/roguetown/survival/recurvepartial,
		/datum/crafting_recipe/roguetown/survival/longbowpartial,
		/datum/crafting_recipe/roguetown/survival/wickercloak,
		/datum/crafting_recipe/roguetown/survival/torch,
		/datum/crafting_recipe/roguetown/survival/woodhammer,
		/datum/crafting_recipe/roguetown/survival/stonehoe,
		/datum/crafting_recipe/roguetown/survival/stonesword,
		/datum/crafting_recipe/roguetown/survival/woodsword,
		/datum/crafting_recipe/roguetown/survival/bag,
		/datum/crafting_recipe/roguetown/survival/rod,
		/datum/crafting_recipe/roguetown/survival/pearlcross,
		/datum/crafting_recipe/roguetown/survival/bpearlcross,
		/datum/crafting_recipe/roguetown/survival/shellnecklace,
		/datum/crafting_recipe/roguetown/survival/shellbracelet,
		/datum/crafting_recipe/roguetown/survival/abyssoramulet,
		/datum/crafting_recipe/roguetown/survival/broom,
		/datum/crafting_recipe/roguetown/survival/woodcross,
		/datum/crafting_recipe/roguetown/survival/tribalrags,
		/datum/crafting_recipe/roguetown/survival/skullmask,
		/datum/crafting_recipe/roguetown/survival/bonespear,
		/datum/crafting_recipe/roguetown/survival/boneaxe,
		/datum/crafting_recipe/roguetown/survival/goodluckcharm,
		/datum/crafting_recipe/roguetown/survival/bouquet_rosa,
		/datum/crafting_recipe/roguetown/survival/bouquet_salvia,
		/datum/crafting_recipe/roguetown/survival/bouquet_matricaria,
		/datum/crafting_recipe/roguetown/survival/bouquet_calendula,
		/datum/crafting_recipe/roguetown/survival/flowercrown_rosa,
		/datum/crafting_recipe/roguetown/survival/flowercrown_salvia,
		/datum/crafting_recipe/roguetown/survival/slingpouchcraft,
		/datum/crafting_recipe/roguetown/survival/oar,
		/datum/crafting_recipe/roguetown/survival/boat,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/natural/fibers/attack_right(mob/user)
	if(user.get_active_held_item())
		return
	var/is_legendary = FALSE
	if(user.get_skill_level(/datum/skill/labor/farming) == SKILL_LEVEL_LEGENDARY) //check if the user has legendary farming skill
		is_legendary = TRUE //they do
	if(is_legendary)
		bundling_time = 2 //if legendary skill, the move_after is fast, 0.2 seconds
	to_chat(user, span_warning("I start to collect [src]..."))
	if(move_after(user, bundling_time, target = src))
		var/fibercount = 0
		for(var/obj/item/natural/fibers/F in get_turf(src))
			fibercount++
		while(fibercount > 0)
			if(fibercount == 1)
				new /obj/item/natural/fibers(get_turf(user))
				fibercount--
			else if(fibercount >= 2)
				var/obj/item/natural/bundle/fibers/B = new(get_turf(user))
				B.amount = clamp(fibercount, 2, 6)
				B.update_bundle()
				fibercount -= clamp(fibercount, 2, 6)
				user.put_in_hands(B)
		for(var/obj/item/natural/fibers/F in get_turf(src))
			qdel(F)

/obj/item/natural/silk
	name = "silk"
	icon_state = "fibers"
	possible_item_intents = list(/datum/intent/use)
	desc = "Strands of spider silk. Clothing made with this is considered exotic in all places but the Underdark."
	force = 0
	throwforce = 0
	obj_flags = null
	color = "#e6e3db"
	bundling_time = 1 SECONDS
	firefuel = 5 MINUTES
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20
	muteinmouth = TRUE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	experimental_inhand = FALSE
	bundletype = /obj/item/natural/bundle/silk

/obj/item/natural/silk/attack_right(mob/user)
	to_chat(user, span_warning("I start to collect [src]..."))
	if(move_after(user, bundling_time, target = src))
		var/silkcount = 0
		for(var/obj/item/natural/silk/F in get_turf(src))
			silkcount++
		while(silkcount > 0)
			if(silkcount == 1)
				new /obj/item/natural/silk(get_turf(user))
				silkcount--
			else if(silkcount >= 2)
				var/obj/item/natural/bundle/silk/B = new(get_turf(user))
				B.amount = clamp(silkcount, 2, 6)
				B.update_bundle()
				silkcount -= clamp(silkcount, 2, 6)
		for(var/obj/item/natural/silk/F in get_turf(src))
			qdel(F)

#ifdef TESTSERVER

/client/verb/bloodnda()
	set category = "DEBUGTEST"
	set name = "bloodnda"
	set desc = ""

	var/obj/item/I
	I = mob.get_active_held_item()
	if(I)
		if(I.return_blood_DNA())

		else


#endif

/obj/item/natural/cloth
	name = "cloth"
	icon_state = "cloth"
	possible_item_intents = list(/datum/intent/use)
	desc = "A bolt of woven fibers. Useful as bandages and in dozens upon dozens of crafts."
	force = 0
	throwforce = 0
	obj_flags = null
	bundling_time = 2 SECONDS
	firefuel = 5 MINUTES
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH|ITEM_SLOT_HIP
	body_parts_covered = null
	experimental_onhip = FALSE //rip
	max_integrity = 20
	muteinmouth = TRUE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	experimental_inhand = FALSE
	bundletype = /obj/item/natural/bundle/cloth
	sellprice = 4
	detail_tag = "_soaked"
	var/wet = 0
	/// Effectiveness when used as a bandage, how much it'll lower the bloodloss, bloodloss will get multiplied by this.
	var/bandage_effectiveness = 0.5
	var/bandage_speed = 7 SECONDS
	///How much you can bleed into the bandage until it needs to be changed
	var/bandage_health = 150 //75 total blood stopped
	//bandage_health * (1 - bandage_effectiveness) = total amount of blood saved from one bandage
	/// If the bandage is soaked in some kind of medicine.
	var/medicine_quality
	var/medicine_amount = 0

/obj/item/natural/cloth/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/longbowpartial,
		/datum/crafting_recipe/roguetown/survival/bag,
		/datum/crafting_recipe/roguetown/survival/book_crafting_kit,
		/datum/crafting_recipe/roguetown/survival/slingpouchcraft,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/natural/cloth/attack_right(mob/user)
	if(user.get_active_held_item())
		return
	to_chat(user, span_warning("I start to collect [src]..."))
	if(move_after(user, bundling_time, target = src))
		var/clothcount = 0
		for(var/obj/item/natural/cloth/F in get_turf(src))
			clothcount++
		while(clothcount > 0)
			if(clothcount == 1)
				new /obj/item/natural/cloth(get_turf(user))
				clothcount--
			else if(clothcount >= 2)
				var/obj/item/natural/bundle/cloth/B = new(get_turf(user))
				B.amount = clamp(clothcount, 2, 10)
				B.update_bundle()
				clothcount -= clamp(clothcount, 2, 10)
				user.put_in_hands(B)
		for(var/obj/item/natural/cloth/F in get_turf(src))
			playsound(user, "rustle", 70, FALSE, -4)
			qdel(F)

/obj/item/natural/cloth/examine(mob/user)
	. = ..()
	if(wet)
		. += span_notice("It's wet!")

// CLEANING

/obj/item/natural/cloth/attack_obj(obj/O, mob/living/user)

	if(user.client && ((O in user.client.screen) && !user.is_holding(O)))
		to_chat(user, span_warning("I need to take that [O.name] off before cleaning it!"))
		return
	if(istype(O, /obj/effect/decal/cleanable))
		var/cleanme = TRUE
		if(istype(O, /obj/effect/decal/cleanable/blood))
			if(!wet)
				cleanme = FALSE
			add_blood_DNA(O.return_blood_DNA())
		if(prob(33 + (wet*10)) && cleanme)
			wet = max(wet-1, 0)
			user.visible_message(span_info("[user] wipes \the [O.name] with [src]."), span_info("I wipe \the [O.name] with [src]."))
			qdel(O)
		playsound(user, "clothwipe", 100, TRUE)
	else
		if(prob(30 + (wet*10)))
			user.visible_message(span_info("[user] wipes \the [O.name] with [src]."), span_info("I wipe \the [O.name] with [src]."))

			if(O.return_blood_DNA())
				add_blood_DNA(O.return_blood_DNA())
			for(var/obj/effect/decal/cleanable/C in O)
				qdel(C)
			if(!wet)
				SEND_SIGNAL(O, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_WEAK)
			else
				SEND_SIGNAL(O, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_STRONG)
			wet = max(wet-1, 0)
		playsound(user, "clothwipe", 100, TRUE)

/obj/item/natural/cloth/attack_turf(turf/T, mob/living/user)
	if(istype(T, /turf/open/water))
		return ..()
	if(prob(30 + (wet*10)))
		user.visible_message(span_info("[user] wipes \the [T.name] with [src]."), span_info("I wipe \the [T.name] with [src]."))
		if(wet)
			for(var/obj/effect/decal/cleanable/C in T)
				qdel(C)
			wet = max(wet-1, 0)
	playsound(user, "clothwipe", 100, TRUE)


// BANDAGING
/obj/item/natural/cloth/attack(mob/living/M, mob/user)

	bandage(M, user)

/obj/item/natural/cloth/wash_act()
	. = ..()
	wet = 10
	bandage_health = initial(bandage_health)
	medicine_amount = 0
	medicine_quality = 0
	detail_color = null
	desc = initial(desc)
	update_icon()

/obj/item/natural/cloth/attackby(obj/item/I, mob/living/user, params)
	var/obj/item/reagent_containers/C = I
	if(!istype(C))
		return ..()
	if(C.reagents.has_reagent(/datum/reagent/medicine/healthpot, 10) && !medicine_amount)
		to_chat(user, span_notice("You start soaking the [src] in lyfeblood..."))
		if(do_after(user, 3 SECONDS, target = src))
			C.reagents.remove_reagent(/datum/reagent/medicine/healthpot, 10)
			medicine_quality = 1
			medicine_amount += 10
			desc += " It has been soaked in lyfeblood."
			detail_color = "#ff0000"
			update_icon()
	if(C.reagents.has_reagent(/datum/reagent/medicine/stronghealth, 10) && !medicine_amount)
		to_chat(user, span_notice("You start soaking the [src] in strong lyfeblood..."))
		if(do_after(user, 3 SECONDS, target = src))
			C.reagents.remove_reagent(/datum/reagent/medicine/stronghealth, 10)
			medicine_quality = 2
			medicine_amount += 10
			desc += " It has been soaked in strong lyfeblood."
			detail_color = "#820000"
			update_icon()
	if(C.reagents.has_reagent(/datum/reagent/consumable/ethanol/aqua_vitae, 10) && !medicine_amount)
		to_chat(user, span_notice("You start soaking the [src] in aqua vitae..."))
		if(do_after(user, 3 SECONDS, target = src))
			C.reagents.remove_reagent(/datum/reagent/consumable/ethanol/aqua_vitae, 10)
			medicine_quality = 0.5 //slower than health potions, more healing overall. Good for fractures or other big wounds.
			medicine_amount += 60
			desc += " It has been soaked in aqua vitae."
			detail_color = "#6e6e6e"
			update_icon()
	if(C.reagents.has_reagent(/datum/reagent/water/blessed, 10) && !medicine_amount)
		to_chat(user, span_notice("You start soaking the [src] in blessed water..."))
		if(do_after(user, 3 SECONDS, target = src))
			C.reagents.remove_reagent(/datum/reagent/water/blessed, 10)
			medicine_quality = 0.2 //cheap, easy to get, doesn't even heal wounds if it's not on a bandage
			medicine_amount += 20
			desc += " It has been soaked in blessed water."
			detail_color = "#6a9295"
			update_icon()

/obj/item/natural/cloth/update_icon()
	cut_overlays()
	if(medicine_amount > 0)
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/natural/cloth/proc/bandage(mob/living/M, mob/user)
	var/used_time = bandage_speed
	var/medskill = 0

	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		medskill = human_user.get_skill_level(/datum/skill/misc/medicine)
		used_time -= ((medskill * 10) + (human_user.STASPD / 2)) //With 20 SPD you can insta bandage at max medicine.

	if(istype(M, /mob/living/simple_animal))
		var/mob/living/simple_animal/animal_patient = M
		if(!animal_patient.bruteloss)
			to_chat(user, span_warning("[animal_patient] doesn't need bandaging right now."))
			return
		playsound(loc, 'sound/foley/bandage.ogg', 100, FALSE)
		if(!move_after(user, used_time, target = animal_patient))
			return
		playsound(loc, 'sound/foley/bandage.ogg', 100, FALSE)
		animal_patient.adjustHealth(-((animal_patient.maxHealth / 5) * (medskill + 1)), TRUE)
		user.visible_message(span_notice("[user] bandages [M]'s wounds."), span_notice("I bandage [M]'s wounds."))
		// clear all the wounds
		for(var/datum/wound/wound as anything in animal_patient.get_wounds())
			qdel(wound)
		qdel(src)
		return

	if(!M.can_inject(user, TRUE))
		return

	if(!ishuman(M))
		return

	var/mob/living/carbon/human/H = M
	var/obj/item/bodypart/affecting = H.get_bodypart(check_zone(user.zone_selected))
	if(!affecting)
		return
	if(affecting.bandage)
		to_chat(user, span_warning("There is already a bandage."))
		return

	playsound(loc, 'sound/foley/bandage.ogg', 100, FALSE)
	if(!move_after(user, used_time, target = M))
		return
	playsound(loc, 'sound/foley/bandage.ogg', 100, FALSE)

	user.dropItemToGround(src)
	affecting.try_bandage(src)
	H.update_damage_overlays()

	if(M == user)
		user.visible_message(span_notice("[user] bandages [user.p_their()] [affecting]."), span_notice("I bandage my [affecting.name]."))
	else
		user.visible_message(span_notice("[user] bandages [M]'s [affecting]."), span_notice("I bandage [M]'s [affecting.name]."))

/obj/item/natural/thorn
	name = "thorn"
	icon_state = "thorn"
	desc = "The sharp and pointy growth of many a bush. It's somewhat shaped like a needle."
	force = 10
	throwforce = 0
	possible_item_intents = list(/datum/intent/stab)
	firefuel = 5 MINUTES
	embedding = list("embedded_unsafe_removal_time" = 20, "embedded_pain_chance" = 10, "embedded_pain_multiplier" = 1, "embed_chance" = 35, "embedded_fall_chance" = 0)
	resistance_flags = FLAMMABLE
	max_integrity = 20

/obj/item/natural/thorn/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/tneedle,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/natural/thorn/attack_self(mob/living/user)
	user.visible_message(span_warning("[user] snaps [src]."))
	playsound(user,'sound/items/seedextract.ogg', 100, FALSE)
	qdel(src)

/obj/item/natural/thorn/Crossed(mob/living/L)
	. = ..()
	if(istype(L))
		var/prob2break = 33
		if(L.m_intent == MOVE_INTENT_SNEAK)
			prob2break = 0
		if(L.m_intent == MOVE_INTENT_RUN)
			prob2break = 100
		if(prob(prob2break))
			if(!(HAS_TRAIT(L, TRAIT_AZURENATIVE) || (HAS_TRAIT(L, TRAIT_WOODWALKER)) && L.m_intent != MOVE_INTENT_RUN))
				playsound(src,'sound/items/seedextract.ogg', 100, FALSE)
			qdel(src)
			if (L.alpha == 0 && L.rogue_sneaking) // not anymore you're not
				L.update_sneak_invis(TRUE)
			if(!HAS_TRAIT(L, TRAIT_WOODWALKER))
				L.consider_ambush()

/obj/item/natural/bundle/fibers
	name = "fiber bundle"
	icon_state = "fibersroll1"
	possible_item_intents = list(/datum/intent/use)
	desc = "Numerous plant fibers are bundled together in a tight coil."
	force = 0
	throwforce = 0
	maxamount = 6
	obj_flags = null
	color = "#575e4a"
	firefuel = 5 MINUTES
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20
	muteinmouth = TRUE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	experimental_inhand = FALSE
	stacktype = /obj/item/natural/fibers
	icon1step = 3
	icon2step = 6
	grid_width = 32
	grid_height = 32

/obj/item/natural/bundle/fibers/full
	icon_state = "fibersroll2"
	amount = 6
	firefuel = 30 MINUTES
	grid_width = 64

/obj/item/natural/bundle/silk
	name = "silken weave"
	icon_state = "fibersroll1"
	possible_item_intents = list(/datum/intent/use)
	desc = "Multiple lengths of spider silk have been tied neatly together into a tight coil."
	force = 0
	throwforce = 0
	maxamount = 6
	obj_flags = null
	color = "#e6e3db"
	firefuel = 5 MINUTES
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20
	muteinmouth = TRUE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	stacktype = /obj/item/natural/silk
	icon1step = 3
	icon2step = 6

/obj/item/natural/bundle/cloth
	name = "bundle of cloth"
	icon_state = "clothroll1"
	possible_item_intents = list(/datum/intent/use)
	desc = "Multiple bolts of fabric have been rolled up together for easier transport."
	force = 0
	throwforce = 0
	maxamount = 10
	obj_flags = null
	firefuel = 5 MINUTES
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	experimental_inhand = FALSE
	stacktype = /obj/item/natural/cloth
	stackname = "cloth"
	icon1 = "clothroll1"
	icon1step = 5
	icon2 = "clothroll2"
	icon2step = 10
	grid_width = 32
	grid_height = 32

/obj/item/natural/bundle/stick
	name = "bundle of sticks"
	icon_state = "stickbundle1"
	possible_item_intents = list(/datum/intent/use)
	desc = "Stick alone: Weak. Stick together: Strong."
	maxamount = 10
	force = 0
	throwforce = 0
	obj_flags = null
	firefuel = 5 MINUTES
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	experimental_inhand = FALSE
	stacktype = /obj/item/grown/log/tree/stick
	stackname = "sticks"
	icon1 = "stickbundle1"
	icon1step = 4
	icon2 = "stickbundle2"
	icon2step = 7
	icon3 = "stickbundle3"

/obj/item/natural/bundle/stick/attackby(obj/item/W, mob/living/user)
	. = ..()
	user.changeNext_move(CLICK_CD_MELEE)
	if(user.used_intent?.blade_class == BCLASS_CUT)
		playsound(get_turf(src.loc), 'sound/items/wood_sharpen.ogg', 100)
		user.visible_message(span_info("[user] starts sharpening the sticks in [src]..."), span_info("I start sharpening the sticks in [src]...."))
		for(var/i in 1 to (amount - 1))
			if(!do_after(user, 20))
				break
			var/turf/T = get_turf(user.loc)
			var/obj/item/grown/log/tree/stake/S = new /obj/item/grown/log/tree/stake(T)
			amount--
			// If there's only one stick left in the bundle...
			if (amount == 1)
				// Replace the bundle with a single stick
				var/obj/item/ST = new stacktype(T)
				if(user.is_holding(src))
					user.doUnEquip(src, TRUE, T, silent = TRUE)
				qdel(src)
				var/holding = user.put_in_hands(ST)
				// And automatically have us try and carve the last new stick, assuming we're still holding it!
				if(!do_after(user, 20))
					break
				S = new /obj/item/grown/log/tree/stake(T)
				if(holding)
					user.doUnEquip(ST, TRUE, T, silent = TRUE)
				qdel(ST)
			else
				update_bundle()
			user.put_in_hands(S)
			S.pixel_x = rand(-3, 3)
			S.pixel_y = rand(-3, 3)
		return

/obj/item/natural/bundle/bone
	name = "stack of bones"
	icon_state = "bonestack1"
	possible_item_intents = list(/datum/intent/use)
	desc = "These remains of the dead have been bundled together."
	force = 0
	throwforce = 0
	maxamount = 6
	obj_flags = null
	color = null
	firefuel = null
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20
	muteinmouth = TRUE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	experimental_inhand = FALSE
	stacktype = /obj/item/natural/bone
	stackname = "bones"
	icon1 = "bonestack1"
	icon2 = "bonestack2"

/obj/item/natural/bundle/bone/full
	amount = 6

/*/obj/item/natural/bone/attackby(obj/item/I, mob/living/user, params)
	var/mob/living/carbon/human/H = user
	user.changeNext_move(CLICK_CD_MELEE)
	if(istype(I, /obj/item/natural/bone))
		var/obj/item/natural/bundle/bone/F = new(src.loc)
		H.put_in_hands(F)
		H.visible_message("[user] ties the bones into a bundle.")
		qdel(I)
		qdel(src)
	if(istype(I, /obj/item/natural/bundle/bone))
		var/obj/item/natural/bundle/bone/B = I
		if(B.amount < B.maxamount)
			H.visible_message("[user] adds the [src] to the bundle.")
			B.amount += 1
			B.update_bundle()
			qdel(src)
	..()*/

/obj/item/natural/bowstring
	name = "fibre bowstring"
	desc = "Wax-fed fibrous thread has been spun and dressed into a continuous loop."
	icon_state = "fibers"
	possible_item_intents = list(/datum/intent/use)
	force = 0
	throwforce = 0
	obj_flags = null
	color = COLOR_BEIGE
	firefuel = 5 MINUTES
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20
	muteinmouth = TRUE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	experimental_inhand = FALSE

/obj/item/natural/bowstring/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/bow,
		/datum/crafting_recipe/roguetown/survival/recurvebow,
		/datum/crafting_recipe/roguetown/survival/longbow,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/natural/bundle/worms
	name = "worms"
	desc = "Multiple tiny creatures of the earth squirm and writhe together in a small pile."
	color = "#964B00"
	maxamount = 12
	icon_state = "worm2"
	icon1 = "worm2"
	icon1step = 6
	icon2 = "worm4"
	icon2step = 12
	icon3 = "worm6"
	stacktype = /obj/item/natural/worms
	stackname = "worms"
	bundling_time = 1 SECONDS

/obj/item/natural/worms/attack_right(mob/user)
	to_chat(user, span_warning("I start to collect [src]..."))
	if(move_after(user, bundling_time, target = src))
		var/wormcount = 0
		for(var/obj/item/natural/worms/F in get_turf(src))
			wormcount++
		while(wormcount > 0)
			if(wormcount == 1)
				new /obj/item/natural/worms(user.drop_location())
				wormcount--
			else if(wormcount >= 2)
				var/obj/item/natural/bundle/worms/B = new(user.drop_location())
				B.amount = clamp(wormcount, 2, 12)
				B.update_bundle()
				wormcount -= clamp(wormcount, 2, 12)
				user.put_in_hands(B)
		for(var/obj/item/natural/worms/F in get_turf(src))
			qdel(F)


