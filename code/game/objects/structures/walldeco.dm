
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
	desc = "A place for posters displaying the faces of roving bandits, and a lesser assortment of villainous ne'er-do-wells. Let's see if there are any this week.. </br>By toggling the 'Mechanics' tab, I can learn much more about this poster's given topic."
	icon_state = "wanted1"
	layer = BELOW_MOB_LAYER
	pixel_y = 32

/obj/structure/fluff/walldeco/wantedposter/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("The kingdom is often beset with antagonists, both lesser and greater. Their presence is greatly influenced by the round's chosen storyteller, the whims of many higher powers, and pure circumstance-and-chance.")
	. += span_info("Clicking the 'Villain Selection' tab in the character creation menu allows you to opt into being a villain at the round's start, yourself. Such include bandits, vampyres, liches, verebeasts, usurpers, and more.")
	. += span_info("Ghosts, voyeurs, and those still in the lobby can intermittently receive prompts to spawn in as a lesser villan or an arcyne-summoned familiar. These roles are usually less independant, and are oft-beheld to another's command.")
	. += span_info("Uniquely, the 'Wretch' role functions as a static slot for villainy. While Wretches can spawn in nearly all rounds, they're also held to a higher standard and have a customizable bounty planted on their heads.")
	. += span_info("With all that being said, however, villainy isn't restricted to just the antagonists. All roles can indulge in villainy, both lesser and greater, so long as it can be justified beyond 'meaningless violence' or 'witless kleptomania.'")
	. += span_info("Remember that you are ultimately an actor in this virtual theatre, alongside everyone else. Working with the tempo-and-tact of others is the key to making a memorable - and enjoyable - experience for everyone involved.")

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
	desc = "A placard sign with a skull and crossbones. </br>By toggling the 'Mechanics' tab, I can learn much more about this poster's given topic."
	icon_state = "bar"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/innsign/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("With little exception, your character still needs to eat, drink, and sleep.")
	. += span_info("Eating food not only fills you up, but can also improve your character's mood and stats. Be careful, however, as eating improperly-prepared or poisoned food can have ill consequences.")
	. += span_info("Drinking follows the same tune. Middle-clicking puddles of water with the 'BITE' subintent selected can let you drink straight from the source, in a pinch. Be mindful of where you sip, however.")
	. += span_info("Neglecting to eat, drink, or sleep will negatively impact your character's mood and stats before long. Hunger saps Strength, thirst saps Willpower, and restlessness leaves you too exhausted to do much at all.")
	. += span_info("Remember, however, that a cool pint and a crisp frybird's leg tastes much better when enjoyed with the company of others. You'd be surprised what kinds of friends and enemies you can make, within a stocked inn.")
	. += span_info("Likewise, the inn - and the bathhouse, traditionally located beneath it - is the finest place to satiate many of mankind's most prominent vices.")

/obj/structure/fluff/walldeco/steward
	name = "steward's sign"
	desc = "A sign depicting the office of the local steward. </br>By toggling the 'Mechanics' tab, I can learn much more about this poster's given topic."
	icon_state = "steward"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/steward/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Mammons reign as the primary form of currency within the kingdom, with bargaining and trading as a lesser alternative. There are three types of mammons; ZENNIES, ZILIQUAE, and ZENARII.")
	. += span_info("ZENNIES, or simply referred to as MAMMONS, are the backbone of the kingdom's economy. A pouch of TEN zennies can usually afford a decent meal with liqour at the inn, or some lesser supplies.")
	. += span_info("ZILIQUAE, better known as SILVER, are each worth FIVE MAMMONS. A stack of TEN ziliquae can usually afford a freshly-forged longsword of steel, or enough supplies for a dae's adventure.")
	. += span_info("ZENARII, better known as GOLD, are each worth TEN MAMMONS. A palmful of TEN zenarii can usuaully afford a well-mountable saiga, high-end lodging for the week, or most items on the market.")
	. += span_info("Your character almost always spawns with mammons; either in pouches, or inside their MEISTER's account. Earning more can be as simple as laboring, adventuring, or otherwise driving a hard bargain.")

