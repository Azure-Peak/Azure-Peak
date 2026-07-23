//Lazily shoving all donator fluff items in here for now. Feel free to make this a sub-folder or something, I think it's just easier to keep a list here and just modify as needed.

///////////////////
// UNIVERSAL     //
///////////////////

/obj/item/herbseed/rosa/azure
	name = "azurosa seeds"
	seed_identity = "azurosa seeds"
	makes_herb = /obj/structure/flora/roguegrass/herb/rosa/azure

/obj/item/storage/belt/rogue/pouch/azurosa_seeds
	name = "pouch of azurosa seeds"
	desc = "A pouch that's been filled with seeds of the Azurosa flower, freshly harvested from the highest plateaus of the Azure Peak."
	populate_contents = list(
	/obj/item/herbseed/rosa/azure,
	/obj/item/herbseed/rosa/azure,
	/obj/item/herbseed/rosa/azure,
	/obj/item/herbseed/rosa/azure,
	)

/obj/structure/flora/roguegrass/herb/rosa/azure
	name = "azurosa"
	desc = "A prickly, blueish mutation of the common Rosa found uniquely in the plains of \
	central Azuria, this flower rarely grows upon the Azurian coast. Its sight here means only \
	one thing: a donation from the inner lands."
	icon_state = "azurosa_plant"
	icon = 'icons/obj/items/donor_objects.dmi'

	herbtype = /obj/item/alch/rosa/azure

/obj/item/alch/rosa/azure
	name = "azurosa"
	icon_state = "azurosa"
	item_state = "azurosa"
	desc = "A reminder, hued blue, that happiness is always worth fighting for."
	sellprice = SELLPRICE_HERB_COMMON
	icon = 'icons/obj/items/donor_objects.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK|ITEM_SLOT_MOUTH
	body_parts_covered = NONE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	muteinmouth = FALSE
	alternate_worn_layer  = 8.9 //On top of helmet
	mill_result = /obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals/azure
	major_pot = /datum/alch_cauldron_recipe/lck_potion
	med_pot = /datum/alch_cauldron_recipe/antidote
	minor_pot = /datum/alch_cauldron_recipe/restoration_potion

/obj/item/alch/rosa/azure/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_MOUTH)
		icon_state = "azurosa_mouth"
		user.update_inv_mouth()
	else
		icon_state = "azurosa"
		user.update_icon()

/obj/item/flowercrown/rosa/azure
	name = "crown of azurosa"
	desc = "A crown formed of azurosas, freshly plucked from the plains of central Azuria. Often worn during \
	the many festivals and holidaes that're celebrated throughout the yil, as a sign of pride and propserity."
	icon = 'icons/obj/items/donor_objects.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "azurosa_crown"
	icon_state = "azurosa_crown"

/obj/item/bouquet/rosa/azure
	name = "azurosa bouquet"
	desc = "Azurian affections bundled together in string, most popularly seen in the grand tournmanets that're \
	hosted, every yil, at the summer's solstice. Should a jousting knight successfully catch such a bouquet during \
	their charge, they're surely to be blessed with incoming fortune by a higher power; that, or they might just \
	be particularly dextrous."
	icon = 'icons/obj/items/donor_objects.dmi'
	item_state = "azurosa_bouquet"
	icon_state = "azurosa_bouquet"

/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals/azure
	name = "fresh azurosa petals"
	desc = "Crushed azurosa petals, teeming with a sweet fragrance. Long ago, Azuria's original settlers used these herbs \
	as an antiquated treatment for poisonings and sickness. Though alchemical solutions are more popular nowadaes, those who \
	grew up in Azuria's highest peaks might still remember chewing on these leaves in their youngest yils, to riposte fell humors."
	icon = 'icons/obj/items/donor_objects.dmi'
	icon_state = "azurosa_petal"
	tastes = list("pleasantly mild sweetness" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/medicine/antidote = 2)
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_dried/azure
	name = "dried azurosa petals"
	desc = "Dried azurosa petals, fragrant and fragile. When dried out on a tanning rack and steeped in \
	boiling water for long enough, these petals brew into a bright herbal tea; a cultural delight, commonly \
	served to visiting diplomats and to those who're recovering from both injury-and-malaise alike."
	icon = 'icons/obj/items/donor_objects.dmi'
	icon_state = "azurosa_petal_dry"
	tastes = list("pleasantly mild sweetness" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/medicine/antidote = 2)
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY

/datum/reagent/water/azurosa_tea
	name = "azurosa tea"
	description = "A herbal tea that's been brewed from steeped-and-dried azurosa petals, providing slightly more health regeneration and antidotal properties."
	reagent_state = LIQUID
	color = "#5e50e9"
	taste_description = "pleasantly floral sweetness"
	overdose_threshold = 0
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173

/datum/reagent/water/azurosa_tea/on_mob_life(mob/living/carbon/M)
	. = ..()
	if (M.mob_biotypes & MOB_BEAST)
		M.adjustFireLoss(0.5  * REAGENTS_EFFECT_MULTIPLIER)
	else
		M.adjustBruteLoss(-0.3  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-0.3  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustOxyLoss(-0.3, 0)
		M.adjustToxLoss(-3, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()

/datum/crafting_recipe/roguetown/dryazurrosa
	name = "dry azurosa petals"
	result = /obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_dried/azure
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals/azure = 1)
	structurecraft = /obj/machinery/tanningrack
	time = 2 SECONDS
	verbage_simple = "dry"
	verbage = "dries"
	craftsound = null
	skillcraft = null

/datum/crafting_recipe/roguetown/survival/flowercrown_azurosa
	name = "azurosa crown"
	category = "Clothes"
	result = /obj/item/flowercrown/rosa/azure
	reqs = list(
		/obj/item/alch/rosa/azure = 4,
		/obj/item/natural/fibers = 2,
		)
	craftdiff = 0
	verbage_simple = "tied"
	verbage = "ties"

/datum/crafting_recipe/roguetown/bouquet_azurosa
	name = "azurosa bouquet"
	result = /obj/item/bouquet/rosa/azure
	reqs = list(/obj/item/alch/rosa/azure = 4,
				/obj/item/natural/fibers = 2,
				/obj/item/paper/scroll = 1)
	craftdiff = 0
	verbage_simple = "arranged"
	verbage = "arranges"

//

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/donator
	name = "maillekini"
	desc = "A curious - and particularly revealing - variant of a common maille-aketon. It's said that the intentionally provocative design \
	excels at diverting strikes that'd otherwise pierce the wearer's unprotected regions."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "chainkinis"
	icon_state = "chainkinis"

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/donator
	name = "iron maillekini"
	desc = "A curious - and particularly revealing - variant of an iron maille-aketon. It's said that the intentionally provocative design \
	excels at diverting strikes that'd otherwise pierce the wearer's unprotected regions."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "chainkinii"
	icon_state = "chainkinii"

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/bronze/donator
	name = "bronze maillekini"
	desc = "A curious - and particularly revealing - variant of a bronze maille-aketon. It's said that the intentionally provocative design \
	excels at diverting strikes that'd otherwise pierce the wearer's unprotected regions."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "chainkinib"
	icon_state = "chainkinib"

/obj/item/clothing/cloak/donator_goldmaillekini
	name = "golden maillekini"
	desc = "A curious - and particularly revealing - variant of a common maille-aketon, fashioned from interlinked rings of pure gold. Unlike \
	its iron- and steel-mailled cousins, this regal corset is far too fragile to double as armor; but that's not going to stop you, is it? </br> It \
	feels light enough to be worn above-or-below most garments."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "chainking"
	icon_state = "chainking"
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK

/obj/item/clothing/suit/roguetown/armor/chainmail/donator
	name = "cropped haubergeon"
	desc = "A curious - and particularly revealing - variant of a common maille-garment. It's said that the intentionally provocative design \
	excels at diverting strikes that'd otherwise pierce the wearer's unprotected regions."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	item_state = "cropmailles"
	icon_state = "cropmailles"

/obj/item/clothing/suit/roguetown/armor/chainmail/iron/donator
	name = "cropped iron haubergeon"
	desc = "A curious - and particularly revealing - variant of an iron maille-garment. It's said that the intentionally provocative design \
	excels at diverting strikes that'd otherwise pierce the wearer's unprotected regions."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	item_state = "cropmaillei"
	icon_state = "cropmaillei"

/obj/item/clothing/suit/roguetown/armor/chainmail/bronze/donator
	name = "cropped iron haubergeon"
	desc = "A curious - and particularly revealing - variant of a bronze maille-garment. It's said that the intentionally provocative design \
	excels at diverting strikes that'd otherwise pierce the wearer's unprotected regions."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	item_state = "cropmailleb"
	icon_state = "cropmailleb"

/obj/item/clothing/suit/roguetown/armor/chainmail/donator_elven
	name = "elven haubergeon"
	desc = "An ancestral design, passed down from the oldest of Azuria's native elven inhabitants. The greenish tint present along the leatherbound \
	steel maille is the byproduct of its links being fashioned through magicks, not a forge's heat."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	item_state = "elven_chain"
	icon_state = "elven_chain"

/obj/item/clothing/suit/roguetown/armor/chainmail/iron/donator_elven
	name = "elven haubergeon"
	desc = "An ancestral design, passed down from the oldest of Azuria's native elven inhabitants. The greenish tint present along the leatherbound \
	iron maille is the byproduct of its links being fashioned through magicks, not a forge's heat."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	item_state = "elven_chain"
	icon_state = "elven_chain"

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/donator
	name = "steel heartplate"
	desc = "A curious - and particularly revealing - variant of a common cuirass. It's said that the intentionally provocative design \
	excels at diverting strikes that'd otherwise pierce the wearer's unprotected regions."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "heartplates"
	icon_state = "heartplates"

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/donator
	name = "iron heartplate"
	desc = "A curious - and particularly revealing - variant of an iron cuirass. It's said that the intentionally provocative design \
	excels at diverting strikes that'd otherwise pierce the wearer's unprotected regions."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "heartplatei"
	icon_state = "heartplatei"

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/bronze/donator
	name = "bronze heartplate"
	desc = "A curious - and particularly revealing - variant of a bronze cuirass. It's said that the intentionally provocative design \
	excels at diverting strikes that'd otherwise pierce the wearer's unprotected regions."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "heartplateb"
	icon_state = "heartplateb"

/obj/item/clothing/suit/roguetown/armor/leather/donator
	name = "leather heartplate"
	desc = "A curious - and particularly revealing - variant of a leather vest. It's said that the intentionally provocative design \
	excels at diverting strikes that'd otherwise pierce the wearer's unprotected regions."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "heartplatel"
	icon_state = "heartplatel"

/obj/item/clothing/suit/roguetown/armor/leather/donator_cuirass
	name = "heroic leather cuirass"
	desc = "A flexible vest, stitched together from lengths of cured leather. It hugs the wearer's form, gifting them a mimicked form \
	of a sculpted physique - or maybe that's just a byproduct of it being so damn tight."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "leathercuirass"
	icon_state = "leathercuirass"

/obj/item/clothing/suit/roguetown/armor/leather/heavy/donator_cuirass
	name = "heroic leather cuirass"
	desc = "A flexible vest, stitched together from lengths of cured leather. It hugs the wearer's form, gifting them a mimicked form \
	of a sculpted physique - or maybe that's just a byproduct of it being so damn tight."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "leathercuirass"
	icon_state = "leathercuirass"

/obj/item/clothing/suit/roguetown/armor/leather/studded/donator_cuirass
	name = "heroic leather cuirass"
	desc = "A flexible vest, stitched together from lengths of cured leather. It hugs the wearer's form, gifting them a mimicked form \
	of a sculpted physique - or maybe that's just a byproduct of it being so damn tight."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "leathercuirass"
	icon_state = "leathercuirass"

/obj/item/clothing/suit/roguetown/armor/leather/studded/psyaltrist/donator_cuirass
	name = "heroic leather cuirass"
	desc = "A flexible vest, stitched together from lengths of cured leather. It hugs the wearer's form, gifting them a mimicked form \
	of a sculpted physique - or maybe that's just a byproduct of it being so damn tight."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "leathercuirass"
	icon_state = "leathercuirass"

/obj/item/storage/belt/rogue/leather/donator_steelgirdle
	name = "steel belted plackart"
	desc = "A fine leather belt that carries a pair of segmented steel plates, providing minimal coverage to the lower stomach."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "plackarts"
	icon_state = "plackarts"

/obj/item/storage/belt/rogue/leather/donator_irongirdle
	name = "iron belted plackart"
	desc = "A fine leather belt that carries a pair of segmented iron plates, providing minimal coverage to the lower stomach."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "plackarti"
	icon_state = "plackarti"

/obj/item/storage/belt/rogue/leather/donator_bronzegirdle
	name = "bronze belted plackart"
	desc = "A fine leather belt that carries a pair of segmented bronze plates, providing minimal coverage to the lower stomach."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "plackartb"
	icon_state = "plackartb"

/obj/item/storage/belt/rogue/leather/donator_leathergirdle
	name = "belted plackart"
	desc = "A fine leather belt that's thickly padded at the front and back, providing minimal coverage to the lower stomach."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "plackartleather"
	icon_state = "plackartleather"

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/donator_girdle
	name = "steel plackart"
	desc = "A curious - and particularly revealing - variant of a common cuirass. It's said that the intentionally provocative design \
	excels at diverting strikes that'd otherwise pierce the wearer's unprotected regions."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "plackarts"
	icon_state = "plackarts"

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/donator_girdle
	name = "iron plackart"
	desc = "A curious - and particularly revealing - variant of an iron cuirass. It's said that the intentionally provocative design \
	excels at diverting strikes that'd otherwise pierce the wearer's unprotected regions."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "plackarti"
	icon_state = "plackarti"

/obj/item/clothing/suit/roguetown/armor/leather/donator_girdle
	name = "leather plackart"
	desc = "A curious - and particularly revealing - variant of a common leather cuirass. It's said that the intentionally provocative design \
	excels at diverting strikes that'd otherwise pierce the wearer's unprotected regions."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "plackartleather"
	icon_state = "plackartleather"

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/bronze/donator_girdle
	name = "bronzeplackart"
	desc = "A curious - and particularly revealing - variant of an bronzecuirass. It's said that the intentionally provocative design \
	excels at diverting strikes that'd otherwise pierce the wearer's unprotected regions."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "plackartb"
	icon_state = "plackartb"

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/donator_gothic
	name = "gothic cuirass"
	desc = "A magnificent steel cuirass, assembled by an Azurian mastersmith. The intricate fluting and interlocked plates are clear \
	signs of its Grenzelhoftian heritage; expensive, but second-to-none when it comes to what truly matters in life."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "gcuirass"
	icon_state = "gcuirass"

/obj/item/clothing/suit/roguetown/armor/plate/donator_gothic
	name = "gothic half-plate"
	desc = "A magnificent steel cuirass, fitted with tassets and assembled by an Azurian mastersmith. The intricate fluting \
	and interlocked plates are clear signs of its Grenzelhoftian heritage; expensive, but second-to-none when it comes to what \
	truly matters in life."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	item_state = "ghalfplate"
	icon_state = "ghalfplate"

/obj/item/clothing/suit/roguetown/armor/plate/full/donator_gothic
	name = "gothic plate armor"
	desc = "A magnificent set of steel plate armor, assembled by an Azurian mastersmith. The intricate fluting \
	and interlocked plates are clear signs of its Grenzelhoftian heritage; expensive, but second-to-none when it comes to what \
	truly matters in life."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	item_state = "gplate"
	icon_state = "gplate"

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/donator_gothic
	name = "gothic plate-and-maille"
	desc = "A magnificent steel cuirass, fitted atop a hauberk and assembled by an Azurian mastersmith. The intricate fluting \
	and interlocked plates are clear signs of its Grenzelhoftian heritage; expensive, but second-to-none when it comes to what \
	truly matters in life."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	item_state = "gcuirasshauberk"
	icon_state = "gcuirasshauberk"

/datum/crafting_recipe/roguetown/survival/gothicmailledhauberk
	name = "layer a gothic cuirass atop hauberk"
	result = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/donator_gothic)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/donator_gothic = 1,
	            /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 1)
	craftdiff = 0
	req_table = TRUE
	bypass_dupe_test = TRUE

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/donator_gothic
	name = "gothic iron cuirass"
	desc = "A magnificent iron cuirass, assembled by an Azurian mastersmith. The intricate fluting and interlocked plates are clear \
	signs of its Grenzelhoftian heritage; expensive, but second-to-none when it comes to what truly matters in life."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "igcuirass"
	icon_state = "igcuirass"

