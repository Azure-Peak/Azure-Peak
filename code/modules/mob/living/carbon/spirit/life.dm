

/mob/living/carbon/spirit


/mob/living/carbon/spirit/Life()
	set invisibility = 0

	if (notransform)
		return

/mob/living/carbon/spirit/handle_random_events()
	..()
	if (prob(1) && prob(2))
		emote("scratch")

/mob/living/carbon/spirit/has_smoke_protection()
	if(wear_mask)
		if(wear_mask.clothing_flags & BLOCK_GAS_SMOKE_EFFECT)
			return 1