/obj/structure/fluff/walldeco/bsmith
	name = "smith's sign"
	desc = "A sign depicting the workplace of the local smith. </br>By toggling the 'Mechanics' tab, I can learn much more about this poster's given topic."
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "bsmith"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/bsmith/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Most roles naturally rely on weapons and armor, either to protect themselves from those who'd do harm or to better leverage their position in an ongoing story.")
	. += span_info("Left-clicking the 'SKILLS' button in your HUD will show whatever skills your character currently has. Right-clicking it will instead show their traits, and - if applicable - their armor training.")
	. += span_info("Skills determine how proficent you are in a given field. There are six levels to every skill; NOVICE, APPRENTICE, JOURNEYMAN, EXPERT, MASTER, and LEGENDARY. For weapons, JOURNEYMAN is considered the baseline.")
	. += span_info("Most weapons specifically call upon a certain skill when determining their effectiveness. Using a longsword, for example, will check the character's Swordsmanship skill when determining its accuracy and chance to parry.")	
	. += span_info("Armor is simpler, for the most part. There are three weight classes; LIGHT, MEDIUM (for the 'Maille Training' trait), and HEAVY (for the 'Plate Training' trait). Wearing armor you aren't trained in leaves you sluggish and open for attacks.")
	. += span_info("Certain armor types provide better protection to certain attacks than others. A cloth gambeson, for example, thwarts piercing and blunt damage. A steel cuirass, on the other hand, stops slashing and clawing damage dead in its tracks.")
	. += span_info("Using armor and weapons as intended will gradually wear their integrity down. Once it breaks, they can no longer be used or provide protection. Blacksmiths, tailors, repair kits, and certain tools can amend this.")

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
	desc = "The iconic swirl of the barber surgeon. </br>By toggling the 'Mechanics' tab, I can learn much more about this poster's given topic."
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "barbersign"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/barbersign/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Your character can be wounded, and mended, in a wide variety of ways. Their reaction to such injuries depends on their Willpower and Constitution.")
	. += span_info("Willpower determines how much energy and stamina your character has, represented by the blue and green bars on your HUD. Likewise, it also determines how much pain you can withstand before incapacitation.")
	. += span_info("Constitution determines how much health your character has. The higher your Constitution, the more injuries you can withstand before suffering critical hits and-or dying.")
	. += span_info("Critical hits can be inflicted on limbs that're no longer protected by armor, and have already been severely damaged. These injuries are all debilitating, and can be fatal not treated.")
	. += span_info("Lifeblood, otherwise known as 'red' or 'health', heals most injuries. Needles, cloth, and bandages can stop bleeding. Water can restore lost blood. Bedrest and sleeping can fix most things with time.")
	. += span_info("Examining someone can show how much blood loss they've suffered; from being pale, to very pale, to extremely pale and sickly. If someone is barely conscious, this means they're critically wounded and will die without assistance.")
	. += span_info("Target someone's mouth and left-click them with an open hand on the 'WEAK' intent to manually breathe into them. This counteracts the onset of suffocation that comes with critical blood loss and other fatal wounds.")
	. += span_info("With that being said, members of the Church and Apothecarium are the most well-equipped for healing most wounds. Miracles and surgery can often be the only way to save your character from critical injuries and death.")

