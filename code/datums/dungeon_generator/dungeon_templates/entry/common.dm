/datum/map_template/dungeon/entry
	name = "Entry Tile"
	abstract_type = /datum/map_template/dungeon/entry
	type_weight = 0

/datum/map_template/dungeon/entry/tented
	mappath = "_maps/dungeon_generator/entry/Tented Entrance.dmm"
	id = "tented"
	width = 15
	height = 15

	north_offset = 7
	south_offset = 7
	east_offset = 8
	west_offset = 8

/datum/map_template/dungeon/entry/tented_entrance
	name = "Tented Entrance"
	mappath = "_maps/dungeon_generator/entry/tented_entrance.dmm"
	width = 15
	height = 15
	
	north_offset = 7
	south_offset = 7
	west_offset = 7
	east_offset = 7

/datum/map_template/dungeon/entry/eastentrance
	mappath = "_maps/dungeon_generator/entry/eastentrance.dmm"
	id = "eastentrance"
	width = 25
	height = 35

	north_offset = 9
	south_offset = 7
	west_offset = 18

/datum/map_template/dungeon/entry/Northernentrance
	mappath = "_maps/dungeon_generator/entry/Northernentrance.dmm"
	id = "Northernentrance"
	width = 45
	height = 25

	south_offset = 22
	west_offset = 6
	east_offset = 6
