
/obj/structure/fluff/walldeco
	name = ""
	desc = ""
	icon = 'icons/roguetown/misc/decoration.dmi'
	anchored = TRUE
	density = FALSE
	max_integrity = 0
	layer = ABOVE_MOB_LAYER+0.1

/obj/structure/fluff/walldeco/OnCrafted(dirin, user)
	pixel_x = 0
	pixel_y = 0
	switch(dirin)
		if(NORTH)
			pixel_y = 32
		if(SOUTH)
			pixel_y = -32
		if(EAST)
			pixel_x = 32
		if(WEST)
			pixel_x = -32
	. = ..()

/obj/structure/fluff/walldeco/proc/get_attached_wall()
	return

/obj/structure/fluff/walldeco/wantedposter
	name = "bandit notice"
	desc = "A place for posters displaying the faces of roving bandits. Let's see if there are any this week..."
	icon_state = "wanted1"
	layer = BELOW_MOB_LAYER
	pixel_y = 32

/obj/structure/fluff/walldeco/wantedposter/r
	pixel_y = 0
	pixel_x = 32
/obj/structure/fluff/walldeco/wantedposter/l
	pixel_y = 0
	pixel_x = -32

/obj/structure/fluff/walldeco/wantedposter/Initialize()
	. = ..()
	icon_state = "wanted[rand(1,3)]"
	dir = pick(GLOB.cardinals)

/obj/structure/fluff/walldeco/wantedposter/examine(mob/user)
	. = ..()
	if(user.Adjacent(src))
		if(SSrole_class_handler.bandits_in_round)
			. += span_bold("I see that bandits are active in the region.")
			user.playsound_local(user, 'sound/misc/notice (2).ogg', 100, FALSE)
		else
			. += span_bold("There doesn't seem to be any reports of bandit activity.")

/obj/structure/fluff/walldeco/innsign
	name = "skull sign"
	desc = "A placard sign with a skull and crossbones."
	icon_state = "bar"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/steward
	name = "steward's sign"
	desc = "A sign depicting the office of the local steward."
	icon_state = "steward"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/bsmith
	name = "smith's sign"
	desc = "A sign depicting the workplace of the local smith."
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "bsmith"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/goblet
	name = "goblet sign"
	desc = "An inviting sign; this one indicates to the weary and sober that booze is within."
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "goblet"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/flower
	name = "flowery sign"
	desc = "A seductive sign with a purple flower."
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "flower"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/barbersign
	name = "barberpole"
	desc = "The iconic swirl of the barber surgeon."
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "barbersign"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/barbersignreverse
	name = "barberpole"
	desc = "The iconic swirl of the barber surgeon."
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "barbersignflip"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/sparrowflag
	name = "sparrow flag"
	desc = "A flag of coarse fabric bearing the symbol of a blood-red sparrow, its wings unfurled. A symbol of mercenaries \
	cut-throats, and all those willing to spill blood for gold. "
	icon_state = "sparrow"

/obj/structure/fluff/walldeco/xavo
	name = "xavo flag"
	desc = ""
	icon_state = "xavo"

/obj/structure/fluff/walldeco/serpflag
	name = "serpent flag"
	desc = ""
	icon_state = "serpent"

/obj/structure/fluff/walldeco/artificerflag
	name = "Artificer's Guild"
	desc = "Fine fabric bears the symbol of a square and compass, heraldry of the Guild of Craft. Artisans of beautiful \
	works, and jealous protectors of the monopoly of their business."
	icon_state = "artificer"

/obj/structure/fluff/walldeco/maidendrape
	name = "black drape"
	desc = "A drape of fabric."
	icon_state = "black_drape"
	dir = SOUTH
	pixel_y = 32

/obj/structure/fluff/walldeco/wallshield
	name = "decorative shield"
	desc = "This is a large, broad shield attached to a wall as decoration. Often used to denote structures operated by \
	a city's garrison."
	icon_state = "wallshield"

/obj/structure/fluff/walldeco/sign/merchantsign
	name = "merchant shop sign"
	icon_state = "shopsign_merchant_right"
	plane = -1
	pixel_y = 16

/obj/structure/fluff/walldeco/sign/merchantsign/left
	icon_state = "shopsign_merchant_left"

/obj/structure/fluff/walldeco/psybanner
	name = "banner"
	icon_state = "Psybanner-PURPLE"

/obj/structure/fluff/walldeco/psybanner/red
	icon_state = "Psybanner-RED"

/obj/structure/fluff/walldeco/stone
	name = ""
	desc = ""
	icon_state = "walldec1"
	mouse_opacity = 0

/obj/structure/fluff/walldeco/stone/bronze
	color = "#ff9c1a"

