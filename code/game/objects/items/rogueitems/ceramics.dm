/* Tools for using with Pottery */

/* Items made from Pottery */

// Uncooked items -- Still need to be brought to a smelter or an oven. Kilns do not exist as of 6/20/2026.
// Those are all children of natural/clay so that they can inherit the Glaze method.

//Bottle - subtype of glass bottle
/obj/item/natural/clay/claybottle
	name = "unfired clay bottle"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claybottleraw"
	cooked_type = /obj/item/reagent_containers/glass/bottle/claybottle
	desc = "A bottle fashioned from clay. It still needs to be fired to be useful."
	smeltresult = /obj/item/reagent_containers/glass/bottle/claybottle

/obj/item/natural/clay/claybottleclassic
	name = "unfired clay bottle"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claybottleraw"
	cooked_type = /obj/item/reagent_containers/glass/bottle/claybottleclassic
	desc = "A bottle fashioned from clay. It still needs to be fired to be useful."
	smeltresult = /obj/item/reagent_containers/glass/bottle/claybottleclassic

/obj/item/reagent_containers/glass/bottle/claybottle
	name = "clay vessel"
	desc = "A ceramic bottle." //The sprite was anything but small
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claybottlecook"
	volume = 75 // Larger than glass bottle
	reagent_flags = OPENCONTAINER	//So it doesn't appear through
	glaze_bonus_pct = GLAZE_BONUS_PCT

/obj/item/reagent_containers/glass/bottle/claybottleclassic
	name = "clay vessel"
	desc = "A ceramic bottle. Tyme caresses its curves and cracks with a faint, ethereal glimmer."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claybottlebaked"
	volume = 75 // Larger than glass bottle
	reagent_flags = OPENCONTAINER	//So it doesn't appear through
	glaze_bonus_pct = GLAZE_BONUS_PCT

/obj/item/reagent_containers/glass/bottle/claybottle/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Clay pottery, unlike its alloyed counterparts, can be stained in a dyebin.")

//Vase - bigger bottle
/obj/item/natural/clay/clayvase
	name = "unfired clay vase"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayvaseraw"
	cooked_type = /obj/item/reagent_containers/glass/bottle/clayvase
	desc = "A vase fashioned from clay. It still needs to be fired to be useful."
	smeltresult = /obj/item/reagent_containers/glass/bottle/clayvase

/obj/item/natural/clay/clayvaseclassic
	name = "unfired clay vase"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayvaseraw"
	cooked_type = /obj/item/reagent_containers/glass/bottle/clayvaseclassic
	desc = "A vase fashioned from clay. It still needs to be fired to be useful."
	smeltresult = /obj/item/reagent_containers/glass/bottle/clayvaseclassic

/obj/item/reagent_containers/glass/bottle/clayvase
	name = "ceramic vase"
	desc = "A large sized ceramic vase."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayvasecook"
	volume = 65 // Larger than glass bottle
	reagent_flags = OPENCONTAINER	//So it doesn't appear through
	glaze_bonus_pct = GLAZE_BONUS_PCT

/obj/item/reagent_containers/glass/bottle/clayvaseclassic
	name = "ceramic vase"
	desc = "A large sized ceramic vase. Tyme caresses its curves and cracks with a faint, ethereal glimmer."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayvasebaked"
	volume = 65 // Larger than glass bottle
	reagent_flags = OPENCONTAINER	//So it doesn't appear through
	glaze_bonus_pct = GLAZE_BONUS_PCT

/obj/item/reagent_containers/glass/bottle/clayvase/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Clay pottery, unlike its alloyed counterparts, can be stained in a dyebin.")

//Fancy vase - bigger bottle + fancy
/obj/item/natural/clay/clayfancyvase
	name = "unfired fancy clay vase"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayfancyvaseraw"
	cooked_type = /obj/item/reagent_containers/glass/bottle/clayfancyvase
	desc = "A fancy vase fashioned from clay. It still needs to be fired to be useful."
	smeltresult = /obj/item/reagent_containers/glass/bottle/clayfancyvase

/obj/item/natural/clay/clayfancyvaseclassic
	name = "unfired fancy clay vase"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayfancyvaseraw"
	cooked_type = /obj/item/reagent_containers/glass/bottle/clayfancyvaseclassic
	desc = "A fancy vase fashioned from clay. It still needs to be fired to be useful."
	smeltresult = /obj/item/reagent_containers/glass/bottle/clayfancyvaseclassic

