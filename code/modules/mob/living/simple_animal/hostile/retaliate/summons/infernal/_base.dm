/mob/living/simple_animal/hostile/retaliate/rogue/infernal
	obj_damage = 75
	blood_toll_bucket = STATS_KILLED_INFERNALS
	AIStatus = AI_OFF
	can_have_ai = FALSE

/mob/living/simple_animal/hostile/retaliate/rogue/infernal/Initialize(mapload)
	. = ..()
	desc += span_bold(" It does not belong to this plane.") // To hint that they may be summoned.
	ADD_TRAIT(src, TRAIT_NOFIRE, "[type]")
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_SILVER_WEAK, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	weather_immunities += "lava"
	AddComponent(/datum/component/ai_aggro_system)

/mob/living/simple_animal/hostile/retaliate/rogue/infernal/Life()
	..()
	if(pulledby)
		Retaliate()
		GiveTarget(pulledby)

/mob/living/simple_animal/hostile/retaliate/rogue/infernal/attackby(obj/item/I, mob/living/carbon/human/user, params)
	if(istype(I, /obj/item/magic))
		var/obj/item/magic/magicmaterial = I
		if(istype(magicmaterial, /obj/item/magic/infernal/ash))
			if(health == maxHealth)
				to_chat(user, "[src] is already healthy!")
				return
			to_chat(user, "I start healing [src] with [magicmaterial].")
			if(do_mob(user, src, 20))
				var/tier_diff = magicmaterial.tier / summon_tier //find the percentage of the guy we're healing based on the tier of our magic material
				visible_message("[src] absorbs [magicmaterial] and is healed.")
				adjustBruteLoss(-maxHealth * tier_diff)
				qdel(magicmaterial)
				return
	..()
