//spear datums ฅ^•ﻌ•^ฅ
/obj/item/rogueweapon/spear
	name = "spear"
	desc = "One of the oldest weapons still in use today, second only to the club. The lack of reinforcements along the \
	shaft leaves it vulnerable to being split in two."
	icon_state = "spear"
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	force = 22
	force_wielded = 30
	possible_item_intents = list(SPEAR_THRUST_1H, SPEAR_CUT_1H)
	gripped_intents = list(SPEAR_THRUST, SPEAR_CUT, SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 8
	max_blade_int = 180
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/iron
	associated_skill = /datum/skill/combat/polearms
	walking_stick = TRUE
	wdefense = 4.5
	thrown_bclass = BCLASS_STAB
	throwforce = 25
	resistance_flags = FLAMMABLE
	special = /datum/special_intent/polearm_backstep
	twirly = SKILL_LEVEL_EXPERT // safely twirling like, a halberd, is going to be harder than a blunt staff
	twirl_speed = 6

/obj/item/rogueweapon/spear/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/obj/item/rogueweapon/spear/short
	name = "short spear"
	icon_state = "short_spear"
	force = 25
	force_wielded = 25
	possible_item_intents = list(SHORT_SPEAR_THRUST, SHORT_SPEAR_CUT)
	gripped_intents = list(SHORT_SPEAR_THRUST, SHORT_SPEAR_CUT, SPEAR_BASH)
	wlength = WLENGTH_LONG

/obj/item/rogueweapon/spear/cleric
	name = "anointed spear"
	desc = "A crusader's spear, adorned with a blade of cold iron and blessed to smite evil. Though this blessed alloy lacks the strength to \
	sunder those who bear greater curses, it nevertheless channels enough power to dispel the lesser curses of mindless fiends-and-foes."
	icon_state = "crusaderspear"
	force = 20
	force_wielded = 25
	wdefense = 6
	max_blade_int = 230
	max_integrity = 300
	smeltresult = /obj/item/ingot/iron
	is_even_lesser_silver = TRUE // adv paladin exclusive weapon, works like unblessed silver but only in pve

/obj/item/rogueweapon/spear/holysee
	name = "see spear"
	desc = "A blessed spear, wielded by the Holy See's templars to keep the forces of evil at bay. The design is remarkably \
	well-balanced, allowing it for effective off-handed use with a shield. The prongs seem to catch even the tiniest glimmer \
	of daelight, magnifying it into a blinding glare. </br>'I fear no evil, my Gods, for thou art with me!'"
	icon_state = "gsspear"
	force = 25 // better in one hand. Use it with the shield.
	max_blade_int = 225
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/spear/spellblade
	name = "dory"
	icon_state = "short_spear"
	desc = "A shortened spear, six feet long and balanced. Favored by Azurean Spellblades \
		who found the traditional long spear ill-suited for their flashy, individualistic fighting style. \
		Designed to thrust quickly from one hand but maneuver nimbly in two.<BR><BR> \
		'From this dae on, we shall name ourselves naught spearman, but phalangite, and our spear, the dory, not a shortspear. \
		And with this measure we shall gain great respect henceforth.' - Unknown Grandmaster of the Azurean Spellblade Order, 900 AP."
	force = 20
	force_wielded = 25
	possible_item_intents = list(/datum/intent/spear/thrust/azurean/oneh)
	gripped_intents = list(/datum/intent/spear/thrust/azurean, /datum/intent/spear/thrust/azurean/pick, SPEAR_BASH)
	wlength = WLENGTH_LONG
	w_class = WEIGHT_CLASS_BULKY
	minstr = 7
	max_blade_int = 180
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/iron
	associated_skill = /datum/skill/combat/polearms
	wdefense = 4
	thrown_bclass = BCLASS_STAB
	throwforce = 22
	resistance_flags = FLAMMABLE
	armor_penetration = PEN_NONE

/obj/item/rogueweapon/spear/trainer
	name = "sparring spear"
	desc = "An old dulled spear with a shaft worn by the hands of countless trainees before you. The fabric and watting wrap is meant to protect combatants, \
	but getting hit with this still leaves welts and breaks fingers."
	icon_state = "spear_trainer"
	possible_item_intents = list(SPEAR_TRAINER_THRUST1H, SPEAR_BASH)
	gripped_intents = list(SPEAR_TRAINER_THRUST, SPEAR_BASH, MACE_SMASH_WOOD)
	force = 7
	force_wielded = 15
	sharpness = IS_BLUNT
	thrown_bclass = BCLASS_BLUNT

/obj/item/rogueweapon/spear/trainer/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 2,"nx" = 8,"ny" = 2,"wx" = -4,"wy" = 2,"ex" = 1,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 300,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 100,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 4,"sy" = -2,"nx" = -3,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/obj/item/rogueweapon/spear/stone
	name = "stone spear"
	desc = "This handmade spear is simple, but does the job."
	icon_state = "stonespear"
	force = 15
	force_wielded = 18
	minstr = 6
	max_blade_int = 70
	smeltresult = null
	anvilrepair = /datum/skill/craft/crafting
	wdefense = 4
	max_integrity = 50
	throwforce = 20
	special = null

/obj/item/rogueweapon/spear/stone/copper
	name = "copper spear" // Copper spear, no point to adjust force just slightly better integrity
	desc = "A simple spear with a copper tip. More durable than stone, but not much better."
	force = 18
	force_wielded = 22
	max_integrity = 100
	icon_state = "cspear"
	smeltresult = /obj/item/ingot/copperslag
	anvilrepair = /datum/skill/craft/weaponsmithing
	special = /datum/special_intent/polearm_backstep

/obj/item/rogueweapon/spear/bonespear
	name = "bone spear"
	desc = "Yesterday's hunt, tomorrow's weapon."
	icon_state = "bonespear"
	force = 18
	force_wielded = 22
	minstr = 6
	max_blade_int = 80
	smeltresult = null
	wdefense = 4
	max_integrity = 60
	throwforce = 20
	special = null
	materia = list(/datum/materia_aspect/weapon, /datum/materia_aspect/death)

/obj/item/rogueweapon/spear/aalloy
	name = "decrepit spear"
	desc = "A rotting staff, tipped with rotted metal. After the stone, but before the sword; an interlude for the violence that would soon \
	engulf His world."
	icon_state = "ancient_spear"
	force = 13
	force_wielded = 22
	max_integrity = 120
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null

/obj/item/rogueweapon/spear/paalloy
	name = "ancient spear"
	desc = "A gnarled staff, tipped with polished gilbranze. Your breathing hilts, and your knuckles tighten around the staff; you \
	see what is yet to come, yet your mind refuses to retain it. To know what fate this dying world has - it would drive any man inzane."
	smeltresult = /obj/item/ingot/aaslag
	icon_state = "ancient_spear"

/obj/item/rogueweapon/spear/silver
	name = "silver spear"
	desc = "A winged staff, tipped with a silver spearhead. It bears a resemblenece to the 'boar spear', but with a critical difference; instead \
	of stopping hogs, it halts charging deadites from spreading their sickness any further."
	icon_state = "silverspear"
	force = 20
	force_wielded = 30
	minstr = 8
	wdefense = 5
	is_silver = TRUE
	resistance_flags = FIRE_PROOF	//It's meant to be smacked by a "lamptern", and is special enough to warrant overriding the spear weakness
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/spear/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE\
	)