/obj/item/reagent_containers/glass/bottle/clayfancyvase
	name = "fancy ceramic vase"
	desc = "A large sized fancy ceramic vase."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayfancyvasecook"
	volume = 65 // Larger than glass bottle
	reagent_flags = OPENCONTAINER	//So it doesn't appear through
	glaze_bonus_pct = GLAZE_BONUS_PCT

/obj/item/reagent_containers/glass/bottle/clayfancyvaseclassic
	name = "fancy ceramic vase"
	desc = "A large sized fancy ceramic vase. Tyme caresses its curves and cracks with a faint, ethereal glimmer."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayfancyvasebaked"
	volume = 65 // Larger than glass bottle
	reagent_flags = OPENCONTAINER	//So it doesn't appear through
	glaze_bonus_pct = GLAZE_BONUS_PCT

/obj/item/reagent_containers/glass/bottle/clayfancyvase/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Clay pottery, unlike its alloyed counterparts, can be stained in a dyebin.")

//Flask (was a cup) - subtype of regular cup but can shatter.
/obj/item/natural/clay/claycup
	name = "unfired clay flask"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claycupraw"
	cooked_type = /obj/item/reagent_containers/glass/cup/claycup
	desc = "A small flask fashioned from clay. It still needs to be fired to be useful."
	smeltresult = /obj/item/reagent_containers/glass/cup/claycup

/obj/item/natural/clay/claycupclassic
	name = "unfired clay flask"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claycupraw"
	cooked_type = /obj/item/reagent_containers/glass/cup/claycupclassic
	desc = "A small flask fashioned from clay. It still needs to be fired to be useful."
	smeltresult = /obj/item/reagent_containers/glass/cup/claycupclassic

/obj/item/natural/clay/rawcup
	name = "unfired clay cup"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelaincupraw"
	cooked_type = /obj/item/reagent_containers/glass/cup/carved/porcelain
	desc = "A small cup fashioned from clay. It still needs to be fired to be useful."
	smeltresult = /obj/item/reagent_containers/glass/cup/carved/porcelain

/obj/item/natural/clay/rawcupfancy
	name = "unfired fancy clay goblet"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelaincupfancyraw"
	cooked_type = /obj/item/reagent_containers/glass/cup/carved/porcelainfancy
	desc = "A fancy goblet fashioned from clay. It still needs to be fired to be useful."
	smeltresult = /obj/item/reagent_containers/glass/cup/carved/porcelainfancy

/obj/item/natural/clay/rawbowl
	name = "unfired clay bowl"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainbowlraw"
	cooked_type = /obj/item/reagent_containers/glass/bowl/carved/porcelain
	desc = "A fancy bowl fashioned from clay. It still needs to be fired to be useful."
	smeltresult = /obj/item/reagent_containers/glass/bowl/carved/porcelain

/obj/item/natural/clay/rawspoon
	name = "unfired clay spoon"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainspoonraw"
	cooked_type = /obj/item/kitchen/spoon/carved/porcelain
	desc = "A fancy spoon fashioned from clay. It still needs to be fired to be useful."


/obj/item/natural/clay/rawfork
	name = "unfired clay fork"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainforkraw"
	cooked_type = /obj/item/kitchen/fork/carved/porcelain 
	desc = "A fancy fork fashioned from clay. It still needs to be fired to be useful."

/obj/item/natural/clay/rawplatter
	name = "unfired clay platter"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainplatterraw"
	cooked_type = /obj/item/cooking/platter/carved/porcelain
	desc = "A fancy platter fashioned from clay. It still needs to be fired to be useful."


/obj/item/reagent_containers/glass/cup/claycup
	name = "clay flask"
	desc = "A small ceramic flask."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claycupcook"
	reagent_flags = OPENCONTAINER	//So it doesn't appear through
	glaze_bonus_pct = GLAZE_BONUS_PCT

/obj/item/reagent_containers/glass/cup/claycupclassic
	name = "clay flask"
	desc = "A small ceramic flask. Tyme caresses its curves and cracks with a faint, ethereal glimmer."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claycupbaked"
	reagent_flags = OPENCONTAINER	//So it doesn't appear through
	glaze_bonus_pct = GLAZE_BONUS_PCT

/obj/item/reagent_containers/glass/cup/claycup/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Clay pottery, unlike its alloyed counterparts, can be stained in a dyebin.")

// Raw teapot
/obj/item/natural/clay/rawteapot
	name = "unfired teapot"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "teapot_raw"
	desc = "A teapot fashioned from clay. It still needs to be fired to be useful."
	cooked_type = /obj/item/reagent_containers/glass/bucket/pot/teapot
	smeltresult = /obj/item/reagent_containers/glass/bucket/pot/teapot