/obj/item/clothing/suit/roguetown/armor/plate/iron/donator_gothic
	name = "gothic iron half-plate"
	desc = "A magnificent iron cuirass, fitted with tassets and assembled by an Azurian mastersmith. The intricate fluting \
	and interlocked plates are clear signs of its Grenzelhoftian heritage; expensive, but second-to-none when it comes to what \
	truly matters in life."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "ighalfplate"
	icon_state = "ighalfplate"

/obj/item/clothing/suit/roguetown/armor/plate/full/iron/donator_gothic
	name = "gothic iron plate armor"
	desc = "A magnificent set of iron plate armor, assembled by an Azurian mastersmith. The intricate fluting \
	and interlocked plates are clear signs of its Grenzelhoftian heritage; expensive, but second-to-none when it comes to what \
	truly matters in life."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	item_state = "igplate"
	icon_state = "igplate"

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/donator_gothic
	name = "gothic iron plate-and-maille"
	desc = "A magnificent iron cuirass, fitted atop a hauberk and assembled by an Azurian mastersmith. The intricate fluting \
	and interlocked plates are clear signs of its Grenzelhoftian heritage; expensive, but second-to-none when it comes to what \
	truly matters in life."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	item_state = "igcuirasshauberk"
	icon_state = "igcuirasshauberk"

/datum/crafting_recipe/roguetown/survival/gothicironmailledhauberk
	name = "layer a gothic iron cuirass atop hauberk"
	result = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/donator_gothic)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/donator_gothic = 1,
	            /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron = 1)
	craftdiff = 0
	req_table = TRUE
	bypass_dupe_test = TRUE

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/donator
	name = "steel heartplate"
	desc = "A curious - and particularly revealing - variant of a common cuirass. It's said that the intentionally provocative design \
	excels at diverting strikes that'd otherwise pierce the wearer's unprotected regions."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "heartplates"
	icon_state = "heartplates"

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/donator_girdle
	name = "steel plackart"
	desc = "A curious - and particularly revealing - variant of a common cuirass. It's said that the intentionally provocative design \
	excels at diverting strikes that'd otherwise pierce the wearer's unprotected regions."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "plackarts"
	icon_state = "plackarts"

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/donator_gothic
	name = "gothic fencing cuirass"
	desc = "A magnificent steel cuirass, assembled by an Azurian mastersmith. The intricate fluting and interlocked plates are clear \
	signs of its Grenzelhoftian heritage; expensive, but second-to-none when it comes to what truly matters in life."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "gcuirass"
	icon_state = "gcuirass"

/obj/item/storage/belt/rogue/leather/donator
	name = "belt of caped leathers"
	desc = "A fine leather belt that's been decorated with a skirt of thin leather strips."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "leatherbases"
	icon_state = "leatherbases"

/obj/item/storage/belt/rogue/leather/donator_fur
	name = "belt of caped fur"
	desc = "A fine leather belt that's been decorated with a skirt of well-groomed fur."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "furbases"
	icon_state = "furbases"

/obj/item/storage/belt/rogue/leather/donator_steel
	name = "belt of maille"
	desc = "A fine leather belt that's been decorated with a skirt of steel chainmail."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "chainbases"
	icon_state = "chainbases"

/obj/item/storage/belt/rogue/leather/donator_iron
	name = "belt of iron maille"
	desc = "A fine leather belt that's been decorated with a skirt of iron chainmail."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "chainbasei"
	icon_state = "chainbasei"

/obj/item/storage/belt/rogue/leather/donator_bronze
	name = "belt of bronze maille"
	desc = "A fine leather belt that's been decorated with a skirt of bronze chainmail."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	item_state = "chainbaseb"
	icon_state = "chainbaseb"

/obj/item/clothing/suit/roguetown/armor/plate/full/donator_triheartfelt
	name = "azurian plate armor"
	desc = "A complete set of Heartfeltian-styled plate armor, decorated with a furred coif and a silk robe that's been dyed with \
	dried azurosa powder. Most intimately associated with Azuria's diplomats and champions, these suits are traditionally restricted \
	to the battlefields of garish noble courtrooms and balls."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	item_state = "triheartfelt"
	icon_state = "triheartfelt"

/obj/item/clothing/wrists/roguetown/bracers/armharness
	name = "plate arm harness"
	desc = "A pair of interlocked steel plate arm harnesses, composed of pauldrons, rerebraces, couters, and vambraces - all snugly latched around the limb and secured to one another thanks to a series of leather straps, metal aglets, and sliding rivets. The engineering is so meticulous that flexibility of the limb is hardly impeded."
	item_state = "armharness"
	icon_state = "armharness"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'

/obj/item/clothing/head/roguetown/decoration/orle
	name = "noble striped decoration"
	desc = "A delicate weaving of colored fabric, intended to be worn atop a helmet; a touch of elegance, indiscriminate of the alloy."
	item_state = "d_stripes"
	icon_state = "d_stripes"
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	worn_offsets = list("x" = 0, "y" = 7) // Allows for dynamic offsets, so that headpieces normally requiring a 64x .dmi can fit in a 32x .dmi.
	color = null

	//Originally found in icons/roguetown/topadd/johnie/noldor.dmi. Full credit to Johnie, who - from what I might guess - was a very early contributor to Roguetown. Hi!
	//Hatcheted implementation. If someone ever finds out how to use onmob offsets, use the sprites in onmob/donor_clothes with an offset of +7 Y instead.______qdel_list_wrapper(list/L)

/obj/item/clothing/head/roguetown/decoration/orle/donator_oathkeeper
	name = "oathkeeper's noble decoration"
	desc = "A delicate weaving of colored fabric, intended to be worn atop a helmet; a touch of elegance, indiscriminate of the alloy. This weave is crested with a \
	golden winged shield; an unofficial coat-of-arms used to represent Azuria's many noble houses. To wear such garments is to command respect from those that've come after you; hopefully, not undue."
	item_state = "d_oathtaker"
	icon_state = "d_oathtaker"
	worn_offsets = list("x" = 0, "y" = 7) // X is a horizontal offset, Y is a vertical offset. In this case, it's offset to be seven pixels north.
	alternate_worn_layer = 8.9

