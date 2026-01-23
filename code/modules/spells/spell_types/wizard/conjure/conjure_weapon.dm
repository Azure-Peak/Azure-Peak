/obj/effect/proc_holder/spell/invoked/conjure_weapon
	name = "Conjure Weapon"
	desc = "Conjure a sword fitting of Noc's bottomless wisdom. The weapon will be unsummoned should you conjure a new one or unbind the spell.\n\
	Melee weapons only."
	overlay_state = "conjure_weapon"
	sound = list('sound/magic/whiteflame.ogg')

	releasedrain = 30
	no_early_release = TRUE
	recharge_time = 5 MINUTES // Not meant to be spammed or used as a mega support spell to outfit an entire party

	antimagic_allowed = FALSE
	cost = 2
	spell_tier = 2 // Spellblade tier.

	invocations = list("Lacrima E Caelo Nocturno!") // (a tear from the night sky is fitting enough for this spell).
	invocation_type = "shout"
	glow_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_LOW

	var/obj/item/rogueweapon/conjured_weapon = null

/obj/effect/proc_holder/spell/self/conjure_weapon/cast(list/targets, mob/living/user = usr)
	if(src.conjured_sword)
		qdel(conjured_sword)
	var/obj/item/rogueweapon/astrata_blade = new /obj/item/rogueweapon/rapier/
nite_needle(user.drop_location())

	user.put_in_hands(nite_needle)
	src.conjured_sword = nite_needle
	return TRUE

/obj/item/rogueweapon/sword/nite_neddle
	name = "Nite-Needle"
	desc = "A long thin needle, you can spy countless star within the blade."
	force = 19			//more comparable to a dagger than a sword, for it is ultimately a tool
	max_blade_int = 100 //Astrata made this out of light not dull, duh.
	max_integrity = 100
	wdefense = 7

	icon = 'icons/roguetown/weapons/swords64.dmi'
	icon_state = "rapier"

/obj/effect/proc_holder/spell/invoked/conjure_weapon/miracle
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/conjure_weapon/Destroy()
	if(src.conjured_weapon)
		conjured_weapon.visible_message(span_warning("The [conjured_weapon]'s borders begin to shimmer and fade, before it vanishes entirely!"))
		qdel(src.conjured_weapon)
	return ..()