// Raw teacup
/obj/item/natural/clay/rawteacup
	name = "unfired teacup"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "teacup_raw"
	desc = "A teacup fashioned from clay. It still needs to be fired to be useful."
	cooked_type = /obj/item/reagent_containers/glass/cup/ceramic
	smeltresult = /obj/item/reagent_containers/glass/cup/ceramic

//Bricks - Makes bricks which are used for building. (Need brick-wall sprites for this.. augh..)
/obj/item/natural/clay/claybrick
	name = "unfired clay brick"
	desc = "An uncooked clay brick. It still needs to be fired to be useful."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claybrickraw"
	cooked_type = /obj/item/natural/brick
	smeltresult = /obj/item/natural/brick

//Statues - Basically cheapest version of the metal-made statues, but way easier to make given no rare material usage. Just skill. Plus, dyeable.
/obj/item/natural/clay/claystatue
	name = "unfired clay statue"
	desc = "An uncooked clay statue. It still needs to be fired to be useful."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claystatueraw"
	cooked_type = /obj/item/roguestatue/clay
	smeltresult = /obj/item/roguestatue/clay

/obj/item/roguestatue/clay
	name = "ceramic statue"
	desc = "A ceramic statue, shining in its elegance!"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claystatuecooked1"
	smeltresult = null	//No resource return
	glaze_bonus_pct = GLAZE_BONUS_PCT

/obj/item/roguestatue/clay/Initialize()
	. = ..()
	icon_state = "claystatuecooked[pick(1,2,3,4,5)]"

/obj/item/roguestatue/glass
	name = "glass statue"
	desc = "A statue made of fine glass. An incredible amount of skill must have went into this fragile masterpiece!"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "statueglass1"
	smeltresult = /obj/item/natural/glass
	glaze_bonus_pct = GLAZE_BONUS_PCT

/obj/item/roguestatue/glass/Initialize()
	. = ..()
	icon_state = "statueglass[pick(1,2,3,4,5)]"

/obj/item/roguestatue/glass/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	if(!..()) //was it caught by a mob?
		new /obj/item/natural/glass_shard(get_turf(src))
		pixel_x = rand(-3, 3)
		pixel_y = rand(-3, 3)
		new /obj/item/natural/glass_shard(get_turf(src))
		new /obj/effect/decal/cleanable/debris/glassy(get_turf(src))
		playsound(src, 'sound/foley/glassbreak.ogg', 95, TRUE)
		qdel(src)

// LITERALLY EVERYTHING ELSE. ORGANIZATION BE DAMNED!

/obj/item/natural/clay/rawbauble
	name = "unfired clay bauble"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainbaubleraw"
	desc = "A bauble fashioned out of clay."
	cooked_type = /obj/item/natural/clay/porcelain/bauble
	smeltresult = /obj/item/natural/clay/porcelain/bauble

/obj/item/natural/clay/rawcameo
	name = "unfired clay cameo"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelaincameoraw"
	desc = "A cameo fashioned out of clay."
	cooked_type = /obj/item/natural/clay/porcelain/cameo
	smeltresult = /obj/item/natural/clay/porcelain/cameo

/obj/item/natural/clay/rawbust
	name = "unfired clay bust"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainbustraw"
	desc = "A large bust fashioned out of clay."
	cooked_type = /obj/item/natural/clay/porcelain/bust
	smeltresult = /obj/item/natural/clay/porcelain/bust

/obj/item/natural/clay/rawfigurine
	name = "unfired clay figurine"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainfigurineraw"
	desc = "A small figurine fashioned out of clay."
	cooked_type = /obj/item/natural/clay/porcelain/figurine
	smeltresult = /obj/item/natural/clay/porcelain/figurine

/obj/item/natural/clay/rawurn
	name = "unfired large clay urn"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainurnraw"
	desc = "A large, lidded urn fashioned out of clay."
	cooked_type = /obj/item/natural/clay/porcelain/urn
	smeltresult = /obj/item/natural/clay/porcelain/urn

/obj/item/natural/clay/rawstatuette
	name = "unfired clay statuette"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainstatueraw"
	desc = "A medium-sized statuette fashioned out of clay."
	cooked_type = /obj/item/natural/clay/porcelain/statuette
	smeltresult = /obj/item/natural/clay/porcelain/statuette

/obj/item/natural/clay/rawobelisk
	name = "unfired clay obelisk"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainobeliskraw"
	desc = "A medium-sized obelisk fashioned out of clay."
	cooked_type = /obj/item/natural/clay/porcelain/obelisk
	smeltresult = /obj/item/natural/clay/porcelain/obelisk

