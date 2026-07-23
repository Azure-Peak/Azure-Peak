/obj/item/flashlight/flare/torch/lantern/censer
	name = "medicinal censer"
	desc = "A masterfully-crafted brass censer fitted with an intricate diffuser. When opened, its volatile aromatic mixture produces a dense medicinal mist that may be further enriched by burning carefully prepared herbs. In practiced hands, the vapors can be guided to cling to a patient's body, greatly prolonging the effects of restorative compounds. Mishandling the pressure vessel, however, may cause it to rupture violently into an irrepairable state."
	icon_state = "censer"
	item_state = "censer"
	light_outer_range = 6
	light_color ="#daffe1"
	possible_item_intents = list(/datum/intent/flail/smash)
	fuel = 999 MINUTES
	force = 11
	var/next_smoke
	var/smoke_interval = 2 SECONDS
	var/datum/herbal_recipe/recipe = null
	var/herb_charges = 0
	var/mix_name = null

/datum/herbal_recipe
    var/brute = 0
    var/burn = 0
    var/blood = 0
    var/toxin = 0
    var/wounds = 0
    var/catalyst = null

/obj/item/flashlight/flare/torch/lantern/censer/examine(mob/user)
	. = ..()
	if(herb_charges)
		. += span_blue("[herb_charges] uses remaining.")
	if(mix_name)
		. += span_blue("[mix_name] mix currently in effect.")

/obj/item/flashlight/flare/torch/lantern/censer/get_mechanics_examine(mob/user)
	. = ..()
	if(fuel > 0)
		. += span_info("Activate it in your hand to open the censer. An open censer is required for advanced medicinal techniques.")
		. += span_info("Mill herbs into powders with a Herb Mill, then prepare a recipe by mixing them together. You can use that to fill the censer with the desired herbal blend.")
		. += span_info("Different herbs specialize in different treatments. GREEN herbs improve brute healing, YELLOW improve burn healing, BLUE improve toxin treatment, WHITE aid wounds, and RED restore blood and stop bleeding.")
		. += span_info("With the censer lit and fueled, those trained in Medicine may use the BLESS intent to bathe nearby creatures in restorative vapors. The vapors always provide mild, prolonged recovery, while the prepared herbal recipe enhances only the injuries its ingredients are suited to treat.")
		. += span_info("Herbal fuel is consumed whenever medicinal vapors are released. Once the fuel is burned out, RIGHT CLICK the censer to remove it. You can remove it preemptively, but removing will always destroy the blend.")
		. += span_necrosis("Using the SMASH intent while the censer is open will rupture its volatile reservoir, causing a violent explosion. But remember the oath: Do No Harm!")
	else
		. += span_necrosis("The censer's reservoir has been destroyed. It can no longer hold fuel or herbal preparations. Would you look at that! The hippocratic oath was right after all.")

/obj/item/flashlight/flare/torch/lantern/censer/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -2,"sy" = -4,"nx" = 9,"ny" = -4,"wx" = -3,"wy" = -4,"ex" = 2,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 45, "sturn" = 45,"wturn" = 45,"eturn" = 45,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 45,"sturn" = 45,"wturn" = 45,"eturn" = 45,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


/obj/item/flashlight/flare/torch/lantern/censer/fire_act(added, maxstacks)
	return

/obj/item/flashlight/flare/torch/lantern/censer/attack_self(mob/user)
	if(fuel > 0)
		if(on)
			turn_off()
			possible_item_intents = list(/datum/intent/flail/smash)
			user.update_a_intents()
		else
			playsound(src.loc, 'sound/items/censer_on.ogg', 100)
			possible_item_intents = list(/datum/intent/flail/smash, /datum/intent/bless)
			user.update_a_intents()
			on = TRUE
			update_brightness()
			if(soundloop)
				soundloop.start()
			if(ismob(loc))
				var/mob/M = loc
				M.update_inv_hands()
			START_PROCESSING(SSobj, src)
	else if(fuel <= 0 && user.used_intent.type == /datum/intent/weep)
		to_chat(user, span_warning("Damn. This was like, a whole lyfe's savings, you know?"))

/obj/item/flashlight/flare/torch/lantern/censer/process()
	if(on && next_smoke < world.time)
		new /obj/effect/temp_visual/censer_dust(get_turf(src))
		next_smoke = world.time + smoke_interval

/obj/item/flashlight/flare/torch/lantern/censer/turn_off()
	playsound(src.loc, 'sound/items/censer_off.ogg', 100)
	if(soundloop)
		soundloop.stop()
	STOP_PROCESSING(SSobj, src)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()
		M.update_inv_belt()
	damtype = BRUTE