/obj/structure/fluff/walldeco/barbersignreverse
	name = "barberpole"
	desc = "The iconic swirl of the barber surgeon. </br>By toggling the 'Mechanics' tab, I can learn much more about this poster's given topic."
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "barbersignflip"
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/walldeco/barbersignreverse/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Your character can be wounded, and mended, in a wide variety of ways. Their reaction to such injuries depends on their Willpower and Constitution.")
	. += span_info("Willpower determines how much energy and stamina your character has, represented by the blue and green bars on your HUD. Likewise, it also determines how much pain you can withstand before incapacitation.")
	. += span_info("Constitution determines how much health your character has. The higher your Constitution, the more injuries you can withstand before suffering critical hits and-or dying.")
	. += span_info("Critical hits can be inflicted on limbs that're no longer protected by armor, and have already been severely damaged. These injuries are all debilitating, and can be fatal not treated.")
	. += span_info("Lifeblood, otherwise known as 'red' or 'health', heals most injuries. Needles, cloth, and bandages can stop bleeding. Water can restore lost blood. Bedrest and sleeping can fix most things with time.")
	. += span_info("Examining someone can show how much blood loss they've suffered; from being pale, to very pale, to extremely pale and sickly. If someone is barely conscious, this means they're critically wounded and will die without assistance.")
	. += span_info("Target someone's mouth and left-click them with an open hand on the 'WEAK' intent to manually breathe into them. This counteracts the onset of suffocation that comes with critical blood loss and other fatal wounds.")
	. += span_info("With that being said, members of the Church and Apothecarium are the most well-equipped for healing most wounds. Miracles and surgery can often be the only way to save your character from critical injuries and death.")

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
	works, and jealous protectors of the monopoly of their business. </br>By toggling the 'Mechanics' tab, I can learn much more about this poster's given topic."
	icon_state = "artificer"

/obj/structure/fluff/walldeco/artificerflag/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Most roles naturally rely on weapons and armor, either to protect themselves from those who'd do harm or to better leverage their position in an ongoing story.")
	. += span_info("Left-clicking the 'SKILLS' button in your HUD will show whatever skills your character currently has. Right-clicking it will instead show their traits, and - if applicable - their armor training.")
	. += span_info("Skills determine how proficent you are in a given field. There are six levels to every skill; NOVICE, APPRENTICE, JOURNEYMAN, EXPERT, MASTER, and LEGENDARY. For weapons, JOURNEYMAN is considered the baseline.")
	. += span_info("Most weapons specifically call upon a certain skill when determining their effectiveness. Using a longsword, for example, will check the character's Swordsmanship skill when determining its accuracy and chance to parry.")	
	. += span_info("Armor is simpler, for the most part. There are three weight classes; LIGHT, MEDIUM (for the 'Maille Training' trait), and HEAVY (for the 'Plate Training' trait). Wearing armor you aren't trained in leaves you sluggish and open for attacks.")
	. += span_info("Certain armor types provide better protection to certain attacks than others. A cloth gambeson, for example, thwarts piercing and blunt damage. A steel cuirass, on the other hand, stops slashing and clawing damage dead in its tracks.")
	. += span_info("Using armor and weapons as intended will gradually wear their integrity down. Once it breaks, they can no longer be used or provide protection. Blacksmiths, tailors, repair kits, and certain tools can amend this.")

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
	desc = "For the lord of coinage and commerce, look no further. </br>By toggling the 'Mechanics' tab, I can learn much more about this poster's given topic."
	plane = -1
	pixel_y = 16

/obj/structure/fluff/walldeco/sign/merchantsign/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Mammons reign as the primary form of currency within the kingdom, with bargaining and trading as a lesser alternative. There are three types of mammons; ZENNIES, ZILIQUAE, and ZENARII.")
	. += span_info("ZENNIES, or simply referred to as MAMMONS, are the backbone of the kingdom's economy. A pouch of TEN zennies can usually afford a decent meal with liqour at the inn, or some lesser supplies.")
	. += span_info("ZILIQUAE, better known as SILVER, are each worth FIVE MAMMONS. A stack of TEN ziliquae can usually afford a freshly-forged longsword of steel, or enough supplies for a dae's adventure.")
	. += span_info("ZENARII, better known as GOLD, are each worth TEN MAMMONS. A palmful of TEN zenarii can usuaully afford a well-mountable saiga, high-end lodging for the week, or most items on the market.")
	. += span_info("Your character almost always spawns with mammons; either in pouches, or inside their MEISTER's account. Earning more can be as simple as laboring, adventuring, or otherwise driving a hard bargain.")