/obj/item/rogueweapon/spear/silver/psy
	name = "psydonic spear"
	desc = "An ornate spear, plated in a ceremonial veneer of silver. The barbs pierce your palm, and - for just a moment - you see red. Never \
	forget that you are why Psydon wept."
	icon_state = "psyspear"
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/spear/silver/psy/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN\
	)

/obj/item/rogueweapon/spear/silver/psy/preblessed/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN\
	)

/obj/item/rogueweapon/spear/silver/psy/old
	name = "enduring spear"
	desc = "An ornate spear, its silver tarnished by neglect. HE still guides the faithful's hand, if not this weapon."
	icon_state = "psyspear"
	force = 20
	force_wielded = 30
	minstr = 8
	wdefense = 5
	is_silver = FALSE
	smeltresult = /obj/item/ingot/steel
	color = COLOR_FLOORTILE_GRAY

/obj/item/rogueweapon/spear/silver/psy/old/ComponentInitialize()
	return

/obj/item/rogueweapon/spear/naginata
	name = "naginata"
	desc = "A traditional Kazengunese polearm, combining the reach of a spear with the cutting power of a curved blade. Due \
	to the brittle quality of Kazengunese bladesmithing, weaponsmiths have adapted its blade to be easily replaceable when \
	broken by a peg upon the end of the shaft."
	force = 16
	force_wielded = 30
	possible_item_intents = list(/datum/intent/spear/cut/naginata, SPEAR_BASH) // no stab for you little chuddy, it's a slashing weapon
	gripped_intents = list(/datum/intent/spear/cut/naginata, /datum/intent/spear/cut/naginata/sweep, /datum/intent/rend/reach, SPEAR_BASH)
	icon_state = "naginata"
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	minstr = 7
	max_blade_int = 220 //Glaive/Greatsword side-grade. Worse blade integrity and versatility than a greatsword, 20% extra damage on the cut, same as glaive. Tiny bump in defense and blade integ in exchange for losing thrust.
	wdefense = 5
	throwforce = 12	//Not a throwing weapon.
	icon_angle_wielded = 50
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/spear/naginata/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 2,"nx" = 8,"ny" = 2,"wx" = -4,"wy" = 2,"ex" = 1,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 300,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 100,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 4,"sy" = -2,"nx" = -3,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/obj/item/rogueweapon/spear/assegai
	name = "steel assegai"
	desc = "A long spear originating from the southern regions of Naledi. Commoners living along the great river Bilomari \
	are taught to use assegai so they can defend themselves against the Djinn."
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	max_integrity = 250
	max_blade_int = 200
	icon_state = "assegai_steel"
	gripsprite = FALSE
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/spear/assegai/iron
	name = "iron assegai"
	desc = "A long spear originating from the southern regions of Naledi. Commoners living along the great river Bilomari are \
	taught to use assegai so they can defend themselves against the Djinn."
	max_integrity = 150
	max_blade_int = 150
	icon_state = "assegai_iron"
	gripsprite = FALSE

/obj/item/rogueweapon/spear/bronze
	name = "bronze spear"
	desc = "An antiquital staff, adorned with a bronze spearhead. Ancient in both design and purpose, its lighter weight once \
	complimented the towering shields of precivilizational legionnaires. While rarely seen beyond the Deadlands, nowadaes, its \
	lightweight balance makes it perfect for one-handed thrusts and throws."
	force = 25
	force_wielded = 28
	throwforce = 30
	icon_state = "bronzespear"
	smeltresult = /obj/item/ingot/bronze
	armor_penetration = PEN_LIGHT //In-between a spear and javelin.
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 33, "embedded_fall_chance" = 2)
	max_blade_int = 225
	max_integrity = 155