/obj/item/flashlight/flare/torch/lantern/censer/fire_act(added, maxstacks)
	return

/obj/item/flashlight/flare/torch/lantern/censer/afterattack(atom/movable/A, mob/user, proximity)
	. = ..()
	if(ismob(A) && on && (user.used_intent.type == /datum/intent/flail/smash) && user.cmode && istype(user.rmb_intent, /datum/rmb_intent/strong)) // needs strong intent
		user.visible_message(span_warningbig("[user] smashes the exposed [src], shattering the device and any leftovers of the Hippocratic Oath along! SHAME!!!"))
		user.visible_message(span_necrosis(pick("WHY--!!","PESTRA BLAS--!!","CURE--!!","CURE THI--!!","DO NO HAR--!!","OH ILLMAIDE--!!","OH PESTR--!!","KABOO--!!","MASHALLA--!!","OH HEARTBEAS--!!","OH SHI--!!","PESTR--!!","PESTRA BLAS--!!","PESTRA HAVE MER--!!","BY THE ILLMAIDE--!!","HEARTBEAST PRESER--!!","MY PATIEN--!!","NOT THE MIXTU--!!")))
		explosion(get_turf(user),devastation_range = 0, heavy_impact_range = 0, light_impact_range = 0, flame_range = 3, flash_range = 6, smoke = FALSE)
		fuel = 0
		turn_off()
		icon_state = "censer-broken"
		possible_item_intents = list(/datum/intent/weep)
		user.update_a_intents()
		return

	if(ishuman(A) && on && (user.used_intent.type == /datum/intent/bless))
		var/mob/living/carbon/human/H = A
		if(herb_charges)
			if(!H.has_status_effect(/datum/status_effect/buff/healingvapors, recipe))
				user.playsound_local(user, 'sound/magic/teleport_diss.ogg', 50, FALSE)
				user.playsound_local(user, 'sound/magic/heal.ogg', 100, FALSE)
				user.visible_message(span_info("[user] holds \the [src] over \the [A].."))
				if(do_after(user, 3.5 SECONDS, target = A))
					H.apply_status_effect(/datum/status_effect/buff/healingvapors, recipe)
					to_chat(H, span_necrosis("The fragrance of the censer invigorates you!"))
					user.playsound_local(H, 'sound/magic/undivided_recuperation.ogg', 50)
					user.playsound_local(H, 'sound/magic/PSY.ogg', 100)
					new /obj/effect/temp_visual/censer_dust(get_turf(H))
					herb_charges = max(src.herb_charges - 1, 0)
					return
			else
				to_chat(span_warning("They're already under the effects of vapors."))
				return
		else
			to_chat(user, span_warning("There's not enough Herb Fuel for this to work."))
			return

