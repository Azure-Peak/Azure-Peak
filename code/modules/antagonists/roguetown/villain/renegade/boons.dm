/datum/renegade_boons
	/// The Renegade this menu belongs to.
	var/datum/antagonist/renegade/owner
	/// Category the menu is filtered to, or "" for none.
	var/category = ""
	/// Search text across every category, or "" for none.
	var/search = ""
	/// Renegade-only boon instances, shared by every menu.
	var/static/list/boon_list
	/// Categories holding Renegade-only boons.
	var/static/list/boon_cats
	/// world.time the Renegade may next be seen chewing.
	var/chew_cd = 0

/datum/renegade_boons/New(datum/antagonist/renegade/R)
	owner = R
	if(boon_list)
		return
	boon_list = list()
	boon_cats = list()
	for(var/datum/renegade_boon/B as anything in subtypesof(/datum/renegade_boon))
		if(!initial(B.name))
			continue
		B = new B
		boon_list += B
		boon_cats |= B.category

/datum/renegade_boons/Destroy()
	owner = null
	return ..()

/datum/renegade_boons/ui_state(mob/user)
	return GLOB.conscious_state

/datum/renegade_boons/ui_status(mob/user, datum/ui_state/state)
	var/mob/living/carbon/human/H = user
	if(H != owner?.owner?.current || !istype(H.mouth, /obj/item/roguecoin/aalloy) || !in_reach(H))
		return UI_CLOSE
	return ..()

/datum/renegade_boons/proc/in_reach(mob/M)
	var/area/rogue/A = get_area(M)
	if(!istype(A))
		return FALSE
	if(A.town_area || (A.type in list(/area/rogue/outdoors/beach, /area/rogue/outdoors/beach/grim)))
		return TRUE
	return istype(A, /area/rogue/outdoors/exposed/town) || istype(A, /area/rogue/under/town/sewer) || istype(A, /area/rogue/outdoors/exposed/under/sewer)

/datum/renegade_boons/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		user.playsound_local(get_turf(user), 'sound/misc/gold_menu.ogg', 60, FALSE)
		ui = new(user, src, "RenegadeBoons", "Renegade Boons")
		ui.open()

/datum/renegade_boons/ui_data(mob/living/carbon/human/user)
	var/obj/item/roguecoin/aalloy/P = user.mouth
	var/list/items = list()
	if(category || search)
		var/list/rows = list()
		for(var/datum/renegade_boon/B as anything in boon_list)
			if(B.once && (B.name in owner.bought))
				continue
			rows += list(list("ref" = "[B.type]", "name" = B.name, "desc" = B.desc, "category" = B.category, "price" = B.cost))
		var/list/vheslie = VHESLIE_CATEGORIES
		for(var/pack in SSmerchant.supply_packs)
			var/datum/supply_pack/PA = SSmerchant.supply_packs[pack]
			if(!PA.not_in_public && (PA.group in vheslie))
				rows += list(list("ref" = "[PA.type]", "name" = PA.name, "desc" = PA.desc, "category" = PA.group, "price" = max(1, CEILING(PA.cost / RENEGADE_PSILEN_WORTH, 1))))
		var/needle = LOWER_TEXT(search)
		for(var/list/row as anything in rows)
			if((!category || row["category"] == category) && (!needle || findtext(LOWER_TEXT(row["name"]), needle)))
				items += list(row)
	return list(
		"psila" = P.quantity,
		"categories" = boon_cats | VHESLIE_CATEGORIES,
		"exclusive" = boon_cats,
		"category" = category,
		"search" = search,
		"spent" = owner.spent,
		"items" = items,
	)

/datum/renegade_boons/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = usr
	if(world.time >= chew_cd)
		chew_cd = world.time + 4 SECONDS
		H.visible_message(span_notice("[H] chews on a mouthful of coins."), span_notice("I grind the psila between my teeth."), vision_distance = 2)
	switch(action)
		if("category")
			var/cat = "[params["category"]]"
			category = (cat in (boon_cats | VHESLIE_CATEGORIES)) ? cat : ""
			return TRUE
		if("search")
			search = copytext("[params["search"]]", 1, 64)
			return TRUE
		if("buy")
			buy(H, text2path(params["ref"]))
			return TRUE

