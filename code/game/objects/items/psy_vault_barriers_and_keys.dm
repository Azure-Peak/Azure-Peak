/obj/effect/oneway/psy_bog //one way barrier to the boss room. Can be despawned with the key the boss drops.
	name = "magical barrier"
	max_integrity = 99999
	desc = "Victory or death - once you pass this point you will either triumph or fall. Recommended 6 players or more."
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	invisibility = SEE_INVISIBLE_LIVING
	anchored = TRUE

/obj/effect/oneway/psy_bog/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(istype(W, /obj/item/roguekey/psy_bog/exit))
		visible_message(span_boldannounce("The magical barrier disperses!"))
		qdel(src)

/obj/effect/oneway/psy_bog_two //one way barrier to the boss room. Can be despawned with the key the boss drops.
	name = "magical barrier"
	max_integrity = 99999
	desc = "Victory or death - once you pass this point you will either triumph or fall. Recommended 6 players or more."
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	invisibility = SEE_INVISIBLE_LIVING
	anchored = TRUE

/obj/effect/oneway/psy_bog_two/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(istype(W, /obj/item/roguekey/psy_bog/two))
		visible_message(span_boldannounce("The magical barrier disperses!"))
		qdel(src)


//Loot
/obj/item/roguekey/psy_bog/exit
	name = "Rusted key"
	desc = "A strange key...ever enduring."
	icon_state = "rustkey"
	lockid = "psy_bog_dung_lootkey"

/obj/item/roguekey/psy_bog/two
	name = "Rusted key"
	desc = "A strange key...ever enduring."
	icon_state = "rustkey"
	lockid = "psy_bog_dung_lootkey_two"
