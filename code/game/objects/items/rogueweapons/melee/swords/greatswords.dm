
/obj/item/rogueweapon/greatsword
	force = 12
	force_wielded = 30
	possible_item_intents = list(/datum/intent/sword/chop, /datum/intent/sword/strike) //bash is for nonlethal takedowns, only targets limbs
	// Design Intent: I have a big fucking sword and I want to cut everything in sight.
	gripped_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/sword/thrust/zwei, /datum/intent/sword/cut/zwei/cleave, /datum/intent/sword/cut/zwei/sweep)
	alt_grips = list(/datum/alt_grip/mordhau/greatsword, /datum/alt_grip/halfsword/greatsword)
	name = "greatsword"
	desc = "Might be able to chop anything in half!"
	icon_state = "gsw"
	parrysound = list(
		'sound/combat/parry/bladed/bladedlarge (1).ogg',
		'sound/combat/parry/bladed/bladedlarge (2).ogg',
		'sound/combat/parry/bladed/bladedlarge (3).ogg',
		)
	icon = 'icons/roguetown/weapons/swords64.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	swingsound = BLADEWOOSH_HUGE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 9
	smeltresult = /obj/item/ingot/steel
	associated_skill = /datum/skill/combat/swords
	max_blade_int = 300
	wdefense = 5
	smelt_bar_num = 3
	special = /datum/special_intent/greatsword_swing