/datum/renegade_boons/proc/buy(mob/living/carbon/human/H, path)
	var/obj/item/roguecoin/aalloy/P = H.mouth
	var/name
	var/price
	var/list/contents
	if(ispath(path, /datum/renegade_boon))
		var/datum/renegade_boon/B = locate(path) in boon_list
		if(!B || (B.once && (B.name in owner.bought)))
			return
		name = B.name
		price = B.cost
		contents = B.contains
	else if(ispath(path, /datum/supply_pack))
		var/datum/supply_pack/PA = SSmerchant.supply_packs[path]
		if(!PA || PA.not_in_public || !(PA.group in VHESLIE_CATEGORIES))
			return
		name = PA.name
		price = max(1, CEILING(PA.cost / RENEGADE_PSILEN_WORTH, 1))
		contents = PA.contains
	else
		return
	if(P.quantity < price)
		to_chat(H, span_warning("Vheslie hisses. Not enough psila."))
		return
	if(P.quantity == price)
		H.doUnEquip(P)
		qdel(P)
	else
		P.set_quantity(P.quantity - price)
	owner.spent += price
	owner.bought += name
	var/turf/T = get_turf(H)
	var/list/made = list()
	for(var/item_path in contents)
		made += new item_path(T)
	if(length(made) == 1)
		H.put_in_hands(made[1])
	H.playsound_local(T, 'sound/misc/gold_misc.ogg', 60, FALSE)
	playsound(H, 'sound/misc/eat.ogg', 40, TRUE, -4)
	to_chat(H, span_notice("The psila sours on my tongue. [name] is mine."))
	log_game("[key_name(H)] bought Renegade boon [name] for [price] psila.")

/datum/renegade_boon
	/// Shown in the menu. Boons without one are abstract.
	var/name
	/// Shown under the name in the menu.
	var/desc
	/// Menu category.
	var/category
	/// Price in psila.
	var/cost = 1
	/// Item paths handed over on purchase.
	var/list/contains = list()
	/// TRUE if a Renegade may only ever buy this once.
	var/once = FALSE

/datum/renegade_boon/poison
	category = "Boons (Poisons)"

/datum/renegade_boon/poison/berry
	name = "Berry Poison x3"
	cost = 3
	contains = list(
		/obj/item/reagent_containers/glass/bottle/rogue/berrypoison,
		/obj/item/reagent_containers/glass/bottle/rogue/berrypoison,
		/obj/item/reagent_containers/glass/bottle/rogue/berrypoison,
	)

/datum/renegade_boon/poison/doom
	name = "Doom Poison"
	cost = 3
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/poison)

/datum/renegade_boon/poison/strong
	name = "Strong Doom Poison"
	cost = 6
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/strongpoison)

/datum/renegade_boon/poison/stamina
	name = "Stamina Poison"
	cost = 3
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/stampoison)

/datum/renegade_boon/poison/stamina_strong
	name = "Strong Stamina Poison"
	cost = 5
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/strongstampoison)

/datum/renegade_boon/poison/sleep
	name = "Sleep Poison"
	cost = 8
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/sleeppoison)

/datum/renegade_boon/elixir
	category = "Boons (Elixirs)"

/datum/renegade_boon/elixir/health
	name = "Strong Red"
	cost = 4
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew)

/datum/renegade_boon/elixir/mana
	name = "Strong Blue"
	cost = 5
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/strongmanapot)

/datum/renegade_boon/elixir/stamina
	name = "Strong Stamina"
	cost = 5
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/strongstampot)

/datum/renegade_boon/elixir/survival
	name = "Survivor's Crystal"
	desc = "A cloudy crystal. It'll imbue whoever crushes it with the ability to shrug off pain, or be quick in their steps.."
	cost = 4
	once = TRUE
	contains = list(/obj/item/renegade_crystal/survival)

/datum/renegade_boon/elixir/plate
	name = "Plated Crystal"
	desc = "A dull crystal, it makes the heavier armour far more bearable."
	cost = 2
	once = TRUE
	contains = list(/obj/item/renegade_crystal/plate)

/datum/renegade_boon/elixir/wrath
	name = "Wrathful Crystal"
	desc = "A jagged crystal. Crushing this would surely turn the most peaceful of souls into killers."
	cost = 2
	once = TRUE
	contains = list(/obj/item/renegade_crystal/wrath)

/datum/renegade_boon/coin
	category = "Boons (Coin)"

/datum/renegade_boon/coin/small
	name = "100 Mammons"
	cost = 2
	contains = list(/obj/item/roguecoin/gold/renegadepile)