/obj/item/clothing/head/roguetown/decoration/orle/donator_dyeable
	name = "orle"
	desc = "A delicate weaving of striped fabric, intended to be dyed in contrasting colors and worn atop a helmet. Perfect for tournaments."
	item_state = "orle"
	icon_state = "orle"
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	detail_color = CLOTHING_SCARLET
	altdetail_color = CLOTHING_AZUROSA

/obj/item/clothing/head/roguetown/decoration/orle/donator_dyeable/Initialize()
	. = ..()
	update_icon()

/obj/item/clothing/head/roguetown/decoration/orle/donator_dyeable/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)
	if(get_altdetail_tag())
		var/mutable_appearance/pic2 = mutable_appearance(icon(icon, "[icon_state][altdetail_tag]"))
		pic2.appearance_flags = RESET_COLOR
		if(get_altdetail_color())
			pic2.color = get_altdetail_color()
		add_overlay(pic2)

/obj/item/clothing/head/roguetown/decoration/greatplume
	name = "helmet's greatplume"
	desc = "A magnificent plume, intended to be worn atop a helmet; a touch of flamboyance, indiscriminate of the alloy."
	item_state = "greatplume" //Won't look perfect on some helmets (due to the lack of direction-specific clipping), but it'll do.
	icon_state = "greatplume"
	slot_flags = ITEM_SLOT_HEAD //Not designed to be worn outside of a helmet's cosmetic inventory. Going to see how this goes.
	worn_offsets = list("x" = 0, "y" = 2)
	color = null

/obj/item/clothing/cloak/tabard/stabard/donator_shoulderguard
	name = "ecranche"
	desc = "An alloyed shoulderguard, strapped to the shoulder. While traditionally fielded in tournaments to serve as protective targets for \
	jousts on saigaback, it isn't uncommon to see them fielded in battle as well - though the effectiveness is dubious, at best."
	item_state = "shoulderguard"
	icon_state = "shoulderguard"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	color = null
	custom_design = TRUE
	slot_flags = ITEM_SLOT_HEAD | ITEM_SLOT_CLOAK
	storage = FALSE
	grid_width = 32
	grid_height = 32

/obj/item/clothing/cloak/tabard/stabard/donator_oathkeeper
	name = "oathkeeper's noble surcoat"
	icon_state = "oa_fancy_short"
	icon_state = "oa_fancy_short"
	desc = "An elegant surcoat, toned in cadence with the unofficial coat-of-arms that's used to represent Azuria's many noble houses. One shoulder is decorated with a golden-laced \
	sleeve, while the other supports a small ecranche. To wear such garments is to command respect from those that've come after you; hopefully, not undue."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	color = null
	custom_design = TRUE

/obj/item/clothing/cloak/tabard/stabard/surcoat/donator_oathkeeper
	name = "oathkeeper's noble jupon"
	icon_state = "oa_fancy_long"
	icon_state = "oa_fancy_long"
	desc = "An elegant jupon, toned in cadence with the unofficial coat-of-arms that's used to represent Azuria's many noble houses. One shoulder is decorated with a golden-laced \
	sleeve, while the other supports a small ecranche. To wear such garments is to command respect from those that've come after you; hopefully, not undue."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	color = null
	custom_design = TRUE

/obj/item/clothing/shoes/roguetown/simpleshoes/heels
	name = "high-heeled shoes"
	desc = "Elegant shoes that're lightly elevated in the rear, providing a distinctive 'click' with each step. Allegedly, it's \
	quite the fashion statement in Heartfelt's noble galas - a sentiment yet to be fully appreciated by Azuria's own."
	icon_state = "heels"
	item_state = "heels"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	detail_tag = "_detail"
	color = "#FFFFFF"
	detail_color = "#FFFFFF"
	var/picked = FALSE

/obj/item/clothing/shoes/roguetown/simpleshoes/heels/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "Choose a color.", "Uniform colors") as anything in COLOR_MAP
		var/playerchoice = COLOR_MAP[choice]
		picked = TRUE
		detail_color = playerchoice
		detail_tag = "_detail"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_armor()
			H.update_icon()

/obj/item/clothing/shoes/roguetown/simpleshoes/heels/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_HEELS, 2)
	stepnoise_flag = STEPNOISE_HEELS // This will prevent default footstep noise from being made by the heels (sounds odd)

/obj/item/clothing/shoes/roguetown/simpleshoes/heels/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/shoes/roguetown/simpleshoes/heels/donator_gold
	name = "high-heeled golden shoes"
	desc = "Gold-laced shoes that're lightly elevated in the rear, providing a distinctive 'click' with each step. Allegedly, it's \
	quite the fashion statement in Heartfelt's noble galas - a sentiment yet to be fully appreciated by Azuria's own."
	icon_state = "goldheels"
	item_state = "goldheels"

/obj/item/clothing/shoes/roguetown/simpleshoes/heels/donator_silver
	name = "high-heeled silver shoes"
	desc = "Silver-laced shoes that're lightly elevated in the rear, providing a distinctive 'click' with each step. Allegedly, it's \
	quite the fashion statement in Heartfelt's noble galas - a sentiment yet to be fully appreciated by Azuria's own."
	icon_state = "silverheels"
	item_state = "silverheels"

/obj/item/clothing/mask/rogue/facemask/donator
	name = "jade halfmask"
	desc = "An intimidating mandible, chiseled from jade and decorated with indeterminable alloys. It is smiling back at you with eternal malice."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	icon_state = "elegantjademask"
	item_state = "elegantjademask"
	smeltresult = /obj/item/ingot/jadeslag

/obj/item/clothing/mask/rogue/facemask/steel/donator
	name = "jade halfmask"
	desc = "An intimidating mandible, chiseled from jade and decorated with indeterminable alloys. It is smiling back at you with eternal malice."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	icon_state = "elegantjademask"
	item_state = "elegantjademask"
	smeltresult = /obj/item/ingot/jadeslag

/obj/item/clothing/mask/rogue/facemask/bronze/donator
	name = "jade halfmask"
	desc = "An intimidating mandible, chiseled from jade and decorated with indeterminable alloys. It is smiling back at you with eternal malice."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	icon_state = "elegantjademask"
	item_state = "elegantjademask"
	smeltresult = /obj/item/ingot/jadeslag

/obj/item/clothing/mask/rogue/facemask/carved/jademask/donator
	name = "jade halfmask"
	desc = "An intimidating mandible, chiseled from jade and decorated with indeterminable alloys. It is smiling back at you with eternal malice."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	icon_state = "elegantjademask"
	item_state = "elegantjademask"
	smeltresult = /obj/item/ingot/jadeslag

/obj/item/clothing/suit/roguetown/shirt/doublet
	name = "doublet"
	desc = "A snug-fitting tunic, favored by Azurians during the chillier daes of autumn."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	icon_state = "doublet"
	item_state = "doublet"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	body_parts_covered = CHEST|VITALS

/obj/item/clothing/suit/roguetown/shirt/apothshirt/donator
	name = "doublet"
	desc = "A snug-fitting tunic, favored by Azurians during the chillier daes of autumn. It has been dyed with a pale, green tone."

//

/obj/item/rogueweapon/huntingknife/idagger/steel/donator
	name = "cackledagger"
	desc = "A curious iteration of the steel dagger, fitted with a wooden handle that's been carved in mimicry of a certain anatomical feature. While \
	no one's quite sure as to where this design originated from, one thing's clear; it's not fit to be wielded by the faint-hearted."
	icon_state = "bollockdagger"
	sheathe_icon = "bollockdagger"
	icon = 'icons/obj/items/donor_weapons.dmi'

/obj/item/rogueweapon/huntingknife/idagger/steel/decorated/donator
	name = "decorated cackledagger"
	desc = "A decorated iteration of the steel dagger, fitted with a wooden handle that's been carved in mimicry of a certain anatomical feature. While \
	no one's quite sure as to where this design originated from, one thing's clear; it's not fit to be wielded by the faint-hearted."
	icon_state = "decbollockdagger"
	sheathe_icon = "decbollockdagger"
	icon = 'icons/obj/items/donor_weapons.dmi'

/obj/item/rogueweapon/donator_longsword
	name = "elegant longsword"
	desc = "A lethal and perfectly balanced weapon, endowed with regional flair. The longsword is the protagonist of endless tales and myths \
	all across Psydonia, seen in the hands of noblemen and an ever-decreasing quantity of master duelists. \
	It has great cultural significance in the empires of Grenzelhoft and Etrusca, where legendary swordsmen \
	have created and perfected many fighting techniques of todae."
	icon_state = "longswordalt"
	sheathe_icon = "longswordalt"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	bigboy = TRUE

//

/obj/item/rogueweapon/stoneaxe/woodcut/steel/donator_elegant
	name = "elegant axe"
	desc = "An elegant axe for an elegant wielder."
	icon_state = "donator_axe"
	icon = 'icons/obj/items/donor_weapons.dmi'

/obj/item/rogueweapon/stoneaxe/battle/donator_elegant
	name = "elegant battle axe"
	desc = "An elegant battle axe for an elegant wielder."
	icon_state = "donator_battleaxe"
	icon = 'icons/obj/items/donor_weapons.dmi'

/obj/item/rogueweapon/mace/steel/donator_elegant
	name = "elegant mace"
	desc = "An elegant mace for an elegant wielder."
	icon_state = "donator_mace"
	icon = 'icons/obj/items/donor_weapons.dmi'

/obj/item/rogueweapon/mace/steel/silver/donator_elegant
	name = "elegant bar mace"
	desc = "An elegant bar mace for an elegant wielder."
	icon_state = "donator_barmace"
	icon = 'icons/obj/items/donor_weapons.dmi'

/obj/item/rogueweapon/mace/warhammer/steel/donator_elegant
	name = "elegant warhammer"
	desc = "An elegant warhammer for an elegant wielder."
	icon_state = "donator_hammer"
	icon = 'icons/obj/items/donor_weapons.dmi'

/obj/item/rogueweapon/flail/sflail/donator_elegant
	name = "elegant flail"
	desc = "An elegant flail for an elegant wielder."
	icon_state = "donator_flail"
	icon = 'icons/obj/items/donor_weapons.dmi'

/obj/item/rogueweapon/huntingknife/idagger/steel/donator_elegant
	name = "elegant dagger"
	desc = "An elegant dagger for an elegant wielder."
	icon_state = "donator_dagger"
	sheathe_icon = "donator_dagger"
	icon = 'icons/obj/items/donor_weapons.dmi'

/obj/item/rogueweapon/huntingknife/idagger/steel/decorated/donator_elegant
	name = "elegantly decorated dagger"
	desc = "An elegantly decorated dagger for an elegantly decorated wielder."
	icon_state = "donator_decdagger"
	sheathe_icon = "donator_decdagger"
	icon = 'icons/obj/items/donor_weapons.dmi'

/obj/item/rogueweapon/katar/donator_elegant
	name = "elegant handblade"
	desc = "An elegant handblade for an elegant wielder."
	icon_state = "donatorkatarclaw"
	icon = 'icons/obj/items/donor_weapons.dmi'

/obj/item/rogueweapon/sword/donator_elegant
	name = "elegant sword"
	desc = "An elegant sword for an elegant wielder."
	icon_state = "donator_sword"
	sheathe_icon = "donator_sword"
	icon = 'icons/obj/items/donor_weapons.dmi'