/obj/structure/fluff/walldeco/sign/merchantsign/left
	icon_state = "shopsign_merchant_left"

/obj/structure/fluff/walldeco/psybanner
	name = "psydonic banner"
	desc = "A banner of fine fabric bearing the symbol of Psydon, the Weeping God, creator of the world. \
	Flown frequently by both Psydonite and Tennite authorities. </br>By toggling the 'Mechanics' tab, I can learn much more about this poster's given topic."
	icon_state = "Psybanner-PURPLE"

/obj/structure/fluff/walldeco/psybanner/red
	icon_state = "Psybanner-RED"

/obj/structure/fluff/walldeco/psybanner/tennite
	name = "ten undivided banner"
	icon_state = "unibanner_purple"
	desc = "A banner depicting a circle over a cross; the symbolism of the Ten Undivided, the sphere of \
	Tennite religious practice dedicated to the entirety of the pantheon without favour or preference. \
	Particularly strongly associated with the Grenzelhoftian Holy See."

/obj/structure/fluff/walldeco/psybanner/tennite/red
	icon_state = "unibanner_red"

/obj/structure/fluff/walldeco/psybanner/astrata
	name = "astratan banner"
	icon_state = "astratabanner_purple"
	desc = "The six-pronged cross of Astrata, embroidered upon fine fabric. It is Her will that \
	suspends the heavens and the earth, and it is Her light that maintains life upon the abandoned \
	surface of Psydonia. An image associated with the nobility of all lands, and with the \
	highest echelons of church leadership."

/obj/structure/fluff/walldeco/psybanner/astrata/red
	icon_state = "astratabanner_red"

/obj/structure/fluff/walldeco/psybanner/zizo
	name = "zizite banner"
	icon_state = "zizobanner_purple"
	desc = "A carefully made banner bearing the inverted cross of Zizo, Dame of Progress. Banners such \
	as this one are wildly dangerous to fly in any Tennite or Psydonite nation, in which the worship \
	of the progenitor of undeath is harshly criminalised, but may be commonly found in more remote \
	areas of the world."

/obj/structure/fluff/walldeco/psybanner/zizo/red
	icon_state = "zizobanner_red"

/obj/structure/fluff/walldeco/psybanner/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Faith is the most important aspect of lyfe, no matter if you're a peasant or a lord. Those with differing faiths oft-clash, both metaphorically and very literally.")
	. += span_info("Your character can choose from a wide variety of patrons to worship. The three most relevant groups, as of todae, are the PANTHEON, the ASCENDANTS, and GENESISM.")
	. += span_info("The PANTHEON, as the Church's official religion, is considered the 'status quo' within Azuria. They worship ONE of TEN GODS, all embodying certain aspects and virtues of humenity.")
	. += span_info("The ASCENDANTS are considered 'heathens' by the PANTHEON, and are actively hunted if made apparent within Azuria. They worship ONE of FOUR MORTALS-TURNED-GODS, who seek to usurp the 'status quo'.")
	. += span_info("At last, GENESISM is considered 'archaic' by both the PANTHEON and ASCENDANTS. They worship PSYDON; the SAVIOR of this world who's presence is all-but-gone. They are, for lack of a better term, a 'wild card'.")
	. += span_info("Irregardless of the chosen patron, your character is free - within reason - to interpret and worship their GOD in whatever way they see fit. After all, who's to say they aren't the only one that knows the TRUTH?")

/obj/structure/fluff/walldeco/stone
	name = ""
	desc = ""
	icon_state = "walldec1"
	mouse_opacity = 0

/obj/structure/fluff/walldeco/stone/bronze
	color = "#ff9c1a"

/obj/structure/fluff/walldeco/stone/stone2
	icon_state = "walldec2"

/obj/structure/fluff/walldeco/stone/stone3
	icon_state = "walldec3"

