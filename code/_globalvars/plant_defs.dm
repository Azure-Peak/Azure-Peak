#define BERRYCOLORS	list("#6a6699" = "Light Blue", "#9b6464" = "Red", "#58a75c" = "Green", "#5658a9" = "Blue", "#669799" = "Cyan")
GLOBAL_LIST_EMPTY(berrycolors)

GLOBAL_LIST_INIT(plant_defs, build_plant_defs())

/proc/build_plant_defs()
	. = list()
	for(var/path in subtypesof(/datum/plant_def))
		.[path] = new path()
