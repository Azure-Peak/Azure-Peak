/obj/item/alch
	name = "dust"
	desc = ""
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "irondust"
	w_class = WEIGHT_CLASS_TINY
	experimental_inhand = TRUE
	/*
		So, you're here about potions: TLDR - the cauldron takes up to 4 items, from this, makes 1 recipe. Major gives 3 points, med 2 points,minor 1 point.
		If no recipe gets above 5 points, it makes nothing,otherwise It then makes the recipe with the HIGHEST POINTS.
		all 3 of the below variables should be NULL or the type-path of the recipe to make.
	*/
	var/major_pot = null
	var/med_pot = null
	var/minor_pot = null
	//Dont worry, these 3 are just to cache the 'smell' of their pot on initialization to not have to re-look every examine.
	//No need to set them.
	var/major_smell
	var/med_smell
	var/minor_smell
	///Same as the smells, just caching what the potion name is
	var/major_name
	var/med_name
	var/minor_name

/obj/item/alch/Initialize()
	. = ..()
	if(!isnull(major_pot))
		var/datum/alch_cauldron_recipe/rec = locate(major_pot) in GLOB.alch_cauldron_recipes
		major_smell = rec.smells_like
		major_name = rec.name
	if(!isnull(med_pot))
		var/datum/alch_cauldron_recipe/rec = locate(med_pot) in GLOB.alch_cauldron_recipes
		med_smell = rec.smells_like
		med_name = rec.name
	if(!isnull(minor_pot))
		var/datum/alch_cauldron_recipe/rec = locate(minor_pot) in GLOB.alch_cauldron_recipes
		minor_smell = rec.smells_like
		minor_name = rec.name

/obj/item/alch/examine(mob/user)
	. = ..()
	if(user.mind)
		var/alch_skill = user.get_skill_level(/datum/skill/craft/alchemy)
		var/perint = 0
		if(isliving(user))
			var/mob/living/lmob = user
			perint = FLOOR((lmob.STAPER + lmob.STAINT)/2,1)
		if(HAS_TRAIT(user,TRAIT_LEGENDARY_ALCHEMIST))
			if(!isnull(major_name))
				. += span_notice(" Strongly attuned to making [major_name].")
			if(!isnull(med_name))
				. += span_notice(" Moderately attuned to making [med_name].")
			if(!isnull(minor_name))
				. += span_notice(" Minorly attuned to making [minor_name].")
		else
			if(!isnull(major_smell))
				if(alch_skill >= SKILL_LEVEL_NOVICE || perint >= 6)
					. += span_notice(" Smells strongly of [major_smell].")
			if(!isnull(med_smell))
				if(alch_skill >= SKILL_LEVEL_APPRENTICE || perint >= 10)
					. += span_notice(" Smells slightly of [med_smell].")
			if(!isnull(minor_smell))
				if(alch_skill >= SKILL_LEVEL_EXPERT || perint >= 16)
					. += span_notice(" Smells weakly of [minor_smell].")
/obj/item/alch/viscera
	name = "viscera"
	desc = "Butchered entrails. Quite useful for alchemy, if a little unappealing to handle."
	icon_state = "viscera"
	major_pot = /datum/alch_cauldron_recipe/big_health_potion
	med_pot = /datum/alch_cauldron_recipe/health_potion
	minor_pot = /datum/alch_cauldron_recipe/antidote

/obj/item/alch/sleep_powder
	name = "sleeping powder"
	icon_state = "zizodust"
	major_pot = /datum/alch_cauldron_recipe/sleeping_poison
	med_pot = /datum/alch_cauldron_recipe/lck_potion
	minor_pot = /datum/alch_cauldron_recipe/mana_potion

/obj/item/alch/briar_essence
	name = "essence of briar"
	icon_state = "redpowder"
	major_pot = /datum/alch_cauldron_recipe/sleeping_poison
	med_pot = /datum/alch_cauldron_recipe/antidote
	minor_pot = /datum/alch_cauldron_recipe/lck_potion