/datum/renegade_boon/coin/large
	name = "200 Mammons"
	cost = 4
	contains = list(/obj/item/roguecoin/gold/aspirantpile)

/datum/renegade_boon/sabotage
	category = "Boons (Sabotage)"

/datum/renegade_boon/sabotage/tripbomb
	name = "Trip Bomb"
	cost = 6
	contains = list(/obj/item/bomb/tripbomb)

/datum/renegade_boon/sabotage/beartrap
	name = "Bear Trap"
	cost = 1
	contains = list(/obj/item/restraints/legcuffs/beartrap)

/datum/renegade_boon/sabotage/soap
	name = "Soap x2"
	cost = 1
	contains = list(/obj/item/soap, /obj/item/soap)

/datum/renegade_boon/sabotage/torches
	name = "Torch x3"
	cost = 1
	contains = list(/obj/item/flashlight/flare/torch, /obj/item/flashlight/flare/torch, /obj/item/flashlight/flare/torch)

/datum/renegade_boon/ranged
	category = "Boons (Ranged)"

/datum/renegade_boon/ranged/sunderbolts
	name = "Quiver of Sunderbolts"
	cost = 8
	contains = list(/obj/item/quiver/bolt/holy)

/datum/renegade_boon/ranged/silver
	name = "Silver Bolts x6"
	cost = 6
	contains = list(
		/obj/item/ammo_casing/caseless/rogue/bolt/silver,
		/obj/item/ammo_casing/caseless/rogue/bolt/silver,
		/obj/item/ammo_casing/caseless/rogue/bolt/silver,
		/obj/item/ammo_casing/caseless/rogue/bolt/silver,
		/obj/item/ammo_casing/caseless/rogue/bolt/silver,
		/obj/item/ammo_casing/caseless/rogue/bolt/silver,
	)

/datum/renegade_boon/ranged/blacksteel
	name = "Blacksteel Bolts x4"
	cost = 8
	contains = list(
		/obj/item/ammo_casing/caseless/rogue/bolt/blacksteel,
		/obj/item/ammo_casing/caseless/rogue/bolt/blacksteel,
		/obj/item/ammo_casing/caseless/rogue/bolt/blacksteel,
		/obj/item/ammo_casing/caseless/rogue/bolt/blacksteel,
	)

/datum/renegade_boon/ranged/blunt
	name = "Quiver of Blunt Bolts"
	cost = 3
	contains = list(/obj/item/quiver/bolt/blunt)

/datum/renegade_boon/ranged/water
	name = "Quiver of Water Bolts"
	cost = 2
	contains = list(/obj/item/quiver/bolt/water)

/datum/renegade_boon/ranged/firepot
	name = "Pouch of Fire Pots"
	cost = 5
	contains = list(/obj/item/quiver/sling/fire_pot)

/datum/renegade_boon/disguise
	category = "Boons (Disguises)"

/datum/renegade_boon/disguise/hood
	name = "Black Hood"
	cost = 1
	contains = list(/obj/item/clothing/head/roguetown/roguehood/black)

/datum/renegade_boon/disguise/skull
	name = "Skull Mask"
	cost = 2
	contains = list(/obj/item/clothing/mask/rogue/skullmask)

/datum/renegade_boon/disguise/sack
	name = "Sack Hood"
	cost = 1
	contains = list(/obj/item/clothing/mask/rogue/sack)

/datum/renegade_boon/disguise/commoner
	name = "Commoner's Garb"
	cost = 2
	contains = list(
		/obj/item/clothing/suit/roguetown/shirt/tunic/random,
		/obj/item/clothing/under/roguetown/tights/random,
		/obj/item/clothing/shoes/roguetown/simpleshoes,
		/obj/item/clothing/head/roguetown/cap,
	)

/datum/renegade_boon/disguise/laborer
	name = "Laborer's Garb"
	cost = 2
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/leather/vest,
		/obj/item/clothing/under/roguetown/tights/random,
		/obj/item/clothing/shoes/roguetown/simpleshoes,
	)

/datum/renegade_boon/disguise/dress
	name = "Townswoman's Dress"
	cost = 2
	contains = list(/obj/item/clothing/suit/roguetown/shirt/dress/gen/random, /obj/item/clothing/shoes/roguetown/simpleshoes)

/datum/renegade_boon/disguise/acolyte
	name = "Acolyte's Robe"
	cost = 2
	contains = list(/obj/item/clothing/suit/roguetown/shirt/robe/undivided)

