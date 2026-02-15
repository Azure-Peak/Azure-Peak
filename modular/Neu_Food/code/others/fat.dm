// -------------- FAT -----------------
/obj/item/reagent_containers/food/snacks/fat
	icon = 'modular/Neu_Food/icons/others/fat.dmi'
	name = "fat"
	desc = "A lump of animal fat."
	icon_state = "fat"
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	eat_effect = /datum/status_effect/debuff/uncookedfood
	possible_item_intents = list(/datum/intent/food, /datum/intent/splash)
	fat_yield = 20

/obj/item/reagent_containers/food/snacks/fat/attackby(obj/item/I, mob/living/user, params)
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
	else
		return ..()

/obj/item/reagent_containers/food/snacks/fat/attack(mob/living/M, mob/user, proximity)
	if(user.used_intent.type == /datum/intent/food)
		return ..()

	if(!isliving(M) || (M != user))
		return ..()

	user.visible_message("[user] starts to oil up [M]", "You start to oil up [M]")
	if(!do_after(user, 5 SECONDS, M))
		return
	M.apply_status_effect(/datum/status_effect/buff/oiled)

/obj/item/reagent_containers/food/snacks/fat/examine()
	. = ..()
	. += span_info("Use on splash intent on yourself to oil yourself up, making yourself slippery and harder to grab when uncovered. Being barefoot reduces the chance of slipping.")

// TALLOW is used as an intermediate crafting ingredient for other recipes.
/obj/item/reagent_containers/food/snacks/tallow
	name = "tallow"
	desc = "Fatty tissue is harvested from slain creachurs and rendered of its membraneous sinew to produce a hard shelf-stable \
	grease."
	icon = 'modular/Neu_Food/icons/others/fat.dmi'
	icon_state = "tallow"
	tastes = list("grease" = 1, "oil" = 1, "regret" =1)
	obj_flags = CAN_BE_HIT
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	eat_effect = /datum/status_effect/debuff/uncookedfood
	fat_yield = 5 // 5 per animal fat
	bitesize = 1
	dropshrink = 0.75

/obj/item/reagent_containers/food/snacks/tallow/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/soap,
		/datum/crafting_recipe/roguetown/survival/candle,
		/datum/crafting_recipe/roguetown/survival/candle/eora,
		/datum/crafting_recipe/roguetown/survival/recurvepartial,
		/datum/crafting_recipe/roguetown/survival/longbowpartial,
		/datum/crafting_recipe/roguetown/leather/container/javelinbag,
		/datum/crafting_recipe/roguetown/leather/fingerless_leather_gloves,
		/datum/crafting_recipe/roguetown/leather/armor/heavy_leather_pants,
		/datum/crafting_recipe/roguetown/leather/armor/heavy_leather_pants/shorts,
		/datum/crafting_recipe/roguetown/leather/armor/helmet/advanced,
		/datum/crafting_recipe/roguetown/leather/armor/heavy_leather_armor,
		/datum/crafting_recipe/roguetown/leather/armor/heavy_leather_armor/coat,
		/datum/crafting_recipe/roguetown/leather/armor/heavy_leather_armor/jacket,
		/datum/crafting_recipe/roguetown/leather/hidebikini,
		/datum/crafting_recipe/roguetown/leather/unique/otavanleatherpants,
		/datum/crafting_recipe/roguetown/leather/unique/otavanboots,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/reagent_containers/food/snacks/tallow/get_mechanics_examine(mob/user)
    . = ..()
    . += span_info("Mixing tallow with a filled glass of wine can make 'redtallow', a crimson-tinged wax that's popular for sealing folded letters of ducal- and religious importance.")
    . += span_info("For more grizzly alternatives, one can substitute the wine with blood, or - in the hands of a trained Inquisitorial agent - a filled INDEXER.")

/obj/item/reagent_containers/food/snacks/tallow/red
	name = "redtallow"
	desc = "Fatty tissue is harvested from slain creachurs and rendered of its membraneous sinew to produce a hard shelf-stable \
	grease. It has then been soaked in blood or something blood adjacent to make for an easily sourced and rather grim wax substitute. As they say in Otava, Bon Appetit."
	icon_state = "redtallow"
	tastes = list("grease" = 1, "oil" = 1, "regret" =1, "blood"=1,)

/obj/item/reagent_containers/food/snacks/tallow/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(istype(I, /obj/item/inqarticles/indexer))
		var/obj/item/inqarticles/indexer/IND = I
		var/success
		if(HAS_TRAIT(user, TRAIT_INQUISITION))
			if(IND.full)
				if(alert(user, "SOAK THE TALLOW?", "IT'S JUST BLOOD", "YES", "NO") != "NO")
					success = TRUE
					IND.fullreset(user)
				else
					return	
				if(success)
					changefood(/obj/item/reagent_containers/food/snacks/tallow/red, user)		
