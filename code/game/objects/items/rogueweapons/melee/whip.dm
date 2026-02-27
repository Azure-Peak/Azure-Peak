/obj/item/rogueweapon/whip
	force = 21
	possible_item_intents = list(/datum/intent/whip/lash, /datum/intent/whip/crack, /datum/intent/whip/punish)
	name = "whip"
	desc = "A leather whip, tipped with a flintknapped stone. Though intended to shepherd \
	unruly livestock, the tip's jagged points also suffice at leaving assailants with horrific lacerations."
	icon_state = "whip"
	icon = 'icons/roguetown/weapons/whips32.dmi'
	sharpness = IS_BLUNT
	//dropshrink = 0.75
	wlength = WLENGTH_LONG
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BELT
	associated_skill = /datum/skill/combat/whipsflails
	sewrepair = TRUE //Whips are mostly leather, with only a bit of metal or stone at the end. Should hopefully make more sense.
	parrysound = list('sound/combat/parry/parrygen.ogg')
	swingsound = WHIPWOOSH
	throwforce = 5
	wdefense = 0
	minstr = 6
	grid_width = 32
	grid_height = 64
	special = /datum/special_intent/whip_coil

/obj/item/rogueweapon/whip/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -10,"sy" = -3,"nx" = 11,"ny" = -2,"wx" = -7,"wy" = -3,"ex" = 3,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 22,"sturn" = -23,"wturn" = -23,"eturn" = 29,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

//////////////////////////
// INTENTS!             //
//////////////////////////

//Lash = default, can't dismember, so more range and some pen.
/datum/intent/whip/lash
	name = "lash"
	desc = "Lash the whip against a target from afar. </br>Uniquely deals lashing wounds, which inflicts tremendous blood loss and pain onto the target. </br>Critical hits leave permenant scars, unremovable under most circumstances."
	blade_class = BCLASS_LASHING
	attack_verb = list("lashes", "cracks")
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	chargetime = 0
	recovery = 7
	penfactor = 30
	reach = 3
	icon_state = "inlash"
	item_d_type = "slash"

//Exclusive variant to whips with alloyed tips and high Strength requirements. On par with a traditional lash, but can dismember from afar.
/datum/intent/whip/lash/master
	name = "lash with dismembering force"
	desc = "Lash the whip against a target from afar, leveraging your strength to lash their limbs apart. </br>Critical hits can uniquely dismember limbs and cause disembowelements."
	blade_class = BCLASS_CUT
	attack_verb = list("deftly lashes", "sharply cracks")

//Crack = cut damage, can dismember, so lower range.
/datum/intent/whip/crack
	name = "crack"
	desc = "Crack the whip's tip against a target, leaving terrible cuts in its wake. </br>Cracking can uniquely dismember limbs and cause disembowelments."
	blade_class = BCLASS_CUT				//Lets you dismember
	attack_verb = list("cracks", "strikes") //something something dwarf fotresss
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	chargetime = 0
	recovery = 10
	damfactor = 1.1
	penfactor = 20
	reach = 2
	icon_state = "incrack"
	item_d_type = "slash"

//Bludgeon = Sidegrade of the Crack that functions like a ranged mace. Unique to the Nagaika, or the Steppsman's whip.
/datum/intent/whip/crack/blunt
	name = "bludgeon"
	blade_class = BCLASS_BLUNT
	penfactor = BLUNT_DEFAULT_PENFACTOR
	recovery = 6
	reach = 2			//Less range than a normal whip by 1 compared to crack.
	icon_state = "instrike"
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

//Punish = Non-lethal sorta damage.
/datum/intent/whip/punish
	name = "punish"
	desc = "Lash the whip against a target from afar. </br>Uniquely deals lashing wounds, which inflicts tremendous pain onto the target. </br>Critical hits leave permenant scars, unremovable under most circumstances."
	blade_class = BCLASS_PUNISH
	attack_verb = list("lashes", "cracks")
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	chargetime = 0
	recovery = 5
	damfactor = 1.2							//No range, gets bonus damage - using this even on weak SHOULD let you get perma-scars then.
	penfactor = BLUNT_DEFAULT_PENFACTOR		//No pen cus punishment intent.
	reach = 1								//No range, cus not meant to be a flat-out combat intent.
	icon_state = "inpunish"
	item_d_type = "slash"

///////////////////
// UNIQUE WHIPS! //
///////////////////