/obj/item/rogueweapon/greatsword/getonmobprop(tag)
	. = ..()
	if(tag == "altgrip" && .)
		return .
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -50,"sturn" = 40,"wturn" = 50,"eturn" = -50,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
			if("altgrip")
				return list("shrink" = 0.6,"sx" = 4,"sy" = 0,"nx" = -7,"ny" = 1,"wx" = -8,"wy" = 0,"ex" = 8,"ey" = -1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -135,"sturn" = -35,"wturn" = 45,"eturn" = 145,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/greatsword/elfgsword
	name = "elven kriegsmesser"
	desc = "An elegant greatsword, crested with a glistening blade that - in spite of its intimidating length - is mysteriously light. Unlike most elven masterworks, the grip is dressed in rosaleather; a foreboding symbol, christening it as a weapon of war against those who'd threaten elvekind."
	icon_state = "elfkriegmesser"
	item_state = "elfkriegmesser"
	minstr = 10
	wdefense = 7
	sellprice = 120

/obj/item/rogueweapon/greatsword/elfgsword/getonmobprop(tag)
	. = ..()
	if(tag == "altgrip" && .)
		return .
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -50,"sturn" = 40,"wturn" = 50,"eturn" = -50,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("altgrip")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 85,"sturn" = 265,"wturn" = 275,"eturn" = 85,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 4,"sflip" = 4,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = -1,"sy" = 3,"nx" = -1,"ny" = 2,"wx" = 3,"wy" = 4,"ex" = -1,"ey" = 5,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 20,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/greatsword/iron
	name = "iron greatsword"
	desc = "A massive sword of iron, requiring both hands to properly wield. Heftier and less sturdier than its steel equivalent - but it still does the job."
	icon_state = "igsw"
	max_blade_int = 200
	max_integrity = 200
	wdefense = 4
	smelt_bar_num = 3
	smeltresult = /obj/item/ingot/iron

/obj/item/rogueweapon/greatsword/aalloy
	name = "decrepit greatsword"
	desc = "A massive blade, wrought in frayed bronze. It is too big to be called a sword; massive, thick, heavy, and far too rough. Indeed, this blade was more like a heap of raw metal."
	force = 10
	force_wielded = 25
	max_integrity = 150
	icon_state = "ancient_gsw"
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null
	randomize_blade_int_on_init = TRUE


/obj/item/rogueweapon/greatsword/paalloy
	name = "ancient greatsword"
	desc = "A massive blade, forged from polished gilbronze. Your kind will discover your true nature, in wrath and ruin. You will take to the stars and burn them out, one by one. Only when the last star turns to dust, will you finally realize that She was trying to save you from Man's greatest foe; oblivion."
	icon_state = "ancient_gsw"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/greatsword/zwei
	name = "claymore"
	desc = "This is much longer than a common greatsword, and well balanced too!"
	icon_state = "claymore"
	smeltresult = /obj/item/ingot/iron
	smelt_bar_num = 3
	max_blade_int = 220
	wdefense = 4
	force = 14
	force_wielded = 35

/obj/item/rogueweapon/greatsword/grenz
	name = "steel zweihander"
	icon_state = "steelzwei"
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 3
	max_blade_int = 240
	wdefense = 4
	force = 14
	force_wielded = 35

/obj/item/rogueweapon/greatsword/grenz/flamberge
	name = "steel flamberge"
	desc = "A close relative of the Grenzelhoftian \"zweihander\", favored by Otavan nobility. The name comes from its unique, flame-shaped blade; a labor only surmountable by Psydonia's finest weaponsmiths."
	icon_state = "steelflamberge"
	max_blade_int = 180
	max_integrity = 130
	wdefense = 6

/obj/item/rogueweapon/greatsword/grenz/flamberge/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -50,"sturn" = 40,"wturn" = 50,"eturn" = -50,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/greatsword/grenz/flamberge/malum
	name = "forgefiend flamberge"
	desc = "This sword's creation took a riddle in its own making. A great sacrifice was made for a blade of perfect quality."
	icon_state = "malumflamberge"
	max_integrity = 200
	max_blade_int = 200

/obj/item/rogueweapon/greatsword/grenz/flamberge/ravox
	name = "Censure"
	desc = "A blade that invites imagery of hope. Of men clad in shattered plate and bearing blackened pauldrons, \
	standing at His side. To correct Her wrongs, as they sought the censure of divine tyranny. \
	<small>Even now, it smells of ash.</small>"
	icon_state = "ravoxflamberge"
	max_integrity = 240
	max_blade_int = 240
	wdefense = 7//You are truly unique, m'lord.

/obj/item/rogueweapon/greatsword/grenz/flamberge/blacksteel
	name = "blacksteel flamberge"
	desc = "An uncommon kind of sword with a characteristically undulating style of blade, made with an equally rare metal. \
	The wave in the blade is considered to contribute a flame-like quality to its appearance, turning it into a menacing sight. \
	\"Flaming swords\" are often the protagonists of Otavan epics and other knights' tales."
	icon_state = "blackflamb"
	force = 25
	force_wielded = 40
	max_blade_int = 200
	smeltresult = /obj/item/ingot/blacksteel
	smelt_bar_num = 2 // Okay you CAN get a refund on the blacksteel

/obj/item/rogueweapon/greatsword/silver
	name = "silver greatsword"
	desc = "A greatsword with a massive blade of pure silver. Such is favored amongst the Order of Syonica's paladins: a faith-militance that seeks to safeguard those who've taken pilgrimage towards Azuria. </br>'There is no fate, but what we make for ourselves. It is not the will of gods that will determine Psydonia's fate.. but instead, the hope of its children.'"
	icon_state = "silverexealt"
	force = 8
	force_wielded = 25
	minstr = 11
	wdefense = 6
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/greatsword/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greatsword/psygsword
	name = "psydonic greatsword"
	desc = "It is said that a Psydonian smith was guided by Saint Malum himself to forge such a formidable blade, and given the task to slay a daemon preying on the Otavan farmlands. The design was retrieved, studied, and only a few replicas made - for they believe it dulls its edge."
	icon_state = "silverexealt"
	force = 8
	force_wielded = 25
	minstr = 11
	wdefense = 6
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/greatsword/psygsword/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greatsword/psygsword/relic
	name = "Apocrypha"
	desc = "In the Otavan mosaics, Saint Ravox - bare in all but a beaked helmet and loincloth - is often depicted wielding such an imposing greatweapon against the Sinistar, Graggar. Regardless of whether this relic was actually wielded by divinity-or-not, its unparallel strength will nevertheless command even the greatest foes to fall."
	force = 25
	force_wielded = 30
	icon_state = "psygsword"
	possible_item_intents = list(/datum/intent/sword/chop/heavy, /datum/intent/sword/cut/zwei, /datum/intent/sword/thrust/exe, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/sword/chop/cleave, /datum/intent/rend, /datum/intent/sword/cut/zwei, /datum/intent/sword/thrust/heavy)
	minstr = 13
	minstr_req = TRUE

/obj/item/rogueweapon/greatsword/psygsword/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 100,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greatsword/psygsword/relic/getonmobprop(tag)
	. = ..()
	if(tag == "altgrip" && .)
		return .
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("altgrip") 
				return list("shrink" = 0.45,"sx" = 2,"sy" = 3,"nx" = -7,"ny" = 1,"wx" = -8,"wy" = 0,"ex" = 8,"ey" = -1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -135,"sturn" = -35,"wturn" = 45,"eturn" = 145,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)

/obj/item/rogueweapon/greatsword/bsword/psy
	name = "forgotten blade"
	desc = "'Let His name be naught but forgot'n.'"
	icon_state = "oldpsybroadsword"
	force = 20
	force_wielded = 25
	minstr = 11
	wdefense = 6
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/chop/heavy, /datum/intent/sword/thrust/long, /datum/intent/rend/krieg)
	gripped_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/sword/chop/heavy, /datum/intent/sword/thrust/estoc/lunge, /datum/intent/sword/thrust/estoc)
	alt_grips = list(/datum/alt_grip/mordhau/broadsword/forgotten_blade)
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/greatsword/bsword/psy/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greatsword/bsword/psy/relic
	name = "Creed"
	desc = "Psydonian prayers and Tennite smiths, working as one to craft a weapon to slay the Four. A heavy and large blade, favored by Saint Ravox, to lay waste to those who threaten His flock. The crossguard's psycross reflects even the faintest of Noc's light. You're the light - show them the way."
	icon_state = "psybroadsword"
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/greatsword/bsword/psy/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list("shrink" = 0.5, "sx" = -14, "sy" = -8, "nx" = 15, "ny" = -7, "wx" = -10, "wy" = -5, "ex" = 7, "ey" = -6, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = -13, "sturn" = 110, "wturn" = -60, "eturn" = -30, "nflip" = 1, "sflip" = 1, "wflip" = 8, "eflip" = 1)
			if("wielded") return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onback") return list("shrink" = 0.5, "sx" = -1, "sy" = 2, "nx" = 0, "ny" = 2, "wx" = 2, "wy" = 1, "ex" = 0, "ey" = 1, "nturn" = 0, "sturn" = 0, "wturn" = 70, "eturn" = 15, "nflip" = 1, "sflip" = 1, "wflip" = 1, "eflip" = 1, "northabove" = 1, "southabove" = 0, "eastabove" = 0, "westabove" = 0)
			if("onbelt") return list("shrink" = 0.3, "sx" = -4, "sy" = -6, "nx" = 5, "ny" = -6, "wx" = 0, "wy" = -6, "ex" = -1, "ey" = -6, "nturn" = 100, "sturn" = 156, "wturn" = 90, "eturn" = 180, "nflip" = 0, "sflip" = 0, "wflip" = 0, "eflip" = 0, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0)

