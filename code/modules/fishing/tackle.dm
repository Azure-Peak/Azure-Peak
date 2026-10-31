/obj/item/fishing
	name = "fishing tackle"
	icon = 'icons/roguetown/items/fishing.dmi'
	icon_state = "twinereel"
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 1
	var/attachtype

/obj/item/fishing/reel
	attachtype = "reel"
	///A bitfield of FISHING_REEL_* traits, checked by fish traits and the minigame.
	var/fishing_reel_traits

/obj/item/fishing/reel/twine
	name = "twine fishing line"
	desc = "A simple fishing line made out of woven fibers. Cheap, but works poorly against strong fish."
	fishing_reel_traits = FISHING_REEL_FRAYED

/obj/item/fishing/reel/leather
	name = "leather fishing line"
	desc = "A fishing line made out of leather. Far stronger than twine. It is the standard material for fishing lines."
	icon_state = "leatherreel"

/obj/item/fishing/reel/silk
	name = "silk fishing line"
	desc = "A fishing line made out of woven silk. Strong and thin, it's a common choice among seasoned fisherman."
	icon_state = "silkreel"
	fishing_reel_traits = FISHING_REEL_SMOOTH | FISHING_REEL_THIN

/obj/item/fishing/reel/deluxe
	name = "deluxe fishing line"
	desc = "Extremely sought after by seasoned fisherman, this fishing line was blessed by Abyssorites in their underwater temples. A perfect fishing line that makes catching fishes much easier, if not for the cost."
	icon_state = "deluxereel"
	fishing_reel_traits = FISHING_REEL_BLESSED | FISHING_REEL_THIN