//A note for the Physician.
/obj/item/paper/herb_censer_prep_recipe
	name = "Censer Herbal Compendium"
	desc = "A reference detailing the medicinal properties of herbal censer preparations."
	info = {"
		<font face='Times New Roman' color='#000000'>

		<b>Herbal Properties</b><br>
		<font color='red'><b>Red</b></font> = Restores blood and staunches bleeding.<br>
		<font color='green'><b>Green</b></font> = Heals brute injuries.<br>
		<font color='blue'><b>Blue</b></font> = Purges toxins.<br>
		<b>White</b> = Treats wounds.<br>
		<font color='#C8A000'><b>Yellow</b></font> = Heals burns.<br>
		<br>

		Herbs are prepared in groups of <b>three</b>.<br>
		Red and White may only appear once in a mixture.<br>
		Repeated herbs strengthen their respective effects.<br>

		<hr>

		<b>Known Preparations</b><br><br>

		<b>Brute (Green)</b><br>
		G + G + G = Great Brute Healing<br>
		R + G + G = Blood & Strong Brute<br>
		G + G + B = Strong Brute & Toxin<br>
		G + G + Y = Strong Brute & Burn<br>
		G + G + W = Strong Brute & Wound<br>
		R + G + B = Blood, Brute & Toxin <i>(A classic!)</i><br>
		R + G + Y = Blood, Brute & Burn<br>
		R + G + W = Blood, Brute & Wound<br>
		G + B + B = Brute & Strong Toxin<br>
		G + B + Y = Brute, Toxin & Burn<br>
		G + B + W = Brute, Toxin & Wound<br>
		G + Y + Y = Brute & Strong Burn<br>
		G + Y + W = Brute, Burn & Wound<br>

		<br>

		<b>Burn (Yellow)</b><br>
		Y + Y + Y = Great Burn Healing<br>
		R + Y + Y = Blood & Strong Burn<br>
		G + Y + Y = Brute & Strong Burn<br>
		B + Y + Y = Toxin & Strong Burn<br>
		W + Y + Y = Wound & Strong Burn<br>
		R + G + Y = Blood, Brute & Burn<br>
		R + B + Y = Blood, Toxin & Burn<br>
		R + W + Y = Blood, Wound & Burn<br>
		G + B + Y = Brute, Toxin & Burn<br>
		G + W + Y = Brute, Wound & Burn<br>
		B + W + Y = Toxin, Wound & Burn<br>

		<br>

		<b>Toxin (Blue)</b><br>
		B + B + B = Great Toxin Purge<br>
		R + B + B = Blood & Strong Toxin<br>
		G + B + B = Brute & Strong Toxin<br>
		B + B + Y = Strong Toxin & Burn<br>
		B + B + W = Strong Toxin & Wound<br>
		R + G + B = Blood, Brute & Toxin <i>(A classic!)</i><br>
		R + B + Y = Blood, Toxin & Burn<br>
		R + B + W = Blood, Wound & Toxin<br>
		G + B + Y = Brute, Toxin & Burn<br>
		G + B + W = Brute, Toxin & Wound<br>
		B + W + Y = Toxin, Wound & Burn<br>

		<br>

		<b>Wounds (White)</b><br>
		R + W + G = Blood, Wound & Brute<br>
		R + W + B = Blood, Wound & Toxin<br>
		R + W + Y = Blood, Wound & Burn<br>
		G + G + W = Strong Brute & Wound<br>
		G + B + W = Brute, Toxin & Wound<br>
		G + W + Y = Brute, Wound & Burn<br>
		B + B + W = Strong Toxin & Wound<br>
		B + W + Y = Toxin, Wound & Burn<br>
		W + Y + Y = Wound & Strong Burn<br>

		<br>

		<b>Blood (Red)</b><br>
		R + G + G = Blood & Strong Brute<br>
		R + B + B = Blood & Strong Toxin<br>
		R + Y + Y = Blood & Strong Burn<br>
		R + G + B = Blood, Brute & Toxin <i>(A classic!)</i><br>
		R + G + Y = Blood, Brute & Burn<br>
		R + B + Y = Blood, Toxin & Burn<br>
		R + W + G = Blood, Wound & Brute<br>
		R + W + B = Blood, Wound & Toxin<br>
		R + W + Y = Blood, Wound & Burn<br>

		<b>On Catalysts</b><br>
		A completed herbal preparation may be further fortified with a single medicinal catalyst. Such agents bind only to finished mixtures, and will fail if introduced before the threefold preparation is complete.<br>
		<br>

		Ozium = Powerful analgesic effects, hinders speech for a while.<br>
		Moondust = Increase speed and removes tiredness. May have complications if done on someone not tired.<br>
		Coffee, Sugar, Tea = Sharpens the senses and restores stamina.<br>
		Honey = Cleanses infected flesh and halts the advance of rot.<br>
		Coal Dust = Cleanses all impurities from the blood.<br>
		Impure Lux = Progressive resurrection, but not recommended.<br>
		Purified Lux = Immediate resurrection, recommended.<br>
		SIDE-NOTE FOR RESURRECTION = DO 'NOT' FORCE IT IF YOU CANNOT DO SO!

		</font>
	"}

/obj/item/herbmill/bootleg
	name = "crude herb mill"
	desc = "A crude herb mill cobbled together from scrap. It has an unfortunate habit of ruining herbs during the grinding process."
	icon_state = "peppermill"

/obj/item/herbmill/bootleg/attack_self(mob/user)
	if(!herb_amount || !powder_type)
		to_chat(user, span_warning("The herb mill is empty."))
		return
	to_chat(user, span_notice("You begin grinding the herbs with the crude mill..."))
	playsound(get_turf(user), 'modular/Neu_Food/sound/peppermill.ogg', 90, TRUE, -1)
	if(!do_after(user, 20, target = src))
		to_chat(user, span_warning("You stop grinding before the herbs are fully milled."))
		return
	var/powders_created = 0
	var/medicine_bonus = user.get_skill_level(/datum/skill/misc/medicine) * 5
	var/alchemy_bonus = user.get_skill_level(/datum/skill/craft/alchemy) * 5
	for(var/i = 1, i <= herb_amount, i++)
		var/total_chance = prob(20 + medicine_bonus + alchemy_bonus)
		if(total_chance)
			new powder_type(get_turf(src))
			user.mind.add_sleep_experience(/datum/skill/craft/alchemy, rand(2,10))
			user.mind.add_sleep_experience(/datum/skill/misc/medicine, rand(2,10))
			powders_created++
	if(!powders_created)
		to_chat(user, span_warning("The crude mill mangles the herbs into a useless mess. Nothing salvageable remains."))
	else if(powders_created < herb_amount)
		to_chat(user, span_notice("You finish grinding the herbs, though much of the mixture is wasted by the crude mechanism."))
	else
		var/mob/living/H = user
		to_chat(user, span_notice("Against all odds, the crude mill grinds every herb without wasting any. By [uppertext(H.patron)], what a miracle!"))
	herb_amount = 0
	powder_type = null
	update_icon()

/obj/item/herbmill
	name = "herb mill"
	desc = "A small mill used to grind medicinal herbs into powders."
	icon = 'modular/Neu_Food/icons/cookware/peppermill.dmi'
	icon_state = "peppermill"
	w_class = WEIGHT_CLASS_TINY
	var/powder_type = null
	var/herb_amount = 0

/obj/item/herbmill/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Mill herbs into powders with a Herb Mill, then prepare a recipe by mixing them together. You can use that to fill the censer with the desired herbal blend.")
	. += span_info("Different herbs specialize in different treatments. GREEN herbs improve brute healing, YELLOW improve burn healing, BLUE improve toxin treatment, WHITE aid wounds, and RED restore blood and stop bleeding.")

/obj/item/herbmill/attackby(obj/item/I, mob/user, params)
	if(!istype(I, /obj/item/alch))
		return ..()
	var/obj/item/alch/herb = I
	if(!herb.herb_powder_type)
		to_chat(user, span_warning("This herb cannot be refined into a medicinal powder."))
		return
	if(powder_type && powder_type != herb.herb_powder_type)
		to_chat(user, span_warning("The mill already contains another type of herbal essence. Grind it before adding more."))
		return
	powder_type = herb.herb_powder_type
	herb_amount++
	qdel(herb)
	to_chat(user, span_notice("You place the herb into the mill."))
	update_icon()

/obj/item/herbmill/attack_self(mob/user)
	if(!herb_amount || !powder_type)
		to_chat(user, span_warning("The herb mill is empty."))
		return
	to_chat(user, span_notice("You begin grinding the herbs..."))
	playsound(get_turf(user), 'modular/Neu_Food/sound/peppermill.ogg', 90, TRUE, -1)
	if(!do_after(user, 20, target = src))
		return
	for(var/i = 1, i <= herb_amount, i++)
		new powder_type(get_turf(src))
	to_chat(user, span_notice("You finish grinding the herbs into powder."))
	user.mind.add_sleep_experience(/datum/skill/craft/alchemy, rand(2,10))
	user.mind.add_sleep_experience(/datum/skill/misc/medicine, rand(2,10))
	herb_amount = 0
	powder_type = null
	update_icon()

/obj/item/herb_powder
	name = "herbal powder"
	desc = "A finely ground medicinal powder."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "salt"
	color = null
	w_class = WEIGHT_CLASS_TINY
	var/herb_color = null
	var/list/herb_layers = list()
	var/catalyst = null

/obj/item/herb_powder/proc/apply_catalyst(obj/item/I, mob/user)
	if(length(herb_layers) != 3)
		to_chat(user, span_warning("The catalyst has nothing complete to bind to. The preparation must contain three mixtures first."))
		return FALSE
	if(catalyst)
		to_chat(user, span_warning("This preparation already contains a catalyst."))
		return FALSE
	if(istype(I, /obj/item/reagent_containers/powder/moondust))
		catalyst = "Moondust"
	else if(istype(I, /obj/item/reagent_containers/food/snacks/grown/coffee) || \
			istype(I, /obj/item/reagent_containers/food/snacks/grown/coffeebeans) || \
			istype(I, /obj/item/reagent_containers/food/snacks/grown/coffeebeansroasted))
		catalyst = "Coffee"
	else if(istype(I, /obj/item/reagent_containers/powder/ozium))
		catalyst = "Ozium"
	else if(istype(I, /obj/item/alch/coaldust))
		catalyst = "Coal"
	else if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		catalyst = "Honey"
	else if(istype(I, /obj/item/reagent_containers/lux_impure) || \
			istype(I, /obj/item/reagent_containers/lux_moss))
		catalyst = "Impure Lux"
	else if(istype(I, /obj/item/reagent_containers/lux))
		catalyst = "Purified Lux"
	else
		return FALSE
	qdel(I)
	aura_color = "#34ff3b"
	update_aura()
	to_chat(user, span_notice("You enrich the finished herbal preparation with [catalyst]."))
	return TRUE

/obj/item/herb_powder/attackby(obj/item/I, mob/user, params)
	if(apply_catalyst(I, user))
		return
	if(!istype(I, /obj/item/herb_powder))
		return ..()
	var/obj/item/herb_powder/P = I
	if(!can_combine(P))
		to_chat(user, span_warning("These powders do not form a stable preparation."))
		return
	combine_powders(P, user)

/obj/item/herb_powder/Initialize()
	. = ..()
	if(herb_color)
		herb_layers += herb_color

	update_name()
	update_visuals()

/obj/item/herb_powder/proc/update_aura()
	stacked_aura_colors = list()

	if(herb_layers.len <= 1)
		remove_stacked_auras()
		return

	for(var/i = 2, i <= herb_layers.len, i++)
		switch(herb_layers[i])
			if("R") stacked_aura_colors += "#C0392B"
			if("G") stacked_aura_colors += "#34ff3b"
			if("B") stacked_aura_colors += "#5834DB"
			if("Y") stacked_aura_colors += "#D4AC0D"
			if("W") stacked_aura_colors += "#F2F2F2"

	refresh_stacked_auras()

/obj/item/herb_powder/red
	name = "red herbal powder"
	color = "#C0392B"
	herb_color = "R"

/obj/item/herb_powder/green
	name = "green herbal powder"
	color = "#4CAF50"
	herb_color = "G"

/obj/item/herb_powder/blue
	name = "blue herbal powder"
	color = "#5834DB"
	herb_color = "B"

/obj/item/herb_powder/yellow
	name = "yellow herbal powder"
	color = "#D4AC0D"
	herb_color = "Y"

/obj/item/herb_powder/white
	name = "white herbal powder"
	color = "#F2F2F2"
	herb_color = "W"

/obj/item/herb_powder/proc/can_combine(obj/item/herb_powder/P)
	if(herb_layers.len + P.herb_layers.len > 3)
		return FALSE
	var/list/result = herb_layers.Copy()
	result += P.herb_layers
	if(list_count(result, "R") > 1)
		return FALSE
	if(list_count(result, "W") > 1)
		return FALSE
	return TRUE

/proc/list_count(list/L, value)
	var/n = 0
	for(var/V in L)
		if(V == value)
			n++
	return n

/obj/item/herb_powder/proc/combine_powders(obj/item/herb_powder/P, mob/user)
	for(var/C in P.herb_layers)
		herb_layers += C

	qdel(P)

	update_name()
	update_visuals()
	update_icon()

	to_chat(user, span_notice("You combine the powders into a unified preparation."))

/obj/item/herb_powder/proc/update_visuals()
	cut_overlays()

	if(!herb_layers.len)
		return

	color = get_herb_color(herb_layers[1])

	for(var/i = 2; i <= herb_layers.len; i++)
		var/mutable_appearance/A = mutable_appearance(icon, icon_state)

		A.color = get_herb_color(herb_layers[i])
		A.alpha = 180

		A.pixel_x = rand(-2,2)
		A.pixel_y = rand(-2,2)

		A.layer = FLOAT_LAYER + (i * 0.01)

		add_overlay(A)

/obj/item/herb_powder/proc/get_herb_color(C)
	switch(C)
		if("R")
			return "#C0392B"
		if("G")
			return "#4CAF50"
		if("B")
			return "#5834DB"
		if("Y")
			return "#D4AC0D"
		if("W")
			return "#F2F2F2"

	return "#FFFFFF"

/obj/item/herb_powder/proc/update_name()
	var/list/names = list()

	for(var/C in herb_layers)
		switch(C)
			if("R") names += "red"
			if("G") names += "green"
			if("B") names += "blue"
			if("Y") names += "yellow"
			if("W") names += "white"

	name = "[jointext(names, "-")] herbal powder"

/obj/item/flashlight/flare/torch/lantern/censer/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/herb_powder))
		var/obj/item/herb_powder/P = I
		if(recipe)
			to_chat(user, span_warning("The censer already contains a herbal preparation."))
			return
		recipe = P.build_recipe()
		if(!recipe)
			to_chat(user, span_warning("The preparation fails to produce a stable medicinal blend."))
			return
		if(recipe.catalyst == "Purified Lux")
			to_chat(user, span_warning("The Purified Lux destroys most of the ingredients within, sharply reducing the uses this have."))
			herb_charges = 1
		else
			herb_charges = 5
		mix_name += P.name
		qdel(P)
		to_chat(user, span_notice("You carefully load the herbal preparation into the censer."))
		return
	return ..()