/obj/structure/fluff/walldeco/stone/stone4
	icon_state = "walldec4"

/obj/structure/fluff/walldeco/stone/stone5
	icon_state = "walldec5"

/obj/structure/fluff/walldeco/stone/stone6
	icon_state = "walldec6"

/obj/structure/fluff/walldeco/church/line
	name = ""
	desc = ""
	icon_state = "churchslate"
	mouse_opacity = 0
	layer = BELOW_MOB_LAYER+0.1

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
	name = "noccite banner"
	desc = "An embroidered banner depicting Noc, the Brother Moon, brother of Astrata and progenitor of \
	all knowledge. A favourite decoration of magicians and learned folk."
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
	desc = "A medical diagram depicting the interior structure of a humanoid hand. </br>By toggling the 'Mechanics' tab, I can learn much more about this poster's given topic."

/obj/structure/fluff/walldeco/med/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Your character can be wounded, and mended, in a wide variety of ways. Their reaction to such injuries depends on their Willpower and Constitution.")
	. += span_info("Willpower determines how much energy and stamina your character has, represented by the blue and green bars on your HUD. Likewise, it also determines how much pain you can withstand before incapacitation.")
	. += span_info("Constitution determines how much health your character has. The higher your Constitution, the more injuries you can withstand before suffering critical hits and-or dying.")
	. += span_info("Critical hits can be inflicted on limbs that're no longer protected by armor, and have already been severely damaged. These injuries are all debilitating, and can be fatal not treated.")
	. += span_info("Lifeblood, otherwise known as 'red' or 'health', heals most injuries. Needles, cloth, and bandages can stop bleeding. Water can restore lost blood. Bedrest and sleeping can fix most things with time.")
	. += span_info("Examining someone can show how much blood loss they've suffered; from being pale, to very pale, to extremely pale and sickly. If someone is barely conscious, this means they're critically wounded and will die without assistance.")
	. += span_info("Target someone's mouth and left-click them with an open hand on the 'WEAK' intent to manually breathe into them. This counteracts the onset of suffocation that comes with critical blood loss and other fatal wounds.")
	. += span_info("With that being said, members of the Church and Apothecarium are the most well-equipped for healing most wounds. Miracles and surgery can often be the only way to save your character from critical injuries and death.")

/obj/structure/fluff/walldeco/med2
	name = "diagram"
	icon_state = "medposter2"
	desc = "A medical diagram depicting an interior section of a humanoid body. </br>By toggling the 'Mechanics' tab, I can learn much more about this poster's given topic."

/obj/structure/fluff/walldeco/med2/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Your character can be wounded, and mended, in a wide variety of ways. Their reaction to such injuries depends on their Willpower and Constitution.")
	. += span_info("Willpower determines how much energy and stamina your character has, represented by the blue and green bars on your HUD. Likewise, it also determines how much pain you can withstand before incapacitation.")
	. += span_info("Constitution determines how much health your character has. The higher your Constitution, the more injuries you can withstand before suffering critical hits and-or dying.")
	. += span_info("Critical hits can be inflicted on limbs that're no longer protected by armor, and have already been severely damaged. These injuries are all debilitating, and can be fatal not treated.")
	. += span_info("Lifeblood, otherwise known as 'red' or 'health', heals most injuries. Needles, cloth, and bandages can stop bleeding. Water can restore lost blood. Bedrest and sleeping can fix most things with time.")
	. += span_info("Examining someone can show how much blood loss they've suffered; from being pale, to very pale, to extremely pale and sickly. If someone is barely conscious, this means they're critically wounded and will die without assistance.")
	. += span_info("Target someone's mouth and left-click them with an open hand on the 'WEAK' intent to manually breathe into them. This counteracts the onset of suffocation that comes with critical blood loss and other fatal wounds.")
	. += span_info("With that being said, members of the Church and Apothecarium are the most well-equipped for healing most wounds. Miracles and surgery can often be the only way to save your character from critical injuries and death.")