/obj/item/rogueweapon/sword/decorated/donator_elegant
	name = "elegantly decorated sword"
	desc = "An elegantly decorated sword for an elegantly decorated wielder."
	icon_state = "donator_decsword"
	sheathe_icon = "donator_decsword"
	icon = 'icons/obj/items/donor_weapons.dmi'

/obj/item/rogueweapon/sword/short/donator_elegant
	name = "elegant shortsword"
	desc = "An elegant shortsword for an elegant wielder."
	icon_state = "donator_messer"
	sheathe_icon = "donator_messer"
	icon = 'icons/obj/items/donor_weapons.dmi'

/obj/item/rogueweapon/sword/short/messer/donator_elegant
	name = "elegant messer"
	desc = "An elegant messer for an elegant wielder."
	icon_state = "donator_messer"
	sheathe_icon = "donator_messer"
	icon = 'icons/obj/items/donor_weapons.dmi'

/obj/item/rogueweapon/sword/sabre/donator_elegant
	name = "elegant sabre"
	desc = "An elegant sabre for an elegant wielder."
	icon_state = "donator_sabre"
	sheathe_icon = "donator_sabre"
	icon = 'icons/obj/items/donor_weapons.dmi'

/obj/item/rogueweapon/halberd/donator_elegant
	name = "elegant halberd"
	desc = "An elegant halberd for an elegant wielder."
	icon_state = "donator_halberd"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	bigboy = TRUE

/obj/item/rogueweapon/spear/lance/donator_elegant
	name = "elegant lance"
	desc = "An elegant lance for an elegant wielder."
	icon_state = "donator_lance"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	bigboy = TRUE

/obj/item/rogueweapon/eaglebeak/donator_elegant
	name = "elegant polehammer"
	desc = "An elegant polehammer for an elegant wielder."
	icon_state = "donator_eaglebeak"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	bigboy = TRUE

/obj/item/rogueweapon/greataxe/steel/donator_elegant
	name = "elegant greataxe"
	desc = "An elegant greataxe for an elegant wielder."
	icon_state = "donator_greataxe"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	bigboy = TRUE

/obj/item/rogueweapon/sword/rapier/donator_elegant
	name = "elegant rapier"
	desc = "An elegant rapier for an elegant wielder."
	icon_state = "donatorrapier"
	sheathe_icon = "donatorrapier"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	bigboy = TRUE

/obj/item/rogueweapon/sword/rapier/dec/donator_elegant
	name = "elegantly decorated rapier"
	desc = "An elegant rapier for an elegantly decorated wielder."
	icon_state = "donatordecrapier"
	sheathe_icon = "decrapier"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	bigboy = TRUE

/obj/item/rogueweapon/sword/long/donator_elegant
	name = "elegant longsword"
	desc = "An elegant longsword for an elegant wielder."
	icon_state = "donatorlongsword"
	sheathe_icon = "donatorlongsword"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	bigboy = TRUE

/obj/item/rogueweapon/woodstaff/quarterstaff/steel/donator_elegant
	name = "elegant quarterstaff"
	desc = "An elegant quarterstaff for an elegant wielder."
	icon_state = "quarterstaff_donator"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	bigboy = TRUE

/obj/item/rogueweapon/sword/long/dec/donator_elegant
	name = "elegantly decorated longsword"
	desc = "An elegantly decorated longsword for an elegantly decorated wielder."
	icon_state = "donatordeclongsword"
	sheathe_icon = "donatordeclongsword"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	bigboy = TRUE

/obj/item/rogueweapon/spear/boar/donator_elegant
	name = "elegant spear"
	desc = "An elegant spear for an elegant wielder."
	icon_state = "donatorspear"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	bigboy = TRUE

/obj/item/rogueweapon/mace/goden/steel/donator_elegant
	name = "elegant grand mace"
	desc = "Good morrow, sire."
	icon_state = "donatorgmace"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	bigboy = TRUE

/obj/item/rogueweapon/shield/tower/metal/donator_elegant
	name = "elegant kite shield"
	desc = "An elegant kite shield for an elegant wielder."
	icon_state = "donatorsh"
	icon = 'icons/obj/items/donor_weapons.dmi'

/obj/item/clothing/gloves/roguetown/knuckles/donator_elegant
	name = "elegant knuckles"
	desc = "An elegant pair of knuckledusters for an elegant wielder."
	icon_state = "donator_knuckle"
	icon = 'icons/obj/items/donor_weapons.dmi'

/obj/item/rogueweapon/greatsword/donator_elegant
	name = "elegant greatsword"
	desc = "An elegant greatsword for an elegant wielder."
	icon_state = "donatorgreatsword"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	bigboy = TRUE

/obj/item/rogueweapon/sword/long/exe/donator_elegant
	name = "elegant executioner's sword"
	desc = "An elegant executioner's sword for an elegant headsman."
	icon_state = "donatorexesword"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	bigboy = TRUE

//

/obj/item/rogueweapon/donator_imbuedlongsword
	name = "imbued longsword"
	desc = "A lethal and perfectly balanced weapon, imbued with decorative flair. The longsword is the protagonist of endless tales and myths \
	all across Psydonia, seen in the hands of noblemen and an ever-decreasing quantity of master duelists. \
	It has great cultural significance in the empires of Grenzelhoft and Etrusca, where legendary swordsmen \
	have created and perfected many fighting techniques of todae."
	icon_state = "longswordaltred"
	sheathe_icon = "longswordaltred"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	bigboy = TRUE

/obj/item/rogueweapon/example/donator_elegant_whip
	name = "elegant whip"
	desc = "An elegant whip for an elegant wielder."
	icon_state = "donator_whip"
	icon = 'icons/obj/items/donor_weapons.dmi'

/obj/item/rogueweapon/example/donator_elegant_urumi
	name = "elegant urumi"
	desc = "An elegant urumi for an elegant wielder."
	icon_state = "donator_urumi"
	icon = 'icons/obj/items/donor_weapons.dmi'

/obj/item/rogueweapon/sword/donator_smallsword
	name = "smallsword"
	desc = "A thinner and lighter relative to the rapier, oft-carried upon the hips of nobility as a sidearm for the courts. Don't mistake the \
	sleekness, however; it's still an armor-piercing length of steel, at the end of the dae."
	icon_state = "smallsword"
	sheathe_icon = "smallsword"
	icon = 'icons/obj/items/donor_weapons.dmi'
	dropshrink = null
	max_blade_int = 230
	possible_item_intents = list(/datum/intent/sword/thrust/rapier, /datum/intent/sword/cut/rapier, /datum/intent/sword/thrust/rapier/lunge)
	gripped_intents = null
	special = /datum/special_intent/piercing_lunge
	parrysound = list(
		'sound/combat/parry/bladed/bladedthin (1).ogg',
		'sound/combat/parry/bladed/bladedthin (2).ogg',
		'sound/combat/parry/bladed/bladedthin (3).ogg',
		)
	swingsound = BLADEWOOSH_SMALL
	minstr = 6
	wdefense = 7
	wbalance = WBALANCE_SWIFT

/obj/item/rogueweapon/example/donator_grenzshortsword
	name = "katzbalger"
	desc = "A wide-bladed shortsword with a winding handguard, not unlike a rapier in terms of presentation. Famously carried on the hips \
	of Grenzelhoftian mercenaries and career-soldiers, yet seldom drawn."
	icon_state = "katzbalger"
	sheathe_icon = "katzbalger"
	icon = 'icons/obj/items/donor_weapons.dmi'

///////////////////
// CKEY SPECIFIC //
///////////////////
//Plexiant's donator item - rapier
/obj/item/rogueweapon/sword/rapier/aliseo
	name = "Rapier di Aliseo"
	desc = "A rapier of sporting a steel blade and decrotive silver-plating. Elaborately designed in classic intricate yet functional Etrucian style, the pummel appears to be embedded with a cut emerald with a family crest engraved in the fine leather grip of the handle."
	icon_state = "plex"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

//Ryebread's donator item - estoc
/obj/item/rogueweapon/estoc/worttrager
	name = "Wortträger"
	desc = "An imported Grenzelhoftian panzerstecher, a superbly crafted implement devoid of armory marks- merely bearing a maker's mark and the Zenitstadt seal. This one has a grip of walnut wood, and a pale saffira set within the crossguard. The ricasso is engraved with Ravoxian scripture."
	icon_state = "mansa"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

//Srusu's donator item - dress
/obj/item/clothing/suit/roguetown/shirt/dress/emerald
	name = "emerald dress"
	desc = "A silky smooth emerald-green dress, only for the finest of ladies."
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR	//Goes either slot, no armor on it after all.
	icon_state = "laciedress"
	sleevetype = "laciedress"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'

/obj/item/clothing/head/roguetown/circlet/saffiratiara
	name = "saffira encrusted tiara"
	desc = "An ornate gold tiara, inset with a Saffira in its peak."
	icon_state = "eekasqueak"
	item_state = "eekasqueak"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

//Funkymonke's donator item - dress
/obj/item/clothing/suit/roguetown/shirt/dress/funkydress
	name = "padded dress"
	desc = "A trimmed down version of a would be protective dress."
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon_state = "funkydress"
	sleevetype = "funkydress"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'

//Strudles donator item - mage vest, xylix tabard, etruscan cloak, and formfitted gambeson
/obj/item/clothing/cloak/tabard/stabard/surcoat/sofiavest
	name = "grenzelhoftian mages vest"
	desc = "A vest often worn by those of the Grenzelhoftian mages college."
	icon_state = "sofiavest"
	item_state = "sofiavest"
	sleevetype = "sofiavest"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_CLOAK|ITEM_SLOT_ARMOR
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	flags_inv = HIDEBOOB
	color = null
	nodismemsleeves = TRUE // prevents sleeves from being torn

/obj/item/clothing/cloak/templar/xylixian/faux
	name = "xylixian fasching leotard"
	desc = "Look at you! Swing and Jingle your hips, maybe even crack some whips. Today is going to be a fun day!"
	icon_state = "fauxoutfit"
	item_state = "fauxoutfit"
	alternate_worn_layer = TABARD_LAYER
	boobed = FALSE
	flags_inv = HIDECROTCH|HIDEBOOB
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_CLOAK|ITEM_SLOT_ARMOR
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = null
	nodismemsleeves = TRUE
	color = CLOTHING_DARK_GREY
	detail_tag = "_detail"
	detail_color = CLOTHING_WHITE

/obj/item/clothing/cloak/poncho/dittocloak
	name = "etruscan design cloak"
	desc = "A overly fancy and nicely designed Cloak with what appears to be Etruscan silks. Looks expensive."
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	adjustable = CAN_CADJUST
	alternate_worn_layer = 9.9 // okay look this is weird but its to cover hair :)
	color = CLOTHING_WHITE
	detail_color = CLOTHING_WHITE
	altdetail_color = CLOTHING_WHITE
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	icon_state = "dittocloak"
	item_state = "dittocloak"
	sleevetype = "dittocloak"
	nodismemsleeves = TRUE

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/strudels
	name = "form-fitting padded gambeson"
	desc = "A normal looking padded gambeson that seems to have been custom fitted to a specific body for more comfort."
	icon_state = "formfit"
	item_state = "formfit"
	color = "#ffffff"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

//Bat's donator item - custom harp sprite
/obj/item/rogue/instrument/harp/handcarved
	name = "handcrafted harp"
	desc = "A handcrafted harp."
	icon_state = "batharp"
	icon = 'icons/obj/items/donor_objects.dmi'

