/obj/item/reagent_containers/food/snacks/grown
	icon = 'icons/roguetown/items/produce.dmi'
	dried_type = null
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_SMALL
	var/list/pipe_reagents = list()
	var/seed
	var/bitesize_mod = 0
	experimental_inhand = FALSE
	/// Type of splat to use. If null - produce is unsquashable.
	var/splat_type = null
	/// Color of the splat, applied when splat_type is spawned (after squashing).
	var/splat_color = null

/obj/item/reagent_containers/food/snacks/grown/Initialize(mapload)
	. = ..()
	if(!tastes)
		tastes = list("[name]" = 1)
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)

/obj/item/reagent_containers/food/snacks/grown/examine(mob/user)
	. = ..()
	. += span_smallnotice("Smash this with a blunt object to extract seeds from it.")

/obj/item/reagent_containers/food/snacks/grown/attackby(obj/item/weapon, mob/user, params)
	if(weapon && isturf(loc))
		var/turf/location = get_turf(src)
		if(seed && (user.used_intent.blade_class == BCLASS_BLUNT) && (!user.used_intent.noaa))
			playsound(src,'sound/items/seedextract.ogg', 100, FALSE)
			if(prob(5))
				user.visible_message(span_warning("[user] fails to extract the seeds."))
				qdel(src)
				return
			user.visible_message(span_info("[user] extracts the seeds."))
			new seed(location)
			if(prob(90))
				new seed(location)
			if(prob(23))
				new seed(location)
			if(prob(6))
				new seed(location)
			qdel(src)
			return
	return ..()

/obj/item/reagent_containers/food/snacks/grown/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(!QDELETED(src) && !QDELETED(hit_atom) && !isnull(splat_type))
		return squash(hit_atom, throwingdatum)

/// Squashing logic. Returns TRUE if food is squashed and qdeleted, FALSE - otherwise.
/obj/item/reagent_containers/food/snacks/grown/proc/squash(atom/movable/hit_atom, datum/thrownthing/throwingdatum)
	var/mob/living/thrower = throwingdatum?.thrower
	if(istype(thrower) && (thrower.STASTR < 9 && prob(40 + (20 - thrower.STASTR))))
		visible_message(span_warning("[src] bounces off [hit_atom]!"))
		return FALSE // If thrower is weaker than average, it bounces off with no effect just for the pun of it.

	var/turf/T = get_turf(src)
	if(istransparentturf(T))
		T = GET_TURF_BELOW(src)
	if(istype(hit_atom) && !(hit_atom.density && !(hit_atom?.pass_flags & LETPASSTHROW) && !(hit_atom?.flags_1 & ON_BORDER_1)))
		T = get_turf(hit_atom) // No splats under walls and dense atoms

	forceMove(T)
	if(ispath(splat_type, /obj/effect/decal/cleanable/food/plant_smudge))
		if(filling_color)
			var/atom/movable/spawned_splat = new splat_type(T)
			spawned_splat.color = splat_color
			spawned_splat.name = "[name] smudge"
	else if(splat_type)
		new splat_type(T)

	if(trash)
		generate_trash(T)

	visible_message(span_warning("[src] has been squashed."), null, span_hear("I hear a smack."))

	qdel(src)
	return TRUE

/obj/item/reagent_containers/food/snacks/grown/wheat
	seed = /obj/item/seeds/wheat
	name = "wheat grain"
	desc = ""
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "wheat"
	gender = PLURAL
	filling_color = "#F0E68C"
	bitesize_mod = 2
	foodtype = GRAIN
	tastes = list("wheat" = 1)
	grind_results = list(/datum/reagent/floure = 10)
	mill_result = /obj/item/reagent_containers/powder/flour

/obj/item/reagent_containers/food/snacks/grown/oat
	seed = /obj/item/seeds/wheat/oat
	name = "oat grain"
	desc = ""
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "oat"
	gender = PLURAL
	filling_color = "#556B2F"
	bitesize_mod = 2
	foodtype = GRAIN
	tastes = list("oat" = 1)
	grind_results = list(/datum/reagent/floure = 10)
	mill_result = /obj/item/reagent_containers/powder/flour

