/mob/living/simple_animal/hostile/retaliate/rogue/fae
	obj_damage = 75
	blood_toll_bucket = STATS_KILLED_FAE
	AIStatus = AI_OFF
	can_have_ai = FALSE

/mob/living/simple_animal/hostile/retaliate/rogue/fae/Initialize(mapload)
	. = ..()
	desc += span_bold(" It does not belong to this plane.") // To hint that they may be summoned.
	ADD_TRAIT(src, TRAIT_KNEESTINGER_IMMUNITY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	faction += "plants"
	AddComponent(/datum/component/ai_aggro_system)

/mob/living/simple_animal/hostile/retaliate/rogue/fae/Life()
	..()
	if(pulledby)
		Retaliate()
		GiveTarget(pulledby)

/mob/living/simple_animal/hostile/retaliate/rogue/fae/attackby(obj/item/I, mob/living/carbon/human/user, params)
	if(istype(I, /obj/item/magic))
		var/obj/item/magic/magicmaterial = I
		if(istype(magicmaterial, /obj/item/magic/fae))
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
