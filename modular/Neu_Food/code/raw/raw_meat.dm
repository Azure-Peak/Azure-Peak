// Raw meat from land animals.
/obj/item/reagent_containers/food/snacks/rogue/meat
	eat_effect = /datum/status_effect/debuff/uncookedfood
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	name = "meat"
	icon = 'modular/Neu_Food/icons/raw/raw_meat.dmi'
	icon_state = "meatslab"
	slice_batch = TRUE // so it takes more time, changed from FALSE
	filling_color = "#8f433a"
	rotprocess = SHELFLIFE_SHORT
	chopping_sound = TRUE
	foodtype = MEAT
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	cooked_smell = /datum/pollutant/food/fried_meat
	var/fresh_meat = FALSE
	become_rot_type = /obj/item/reagent_containers/food/snacks/rogue/meat_rotten

/obj/item/reagent_containers/food/snacks/rogue/meat_rotten
	eat_effect = /datum/status_effect/debuff/rotfood
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	name = "rotten meat"
	desc = "This was once edible. It is now only a putrid mess, except to the most steadfast \
	of stomachs."
	icon = 'modular/Neu_Food/icons/raw/raw_meat.dmi'
	icon_state = "meat_rotten"

/obj/item/reagent_containers/food/snacks/rogue/meat_rotten/Initialize()
	. = ..()
	src.become_rotten(FALSE, FALSE)

/obj/item/reagent_containers/food/snacks/rogue/meat_rotten/can_craft_with()
	return TRUE

/obj/item/reagent_containers/food/snacks/rogue/meat/attackby(obj/item/I, mob/living/user)
	update_cooktime(user)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(I, /obj/item/kitchen/rollingpin))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Tenderizing [src] into a nitzel."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/nitzel(loc)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	else 
		return ..()

/* ............. Generic Steak ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/steak
	ingredient_size = 2
	name = "raw meat"
	icon_state = "meatsteak"
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried
	slices_num = 2
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef
	slice_bclass = BCLASS_CHOP

/obj/item/reagent_containers/food/snacks/rogue/meat/steak/get_mechanics_examine(mob/user)
    . = ..()
    . += span_info("Chopping raw meat on a table with a knife, cleaver, or dagger turns it into mince. Mince can be used for advanced recipes, or used to make 'more out of less' in a stew's broth.")
    . += span_info("Left-clicking a fire while holding a knife, dagger, or stake in your off-hand allows you to roast it. Roasting meat is quicker than cooking it, but has a higher chance of failure.")

/* ............. Pork (Fatty Sprite) ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/fatty //pork
	name = "raw pigflesh"
	icon_state = "pork"
	color = "#f093c3"
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/fatty/roast
	slices_num = 2
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/bacon
	chopping_sound = TRUE
	cooked_smell = /datum/pollutant/food/fried_meat

/* ............. Bacon ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/bacon
	name = "raw bacon"
	icon_state = "bacon"
	slice_path = null
	slices_num = 0
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried
	filling_color = "#8a0000"
	cooked_smell = /datum/pollutant/food/fried_bacon

/* ............. Spider Meat ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/spider // Low-nutrient, kind of gross. Survival food.
	name = "spidermeat"
	icon_state = "spidermeat"
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/spider/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/spider/fried
	slice_path = null
	slices_num = 0

/obj/item/reagent_containers/food/snacks/rogue/meat/spider/attackby(obj/item/I, mob/living/user)
	update_cooktime(user)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(I, /obj/item/kitchen/rollingpin))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Tenderizing [src] into a schnitzel."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/schnitzel(loc)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	else 
		return ..()

/* ............. Whole Bird ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry
	name = "plucked bird"
	icon_state = "halfchicken"
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked
	fried_type = null
	slices_num = 2
	slice_sound = TRUE
	ingredient_size = 4
	cooked_smell = /datum/pollutant/food/cooked_chicken

/* ............. Chicken Cutlet (Drumstick) ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet
	name = "bird meat"
	icon_state = "chickencutlet"
	ingredient_size = 2
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried
	slices_num = 1
	slice_bclass = BCLASS_CHOP
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/poultry
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried

/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/attackby(obj/item/I, mob/living/user)
	update_cooktime(user)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(I, /obj/item/kitchen/rollingpin))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Tenderizing [src]."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/chickentender(loc)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	else
		return ..()

/* ............. Crab Meat ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/crab
	name = "crab meat"
	desc = "A chunk of raw crab meat, absolutely wonderful."
	icon_state = "crabmeatraw"
	slice_path = null
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/crab/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/crab/fried
	slices_num = null
	ingredient_size = 1
	cooked_smell = /datum/pollutant/food/fried_crab

/obj/item/reagent_containers/food/snacks/rogue/meat/crab/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/butterdoughslice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, "<span class='notice'>Covering the crab with butterdough...</span>")
			if(do_after(user,short_cooktime, target = src))
				user.mind.add_sleep_experience(/datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/crabcakeraw(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put it on a table!"))
		return TRUE
	. = ..()

/* ............. Cabbit Meat ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit
	name = "raw cabbit meat"
	icon_state = "cabbitcutlet"
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/rabbit
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried
	slices_num = 1
	ingredient_size = 1

/* ............. Volf Meat ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf
	name = "raw volf meat"
	icon_state = "volfstrip"
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef		//Honestly, we don't need our own minced type on this one.
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried

/* ............. fish chop ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/fish
	name = "fish filet"
	desc = "A filet of fish. All of them are the same inside."
	icon_state = "fish_filet"
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried
	slices_num = 1
	ingredient_size = 1
	cooked_smell = /datum/pollutant/food/cooked_fish

/* .........   Shellfish    ................. */
/obj/item/reagent_containers/food/snacks/rogue/meat/shellfish
	name = "shellfish meat"
	desc = "Meat from a crustacean. Salty with a different texture than most fishmeat. Chop to create mince, bake or fry to make fried shellfish meat"
	icon_state = "shellfish_meat"
	rotprocess = SHELFLIFE_LONG
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish
	slices_num = 1
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/fried
	cooked_smell = /datum/pollutant/food/fried_shellfish