/obj/item/reagent_containers/food/snacks/grown/rice
	seed = /obj/item/seeds/rice
	name = "rice grain"
	desc = "Rice grains, ready to be worked with water to be cleaned."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "rice"
	gender = PLURAL
	filling_color = "#f0f0f0"
	bitesize_mod = 2
	foodtype = GRAIN
	tastes = list("rice" = 1)
	grind_results = list(/datum/reagent/floure = 10)
	mill_result = /obj/item/reagent_containers/powder/flour

/obj/item/reagent_containers/food/snacks/grown/apple
	seed = /obj/item/seeds/apple
	name = "apple"
	desc = ""
	icon_state = "apple"
	filling_color = "#FF4500"
	bitesize = 3
	foodtype = FRUIT
	tastes = list("apple" = 1)
	trash = /obj/item/trash/applecore
	faretype = FARE_POOR
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	slot_flags = ITEM_SLOT_HEAD
	worn_x_dimension = 64
	list_reagents = list(/datum/reagent/consumable/nutriment = 3)
	worn_y_dimension = 64
	rotprocess = SHELFLIFE_SHORT
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced
	slices_num = 3
	chopping_sound = TRUE
	var/equippedloc = null
	var/list/bitten_names = list()

/obj/item/reagent_containers/food/snacks/grown/apple/On_Consume(mob/living/eater)
	..()
	if(ishuman(eater))
		var/mob/living/carbon/human/H = eater
		if(!(H.real_name in bitten_names))
			bitten_names += H.real_name

/obj/item/reagent_containers/food/snacks/grown/apple/blockproj(mob/living/carbon/human/H)

	if(prob(98))
		H.visible_message(span_notice("[H] is saved by the apple!"))
		H.dropItemToGround(H.head)
		return 1
	else
		H.dropItemToGround(H.head)
		return 0

/obj/item/reagent_containers/food/snacks/grown/apple/equipped(mob/M)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.head == src)

			equippedloc = H.loc
			START_PROCESSING(SSobj, src)

/obj/item/reagent_containers/food/snacks/grown/apple/process()
	. = ..()
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.head == src)
			if(equippedloc != H.loc)
				H.dropItemToGround(H.head)

/obj/item/reagent_containers/food/snacks/grown/fruit
	name = "generic fruit"
	desc = "Uh oh, this shouldn't be here."
	bitesize = 2
	list_reagents = list(/datum/reagent/consumable/nutriment = 3)
	foodtype = FRUIT
	faretype = FARE_POOR
	rotprocess = SHELFLIFE_DECENT
	splat_type = /obj/effect/decal/cleanable/food/plant_smudge

/obj/item/reagent_containers/food/snacks/grown/fruit/pear
	name = "pear"
	seed = /obj/item/seeds/pear
	desc = "A juicy, bell-shaped fruit with a delicate sweetness and soft, grainy flesh."
	icon_state = "pear"
	tastes = list("pear" = 1)
	splat_color = "#D2B48C"

/obj/item/reagent_containers/food/snacks/grown/fruit/lemon
	name = "lemon"
	seed = /obj/item/seeds/lemon
	desc = "A bright yellow citrus fruit, prized for its tart, refreshing juice and fragrant zest."
	icon_state = "lemon"
	tastes = list("lemon" = 1)
	splat_color = "#FFFF00"

/obj/item/reagent_containers/food/snacks/grown/fruit/lime
	name = "lime"
	seed = /obj/item/seeds/lime
	desc = "A small, green citrus fruit with a sharp, tangy flavor, often used to add zest to dishes and drinks."
	icon_state = "lemon" // Need a real icon
	tastes = list("lime" = 1)
	splat_color = "#00FF00"

/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine
	name = "tangerine"
	seed = /obj/item/seeds/tangerine
	desc = "A small, easy-to-peel citrus fruit with a vibrant orange color and sweet, juicy segments."
	icon_state = "tangerine"
	tastes = list("tangerine" = 1)
	splat_color = "#FFA500"