/obj/item/alch/viscera/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Viscera is chiefly obtained by butchering most animals. To butcher an animal, middle-click it with a knife without any miracles, spells, or special intents selected. The higher your Butchering skill, the more you'll carve.")

/obj/item/alch/waterdust
	name = "water essentia"
	icon_state = "water_runedust"
	sellprice = 2
	major_pot = /datum/alch_cauldron_recipe/int_potion
	med_pot = /datum/alch_cauldron_recipe/big_mana_potion
	minor_pot = /datum/alch_cauldron_recipe/per_potion

/obj/item/alch/bonemeal
	name = "bone meal"
	icon_state = "bonemeal"
	sellprice = 2
	major_pot = /datum/alch_cauldron_recipe/mana_potion
	med_pot = /datum/alch_cauldron_recipe/per_potion
	minor_pot = /datum/alch_cauldron_recipe/antidote

/obj/item/alch/seeddust
	name = "seed dust"
	icon_state = "seeddust"
	sellprice = 2
	major_pot = /datum/alch_cauldron_recipe/big_stamina_potion
	med_pot = /datum/alch_cauldron_recipe/stamina_potion
	minor_pot = /datum/alch_cauldron_recipe/strong_antidote

/obj/item/alch/runedust
	name = "raw essentia"
	icon_state = "runedust"
	sellprice = SELLPRICE_ARCANE_DUST_MID
	major_pot = /datum/alch_cauldron_recipe/int_potion
	med_pot = /datum/alch_cauldron_recipe/big_mana_potion
	minor_pot = /datum/alch_cauldron_recipe/per_potion

/obj/item/alch/coaldust
	name = "coal dust"
	icon_state = "coaldust"
	sellprice = 1
	major_pot = /datum/alch_cauldron_recipe/antidote
	med_pot = /datum/alch_cauldron_recipe/end_potion
	minor_pot = /datum/alch_cauldron_recipe/str_potion

/obj/item/alch/silverdust
	name = "silver dust"
	icon_state = "silverdust"
	sellprice = 20
	major_pot = /datum/alch_cauldron_recipe/strong_antidote
	med_pot = /datum/alch_cauldron_recipe/restoration_potion
	minor_pot = /datum/alch_cauldron_recipe/big_health_potion

/obj/item/alch/magicdust
	name = "pure essentia"
	icon_state = "magic_runedust"
	sellprice = SELLPRICE_ARCANE_DUST_HIGH
	major_pot = /datum/alch_cauldron_recipe/big_mana_potion
	med_pot = /datum/alch_cauldron_recipe/end_potion
	minor_pot = /datum/alch_cauldron_recipe/con_potion

/obj/item/alch/firedust
	name = "fire essentia"
	icon_state = "fire_runedust"
	sellprice = SELLPRICE_ARCANE_DUST_LOW
	major_pot = /datum/alch_cauldron_recipe/str_potion
	med_pot = /datum/alch_cauldron_recipe/con_potion
	minor_pot = /datum/alch_cauldron_recipe/fire_potion

/obj/item/alch/sinew
	name = "sinew"
	desc = "The sinew of an animal, pulled out of said animal. Has some alchemical uses."
	icon_state = "sinew"
	sellprice = SELLPRICE_SINEW
	dropshrink = 0.9
	major_pot = /datum/alch_cauldron_recipe/stam_poison
	med_pot = /datum/alch_cauldron_recipe/end_potion
	minor_pot = /datum/alch_cauldron_recipe/health_potion

/obj/item/alch/sinew/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Sinew is chiefly obtained by butchering most animals. To butcher an animal, middle-click it with a knife without any miracles, spells, or special intents selected. The higher your Butchering skill, the more you'll carve.")

/obj/item/alch/irondust
	name = "iron dust"
	icon_state = "irondust"
	sellprice = 3
	major_pot = /datum/alch_cauldron_recipe/end_potion
	med_pot = /datum/alch_cauldron_recipe/con_potion
	minor_pot = /datum/alch_cauldron_recipe/str_potion