//Rebel0's donator item - visored sallet with a hood on under it. (Same as normal sallet)
/obj/item/clothing/head/roguetown/helmet/sallet/visored/gilded
	name = "gilded visored sallet"
	desc = "A steel helmet with gilded trim which protects the ears, nose, and eyes."
	icon_state = "gildedsallet_visor"
	item_state = "gildedsallet_visor"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

//Bigfoot's donator item - knight helmet with gilded pattern
/obj/item/clothing/head/roguetown/helmet/heavy/knight/gilded
	name = "gilded knight's helmet"
	desc = "A noble knight's helm made of steel and completed with a gilded trim."
	icon_state = "gildedknight"
	item_state = "gildedknight"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

/obj/item/clothing/head/roguetown/helmet/heavy/knight/gilded/attackby(obj/item/W, mob/living/user, params)
	..()
	if(!(istype(W, /obj/item/natural/feather) && !detail_tag))
		return
	user.visible_message(span_warning("[user] adds [W] to [src]."))
	user.transferItemToLoc(W, src, FALSE, FALSE)
	detail_tag = "_detail"
	update_icon()
	if(loc == user && ishuman(user))
		var/mob/living/carbon/H = user
		H.update_inv_head()

//Bigfoot's donator item - steel great axe with gilded pattern
/obj/item/rogueweapon/greataxe/steel/gilded
	name = "Aureline"
	desc = "An axe crafted of carefully forged steel, this weapon bears the mark of many hours toiling over a forge.  \
	Inlaid with gold patterns depicting a side-facing griffon with interwoven vines of fabric trailing in a curve along the centre of the axe.   \
	The axe head itself is a more darkened metal save for the edge of the blade itself, a strip of curved, deadly silver against the black and gold of the rest of the axe.   \
	Not a single flaw is to be found in the metal itself, no matter how many times it is brought to wielded; not a chip in the blade nor loss of its bite.   \
	Evidently it is a very well cared for piece. \n\
	\n\
	The handle itself is no less impressive, made of a darkened heartwood and banded with gold-appearing steel to both fasten the weapon and provide contrast along the bottom and top.  \
	Inlaid at the bottom most band is the sigil of House Xulu, a long ago served house that is carried in remembrance of an Oath he is now released from."
	icon_state = "orin"
	icon = 'icons/obj/items/donor_weapons_64.dmi'


//Zydras donator items - ironclad baddie
/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/zycuirass
	name = "iron gardbrace and fauld"
	desc = "An aged piece of damaged mailled cuirass, with only its skirt and a spiked shoulder remaining. It glimmers with a reddish hue."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	icon_state = "zy_cuirass"
	item_state = "zy_cuirass"
	sleevetype = "zy_cuirass"
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'

/obj/item/rogueweapon/greataxe/zygreataxe
	name = "Bourreau"
	desc = "This Greataxe has seen better days. It will see even worse ones, by the looks of its wielder."
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	icon_state = "zy_greataxe"


/obj/item/clothing/suit/roguetown/armor/longcoat/eiren //Longcoat has no armor, ignore the /armor/ path.
	name = "Darkwood's Embrace"
	desc = "A tough leather coat, taken from one of the few remaining arcyne studies of Lord Darkwood. Ancient, but in remarkably good condition as the weight of memory and sin tries to drag you down."
	sleeved = TRUE
	icon = 'icons/clothing/donor_clothes.dmi'
	icon_state = "eirencoat"
	item_state = "eirencoat"
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	sleevetype = "eirencoat"
	detail_tag = "_detail"
	detail_color = CLOTHING_RED
	color = CLOTHING_WHITE
	boobed = FALSE

/obj/item/clothing/suit/roguetown/armor/longcoat/eiren/Initialize()
	. = ..()
	update_icon()

/obj/item/clothing/suit/roguetown/armor/longcoat/eiren/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/rogueweapon/eirenxiv/eiren_m
	name = "glintstone longsword"
	desc = "A glimmering blade, forged from a blue-white ore found rarely within the duchy of Azuria. Identical to steel in its properties, the tempering process to preserve the blue sheen is extensive and time consuming."
	icon_state = "eiren_m"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	sheathe_icon = "eiren_m"
	bigboy = TRUE

/obj/item/rogueweapon/eirenxiv/eirensword
	name = "stygian longsword"
	desc = "A finely crafted steel longsword, its design perfectly combining elegance and practicality. Quenched in white oil, refined by the dwarves of Hammerhold, the blade holds a darker hue than usual."
	icon_state = "eirensword"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	sheathe_icon = "eirensword"
	bigboy = TRUE

/obj/item/clothing/head/roguetown/duelhat/pretzel
	name = "rethrifted gravedigger's hat"
	desc = "A gravetender's dark leather slouch, refitted with a golden dragon-sigil. Who needs a steel skullcap when you have dumb luck? <br> \
	\"You ever feel like nothin' good was ever gonna happen to you?\" <br> \
	\"Yeah, and nothin' did. So what?\""
	color = null
	icon_state = "pretzel_stolenhat"
	item_state = "pretzel_stolenhat"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'


// ZoeTheOrc
/obj/item/clothing/cloak/raincloak/feather_cloak
	name = "Shroud of the Undermaiden"
	desc = "A fine cloak made from the feathers of Necra's servants, each gifted to a favoured child of the Lady of Veils. While it offers no physical protection, perhaps it ensures that the Undermaiden's gaze is never far from its wearer..."
	icon_state = "feather_cloak"
	item_state = "feather_cloak"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	boobed = FALSE
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	sleevetype = "feather_cloak"
	hoodtype = /obj/item/clothing/head/hooded/rainhood/feather_hood

/obj/item/clothing/head/hooded/rainhood/feather_hood
	name = "feather hood"
	desc = "This one will shelter me from the weather and my identity too."
	icon_state = "feather_hood"
	item_state = "feather_hood"
	slot_flags = ITEM_SLOT_HEAD
	dynamic_hair_suffix = ""
	edelay_type = 1
	body_parts_covered = HEAD
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDETAIL
	block2add = FOV_BEHIND
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

/obj/item/clothing/suit/roguetown/armor/longcoat/wyrd_cloak
	name = "Cloak of the Wyrd"
	desc = "Sewn by ways unknown to the land, what may have been garbs fitting for royalty once now lays aged beyond measure. However, it would surely provide much needed warmth for the cold and uncaring bog..."
	icon_state = "wyrd_cloak"
	item_state = "wyrd_cloak"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	armor = ARMOR_CLOTHING
	boobed = FALSE
	toggle_icon_state = FALSE
	flags_inv = HIDEBOOB|HIDECROTCH
	color = null
	hoodtype = /obj/item/clothing/head/hooded/rainhood/wyrd_hood

/obj/item/clothing/head/hooded/rainhood/wyrd_hood
	name = "Hood of the Wyrd"
	desc = "Heavy is the head that hides beneath this shadowy hood, for what knowledge lays inside ought to never come into the light..."
	icon_state = "wyrd_hood"
	item_state = "wyrd_hood"
	slot_flags = ITEM_SLOT_HEAD
	dynamic_hair_suffix = ""
	edelay_type = 1
	body_parts_covered = HEAD
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDETAIL
	block2add = FOV_BEHIND
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

// DASFOX
/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/dasfox
	name = "archaic ceremonial valkyrhelm"
	desc = "A winged and angular helm of archaic design, tracing its lineage back to the Celestial Empire's fall. \
		House Timbermere makes sole use of its design within Azuria, claiming it as their heritage right. \
		This one has been gilded by Astrata's own colors, with a hand-woven plume atop to bear heraldic colors."
	icon_state = "valkyrhelm"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/dasfox/attackby(obj/item/W, mob/living/user, params)
	..()
	if(!(istype(W, /obj/item/natural/feather) && !detail_tag))
		return
	var/choice = input(user, "Choose a color.", "Plume") as anything in COLOR_MAP
	user.visible_message(span_warning("[user] adds [W] to [src]."))
	user.transferItemToLoc(W, src, FALSE, FALSE)
	detail_color = COLOR_MAP[choice]
	detail_tag = "_detail"
	update_icon()
	if(loc == user && ishuman(user))
		var/mob/living/carbon/H = user
		H.update_inv_head()

/obj/item/clothing/neck/roguetown/psicross/astrata/dasfox
	name = "defiled Astratan periapt"
	desc = "This golden-lashed eye atop a blade was once a periapt of Astrata, \
	used in prayer and reverence of Her Tyrannical Light. This one has been damaged heavily, \
	and near-shattered- and is bound together by cloth and silver wires. \
	In lieu of its former nature, it now serves as amulet or attachment to armor due to the braided wire to be \
	utilized as a chain."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	icon_state = "astrata_periapt"

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/dasfox
	name = "archaic ceremonial cuirass"
	desc = "A cuirass and tasset set of archaic design, tracing its lineage back to the Celestial Empire's fall. \
		House Timbermere makes sole use of its design within Azuria, claiming it as their heritage right. \
		This one has been gilded by Astrata's own colors atop a sleeved surcoat to bear heraldic colors."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	icon_state = "archaiccuirass"
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	detail_tag = "_det"
	detail_color = CLOTHING_WHITE
	boobed = FALSE
	boobed_detail = FALSE

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/dasfox/update_icon()
	cut_overlays()
	if(!get_detail_tag())
		return
	var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
	message_admins("[pic.icon_state]")
	pic.appearance_flags = RESET_COLOR
	if(get_detail_color())
		pic.color = get_detail_color()
	add_overlay(pic)

/obj/item/rogueweapon/spear/lance/dasfox
	name = "La Rosa de la Chevalerie"
	desc = "A jousting lance, designed to look much like the flower- a softness backed by steel. \
		Handwoven silk is draped down the length and kept in place by steel vines, while heart-shaped ties keep silk on the grip from moving much even during proper jousts. \
		The cup guard has been forged, in lieu of its natural shape, into a blooming rosa - genteel and pleasant in view for a weapon of war."
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	icon_state = "dasfox_lance"

/obj/item/rogueweapon/sword/long/etruscan/freifechter/tyesca
	name = "reliquary Reformist montante"
	desc = "Once upon a time, such swords as these were the Etruscan Isles' specialty for two handed combat. This one has been forged shorter in an archaic \
	pattern, utilized by old Fencers who wished to have a more defensively capable blade for use in the field. Transformed from simple sword to reliquary of \
	the past, a time capsule decorated by bronze, red silk and black prayer beads. A simple engraving on the crossguard pleads; 'Draw Me Only At The End.'"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	icon_state = "tyesca_sword"

/obj/item/rogueweapon/scabbard/sword/tyesca
	name = "reliquary montante scabbard"
	desc = "A scabbard designed in equal parts to match the sword it was crafted for. Catches and loops sit for prayer beads and drapes of silk to hang down \
	the bronze-and-pewter decorated length. The throat and locket are forged to make the bottom of a Psycross when held upright, allowing the sword when \
	sheathed to complete the piece as a mark of faith when placed away from the world. Down the length, it preaches; 'There Is No World To Lyve In Which A \
	Sword Is The Answer.'"
	icon_state = "reliquaryscabbard"
	item_state = "reliquaryscabbard"
	valid_blade = /obj/item/rogueweapon/sword/long/etruscan/freifechter
	cant_strip = TRUE