/obj/structure/fluff/walldeco/med3
	name = "diagram"
	icon_state = "medposter3"
	desc = "A medical diagram depicting an interior section of a humanoid body. </br>By toggling the 'Mechanics' tab, I can learn much more about this poster's given topic."

/obj/structure/fluff/walldeco/med3/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Your character can be wounded, and mended, in a wide variety of ways. Their reaction to such injuries depends on their Willpower and Constitution.")
	. += span_info("Willpower determines how much energy and stamina your character has, represented by the blue and green bars on your HUD. Likewise, it also determines how much pain you can withstand before incapacitation.")
	. += span_info("Constitution determines how much health your character has. The higher your Constitution, the more injuries you can withstand before suffering critical hits and-or dying.")
	. += span_info("Critical hits can be inflicted on limbs that're no longer protected by armor, and have already been severely damaged. These injuries are all debilitating, and can be fatal not treated.")
	. += span_info("Lifeblood, otherwise known as 'red' or 'health', heals most injuries. Needles, cloth, and bandages can stop bleeding. Water can restore lost blood. Bedrest and sleeping can fix most things with time.")
	. += span_info("Examining someone can show how much blood loss they've suffered; from being pale, to very pale, to extremely pale and sickly. If someone is barely conscious, this means they're critically wounded and will die without assistance.")
	. += span_info("Target someone's mouth and left-click them with an open hand on the 'WEAK' intent to manually breathe into them. This counteracts the onset of suffocation that comes with critical blood loss and other fatal wounds.")
	. += span_info("With that being said, members of the Church and Apothecarium are the most well-equipped for healing most wounds. Miracles and surgery can often be the only way to save your character from critical injuries and death.")

/obj/structure/fluff/walldeco/med4
	name = "diagram"
	icon_state = "medposter4"
	desc = "A medical diagram depicting a humanoid heart. </br>By toggling the 'Mechanics' tab, I can learn much more about this poster's given topic."

/obj/structure/fluff/walldeco/med4/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Sometimes, all the medicine and miracles in the world might just not be enough to save your character from dying.")
	. += span_info("Death, though unpleasant, will nevertheless be encountered - in one form or another, personal or external - during the course of a round. With that being said, death is rarely the end.")
	. += span_info("Those who've died beyond Azuria's walls will eventually become deadites; the lyving dead. Shambling back to the Town might offer them a second chance at lyfe, if they aren't laid to rest first.")
	. += span_info("Likewise, your head is the tether to your soul. So long as it is attached to a body of any sort, it can be resurrected through many means; the rites of Anastasis, the implantation of Lux, the ZRONKMACHINE, and much more.")
	. += span_info("If you prefer to stay dead, however, clicking the 'Leave Body' verb in the 'Spirit' tab will allow you to persist as a boundless spirit. Left-clicking the massive skull on your left will allow you to respawn as a new character.")
	. += span_info("While death can spell the end of one's story, it can also kindle the beginning of another one. Courtesy in both killing and being killed leads to a more pleasant experience for all.")

/obj/structure/fluff/walldeco/med5
	name = "diagram"
	icon_state = "medposter5"
	desc = "A medical diagram depicting a humanoid heart. </br>By toggling the 'Mechanics' tab, I can learn much more about this poster's given topic."

/obj/structure/fluff/walldeco/med5/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Sometimes, all the medicine and miracles in the world might just not be enough to save your character from dying.")
	. += span_info("Death, though unpleasant, will nevertheless be encountered - in one form or another, personal or external - during the course of a round. With that being said, death is rarely the end.")
	. += span_info("Those who've died beyond Azuria's walls will eventually become deadites; the lyving dead. Shambling back to the Town might offer them a second chance at lyfe, if they aren't laid to rest first.")
	. += span_info("Likewise, your head is the tether to your soul. So long as it is attached to a body of any sort, it can be resurrected through many means; the rites of Anastasis, the implantation of Lux, the ZRONKMACHINE, and much more.")
	. += span_info("If you prefer to stay dead, however, clicking the 'Leave Body' verb in the 'Spirit' tab will allow you to persist as a boundless spirit. Left-clicking the massive skull on your left will allow you to respawn as a new character.")
	. += span_info("While death can spell the end of one's story, it can also kindle the beginning of another one. Courtesy in both killing and being killed leads to a more pleasant experience for all.")