/obj/item/alch/airdust
	name = "air essentia"
	icon_state = "air_runedust"
	sellprice = SELLPRICE_ARCANE_DUST_LOW
	major_pot = /datum/alch_cauldron_recipe/spd_potion
	med_pot = /datum/alch_cauldron_recipe/stamina_potion
	minor_pot = /datum/alch_cauldron_recipe/int_potion

/obj/item/alch/swampdust
	name = "swampweed dust"
	icon_state = "swampdust"
	sellprice = 3
	major_pot = /datum/alch_cauldron_recipe/berrypoison
	med_pot = /datum/alch_cauldron_recipe/big_stam_poison
	minor_pot = /datum/alch_cauldron_recipe/end_potion

/obj/item/alch/tobaccodust
	name = "westleach dust"
	icon_state = "tobaccodust"
	sellprice = 4
	major_pot = /datum/alch_cauldron_recipe/per_potion
	med_pot = /datum/alch_cauldron_recipe/stamina_potion
	minor_pot = /datum/alch_cauldron_recipe/spd_potion

/obj/item/alch/earthdust
	name = "earth essentia"
	icon_state = "earth_runedust"
	sellprice = 1
	major_pot = /datum/alch_cauldron_recipe/con_potion
	med_pot = /datum/alch_cauldron_recipe/end_potion
	minor_pot = /datum/alch_cauldron_recipe/str_potion

/obj/item/alch/bone
	name = "tail bone"
	icon_state = "bone"
	desc = "The only bone in creachers with alchemical properties."
	sellprice = SELLPRICE_BONE
	force = 7
	throwforce = 5
	w_class = WEIGHT_CLASS_SMALL
	grid_width = 32
	grid_height = 64

	major_pot = /datum/alch_cauldron_recipe/strong_antidote
	med_pot = /datum/alch_cauldron_recipe/health_potion
	minor_pot = /datum/alch_cauldron_recipe/con_potion

/obj/item/alch/bone/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Tailbones are chiefly obtained by butchering most animals. To butcher an animal, middle-click it with a knife without any miracles, spells, or special intents selected. The higher your Butchering skill, the more you'll carve.")

/obj/item/alch/horn
	name = "troll horn"
	icon_state = "horn"
	desc = "The horn of a bog troll."
	sellprice = SELLPRICE_HORN
	force = 7
	throwforce = 5
	w_class = WEIGHT_CLASS_NORMAL
	grid_width = 64
	grid_height = 64

	major_pot = /datum/alch_cauldron_recipe/str_potion
	med_pot = /datum/alch_cauldron_recipe/con_potion
	minor_pot = /datum/alch_cauldron_recipe/end_potion

/obj/item/alch/horn/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("These horns are chiefly obtained by butchering trolls. To butcher an animal, middle-click it with a knife without any miracles, spells, or special intents selected. The higher your Butchering skill, the more you'll carve.")

/obj/item/alch/golddust
	name = "gold dust"
	icon_state = "golddust"
	sellprice = 15

	major_pot = /datum/alch_cauldron_recipe/big_mana_potion
	med_pot = /datum/alch_cauldron_recipe/restoration_potion
	minor_pot = /datum/alch_cauldron_recipe/per_potion

/obj/item/alch/feaudust
	name = "feau dust"
	icon_state = "feaudust"
	sellprice = SELLPRICE_ARCANE_DUST_MID

	major_pot = /datum/alch_cauldron_recipe/spd_potion
	med_pot = /datum/alch_cauldron_recipe/big_mana_potion
	minor_pot = /datum/alch_cauldron_recipe/strong_antidote

/obj/item/alch/ozium
	name = "alchemical ozium"
	desc = "Alchemical processing has left it unfit for consumption."
	icon_state = "darkredpowder"
	sellprice = 8

	major_pot = /datum/alch_cauldron_recipe/big_stamina_potion
	med_pot = /datum/alch_cauldron_recipe/lck_potion
	minor_pot = /datum/alch_cauldron_recipe/int_potion