/datum/renegade_boon/disguise/guard
	name = "Guard's Tabard"
	cost = 6
	contains = list(/obj/item/clothing/cloak/tabard/stabard/guard)

/datum/renegade_boon/blade
	category = "Boons (Blades)"

/datum/renegade_boon/blade/dagger
	name = "Steel Dagger"
	cost = 3
	contains = list(/obj/item/rogueweapon/huntingknife/idagger/steel)

/datum/renegade_boon/blade/parrying
	name = "Parrying Dagger"
	cost = 4
	contains = list(/obj/item/rogueweapon/huntingknife/idagger/steel/parrying)

/datum/renegade_boon/blade/throwing
	name = "Steel Throwing Knives x3"
	cost = 4
	contains = list(
		/obj/item/rogueweapon/huntingknife/throwingknife/steel,
		/obj/item/rogueweapon/huntingknife/throwingknife/steel,
		/obj/item/rogueweapon/huntingknife/throwingknife/steel,
	)

/datum/renegade_boon/blade/silver
	name = "Silver Dagger"
	cost = 6
	contains = list(/obj/item/rogueweapon/huntingknife/idagger/steel/silver)

/datum/renegade_boon/blade/sabre
	name = "Decorated Sabre"
	cost = 5
	contains = list(/obj/item/rogueweapon/sword/sabre/dec)

/obj/item/renegade_crystal
	name = "crystal"
	abstract_type = /obj/item/renegade_crystal
	icon = 'icons/roguetown/items/gems.dmi'
	icon_state = "ruby_cut"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 0.4
	drop_sound = 'sound/items/gem.ogg'
	/// Options the crusher picks one of, as option name = list of traits it grants.
	var/list/traits = list()
	/// Played when the crystal is crushed.
	var/crush_sound = 'sound/foley/glassbreak.ogg'

/obj/item/renegade_crystal/Initialize(mapload)
	. = ..()
	icon_state = pick("emerald_cut", "quartz_cut", "topaz_cut", "sapphire_cut", "ruby_cut", "diamond_cut")

/obj/item/renegade_crystal/examine(mob/user)
	. = ..()
	. += span_info("It can be used in hand.")

/obj/item/renegade_crystal/attack_self(mob/living/user)
	var/list/options = list()
	for(var/option in traits)
		for(var/trait in traits[option])
			if(!HAS_TRAIT(user, trait))
				options += option
				break
	if(!length(options))
		to_chat(user, span_warning("The crystal has nothing left to give me."))
		return
	var/choice = options[1]
	if(length(options) > 1)
		for(var/option in options)
			for(var/trait in traits[option])
				to_chat(user, "<b>[trait]:</b> [GLOB.roguetraits[trait]]")
		choice = tgui_alert(user, "What will the crystal grant me?", name, options)
		if(!choice || QDELETED(src) || !user.is_holding(src))
			return
	for(var/trait in traits[choice])
		ADD_TRAIT(user, trait, TRAIT_GENERIC)
	crush(user, "I gain [english_list(traits[choice])].")

/obj/item/renegade_crystal/proc/crush(mob/living/user, outcome)
	playsound(user, crush_sound, 70, TRUE)
	user.visible_message(span_notice("[user] crushes [src] in their hands."), span_notice("I crush [src] in my hands. [outcome]"))
	qdel(src)

/obj/item/renegade_crystal/survival
	name = "survivor's crystal"
	desc = "A cloudy crystal. It'll imbue whoever crushes it with the ability to shrug off pain, or be quick in their steps.."
	traits = list(
		"Painless & Enduring" = list(TRAIT_NOPAIN, TRAIT_NOPAINSTUN),
		TRAIT_DODGEEXPERT = list(TRAIT_DODGEEXPERT),
	)

/obj/item/renegade_crystal/plate
	name = "plated crystal"
	desc = "A dull crystal. It makes the heavier armour far more bearable."
	traits = list(TRAIT_HEAVYARMOR = list(TRAIT_HEAVYARMOR))

/obj/item/renegade_crystal/wrath
	name = "wrathful crystal"
	desc = "A jagged crystal. Crushing this would surely turn the most peaceful of souls into killers."

/obj/item/renegade_crystal/wrath/attack_self(mob/living/user)
	if(!HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("Nothing stays my hand. The crystal has nothing to give me."))
		return
	REMOVE_TRAIT(user, TRAIT_PACIFISM, null)
	crush(user, "Nothing stays my hand now.")