/obj/item/reagent_containers/food/snacks/grown/fruit/plum
	name = "plum"
	seed = /obj/item/seeds/plum
	desc = "A smooth-skinned fruit with juicy, sweet-tart flesh and a deep purple or red hue."
	icon_state = "plum"
	tastes = list("plum" = 1)
	splat_color = "#8B008B"

/obj/item/reagent_containers/food/snacks/grown/fruit/strawberry
	name = "strawberry"
	seed = /obj/item/seeds/strawberry
	desc = "A small, red fruit with a sweet taste. It is often used in desserts."
	icon_state = "strawberry"
	tastes = list("strawberry" = 1)
	splat_color = "#9A1B00"

/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry
	name = "blackberry"
	seed = /obj/item/seeds/blackberry
	desc = "A small, dark fruit with a sweet and slightly tart taste. It is often used in desserts."
	icon_state = "blackberry"
	tastes = list("blackberry" = 1)
	splat_color = "#272C3F"

/obj/item/reagent_containers/food/snacks/grown/fruit/raspberry
	name = "raspberry"
	seed = /obj/item/seeds/raspberry
	desc = "A small, red fruit with a sweet and slightly tart taste. It is often used in desserts."
	icon_state = "raspberry"
	tastes = list("raspberry" = 1)
	splat_color = "#A01600"

/obj/item/reagent_containers/food/snacks/grown/fruit/tomato
	name = "tomato"
	seed = /obj/item/seeds/tomato
	desc = "A plump, red fruit with juicy flesh and a balanced sweet-tart flavor, essential in salads and sauces."
	icon_state = "tomato"
	tastes = list("tomato" = 1)
	splat_color = "#CD5320"

/obj/item/reagent_containers/food/snacks/grown/berries/rogue
	seed = /obj/item/seeds/berryrogue
	name = "jacksberries"
	desc = ""
	icon_state = "berries"
	tastes = list("berry" = 1)
	bitesize = 5
	list_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/water = 5)
	faretype = FARE_NEUTRAL
	dropshrink = 0.75
	var/color_index = "good"
	rotprocess = SHELFLIFE_SHORT

/obj/item/reagent_containers/food/snacks/grown/berries/rogue/examine(mob/user)
	. = ..()
	if(!user.get_client_color(/datum/client_colour/monochrome))
		. += span_notice("These berries have a <b>[BERRYCOLORS[filling_color]]</b> hue.")

/obj/item/reagent_containers/food/snacks/grown/berries/rogue/Initialize()
	if(GLOB.berrycolors[color_index])
		filling_color = GLOB.berrycolors[color_index]
	else
		var/newcolor = pick(BERRYCOLORS)
		if(newcolor in GLOB.berrycolors)
			GLOB.berrycolors[color_index] = pick(BERRYCOLORS)
		else
			GLOB.berrycolors[color_index] = newcolor
		filling_color = GLOB.berrycolors[color_index]
	update_icon()
	..()

/obj/item/reagent_containers/food/snacks/grown/berries/rogue/On_Consume(mob/living/eater)
	..()
	update_icon()

/obj/item/reagent_containers/food/snacks/grown/berries/rogue/update_icon()
	cut_overlays()
	var/used_state = "berriesc5"
	if(bitecount == 1)
		used_state = "berriesc4"
	if(bitecount == 2)
		used_state = "berriesc3"
	if(bitecount == 3)
		used_state = "berriesc2"
	if(bitecount == 4)
		used_state = "berriesc1"
	var/image/item_overlay = image(used_state)
	item_overlay.color = filling_color
	add_overlay(item_overlay)

/obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison
	seed = /obj/item/seeds/berryrogue/poison
	icon_state = "berries"
	tastes = list("berry" = 1)
	list_reagents = list(/datum/reagent/berrypoison = 5, /datum/reagent/consumable/nutriment = 3, /datum/reagent/water = 5)
	grind_results = list(/datum/reagent/berrypoison = 5)
	color_index = "bad"