/obj/structure/fluff/walldeco/church/line
	name = ""
	desc = ""
	icon_state = "churchslate"
	mouse_opacity = 0
	layer = BELOW_MOB_LAYER+0.1

/obj/structure/fluff/walldeco/stone/Initialize()
	icon_state = "walldec[rand(1,6)]"
	..()

/obj/structure/fluff/walldeco/maidensigil
	name = "stone sigil"
	desc = ""
	icon_state = "maidensigil"
	mouse_opacity = 0
	dir = SOUTH
	pixel_y = 32

/obj/structure/fluff/walldeco/maidensigil/r
	dir = WEST
	pixel_x = 16

/obj/structure/fluff/walldeco/bigpainting
	name = "painting"
	desc = "A large painting depicting a dim, forested bog."
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "sherwoods"
	pixel_y = 32
	pixel_x = -16

/obj/structure/fluff/walldeco/bigpainting/lake
	desc = "A large painting depicting a lake under moonlight."
	icon_state = "lake"

/obj/structure/fluff/walldeco/mona
	name = "painting"
	desc = "A painting of an enigmatic woman smiling at the viewer. Looking closer, it looks half-finished."
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "mona"
	pixel_y = 32

/obj/structure/fluff/walldeco/chains
	name = "hanging chains"
	alpha = 180
	layer = 4.26
	icon_state = "chains1"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	can_buckle = 1
	buckle_lying = 0
	breakoutextra = 5 MINUTES
	buckleverb = "tie"

/obj/structure/fluff/walldeco/chains/Initialize()
	icon_state = "chains[rand(1,8)]"
	..()

/obj/structure/fluff/walldeco/customflag
	name = "Azure Peak flag"
	desc = "A banner flutters in the breeze in the proud heraldic colors of the Duchy."
	icon_state = "wallflag"

/obj/structure/fluff/walldeco/customflag/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/structure/fluff/walldeco/customflag/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/structure/fluff/walldeco/customflag/lordcolor(primary,secondary)
	if(!primary || !secondary)
		return
	var/mutable_appearance/M = mutable_appearance(icon, "wallflag_primary", -(layer+0.1))
	M.color = primary
	add_overlay(M)
	M = mutable_appearance(icon, "wallflag_secondary", -(layer+0.1))
	M.color = secondary
	add_overlay(M)

/obj/structure/fluff/walldeco/moon
	name = "banner"
	icon_state = "moon"

/obj/structure/fluff/walldeco/rpainting
	name = "painting"
	icon_state = "painting_1"
	desc = "A thought-evoking painting of a skull dimly illuminated by a candelabra."

/obj/structure/fluff/walldeco/rpainting/forest
	icon_state = "painting_2"
	desc = "An unsettling painting of a blue-green, soupy forest, enshrouded in fog. The trees blend into each other."

/obj/structure/fluff/walldeco/rpainting/crown
	icon_state = "painting_3"
	desc = "An introspective painting of a golden, spiked crown resting on top of some sort of book in dim light, accompanied by a red fruit."

/obj/structure/fluff/walldeco/med
	name = "diagram"
	icon_state = "medposter"
	desc = "A medical diagram depicting the interior structure of a humanoid hand."

/obj/structure/fluff/walldeco/med2
	name = "diagram"
	icon_state = "medposter2"
	desc = "A medical diagram depicting an interior section of a humanoid body."

/obj/structure/fluff/walldeco/med3
	name = "diagram"
	icon_state = "medposter3"
	desc = "A medical diagram depicting an interior section of a humanoid body."

/obj/structure/fluff/walldeco/med4
	name = "diagram"
	icon_state = "medposter4"
	desc = "A medical diagram depicting a humanoid heart."

/obj/structure/fluff/walldeco/med5
	name = "diagram"
	icon_state = "medposter5"
	desc = "A medical diagram depicting a humanoid heart."

/obj/structure/fluff/walldeco/med6
	name = "diagram"
	icon_state = "medposter6"
	desc = "A medical diagram depicting a humanoid head."

/obj/structure/fluff/walldeco/alarm
	name = "le réveil murmure"
	icon_state = "alarm"
	desc = "This est un wall-mounted système d'alarme, designed dans les ."
	pixel_y = 32
	var/next_yap = 0
	var/onoff = 1 //Init on

/obj/structure/fluff/walldeco/alarm/attack_hand(mob/living/user)

	user.changeNext_move(CLICK_CD_MELEE)

	if(!(HAS_TRAIT(user, TRAIT_NOBLE)))
		playsound(src, 'sound/misc/machineno.ogg', 100, TRUE, -1)
		say("REMOVE THINE HAND FROM THE ALARM, CREATURE!")
		return

	playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
	if(onoff == 0)
		onoff = 1
		icon_state = "alarm"
		say("Bonjour, le sentinelle est active.")
		next_yap = 0 //They won't believe us unless we yap again
		return
	if(onoff == 1)
		onoff = 0
		icon_state = "face"
		say("A moment's rest, merci! Bonne nuit.")
		return
	else //failsafe
		onoff = 1
		icon_state = "alarm"