/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/tyesca
	name = "fencing brigandine"
	desc = "A lightweight set of Szöréndnížine brigandine, designed in part to match the archaic Etruscan sets that came over at the head of the Reformation. \
	A sewn in surcoat bearing the City-State's colors is sewn in as the interior lining, showing the Elephantine heraldry on the interior."
	icon_state = "fencerbrig"
	item_state = "fencerbrig"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

/obj/item/clothing/suit/roguetown/armor/brigandine/light/tyesca
	name = "fencing brigandine"
	desc = "A lightweight set of Szöréndnížine brigandine, designed in part to match the archaic Etruscan sets that came over at the head of the Reformation. \
	A sewn in surcoat bearing the City-State's colors is sewn in as the interior lining, showing the Elephantine heraldry on the interior."
	icon_state = "fencerbrig"
	item_state = "fencerbrig"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

/obj/item/clothing/cloak/raincloak/tyesca
	name = "\improper Szöréndnížine banner-cloak"
	desc = "A harsh reality that comes from yils of travel is the lack of protections one might have. This cloak is designed from the repurposed canvas \
	of a Szöréndnížine banner that's often in the belongings of Freelancers so far from home. Both serving as a reminder of what they travel and fight \
	for, and some protection from the elements."
	icon_state = "fencercloak"
	item_state = "fencercloak"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	boobed = FALSE
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	sleevetype = "feather_cloak"
	hoodtype = /obj/item/clothing/head/hooded/rainhood/tyesca

/obj/item/clothing/head/hooded/rainhood/tyesca
	name = "\improper Szöréndnížine banner-hood"
	desc = "Coming from the depths of a repurposed banner for use as a cloak, this hood will serve well in its heavy canvas to keep the wind and light \
	rain from the wearer's head and face. At least, for the most part."
	icon_state = "fencerhood"
	item_state = "fencerhood"
	slot_flags = ITEM_SLOT_HEAD
	dynamic_hair_suffix = ""
	edelay_type = 1
	body_parts_covered = HEAD
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDETAIL
	block2add = FOV_BEHIND
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'



//IamCrystalClear
/obj/item/clothing/mask/rogue/iamcrystalclear
	name = "porcelain mask"
	desc = "A porcelain mask with black eyes and no mouth."
	icon = 'icons/clothing/donor_clothes.dmi'
	icon_state = "porc_mask"
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	adjustable = CAN_CADJUST
	var/list/toggles = list(
		"porc_mask",
		"porc_mask_red",
		"porc_mask_blue"
		)

/obj/item/clothing/mask/rogue/iamcrystalclear/AdjustClothes(mob/user)
	for(var/i in 1 to length(toggles))
		if(toggles[i] == icon_state)
			if(i == length(toggles))
				icon_state = toggles[1]
			else
				icon_state = toggles[i+1]
			break
	to_chat(user, span_info("My mask shifts its contours."))
	update_icon()
	user.update_inv_head()
	user.update_inv_wear_mask()



//RYAN180602
/obj/item/caparison/ryan
	name = "western estates caparison"
	desc = "To the west, Grenzelhoft. The scrawny coastlines make it hard to lay anchor. The waters flow, regardless."
	icon = 'icons/clothing/donor_clothes.dmi'
	icon_state = "ryan_caparison"
	caparison_icon = 'icons/clothing/onmob/donor_caparisons.dmi'
	caparison_state = "ryan_caparison"
	female_caparison_state = "ryan_caparison-f"

/obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm/ryan
	name = "maimed psydonic helm"
	desc = "Disavowed lamb, suicidal hero, cursed idiot - Psydon is dead. Will you follow Him to the grave, as a beacon of dying hope, or surrender to temptation?"
	icon_state = "ryan_maimedhelm"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes64.dmi'

//KORUU
/obj/item/clothing/head/roguetown/mentorhat/koruu
	name = "well-worn bamboo hat"
	desc = "A bamboo hat, made from shaven rice straw and woven into place alongside a coating of lacquer. This particular hat seems worn with age, yet well maintained. The phrase, '葉隠' can be seen stitched in gold in the inner lining of the hat."
	armor = ARMOR_CLOTHING

/obj/item/rogueweapon/spear/naginata/koruu
	name = "Sixty Five Yils"
	desc = "A beautiful guandao forged out of steel and interlocked with blacksteel, much like few blades before. The inscription, 'At fifteen, I went to join the army; only at eighty was I finally able to return home.' is inscribed in gold into the haft of the guandao."
	icon_state = "koruu_naginata"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

/obj/item/rogueweapon/spear/naginata/koruu/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/halberd/glaive/koruu
	name = "Sixty Five Yils"
	desc = "A beautiful guandao forged out of steel and interlocked with blacksteel, much like few blades before. The inscription, 'At fifteen, I went to join the army; only at eighty was I finally able to return home.' is inscribed in gold into the haft of the guandao."
	icon_state = "koruu_glaive"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

/obj/item/rogueweapon/koruu/kukri
	name = "leachwhacker"
	desc = "A curved blade proudly made of Azurean Origin. Forged for wading through the hellish Terrorbog, it is a symbol of Azurean Tenacity. \
	It is said that the name is derived from old rituals of severing the leaves of a westleach bush while the iron is still hot to bless it. \
	The bane of Maneaters, Brigands, and Invaders."
	icon_state = "koruu_kukri"
	icon = 'icons/obj/items/donor_weapons.dmi'
	sheathe_icon = "koruu_kukri"

/obj/item/rogueweapon/koruu/kukri/warden
	name = "warden's leachwhacker"
	desc = "A curved blade proudly made of Azurean Origin. Forged for wading through the hellish Terrorbog, it is a symbol of Azurean Tenacity. \
	It is said that the name is derived from old rituals of severing the leaves of a westleach bush while the iron is still hot to bless it. \
	The bane of Maneaters, Brigands, and Invaders. An azure cloth could be seen wrapped around the handle."
	icon_state = "koruu_kukri_warden"
	icon = 'icons/obj/items/donor_weapons.dmi'
	sheathe_icon = "koruu_kukri_warden"

/obj/item/rogueweapon/koruu/kukri/silver
	name = "psydonic leachwhacker"
	desc = "Sometimes... I still hear her voice in the darkness, when the lampterns are out. \
	Verzeih mir, Erika."
	icon_state = "wazia_kukri_silver"
	icon = 'icons/obj/items/donor_weapons.dmi'
	sheathe_icon = "wazia_kukri_silver"

/obj/item/rogueweapon/koruu/longsword
	name = "Excaliber"
	desc = "One day...I'll craft a legendary weapon, a truly legendary sword. One that shall be known. \
As Excaliber."
	icon_state = "wazialong"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	sheathe_icon = "wazialong"
	bigboy = TRUE

/obj/item/rogueweapon/koruu/etrusca
	name = "Colada"
	desc = "The wounds received in battle bestow honor, they do not take it away..."
	icon_state = "waziaetrusc"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	sheathe_icon = "waziaetrusc"
	bigboy = TRUE

/obj/item/rogueweapon/koruu/judgement
	name = "A Durthurian Tale"
	desc = "Strength Above All. To Protect What We Love."
	icon_state = "waziajudgement"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	sheathe_icon = "waziajudgement"
	bigboy = TRUE

//DAKKEN12
/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull/dakken
	name = "armoured avantyne barbute"
	desc = "A heavy-metal barbute that seems to be more avantyne than steel. It carries a tormented lustre about it, glinting under the sun as threads of the dark metal wind through its visor."
	icon_state = "dakken_zizbarb"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/dakken
	name = "armoured avantyne barbute"
	desc = "A heavy-metal barbute that seems to be more avantyne than steel. It carries a tormented lustre about it, glinting under the sun as threads of the dark metal wind through its visor."
	icon_state = "dakken_zizbarb"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

/obj/item/clothing/head/roguetown/helmet/heavy/barbute/visor/dakken
	name = "armoured avantyne barbute"
	desc = "A heavy-metal barbute that seems to be more avantyne than steel. It carries a tormented lustre about it, glinting under the sun as threads of the dark metal wind through its visor."
	icon_state = "dakken_zizbarb"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes64.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64
	bloody_icon = 'icons/effects/blood64.dmi'

/obj/item/rogueweapon/sword/dakken_sword
	name = "avantyne threaded sword"
	desc = "'Threads of dark metal wind through what was formerly a simple steel blade. Cracks and chips are filled in as the weapon of war is reshaped into a symbol of faith.'"
	icon = 'icons/obj/items/donor_weapons.dmi'
	icon_state = "alloybsword_32"
	sheathe_icon = "alloybsword"

/obj/item/rogueweapon/sword/long/dakken_longsword
	name = "avantyne threaded longsword"
	desc = "'Threads of dark metal wind through what was formerly a simple steel blade. Cracks and chips are filled in as the weapon of war is reshaped into a symbol of faith.'"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	icon_state = "alloyblongsword"
	sheathe_icon = "alloybsword"

/obj/item/rogueweapon/spear/boar/frei/pike/stinketh
	name = "Kindness of Ravens Standard"
	desc = "A Freifechter's steel pike with a reinforced spruce shaft sporting a black banner with a strange blend of religious symbols."
	icon_state = "stinkethbanner"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

//DRD21
/obj/item/rogueweapon/sword/long/drd
	name = "ornate basket-hilted longsword"
	desc = "A longsword, fitten with a basket-hilt. The grip is made out of a fine green-stained leather, with a piece of spiral-cared walnut connecting it to a lion-shaped pommel. A purple glowing rune sits atop the blade."
	icon_state = "drd_lsword"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

/obj/item/caparison/drd
	name = "\improper House Woerden caparison"
	desc = "The livery of House Woerden: Pale blue, and white. A deer's head marks the flanks of the caparison."
	icon = 'icons/clothing/donor_clothes.dmi'
	icon_state = "drd_caparison"
	caparison_icon = 'icons/clothing/onmob/donor_caparisons.dmi'
	caparison_state = "drd_caparison"
	female_caparison_state = "drd_caparison-f"

/obj/item/rogueweapon/drd/shield
	name = "kite shield"
	desc = "The heraldry of the near-fallen House Woerden: Argent and celestial-azure, per bend, in fess point a deer head erased affronty gray."
	icon_state = "drd_shield"
	icon = 'icons/obj/items/donor_weapons.dmi'

//LMWEVIL
/obj/item/clothing/mask/rogue/courtphysician/brassbeak
	name = "\improper Society of the Brass Beak mask"
	desc = "A plague mask fitted with a brass-embossed beak, indicating membership in an erudite society of like-minded physickers. \
	This one is utterly filled with a pungent array of dried herbs to ward off ill humours, shielding from the outside world one breath at a time."
	icon_state = "brassbeak"
	item_state = "brassbeak"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

//SHUDDERFLY
/obj/item/rogueweapon/huntingknife/idagger/steel/shudderfly
	name = "\improper Eoran Spike"
	desc = "An ornately decorated steel dagger with the initials M.D. engraved on one side and the word Amor on the other. \
	Around its crossguard is bound a rosa that never seems to wilt, the weapon is obviously cared for, but has seen many fights. \
	You can’t help but shake the feeling that the weapon itself resists being used."
	icon_state = "eoranspike"
	icon = 'icons/obj/items/donor_weapons.dmi'

//MAESUNE
/obj/item/clothing/suit/roguetown/shirt/maesune
	name = "mercantile union's garb"
	desc = "Baubles, Trinkets, Merchandise galore! Come seek your finest wares, store them in your many pockets! Made for the finery of the naturalistic entrepreneurs! Mercantilism, ho!"
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon_state = "merchantgarb"
	sleevetype = "merchantgarb"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'