/obj/item/reagent_containers/food/snacks/grown/nut
	name = "rocknut"
	desc = "A nut with mild stimulant properties. In powderized form, it can be used to make a zig."
	seed = /obj/item/seeds/nut
	icon_state = "rocknut"
	tastes = list("nutty" = 1)
	filling_color = "#6b4d18"
	bitesize = 1
	foodtype = FRUIT
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/acorn_powder = 4, /datum/reagent/drug/nicotine = 1)
	grind_results = list(/datum/reagent/consumable/acorn_powder = 4)
	mill_result = /obj/item/reagent_containers/powder/rocknut

/obj/item/reagent_containers/food/snacks/grown/sugarcane
	seed = /obj/item/seeds/sugarcane
	name = "sugarcane"
	desc = "A tall, leafy plant with a thick, fibrous stalk. It can be milled into sugar. Commonly eaten as a snack in part of the former Zhongese dynasty."
	icon_state = "sugarcane"
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/sugar = 5)
	dropshrink = 0.8
	rotprocess = null
	mill_result = /obj/item/reagent_containers/food/snacks/sugar

/obj/item/reagent_containers/food/snacks/sugar
	name = "sugar"
	desc = "Milled sugarcane, sweet as can be."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "salt"
	tastes = list("sweet" = 1)
	list_reagents = list(/datum/reagent/consumable/sugar = 15)

/obj/item/reagent_containers/food/snacks/grown/vegetable/turnip
	name = "turnip"
	desc = "A shield against hunger, naught else."
	seed = /obj/item/seeds/turnip
	icon_state = "turnip"
	tastes = list("dirt" = 1)
	bitesize = 1
	slices_num = 1
	slice_path = /obj/item/reagent_containers/food/snacks/veg/turnip_sliced
	foodtype = VEGETABLES
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	chopping_sound = TRUE
	dropshrink = 0.9
	rotprocess = SHELFLIFE_EXTREME

/*	..................   Sunflower   ................... */
/obj/item/reagent_containers/food/snacks/grown/sunflower
	name = "sunflower"
	desc = "A large, bright yellow flower. Can be worn on the head."
	icon_state = "sunflower"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	seed = /obj/item/seeds/sunflower
	slot_flags = ITEM_SLOT_HEAD
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = 0)
	dropshrink = 0.8
	rotprocess = null

//pyroclastic flowers - stonekeep port
/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius
	name = "fyritius flower"
	seed = /obj/item/seeds/fyritius
	desc = "A delicate orange flower that radiates warmth."
	icon_state = "fyritius"
	filling_color = "#ff5e00"
	tastes = list("tastes like a burning coal and fire" = 1)
	obj_flags = CAN_BE_HIT
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/toxin/fyritiusnectar = 5)
	grind_results = list(/datum/reagent/toxin/fyritiusnectar = 10)
	dropshrink = 0.8
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3

