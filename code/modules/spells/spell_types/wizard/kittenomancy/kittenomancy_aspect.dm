/datum/magic_aspect/kittenomancy
	name = "Kittenomancy"
	latin_name = "Maior Aspectus Felis"
	desc = "A forbidden school of magic that channels the primal fury of felines. \
	Practitioners hurl explosive kittens, summon vengeful cat spirits, and wield the most degenerate combination of spells known to magekind. \
	Only those who follow the teachings of Zizo have the requisite lack of ethics to practice this art."
	aspect_type = ASPECT_MAJOR
	attuned_name = ASPECT_NAME_KITTENOMANCY
	school_color = GLOW_COLOR_HEX
	binding_chants = list(
		"Invoco furomeow felis!",
		"I call upon the furry of a thousand cats, obey!",
		"Feles, in meow ligare!",
	)
	unbinding_chants = list(
		"Solvo furomeow felis!",
		"I release the feline spirits, rest... fur now.",
		"Feles, a meow discedere!",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/avenging_kittens,
		/datum/action/cooldown/spell/projectile/lightning_bolt/kittenomancy,
		/datum/action/cooldown/spell/repulse/kittenomancy,
	)
	choice_spells = list(
		/datum/action/cooldown/spell/projectile/throw_kitten,
		/datum/action/cooldown/spell/projectile/throw_puppy,
	)
	variants = list(
		"mastery" = list(
			VARIANT_ADDITIVE =/datum/action/cooldown/spell/cat_aclysm,
		),
	)

/datum/magic_aspect/kittenomancy/can_select(mob/living/user)
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/H = user
	if(!H.patron)
		return FALSE
	return istype(H.patron, /datum/patron/inhumen/zizo)