/obj/item/alch/transisdust
	name = "sui dust"
	desc = "A long mix of herbs resulting in a special dust. For you. Use it while held."
	icon_state = "transisdust"

/obj/item/alch/transisdust/attack_self(mob/living/user)
	..()

	if(alert("Do you wish to change your self?", "Dust of Self", "Yes", "No") != "Yes")
		return
	user.visible_message(
		span_warn("[user] begins to use [src]."),
		span_warn("I begin to apply [src] on myself.")
	)
	if(!do_after(user, 5 SECONDS))
		return

	var/p_input = input(user, "Choose your character's pronouns", "Pronouns") as null|anything in GLOB.pronouns_list
	if(p_input)
		user.pronouns = p_input
	if(alert("Do you wish to change your frame?", "Body Type", "Yes", "No") == "Yes")
		user.gender = "male" ? "female" : "male"

	if(!do_after(user, 5 SECONDS))
		return

	user.regenerate_icons()
	to_chat(user, span_notice("Tis' complete."))
	qdel(src)

/obj/item/alch/puresalt
	name = "purified salts"
	desc = "Salts that have been finely sifted to enchance their healing properties and to bolster its connection to the arcyne."
	icon_state = "puresalt"
	sellprice = 8

	major_pot = /datum/alch_cauldron_recipe/antidote
	med_pot = /datum/alch_cauldron_recipe/strong_antidote
	minor_pot = /datum/alch_cauldron_recipe/big_mana_potion

/obj/item/alch/mineraldust
	name = "mineral dusts"
	desc = "Elements of gems ground and sifted of impurities to help draw out its useful alchemical minerals."
	icon_state = "mineraldust"
	sellprice = 1

	major_pot = /datum/alch_cauldron_recipe/doompoison
	med_pot = /datum/alch_cauldron_recipe/big_mana_potion
	minor_pot = /datum/alch_cauldron_recipe/big_stam_poison

/obj/item/alch/infernaldust
	name = "infernal dust"
	desc = "The remains of an abyssal tether to this plane, banished or slain. Best handled with gloves."
	icon_state = "infernaldust"
	sellprice = SELLPRICE_ARCANE_DUST_HIGH

	major_pot = /datum/alch_cauldron_recipe/fire_potion
	med_pot = /datum/alch_cauldron_recipe/big_stam_poison
	minor_pot = /datum/alch_cauldron_recipe/int_potion

/obj/item/alch/solardust
	name = "solar dust"
	desc = "A pinch of Astrata worked into radiant matter. Looking at it hurts your eyes."
	icon_state = "solardust"
	sellprice = SELLPRICE_ARCANE_DUST_MID

	major_pot = /datum/alch_cauldron_recipe/fire_potion
	med_pot = /datum/alch_cauldron_recipe/int_potion
	minor_pot = /datum/alch_cauldron_recipe/per_potion

/obj/item/alch/berrypowder
	name = "berry powder"
	desc = "Berries ground and dried into a soft, fragrant powder. It'd probably \
	make you sneeze if you accidentally inhaled any."
	icon_state = "berrypowder"
	sellprice = 2

	major_pot = /datum/alch_cauldron_recipe/berrypoison
	med_pot = /datum/alch_cauldron_recipe/mana_potion
	minor_pot = /datum/alch_cauldron_recipe/big_mana_potion

//BEGIN THE HERBS

/obj/item/alch/atropa
	name = "atropa"
	icon_state = "atropa"
	sellprice = SELLPRICE_HERB_RARE

	major_pot = /datum/alch_cauldron_recipe/doompoison
	med_pot = /datum/alch_cauldron_recipe/berrypoison
	minor_pot = /datum/alch_cauldron_recipe/stam_poison

