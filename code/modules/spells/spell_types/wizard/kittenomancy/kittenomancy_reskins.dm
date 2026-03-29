// Cat-themed reskins of existing spells for Kittenomancy
// Mechanically identical, just different sounds and names

/datum/action/cooldown/spell/projectile/lightning_bolt/kittenomancy
	button_icon = 'icons/mob/actions/mage_kittenomancy.dmi'
	name = "Bolt of Feline Fury"
	desc = "Emit a bolt of lightning accompanied by an unearthly yowl, burning the target and preventing them from attacking for 6 seconds. \
	Damage is increased by 100% versus simple-minded creechurs. \
	The CC effects cannot be reapplied to the same target within 15 seconds."
	button_icon_state = "lightning_bolt"
	sound = 'sound/vo/mobs/cat/roar4.ogg'
	invocations = list("Fulmeow!")
	attunement_school = ASPECT_NAME_KITTENOMANCY

/datum/action/cooldown/spell/repulse/kittenomancy
	button_icon = 'icons/mob/actions/mage_kittenomancy.dmi'
	name = "Caterwaul"
	desc = "Let loose a deafening caterwaul, repelling everyone around you with the force of a thousand angry cats. \
	Deals massive damage to anyone below you on the ground."
	button_icon_state = "caterwaul"
	sound = 'sound/vo/mobs/cat/roar1.ogg'
	invocations = list("Repellmeow!")
	attunement_school = ASPECT_NAME_KITTENOMANCY