/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/attack(mob/living/carbon/human/M, mob/user)
	if(M == user)
		return ..() //Eat it
	if(user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
		return ..() //Make THEM eat it.
	if(!M.get_bleed_rate())
		to_chat(user, span_warning("There is no blood to wick into the flower bud."))
		return
	var/success = FALSE
	//Logic from funny_attack_effects
	var/datum/antagonist/werewolf/Were = M.mind.has_antag_datum(/datum/antagonist/werewolf/)
	var/datum/antagonist/vampire/Vamp = M.mind.has_antag_datum(/datum/antagonist/vampire/)
	if(Were && Were.transformed == TRUE)
		user.visible_message(span_notice("[user] brings [src] to soak up the ichor of [M]'s wounds."))
		if(do_after(user, 5 SECONDS, target = M))
			user.visible_message(span_notice("[user] draws the ichor of Dendor's Curse from [M]'s open wounds into [src]."), \
								 span_notice("I have captured the ferocity of Dendor's Curse inside [src]."))
			success = TRUE
	else if(Vamp)
		user.visible_message(span_notice("[user] brings [src] to soak up the petrified blood of [M]'s wounds."))
		if(do_after(user, 5 SECONDS, target = M))
			user.visible_message(span_notice("[user] captures the petrified blood from [M]'s open wounds into [src]."), \
								 span_notice("I have captured the quizzical properties of the petrified blood inside [src]."))
			success = TRUE
	else
		to_chat(user, span_warning("Their blood is not robust enough to hold to the warmth of [src]."))
	if(success)
		changefood(/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/bloodied, user)

/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(istype(I, /obj/item/inqarticles/indexer))
		var/obj/item/inqarticles/indexer/IND = I
		var/success
		if(HAS_TRAIT(user, TRAIT_INQUISITION))
			if(IND.cursedblood)
				if(alert(user, "DRENCH THE FYRITIUS?", "CURSED BLOOD", "YES", "NO") != "NO")
					success = TRUE
					IND.fullreset(user)
				else
					return
				if(success)
					changefood(/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/bloodied, user)


/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/bloodied
	name = "bloodied fyritius flower"
	desc = "A once delicate orange flower, now soaked with gruesome accursed blood that slowly burns it away."
	icon_state = "fyritius_blood"
	filling_color = "#ff3300"
	tastes = list("tastes like a burning coal and fire and blood" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/toxin/fyritiusnectar = 5)
	rotprocess = SHELFLIFE_SHORT

/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/bloodied/become_rotten()
	visible_message(span_danger("[src] burns into ash!"))
	new /obj/item/ash(get_turf(src))
	qdel(src)
	return TRUE

/obj/item/reagent_containers/food/snacks/grown/rogue/swampweed
	seed = /obj/item/seeds/swampweed
	name = "swampweed"
	desc = "A pipeweed with pungent odor and a sparkling surface."
	icon_state = "swampweed"
	filling_color = "#008000"
	bitesize_mod = 1
	foodtype = VEGETABLES
	list_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/berrypoison = 5)
	tastes = list("sweet" = 1,"bitterness" = 1)
	eat_effect = /datum/status_effect/debuff/badmeal
	rotprocess = SHELFLIFE_SHORT

/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed
	seed = /obj/item/seeds/pipeweed
	name = "westleach leaf"
	desc = "A pipeweed prized for its rich flavor."
	icon_state = "westleach"
	filling_color = "#008000"
	bitesize_mod = 1
	foodtype = VEGETABLES
	tastes = list("sweet" = 1,"bitterness" = 1)
	list_reagents = list(/datum/reagent/drug/nicotine = 2, /datum/reagent/consumable/nutriment = 1, /datum/reagent/berrypoison = 5)
	grind_results = list(/datum/reagent/drug/nicotine = 5)
	eat_effect = /datum/status_effect/debuff/badmeal
	rotprocess = SHELFLIFE_SHORT

/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry
	seed = null
	name = "westleach leaf"
	desc = "A dried pipeweed, ready to smoke."
	icon_state = "westleachd"
	dry = TRUE
	pipe_reagents = list(/datum/reagent/drug/nicotine = 30)
	eat_effect = /datum/status_effect/debuff/badmeal
	list_reagents = list(/datum/reagent/drug/nicotine = 5, /datum/reagent/consumable/nutriment = 1)
	grind_results = list(/datum/reagent/drug/nicotine = 10)

/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/sigdry,
		/datum/crafting_recipe/roguetown/survival/sigdry/cheroot,
		/datum/crafting_recipe/roguetown/survival/sigsweet/cheroot,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry
	seed = null
	name = "swampweed"
	desc = "A prepared pipeweed prized for its foggy effects."
	icon_state = "swampweedd"
	dry = TRUE
	pipe_reagents = list(/datum/reagent/drug/space_drugs = 30)
	list_reagents = list(/datum/reagent/drug/space_drugs = 2,/datum/reagent/consumable/nutriment = 1)
	grind_results = list(/datum/reagent/drug/space_drugs = 5)
	eat_effect = /datum/status_effect/debuff/badmeal

/obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/sigsweet,
		/datum/crafting_recipe/roguetown/survival/sigsweet/cheroot,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/reagent_containers/food/snacks/grown/onion/rogue
	name = "onion"
	desc = "A wonderful vegetable with many layers and broad flavor profile."
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced
	chopping_sound = TRUE
	dropshrink = 0.8
	icon_state = "onion"
	slices_num = 2
	tastes = list("spicy sweetness" = 1)
	bitesize = 2
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	rotprocess = null
	seed = /obj/item/seeds/onion

/obj/item/reagent_containers/food/snacks/grown/cabbage/rogue
	name = "cabbage"
	desc = "A dense leafed vegetable, crunchy and ripe. A symbol of prosperity for elves."
	icon_state = "cabbage"
	tastes = list("blandness" = 1)
	bitesize = 10
	list_reagents = list(/datum/reagent/consumable/nutriment = 5)
	slices_num = 3
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced
	chopping_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	seed = /obj/item/seeds/cabbage

/obj/item/reagent_containers/food/snacks/grown/potato/rogue
	name = "potato"
	desc = "A spud, dwarven icon of growth. Can be eaten raw."
	icon_state = "potato"
	eat_effect = null
	tastes = list("potato" = 1)
	bitesize = 2
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	slices_num = 2
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/veg/potato_sliced
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/potato_baked
	chopping_sound = TRUE
	rotprocess = null
	seed = /obj/item/seeds/potato

/obj/item/reagent_containers/food/snacks/grown/garlick/rogue
	name = "garlick bulb"
	desc = "Hated by the foule vampyres that lurk in the dark. Garlick."
	icon_state = "garlick"
	slices_num = 5
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove
	eat_effect = null
	tastes = list("pungent umami" = 1)
	bitesize = 2
	list_reagents = list(/datum/reagent/consumable/nutriment = 1) //add a reagent that harms vampires later
	rotprocess = null
	chopping_sound = TRUE
	seed = /obj/item/seeds/garlick

// poppies, from vanderlin
/obj/item/reagent_containers/food/snacks/grown/rogue/poppy
	name = "poppy"
	desc = "For their crimson beauty and the sedating effect of their crushed seeds, these flowers are considered a symbol of Eora."
	icon_state = "poppy"
	seed = /obj/item/seeds/poppy
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = 0)
	dropshrink = 0.5
	rotprocess = null

/obj/item/reagent_containers/food/snacks/grown/coffee
	name = "coffee cherry"
	desc = "A small sweet, small red fruit that contains coffee bean(s) inside. Can be grounded in a millstone for coffee beans."
	icon_state = "coffee"
	seed = /obj/item/seeds/coffee
	tastes = list("hibicus sweetness" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	mill_result = /obj/item/reagent_containers/food/snacks/grown/coffeebeans
	rotprocess = null

/obj/item/reagent_containers/food/snacks/grown/tea
	name = "tea leaves"
	desc = "Tea leaves plucked from the plant. It is still fresh and needs to be dried before use."
	icon_state = "tea"
	seed = /obj/item/seeds/tea
	tastes = list("grass" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	rotprocess = null

/obj/item/reagent_containers/food/snacks/grown/carrot
	name = "carrot"
	desc = "A long vegetable said to help with eyesight. Often baked"
	icon_state = "carrot"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked
	tastes = list("carrot" = 1)
	dropshrink = 0.75

/*	..................   Cucumber   ................... */
/obj/item/reagent_containers/food/snacks/grown/cucumber
	name = "cucumber"
	desc = "A long, green vegetable that is crunchy and refreshing. Can be sliced for easier consumption."
	icon_state = "cucumber"
	dropshrink = 0.75
	slices_num = 2
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/veg/cucumber_sliced
	tastes = list("cucumber" = 1)
	chopping_sound = TRUE

/obj/item/reagent_containers/food/snacks/grown/eggplant
	name = "eggplant"
	desc = "A large, purple vegetable with a mild taste. Can be carved to be filled up."
	icon_state = "eggplant"
	slices_num = 1
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/eggplantcarved
	slice_sound = TRUE