/obj/item/alch/matricaria
	name = "matricaria"
	icon_state = "matricaria"
	sellprice = SELLPRICE_HERB_COMMON
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	body_parts_covered = NONE
	w_class = WEIGHT_CLASS_TINY
	alternate_worn_layer  = 8.9 //On top of helmet

	major_pot = /datum/alch_cauldron_recipe/berrypoison
	med_pot = /datum/alch_cauldron_recipe/per_potion
	minor_pot = /datum/alch_cauldron_recipe/doompoison

/obj/item/alch/symphitum
	name = "symphitum"
	icon_state = "symphitum"
	sellprice = SELLPRICE_HERB_UNCOMMON

	major_pot = /datum/alch_cauldron_recipe/health_potion
	med_pot = /datum/alch_cauldron_recipe/stam_poison
	minor_pot = /datum/alch_cauldron_recipe/antidote

/obj/item/alch/taraxacum
	name = "taraxacum"
	icon_state = "taraxacum"
	sellprice = SELLPRICE_HERB_COMMON

	major_pot = /datum/alch_cauldron_recipe/stam_poison
	med_pot = /datum/alch_cauldron_recipe/health_potion
	minor_pot = /datum/alch_cauldron_recipe/antidote

/obj/item/alch/euphrasia
	name = "euphrasia"
	icon_state = "euphrasia"
	sellprice = SELLPRICE_HERB_UNCOMMON

	major_pot = /datum/alch_cauldron_recipe/spd_potion
	med_pot = /datum/alch_cauldron_recipe/stam_poison
	minor_pot = /datum/alch_cauldron_recipe/int_potion

/obj/item/alch/paris
	name = "paris"
	icon_state = "paris"
	sellprice = SELLPRICE_HERB_UNCOMMON

	major_pot = /datum/alch_cauldron_recipe/big_stam_poison
	med_pot = /datum/alch_cauldron_recipe/berrypoison
	minor_pot = /datum/alch_cauldron_recipe/stam_poison

/obj/item/alch/calendula
	name = "calendula"
	icon_state = "calendula"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	body_parts_covered = NONE
	w_class = WEIGHT_CLASS_TINY
	alternate_worn_layer  = 8.9 //On top of helmet

	major_pot = /datum/alch_cauldron_recipe/big_health_potion
	med_pot = /datum/alch_cauldron_recipe/end_potion
	minor_pot = /datum/alch_cauldron_recipe/health_potion

/obj/item/alch/calendula/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/cooking/calenduladry,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/alch/mentha
	name = "mentha"
	icon_state = "mentha"
	sellprice = SELLPRICE_HERB_COMMON

	major_pot = /datum/alch_cauldron_recipe/per_potion
	med_pot = /datum/alch_cauldron_recipe/int_potion
	minor_pot = /datum/alch_cauldron_recipe/stamina_potion

/obj/item/alch/mentha/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/cooking/menthadry,
		/datum/crafting_recipe/roguetown/cooking/menthaappledry,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/alch/urtica
	name = "urtica"
	icon_state = "urtica"
	sellprice = SELLPRICE_HERB_COMMON

	major_pot = /datum/alch_cauldron_recipe/health_potion
	med_pot = /datum/alch_cauldron_recipe/spd_potion
	minor_pot = /datum/alch_cauldron_recipe/stamina_potion

/obj/item/alch/salvia
	name = "salvia"
	icon_state = "salvia"
	sellprice = SELLPRICE_HERB_COMMON
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	body_parts_covered = NONE
	w_class = WEIGHT_CLASS_TINY
	alternate_worn_layer  = 8.9 //On top of helmet

	major_pot = /datum/alch_cauldron_recipe/con_potion
	med_pot = /datum/alch_cauldron_recipe/str_potion
	minor_pot = /datum/alch_cauldron_recipe/end_potion

