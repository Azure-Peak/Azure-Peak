/obj/structure/roguemachine/mossmother
	name = "Mossmother"
	desc = "One of the most sacred of trees. The very heart of the bog, its roots extend across every single inch of land drenched by maddened waters. Its moss is said to have magical properties."
	icon = 'icons/roguetown/items/hag/hag_tree.dmi'
	icon_state = "mossmother"
	density = TRUE
	blade_dulling = DULLING_BASH
	integrity_failure = 0.1
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	pixel_y = -30
	pixel_x = -27

/obj/item/alch/hag_moss
	name = "Generic moss"
	desc = "I shouldn't exist."
	icon_state = "moss_blank"
	icon = 'icons/roguetown/items/hag/hag_items.dmi'

/obj/item/alch/hag_moss/sorrow
	name = "Mother's sorrow"
	desc = "A blossom of green moss. Said to induce melancholy when consumed by mothers to be, have been, and would've been."
	icon_state = "moss"

/obj/item/alch/hag_moss/fury
	name = "Mother's fury"
	desc = "A blossom of red moss. It cuts the throat when consumed, it burns and irritates the skin when touched. No one would dare cut down a mossmother, lest the very air gets choked by her fury."
	color = "#610202"

/obj/item/alch/hag_moss/mercy
	name = "Mother's mercy"
	desc = "A blossom of pale, glowing moss. Holding it parts the trees, it is as if home, hearth, and a warm meal surround you once."
	color = "#E0FFD1"

/obj/item/alch/hag_moss/grief
	name = "Mother's grief"
	desc = "A blossom of dark, velvet moss. Looking at it makes the silence louder, until it is deafening."
	color = "#2C2C2C"

/obj/item/alch/hag_moss/envy
	name = "Mother's envy"
	desc = "A blossom of bile-colored moss. It hisses when it touches metal and dissolves organic matter into a nutrient-rich slurry for the Mossmother's roots."
	color = "#A4C639"

/obj/item/alch/hag_moss/lullaby
	name = "Mother's lullaby"
	desc = "A blossom of deep indigo moss."
	color = "#301a3a"

/obj/item/alch/hag_moss/lullaby/examine(mob/user)
	. = ..()
	. += "<br><span class='italic'>You recall a childhood rhyme regarding this bloom...</span>"
	. += "<br>[span_notice("Smell too deep, fall asleep,")]"
	. += "[span_warning("Into the soil, quiet and steep.")]"
	. += "<br>[span_danger("Hear her hum a hollow strain,")]"
	. += "[span_boldnotice("To wash away your fear and pain.")]"