/obj/item/rogueweapon/maesune/sabre
	name = "\improper Y Ceirw"
	desc = "A masterfully forged sword, trimmed in gold, embedded with a gem in the guard. Built as a weapon against injustice. So we may carve out a better world. \
	Borne upon the blade, a faded inscription reads, \"A Light Shineth In the Darkness\"."
	icon_state = "maesune_sabre"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	bigboy = TRUE

/obj/item/rogueweapon/maesune/shield
	name = "\improper Fy Annwyl"
	desc = "A balanced shield, trimmed in silver, and bearing the crest of a golden deer's head with gleaming gemstone eyes. A bulwark against the howling abyss. Endvring, so we may all live in a better world. \
	Borne upon it, a freshly carved inscription reads, \"But The Darkness Comprehended It Not\"."
	icon_state = "maesune_shield"
	icon = 'icons/obj/items/donor_weapons.dmi'

//NEROCAVALIER
/* -- REMOVED BY REQUEST. KEPT FOR POSTERITY. NOW USED AS "BLACKSTEEL LONGSWORD".
/obj/item/rogueweapon/nerocavalier/flsword
	name = "blacksteel longsword"
	desc = "A sleek blade of a dark, and burnished hue. A handle carved from a rosawood branch. A pairing that should sing a melody sweeter than any harp as it parts the air.. and yet, beautiful it may be, it is not worthy of song."
	icon_state = "flsword"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	bigboy = TRUE
*/

//WALKTHEWASTE
/obj/item/clothing/head/roguetown/mentorhat/walkthewaste
	armor = ARMOR_CLOTHING

//SCIDRAGON
/obj/item/rogueweapon/sword/sabre/shamshir/dono_scidragon_flame
	name = "flametongue"
	desc = "An eternal flame dances and flickers across the blade of this shamshir, fueled by the passion of its wielder, promising to bring the heat of the long-away desert to its victims."
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	icon_state = "sci_firetongue"

/obj/item/rogueweapon/sword/sabre/shamshir/dono_scidragon_flame/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/ignitable/fluff/sci_flame)

/obj/item/rogueweapon/sword/sabre/shamshir/dono_scidragon_sand
	name = "sandlash"
	desc = "Fury of an untamable desert sandstorm, conjured along the steel of this shamshir, destined to bite and lash at the target of its owner's ire. Or perhaps just business."
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	icon_state = "sci_sandlash"

/obj/item/rogueweapon/sword/sabre/shamshir/dono_scidragon_sand/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/ignitable/fluff/sci_sand)

/obj/item/rogueweapon/sword/rapier/aisu
	base_implement_name = "crystalline rapier"
	name = "crystalline rapier"
	desc = "A crystalline rapier, born from a single tear and weeks of prayers and enchantments, Oh my guiding Moonlight!"
	icon_state = "aisuwand"
	icon = 'icons/obj/items/donor_weapons.dmi'

/obj/item/rogueweapon/rapier/aisu/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

//NAUTICALL
/obj/item/rogueweapon/example/regnum
	name = "Regnum"
	desc = "<i>'In war, the moral is to the physical as three is to one.'</i> <br> \
	An armor-piercing longsword. The finest steel, wrapped in the finest leather. Its rear-biased weight distribution makes it more of a scalpel than a slasher, while its sharp taper implies its purpose of skewering enemies with graceful precision. \
	The immaculate craftsmanship, the red leather, and the sparse but tasteful gold ornaments tell anyone who may pick this blade up that 'tis truly fit for a sovereign."
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	icon_state = "regnum"
	sheathe_icon = "regnum"
	bigboy = TRUE

/obj/item/rogueweapon/example/aeternum
	name = "Aeternum"
	desc = "<i>'Lay by your pleading, law lies a-bleeding / Burn all your studies down, and throw away your reading; small power the word has, and can afford us / Not half so many privileges as the sword has.'</i> <br> \
	A bespoke polished montante. Austere yet ornate, formal yet functional. Like its smaller sibling, it comes with hardware of real gold and a handgrip of supple red leather. Where most monarchs' blades are meant for ceremony, this one tells a \
	different story altogether, for it is made for only one purpose: war."
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	icon_state = "aeternum"
	bigboy = TRUE

/obj/item/clothing/head/roguetown/crown_hat
	name = "crown hat"
	desc = "Oft worn in place of a crown, this hat is the signature headwear of the Grand Duke. Its iconic feather stretches tall above its peers."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	icon_state = "shenara_hat"
	detail_tag = "_detail"
	detail_color = CLOTHING_SCARLET
	adjustable = CAN_CADJUST

/obj/item/clothing/head/roguetown/crown_hat/Initialize()
	. = ..()
	AddComponent(/datum/component/adjustable_clothing, null, null, null, null, null, UPD_HEAD)
	update_icon()

/obj/item/clothing/head/roguetown/crown_hat/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

//KETRAI
/obj/item/clothing/head/roguetown/octopus
	name = "octopus hat"
	desc = "A deep red, slimy cephalopod that clings to your scalp. Its tentacles can be adjusted."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	icon_state = "octopus"
	adjustable = CAN_CADJUST
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR
	body_parts_covered = HEAD|EARS|HAIR
	armor = null
	resistance_flags = FIRE_PROOF
	sellprice = 30

//spaz - Armet/Hounskull/Barbute
/obj/item/clothing/head/roguetown/helmet/heavy/barbute/visor/spaz
	name = "hound-nosed bascinet"
	desc = "A sturdy bascinet that seems to have been fitten with a long visor."
	icon_state = "spaz_helm"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes64.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64
	bloody_icon = 'icons/effects/blood64.dmi'

/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull/spaz
	name = "hound-nosed bascinet"
	desc = "A sturdy bascinet that seems to have been fitten with a long visor."
	icon_state = "spaz_helm"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/spaz
	name = "hound-nosed bascinet"
	desc = "A sturdy bascinet that seems to have been fitten with a long visor."
	icon_state = "spaz_helm"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

/obj/item/clothing/head/roguetown/octopus/ComponentInitialize()
	..()
	AddComponent(/datum/component/adjustable_clothing, \
		(HEAD|EARS|HAIR), \
		(HIDEEARS|HIDEFACE|HIDEHAIR),\
		null, \
		'sound/magic/slimesquish.ogg', \
		null, \
		UPD_HEAD)

/obj/item/clothing/head/roguetown/octopus/MiddleClick(mob/user)
	if(!ishuman(user))
		return
	if(flags_inv & HIDEHAIR)
		flags_inv &= ~HIDEHAIR
		to_chat(user, span_info("You pull your hair out from under the [src]."))
	else
		flags_inv |= HIDEHAIR
		to_chat(user, span_info("You tuck your hair under the [src]."))
	user.update_inv_head()

// CASTORTROY23
/obj/item/rogueweapon/example/darling
	name = "Darling"
	desc = "<i>'... since this is the basic tenet of swordsmanship: that a man is always in motion and never at rest.'</i> <br> \
	Elaborately forged at the edge, reinforced at the tip, and restrained at the handle with fine leathers and coiling of taut sylveren wire, \
	this sleek longsword is a most modern marvel of metallurgy blended with one of the oldest symbols of majesty, its blade boasting a diamond cross section \
	and a thin fuller to boot. The color and insignia on the fine silken cloth wrapped around its ricasso does not quite seem to fit with the wielder's own."
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	icon_state = "darling"
	sheathe_icon = "darling"
	bigboy = TRUE

//RIVERCADAVER
/obj/item/rogueweapon/example/sumquoderis
	name = "Sum Quod Eris"
	desc = "<b>'I AM AS YOU WERE. YOU WILL BE AS I AM NOW.'</b> <br> \
	A staggeringly large executioner's sword seemingly formed from one great slab of metal. A horrific implement for a singular task. \
	The handle of the blade is wreathed in blood-red vines sprouting from hollows within the crossguard. Crimson ichor drips from the thorns. \
	A surprisingly heavy pommel allows for deceptively quick strikes, but the grotesque weight of the blade is capable of cleaving bodies in twain. \
	The weapon is entirely without adornment, bare metal facing the world. <i>When you fall, leave behind a beautiful corpse. Do not die of decay.</i>"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	icon_state = "sumquoderis"
	bigboy = TRUE

/obj/item/rogueweapon/example/euthanasia
	name = "Euthanasia"
	desc = "A curved, flowing dagger of dappled steel, formed in one piece as if born, not made. <br> \
	Strings of rough, red hemp-rope tie in tight coils around the haft and crossguard, forming a surprisingly makeshift grip. \
	No adornments or inscription lies on the blade. Its purpose is fulfilled intrinsically, a sarkic weapon, fit for one sole purpose. \
	<i>Take the instrument into your hands, O murderer mine. The garden is on fire, and soon the stars must go out.</i>"
	icon = 'icons/obj/items/donor_weapons.dmi'
	icon_state = "euthanasia"

//MAGI1138
/obj/item/clothing/cloak/magi1138
	name = "reappropriated Xylixian Cloak"
	desc = "A Xylixian Cloak, without all the bells and whistles."
	icon_state = "magi_xylix"
	item_state = "magi_xylix"
	alternate_worn_layer = TABARD_LAYER
	flags_inv = HIDEBOOB
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_CLOAK|ITEM_SLOT_ARMOR
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	nodismemsleeves = TRUE

/obj/item/clothing/mask/rogue/spectacles/magi1138
	name = "modified Nocshade lens-pair"
	desc = "A pair of Otavan Nocshade Lenses with cut and polished amythortz lenses."
	icon_state = "magi_glasses"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

/obj/item/clothing/suit/roguetown/shirt/dress/willmbrink
	name = "padded dress"
	desc = "A padded, sleeved dress. The padding looks far more for fluff, than to act as armour, however."
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon_state = "willmbrink_dress"
	sleevetype = "willmbrink_dress"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'

// NEROCAVALIER
/obj/item/rogueweapon/example/nero_sylvanlsword
	name = "sylvan longsword"
	desc = "The blades of Men are broad, heavy, and simple in countenance. This is no such blade. \n\
			\n\
			It is as slender as a riverland reed, yet with an edge as keen as winter lightning. \
			Its golden hilt, wrought in softened hue and swaddled in leather dark as the heart of a cedar grove, \
			flows into curved quillons fashioned in the likeness of reaching branches.\n\
			\n\
			It is said these blades seek to paint the battlefield a sunset’s shade that has not been witnessed since \
			the time of the father's father. Its song is a metallic ode of rebellious mem’ry."
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	icon_state = "sylvan_longsword"
	sheathe_icon = "sylvan_longsword"
	bigboy = TRUE

/obj/item/rogueweapon/example/nero_sylvansabre
	name = "sylvan sabre"
	desc = "An elegant fusion of auld and new, this single-edged sabre is hewn from both steel and the bark of an Azurian elk tree. \
			Traditionally, these blades would be forged from faeiron or silver, but necessity has triumphed over tradition. \
			Today, examples such as these are sometimes seen in the hands of those who have reached an accord with the duchy of Azuria."
	icon = 'icons/obj/items/donor_weapons.dmi'
	icon_state = "sylvan_sabre"
	sheathe_icon = "sylvan_sabre"


