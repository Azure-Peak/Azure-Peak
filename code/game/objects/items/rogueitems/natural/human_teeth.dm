/obj/item/natural/human_tooth
	name = "tooth"
	force = 0
	throwforce = 0
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 0, "embedded_fall_chance" = 100) //This shouldn't embed
	dropshrink = 0.5

/obj/item/natural/human_tooth/Initialize()
	. = ..()
	var/static/list/tooth_sprites = list(
		"tooth1",
		"tooth2",
		"tooth3"
	)
	icon_state = pick(tooth_sprites)

/obj/item/gold_tooth
	name = "gold tooth"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "gold_tooth"
	force = 0
	throwforce = 0
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 0, "embedded_fall_chance" = 100) //This shouldn't embed
	dropshrink = 0.5
	sellprice = 25