/obj/item/natural/clay/rawduck
	name = "unfired clay duck"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainduckraw"
	desc = "An adorable duck statue fashioned out of clay."
	cooked_type = /obj/item/natural/clay/porcelain/duck
	smeltresult = /obj/item/natural/clay/porcelain/duck

/obj/item/natural/clay/rawcomb
	name = "unfired clay comb"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelaincombraw"
	desc = "A fashionable comb fashioned out of clay."
	cooked_type = /obj/item/natural/clay/porcelain/comb
	smeltresult = /obj/item/natural/clay/porcelain/comb

/obj/item/natural/clay/rawtablet
	name = "unfired clay tablet"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelaintabletraw"
	desc = "A medium-sized tablet fashioned out of clay."
	cooked_type = /obj/item/natural/clay/porcelain/tablet
	smeltresult = /obj/item/natural/clay/porcelain/tablet

/obj/item/natural/clay/rawturtle
	name = "unfired clay turtle statuette"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainturtleraw"
	desc = "A large turtle statuette fashioned out of clay."
	cooked_type = /obj/item/natural/clay/porcelain/turtle
	smeltresult = /obj/item/natural/clay/porcelain/turtle

/obj/item/natural/clay/rawfish
	name = "unfired clay fish figurine"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainfishraw"
	desc = "A small fish figurine fashioned out of clay."
	cooked_type = /obj/item/natural/clay/porcelain/fish
	smeltresult = /obj/item/natural/clay/porcelain/fish

/obj/item/natural/clay/rawmoon
	name = "unfired clay moon"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainmoonraw"
	desc = "A medium-sized moon statue fashioned out of clay."
	cooked_type = /obj/item/natural/clay/porcelain/moon
	smeltresult = /obj/item/natural/clay/porcelain/moon

/obj/item/natural/clay/rawsun
	name = "unfired clay sun"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainsunraw"
	desc = "A medium-sized sun statue fashioned out of clay."
	cooked_type = /obj/item/natural/clay/porcelain/sun
	smeltresult = /obj/item/natural/clay/porcelain/sun

/obj/item/natural/clay/rawheart
	name = "unfired clay heart"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainheartraw"
	desc = "A heart fashioned out of clay."
	cooked_type = /obj/item/natural/clay/porcelain/heart
	smeltresult = /obj/item/natural/clay/porcelain/heart

/obj/item/natural/clay/rawoctopus
	name = "unfired clay octopus statuette"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainoctopusraw"
	desc = "A large octopus statuette fashioned out of clay."
	cooked_type = /obj/item/natural/clay/porcelain/octopus
	smeltresult = /obj/item/natural/clay/porcelain/octopus

/obj/item/natural/clay/rawbeaver
	name = "unfired clay beaver statuette"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainbeaverraw"
	desc = "A medium-sized beaver statuette fashioned out of clay."
	cooked_type = /obj/item/natural/clay/porcelain/beaver
	smeltresult = /obj/item/natural/clay/porcelain/beaver

/obj/item/natural/clay/rawcarp
	name = "unfired clay carp statuette"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelaincarpraw"
	desc = "A large carp statuette fashioned out of clay."
	cooked_type = /obj/item/natural/clay/porcelain/carp
	smeltresult = /obj/item/natural/clay/porcelain/carp

/obj/item/natural/clay/rawcaryatid
	name = "unfired clay caryatid"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelaincaryatidraw"
	desc = "A medium-sized caryatid fashioned out of clay."
	cooked_type = /obj/item/natural/clay/porcelain/caryatid
	smeltresult = /obj/item/natural/clay/porcelain/caryatid

/obj/item/natural/clay/rawpot
	name = "unfired clay pot"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainpotraw"
	desc = "A large clay pot fashioned out of clay."
	cooked_type = /obj/item/reagent_containers/glass/bucket/pot/porcelain
	smeltresult = /obj/item/reagent_containers/glass/bucket/pot/porcelain

/obj/item/natural/clay/rawdisplay
	name = "unfired clay display stand"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainstandraw"
	desc = "A small display stand fashioned out of clay."
	cooked_type = /obj/item/natural/clay/porcelain/display
	smeltresult = /obj/item/natural/clay/porcelain/display

/obj/item/natural/clay/rawring
	name = "unfired clay ring"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporeclainringraw"
	desc = "A dainty ring fashioned out of clay."
	cooked_type = /obj/item/clothing/ring/porcelain
	smeltresult = /obj/item/clothing/ring/porcelain

