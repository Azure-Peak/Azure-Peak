
// Raw Shellfish. Separate folder due to sprites
/obj/item/reagent_containers/food/snacks/fish/crab
	name = "crab"
	desc = "A defensive shellfish that's a real hassle to crack open, they taste great when made into cakes with butterdough slice."
	icon_state = "crab"
	sellprice = 10
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/crab
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/crab
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/crab
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
		return TRUE
	. = ..()

/obj/item/reagent_containers/food/snacks/fish/clam
	name = "clam"
	desc = "A beastye built by Abyssor in the image of a knight. Hard shell, squishy interior."
	icon_state = "clam"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	sellprice = 15
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/clam
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/clam
	cooked_smell = /datum/pollutant/food/fried_shellfish

/obj/item/reagent_containers/food/snacks/fish/lobster
	name = "lobster"
	desc = "A hard-shelled cretin, barely fit for eating."
	icon_state = "lobster"
	faretype = FARE_NEUTRAL
	no_rarity_sprite = TRUE
	sellprice = 5
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish
	cooked_smell = /datum/pollutant/food/fried_shellfish

/obj/item/reagent_containers/food/snacks/fish/shrimp
	name = "shrimp"
	desc = "A tiny shellfish, little bigger than your thumb. Often nicknamed butterflies of the sea."
	icon_state = "shrimp"
	sellprice = 5
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/shrimp
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fryfish/shrimp
	cooked_smell = /datum/pollutant/food/fried_shellfish

/obj/item/reagent_containers/food/snacks/fish/oyster
	name = "oyster"
	desc = "A stubborn shellfish that MIGHT hide a prize within, can be opened with a knife to reveal the flesh within."
	icon_state = "oyster"
	sellprice = 5
	var/closed
	var/obj/item/pearl
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish
	trash = /obj/item/oystershell
	cooked_smell = /datum/pollutant/food/fried_shellfish

/obj/item/reagent_containers/food/snacks/fish/oyster/Initialize()
	. = ..()
	var/pearl_weight
	switch(name) //checks the rarity of the oyster via the name
		if("legendary oyster")
			pearl_weight = pickweight(list("bpearl" = 200, "pearl" =15, "nopearl"=15)) //specific weights should be modified due to balance later
		if("ultra-rare oyster")
			pearl_weight = pickweight(list("bpearl" = 60, "pearl" =120, "nopearl"=35))
		if("rare oyster")
			pearl_weight = pickweight(list("bpearl" = 40, "pearl" =80, "nopearl"=150))
		if("common oyster")
			pearl_weight = pickweight(list("bpearl" = 10, "pearl" =40, "nopearl"=200))
	switch(pearl_weight)
		if("nopearl")
			pearl = null
		if("pearl")
			pearl = new /obj/item/pearl(src)
		if("bpearl")
			pearl = new /obj/item/pearl/blue(src)
	closed = TRUE

/obj/item/reagent_containers/food/snacks/fish/oyster/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/rogueweapon/huntingknife))
		if(closed)
			user.visible_message("<span class='notice'>[user] opens the oyster with the knife.</span>")
			closed = FALSE
			icon_state = "[icon_state]_open"
			update_icon()
		else
			if(slice(src, user))
				new /obj/item/oystershell(user.loc)
				new /obj/item/oystershell(user.loc)
	else
		. = ..()

/obj/item/reagent_containers/food/snacks/fish/oyster/attack_right(mob/user)
	if(user.get_active_held_item())
		return
	else
		if(pearl)
			user.put_in_hands(pearl)
			pearl = null
			update_icon()
	. = ..()

/obj/item/reagent_containers/food/snacks/fish/oyster/update_icon()
	cut_overlays()
	if(!closed && pearl)
		var/mutable_appearance/pearl = mutable_appearance(icon, "pearl")
		add_overlay(pearl)

/obj/item/oystershell
	name = "oyster shell"
	icon = 'modular/Neu_food/icons/raw/raw_fish.dmi'
	icon_state = "oyster_shell"
	desc = ""
	dropshrink = 0.5
	w_class = WEIGHT_CLASS_TINY
	sellprice = 3
	grid_height = 32
	grid_width = 32

// Close enough crab cake is raw shellfish
/obj/item/reagent_containers/food/snacks/rogue/foodbase/crabcakeraw
	name = "raw crab cake"
	desc = "A variant of the handpie filled with buttery, savory shellfish meat and made with a buttered slice of dough."
	icon_state = "crab_cake_raw"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/crabcake
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/crabcake
	cooked_smell = /datum/pollutant/food/fried_crab_cake
	w_class = WEIGHT_CLASS_NORMAL
	dropshrink = 0.8

/obj/item/reagent_containers/food/snacks/rogue/crabcake
	name = "crab cake"
	desc = "A variant of the handpie filled with buttery, savory shellfish meat and made with a buttered slice of dough."
	icon_state = "crab_cake"
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	bitesize = 4
	list_reagents = list(/datum/reagent/consumable/nutriment = SMALLDOUGH_NUTRITION + MEATSLAB_NUTRITION)
	tastes = list("crispy butterdough and shellfish meat" = 1)
	rotprocess = null
	dropshrink = 0.8