/obj/item/rogueweapon/whip/nagaika
	name = "nagaika whip"
	desc = "A short but heavy leather whip, sporting a blunt reinforced tip and a longer handle."
	icon_state = "nagaika"
	force = 25		//Same as a cudgel/sword for intent purposes. Basically a 2 range cudgel while one-handing.
	possible_item_intents = list(/datum/intent/whip/crack/blunt, /datum/intent/whip/lash, /datum/intent/sword/strike)
	wdefense = 1	//Akin to a cudgel, still terrible at parrying though. Better than nothing I guess; thing is used irl as a counter-weapon to knives.

/obj/item/rogueweapon/whip/xylix
	name = "cackle lash"
	desc = "The chimes of this whip are said to sound as the trickster's laughter itself."
	icon_state = "xylixwhip"
	force = 24

/obj/item/rogueweapon/whip/spiderwhip
	force = 22
	name = "lashkiss whip"
	desc = "A dark whip with segmented, ashen spines for a base. Claimed to be hewn from dendrified prisoners of terror."
	icon_state = "spiderwhip"
	minstr = 6
	smeltresult = /obj/item/ingot/drow
	smelt_bar_num = 1

/obj/item/rogueweapon/whip/antique
	name = "\"Repenta En\""
	desc = "A multi-tailed whip that's extremely well-maintained. The gilded handle first burdens the hand with its inordinate weight, and then the mind with an unsettling realization; this is not a tool of honor. </br>'Ravox stands for justice, not murder.'"
	force = 25
	minstr = 11
	icon_state = "gwhip"

/obj/item/rogueweapon/whip/bronze
	name = "bronze whip"
	desc = "A heavy whip, corded from thick leather and adorned with a razor-sharp bronzehead. In ancient tymes, this shepherd's weapon once repelled the gnashing teeth of bloodthirsty nitebeasts: now, it seperates limb-from-trunk with thunderous claps. </br>Holding this whip imbues you with determination.. and a rather odd hankering for turkey dinners."
	icon_state = "bronzewhip"
	force = 21
	minstr = 11
	possible_item_intents = list(/datum/intent/whip/lash/master, /datum/intent/whip/crack, /datum/intent/whip/punish)
	smeltresult = /obj/item/ingot/bronze

/obj/item/rogueweapon/whip/antique/psywhip
	name = "Daybreak"
	desc = "A chain-linked whip, meticulously assembled from a hundred pieces of blessed silver. Its origins are steeped in mythos: most believe it to originate from an ancient bloodline of vampyre-killers, which once saved Psydonia from a powerful lyckerlorde. Whether it was happenstance or fate itself that eventually led it into your grasp, however, is better left unspoken. </br>'There, upon the Cathedral's ceiling, was painted a scene-most-beautiful: of a robed Psydon standing before the Archdevil, parting the nite's sky with a crack from His fiery whip. Just as He had done prior, so too must you bring daelight to the darkness.'"
	icon_state = "psywhip"
	is_silver = TRUE
	force = 25
	possible_item_intents = list(/datum/intent/whip/lash/master, /datum/intent/whip/crack, /datum/intent/whip/punish)
	minstr = 11
	wdefense = 0
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/whip/antique/psywhip/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 100,\
		added_def = 0,\
	)

/obj/item/rogueweapon/whip/silver
	name = "silver whip"
	desc = "A hefty, silver whip. The uncoiled leather is tipped with a silver barb, which can sunder the blighted from a remarkable distance. </br>'Die, monster! You don't belong in this world!'"
	icon_state = "silverwhip"
	force = 23 //Experimental change - adds a +2 to force, as a bridge between handweapons and blunt weapons. Higher strength minimum. Do not raise above 25, unless you want to resurrect maille-shatterers.
	possible_item_intents = list(/datum/intent/whip/lash/master, /datum/intent/whip/crack, /datum/intent/whip/punish)
	minstr = 11
	wdefense = 0
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/whip/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 0,\
	)

/obj/item/rogueweapon/whip/psywhip_lesser
	name = "psydonic whip"
	desc = "An ornate whip, plated in a ceremonial veneer of silver. Crack the leather and watch as the apostates clammer aside."
	icon_state = "psywhip_lesser"
	possible_item_intents = list(/datum/intent/whip/lash/master, /datum/intent/whip/crack, /datum/intent/whip/punish)
	force = 23
	minstr = 11
	wdefense = 0
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/whip/psywhip_lesser/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 0,\
	)
