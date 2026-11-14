/obj/item
	// Quality of the bait, used to determien the fishing pool distribution
	var/bait_quality
	/// Catches this bait survives, on the rod or in the cage, before it is used up. Zero and one both mean a single catch.
	var/baitresilience = 0
	var/isbait = FALSE	// Is the item in question bait to be used?
	var/bait_flag = NONE

/obj/item/proc/expected_bait_catches(mob/user)
	var/spend_chance = FISHING_BAIT_SPEND_CHANCE_BASE - user.get_skill_level(/datum/skill/labor/fishing) * FISHING_BAIT_SPEND_CHANCE_PER_SKILL
	return round(max(1, baitresilience) * 100 / spend_chance, 0.1)

/obj/item/natural/worms
	name = "worm"
	desc = "The favorite bait of the courageous fishermen who venture these dark waters."
	icon_state = "worm1"
	throwforce = 10
	bait_quality = TRAIT_BASIC_QUALITY_BAIT
	bait_flag = DISH_MEAT
	isbait = TRUE
	color = "#985544"
	w_class = WEIGHT_CLASS_TINY
	baitresilience = 1

	drop_sound = 'sound/foley/dropsound/food_drop.ogg'
	var/amt = 1

/obj/item/natural/worms/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Like many wriggling things, this can be used as bait for fishing. Its friends can be found by digging holes in wet dirt.")

/obj/item/natural/worms/grubs
	name = "grub"
	desc = "Bait for the desperate, or the daring."
	bait_quality = TRAIT_GOOD_QUALITY_BAIT
	isbait = TRUE
	color = null
	baitresilience = 2

/obj/item/natural/worms/grubs/attack_right(mob/user)
	return

/obj/item/natural/worms/Initialize(mapload)
	. = ..()
	dir = rand(0,8)
