/obj/effect/proc_holder/spell/invoked/conjure_weapon
	name = "Conjure Weapon"
	desc = "Conjure a weapon of your choice in your hand. The weapon will be unsummoned should you conjure a new one or unbind the spell.\n\
	Melee weapons only."
	overlay_state = "conjure_weapon"
	sound = list('sound/magic/whiteflame.ogg')

	releasedrain = 60
	chargedrain = 1
	chargetime = 2 SECONDS
	no_early_release = TRUE
	recharge_time = 5 MINUTES // Not meant to be spammed or used as a mega support spell to outfit an entire party

	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = TRUE
	antimagic_allowed = FALSE
	charging_slowdown = 3
	cost = 2
	spell_tier = 2 // Spellblade tier.

	invocations = list("Conjura Telum!") // I was offered Me Armare (Arm Myself) but Conjura Telum (Conjure Weapon) is more suitable.
	invocation_type = "shout"
	glow_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_LOW

	var/obj/item/rogueweapon/conjured_weapon = null

	var/list/weapons = list(
		"Short Sword" = /obj/item/rogueweapon/sword/short/iron,
		"Hunting Sword" = /obj/item/rogueweapon/sword/short/messer/iron,
		"Arming Sword" = /obj/item/rogueweapon/sword/iron,
		"Cudgel" = /obj/item/rogueweapon/mace/cudgel,
		"Warhammer" = /obj/item/rogueweapon/mace/warhammer,
		"Dagger" = /obj/item/rogueweapon/huntingknife/idagger,
		"Axe" = /obj/item/rogueweapon/stoneaxe/woodcut,
		"Flail" = /obj/item/rogueweapon/flail,
		"Whip" = /obj/item/rogueweapon/whip,
	)

/obj/effect/proc_holder/spell/invoked/conjure_weapon/cast(list/targets, mob/living/user = usr)
	var/weapon_choice = input(user, "Choose a weapon", "Conjure Weapon") as anything in weapons
	if(!weapon_choice)
		return
	if(src.conjured_weapon)
		qdel(src.conjured_weapon)
	weapon_choice = weapons[weapon_choice]

	var/obj/item/rogueweapon/R = new weapon_choice(user.drop_location())
	R.blade_dulling = DULLING_SHAFT_CONJURED
	if(!QDELETED(R))
		R.AddComponent(/datum/component/conjured_item, GLOW_COLOR_ARCANE)
	user.put_in_hands(R)
	src.conjured_weapon = R
	return TRUE

/obj/effect/proc_holder/spell/invoked/conjure_weapon/miracle
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/conjure_weapon/Destroy()
	if(src.conjured_weapon)
		conjured_weapon.visible_message(span_warning("The [conjured_weapon]'s borders begin to shimmer and fade, before it vanishes entirely!"))
		qdel(src.conjured_weapon)
	return ..()