/obj/item/rogueweapon/spear/bronze/winged
	name = "bronze winged spear"
	desc = "An antiquital staff, adorned with a winged bronze spearhead. The flared edges catch errant strikes and keep snarling foes from \
	further impaling themselves in order to maul its wielder. </br>Scholars believe this particular type of polearm was made to counter Vheslynic \
	seadaemons, during the now-mythologized Syonic era's collapse."
	icon_state = "bronzewingedspear"
	item_state = "bronzewingedspear"
	wdefense = 6 //Functionally the same, but with +1 DEF.

/obj/item/rogueweapon/spear/bronze/strapless
	desc = "An antiquital staff, adorned with a bronze spearhead. Ancient in both design and purpose, its lighter weight once complimented \
	the towering shields of precivilizational legionnaires. While rarely seen beyond the Deadlands, nowadaes, its lightweight balance makes \
	it perfect for one-handed thrusts and throws. </br>This particular spear has a thin strap running along its grain, allowing it to be stowed \
	without the need for a greatweapon strap."
	slot_flags = ITEM_SLOT_BACK //Option-unique, uncraftable. Ensures the loadout doesn't implode on itself.
	equip_delay_self = 2 SECONDS
	unequip_delay_self = 2 SECONDS
	inv_storage_delay = 1 SECONDS

/obj/item/rogueweapon/spear/bronze/winged/strapless
	desc = "An antiquital staff, adorned with a winged bronze spearhead. The flared edges catch errant strikes and keep snarling foes from further \
	impaling themselves in order to maul its wielder. </br>Scholars believe this particular type of polearm was made to counter Vheslynic seadaemons, \
	during the now-mythologized Syonic era's collapse. </br>This particular spear has a thin strap running along its grain, allowing it to be stowed \
	without the need for a greatweapon strap."
	slot_flags = ITEM_SLOT_BACK //Ditto.
	equip_delay_self = 2 SECONDS
	unequip_delay_self = 2 SECONDS
	inv_storage_delay = 1 SECONDS