/obj/structure/fluff/walldeco/med6
	name = "diagram"
	icon_state = "medposter6"
	desc = "A medical diagram depicting a humanoid head. </br>By toggling the 'Mechanics' tab, I can learn much more about this poster's given topic."

/obj/structure/fluff/walldeco/med6/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Sometimes, all the medicine and miracles in the world might just not be enough to save your character from dying.")
	. += span_info("Death, though unpleasant, will nevertheless be encountered - in one form or another, personal or external - during the course of a round. With that being said, death is rarely the end.")
	. += span_info("Those who've died beyond Azuria's walls will eventually become deadites; the lyving dead. Shambling back to the Town might offer them a second chance at lyfe, if they aren't laid to rest first.")
	. += span_info("Likewise, your head is the tether to your soul. So long as it is attached to a body of any sort, it can be resurrected through many means; the rites of Anastasis, the implantation of Lux, the ZRONKMACHINE, and much more.")
	. += span_info("If you prefer to stay dead, however, clicking the 'Leave Body' verb in the 'Spirit' tab will allow you to persist as a boundless spirit. Left-clicking the massive skull on your left will allow you to respawn as a new character.")
	. += span_info("While death can spell the end of one's story, it can also kindle the beginning of another one. Courtesy in both killing and being killed leads to a more pleasant experience for all.")

/obj/structure/fluff/walldeco/alarm
	name = "réveil murmure"
	icon_state = "alarm"
	desc = "Ceci est une wall-mounted sentinelle."
	pixel_y = 32
	var/next_yap = 0
	var/onoff = 1 //Init on
	var/last_steak = 0
#define STEAK_ALARM_DISABLE_TIME 2 MINUTES // How long does the alarm stay silent.

/obj/structure/fluff/walldeco/alarm/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/peppersteak))
		say("... une petite sieste s'impose...")
		to_chat(user, span_smallnotice("You stuff a piece of steak into the alarm, quietening it for a while..."))
		last_steak = world.time
		qdel(I)
	if(istype(I, /obj/item/roguekey/lord) || istype(I, /obj/item/roguekey/skeleton))
		playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
		if(onoff == 0)
			onoff = 1
			icon_state = "alarm"
			say("Bonjour, la sentinelle est active.")
			next_yap = 0 //They won't believe us unless we yap again
			return
		if(onoff == 1)
			onoff = 0
			icon_state = "face"
			say("A moment's rest, merci, au revoir!")
			return
		else //failsafe
			onoff = 1
			icon_state = "alarm"

/obj/structure/fluff/walldeco/alarm/attack_hand(mob/living/user) //We shock anyone that touches it without appropriate key.

	user.changeNext_move(CLICK_CD_MELEE)

	playsound(src, 'sound/misc/machineno.ogg', 100, TRUE, -1)
	say("RETIRE THINE HAND FROM THE ALARM, CREECHER!")
	user.electrocute_act(12, src)
	return

