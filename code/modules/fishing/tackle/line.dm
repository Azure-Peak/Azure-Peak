
/obj/item/fishing/line //short for line attachment
	attachtype = "line"
	var/bobber = FALSE
	///A bitfield of traits that this fishing line has, checked by fish traits and the minigame.
	var/fishing_line_traits
	/// Color of the fishing line
	var/line_color = COLOR_GRAY

/obj/item/fishing/line/bobber
	name = "wooden bobber"
	desc = "A wooden bobber. Keeps the hook floating in the water and helps you reel in fish."
	icon_state = "bobber"
	fishing_line_traits = FISHING_LINE_BOBBER
	line_color = "#8B4513"

/obj/item/fishing/line/sinker
	name = "stone sinker"
	desc = "A stone sinker. Keeps the hook low to catch fish that lurk at the bottom of the water."
	icon_state = "sinker"
	fishing_line_traits = FISHING_LINE_SINKER
	line_color = "#696969"