/obj/item/flashlight/flare/torch/lantern/censer/attack_right(mob/user)
	if(!recipe)
		return ..()
	to_chat(user, span_notice("You empty the censer. The spent preparation crumbles into ash."))
	recipe = null
	mix_name = null
	herb_charges = 0
	playsound(src.loc, 'sound/items/firesnuff.ogg', 100)
	return TRUE

/obj/item/herb_powder/proc/build_recipe()
//	if(length(herb_layers) != 3)
//		return null
	var/datum/herbal_recipe/R = new
	var/g = list_count(herb_layers, "G")
	var/y = list_count(herb_layers, "Y")
	var/b = list_count(herb_layers, "B")
	var/r = list_count(herb_layers, "R")
	var/w = list_count(herb_layers, "W")
	switch(g)
		if(1) R.brute = 1
		if(2) R.brute = 2
		if(3) R.brute = 3
	switch(y)
		if(1) R.burn = 1
		if(2) R.burn = 2
		if(3) R.burn = 3
	switch(b)
		if(1) R.toxin = 1
		if(2) R.toxin = 2
		if(3) R.toxin = 3
	if(r)
		R.blood = 1
	if(w)
		R.wounds = 1
	R.catalyst = catalyst
	return R

/datum/status_effect/reanimating
	id = "reanimating"
	status_type = STATUS_EFFECT_REFRESH
	duration = 2 MINUTES
	var/stacks = 1