// MEAT MINCE
/*	.............   Minced meat & stuffing sausages   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/mince
	name = "mince"
	desc = "Meat sliced many times both with and against the grain, producing a fine mince."
	icon_state = "meatmince"
	ingredient_size = 2
	slice_path = null
	filling_color = "#8a0000"
	rotprocess = SHELFLIFE_TINY
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/mince/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	new /obj/effect/decal/cleanable/food/mess(get_turf(src))
	playsound(get_turf(src), 'modular/Neu_Food/sound/meatslap.ogg', 100, TRUE, -1)
	..()
	qdel(src)

/obj/item/reagent_containers/food/snacks/rogue/meat/mince/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/mince))
		if(isturf(loc)&& (found_table))
			to_chat(user, span_notice("Stuffing a wiener..."))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/meat/sausage(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work on it."))
	if(istype(I, /obj/item/reagent_containers/food/snacks/fat))
		if(isturf(loc)&& (found_table))
			to_chat(user, span_notice("Stuffing a wiener..."))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/meat/sausage(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work on it."))
	if(istype(I, /obj/item/reagent_containers/food/snacks/egg))
		if(isturf(loc)&& (found_table))
			to_chat(user, span_notice("Preparing a tartar..."))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/tartar(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work on it."))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef
	name = "minced meat"

/obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish
	name = "minced fish"
	icon_state = "fishmince"

/obj/item/reagent_containers/food/snacks/rogue/meat/mince/rabbit
	name = "minced cabbit"
	icon_state = "meatmince"

/obj/item/reagent_containers/food/snacks/rogue/meat/mince/poultry
	name = "minced poultry"
	icon_state = "meatmince"
	cooked_smell = /datum/pollutant/food/cooked_chicken

/obj/item/reagent_containers/food/snacks/rogue/meat/sausage
	name = "raw sausage"
	icon_state = "raw_sausage"
	ingredient_size = 1
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	cooked_smell = /datum/pollutant/food/fried_sausage

/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/attackby(obj/item/I, mob/living/user)
	update_cooktime(user)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(I, /obj/item/kitchen/rollingpin))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Tenderizing [src]."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/wienernitzel(loc)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to roll it out!"))
	else
		return ..()

/* ............. fish chop ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/fish
	name = "fish filet"
	desc = "A filet of fish. All of them are the same inside."
	icon_state = "fish_filet"
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried
	slices_num = 1
	ingredient_size = 1

/* .........   Shellfish    ................. */
/obj/item/reagent_containers/food/snacks/rogue/meat/shellfish
	name = "shellfish meat"
	desc = "Meat from a crustacean. Salty with a different texture than most fishmeat. Chop to create mince, bake or fry to make fried shellfish meat"
	icon_state = "shellfish_meat"
	rotprocess = SHELFLIFE_LONG
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish
	slices_num = 1
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/fried

/obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/fried
	eat_effect = null
	slices_num = 0
	name = "fried shellfish"
	desc = "Fried shellfish meat. A bit salty, but delicious."
	faretype = FARE_NEUTRAL
	icon_state = "shellfish_meat_cooked"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)

/* ............. Cabbit Meat ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit
	name = "raw cabbit meat"
	icon_state = "cabbitcutlet"
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/rabbit
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried
	slices_num = 1
	ingredient_size = 1

/* ............. Volf Meat ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf
	name = "raw volf meat"
	desc = "Meat taken from a volf. Stringy, tough, and gamey - but edible."
	icon_state = "volfstrip"
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef		//Honestly, we don't need our own minced type on this one.
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried

// Do NOT add this to the stockpile, they have other uses and are unique in how they're obtained.
/* ............. Gnoll Meat ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll
	name = "raw gnoll meat"
	desc = "Meat taken from a gnoll. Strangely it doesn't look like it was cut out of a creature. Somehow, it seems perfectly alive."
	icon_state = "gnoll"
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef		//Honestly, we don't need our own minced type on this one.
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll/seared
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll/seared
	rotprocess = SHELFLIFE_EXTREME
	sellprice = 118

/obj/item/reagent_containers/food/snacks/rogue/meat/steak/vilespawn
	name = "vilespawn flesh"
	desc = "Meat that can be used to bring forth some vile creature."
	icon_state = "vilespawn"
	slice_path = null
	fried_type = null
	cooked_type = null
	rotprocess = 0
	sellprice = 118

/obj/item/reagent_containers/food/snacks/rogue/meat/steak/vilespawn/attack_self(mob/living/user)
	to_chat(user, span_notice("You offer the [src.name] to the void, chanting for a host..."))
	var/list/candidates = pollGhostCandidates("Do you want to play as an Impure Gnoll? You'll be subservient to a master.", "Impure Gnoll", null, null, 10 SECONDS, "impure_gnoll")
	if(!LAZYLEN(candidates))
		to_chat(user, span_warning("The meat remains cold. No echoes of violence are hungry enough."))
		return

	var/mob/C = pick(candidates)
	var/mob/living/carbon/human/H = new(get_turf(user))
	H.key = C.key

	H.set_species(/datum/species/gnoll)
	var/datum/advclass/gnoll_impure/G = new()
	G.equipme(H)

	src.visible_message(span_warning("The [src.name] bloats and tears open as a gnoll claw bursts through!"))
	playsound(H.loc, 'sound/magic/slimesquish.ogg', 100, TRUE)
	qdel(C)
	qdel(src)

/obj/item/reagent_containers/food/snacks/rogue/meat/steak/vilespawn/admin
	name = "twisted vilespawn flesh"
	desc = "Transforms the user immediately into an Impure Gnoll."

/obj/item/reagent_containers/food/snacks/rogue/meat/steak/vilespawn/admin/attack_self(mob/living/carbon/human/user)
	if(!istype(user))
		to_chat(user, "You need to be a human to test this.")
		return

	to_chat(user, span_boldnotice("I feel dreadful!"))

	var/mob/living/carbon/human/H = new(get_turf(user))
	H.key = user.key

	H.set_species(/datum/species/gnoll)
	var/datum/advclass/gnoll_impure/C = new()
	C.equipme(H)

	user.visible_message(span_warning("The [src.name] melds into [user]'s flesh as they transform into an Impure Gnoll!"))
	playsound(user.loc, 'sound/magic/slimesquish.ogg', 100, TRUE)

	qdel(user)
	qdel(src)