/obj/item/rogueweapon/spear/partizan
	name = "partizan"
	desc = "A reinforced spear-like polearm of disputed origin: A studded shaft fitted with a steel spearhead with protrusions to aid in \
	arrying. An extremely recent invention that is seeing increasingly more usage in the Western lands."
	force = 8	//Not a possible one-handed weapon. Also too heavy!
	force_wielded = 30
	possible_item_intents = list(SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(SPEAR_THRUST, SPEAR_CUT, PARTIZAN_REND)
	icon_state = "partizan"
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	minstr = 10
	max_blade_int = 200
	wdefense = 5 // It IS a parrying spear after all.
	throwforce = 12	//Not a throwing weapon. Too heavy!
	icon_angle_wielded = 50
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/spear/partizan/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 2,"nx" = 8,"ny" = 2,"wx" = -4,"wy" = 2,"ex" = 1,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 300,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 100,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 4,"sy" = -2,"nx" = -3,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/obj/item/rogueweapon/spear/boar
	name = "boar spear"
	desc = "A spear with a wide head and a pair of wings below the head. The wings are designed to prevent a boar from charging past the spearhead. \
	It is also useful for parrying and stopping a charging opponent."
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	icon_state = "boarspear"
	force_wielded = 33 // 10% base damage increase
	wdefense = 5 // A little bit extra
	max_blade_int = 200
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/spear/boar/noc
	name = "moonlight spear"
	desc = "A spear with a wide head and a pair of wings below the head. The wings are designed to prevent a boar from charging past the spearhead. \
	It is also useful for parrying and stopping a charging opponent. This one in particular is made of blued steel."
	icon_state = "nocspear"

/obj/item/rogueweapon/spear/boar/frei
	name = "Aavnic lándzsa"
	desc = "A regional earspoon lance with a carved handle, adorned with the colours of the Freifechters. These are smithed \
	by the legendary armourers of Vyšvou and given to distinguished lancers upon their graduation."
	icon_state = "cityspear"
	icon = 'icons/roguetown/weapons/special/freifechter.dmi'
	max_blade_int = 300	//You're gonna parry a lot. You need it.
	max_integrity = 235

/obj/item/rogueweapon/spear/boar/frei/pike
	name = "banner of Szöréndnížina"
	desc = "A steel pike with a white and red banner made to spend the time flowing proudly in the wind. A city founded by the \
	free. A State made from the disciplined. Snowy peaks surround her strong walls, her gates make any attack a \
	suicide. Fight, Szöréndnížina. Fight to lyve in a world that rejects you."
	icon_state = "citybanner"
	force = 18
	force_wielded = 33
	possible_item_intents = list(/datum/intent/dagger/sucker_punch, SWORD_STRIKE, /datum/intent/spear/cut/oneh/pike)
	gripped_intents = list(/datum/intent/spear/thrust/pike, /datum/intent/spear/thrust/pike/skewer)

/obj/item/rogueweapon/spear/boar/frei/pike/reformist
	name = "banner of Psydonic Reformism"
	desc = "A steel pike with an altered Psydonic cross representing the order of Primo Reformatio, crossed by a black \
	stripe that symbolizes mourning. Mammukhus sum, qui castellum onere fero. Numquam genua flecto aut gradum amitto."
	icon_state = "reformistbanner"

/obj/item/rogueweapon/spear/blacksteel
	name = "blacksteel spear"
	desc = "A magnificent winged spear of blacksteel; 'nuff said."
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	icon_state = "blacksteelspear"
	force_wielded = 35
	wdefense = 6
	max_blade_int = 400
	smeltresult = /obj/item/ingot/blacksteel

// Fishing Spears & Tridents. Yarr!
/obj/item/rogueweapon/fishspear
	name = "fishing spear"
	desc = "This two-pronged and barbed spear was made to catch those pesky fish."
	icon_state = "fishspear"
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	force = 20
	possible_item_intents = list(SPEAR_THRUST, SPEAR_BASH, SPEAR_CAST)
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 8
	max_blade_int = 200
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/steel
	associated_skill = /datum/skill/combat/polearms
	walking_stick = TRUE
	wdefense = 4
	thrown_bclass = BCLASS_STAB
	throwforce = 35
	resistance_flags = FLAMMABLE

/obj/item/rogueweapon/fishspear/depthseek //DO NOT ADD RECIPE. MEANT TO BE AN ABYSSORITE RELIC. IDEA COURTESY OF LORDINQPLAS
	name = "blessed depthseeker"
	desc = "A beautifully crafted weapon, with handle carved of some beast's bone, inlaid with smooth seaglass at pommel and head, with \
	two prongs smithed of fine dwarven steel. The seaglass carving at the head is a masterwork in and of itself, you can feel an abyssal \
	energy radiating off it."
	icon_state = "depthseek"
	force = 45
	smeltresult = /obj/item/ingot/blacksteel
	max_blade_int = 2600
	wdefense = 8
	throwforce = 50

/obj/item/rogueweapon/fishspear/attack_self(mob/user)
	if(user.used_intent.type == SPEAR_CAST)
		if(user.doing)
			user.doing = 0

/obj/item/rogueweapon/fishspear/afterattack(obj/target, mob/user, proximity)
	var/sl = user.get_skill_level(/datum/skill/labor/fishing) // User's skill level
	var/ft = 160 //Time to get a catch, in ticks
	var/fpp =	90 - (sl * 15) // Fishing power penalty based on fishing skill level
	if(istype(target, /turf/open/water))
		var/turf/water = target
		if(user.used_intent.type == SPEAR_CAST && !user.doing)
			if(target in range(user,3))
				user.visible_message("<span class='warning'>[user] searches for a fish!</span>", \
									"<span class='notice'>I begin looking for a fish to spear.</span>")
				playsound(src.loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
				ft -= (sl * 20) //every skill lvl is -2 seconds
				ft = max(20,ft) //min of 2 seconds
				if(do_after(user,ft, target = target))
					var/fishchance = 100 // Total fishing chance, deductions applied below
					if(user.mind)
						if(!sl) // If we have zero fishing skill...
							fishchance -= 50 // 50% chance to fish base
						else
							fishchance -= fpp // Deduct a penalty the lower our fishing level is (-0 at legendary)
					var/mob/living/fisherman = user
					var/datum/fish_source/source = water.get_fish_source()
					var/A = FISHING_DUD
					if(source && prob(fishchance)) // Finally, roll the dice to see if we fish.
						A = source.roll_simple_reward(water)
					if(A != FISHING_DUD)
						var/ow = 30 + (sl * 10) // Opportunity window, in ticks. Longer means you get more time to cancel your bait
						to_chat(user, "<span class='notice'>You see something!</span>")
						playsound(src.loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
						if(!do_after(user,ow, target = target))
							if(ispath(A, /mob/living))
								source.simple_dispense_reward(A, water, water)
								if(!ispath(A, /mob/living/simple_animal/hostile/retaliate/rogue/mudcrab))
									user.playsound_local(src, pick('sound/misc/jumpscare (1).ogg','sound/misc/jumpscare (2).ogg','sound/misc/jumpscare (3).ogg','sound/misc/jumpscare (4).ogg'), 100)
								user.mind.add_sleep_experience(/datum/skill/labor/fishing, fisherman.STAINT*2) // High risk high reward
							else
								source.simple_dispense_reward(A, user.loc, water)
								teleport_to_dream(user, 10000, 1)
								to_chat(user, "<span class='warning'>Pull 'em in!</span>")
								user.mind.add_sleep_experience(/datum/skill/labor/fishing, round(fisherman.STAINT, 2), FALSE) // Level up!
								record_featured_stat(FEATURED_STATS_FISHERS, fisherman)
								record_round_statistic(STATS_FISH_CAUGHT)
								playsound(src.loc, 'sound/items/Fish_out.ogg', 100, TRUE)
						else
							to_chat(user, "<span class='warning'>Damn, it got away... I should <b>pull away</b> next time.</span>")
					else
						to_chat(user, "<span class='warning'>Not a single fish...</span>")
						user.mind.add_sleep_experience(/datum/skill/labor/fishing, fisherman.STAINT/2) // Pity XP.
				else
					to_chat(user, "<span class='warning'>I must stand still to fish.</span>")
			update_icon()

/obj/item/rogueweapon/fishspear/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list(
					"shrink" = 0.6,
					"sx" = -6,
					"sy" = 7,
					"nx" = 6,
					"ny" = 8,
					"wx" = 0,
					"wy" = 6,
					"ex" = -1,
					"ey" = 8,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = -50,
					"sturn" = 40,
					"wturn" = 50,
					"eturn" = -50,
					"nflip" = 0,
					"sflip" = 8,
					"wflip" = 8,
					"eflip" = 0,
					)
			if("wielded")
				return list(
					"shrink" = 0.6,
					"sx" = 3,
					"sy" = 1,
					"nx" = -3,
					"ny" = 1,
					"wx" = -9,
					"wy" = 1,
					"ex" = 9,
					"ey" = 1,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = -30,
					"sturn" = 30,
					"wturn" = -30,
					"eturn" = 30,
					"nflip" = 8,
					"sflip" = 0,
					"wflip" = 8,
					"eflip" = 0,
					)

/obj/item/rogueweapon/spear/trident
	name = "bronze trident" 	// Better one handed & throwing weapon, flimsier.
	desc = "A bronze trident from the seas designed to pierce fish upon its hooked teeth. Feels balanced in your hand, like you could throw it quite easily."
	icon_state = "bronzetri"
	force = 25
	wdefense = 4
	max_blade_int = 175
	max_integrity = 225
	throwforce = 30
	possible_item_intents = list(SPEAR_THRUST, SPEAR_BASH, SPEAR_CAST)
	gripped_intents = null
	smeltresult = /obj/item/ingot/bronze

/obj/item/rogueweapon/spear/trident/afterattack(obj/target, mob/user, proximity)
	var/sl = user.get_skill_level(/datum/skill/labor/fishing)
	var/ft = 150
	var/fpp =	90 - (sl * 15)
	if(istype(target, /turf/open/water))
		var/turf/water = target
		if(user.used_intent.type == SPEAR_CAST && !user.doing)
			if(target in range(user,3))
				user.visible_message("<span class='warning'>[user] searches for a fish!</span>", \
									"<span class='notice'>I begin looking for a fish to spear.</span>")
				playsound(src.loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
				ft -= (sl * 20)
				ft = max(20,ft)
				if(do_after(user,ft, target = target))
					var/fishchance = 100
					if(user.mind)
						if(!sl)
							fishchance -= 50
						else
							fishchance -= fpp
					var/mob/living/fisherman = user
					var/datum/fish_source/source = water.get_fish_source()
					var/A = FISHING_DUD
					if(source && prob(fishchance))
						A = source.roll_simple_reward(water)
					if(A != FISHING_DUD)
						var/ow = 30 + (sl * 10)
						to_chat(user, "<span class='notice'>You see something!</span>")
						playsound(src.loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
						if(!do_after(user,ow, target = target))
							if(ispath(A, /mob/living))
								if(source.spend_reward_count(A))
									new /obj/effect/temp_visual/hunting_phantom(target, A, /datum/component/rot/simple/hunt, 2 SECONDS)
								user.mind.add_sleep_experience(/datum/skill/labor/fishing, fisherman.STAINT*2)
							else
								source.simple_dispense_reward(A, user.loc, water)
								teleport_to_dream(user, 10000, 1)
								to_chat(user, "<span class='warning'>Pull 'em in!</span>")
								user.mind.add_sleep_experience(/datum/skill/labor/fishing, round(fisherman.STAINT, 2), FALSE)
								record_featured_stat(FEATURED_STATS_FISHERS, fisherman)
								GLOB.azure_round_stats[STATS_FISH_CAUGHT]++
								playsound(src.loc, 'sound/items/Fish_out.ogg', 100, TRUE)
						else
							to_chat(user, "<span class='warning'>Damn, it got away... I should <b>pull away</b> next time.</span>")
					else
						to_chat(user, "<span class='warning'>Not a single fish...</span>")
						user.mind.add_sleep_experience(/datum/skill/labor/fishing, fisherman.STAINT/2)
				else
					to_chat(user, "<span class='warning'>I must stand still to fish.</span>")
			update_icon()

// Billhooks. For hooking bills.
/obj/item/rogueweapon/spear/billhook
	name = "billhook"
	desc = "A neat hook. Used to pull riders from horses, as well as defend against said horses when used in a proper formation. The \
	reinforcements along its shaft grant it higher durability against attacks."
	gripped_intents = list(SPEAR_THRUST, SPEAR_CUT, SPEAR_BASH, /datum/intent/spear/dismount)
	icon_state = "billhook"
	smeltresult = /obj/item/ingot/steel
	max_blade_int = 230
	minstr = 8
	wdefense = 4.5
	throwforce = 15

/obj/item/rogueweapon/spear/billhook/avantyne
	name = "avantyne-threaded billhook"
	desc = "A twisted implement of harvest, its hooked edge festering with crystalline malice. It is a weapon of pure upheaval, designed \
	to drag Psydonia's false idols into the dirt."
	icon_state = "zizobillhook"
	force = 30
	force_wielded = 35
	max_blade_int = 300
	max_integrity = 400
	equip_delay_self = 0
	unequip_delay_self = 0
	slot_flags = ITEM_SLOT_BACK
	smeltresult = /obj/item/ingot/avantyne

/obj/item/rogueweapon/spear/billhook/avantyne/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_ZIZO_AVANTYNE)

/obj/item/rogueweapon/spear/improvisedbillhook
	name = "improvised billhook"
	desc = "Looks hastily made, even a little flimsy."
	force = 12
	force_wielded = 25
	gripped_intents = list(SPEAR_THRUST, SPEAR_CUT, SPEAR_BASH, /datum/intent/spear/dismount)
	icon_state = "billhook"
	smeltresult = /obj/item/ingot/iron
	max_blade_int = 100
	wdefense = 4
	throwforce = 10

// Halberds & Glaives.
/obj/item/rogueweapon/halberd
	name = "halberd"
	desc = "A steel halberd, the pinnacle of all cumulative melee weapon knowledge. The only downside is the cost, so it's rarely \
	seen outside of the guardsmans' hands. The reinforcements along the shaft provide greater durability."
	icon_state = "halberd"
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	force = 15
	force_wielded = 30
	possible_item_intents = list(SPEAR_THRUST_1H, SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(SPEAR_THRUST, SPEAR_CUT, /datum/intent/axe/chop/halberd, SPEAR_BASH)
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	wbalance = WBALANCE_HEAVY
	minstr = 9
	max_blade_int = 280
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/steel
	associated_skill = /datum/skill/combat/polearms
	walking_stick = TRUE
	wdefense = 4
	special = /datum/special_intent/polearm_backstep

/obj/item/rogueweapon/halberd/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 3,"sy" = -3,"nx" = -5,"ny" = -3,"wx" = -5,"wy" = -3,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/halberd/silver
	name = "silver halberd"
	desc = "A resplendent polearm with a forked eagle's beak, a maillebreaker's point, and an axhead with a silvered edge. While traditionally \
	reserved for ceremonial affairs, the ever-creeping threat of undeath has seen these halberds being used for war once more."
	icon_state = "silverhalberd"
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/halberd/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE\
	)

/obj/item/rogueweapon/halberd/silver/psy
	name = "psydonic halberd"
	desc = "A blessed polearm that has guarded the walls of kingdoms-a-plenty, ever since the first castles of mortar-and-stone arose in Syon's wake. It \
	not only professes the elegance of its knightly wielder, but also their vow to keep the innocent guarded from the guilty."
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/halberd/silver/psy/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN\
	)

/obj/item/rogueweapon/halberd/silver/psy/preblessed/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN\
	)

/obj/item/rogueweapon/halberd/silver/psy/relic
	name = "\"Stigmata\""
	desc = "Christened in the Siege of Lirvas, these silver-tipped poleaxes - wielded by a lonesome contingent of Saint Eora's \
	paladins - kept the horrors at bay for forty daes-and-nites. Long-since-recovered from the rubble, this relic now serve as \
	a bulwark for the defenseless."
	icon_state = "psyhalberd"
	force = 25
	wdefense = 7
	max_integrity = 350
	max_blade_int = 380

/obj/item/rogueweapon/halberd/silver/psy/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN\
	)

/obj/item/rogueweapon/halberd/blacksteel
	name = "blacksteel halberd"
	desc = "A magnificent halberd of blacksteel. It is the finest arm-of-war that a sixteenth-century knight could ask for, especially \
	when it comes to attracting fair maidens in the highest courts. Wrap a length of cloth around the shaft to bear your heraldry."
	icon_state = "bs_halberd"
	smeltresult = /obj/item/ingot/blacksteel
	force = 20
	force_wielded = 35
	max_blade_int = 400
	wdefense = 5
	special_picks = list(
		/datum/special_intent/polearm_backstep,
		/datum/special_intent/quarterstaff_sweep,
		/datum/special_intent/axe_swing,
		/datum/special_intent/wave_swing/vicious,
		)

/obj/item/rogueweapon/halberd/blacksteel/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/cloth) && !detail_tag)
		var/choice = input(user, "Choose a color.", "Banner") as anything in COLOR_MAP
		user.visible_message(span_warning("[user] adds a banner to [src]."))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		detail_color = COLOR_MAP[choice]
		detail_tag = "_detail"
		update_icon()