/obj/structure/fluff/walldeco/alarm/Crossed(mob/living/user)

	if(onoff == 0)
		return

	if(next_yap > world.time) //Yap cooldown
		return

	if(last_steak && (last_steak + STEAK_ALARM_DISABLE_TIME >= world.time))
		return

	if(ishuman(user)) //are we a person?
		var/mob/living/carbon/human/HU = user

		if(HU.anti_magic_check()) //are we shielded?
			return

		if(!SStreasury.has_account(HU)) //first off- do we not have an account? we'll ALWAYS scream if that's the case
			playsound(loc, 'sound/misc/gold_license.ogg', 100, TRUE, -1)
			say("INTRUS! ARRESTEZ-VOUS! GARDES! GARDES! MAROUFLE A MORTIR!!")
			next_yap = world.time + 6 SECONDS
			return

		if(user.job in GLOB.noble_positions) //Ducal Family
			say( "[user.job] [user.real_name], vostre seigneurie, j'avions pour vous tout temps par tout temps")
			playsound(loc, 'sound/misc/gold_menu.ogg', 100, TRUE, -1)
			next_yap = world.time + 30 SECONDS
			return

		if((user.job in GLOB.courtier_positions) || (user.job in GLOB.retinue_positions)) //Courtiers and Keepites
			say("Salut au bon [user.real_name], [user.job] du Castel, who is logged entering ceste zone securisee.")
			playsound(loc, 'sound/misc/gold_menu.ogg', 100, TRUE, -1)
			next_yap = world.time + 30 SECONDS
			return

		if((user.job in GLOB.burgher_positions) || (user.job in GLOB.garrison_positions) || (user.job in GLOB.church_positions)) //Cityfolk and Garrison and Church
			say("Salutations, [user.real_name]. Thirty-breths silence period active por votre grace.")
			playsound(loc, 'sound/misc/gold_menu.ogg', 100, TRUE, -1)
			next_yap = world.time + 30 SECONDS
			return

		if((user.job in GLOB.peasant_positions) || (user.job in GLOB.sidefolk_positions) || (user.job in GLOB.inquisition_positions)) //Peasants and unimportant people to the crown.
			say("Salutations, [user.real_name]. I can spare some time por votre gueuserie.")
			playsound(loc, 'sound/misc/gold_menu.ogg', 100, TRUE, -1)
			next_yap = world.time + 30 SECONDS
			return

		if(SStreasury.has_account(HU)) //Anyone else
			playsound(loc, 'sound/misc/gold_menu.ogg', 100, TRUE, -1)
			say("[user.real_name] logged entering zone securisee.")
			return

		else //?????
			playsound(loc, 'sound/misc/gold_license.ogg', 100, TRUE, -1)
			say("INTRUS! ARRESTEZ-VOUS! GARDES! GARDES! MAROUFLE A MORTIR!!")
			next_yap = world.time + 6 SECONDS

	else
		playsound(loc, 'sound/misc/gold_license.ogg', 100, TRUE, -1)
		say("INTRUS! ARRESTEZ-VOUS! GARDES! GARDES! MAROUFLE A MORTIR!!")
		next_yap = world.time + 6 SECONDS

#undef STEAK_ALARM_DISABLE_TIME

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
	desc = "Well, that's what comes from too much spice and liqour! </br>By toggling the 'Mechanics' tab, I can learn much more about this poster's given topic."
	icon_state = "shopsign_inn_saiga_right"
	plane = -1
	pixel_x = 3
	pixel_y = 16

/obj/structure/fluff/walldeco/sign/saiga/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("With little exception, your character still needs to eat, drink, and sleep.")
	. += span_info("Eating food not only fills you up, but can also improve your character's mood and stats. Be careful, however, as eating improperly-prepared or poisoned food can have ill consequences.")
	. += span_info("Drinking follows the same tune. Middle-clicking puddles of water with the 'BITE' subintent selected can let you drink straight from the source, in a pinch. Be mindful of where you sip, however.")
	. += span_info("Neglecting to eat, drink, or sleep will negatively impact your character's mood and stats before long. Hunger saps Strength, thirst saps Willpower, and restlessness leaves you too exhausted to do much at all.")
	. += span_info("Remember, however, that a cool pint and a crisp frybird's leg tastes much better when enjoyed with the company of others. You'd be surprised what kinds of friends and enemies you can make, within a stocked inn.")
	. += span_info("Likewise, the inn - and the bathhouse, traditionally located beneath it - is the finest place to satiate many of mankind's most prominent vices.")

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