/obj/item/natural/clay/rawamulet
	name = "unfired clay amulet"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainamuletraw"
	desc = "A delicate amulet fashioned out of clay."
	cooked_type = /obj/item/clothing/neck/roguetown/carved/porcelainamulet
	smeltresult = /obj/item/clothing/neck/roguetown/carved/porcelainamulet

/obj/item/natural/clay/rawcirclet
	name = "unfired clay circlet"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelaincircletraw"
	desc = "An elegant circlet fashioned out of clay."
	cooked_type = /obj/item/clothing/head/roguetown/circlet/carvedgem/porcelain
	smeltresult = /obj/item/clothing/head/roguetown/circlet/carvedgem/porcelain

// THE COOKED ITEMS, AGAIN, ORGANIZATION BE DAMNED
/obj/item/natural/clay/porcelain
	name = "porcelain base"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayporcelainbauble"
	desc = "This is a base item, if you are seeing this, it's a bug, report it lol."
	dropshrink = FALSE
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	
/obj/item/natural/clay/porcelain/bauble
	name = "porcelain bauble"
	desc = "A small porcelain bauble."
	icon_state = "clayporcelainbauble"
/obj/item/natural/clay/porcelain/cameo
	name = "porcelain cameo"
	desc = "A small porcelain cameo."
	icon_state = "clayporcelaincameo"

/obj/item/natural/clay/porcelain/bust
	name = "porcelain bust"
	desc = "A large porcelain bust."
	icon_state = "clayporcelainbust"

/obj/item/natural/clay/porcelain/figurine
	name = "porcelain figurine"
	desc = "A small figurine made out of porcelain."
	icon_state = "clayporcelainfigurine"
	
/obj/item/natural/clay/porcelain/urn
	name = "large porcelain urn"
	desc = "A large, lidded urn made out of porcelain."
	icon_state = "clayporcelainurn"

/obj/item/natural/clay/porcelain/statuette
	name = "porcelain statuette"
	desc = "A medium-sized statuette made out of porcelain."
	icon_state = "clayporcelainstatue"

/obj/item/natural/clay/porcelain/obelisk
	name = "porcelain obelisk"
	desc = "A medium-sized obelisk made out of porcelain."
	icon_state = "clayporcelainobelisk"

/obj/item/natural/clay/porcelain/sun
	name = "porcelain sun"
	desc = "A medium-sized sun statue made out of porcelain."
	icon_state = "clayporcelainsun"

/obj/item/natural/clay/porcelain/moon
	name = "porcelain moon"
	desc = "A medium-sized moon statue made out of porcelain."
	icon_state = "clayporcelainmoon"

/obj/item/natural/clay/porcelain/heart
	name = "porcelain heart"
	desc = "A heart made out of porcelain."
	icon_state = "clayporcelainheart"

/obj/item/natural/clay/porcelain/display
	name = "porcelain display stand"
	desc = "A small display stand made out of porcelain."
	icon_state = "clayporcelainstand"
	
/obj/item/natural/clay/porcelain/fish
	name = "porcelain fish figurine"
	desc = "A small fish figurine made out of porcelain."
	icon_state = "clayporcelainfish"

/obj/item/natural/clay/porcelain/turtle
	name = "porcelain turtle statuette"
	desc = "A large turtle statuette made out of porcelain."
	icon_state = "clayporcelainturtle"

/obj/item/natural/clay/porcelain/duck
	name = "porcelain duck statue"
	desc = "An adorable duck statue made out of porcelain."
	icon_state = "clayporcelainduck"

/obj/item/natural/clay/porcelain/comb
	name = "porcelain comb"
	desc = "A fashionable comb made out of porcelain."
	icon_state = "clayporcelaincomb"

/obj/item/natural/clay/porcelain/tablet
	name = "porcelain tablet"
	desc = "A medium-sized tablet made out of porcelain."
	icon_state = "clayporcelaintablet"

/obj/item/natural/clay/porcelain/caryatid
	name = "porcelain caryatid"
	desc = "A medium-sized caryatid made out of porcelain."
	icon_state = "clayporcelaincaryatid"
		
/obj/item/natural/clay/porcelain/beaver
	name = "porcelain beaver statuette"
	desc = "A medium-sized beaver statuette made out of porcelain."
	icon_state = "clayporcelainbeaver"

/obj/item/natural/clay/porcelain/octopus
	name = "porcelain octopus statuette"
	desc = "A large octopus statuette made out of porcelain."
	icon_state = "clayporcelainoctopus"
	
/obj/item/natural/clay/porcelain/carp
	name = "porcelain carp statuette"
	desc = "A large carp statuette made out of porcelain."
	icon_state = "clayporcelaincarp"
	
	