/obj/item/rogueweapon/halberd/blacksteel/update_icon()
	refresh_detail_overlay()

/obj/item/rogueweapon/halberd/blacksteel/attack_self(mob/living/user)
	. = ..()
	update_icon()

/obj/item/rogueweapon/halberd/glaive
	name = "glaive"
	desc = "A curved blade on a pole, specialised in defence, but expensive to manufacture."
	icon_state = "glaive"
	possible_item_intents = list(/datum/intent/spear/thrust/oneh, SPEAR_BASH)
	gripped_intents = list(/datum/intent/spear/cut/glaive, /datum/intent/spear/cut/glaive/sweep, /datum/intent/spear/thrust, SPEAR_BASH)
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/steel
	max_blade_int = 200
	wdefense = 4.5

/obj/item/rogueweapon/halberd/glaive/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/halberd/glaive/elvish
	name = "elvish glaive"
	desc = "An elven weapon that combines the elegant sweeping blade typical of Elven design with a lengthy handle. The true \
	guardian of the forest realm."
	icon_state = "elfglaive"
	max_blade_int = 230 //Elven design makes it sharper
	sellprice = 60

/obj/item/rogueweapon/halberd/glaive/elvish/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 4,"sy" = -2,"nx" = -3,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/obj/item/rogueweapon/halberd/glaive/knightcaptain
	name = "\"Deliverance\"" /// Ported from Scarlet Reach's Glaive. We're avoiding force increase because I hate roguepen. It can have better blade integrity and defense instead.
	desc = "A masterwork glaive with a seasoned ashwood shaft reinforced by brass-sheathed steel bands. The blacksteel blade \
	bears inscriptions on both side. One reads, \"QUIS CUSTODIET\" while the other reads, \"IPSOS CUSTODES\"."
	icon = 'icons/roguetown/weapons/special/captainglaive.dmi'
	icon_state = "capglaive"
	smeltresult = /obj/item/ingot/blacksteel
	max_integrity = 300 //blacksteel, so its gotta be more durable
	max_blade_int = 250
	sellprice = 250