/obj/item/alch/salvia/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/cooking/salviadry,
		/datum/crafting_recipe/roguetown/cooking/salviavalerianadry,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/alch/hypericum
	name = "hypericum"
	icon_state = "hypericum"
	sellprice = SELLPRICE_HERB_COMMON

	major_pot = /datum/alch_cauldron_recipe/stamina_potion
	med_pot = /datum/alch_cauldron_recipe/big_mana_potion
	minor_pot = /datum/alch_cauldron_recipe/antidote

/obj/item/alch/hypericum/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/cooking/zigardry,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/alch/benedictus
	name = "benedictus"
	icon_state = "benedictus"
	sellprice = SELLPRICE_HERB_UNCOMMON

	major_pot = /datum/alch_cauldron_recipe/big_stamina_potion
	med_pot = /datum/alch_cauldron_recipe/stamina_potion
	minor_pot = /datum/alch_cauldron_recipe/int_potion

/obj/item/alch/valeriana
	name = "valeriana"
	icon_state = "valeriana"
	sellprice = SELLPRICE_HERB_COMMON

	major_pot = /datum/alch_cauldron_recipe/health_potion
	med_pot = /datum/alch_cauldron_recipe/spd_potion
	minor_pot = /datum/alch_cauldron_recipe/stam_poison

/obj/item/alch/valeriana/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/cooking/salviavalerianadry,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/alch/artemisia
	name = "artemisia"
	icon_state = "artemisia"
	sellprice = SELLPRICE_HERB_COMMON

	major_pot = /datum/alch_cauldron_recipe/lck_potion
	med_pot = /datum/alch_cauldron_recipe/spd_potion
	minor_pot = /datum/alch_cauldron_recipe/health_potion

/obj/item/alch/manabloompowder
	name = "manabloom powder"
	icon_state = "bluepowder"
	sellprice = SELLPRICE_ARCANE_DUST_HIGH

	major_pot = /datum/alch_cauldron_recipe/mana_potion
	med_pot = /datum/alch_cauldron_recipe/int_potion
	minor_pot = /datum/alch_cauldron_recipe/big_mana_potion

/obj/item/alch/rosa
	name = "rosa"
	icon_state = "rosa"
	item_state = "rosa"
	desc = "It is said that these were white - until Graggar bled on its fields."
	sellprice = SELLPRICE_HERB_COMMON
	icon = 'icons/roguetown/misc/alchemy.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK|ITEM_SLOT_MOUTH
	body_parts_covered = NONE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	muteinmouth = FALSE
	alternate_worn_layer  = 8.9 //On top of helmet
	mill_result = /obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals
	major_pot = /datum/alch_cauldron_recipe/lck_potion
	med_pot = /datum/alch_cauldron_recipe/antidote
	minor_pot = /datum/alch_cauldron_recipe/restoration_potion

/obj/item/alch/rosa/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_MOUTH)
		icon_state = "rosa_mouth"
		user.update_inv_mouth()
	else
		icon_state = "rosa"
		user.update_icon()

//dust mix crafting
/datum/crafting_recipe/roguetown/alch/feaudust
	name = "feau dust"
	result = list(/obj/item/alch/feaudust,
				/obj/item/alch/feaudust)
	reqs = list(/obj/item/alch/irondust = 2,
				/obj/item/alch/golddust = 1)
	structurecraft = /obj/structure/table/wood
	verbage = "mixes"
	craftsound = 'sound/foley/scribble.ogg'
	skillcraft = /datum/skill/craft/alchemy
	craftdiff = 0

/datum/crafting_recipe/roguetown/alch/magicdust
	name = "pure essentia"
	result = list(/obj/item/alch/magicdust)
	reqs = list(/obj/item/alch/waterdust = 1, /obj/item/alch/firedust = 1,
				/obj/item/alch/airdust = 1, /obj/item/alch/earthdust = 1)
	structurecraft = /obj/structure/table/wood
	verbage = "mixes"
	craftsound = 'sound/foley/scribble.ogg'
	skillcraft = /datum/skill/craft/alchemy
	craftdiff = 0