/datum/status_effect/reanimating/refresh()
	. = ..()
	if(stacks < 5)
		owner.visible_message(span_notice("The infusion succeeds... But it's not enough. Keep trying."))
		stacks++
	if(stacks >= 5)
		owner.visible_message(span_notice("The infusion settled!"))
		if(revive_vapor_target())
			qdel(src)

/proc/revive_vapor_target(mob/living/carbon/human/target)
	to_chat(world, span_userdanger("ATTEMPTING REVIVAL FOR [target]"))
	if(QDELETED(target) || target.stat != DEAD || HAS_TRAIT(target, TRAIT_DNR))
		return FALSE
	var/mob/living/carbon/spirit/underworld_spirit = target.get_spirit()
	if(target.client)
		if (alert(target, "You feel a kindling show the way back. Are you ready?", "Revival", "I need to wake up", "Don't let me go") != "I need to wake up")
			target.visible_message(span_notice("Nothing happens. They are not being let go."))
			return FALSE
	else if (underworld_spirit && underworld_spirit.client)
		if (alert(underworld_spirit, "You feel a kindling show the way back. Are you ready?", "Revival", "I need to wake up", "Don't let me go") != "I need to wake up")
			target.visible_message(span_notice("Nothing happens. They are not being let go."))
			return FALSE
	else
		target.visible_message(span_notice("The body shudders, but there's no one to call out to."))
		return FALSE
	target.adjustOxyLoss(-target.getOxyLoss())
	if(target.revive(full_heal = FALSE))
		if(underworld_spirit && underworld_spirit.mind) // Ensure spirit exists and has a mind
			underworld_spirit.mind.transfer_to(target, TRUE) // Transfer mind back to the revived body
			qdel(underworld_spirit) // Delete the spirit mob
		else
			target.grab_ghost(force = TRUE) // This attempts to grab a ghost even if they committed suicide.
		target.emote("breathgasp")
		target.Jitter(100)
		target.update_body()
		target.visible_message(span_notice("[target] is revived by a carefully applied waft of lux-vapors!"), span_green("I feel another's essence kindle my waned one... Like a hug in the form of vapors. Comforting, yet upsetting."))
		ADD_TRAIT(target, TRAIT_IWASREVIVED, "lux_vapors")
		target.apply_status_effect(/datum/status_effect/debuff/metabolic_acceleration)
		target.mind.remove_antag_datum(/datum/antagonist/zombie)
		return TRUE
	else
		target.visible_message(span_warning("The attempt falters, and nothing happens."))
		return FALSE