/obj/item/rogueweapon/halberd/pestran
	name = "\"Lance of Boils\""
	desc = "For when a scalpel is too short, and you still need to perform Pestra's holy work."
	icon_state = "pestranhalberd"

/obj/item/rogueweapon/halberd/bone
	name = "bone halberd"
	desc = "What an elegantly morbid statement."
	icon_state = "bonehalberd"
	smeltresult = null

/obj/item/rogueweapon/halberd/ji
	name = "ji"
	desc = "A Lingyuese dagger-axe. A spearhead crowns the shaft, while a crescent side-blade hooks outwards - equally suited to thrusting, hooking a mounted foe out of his saddle, or shearing through a footman's guard."
	icon_state = "ji"
	gripped_intents = list(SPEAR_THRUST, SPEAR_CUT, /datum/intent/axe/chop/halberd, /datum/intent/spear/dismount)

/obj/item/rogueweapon/halberd/ji/iron
	name = "iron ji"
	desc = "A Lingyuese dagger-axe wrought in iron, lacking the steel reinforcement of finer makes. Still serviceable in the hands of a drilled levyman."
	icon_state = "iji"
	smeltresult = /obj/item/ingot/iron
	max_integrity = 200

// Bardiches.
/obj/item/rogueweapon/halberd/bardiche
	name = "bardiche"
	desc = "A beautiful variant of the halberd. Its reinforced shaft provides it with greater durability against attacks."
	icon_state = "sbardiche"
	possible_item_intents = list(/datum/intent/spear/thrust/polearm, SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(/datum/intent/spear/cut, /datum/intent/spear/cut/bardiche/cleave, /datum/intent/spear/cut/glaive/sweep, SPEAR_BASH)
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/steel //this is a steel weapon.
	max_blade_int = 300
	wdefense = 5
	wbalance = WBALANCE_HEAVY

/obj/item/rogueweapon/halberd/bardiche/iron
	name = "iron bardiche"
	desc = "The poleaxe's predecessor, fitted with a wide iron blade. In the hands of a trained watchman, it can levy the odds of a triumph against multiple assailants."
	icon_state = "bardiche"
	smeltresult = /obj/item/ingot/iron
	max_integrity = 200

/obj/item/rogueweapon/halberd/bardiche/aalloy
	name = "decrepit bardiche"
	desc = "An imposing poleaxe, wrought from rotted metal. Whatever noble purpose this weapon held has long since decayed; for \
	it now persists to sunder the chaff that clings to this dying world."
	max_integrity = 180
	force = 12
	force_wielded = 22
	icon_state = "ancient_bardiche"
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null

/obj/item/rogueweapon/halberd/bardiche/paalloy
	name = "ancient bardiche"
	desc = "A terrifying poleaxe, forged from polished gilbranze. When Her ascension came, these weapons - bereft of their \
	wielders - sunk deep into the earth. Shadowed hands cradled the blades over the centuries, and would eventually create \
	its steel-tipped successor; the glaive."
	icon_state = "ancient_bardiche"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/halberd/bardiche/scythe
	name = "summer scythe"
	desc = "Summer's verdancy runs through the head of this scythe. All the more to sow."
	icon_state = "dendorscythe"
	gripped_intents = list(/datum/intent/spear/cut/bardiche, /datum/intent/spear/cut/bardiche/cleave, /datum/intent/spear/cut/glaive/sweep, /datum/intent/axe/chop/scythe)
	force_wielded = 33 // +3
	max_integrity = 300 // +50

// Polehammers.
/obj/item/rogueweapon/eaglebeak
	name = "eagle's beak"
	desc = "A reinforced pole affixed with an ornate steel eagle's head, of which its beak is intended to pierce with great harm."
	icon_state = "eaglebeak"
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	force = 15
	force_wielded = 30
	possible_item_intents = list(/datum/intent/spear/bash/polehammer, /datum/intent/mace/smash/eaglebeak)
	gripped_intents = list(/datum/intent/spear/bash/polehammer, /datum/intent/mace/smash/eaglebeak, /datum/intent/spear/thrust/polearm)
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 11
	smeltresult = /obj/item/ingot/steel
	associated_skill = /datum/skill/combat/polearms
	sharpness = IS_BLUNT
	walking_stick = TRUE
	wdefense = 4
	wbalance = WBALANCE_HEAVY
	max_integrity = 250 //So there is actual difference between the two

/obj/item/rogueweapon/eaglebeak/lucerne
	name = "lucerne"
	desc = "A polehammer of simple iron. Fracture bone and dissent with simple brute force. The studding along its shaft \
	makes for a slightly more reinforced weapon."
	force = 12
	force_wielded = 25
	icon_state = "polehammer"
	smeltresult = /obj/item/ingot/iron
	max_integrity = 200

/obj/item/rogueweapon/eaglebeak/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/obj/item/rogueweapon/eaglebeak/blacksteel
	name = "blacksteel polehammer"
	desc = "A magnificent polehammer of blacksteel. Purpose-made for killing plate-armored opponents, it features a maillebreaker's point and a \
	flared macehead; excellent for piercing and shattering alloys, respectively. Wrap a length of cloth around the shaft to bear your heraldry."
	possible_item_intents = list(/datum/intent/spear/bash/polehammer, /datum/intent/mace/smash/eaglebeak, /datum/intent/spear/thrust/polearm)
	gripped_intents = list(/datum/intent/spear/bash/polehammer, /datum/intent/mace/smash/eaglebeak, /datum/intent/spear/thrust)
	icon_state = "bs_eaglebeak"
	smeltresult = /obj/item/ingot/blacksteel
	force = 20
	force_wielded = 35
	wdefense_wbonus = 4 //+1 over the eagle beak, once wielded.
	max_integrity = 350 //Basic idea - blacksteel blunt weapons get more integrity, blacksteel edged weapons get more sharpness. Minimal overlap?
	special_picks = list(
		/datum/special_intent/polearm_backstep,
		/datum/special_intent/flail_sweep,
		/datum/special_intent/quarterstaff_sweep,
		/datum/special_intent/ground_smash
		)

/obj/item/rogueweapon/eaglebeak/blacksteel/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/cloth) && !detail_tag)
		var/choice = input(user, "Choose a color.", "Banner") as anything in COLOR_MAP
		user.visible_message(span_warning("[user] adds a banner to [src]."))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		detail_color = COLOR_MAP[choice]
		detail_tag = "_detail"
		update_icon()