/obj/structure/fluff/walldeco/alarm/Crossed(mob/living/user)

	if(onoff == 0)
		return

	if(next_yap > world.time) //Yap cooldown
		return

	if(ishuman(user)) //are we a person?
		var/mob/living/carbon/human/HU = user

		if(HU.anti_magic_check()) //are we shielded?
			return

		if(!(HU in SStreasury.bank_accounts)) //first off- do we not have an account? we'll ALWAYS scream if that's the case
			playsound(loc, 'sound/misc/gold_license.ogg', 100, TRUE, -1)
			say("UNKNOWN PERSON IN SECURE AREA- ARRETZ-VOUZ!!")
			next_yap = world.time + 6 SECONDS
			return

		if(HAS_TRAIT(user, TRAIT_NOBLE))
			say("Salut, [user.real_name] de Sommet. Thirty-breths silence period active por votre grace.")
			playsound(loc, 'sound/misc/gold_menu.ogg', 100, TRUE, -1)
			next_yap = world.time + 30 SECONDS
			return

		if((HU in SStreasury.bank_accounts)) //do we not have an account?
			playsound(loc, 'sound/misc/gold_menu.ogg', 100, TRUE, -1)
			say("Yeoman [user.real_name] logged entering zone securisee.")
			return

		else //?????
			playsound(loc, 'sound/misc/gold_license.ogg', 100, TRUE, -1)
			say("UNAUTHORIZED PERSON IN SECURE AREA- ARRETZ-VOUZ!!")
			next_yap = world.time + 6 SECONDS

	else
		playsound(loc, 'sound/misc/gold_license.ogg', 100, TRUE, -1)
		say("UNKNOWN CREATURE IN SECURE AREA- ARRETZ-VOUS!!")
		next_yap = world.time + 6 SECONDS

/obj/structure/fluff/walldeco/vinez // overlay vines for more flexibile mapping
	icon_state = "vinez"

/obj/structure/fluff/walldeco/vinez/l
	pixel_x = -32

/obj/structure/fluff/walldeco/vinez/r
	pixel_x = 32

/obj/structure/fluff/walldeco/vinez/offset
	icon_state = "vinez"
	pixel_y = 32

/obj/structure/fluff/walldeco/vinez/blue
	icon_state = "vinez_blue"

/obj/structure/fluff/walldeco/vinez/red
	icon_state = "vinez_red"

/obj/structure/fluff/walldeco/bath // suggestive stonework
	icon_state = "bath1"
	pixel_x = -32
	alpha = 210

/obj/structure/fluff/walldeco/bath/two
	icon_state = "bath2"
	pixel_x = -29

/obj/structure/fluff/walldeco/bath/three
	icon_state = "bath3"
	pixel_x = -29

/obj/structure/fluff/walldeco/bath/four
	icon_state = "bath4"
	pixel_y = 32
	pixel_x = 0

/obj/structure/fluff/walldeco/bath/five
	icon_state = "bath5"
	pixel_x = -29

/obj/structure/fluff/walldeco/bath/six
	icon_state = "bath6"
	pixel_x = -29

/obj/structure/fluff/walldeco/bath/seven
	icon_state = "bath7"
	pixel_x = 32

/obj/structure/fluff/walldeco/bath/gents
	icon_state = "gents"
	pixel_x = 0
	pixel_y = 32

/obj/structure/fluff/walldeco/bath/ladies
	icon_state = "ladies"
	pixel_x = 0
	pixel_y = 32

/obj/structure/fluff/walldeco/bath/wallrope
	icon_state = "wallrope"
	layer = WALL_OBJ_LAYER+0.1
	pixel_x = 0
	pixel_y = 0
	color = "#d66262"

/obj/structure/fluff/walldeco/sign/saiga
	name = "The Drunken Saiga"
	icon_state = "shopsign_inn_saiga_right"
	plane = -1
	pixel_x = 3
	pixel_y = 16

/obj/structure/fluff/walldeco/sign/saiga/left
	icon_state = "shopsign_inn_saiga_left"

/obj/structure/fluff/walldeco/sign/trophy
	name = "saiga trophy"
	icon_state = "saiga_trophy"
	pixel_y = 32

/obj/effect/decal/shadow_floor
	name = ""
	desc = ""
	icon = 'icons/roguetown/misc/decoration.dmi'
	icon_state = "shadow_floor"
	mouse_opacity = 0

/obj/effect/decal/shadow_floor/corner
	icon_state = "shad_floorcorn"