/obj/item/rogueweapon/greatsword/bsword/psy/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 100,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greatsword/bsword/psy/unforgotten
	name = "unforgotten blade"
	desc = "High Inquisitor Archibald once recorded an expedition of seven brave Adjudicators into Gronnian snow-felled wastes to root out evil. Its leader, Holy Ordinator Guillemin, was said to have held on for seven daes and seven nights against darksteel-clad heretics before Psydon acknowledged his endurance. Nothing but his blade remained - his psycross wrapped around its hilt in rememberance."
	icon_state = "forgottenblade"
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/greatsword/bsword/psy/unforgotten/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/estoc
	name = "estoc"
	desc = "A sword possessed of a quite long and tapered blade that is intended to be thrust between the \
	gaps in an opponent's armor. The hilt is wrapped tight in black leather, and the crossguard is uniquely \
	adorned with opposingly-curved quillons; perfect for parrying the poised perforations of opponents."
	icon_state = "estoc"
	icon = 'icons/roguetown/weapons/swords64.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 20
	force_wielded = 25
	possible_item_intents = list(
		/datum/intent/sword/thrust,
		/datum/intent/sword/strike,
	)
	gripped_intents = list(
		/datum/intent/sword/thrust/estoc,
		/datum/intent/sword/thrust/estoc/lunge,
		/datum/intent/sword/strike,
	)
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 8
	smeltresult = /obj/item/ingot/steel
	associated_skill = /datum/skill/combat/swords
	max_blade_int = 400
	max_integrity = 300
	wdefense = 3
	wdefense_wbonus = 6
	smelt_bar_num = 2

/obj/item/rogueweapon/estoc/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6, "sx" = -6, "sy" = 7, "nx" = 6, "ny" = 8, "wx" = 0, "wy" = 6, "ex" = -1, "ey" = 8, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = -50, "sturn" = 40, "wturn" = 50, "eturn" = -50, "nflip" = 0, "sflip" = 8, "wflip" = 8, "eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

//Elven weapons originally sprited and added by Jamdrawers.
/obj/item/rogueweapon/greatsword/elvish
	possible_item_intents = list(/datum/intent/sword/chop,/datum/intent/sword/strike) //bash is for nonlethal takedowns, only targets limbs
	// Design Intent: It is pretty purely a two-handed weapon. In one hand it's a bit clumsy.
	gripped_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/rend, /datum/intent/sword/thrust/zwei, /datum/intent/sword/strike/bad)
	alt_grips = null // can't be alt-gripped
	name = "elvish curveblade"
	desc = "The Elven Curveblade is a traditional weapon, its practice as much a dance as a method of death. Flowing like the water's current, let its path lead to your enemy's throat."
	icon_state = "elfcurveblade"
	wlength = WLENGTH_LONG// Less reach than greatsword!
	minstr = 7// Lighter
	wdefense = 8// Better defence than greatsword
	sellprice = 60