/obj/item/rogueweapon/eaglebeak/blacksteel/update_icon()
	refresh_detail_overlay()

/obj/item/rogueweapon/eaglebeak/blacksteel/attack_self(mob/living/user)
	. = ..()
	update_icon()

// Lances. Tally ho!
/obj/item/rogueweapon/spear/lance
	name = "lance"
	desc = "A long polearm designed to be used from horseback, couched under the arm. It has a vambrace to prevent the arm sliding up \
	the shaft on impact."
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	icon_state = "lance"
	force = 15 // Its gonna sucks for 1 handed use
	force_wielded = 20 // Lower damage because a 3 tiles thrust without full charge time still deal base damage.
	wdefense = 4 // 2 Lower than spear
	max_integrity = 200
	max_blade_int = 200 // Better sharpness
	possible_item_intents = list(/datum/intent/spear/thrust, /datum/intent/lance/onehand, SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(/datum/intent/spear/thrust/lance, /datum/intent/lance, SPEAR_BASH)
	resistance_flags = null
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/spear/lance/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/cloth) && !detail_tag)
		var/choice = input(user, "Choose a color.", "Banner") as anything in COLOR_MAP
		user.visible_message(span_warning("[user] adds a banner to [src]."))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		detail_color = COLOR_MAP[choice]
		detail_tag = "_detail"
		update_icon()

