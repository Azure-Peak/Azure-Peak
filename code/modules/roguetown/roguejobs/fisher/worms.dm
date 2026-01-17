/obj/item
	var/baitpenalty = 100 // Using this as bait will incurr a penalty to fishing chance. 100 makes it useless as bait. Lower values are better, but Never make it past 10.
	var/baitresilience = 0 // How resilient bait is. Decreases by 2 for every catch, decreases by 1 when used by a master or better. Bait cannot be consumed whilst it has resilience left.
	var/isbait = FALSE	// Is the item in question bait to be used?
	var/list/fishingMods = null

/obj/item/natural/worms
	name = "worm"
	desc = "The favorite bait of the courageous fishermen who venture these dark waters."
	icon_state = "worm1"
	throwforce = 10
	baitpenalty = 10
	isbait = TRUE
	color = "#985544"
	w_class = WEIGHT_CLASS_TINY
	fishingMods=list(
		"commonFishingMod" = 1,
		"rareFishingMod" = 1,
		"treasureFishingMod" = 1,
		"trashFishingMod" = 1,
		"dangerFishingMod" = 1,
		"ceruleanFishingMod" = 0, // 1 on cerulean aril, 0 on everything else
		"cheeseFishingMod" = 0 // Just for the funny gimmick of a chance for rats and rouses.
	)
	baitresilience = 1
	
	drop_sound = 'sound/foley/dropsound/food_drop.ogg'
	var/amt = 1

/obj/item/natural/worms/grubs
	name = "grub"
	desc = "Bait for the desperate, or the daring."
	baitpenalty = 5
	isbait = TRUE
	color = null
	fishingMods=list(
		"commonFishingMod" = 0.85,
		"rareFishingMod" = 1.15,
		"treasureFishingMod" = 1,
		"trashFishingMod" = 1,
		"dangerFishingMod" = 1,
		"ceruleanFishingMod" = 0, // 1 on cerulean aril, 0 on everything else
		"cheeseFishingMod" = 0 // Just for the funny gimmick of a chance for rats and rouses.
	)
	baitresilience = 2

/obj/item/natural/worms/grubs/attack_right(mob/user)
	return

/obj/item/natural/worms/Initialize()
	. = ..()
	dir = rand(0,8)
