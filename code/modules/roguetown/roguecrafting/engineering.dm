/datum/crafting_recipe/roguetown/engineering
	abstract_type = /datum/crafting_recipe/roguetown/engineering

/datum/crafting_recipe/roguetown/engineering/art_table
	name = "artificer table"
	category = "Machines"
	result = /obj/machinery/artificer_table
	reqs = list(/obj/item/natural/wood/plank = 2,
				/obj/item/roguegear = 2)
	skillcraft = /datum/skill/craft/engineering
	verbage_simple = "constructs"
	verbage = "constructs"

/datum/crafting_recipe/roguetown/engineering/coolingtable
	name = "cooling table"
	category = "Machines"
	result = /obj/structure/table/cooling
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/ingot/iron = 1,
				/obj/item/roguegear = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/potionseller
	name = "potion seller peddler"
	category = "Machines"
	result = /obj/structure/roguemachine/potionseller/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/ingot/iron = 1,
				/obj/item/natural/glass = 1,
				/obj/item/roguegear = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4
	ignoredensity = TRUE

/datum/crafting_recipe/roguetown/engineering/lever
	name = "lever"
	category = "Triggers"
	result = /obj/structure/lever
	reqs = list(/obj/item/roguegear = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering

/datum/crafting_recipe/roguetown/engineering/trapdoor
	name = "wooden floorhatch"
	category = "Hatches"
	result = /obj/structure/floordoor
	reqs = list(/obj/item/grown/log/tree/small = 1,
					/obj/item/roguegear = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 2

/datum/crafting_recipe/roguetown/engineering/trapdoor/TurfCheck(mob/user, turf/T)
	if(istype(T,/turf/open/transparent/openspace))
		return TRUE
	if(istype(T,/turf/open/lava))
		return FALSE
	return ..()

/datum/crafting_recipe/roguetown/engineering/floorgrille
	name = "floorgrille"
	category = "Hatches"
	result = /obj/structure/bars/grille
	reqs = list(/obj/item/ingot/iron = 1,
					/obj/item/roguegear = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3

/datum/crafting_recipe/roguetown/engineering/floorgrille/TurfCheck(mob/user, turf/T)
	if(istype(T,/turf/open/transparent/openspace))
		return TRUE
	if(istype(T,/turf/open/lava))
		return FALSE
	return ..()

/datum/crafting_recipe/roguetown/engineering/bars
	name = "metal bars"
	category = "Barriers"
	result = /obj/structure/bars
	reqs = list(/obj/item/ingot/iron = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering

/datum/crafting_recipe/roguetown/engineering/shopbars
	name = "shop bars"
	category = "Barriers"
	result = /obj/structure/bars/shop
	reqs = list(/obj/item/ingot/iron = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	ignoredensity = TRUE

/datum/crafting_recipe/roguetown/engineering/distiller
	name = "copper distiller"
	category = "Machines"
	result = /obj/structure/fermentation_keg/distiller
	reqs = list(/obj/item/ingot/copper = 2, /obj/item/roguegear = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 2

/datum/crafting_recipe/roguetown/engineering/freedomchair
	name = "LIBERTAS"
	category = "Machines"
	result = /obj/structure/chair/freedomchair/crafted
	reqs = list(/obj/item/ingot/gold = 1, /obj/item/roguegear = 3)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/gate
	name = "gate"
	category = "Passages"
	result = /obj/structure/bars/passage
	reqs = list(/obj/item/ingot/iron = 1,
					/obj/item/roguegear = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 2

/datum/crafting_recipe/roguetown/engineering/passage/TurfCheck(mob/user, turf/T)
	if(istype(T,/turf/open/transparent/openspace))
		return FALSE
	if(istype(T,/turf/open/lava))
		return FALSE
	if(istype(T,/turf/open/water))
		return FALSE
	return ..()

/datum/crafting_recipe/roguetown/engineering/shutters
	name = "shutters"
	category = "Passages"
	result = /obj/structure/bars/passage/shutter
	reqs = list(/obj/item/ingot/iron = 1,
					/obj/item/roguegear = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 2

/datum/crafting_recipe/roguetown/engineering/shutters/TurfCheck(mob/user, turf/T)
	if(istype(T,/turf/open/transparent/openspace))
		return FALSE
	if(istype(T,/turf/open/lava))
		return FALSE
	if(istype(T,/turf/open/water))
		return FALSE
	return ..()

//crossbows, crossbow bolts, and specialized arrows and bolts
//adding in crossbows and bolts at a reduced cost and seeing if this upsets any balance. If it works I may add in other bows and arrows using planks
/datum/crafting_recipe/roguetown/engineering/crossbow
	name = "Crossbow"
	category = "Weapons"
	result = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	reqs = list(/obj/item/ingot/steel = 1, /obj/item/natural/fibers = 1, /obj/item/natural/wood/plank = 2)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3

/datum/crafting_recipe/roguetown/engineering/twentybolts
	name = "Crossbow Bolts 20x"
	category = "Ammo"
	reqs = list(/obj/item/natural/wood/plank = 3, /obj/item/ingot/iron = 1)
	result = list(/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt,
						/obj/item/ammo_casing/caseless/rogue/bolt
					)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3
	
//pyro arrow crafting, from stonekeep
/datum/crafting_recipe/roguetown/engineering/pyrobolt
	name = "pyroclastic bolt"
	category = "Ammo"
	result = /obj/item/ammo_casing/caseless/rogue/bolt/pyro
	reqs = list(/obj/item/ammo_casing/caseless/rogue/bolt = 1,
				/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 1)
	structurecraft = /obj/machinery/artificer_table
	craftdiff = 1
	skillcraft = /datum/skill/craft/engineering

/datum/crafting_recipe/roguetown/engineering/pyrobolt_five
	name = "pyroclastic bolt (x5)"
	category = "Ammo"
	result = list(
				/obj/item/ammo_casing/caseless/rogue/bolt/pyro,
				/obj/item/ammo_casing/caseless/rogue/bolt/pyro,
				/obj/item/ammo_casing/caseless/rogue/bolt/pyro,
				/obj/item/ammo_casing/caseless/rogue/bolt/pyro,
				/obj/item/ammo_casing/caseless/rogue/bolt/pyro
				)
	reqs = list(/obj/item/ammo_casing/caseless/rogue/bolt = 5,
				/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 5)
	structurecraft = /obj/machinery/artificer_table
	craftdiff = 1
	skillcraft = /datum/skill/craft/engineering

/datum/crafting_recipe/roguetown/engineering/pyroarrow
	name = "pyroclastic arrow"
	category = "Ammo"
	result = /obj/item/ammo_casing/caseless/rogue/arrow/pyro
	reqs = list(/obj/item/ammo_casing/caseless/rogue/arrow/iron = 1,
				/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 1)
	structurecraft = /obj/machinery/artificer_table
	craftdiff = 1
	skillcraft = /datum/skill/craft/engineering

/datum/crafting_recipe/roguetown/engineering/pyroarrow_five
	name = "pyroclastic arrow (x5)"
	category = "Ammo"
	result = list(
				/obj/item/ammo_casing/caseless/rogue/arrow/pyro,
				/obj/item/ammo_casing/caseless/rogue/arrow/pyro,
				/obj/item/ammo_casing/caseless/rogue/arrow/pyro,
				/obj/item/ammo_casing/caseless/rogue/arrow/pyro,
				/obj/item/ammo_casing/caseless/rogue/arrow/pyro
				)
	reqs = list(/obj/item/ammo_casing/caseless/rogue/arrow/iron = 5,
				/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 5)
	structurecraft = /obj/machinery/artificer_table
	craftdiff = 1
	skillcraft = /datum/skill/craft/engineering

/datum/crafting_recipe/roguetown/engineering/pressure_plate
	name = "pressure plate"
	category = "Triggers"
	result = /obj/structure/pressure_plate
	reqs = list(/obj/item/roguegear = 1, /obj/item/natural/wood/plank = 2)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 2

/datum/crafting_recipe/roguetown/engineering/activator
	name = "engineer's launcher"
	category = "Machines"
	result = /obj/structure/englauncher
	reqs = list(/obj/item/roguegear = 1, /obj/item/natural/wood/plank = 4, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

//rotational and minecart parts
/datum/crafting_recipe/roguetown/engineering/shaft
	name = "wooden shaft(6x)"
	category = "Rotational"
	result = list(/obj/item/rotation_contraption/shaft,
				  /obj/item/rotation_contraption/shaft,
				  /obj/item/rotation_contraption/shaft,
				  /obj/item/rotation_contraption/shaft,
				  /obj/item/rotation_contraption/shaft,
				  /obj/item/rotation_contraption/shaft)
	reqs = list(/obj/item/grown/log/tree/small = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	tools = list(/obj/item/rogueweapon/huntingknife = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/stickshaft
	name = "wooden shaft"
	category = "Rotational"
	result = list(/obj/item/rotation_contraption/shaft)
	reqs = list(/obj/item/grown/log/tree/stick = 2)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	tools = list(/obj/item/rogueweapon/huntingknife = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/cog
	name = "wooden cogwheel(4x)"
	category = "Rotational"
	result = list(/obj/item/rotation_contraption/cog,
				  /obj/item/rotation_contraption/cog,
				  /obj/item/rotation_contraption/cog,
				  /obj/item/rotation_contraption/cog)
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/roguegear = 2, /obj/item/grown/log/tree/stick = 2)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	tools = list(/obj/item/rogueweapon/huntingknife = 1)
	craftdiff = 4


/datum/crafting_recipe/roguetown/engineering/waterwheel
	name = "wooden waterwheel(2x)"
	category = "Rotational"
	result = list(/obj/item/rotation_contraption/waterwheel,
				  /obj/item/rotation_contraption/waterwheel)
	reqs = list(/obj/item/natural/wood/plank = 3, /obj/item/grown/log/tree/stick = 2)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	tools = list(/obj/item/rogueweapon/huntingknife = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/large_cog
	name = "large wooden cogwheel(2x)"
	category = "Rotational"
	result = list(/obj/item/rotation_contraption/large_cog,
				  /obj/item/rotation_contraption/large_cog)
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/ingot/bronze = 1, /obj/item/grown/log/tree/stick = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	tools = list(/obj/item/rogueweapon/huntingknife = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/gearbox
	name = "gearbox(2x)"
	category = "Rotational"
	result = list(/obj/item/rotation_contraption/horizontal,
				  /obj/item/rotation_contraption/horizontal)
	reqs = list(/obj/item/roguegear = 2, /obj/item/natural/stoneblock = 2,/obj/item/grown/log/tree/stick = 2)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/vertical_gearbox
	name = "vertical gearbox(2x)"
	category = "Rotational"
	result = list(/obj/item/rotation_contraption/vertical,
				  /obj/item/rotation_contraption/vertical)
	reqs = list(/obj/item/roguegear = 2, /obj/item/natural/stoneblock = 2, /obj/item/grown/log/tree/stick = 2)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/rails
	name = "minecart rails (20x)"
	category = "Minecarts"
	result = list(/obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail,
				  /obj/item/rotation_contraption/minecart_rail)
	reqs = list(/obj/item/natural/wood/plank = 5, /obj/item/ingot/iron = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3

/datum/crafting_recipe/roguetown/engineering/railbreak
	name = "minecart rail break (8x)"
	category = "Minecarts"
	result = list(/obj/item/rotation_contraption/minecart_rail/railbreak,
				  /obj/item/rotation_contraption/minecart_rail/railbreak,
				  /obj/item/rotation_contraption/minecart_rail/railbreak,
				  /obj/item/rotation_contraption/minecart_rail/railbreak,
				  /obj/item/rotation_contraption/minecart_rail/railbreak,
				  /obj/item/rotation_contraption/minecart_rail/railbreak,
				  /obj/item/rotation_contraption/minecart_rail/railbreak,
				  /obj/item/rotation_contraption/minecart_rail/railbreak)
	reqs = list(/obj/item/roguegear = 1, /obj/item/ingot/iron = 1)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3


/datum/crafting_recipe/roguetown/engineering/minecart
	name = "minecart"
	category = "Minecarts"
	result = /obj/structure/closet/crate/miningcar
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/ingot/iron = 1, /obj/item/grown/log/tree/stick = 4, /obj/item/roguegear = 2)
	verbage_simple = "engineer"
	verbage = "engineers"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

// ------------ Explosives expansion----------
/datum/crafting_recipe/roguetown/engineering/tntbomb
	name = "blastsand sticks"
	category = "Explosives"
	result = /obj/item/tntstick
	reqs = list(/obj/item/paper = 2, /obj/item/alch/coaldust = 1, /obj/item/compost = 1, /obj/item/natural/fibers = 1)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/satchelbomb
	name = "blastsand satchel"
	category = "Explosives"
	result = /obj/item/satchel_bomb
	reqs = list(/obj/item/storage/backpack/rogue/satchel  = 1, /obj/item/tntstick = 3, /obj/item/alch/firedust = 1, /obj/item/natural/fibers = 1)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

//increasing the number to reflect the effort it takes to get fyritius and firedust
/datum/crafting_recipe/roguetown/engineering/impactexplosive
	name = "explosive grenade"
	category = "Explosives"
	result = list(/obj/item/impact_grenade/explosion,
				  /obj/item/impact_grenade/explosion,
				  /obj/item/impact_grenade/explosion)
	reqs = list(/obj/item/natural/clay = 1, /obj/item/paper = 1, /obj/item/alch/coaldust = 1, /obj/item/alch/firedust = 1, /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 1)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/impactsmoke
	name = "smoke grenade"
	category = "Explosives"
	result = list(/obj/item/impact_grenade/smoke, 
				  /obj/item/impact_grenade/smoke,
				  /obj/item/impact_grenade/smoke,)
	reqs =  list(/obj/item/smokeshell= 3, /obj/item/alch/coaldust = 1, /obj/item/ash = 1, /datum/reagent/water = 48)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/impactpoisonsmoke
	name = "poison smoke grenade"
	category = "Explosives"
	result = list(/obj/item/impact_grenade/smoke/poison_gas,
				  /obj/item/impact_grenade/smoke/poison_gas,
				  /obj/item/impact_grenade/smoke/poison_gas)
	reqs =  list(/obj/item/smokeshell = 3, /obj/item/alch/coaldust = 1, /obj/item/ash = 1, /datum/reagent/berrypoison = 5, /obj/item/alch/airdust = 1, /datum/reagent/water = 48)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/impactfiresmoke
	name = "conflagaration smoke grenade"
	category = "Explosives"
	result = list(/obj/item/impact_grenade/smoke/fire_gas,
				  /obj/item/impact_grenade/smoke/fire_gas,
				  /obj/item/impact_grenade/smoke/fire_gas)
	reqs =  list(/obj/item/smokeshell = 3, /obj/item/alch/coaldust = 2, /obj/item/ash = 1, /obj/item/alch/firedust = 1, /obj/item/alch/solardust = 1, /datum/reagent/water = 48)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/impactblindingsmoke
	name = "blinding smoke grenade"
	category = "Explosives"
	result = list(/obj/item/impact_grenade/smoke/blind_gas,
				  /obj/item/impact_grenade/smoke/blind_gas,
				  /obj/item/impact_grenade/smoke/blind_gas)
	reqs =  list(/obj/item/smokeshell = 3, /obj/item/alch/coaldust = 1, /obj/item/ash = 1, /obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced = 1, /obj/item/natural/dirtclod = 1, /datum/reagent/water = 48)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/impactmutesmoke
	name = "mute smoke grenade"
	category = "Explosives"
	result = list(/obj/item/impact_grenade/smoke/mute_gas,
				  /obj/item/impact_grenade/smoke/mute_gas,
				  /obj/item/impact_grenade/smoke/mute_gas)
	reqs =  list(/obj/item/smokeshell = 3, /obj/item/alch/coaldust = 1, /obj/item/ash = 1, /obj/item/alch/irondust = 1, /obj/item/rogueore/cinnabar = 1, /datum/reagent/water = 48)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/impacthealingsmoke
	name = "healing smoke grenade"
	category = "Explosives"
	result = list(/obj/item/impact_grenade/smoke/healing_gas,
				  /obj/item/impact_grenade/smoke/healing_gas,
				  /obj/item/impact_grenade/smoke/healing_gas)
	reqs =  list(/obj/item/smokeshell = 3, /obj/item/alch/coaldust = 1, /obj/item/ash = 1, /obj/item/alch/viscera = 1, /obj/item/alch/bonemeal = 1, /datum/reagent/water = 48)
	structurecraft = /obj/machinery/artificer_table
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

// ------------ Craftable Traps ----------
//setting these up as a more "arcane" alternative to trap making done with engineering. 

/datum/crafting_recipe/roguetown/engineering/rocktrap
	name = "rock trap (engineered)"
	category = "Traps"
	result = /obj/structure/trap/rock_fall
	reqs =  list(/obj/item/roguegear = 1, /obj/item/natural/clay = 2, /obj/item/roguegem/amethyst = 1, /obj/item/alch/irondust =1, /obj/item/natural/rock = 1)
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 4

/datum/crafting_recipe/roguetown/engineering/sawbladetrap
	name = "saw blades trap (engineered)"
	category = "Traps"
	result = /obj/structure/trap/saw_blades
	reqs =  list(/obj/item/roguegear = 2, /obj/item/natural/clay = 2, /obj/item/roguegem/amethyst = 1, /obj/item/alch/irondust =1, /obj/item/natural/whetstone = 1)
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 5

/datum/crafting_recipe/roguetown/engineering/flametrap
	name = "flame trap (engineered)"
	category = "Traps"
	result = /obj/structure/trap/flame
	reqs =  list(/obj/item/roguegear = 1, /obj/item/natural/clay = 2, /obj/item/roguegem/amethyst = 1, /obj/item/alch/irondust =1, /obj/item/alch/firedust =1)
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 5

/datum/crafting_recipe/roguetown/engineering/shocktrap
	name = "shock trap (engineered)"
	category = "Traps"
	result = /obj/structure/trap/shock
	reqs =  list(/obj/item/roguegear = 1, /obj/item/natural/clay = 2, /obj/item/roguegem/amethyst = 1, /obj/item/alch/irondust =1, /obj/item/alch/magicdust =1)
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 6

/datum/crafting_recipe/roguetown/engineering/bombtrap
	name = "bomb trap (engineered)"
	category = "Traps"
	result = /obj/structure/trap/bomb
	reqs =  list(/obj/item/roguegear = 1, /obj/item/natural/clay = 2, /obj/item/roguegem/amethyst = 1, /obj/item/alch/irondust =1, /obj/item/impact_grenade/explosion = 1)
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 6