/obj/item/rogueweapon/spear/lance/update_icon()
	refresh_detail_overlay()

/obj/item/rogueweapon/spear/lance/attack_self(mob/living/user)
	. = ..()
	update_icon()

/obj/item/rogueweapon/spear/lance/blacksteel
	name = "blacksteel lance"
	desc = "A magnificent lance of blacksteel, designed to be wielded on saigaback in jousting tournaments. Even so, it isn't uncommon to see it \
	being handled on foot as a pike by Grenzelhoft's blacksteel-armored knights. Wrap a length of cloth around the shaft to bear your heraldry."
	icon_state = "bs_lance"
	force = 20
	force_wielded = 25
	wdefense_wbonus = 4 //8 defense wielded
	max_integrity = 300
	max_blade_int = 300
	resistance_flags = FIRE_PROOF
	smeltresult = /obj/item/ingot/blacksteel
	possible_item_intents = list(/datum/intent/spear/thrust, /datum/intent/lance/onehand, SPEAR_BASH)
	gripped_intents = list(/datum/intent/spear/thrust/lance, /datum/intent/lance, SPEAR_BASH)

// Unique Spears.
/obj/item/rogueweapon/spear/partizan/baotha
	name = "saccharine swordspear"
	desc = "Keep her at arm's length, lest you're burdened with the pain of her earnestness and her joy. That would be a final, unbearable cut."
	force = 25
	force_wielded = 35
	possible_item_intents = list(/datum/intent/sword/thrust/long, /datum/intent/sword/cut/long, /datum/intent/sword/strike, /datum/intent/sword/thrust/heavy)
	gripped_intents = list(SPEAR_THRUST, /datum/intent/spear/cut, PARTIZAN_REND, /datum/intent/spear/cut/glaive/sweep)
	icon_state = "swordstaff"
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	parrysound = list(
	'sound/combat/parry/bladed/bladedmedium (1).ogg',
	'sound/combat/parry/bladed/bladedmedium (2).ogg',
	'sound/combat/parry/bladed/bladedmedium (3).ogg',
	)
	pickup_sound = 'sound/foley/equip/swordlarge1.ogg'
	minstr = 4
	thrown_bclass = BCLASS_PIERCE
	max_blade_int = 400
	max_integrity = 400
	throwforce = 45 //Pierce the heavens!
	wdefense = 4
	wdefense_wbonus = 5
	smeltresult = /obj/item/ingot/component/baotha
	slot_flags = ITEM_SLOT_BACK //No need for a supplemental greatweapon strap.
	equip_delay_self = 2 SECONDS
	unequip_delay_self = 2 SECONDS
	inv_storage_delay = 1 SECONDS
	icon_angle_wielded = null

/obj/item/rogueweapon/spear/partizan/baotha/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "SWORDSPEAR")

/obj/item/rogueweapon/spear/partizan/baotha/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list("shrink" = 0.7, "sx" = -14, "sy" = -8, "nx" = 9, "ny" = -6, "wx" = -6, "wy" = -6, "ex" = -1, "ey" = -4, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = -10, "sturn" = 108, "wturn" = -72, "eturn" = -10, "nflip" = 1, "sflip" = 1, "wflip" = 8, "eflip" = 1)
			if("wielded") return list("shrink" = 0.75, "sx" = 5, "sy" = -3, "nx" = -5, "ny" = -3, "wx" = -5, "wy" = -3, "ex" = 3, "ey" = -4, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = 6, "sturn" = -8, "wturn" = 10, "eturn"= -10, "nflip" = 8, "sflip" = 0, "wflip" = 8, "eflip" = 0)

/obj/item/rogueweapon/spear/partizan/baotha/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_BAOTHA_WEAPON)