/obj/item/rogueweapon/example/nero_sylvandagger
	name = "sylvan dagger"
	desc = "A classic elvish dagger is a design of elegance and beauty; its blade of silver reminiscent of water crashing upon the shore. \
			This is not that dagger. The elk wood and gold gilding of its predecessor remain, but the metal has been supplanted by steel. \
			Its blade is now long and slim, tapering off at the tip. What exists now is a cultivated knight killer."
	icon = 'icons/obj/items/donor_weapons.dmi'
	icon_state = "sylvan_dagger"
	sheathe_icon = "sylvan_dagger"

// DESMINUS

/obj/item/rogueweapon/example/des_gaebolg
	name = "Gae Bolg"
	desc = "A double headed polearm with sharp curvacious edges that come to a point. \
	One side is fit with a large viscious blade whilst the dull and flattend. \
	Adorned with blackened steel that rusted to a dark crimson along the handle and blade; \
	the rust has hardened to time to ressemble blood dripping along the blade, whom over owned \
	it must not have seen it well cared for in their deliverance. \n\
	\n\ \
	Along the Handle reads a silver engraving, 'Justice in Blood'"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	icon_state = "gae_bolg"
	bigboy = TRUE

// INVERSERUN
/obj/item/rogueweapon/example/arra_amdir
	name = "Amdir"
	desc = "This is a strange weapon, a mix of Elven steel, and obvious Otavan silversmithing. \
	The blade glints with the light of reflected stars. \
	Inscribed on the leaf patterned staff is a single word in Elvish. \
	Amdir- Look Up. Along one of the braces is a psycross, dangling, jangling \
	and shining with a defiant light.\n\n\
	\"Look up. Do you not hope to see the stars? Astrata's light? Noc's gaze? Look up. \
	To do that, is to hope.\""
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	icon_state = "amdir"
	bigboy = TRUE

// PESSIME959
/obj/item/rogue/instrument/guitar/pes_guitar
	name = "Red-Stained Guitar"
	desc = "\"A song sang, love shared, and promise fulfilled. \
	A well loved guitar, stained to the colors left behind by our Weeping God.\""
	icon = 'icons/obj/items/donor_music.dmi'
	icon_state = "redstainedguitar"

// VAKIOVA
/obj/item/clothing/cloak/vaki_gravetender
	name = "\improper Gravetender's Winter Coat"
	desc = "A fine woven coat that excels at protecting from the cold. It signifies the wearer as one who tends to those in her embrace."
	icon_state = "vaki_necradress"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'

	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN|ARMS
	slot_flags = ITEM_SLOT_CLOAK
	flags_inv = HIDECROTCH|HIDEBOOB


// SAKYUZO
/obj/item/rogueweapon/sakuyzo/sword
	name = "Hævatein"
	desc = "A precious Relic of the highest rarity - a blacksteel sword coated in dragonfyre, found at the base of a river of lava. Inscribed with runic symbols, it is deeply attuned in the arcyne and serves any Spellblade as a vessel for channeling overwhelming power through it - Ironically, at the cost of requiring an aptitude to wield it."
	icon_state = "sakuyzo"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
	sheathe_icon = "sakuyzo"
	bigboy = TRUE

// OLLANIUS
/obj/item/clothing/suit/roguetown/armor/chainmail/ollanius_maille
	name = "shoulderless haubergeon"
	desc = "A maille shirt fashioned from hundreds of interlinked steel rings. This blouse covers all the little nooks-and-crannies \
	that're neglected by a standard cuirass, save for the shoulders and biceps; a curious concession, ostensibly made for agility's sake."
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	item_state = "ollanius_hoeburk"
	icon_state = "ollanius_hoeburk"
	flags_inv = HIDEBOOB

/obj/item/rogueweapon/ollanius_sword
	name = "azurosa-wrapped sword"
	desc = "<font color='007FFF'>LIED TO YOU? TRICKED YOU? NOT I.</font> \
    </br>‎ <font color='007FFF'>FOR I ANSWERED STRAIGHT. I TOLD YOU TRUE..</font> \
    </br>‎ <font color='007FFF'>THE SCAFFOLD HAS BEEN RAISED FOR NONE BUT YOU.</font> \
    </br>‎ <font color='007FFF'>FOR WHO HAS SERVED MORE FAITHFULLY THAN YOU?</font> \
    </br>‎ <font color='007FFF'>AND WHERE ARE THE OTHERS THAT HAVE STOOD BY YOUR SIDE..</font> \
    </br>‎ <font color='007FFF'>..ON YOUR SIDE, IN THE COMMON GOOD?</font> \
    </br>‎ <font color='007FFF'>DEAD.</font> \
	</br>‎ <font color='007FFF'>MURDERED.</font> \
    </br>‎ <font color='007FFF'>I DID NO MORE THAN YOU LET ME DO.</font>"
	icon_state = "ollanius_sword"
	icon = 'icons/obj/items/donor_weapons.dmi'
	sheathe_icon = "ollanius_sword"

// JADEMANIQUE
/obj/item/rogue/instrument/guitar/jade_guitar
	name = "Gilbranzed Guitar"
	desc = "\"A sturdy guitar with gilded strings, as well as numerous nicks and scratches, poorly hidden under loving maintenance \
	The gilbranze fastens seem to be of museum quality, with a touchmark in the form of the initials 'AWE' on one end.\""
	icon = 'icons/obj/items/donor_music.dmi'
	icon_state = "gilbranzeguitar"

// OLYMPUS7
/obj/item/rogueweapon/greatsword/olygsword
    name = "Gre'as'anto d'Shar"
    desc = "A profoundly lavish, late 14th century royal Yuethindrynn kriegsmesser, reforged with Hammerholdian bluntness into a \
    greatsword impregnated with dark alloy threads    that knit together forming cracks.\
    From the wielder’s perspective,<i>Dro'xun phor jal dkinoss.</i> is engraved as a reminder.\
    The center piece of The crossguard features a clan emblem of a shattered symbol of progress held together by arcane energy, \
    in place of the intersection of the cross is a slited eye within a halo, the arms of the cross are triangular.\
    This is not a blade of faith or morals, it is a tool with a purpose to it's user."
    icon = 'icons/obj/items/donor_weapons_64.dmi'
    icon_state = "olygsword"
    bigboy = TRUE

// SPARTANBOBBY
/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/spartanbobby
	name = "holy astratan bascinet"
	desc = "A silver bascinet with an ornate, golden klappvisier molded in HER image.</br>‎<font color='46bacf'>ASTRATA IMPRESSED.</font>"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	icon_state = "astrata_impressed"

// KADENCEKATARI
/obj/item/clothing/head/roguetown/decoration/gazelleskull
	name = "Gazelle Skull"
	desc = "A skull, carved from a gazelle that rests overhead. The tribal identity of the gazelle is seen as an omen of sorts. \
	Known for being quick to act and fleetfooted, it symbolizes the need to be fast to react and the need to get out of danger. \
	Sometimes, you will encounter an insurmountable threat, and in order to survive against such a threat, \
	you must flee. That is a fact of life."
	icon = 'icons/clothing/donor_clothes.dmi'
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	alternate_worn_layer  = 8.9
	icon_state = "donor_skull"
	worn_offsets = list("x" = 0, "y" = 14)
	color = null

// MORTOSASYE
/obj/item/rogueweapon/woodstaff/implement/grand/morto
	base_implement_name = null
	name = "Frozen Vow"
	desc = "A magic staff sheathed in dark ice and crowned with flawless blortz gems of exceptional purity. Each crystalline facet drinks in the arcane energy that would otherwise dissipate into the air with every spell, preserving it within the frozen metal before returning it to its wielder. Extremely cold to the touch."
	icon_state = "mystralstaff"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

/obj/item/rogueweapon/woodstaff/implement/grand/magos/morto
	base_implement_name = null
	name = "Frozen Vow"
	desc = "A magic staff sheathed in dark ice and crowned with flawless blortz gems of exceptional purity. Each crystalline facet drinks in the arcane energy that would otherwise dissipate into the air with every spell, preserving it within the frozen metal before returning it to its wielder. Extremely cold to the touch."
	icon_state = "mystralstaff"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

/obj/item/rogueweapon/woodstaff/implement/greater/quartz/morto
	base_implement_name = null
	name = "Frozen Vow"
	desc = "A magic staff sheathed in dark ice and crowned with flawless blortz gems of exceptional purity. Each crystalline facet drinks in the arcane energy that would otherwise dissipate into the air with every spell, preserving it within the frozen metal before returning it to its wielder. Extremely cold to the touch."
	icon_state = "mystralstaff"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

/obj/item/rogueweapon/woodstaff/implement/amethyst/morto
	base_implement_name = null
	name = "Frozen Vow"
	desc = "A magic staff sheathed in dark ice and crowned with flawless blortz gems of exceptional purity. Each crystalline facet drinks in the arcane energy that would otherwise dissipate into the air with every spell, preserving it within the frozen metal before returning it to its wielder. Extremely cold to the touch."
	icon_state = "mystralstaff"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

// RACOBIO
/obj/item/rogueweapon/woodstaff/implement/grand/racobio

	base_implement_name = "Obsidian Tower"
	name = "Obsidian Tower"
	desc = "An exceptionally long, smooth staff of polished black obsidian. It lacks the traditional gem-top of most casting implements. Careful observation would note that the flawless obelisk of stone does not reflect nearby lights, but light from some other place."
	icon_state = "racobiostaff"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

/obj/item/rogueweapon/woodstaff/implement/grand/racobio/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.8,"sx" = -9,"sy" = 5,"nx" = 9,"ny" = 5,"wx" = -4,"wy" = 4,"ex" = 4,"ey" = 4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.8,"sx" = 8,"sy" = 0,"nx" = -1,"ny" = 0,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

//COBB ANTI-CHRIST
/obj/item/rogueweapon/sword/long/cobb
	name = "\improper Conviction"
	desc = "This longsword appears at first glance to be a replica of the silver-alloyed Psydonic Longsword of the Orthodoxy's many soldiers, though it is clearly made of steel and by a foreign smith imitating the design. \
	The cross-guard is gilded in gold, and etched with tiny, abstract emblems to resemble the Ten; what passes to resembling a sun, a flower, a moon and so on. \
	The hilt, wrapped in a blackened leather strap, was fashioned out of chestnut and whittled for a central waistline. \
	The pommel itself, a steel disc, was embedded with a large blue gem, faceted such that on a close look, one could be able to just see through it.<br><br>\
	Perhaps most notably about this sword is that it was never bereft of the silver psycross that was wrapped around the base of the blade and hilt both, tightly woven like an imprisoning chain."
	icon_state = "jehanpsysword"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

// ATHENA14
/obj/item/rogueweapon/sword/rapier/athena
	name = "Solace"
	desc = "A rapier bearing a glimmer of which only Psydonic silver can give, though it differs immensely from the standards seen within the Otavan Orthodoxy. \
	Following a much older design from the daes of Elder Rock's oldest silver smiths, or simply in imitation of their ancient and revered crafts. \
	Its crossguards are absent with its profile greatly decreased, favoring a much slimmer design in exchange for protection. \
	Strangely the silver appears to have dulled, whether from time or an unknown circumstance. \
	Much of the blade has thusly lost its color, however some fragments remain.<br><br>\
	<font color='1B1B2A'>'Even though He may be gone, we have not lost the ability to Endure hardship.'</font>"
	icon_state = "athena_psyrapier"
	icon = 'icons/obj/items/donor_weapons_64.dmi'
