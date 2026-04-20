/obj/item/reagent_containers/food/snacks/rogue/meat/saiga/cooked
	name = "venison steak"
	desc = "A fine cut of the forest. The Purview of skilled hunters, not farmers."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_saiga.dmi'
	icon_state = "steak"
	eat_effect = null
	faretype = FARE_FINE
	tastes = list("forest venison" = 1)
	bitesize = 3
	bonus_reagents = list(/datum/reagent/consumable/nutriment = SNACK_CHUNKY)
	rotprocess = SHELFLIFE_LONG
	fried_type = null
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs/cooked
	name = "succulent venison ribs"
	desc = "The flesh forbidden to commonfolk by nobility. It oozes with delectable grease, promising a lasting relief to ward off the pangs of hunger."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_saiga.dmi'
	icon_state = "ribs"
	eat_effect = null
	faretype = FARE_FINE
	tastes = list("forest venison" = 1)
	bitesize = 3
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	rotprocess = SHELFLIFE_LONG
	fried_type = null
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins/cooked
	name = "tender venison loins"
	desc = "Tender, the meat oozes delectable juices when squeezed. One of the best cuts of venison, cherised by nobility. The skilled butcher reaps their reward."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_saiga.dmi'
	icon_state = "loin"
	eat_effect = /datum/status_effect/buff/mealbuff
	faretype = FARE_LAVISH
	tastes = list("forest loins" = 1)
	bitesize = 3
	bonus_reagents = list(/datum/reagent/consumable/nutriment = SNACK_CHUNKY)
	rotprocess = SHELFLIFE_LONG
	fried_type = null
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime/cooked
	name = "venison prime steak"
	desc = "A cut worked free from a beast like it is art. A meal fit for royalty, with a bite sufficient to feel like one is back in those woods, staring down that saiga. Often nomikered as 'poacher's demise'."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_saiga.dmi'
	icon_state = "ossobuco"
	eat_effect = /datum/status_effect/buff/greatmealbuff
	faretype = FARE_LAVISH
	tastes = list("forest bounty" = 1)
	bitesize = 6
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEAL_GOOD)
	rotprocess = SHELFLIFE_LONG
	fried_type = null
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_z/cooked
	name = "vile venison steak"
	desc = "Cooking it has only been a marginal improvement to the scent, which seems to pierce the air further. Better not beckon any ghouls."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_saiga.dmi'
	icon_state = "steak_z"
	eat_effect = /datum/status_effect/debuff/rotfood
	faretype = FARE_POOR
	tastes = list("grout and grime" = 1)
	bitesize = 3
	bonus_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	rotprocess = SHELFLIFE_LONG
	fried_type = null
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs_z/cooked
	name = "putrid venison ribs"
	desc = "Brittle bones, good flesh. A pestran monk is never opposed to indulging in the flesh blessed by Pestra."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_saiga.dmi'
	icon_state = "ribs_z"
	eat_effect = /datum/status_effect/debuff/rotfood
	faretype = FARE_POOR
	tastes = list("grout and grime" = 1)
	bitesize = 3
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	rotprocess = SHELFLIFE_LONG
	fried_type = null
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins_z/cooked
	name = "decomposing venison loins"
	desc = "It has firmed up slightly after being cooked. Tender at the surface, tough at the core. Mortals can stomach the idea of eating this, just barely."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_saiga.dmi'
	icon_state = "loin_z"
	// Tender enough to eat without puking
	eat_effect = null
	faretype = FARE_POOR
	tastes = list("grout and grime" = 1)
	bitesize = 3
	bonus_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	rotprocess = SHELFLIFE_LONG
	fried_type = null
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime_z/cooked
	name = "odorous venison prime steak"
	desc = "Seeing a cut so fine tainted by undeath is an... Unfortunate sight. But maybe... What if it does taste as good as the real thing? Surely no noble will have you beheaded for trying lifeless vert."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_saiga.dmi'
	icon_state = "ossobuco_z"
	// Tender enough to eat without puking
	eat_effect = null
	faretype = FARE_NEUTRAL
	tastes = list("grout and grime" = 1)
	bitesize = 6
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	rotprocess = SHELFLIFE_LONG
	fried_type = null
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_w/cooked
	name = "royal venison steak"
	desc = "Serves you right beast, for your arrogance. Hounding men, women, taunting them. Now you are just quartered, cooked, still. Ahh..."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_saiga.dmi'
	icon_state = "steak_w"
	eat_effect = /datum/status_effect/buff/greatmealbuff
	faretype = FARE_LAVISH
	tastes = list("a life of hardship" = 1)
	bitesize = 8
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEAL_FILLING)
	fried_type = null
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs_w/cooked
	name = "royal venison ribs"
	desc = "Ribs stronger than blacksteel, promising great strength. It is both culinary finery and a feast at once, fit to feed many."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_saiga.dmi'
	icon_state = "ribs_w"
	eat_effect = /datum/status_effect/buff/greatmealbuff
	faretype = FARE_LAVISH
	tastes = list("pure resolve" = 1)
	bitesize = 10
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEAL_COMICALLY_FILLING)
	volume = 100
	fried_type = null
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins_w/cooked
	name = "royal venison loins"
	desc = "A welt forms under the touch. It takes little to dent, it swells back to shape in a satisfying manner. The beast may not bleed, yet the abscence of grease does not detract from the heavenly taste."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_saiga.dmi'
	icon_state = "loin_w"
	eat_effect = /datum/status_effect/buff/greatmealbuff
	faretype = FARE_LAVISH
	tastes = list("dendor's fury" = 1)
	bitesize = 5
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEAL_FILLING)
	fried_type = null
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime_w/cooked
	name = "royal venison prime steak"
	desc = "Kin has slain kin, just for a chance to gain the Stag's power. Tear into it, claim its mythical strength. Those that do not smell still experience the scent. To look, is to catch a hint of the taste. The sacred flesh of one of Dendor's angels does not care for the state of your frame, the very flesh itself speaks of legends."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_saiga.dmi'
	icon_state = "ossobuco_w"
	eat_effect = /datum/status_effect/buff/greatmealbuff
	faretype = FARE_LAVISH
	tastes = list("determination" = 1)
	bitesize = 15
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEAL_GODLIKE)
	volume = 100
	fried_type = null
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime_w/cooked/Initialize(mapload)
	AddComponent(/datum/component/stag_essence)
	. = ..()
